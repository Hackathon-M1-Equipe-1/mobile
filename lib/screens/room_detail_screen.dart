

import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/device_card.dart';
import '../widgets/stat_card.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;

  const RoomDetailScreen({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  late Room currentRoom;

  @override
  void initState() {
    super.initState();
    currentRoom = widget.room;
  }

  @override
  Widget build(BuildContext context) {
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
                        currentRoom.name,
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
                    '${currentRoom.familyMembers} family members have access',
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
                itemCount: currentRoom.devicesList.length,
                itemBuilder: (context, index) {
                  final device = currentRoom.devicesList[index];
                  return DeviceCard(
                    device: device,
                    onToggle: (value) {
                      setState(() {
                        currentRoom.devicesList[index].isActive = value;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}