import 'package:ministry_of_minority_affairs/app/modules/home/domain/entity/user.dart';

class HomeData {
  int? totalAssigned;
  int? totalAssignedProposals;
  int? inProgress;
  int? notStarted;
  int? geoTagged;
  int? nonGeoTagged;
  int? totalCompleted;
  User? user;

  HomeData({
    this.totalAssigned,
    this.totalAssignedProposals,
    this.inProgress,
    this.notStarted,
    this.geoTagged,
    this.nonGeoTagged,
    this.totalCompleted,
    this.user,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    totalAssigned: json['totalAssigned'],
    totalAssignedProposals: json['totalAssignedProposals'],
    inProgress: json['inProgress'],
    notStarted: json['notStarted'],
    geoTagged: json['geoTagged'],
    nonGeoTagged: json['nonGeoTagged'],
    totalCompleted: json['totalCompleted'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );
}
