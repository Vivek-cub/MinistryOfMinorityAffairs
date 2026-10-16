class CreatePinResponseModel {
  final String? statusCode;
  final String? statusMessage;
  final CreatePinData? data;

  CreatePinResponseModel({this.statusCode, this.statusMessage, this.data});

  factory CreatePinResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatePinResponseModel(
      statusCode: json['statusCode']?.toString() ?? '',
      statusMessage: json['statusMessage'] ?? '',
      data: CreatePinData.fromJson(json['data'] ?? {}),
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

class CreatePinData {
  final String userId;

  CreatePinData({required this.userId});

  factory CreatePinData.fromJson(Map<String, dynamic> json) {
    return CreatePinData(userId: json['userId'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId};
  }
}
