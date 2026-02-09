class CommonResponseModel {
  final String? statusCode;
  final String? statusMessage;
  final String? error;

  CommonResponseModel({
    this.statusCode,
    this.statusMessage,
    this.error,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) {
    return CommonResponseModel(
      statusCode: json['statusCode']?.toString(),
      statusMessage: json['statusMessage']?.toString(),
      error: json['error']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'error': error,
    };
  }

  /// Helper
  bool get isSuccess => statusCode == '200';
}
