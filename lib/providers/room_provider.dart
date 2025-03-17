import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/room.dart';
import '../models/device.dart';

class RoomProvider extends ChangeNotifier {
  List<Room> _rooms = [];

  // Getter for immutable list of rooms
  List<Room> get rooms => List.unmodifiable(_rooms);

  // Initialize with sample data
  RoomProvider() {
    _initializeRooms();
    _loadState();
  }

  // Initialize rooms with default data
  void _initializeRooms() {
    _rooms = [
      Room(
        name: 'Home',
        familyMembers: 4,
        isActive: true,
        devicesList: [
          Device(name: 'Main Light', value: '80% Brightness', icon: 'assets/icons/light.png', isActive: true),
          Device(name: 'TV', value: '42% Volume', icon: 'assets/icons/tv.png'),
          Device(name: 'AC', value: '24°C Temperature', icon: 'assets/icons/ac.png', isActive: true),
        ],
      ),
      Room(
        name: 'Kitchen',
        familyMembers: 2,
        isActive: true,
        devicesList: [
          Device(name: 'Light', value: '60% Brightness', icon: 'assets/icons/light.png', isActive: true),
          Device(name: 'Refrigerator', value: '5°C Temperature', icon: 'assets/icons/fridge.png', isActive: true),
          Device(name: 'Microwave', value: 'Off', icon: 'assets/icons/microwave.png'),
          Device(name: 'Coffee Machine', value: 'Standby', icon: 'assets/icons/coffee.png'),
        ],
      ),
      Room(
        name: 'Bedroom',
        familyMembers: 3,
        isActive: false,
        devicesList: [
          Device(name: 'Lamp', value: '65% Brightness', icon: 'assets/icons/lamp.png', isActive: true),
          Device(name: 'TV', value: '37% Volume', icon: 'assets/icons/tv.png'),
          Device(name: 'AC', value: '24°C Temperature', icon: 'assets/icons/ac.png', isActive: true),
          Device(name: 'Fridge', value: '5°C Temperature', icon: 'assets/icons/fridge.png', isActive: true),
          Device(name: 'CCTV Cam.', value: 'Left/Right : 96.4° & Up/Down : 86.2°', icon: 'assets/icons/cctv.png'),
        ],
      ),
    ];
  }

  // Load state from SharedPreferences
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Here we would implement proper persistence logic
      // For now, we'll just load room active states
      for (int i = 0; i < _rooms.length; i++) {
        final roomActive = prefs.getBool('room_${i}_active');
        if (roomActive != null) {
          _rooms[i] = _rooms[i].copyWith(isActive: roomActive);
        }

        // Load device states
        for (int j = 0; j < _rooms[i].devicesList.length; j++) {
          final deviceActive = prefs.getBool('room_${i}_device_${j}_active');
          if (deviceActive != null) {
            final devicesList = [..._rooms[i].devicesList];
            devicesList[j] = devicesList[j].copyWith(isActive: deviceActive);
            _rooms[i] = _rooms[i].copyWith(devicesList: devicesList);
          }
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading state: $e');
    }
  }

  // Save state to SharedPreferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save room active states
      for (int i = 0; i < _rooms.length; i++) {
        await prefs.setBool('room_${i}_active', _rooms[i].isActive);

        // Save device states
        for (int j = 0; j < _rooms[i].devicesList.length; j++) {
          await prefs.setBool('room_${i}_device_${j}_active', _rooms[i].devicesList[j].isActive);
        }
      }
    } catch (e) {
      debugPrint('Error saving state: $e');
    }
  }

  // Toggle room active status
  void toggleRoomActive(int roomIndex, bool isActive) {
    if (roomIndex < 0 || roomIndex >= _rooms.length) return;

    final room = _rooms[roomIndex];
    _rooms[roomIndex] = room.copyWith(isActive: isActive);
    notifyListeners();
    _saveState();
  }

  // Toggle device active status
  void toggleDeviceActive(int roomIndex, int deviceIndex, bool isActive) {
    if (roomIndex < 0 || roomIndex >= _rooms.length) return;
    if (deviceIndex < 0 || deviceIndex >= _rooms[roomIndex].devicesList.length) return;

    final room = _rooms[roomIndex];
    final devicesList = [...room.devicesList];
    devicesList[deviceIndex] = devicesList[deviceIndex].copyWith(isActive: isActive);

    _rooms[roomIndex] = room.copyWith(devicesList: devicesList);
    notifyListeners();
    _saveState();
  }

  // Get a room by index
  Room? getRoomByIndex(int index) {
    if (index < 0 || index >= _rooms.length) return null;
    return _rooms[index];
  }

  // Update device value (e.g., brightness, temperature)
  void updateDeviceValue(int roomIndex, int deviceIndex, String value) {
    if (roomIndex < 0 || roomIndex >= _rooms.length) return;
    if (deviceIndex < 0 || deviceIndex >= _rooms[roomIndex].devicesList.length) return;

    final room = _rooms[roomIndex];
    final devicesList = [...room.devicesList];
    devicesList[deviceIndex] = devicesList[deviceIndex].copyWith(value: value);

    _rooms[roomIndex] = room.copyWith(devicesList: devicesList);
    notifyListeners();
    _saveState();
  }
}