import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/room_card.dart';
import 'room_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) {
                  return Row(
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
                        children: [
                          Text(
                            'Hi ${settingsProvider.username}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Welcome to Home',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          settingsProvider.themeMode == ThemeMode.dark
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        onPressed: () {
                          settingsProvider.setThemeMode(
                            settingsProvider.themeMode == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),

              // Room cards
              Consumer<RoomProvider>(
                builder: (context, roomProvider, child) {
                  final rooms = roomProvider.rooms;
                  return Expanded(
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
                                builder: (context) => RoomDetailScreen(roomIndex: index),
                              ),
                            );
                          },
                          onToggle: (value) {
                            roomProvider.toggleRoomActive(index, value);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}