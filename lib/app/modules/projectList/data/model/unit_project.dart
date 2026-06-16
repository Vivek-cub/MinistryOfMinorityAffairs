class UnitProject {
  String? id;
  String? projectName;
  String? stateName;
  String? districtName;
  String? blockTownName;
  int? visitCount;

  UnitProject({
    this.id,
    this.projectName,
    this.stateName,
    this.districtName,
    this.blockTownName,
  });

  UnitProject.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    projectName = json['projectName'];
    stateName = json['stateName'];
    districtName = json['districtName'];
    blockTownName = json['blockTownName'];
    visitCount = json['visitCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['projectName'] = this.projectName;
    data['stateName'] = this.stateName;
    data['districtName'] = this.districtName;
    data['blockTownName'] = this.blockTownName;
    data['visitCount'] = this.visitCount;
    return data;
  }
}
