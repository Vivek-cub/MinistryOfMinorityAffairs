class Assets {
  static final String baseAssetLocation = "assets";
  static final String iconFolderLocation = "$baseAssetLocation/icons";
  static final String imageFolderLocation = "$baseAssetLocation/images";

}

class IconAssets{
  static String get error => "${Assets.iconFolderLocation}/warning.png";
  static String get assignedTask => "${Assets.iconFolderLocation}/task_assigned.png";
  static String get workInProgress => "${Assets.iconFolderLocation}/in_progress.png";
  static String get completedTask => "${Assets.iconFolderLocation}/task_completed.png";
  static String get geotagged => "${Assets.iconFolderLocation}/geotagged.png";
  static String get nonGeotagged => "${Assets.iconFolderLocation}/non_geotagged.png";


}
class ImageAssets{
  static String get splashImage => "${Assets.imageFolderLocation}/pmjvk_splash.png";
  static String get emblemImage => "${Assets.imageFolderLocation}/emblem.png";

}

