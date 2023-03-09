
import 'package:floor/floor.dart';
 
 @entity
class SaveFileModel {
  @primaryKey
  String? id;
  
  String? name;
  String? vitri;

  SaveFileModel.empty();

  SaveFileModel({this.id, required this.name, required this.vitri});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'vitri': vitri};

factory SaveFileModel.fromMap(Map<String, dynamic> map) {
  return SaveFileModel(id: map['id'], name: map['name'], vitri: map['vitri']);
}
 SaveFileModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    vitri = map['vitri'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['vitri'] = vitri;
    return data;
  }
  
}