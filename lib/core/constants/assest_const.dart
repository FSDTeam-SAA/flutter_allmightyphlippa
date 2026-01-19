class AssetsConstants {
  /// icons

  /// images
  // static const String logo = 'assets/images/splash and login logo.png';
  // static const String appLogoLandscape = 'assets/images/onboard image.jpeg';

  static Images get images => Images();
  static Icons get icons => Icons();
}

class Images {
  static const String _base = 'assets/images';
  final String logo = '$_base/splash_and_login_logo.png';
  final String appLogoLandscape = '$_base/onboard_image.jpeg';
}

class Icons {
  static const String _base = 'assets/icons';
  final String bases = _base;

  final String home = '$_base/home.svg';
  final String playSquare = '$_base/play-square.svg';
  final String movieOutline = '$_base/movie-outline.svg';
  final String series = '$_base/series.svg';
  final String userCircle = '$_base/user-circle.svg';
}
