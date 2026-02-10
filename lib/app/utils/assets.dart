class Assets {
  static final String baseAssetLocation = "assets";
  static final String iconFolderLocation = "$baseAssetLocation/icons";
  static final String imageFolderLocation = "$baseAssetLocation/images";

}

class IconAssets{
  static String get error => "${Assets.iconFolderLocation}/warning.png";
}
class ImageAssets{
  static String get splashImage => "${Assets.imageFolderLocation}/pmjvk_splash.png";
}

