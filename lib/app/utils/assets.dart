class Assets {
  static final String baseAssetLocation = "assets";
  static final String iconFolderLocation = "$baseAssetLocation/icons";
  static final String imageFolderLocation = "$baseAssetLocation/images";
  static final String svgFolderLocation = "$baseAssetLocation/svg";
}

class IconAssets {
  static String get error => "${Assets.iconFolderLocation}/warning.png";
  static String get assignedTask =>
      "${Assets.iconFolderLocation}/task_assigned.png";
  static String get workInProgress =>
      "${Assets.iconFolderLocation}/in_progress.png";
  static String get completedTask =>
      "${Assets.iconFolderLocation}/task_completed.png";
  static String get geotagged => "${Assets.iconFolderLocation}/geotagged.png";
  static String get nonGeotagged =>
      "${Assets.iconFolderLocation}/non_geotagged.png";
  static String get user => "${Assets.iconFolderLocation}/user.png";
}

class ImageAssets {
  static String get splashImage =>
      "${Assets.imageFolderLocation}/pmjvk_splash.png";
  static String get emblemImage => "${Assets.imageFolderLocation}/emblem.png";
  static String get successImage => "${Assets.imageFolderLocation}/check.png";
  static String get indiaGateImage =>
      "${Assets.imageFolderLocation}/indiagate.png";
}

class SvgAssets {
  static String get emblemSvg => "${Assets.svgFolderLocation}/emblem.svg";
  static String get assignedSvg => "${Assets.svgFolderLocation}/assigned.svg";
  static String get completedSvg => "${Assets.svgFolderLocation}/completed.svg";
  static String get notStartedSvg =>
      "${Assets.svgFolderLocation}/not_started.svg";
  static String get geotaggedSvg => "${Assets.svgFolderLocation}/geotagged.svg";
  static String get nonGeotaggedSvg =>
      "${Assets.svgFolderLocation}/non_geotagged.svg";
  static String get filterSvg => "${Assets.svgFolderLocation}/filter.svg";
  static String get cancelSvg => "${Assets.svgFolderLocation}/cancel.svg";
  static String get workInProgressSvg =>
      "${Assets.svgFolderLocation}/working_inprogress.svg";
  static String get notFunctionalSvg =>
      "${Assets.svgFolderLocation}/not_functional.svg";
  static String get functionalSvg =>
      "${Assets.svgFolderLocation}/functional.svg";
}
