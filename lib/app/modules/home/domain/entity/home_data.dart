
class HomeData {

  int? inProgress;
  int? notStarted;
  int? geoTagged;
  int? nonGeoTagged;
  int? totalCompleted;


  HomeData({
    this.inProgress,
    this.notStarted,
    this.geoTagged,
    this.nonGeoTagged,
    this.totalCompleted
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        inProgress: json['inProgress'],
        notStarted: json['notStarted'],
        geoTagged: json['geoTagged'],
        nonGeoTagged: json['nonGeoTagged'],
        totalCompleted: json['totalCompleted']
      );
}