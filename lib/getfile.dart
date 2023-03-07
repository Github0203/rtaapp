import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
//import package files


//apply this class on home: attribute at MaterialApp()
class getfile1 extends StatefulWidget{
  String? path;
  getfile1(this.path);
  @override
  State<StatefulWidget> createState() {
    return _getfile1();
  }
}

class _getfile1 extends State<getfile1>{
  var files;
 
  void getfile1s() async { //asyn function to get list of files
      List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
      var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
      var fm = FileManager(root: Directory(root)); //
      files = await fm.filesTree( 
      //set fm.dirsTree() for directory/folder tree list
        excludedPaths: ["/storage/emulated/0/Android/rta/data"],
        extensions: ["xml", "pdf"] //optional, to filter files, remove to list all,
        //remove this if your are grabbing folder list
      );
      setState(() {}); //update the UI
  }

  @override
  void initState() {
    getfile1s(); //call getfile1s() function on initial state. 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return files == null? Text("Searching Files"):
           ListView.builder(  //if file/folder list is grabbed, then show here
              itemCount: files?.length ?? 0,
              itemBuilder: (context, index) {
                    return Card(
                      child:ListTile(
                         title: Text(files[index].path.split('/').last),
                         leading: Icon(Icons.image),
                         trailing: Icon(Icons.delete, color: Colors.redAccent,),
                      )
                    );
              },
    );
  }
}