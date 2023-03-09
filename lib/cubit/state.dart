import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';



abstract class FileAppState {}

class FileAppInitalState extends FileAppState {}

class FileAppDisposeState extends FileAppState {}

class FileAppChooseLoadingState extends FileAppState {}

class FileAppChooseSuccessState extends FileAppState {}

class FileAppChooseErrorState extends FileAppState {}

class FileAppLoadFileLoadingState extends FileAppState {}

class FileAppLoadFileSuccessState extends FileAppState {}

class FileAppLoadFileErrorState extends FileAppState {}

class FileAppLoadFileRecordLoadingState extends FileAppState {}

class FileAppLoadFileRecordSuccessState extends FileAppState {}

class FileAppLoadFileRecordErrorState extends FileAppState {}

class FileAppImportLoadingState extends FileAppState {}

class FileAppImportSuccessState extends FileAppState {}

class FileAppImportErrorState extends FileAppState {}

class FileAppCopyLoadingState extends FileAppState {}

class FileAppCopySuccessState extends FileAppState {}

class FileAppCopyErrorState extends FileAppState {}

class FileAppViewListLoadingState extends FileAppState {}

class FileAppViewListSuccessState extends FileAppState {}

class FileAppViewListErrorState extends FileAppState {}

class FileAppViewDetailLoadingState extends FileAppState {}

class FileAppViewDetailSuccessState extends FileAppState {}

class FileAppViewDetailErrorState extends FileAppState {}

class FileAppFolderExitState extends FileAppState {}

class FileAppCreateFolderSusscesState extends FileAppState {}

class FileAppCreateFolderErrorState extends FileAppState {}