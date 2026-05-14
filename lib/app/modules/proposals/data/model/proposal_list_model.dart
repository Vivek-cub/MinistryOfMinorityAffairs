import 'package:ministry_of_minority_affairs/app/modules/proposals/data/model/proposal_list_data.dart';

class ProposalListModel {
  final String? statusCode;
  final String? statusMessage;
  final List<ProposalListData>? data;

  ProposalListModel({this.statusCode, this.statusMessage, this.data});

  factory ProposalListModel.fromJson(Map<String, dynamic> json) {
    return ProposalListModel(
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      data:
          (json['projects'] as List<dynamic>? ?? [])
              .map((e) => ProposalListData.fromJson(e))
              .toList(),
    );
  }
}
