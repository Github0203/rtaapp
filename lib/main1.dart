import 'dart:io';

import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:example/getfile.dart';


import 'package:example/Database.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
Future<void> main() async{
  // DartPluginRegistrant.ensureInitialized(),
  WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseHandler.initializedDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Folder Picker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Directory? selectedDirectory;
  var files;
  bool khongtimthay = false;

  Future<void> _pickDirectory(BuildContext context) async {
    Directory? directory = selectedDirectory;
    if (directory == null) {
      directory = Directory(FolderPicker.rootPath);
    }
    
    try{
    Directory? newDirectory = await FolderPicker.pick(
        allowFolderCreation: true,
        context: context,
        rootDirectory: directory,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)))
            );
     khongtimthay = false;
    setState(() {
      selectedDirectory = newDirectory;
                  listDir("${selectedDirectory!.path}");
      print(selectedDirectory.toString().substring(12,).replaceAll(RegExp("'"), '').trim());
    });
    }
    catch (e){
        setState(() {
          khongtimthay = true;
        });
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


  @override
  void initState() {
    super.initState();
  }
  
   void _showMaterialDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lỗi' ),
            content: Container(
              height: MediaQuery.of(context).size.height*0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Không tìm thấy Element uuId trong file'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Folder"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.file_open),
              onPressed: () {
                _pickDirectory(context);
               
              },
            ),
            Text('Liệt kê tất cả các tệp XML trong thư mục data'),
            SizedBox(height: 10,),
          filesList == null 
            ? Center(child: CircularProgressIndicator()) :
           Center(
             child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              width: MediaQuery.of(context).size.width-20,
              height: MediaQuery.of(context).size.height*0.8,
              color: Color.fromARGB(96, 236, 207, 205),
               child: ListView.builder(  //if file/folder list is grabbed, then show here
                  itemCount: filesList.length,
                  itemBuilder: (BuildContext context, index) {
                        return Column(
                          children: [
                            Card(
                              child:ListTile(
                                 title: Text(filesList[index]),
                                 trailing: IconButton(
                                  icon: Icon(Icons.add_to_queue),
                                  onPressed: () {
                                    khongtimthay == true ?
                                    _showMaterialDialog(context) :
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => GetFile(
                                        selectedDirectory.toString().substring(12,).replaceAll(RegExp("'"), '').trim(),
                                       filesList[index].toString(),)
                                        ),
                                    );
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
           ),
           SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
  
  
}
