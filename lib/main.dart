import 'dart:io';

import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:example/getfile.dart';

void main() {
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

  Future<void> _pickDirectory(BuildContext context) async {
    Directory? directory = selectedDirectory;
    if (directory == null) {
      directory = Directory(FolderPicker.rootPath);
    }

    Directory? newDirectory = await FolderPicker.pick(
        allowFolderCreation: true,
        context: context,
        rootDirectory: directory,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(10)))
            );
    setState(() {
      selectedDirectory = newDirectory;
                  listDir("${selectedDirectory!.path}");
      print(selectedDirectory.toString().substring(13,).replaceAll(RegExp("'"), '').trim());
    });
    //  setState(() {
    //               listDir("${selectedDirectory!.path}");
    //             });
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
    // getFiles(); //call getFiles() function on initial state. 
    // listDir();
    super.initState();
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
              width: MediaQuery.of(context).size.width-20,
              height: MediaQuery.of(context).size.height*0.5,
              color: Colors.red,
               child: ListView.builder(  //if file/folder list is grabbed, then show here
                  itemCount: filesList.length,
                  itemBuilder: (BuildContext context, index) {
                        return Column(
                          children: [
                            Card(
                              child:ListTile(
                                 title: Text(filesList[index]),
                              )
                            ),
                            SizedBox(height: 10,),
                          ],
                        );
                  },
               ),
             ),
           )
          ],
        ),
      ),
    );
  }
}
