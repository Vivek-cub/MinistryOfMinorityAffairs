class FieldOfficersNotVisited {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? username;
  String? email;
  String? phoneNumber;
  String? profilePath;
  String? stateName;
  String? districtName;
  String? blockName;

  FieldOfficersNotVisited({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.username,
    this.email,
    this.phoneNumber,
    this.profilePath,
    this.blockName,
    this.districtName,
    this.stateName,
  });

  FieldOfficersNotVisited.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    profilePath = json['profilePath'];
    blockName = json['blockName'];
    districtName = json['districtName'];
    stateName = json['stateName'];
  }
}
