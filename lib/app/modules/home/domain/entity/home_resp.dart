
import 'package:ministry_of_minority_affairs/app/modules/home/domain/entity/home_data.dart';

class HomeResp {

  String? statusCode;
  String? statusMessage;
  String? error;
  HomeData? data;

  HomeResp({
    this.statusCode,
    this.statusMessage,
    this.error,
    this.data,
  });
}

