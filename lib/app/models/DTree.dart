import 'package:intl/intl.dart';

class DTree {
  late int id;
  late String actionType;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late String? createdBy;
  late String? updatedBy;
  late String name;
  late int parentId;
  late int? sort;
  late int typeId;

  DTree({this.id = 0, this.name="Undefined"});

  DTree.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actionType = json['action_type'];
    createdAt = json['created_at'] != null
        ? DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(json['updated_at'])
        : null;
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    name = json['name'];
    parentId = json['parent_id'];
    sort = json['sort'];
    typeId = json['type_id'];
  }


}