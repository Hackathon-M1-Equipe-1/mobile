class Device {
  final String name;
  final String value;
  final String icon;
  final bool isActive;

  const Device({
    required this.name,
    required this.value,
    required this.icon,
    this.isActive = false,
  });

  Device copyWith({
    String? name,
    String? value,
    String? icon,
    bool? isActive,
  }) {
    return Device(
      name: name ?? this.name,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
    );
  }
}