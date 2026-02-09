class SendMobileOtpData {
  String token;
  SendMobileOtpData({
    required this.token,
  });

  factory SendMobileOtpData.fromJson(Map<String, dynamic> json) => SendMobileOtpData(
        token: json['token'],
      );
}