import 'dart:io';


import 'package:example/cubit/state.dart';
import 'package:example/fileModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:example/getfile.dart';


import 'package:example/Database.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
    providers: [
    BlocProvider( create: (BuildContext context)  => FileAppCubit()),
    ],
    child: MyApp(),
   ));
  // runApp(MyApp());
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
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  


  @override
  void initState() {
    super.initState();
  }
  
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 var scaffoldKey = GlobalKey<ScaffoldState>();
 @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        FileAppCubit.get(context).getListFile();

        return BlocConsumer<FileAppCubit, FileAppState>(
          listener: (context, state) {
             if(state is FileAppLoadFileSuccessState){
                showToast(state: ToastStates.SUCCESS, text: 'Load File thành công');
             }
          },
          builder: (context, state) {
            SaveFileModel? getfileModel = FileAppCubit.get(context).fileModel;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;

            return ConditionalBuilder(
              condition: FileAppCubit.get(context).posts1.isEmpty,
              builder: (context) => 
              WillPopScope(
          onWillPop: () async => false,
                child: Scaffold(
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
                  FileAppCubit.get(context).pickDirectory(context);
                  },
                ),
                Text('Liệt kê tất cả các tệp XML trong thư mục data'),
                SizedBox(height: 10,),
                
                          FileAppCubit.get(context).filesList == null 
                ? Center(child: CircularProgressIndicator()) :
                           Center(
                 child: Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  width: MediaQuery.of(context).size.width-20,
                  height: MediaQuery.of(context).size.height*0.7,
                  color: Color.fromARGB(96, 236, 207, 205),
                   child: 
                   
                  ListView.builder(  
                    key: _scaffoldKey,//if file/folder list is grabbed, then show here
                      itemCount: FileAppCubit.get(context).filesList.length,
                      itemBuilder: (BuildContext context, index) {
                            return Column(
                              children: [
                                Card(
                                  child:ListTile(
                                     title: Text(FileAppCubit.get(context).filesList[index]),
                                     trailing: IconButton(
                                      icon: Icon(Icons.add_to_queue),
                                      onPressed: () {
                                        
                                        FileAppCubit.get(context).khongtimthay == true ?
                                        FileAppCubit.get(context).showMaterialDialog(context) :
                                        //  SchedulerBinding.instance.addPostFrameCallback((_) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => GetFile(
                                            FileAppCubit.get(context).selectedDirectory.toString().substring(12,).replaceAll(RegExp("'"), '').trim(),
                                           FileAppCubit.get(context).filesList[index].toString(),)
                                            ),
                                        );
                                      // });
                              
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
                    ),
              ),
      fallback: (context) => Center(child:Text('Vui lòng chọn FILE1')),
            );
          },
        );
      }
     );
  }
  
  
}
