import 'device.dart';

class Room {
  final String name;
  final int familyMembers;
  final bool isActive;
  final List<Device> devicesList;

  const Room({
    required this.name,
    required this.familyMembers,
    this.isActive = false,
    required this.devicesList,
  });

  // Getter to dynamically calculate number of devices
  int get devices => devicesList.length;

  Room copyWith({
    String? name,
    int? familyMembers,
    bool? isActive,
    List<Device>? devicesList,
  }) {
    return Room(
      name: name ?? this.name,
      familyMembers: familyMembers ?? this.familyMembers,
      isActive: isActive ?? this.isActive,
      devicesList: devicesList ?? this.devicesList,
    );
  }
}