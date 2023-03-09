// main.dart
import 'package:example/Database.dart';
import 'package:example/cubit/state.dart';
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

import './cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/components.dart';
import 'package:bot_toast/bot_toast.dart';

class GetFile extends StatefulWidget {
  String getPath;
  String getfileName;
  GetFile(this.getPath, this.getfileName);

  @override
  State<GetFile> createState() => _GetFileState();
}

class _GetFileState extends State<GetFile> {
 
  



//   void _grantPermission () async {
//     var status = await Permission.storage.status;
//     if (status.isGranted) {

//     } else {
//       await Permission.storage.request();
//       status = await Permission.storage.status;
//       print(status);
//     }
//  }
//   @override
//   void initState() {
//     // DatabaseHandler;
//     // _loadData1();
//     // _loadData();
//     _grantPermission();
//     super.initState();

//   }
  
  


//    List<dynamic> filesList = [];
//  void listDir(String path) async {
// Directory dir =  Directory(
//     // '/storage/emulated/0/rta/data');
//     path);

// await for (FileSystemEntity entity
//     in dir.list(recursive: true, followLinks: false)) {
//   FileSystemEntityType type = await FileSystemEntity.type(entity.path);
//   if (type == FileSystemEntityType.file &&
//       entity.path.endsWith('.xml')) {
//    setStateê(() {
//       filesList.add(entity.path);
//    });
//   }
// }
// // return filesList;
// }


  
 
 late Future<List<SaveFileModel>> file;
  String? ten;
  String? vitri;
  DatabaseHandler dbHandler = DatabaseHandler();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        FileAppCubit.get(context).convertName(widget.getfileName);
         return BlocConsumer<FileAppCubit, FileAppState>(
          listener: (context, state) {
             if(state is FileAppLoadFileSuccessState){
                showToast(state: ToastStates.SUCCESS, text: 'Load File thành công');
             }
             if(state is FileAppImportSuccessState){
                showToast(state: ToastStates.SUCCESS, text: 'Import File thành công');
             }
             if (state is FileAppImportErrorState)
             {
              showToast(state: ToastStates.ERROR, text: 'Import File thất bại');
             }
             if(state is FileAppCopySuccessState){
                showToast(state: ToastStates.SUCCESS, text: 'Đã Copy File thành công');
             }
             if(state is FileAppCreateFolderSusscesState){
                showToast(state: ToastStates.SUCCESS, text: 'Đã Tạo Folder mới và coppy thành công');
             }
             if(state is FileAppDisposeState){
                dispose();
             }
          },
          builder: (context, state) {
            SaveFileModel? getfileModel = FileAppCubit.get(context).fileModel;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;
      return
      ConditionalBuilder(
        condition: FileAppCubit.get(context).posts1.isEmpty,
              builder: (context) => 
        Scaffold(
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
                    Text('UUID là: ' + FileAppCubit.get(context).fileName.toString()),
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
                      // FileAppCubit.get(context).listDir2('${widget.getPath}/office-data/'.toString());
                      FileAppCubit.get(context).saveFile(widget.getPath, widget.getfileName);
                      SaveFileModel file = SaveFileModel.empty();
                        file.name = FileAppCubit.get(context).getinstanceID.toString();
                        file.vitri = '';
                        
          
          
                        await dbHandler.insertFile(file);
                        // initState();
                        // setState(() {});
                        print('ĐÃ LƯU');
                        // FileAppCubit.get(context).showMaterialDialogCopy(context);
                         
                        
                    }, child: Text('Copy đến file "office-data" ')),
                    SizedBox(height: 30,),
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
        ),
        fallback: (context) => Center(child:Text('Vui lòng chọn FILE1')),
      );
      }
    );
      }
    );
  }



}

