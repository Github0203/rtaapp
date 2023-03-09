import 'dart:io';
import 'package:example/cubit/state.dart';
import 'package:example/fileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math';



import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:xml/xml.dart' as xml;



class FileAppCubit extends Cubit<FileAppState> {
  FileAppCubit() : super(FileAppInitalState());

  
 static FileAppCubit get(context) => BlocProvider.of(context);
 SaveFileModel? fileModel;
 
 List<SaveFileModel> posts1 = [];
 Directory? selectedDirectory;
 bool khongtimthay = false;
 var namenewFolder = '';
var getinstanceID = 'hihi';
var fileName = '';
var getinstanceIDNew;
var data;




//  void clear(){
//   fileModel = null;
//   khongtimthay = false;
//   namenewFolder = '';
//   getinstanceID = '';
//   getinstanceIDNew = '';
//   data = null;
//  }

 void pickDirectory(BuildContext context) async {
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
    //  khongtimthay = false;

     selectedDirectory = null; 
     selectedDirectory = newDirectory;
      listDir("${selectedDirectory!.path}");
      emit(FileAppChooseSuccessState());
    }
    catch (e){
        
          khongtimthay = true;
          emit(FileAppImportErrorState());
       
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
      
      // filesList = [];
      filesList.add(entity.path);
      emit(FileAppLoadFileSuccessState());
  }
}
}

   List<dynamic> filesList2 = [];
 void listDir2(String path) async {
      filesList2 = [];      

Directory dir =  Directory(
    // '/storage/emulated/0/rta/data');
    path);

await for (FileSystemEntity entity
    in dir.list(recursive: true, followLinks: false)) {
  FileSystemEntityType type = await FileSystemEntity.type(entity.path);
  if (type == FileSystemEntityType.file &&
      entity.path.endsWith('.xml')) {

      filesList2.add(entity.path);
      emit(FileAppLoadFileSuccessState());
      // filesList = [];
  }
}
}

  void getListFile() {
     if( filesList != null){
      emit(FileAppChooseSuccessState());
  }
  }

  void showMaterialDialog(context) {
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

  void showMaterialDialogCopy(context) {
 
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            child: AlertDialog(
              title: Text('Copy FILE' ),
              content:
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text('Đang copy file.....'),
                ],
              ),
            ),
          );
        });


  Timer.periodic(Duration(seconds: 4), (_) => 
  Navigator.of(context).pop(true)
  );


          Timer.periodic(Duration(seconds: 6), (_) => 
            emit(FileAppCopySuccessState())

  );
         

  emit(FileAppDisposeState());
          
  
  }

  void saveFile(String getPath, getfileName) async {

    //  final Directory _appDocDir = await getApplicationDocumentsDirectory();
  //App Document Directory + folder name
  final Directory _appDocDirFolder =
  Directory(getPath + '/office-data/');



  if (_appDocDirFolder.existsSync()) {
    //if folder already exists return path
    print('thu muc da ton tai roi ' + _appDocDirFolder.path);
     var file = File(getPath.toString() + '/' + (getfileName!.split('/').last.toString()));
    file.copy(_appDocDirFolder.path.toString() + '/' + (getfileName!.split('/').last.toString()));
   
   
      namenewFolder = _appDocDirFolder.path.toString();
      emit(FileAppFolderExitState());
      emit(FileAppCopySuccessState());
  } else {
    //if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder =
    await _appDocDirFolder.create(recursive: true);
    
      namenewFolder = _appDocDirNewFolder.path.toString();
      emit(FileAppCreateFolderSusscesState());
    
    print(namenewFolder); 
    print('da tao thu muc moi');
    print(getPath.toString());
    print(_appDocDirNewFolder.toString());
      var file = File(getPath.toString() + '/' + (getfileName!.split('/').last.toString()));
    file.copy(namenewFolder  + (getfileName!.split('/').last.toString()));
  }
  }



  void loadData1(var getfileName) {
    // print('đang load.... ');
    //  print(getfileName.toString());
     
     File(getfileName.toString()).readAsString().then((String contents) {
        data = '';
        data = contents;
      
      print(contents);
         var xml2 = xml.XmlDocument.parse(data);
     
      getinstanceID = '';
      getinstanceID = xml2.getElement("All_in_One_GEN007")!.getElement("meta")!.getElement("instanceID")!.text.toString();
      emit(FileAppImportSuccessState());
     print('55555555555555555555555');
    
  });
   }

   void convertName(var getfileName) {
    // print('đang load.... ');
    //  print(getfileName.toString());
     String nhan = getfileName;
     File(nhan.toString()).readAsString().then((String contents) {
        data = '';
        data = contents;
         var xml2 = xml.XmlDocument.parse(data);
     
      fileName = '';
      fileName = xml2.getElement("All_in_One_GEN007")!.getElement("meta")!.getElement("instanceID")!.text.toString();
      print(fileName);
      emit(FileAppImportSuccessState());
     print('55555555555555555555555');
    
  });
   }


     void loadDataNew(String pathofNew) async {
     await File(pathofNew).readAsString().then((String contents) {
      
        data = '';
        data = contents;
     
      // print(data);
         final xml2 = xml.XmlDocument.parse(data);

      getinstanceIDNew = '';     
      getinstanceIDNew = xml2.getElement("All_in_One_GEN007")!.getElement("meta")!.getElement("instanceID")!.text.toString();
    
     print('88888888888888888');
     emit(FileAppViewListSuccessState());
  });
   }

}
