import 'package:flutter/material.dart';
import '../models/room.dart';
import '../models/device.dart';
import '../widgets/room_card.dart';
import 'room_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data for rooms
  late List<Room> rooms;

  @override
  void initState() {
    super.initState();
    // Initialize rooms with sample data
    rooms = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile and welcome message
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hi Samuel',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Welcome to Home',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Room cards
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return RoomCard(
                      room: rooms[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomDetailScreen(room: rooms[index]),
                          ),
                        );
                      },
                      onToggle: (value) {
                        setState(() {
                          rooms[index] = Room(
                            name: rooms[index].name,
                            familyMembers: rooms[index].familyMembers,
                            isActive: value,
                            devicesList: rooms[index].devicesList,
                          );
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}