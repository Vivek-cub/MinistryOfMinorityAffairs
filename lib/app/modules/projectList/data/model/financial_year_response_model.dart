import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/financial_year_name.dart';

class FinancialYearResponseModel {
  final String? statusCode;
  final String? statusMessage;
  final List<FinancialYearName>? data;

  FinancialYearResponseModel({this.statusCode, this.statusMessage, this.data});

  factory FinancialYearResponseModel.fromJson(Map<String, dynamic> json) {
    return FinancialYearResponseModel(
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      data:
          json['data'] != null
              ? List<FinancialYearName>.from(
                json['data'].map((x) => FinancialYearName.fromJson(x)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}
