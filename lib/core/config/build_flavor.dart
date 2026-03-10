enum BuildFlavor { dev, staging, prod }

class BuildFlavorConfig {
  BuildFlavorConfig._();

  static const String _rawFlavor = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'dev',
  );

  static BuildFlavor get current {
    switch (_rawFlavor.toLowerCase()) {
      case 'prod':
      case 'production':
        return BuildFlavor.prod;
      case 'staging':
        return BuildFlavor.staging;
      case 'dev':
      default:
        return BuildFlavor.dev;
    }
  }

  static String get label {
    switch (current) {
      case BuildFlavor.dev:
        return 'DEV';
      case BuildFlavor.staging:
        return 'STAGING';
      case BuildFlavor.prod:
        return 'PROD';
    }
  }
}
