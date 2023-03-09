// main.dart
import 'package:example/Database.dart';
import 'package:example/fileModel.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:io';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:flutter/foundation.dart';

import './cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/components.dart';
import 'package:bot_toast/bot_toast.dart';


class Recordview extends StatefulWidget {
  String? getPath;
  Recordview(this.getPath, );

  @override
  State<Recordview> createState() => _RecordviewState();
}

class _RecordviewState extends State<Recordview> {
  var getinstanceID = 'hihi';
  var getinstanceIDNew = 'hihiNew';
  var data;
  var namenewFolder = '';


  void _loadDataNew(String pathofNew) async {
     await File(pathofNew).readAsString().then((String contents) {
      data = '';
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
    _loadDataNew(widget.getPath.toString());
   listDir(widget.getPath.toString());
    _grantPermission();
    super.initState();

  }
  
  void _saveFile() async {

    //  final Directory _appDocDir = await getApplicationDocumentsDirectory();
  //App Document Directory + folder name
  final Directory _appDocDirFolder =
  Directory('${widget.getPath}/office-data/');



 
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
      appBar: AppBar(title: const Text('Danh sách đã Record')),
      body: Container(
         height: MediaQuery.of(context).size.height*0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [

            
            
              SizedBox(height: 30,),
              Container(
                height: MediaQuery.of(context).size.height*0.5,
                child: ListView.builder(  //if file/folder list is grabbed, then show here
                    itemCount: filesList.length,
                    itemBuilder: (BuildContext context, index) {
                          return Column(
                            children: [
                              Card(
                                child:ListTile(
                                   title: Text(filesList[index]),
                                   trailing: IconButton(
                                    icon: Icon(Icons.view_list_outlined),
                                    onPressed: () async{
                                        _loadDataNew(filesList[index].toString());
                                       
                                       SaveFileModel file = SaveFileModel.empty();
                                        file.name = getinstanceIDNew.toString();
                                        file.vitri = (index).toString();
                                        
                                        // await dbHandler.initializedDB();

                                        await dbHandler.updateFile(file);
                                        // initState();
                                        setState(() {});
                                        print('DA CAP NHAT');
                                        _showMaterialDialog(getinstanceIDNew.toString(), (index).toString());
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => Recordview(
                                      //     namenewFolder.toString().substring(12,).replaceAll(RegExp("'"), '').trim(),
                                      //    filesList[index].toString(),)
                                      //     ),
                                      // );
                                    },
                                  ),
                                )
                              ),
                              SizedBox(height: 10,),
                            ],
                          );
                    },
                 ),
              ),


            ],
          ),
        ),
      ),
    );
  }


  void _showMaterialDialog(String name, String vitri) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Tên uuid tương ứng là ' + name),
            content: Container(
              height: MediaQuery.of(context).size.height*0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Vị trí mới trong folder "office-data" là: ' + vitri + '\n' + '------'+ '\n' +  data),
                  ],
                ))),
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

