import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/entity/field_officer_not_visited.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/entity/state_dashboard_user.dart';

class StateDashboardData {
  StateDashboardUser? user;
  int? totalAssigned;
  int? totalAssignedFieldOfficers;
  int? inProgress;
  int? notStarted;
  int? totalCompleted;
  int? geoTagged;
  int? nonGeoTagged;
  List<FieldOfficersNotVisited>? fieldOfficersNotVisited;

  StateDashboardData({
    this.user,
    this.totalAssigned,
    this.totalAssignedFieldOfficers,
    this.inProgress,
    this.notStarted,
    this.totalCompleted,
    this.geoTagged,
    this.nonGeoTagged,
    this.fieldOfficersNotVisited,
  });

  StateDashboardData.fromJson(Map<String, dynamic> json) {
    user =
        json['user'] != null
            ? new StateDashboardUser.fromJson(json['user'])
            : null;
    totalAssigned = json['totalAssigned'];
    totalAssignedFieldOfficers = json['totalAssignedFieldOfficers'];
    inProgress = json['inProgress'];
    notStarted = json['notStarted'];
    totalCompleted = json['totalCompleted'];
    geoTagged = json['geoTagged'];
    nonGeoTagged = json['nonGeoTagged'];
    if (json['fieldOfficersNotVisited'] != null) {
      fieldOfficersNotVisited = <FieldOfficersNotVisited>[];
      json['fieldOfficersNotVisited'].forEach((v) {
        fieldOfficersNotVisited!.add(new FieldOfficersNotVisited.fromJson(v));
      });
    }
  }
}
