import 'device.dart';

class Room {
  final String name;
  final int familyMembers;
  final bool isActive;
  final List<Device> devicesList;

  Room({
    required this.name,
    required this.familyMembers,
    this.isActive = false,
    required this.devicesList,
  });

  // Getter to dynamically calculate number of devices
  int get devices => devicesList.length;
}