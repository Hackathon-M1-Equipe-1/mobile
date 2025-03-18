import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/room_card.dart';
import 'room_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      // Add the recording button at the bottom center of the screen
      floatingActionButton: GestureDetector(
        onLongPressStart: (_) => _startRecording(),
        onLongPressEnd: (_) => _stopRecording(),
        child: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: _isRecording ? Colors.red : Colors.deepOrange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.mic,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Method to start recording
  void _startRecording() {
    setState(() {
      _isRecording = true;
    });

    // Show visual feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recording started... Keep holding to continue'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.deepOrange,
      ),
    );

    // Here you would implement the actual recording logic
    // For example: record.start();
  }

  // Method to stop recording
  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });

    // Show visual feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recording stopped'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.grey,
      ),
    );

    // Here you would implement the stop recording logic
    // For example: record.stop();
  }
}