import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/entity/state_dashboard_data.dart';

class StateDashboardResponseModel {
  String? statusCode;
  String? statusMessage;
  StateDashboardData? data;

  StateDashboardResponseModel({this.statusCode, this.statusMessage, this.data});

  StateDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    data =
        json['data'] != null
            ? new StateDashboardData.fromJson(json['data'])
            : null;
  }
}
