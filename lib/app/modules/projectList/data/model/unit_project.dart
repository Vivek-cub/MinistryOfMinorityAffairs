class UnitProject {
  String? id;
  String? projectName;
  String? stateName;
  String? districtName;
  String? blockTownName;
  int? visitCount;
  String? msdpItemsName;
  String? msdpSectorName;

  UnitProject({
    this.id,
    this.projectName,
    this.stateName,
    this.districtName,
    this.blockTownName,
    this.msdpItemsName,
    this.msdpSectorName,
  });

  UnitProject.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    projectName = json['projectName'];
    stateName = json['stateName'];
    districtName = json['districtName'];
    blockTownName = json['blockTownName'];
    visitCount = json['visitCount'];
    msdpItemsName = json['msdpItemsName'];
    msdpSectorName = json['msdpSectorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['projectName'] = this.projectName;
    data['stateName'] = this.stateName;
    data['districtName'] = this.districtName;
    data['blockTownName'] = this.blockTownName;
    data['visitCount'] = this.visitCount;
    data['msdpItemsName'] = this.msdpItemsName;
    data['msdpSectorName'] = this.msdpSectorName;
    return data;
  }
}
