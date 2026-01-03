enum Flavor { free, paid }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final bool canAddLocation;
  final String apiBaseUrl;

  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.canAddLocation,
    required this.apiBaseUrl,
  });

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    return _instance ?? FlavorConfig.free();
  }

  factory FlavorConfig.free() {
    _instance = FlavorConfig._(
      flavor: Flavor.free,
      name: 'Story App Free',
      canAddLocation: false,
      apiBaseUrl: 'https://story-api.dicoding.dev/v1',
    );
    return _instance!;
  }

  factory FlavorConfig.paid() {
    _instance = FlavorConfig._(
      flavor: Flavor.paid,
      name: 'Story App Pro',
      canAddLocation: true,
      apiBaseUrl: 'https://story-api.dicoding.dev/v1',
    );
    return _instance!;
  }

  bool get isFree => flavor == Flavor.free;
  bool get isPaid => flavor == Flavor.paid;
}
