import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../widgets/device_card.dart';
import '../widgets/stat_card.dart';

class RoomDetailScreen extends StatelessWidget {
  final int roomIndex;

  const RoomDetailScreen({
    Key? key,
    required this.roomIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) {
        final room = roomProvider.getRoomByIndex(roomIndex);

        if (room == null) {
          return const Scaffold(
            body: Center(
              child: Text('Room not found'),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Header with room name and back button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${room.familyMembers} family members have access',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Environment stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          StatCard(
                            icon: Icons.thermostat,
                            value: '24°C',
                            label: 'TEMP',
                          ),
                          StatCard(
                            icon: Icons.water_drop,
                            value: '50%',
                            label: 'HUMIDITY',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                // Devices list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: room.devicesList.length,
                    itemBuilder: (context, deviceIndex) {
                      final device = room.devicesList[deviceIndex];
                      return DeviceCard(
                        device: device,
                        onToggle: (value) {
                          roomProvider.toggleDeviceActive(roomIndex, deviceIndex, value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}