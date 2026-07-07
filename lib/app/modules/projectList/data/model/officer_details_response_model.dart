import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';

class OfficerDetailsResponseModel {
  String? statusCode;
  String? statusMessage;
  Data? data;

  OfficerDetailsResponseModel({this.statusCode, this.statusMessage, this.data});

  OfficerDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  User? user;
  List<UserProject> projects;

  Data({this.user, this.projects = const []});

  Data.fromJson(Map<String, dynamic> json)
    : user = json['user'] != null ? User.fromJson(json['user']) : null,
      projects =
          json['projects'] != null
              ? (json['projects'] as List)
                  .map((e) => UserProject.fromJson(e))
                  .toList()
              : [];
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? username;
  String? email;
  String? phoneNumber;
  bool? isActive;
  String? roleId;
  String? stateId;
  String? state;
  String? districtId;

  Role? role;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.username,
    this.email,
    this.phoneNumber,
    this.isActive,
    this.roleId,
    this.stateId,
    this.state,
    this.districtId,
    this.role,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    isActive = json['isActive'];
    roleId = json['roleId'];
    stateId = json['stateId'];
    state = json['state'];
    districtId = json['districtId'];

    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['isActive'] = this.isActive;
    data['roleId'] = this.roleId;
    data['stateId'] = this.stateId;
    data['state'] = this.state;
    data['districtId'] = this.districtId;

    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    return data;
  }
}

class Role {
  String? id;
  String? name;

  Role({this.id, this.name});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
