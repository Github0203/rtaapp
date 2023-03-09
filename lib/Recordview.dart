// main.dart
import 'package:example/Database.dart';
import 'package:example/cubit/state.dart';
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
  // var getinstanceID = 'hihi';
  // var getinstanceIDNew = 'hihiNew';
  // var data;
  // var namenewFolder = '';


  // void _loadDataNew(String pathofNew) async {
  //    await File(pathofNew).readAsString().then((String contents) {
  //     data = '';
  //     setState(() {
  //       data = contents;
  //     });
  //     // print(data);
  //        final xml2 = xml.XmlDocument.parse(data);
  //     getinstanceIDNew = '';
  //    setState(() {
  //     getinstanceIDNew = xml2.getElement("All_in_One_GEN007")!.getElement("meta")!.getElement("instanceID")!.text.toString();
  //   });
  //    print('88888888888888888');
  // });
  //  }

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
    _grantPermission();
    super.initState();

  }
  
  
 late Future<List<SaveFileModel>> file;
  String? ten;
  String? vitri;
  DatabaseHandler dbHandler = DatabaseHandler();
  @override
  Widget build(BuildContext context) {
   FileAppCubit.get(context).listDir2(widget.getPath.toString());
    FileAppCubit.get(context).loadDataNew(widget.getPath.toString());

    return Builder(
      builder: (context) {
        return  BlocConsumer<FileAppCubit, FileAppState>(
          listener: (context, state) {
           
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
              appBar: AppBar(title: const Text('Danh sách đã Record')),
              body: Container(
                 height: MediaQuery.of(context).size.height*0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                  
                  
                      SizedBox(height: 30,),
                      Container(
                        height: MediaQuery.of(context).size.height*0.7,
                        child: ListView.builder(  //if file/folder list is grabbed, then show here
                            itemCount: FileAppCubit.get(context).filesList2.length,
                            itemBuilder: (BuildContext context, index) {
                                  return Column(
                                    children: [
                                      Card(
                                        child:ListTile(
                                           title: Text(FileAppCubit.get(context).filesList2[index]),
                                           trailing: IconButton(
                                            icon: Icon(Icons.view_list_outlined),
                                            onPressed: () async{
                                                FileAppCubit.get(context).loadDataNew(FileAppCubit.get(context).filesList2[index].toString());
                                               
                                               SaveFileModel file = SaveFileModel.empty();
                                                file.name = FileAppCubit.get(context).getinstanceIDNew.toString();
                                                file.vitri = (index).toString();
                                                
                                                // await dbHandler.initializedDB();
                  
                                                await dbHandler.updateFile(file);
                                                // initState();
                                                setState(() {});
                                                print('DA CAP NHAT');
                                                _showMaterialDialog(FileAppCubit.get(context).getinstanceIDNew.toString(), (index).toString());
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
            ),
          fallback: (context) => Center(child:Text('Vui lòng chọn FILE1')),
          );
     
      }
    );
      }
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
                    Text('Vị trí mới trong folder "office-data" là: ' + vitri + '\n' + '------'+ '\n' +  FileAppCubit.get(context).data),
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

