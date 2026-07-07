class OfficerListResponseModel {
  String? statusCode;
  String? statusMessage;
  OfficerData? data;

  OfficerListResponseModel({this.statusCode, this.statusMessage, this.data});

  OfficerListResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = json['data'] != null ? new OfficerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OfficerData {
  String? status;
  List<FieldOfficers>? fieldOfficers;

  OfficerData({this.status, this.fieldOfficers});

  OfficerData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['fieldOfficers'] != null) {
      fieldOfficers = <FieldOfficers>[];
      json['fieldOfficers'].forEach((v) {
        fieldOfficers!.add(new FieldOfficers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.fieldOfficers != null) {
      data['fieldOfficers'] =
          this.fieldOfficers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FieldOfficers {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? username;
  String? email;
  String? phoneNumber;

  String? roleId;
  String? stateId;
  String? districtId;
  String? profilePath;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  Role? role;
  Role? state;
  String? stateName;
  String? districtName;
  String? blockName;

  FieldOfficers({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.username,
    this.email,
    this.phoneNumber,

    this.roleId,
    this.stateId,
    this.districtId,
    this.profilePath,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.state,
    this.blockName,
    this.stateName,
    this.districtName,
  });

  FieldOfficers.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];

    roleId = json['roleId'];
    stateId = json['stateId'];
    districtId = json['districtId'];
    profilePath = json['profilePath'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    blockName = json['blockName'];
    districtName = json['districtName'];
    stateName = json['stateName'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    state = json['state'] != null ? new Role.fromJson(json['state']) : null;
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

    data['roleId'] = this.roleId;
    data['stateId'] = this.stateId;
    data['districtId'] = this.districtId;
    data['profilePath'] = this.profilePath;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state!.toJson();
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
