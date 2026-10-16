class VerifyPinResponseModel {
  final String? statusCode;
  final String? statusMessage;
  final VerifyPinData? data;

  VerifyPinResponseModel({this.statusCode, this.statusMessage, this.data});

  factory VerifyPinResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyPinResponseModel(
      statusCode: json['statusCode']?.toString() ?? '',
      statusMessage: json['statusMessage'] ?? '',
      data: VerifyPinData.fromJson(json['data'] ?? {}),
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

class VerifyPinData {
  final String message;
  final String userId;

  VerifyPinData({required this.message, required this.userId});

  factory VerifyPinData.fromJson(Map<String, dynamic> json) {
    return VerifyPinData(
      message: json['message'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'userId': userId};
  }
}
