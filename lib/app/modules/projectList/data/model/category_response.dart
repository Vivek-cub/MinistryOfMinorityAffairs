// main response model
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/category.dart';

class CategoryResponse {
  final String? statusCode;
  final String? statusMessage;
  final List<Category>? data;

  CategoryResponse({
     this.statusCode,
     this.statusMessage,
     this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      data: (json['data'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),

    );
  }

  
}
