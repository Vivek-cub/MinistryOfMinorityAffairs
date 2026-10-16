class SendMobileOtpData {
  final String message;
  final String isPin;

  SendMobileOtpData({required this.message, required this.isPin});

  factory SendMobileOtpData.fromJson(Map<String, dynamic> json) {
    return SendMobileOtpData(
      message: json['message'] ?? '',
      isPin: json['isPin'] ?? '',
    );
  }
}
