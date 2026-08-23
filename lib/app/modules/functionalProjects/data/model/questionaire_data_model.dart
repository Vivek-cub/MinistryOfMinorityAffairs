class QuestionnaireResponse {
  final String? statusCode;
  final String? statusMessage;
  final QuestionnaireData? data;

  QuestionnaireResponse({this.statusCode, this.statusMessage, this.data});

  factory QuestionnaireResponse.fromJson(Map<String, dynamic> json) {
    return QuestionnaireResponse(
      statusCode: json['statusCode']?.toString(),
      statusMessage: json['statusMessage']?.toString(),
      data:
          json['data'] != null
              ? QuestionnaireData.fromJson(json['data'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'data': data?.toJson(),
    };
  }
}

class QuestionnaireData {
  final String? state;
  final String? sector;
  final String? district;
  final String? latitude;
  final String? unitCode;
  final String? longitude;
  final String? blockTown;
  final String? projectName;
  final String? projectType;
  final String? projectUniqueId;
  final DateTime? dateOfCompletion;
  final String? responsibleDepartment;
  //final int? currentStudentEnrolment;

  QuestionnaireData({
    this.state,
    this.sector,
    this.district,
    this.latitude,
    this.unitCode,
    this.longitude,
    this.blockTown,
    this.projectName,
    this.projectType,
    this.projectUniqueId,
    this.dateOfCompletion,
    this.responsibleDepartment,
    //this.currentStudentEnrolment,
  });

  factory QuestionnaireData.fromJson(Map<String, dynamic> json) {
    return QuestionnaireData(
      state: json['state']?.toString(),
      sector: json['sector']?.toString(),
      district: json['district']?.toString(),
      latitude: json['latitude']?.toString(),
      unitCode: json['unitCode']?.toString(),
      longitude: json['longitude']?.toString(),
      blockTown: json['block/town']?.toString(),
      projectName: json['projectName']?.toString(),
      projectType: json['projectType']?.toString(),
      projectUniqueId: json['projectUniqueId']?.toString(),
      dateOfCompletion:
          json['dateOfCompletion'] != null
              ? DateTime.tryParse(json['dateOfCompletion'].toString())
              : null,
      responsibleDepartment: json['responsibleDepartment']?.toString(),
      // currentStudentEnrolment:
      //     (json['currentStudentEnrolment'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'sector': sector,
      'district': district,
      'latitude': latitude,
      'unitCode': unitCode,
      'longitude': longitude,
      'block/town': blockTown,
      'projectName': projectName,
      'projectType': projectType,
      'projectUniqueId': projectUniqueId,
      'dateOfCompletion': dateOfCompletion?.toIso8601String(),
      'responsibleDepartment': responsibleDepartment,
      //'currentStudentEnrolment': currentStudentEnrolment,
    };
  }
}
