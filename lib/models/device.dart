class Device {
  final String name;
  final String value;
  final String icon;
  bool isActive;

  Device({
    required this.name,
    required this.value,
    required this.icon,
    this.isActive = false,
  });
}