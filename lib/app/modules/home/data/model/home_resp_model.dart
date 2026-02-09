
import 'package:ministry_of_minority_affairs/app/modules/home/domain/entity/home_data.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/entity/home_resp.dart';

class HomeRespModel extends HomeResp {
  HomeRespModel({
    super.statusCode,
    super.statusMessage,
    super.error,
    super.data,
  });

  factory HomeRespModel.fromJson(Map<String, dynamic> json) =>
      HomeRespModel(
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
        error: json['error'],
        data: json['data'] != null
            ? HomeData.fromJson(
                json['data'],
              )
            : null,
      );
}