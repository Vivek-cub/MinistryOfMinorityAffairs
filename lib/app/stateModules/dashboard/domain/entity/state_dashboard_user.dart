class StateDashboardUser {
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
  String? profilePath;

  StateDashboardUser({
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
    this.profilePath,
  });

  StateDashboardUser.fromJson(Map<String, dynamic> json) {
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
    profilePath = json['profilePath'];
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
    data['profilePath'] = this.profilePath;
    return data;
  }
}
