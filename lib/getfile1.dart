// main.dart
import 'package:example/Database.dart';
import 'package:example/fileModel.dart';
import 'package:example/Recordview.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:flutter/foundation.dart';

class GetFile extends StatefulWidget {
  String? getPath;
  String? getfileName;
  GetFile(this.getPath, this.getfileName);

  @override
  State<GetFile> createState() => _GetFileState();
}

class _GetFileState extends State<GetFile> {
  var getinstanceID = '';
  var getinstanceIDNew = '';
  var data;
  var namenewFolder = '';

  void _loadData1() async {
     print(widget.getfileName!.toString());
     await File(widget.getfileName!.toString()).readAsString().then((String contents) {
      setState(() {
        data = contents;
      });
      // print(data);
         final xml2 = xml.XmlDocument.parse(data);
     setState(() {
      getinstanceID = xml2.getElement("All_in_One_GEN007")!.getElement("meta")!.getElement("instanceID")!.text.toString();
    });
     print('55555555555555555555555');
  });
   }

  void _loadDataNew(String pathofNew) async {
     await File(pathofNew).readAsString().then((String contents) {
      setState(() {
        data = contents;
      });
      // print(data);
         final xml2 = xml.XmlDocument.parse(data);
      getinstanceIDNew = '';
     setState(() {
      getinstanceIDNew = xml2.getElement("All_in_One_GEN007")!.getElement("meta")!.getElement("instanceID")!.text.toString();
    });
     print('88888888888888888');
  });
   }

  void _grantPermission () async {
    var status = await Permission.storage.status;
    if (status.isGranted) {

    } else {
      await Permission.storage.request();
      status = await Permission.storage.status;
      print(status);
    }
 }
  @override
  void initState() {
    // DatabaseHandler;
    _loadData1();
    // _loadData();
    _grantPermission();
    super.initState();

  }
  
  void _saveFile() async {

    //  final Directory _appDocDir = await getApplicationDocumentsDirectory();
  //App Document Directory + folder name
  final Directory _appDocDirFolder =
  Directory('${widget.getPath}/office-data/');



  if (await _appDocDirFolder.existsSync()) {
    //if folder already exists return path
    print('thu muc da ton tai roi ' + _appDocDirFolder.path);
     var file = File(widget.getPath.toString() + '/' + (widget.getfileName!.split('/').last.toString()));
    file.copy(_appDocDirFolder.path.toString() + '/' + (widget.getfileName!.split('/').last.toString()));
   
   setState(() {
      namenewFolder = _appDocDirFolder.path.toString();
    });
    
  } else {
    //if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder =
    await _appDocDirFolder.create(recursive: true);
    setState(() {
      namenewFolder = _appDocDirNewFolder.path.toString();
    }); 
    print(namenewFolder); 
    print('da tao thu muc moi');
    print(widget.getPath.toString());
    print(_appDocDirNewFolder.toString());
      var file = File(widget.getPath.toString() + '/' + (widget.getfileName!.split('/').last.toString()));
    file.copy(namenewFolder  + (widget.getfileName!.split('/').last.toString()));
  }
  }


   List<dynamic> filesList = [];
 void listDir(String path) async {
Directory dir =  Directory(
    // '/storage/emulated/0/rta/data');
    path);

await for (FileSystemEntity entity
    in dir.list(recursive: true, followLinks: false)) {
  FileSystemEntityType type = await FileSystemEntity.type(entity.path);
  if (type == FileSystemEntityType.file &&
      entity.path.endsWith('.xml')) {
   setState(() {
      filesList.add(entity.path);
   });
  }
}
// return filesList;
}


  
 late Future<List<SaveFileModel>> file;
  String? ten;
  String? vitri;
  DatabaseHandler dbHandler = DatabaseHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File đã chọn để IMPORT')),
      body: Container(
         height: MediaQuery.of(context).size.height*0.5,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('File đã IMPORT'),
                ),
                SizedBox(height: 20,),
                Text('UUID là: ' + getinstanceID.toString()),
                SizedBox(height: 20,),
                TextButton(
                    style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: BorderSide(
            color: Colors.blue,
            width: 1,
            style: BorderStyle.solid
          ),
                borderRadius: BorderRadius.circular(30.0))),
            ),
                  onPressed: 
                () async{
                  _saveFile();
                  SaveFileModel file = SaveFileModel.empty();
                    file.name = getinstanceID.toString();
                    file.vitri = '';
                    


                    await dbHandler.insertFile(file);
                    // initState();
                    setState(() {});
                    print('ĐÃ LƯU');
                    showMaterialDialogCopy(context);
                      Timer.periodic(Duration(seconds: 6), (context) => 
  showMaterialDialogDone(context)
  );
                }, child: Text('Copy đến file "office-fata" ')),
          TextButton(
             style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: BorderSide(
            color: Color.fromARGB(255, 24, 201, 103),
            width: 1,
            style: BorderStyle.solid
          ),
                borderRadius: BorderRadius.circular(30.0))),
            ),
            onPressed: 
              () async{
                 Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  Recordview('${widget.getPath}/office-data/')
                                        ),
                                    );
               
              }, child: Text('Xem lại các file đã Import')),

          
              ],
            ),
          ),
        ),
      ),
    );
  }


void showMaterialDialogCopy(context) {
  Timer.periodic(Duration(seconds: 5), (_) => 
  Navigator.pop(context)
  );
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Copy FILE' ),
            content:
            Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10,),
                Text('Đang copy file.....'),
              ],
            ),
          );
        });
  }
void showMaterialDialogDone(context) {

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Copy FILE"' ),
            content:
            Text('Đã copy file'),

            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
            ],
          );
        });
  }

}

