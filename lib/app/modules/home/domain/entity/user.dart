class User {
  String? id;
  String? phoneNumber;
  String? name;
  bool? isActive;
  //  DateTime? createdAt;
  //  DateTime? updatedAt;
  String? profilePath;
  String? state;

  User({
    this.id,
    this.phoneNumber,
    this.name,
    this.isActive,
    //  this.createdAt,
    //  this.updatedAt,
    this.profilePath,
    this.state,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['Id'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      isActive: json['isActive'] as bool,
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
      profilePath: json["profilePath"],
      state: json["state"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'isActive': isActive,

      "profilePath": profilePath,
      "state": state,
    };
  }
}
