class SubmitResponseModel {
  final bool? success;
  final String? message;
  final String? error;

  SubmitResponseModel({this.success, this.message, this.error});

  factory SubmitResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmitResponseModel(
      success: json['success'],
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'error': error};
  }
}
