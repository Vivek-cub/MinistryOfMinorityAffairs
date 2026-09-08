class UnitProject {
  String? id;
  String? projectName;
  String? stateName;
  String? districtName;
  String? blockTownName;
  int? visitCount;
  String? msdpItemsName;
  String? msdpSectorName;
  ProjectSubType? projectSubType;

  UnitProject({
    this.id,
    this.projectName,
    this.stateName,
    this.districtName,
    this.blockTownName,
    this.msdpItemsName,
    this.msdpSectorName,
    this.projectSubType,
  });

  UnitProject.fromJson(Map<String, dynamic> json) {
    final responseData = json['projectSubType'];
    id = json['Id'];
    projectName = json['projectName'];
    stateName = json['stateName'];
    districtName = json['districtName'];
    blockTownName = json['blockTownName'];
    visitCount = json['visitCount'];
    msdpItemsName = json['msdpItemsName'];
    msdpSectorName = json['msdpSectorName'];
    projectSubType =
        responseData is Map<String, dynamic>
            ? ProjectSubType.fromJson(responseData)
            : null;
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
    data['projectSubType'] = projectSubType?.toJson();
    return data;
  }
}

class ProjectSubType {
  String? id;
  String? name;
  String? label;
  String? projectTypeId;
  String? createdAt;
  String? updatedAt;

  ProjectSubType({
    this.id,
    this.name,
    this.label,
    this.projectTypeId,
    this.createdAt,
    this.updatedAt,
  });

  ProjectSubType.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['name'];
    label = json['label'];
    projectTypeId = json['projectTypeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['name'] = this.name;
    data['label'] = this.label;
    data['projectTypeId'] = this.projectTypeId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
