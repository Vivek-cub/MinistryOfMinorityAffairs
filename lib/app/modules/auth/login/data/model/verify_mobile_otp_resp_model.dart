class VerifyMobileOtpRespModel {
  String? statusCode;
  String? statusMessage;
  LoginData? data;

  VerifyMobileOtpRespModel({this.statusCode, this.statusMessage, this.data});

  VerifyMobileOtpRespModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }
}

class LoginData {
  String? message;
  String? token;
  User? user;

  LoginData({this.message, this.token, this.user});

  LoginData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }
}

class User {
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

  bool? isActive;
  String? createdAt;
  String? updatedAt;
  Role? role;
  State? state;
  District? district;

  User({
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

    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.state,
    this.district,
  });

  User.fromJson(Map<String, dynamic> json) {
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

    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    district =
        json['district'] != null
            ? new District.fromJson(json['district'])
            : null;
  }
}

class Role {
  String? id;
  String? name;
  String? label;
  String? description;
  String? createdAt;
  String? updatedAt;

  Role({
    this.id,
    this.name,
    this.label,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['name'];
    label = json['label'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['name'] = this.name;
    data['label'] = this.label;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class State {
  String? id;
  String? name;
  String? stateCode;
  String? shortName;
  bool? isDeleted;

  String? createdAt;
  String? updatedAt;

  State({
    this.id,
    this.name,
    this.stateCode,
    this.shortName,
    this.isDeleted,

    this.createdAt,
    this.updatedAt,
  });

  State.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['name'];
    stateCode = json['stateCode'];
    shortName = json['shortName'];
    isDeleted = json['isDeleted'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['name'] = this.name;
    data['stateCode'] = this.stateCode;
    data['shortName'] = this.shortName;
    data['isDeleted'] = this.isDeleted;

    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class District {
  String? id;
  String? name;
  String? districtName;
  String? stateId;
  String? districtCode;
  String? stateCode;
  bool? isDeleted;
  int? distCode;
  int? distCodeOld;
  int? totalMinorityPopulation;

  int? type;

  String? createdAt;
  String? updatedAt;

  District({
    this.id,
    this.name,
    this.districtName,
    this.stateId,
    this.districtCode,
    this.stateCode,
    this.isDeleted,
    this.distCode,
    this.distCodeOld,
    this.totalMinorityPopulation,

    this.type,

    this.createdAt,
    this.updatedAt,
  });

  District.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['name'];
    districtName = json['districtName'];
    stateId = json['stateId'];
    districtCode = json['districtCode'];
    stateCode = json['stateCode'];
    isDeleted = json['isDeleted'];
    distCode = json['distCode'];
    distCodeOld = json['distCodeOld'];
    totalMinorityPopulation = json['totalMinorityPopulation'];

    type = json['type'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['name'] = this.name;
    data['districtName'] = this.districtName;
    data['stateId'] = this.stateId;
    data['districtCode'] = this.districtCode;
    data['stateCode'] = this.stateCode;
    data['isDeleted'] = this.isDeleted;
    data['distCode'] = this.distCode;
    data['distCodeOld'] = this.distCodeOld;
    data['totalMinorityPopulation'] = this.totalMinorityPopulation;

    data['type'] = this.type;

    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
