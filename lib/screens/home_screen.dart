import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:hackaton_m1_team1/providers/room_provider.dart';
import 'package:hackaton_m1_team1/providers/settings_provider.dart';
import 'package:hackaton_m1_team1/widgets/room_card.dart';
import 'package:hackaton_m1_team1/screens/room_detail_screen.dart';
import 'package:hackaton_m1_team1/services/speechToText.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioRecorder audioRecord;
  String? audioPath;
  String? transcription;
  bool _isRecording = false;

  @override
  void initState() {
    audioRecord = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User profile and welcome message
                  Consumer<SettingsProvider>(
                    builder: (context, settingsProvider, child) {
                      return Row(
                        children: [
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome home!',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    builder:
                                        (context) =>
                                            RoomDetailScreen(roomIndex: index),
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

            // Custom recording indicator that appears above the button
            if (_isRecording)
              Positioned(
                bottom: 85, // Position above the FAB
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Recording... Release to stop',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
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
          child: Icon(Icons.mic, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Method to start recording
  Future<void> _startRecording() async {
    try {
      setState(() {
        _isRecording = true;
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Recording started... Keep holding to continue'),
      //     duration: Duration(seconds: 1),
      //     backgroundColor: Colors.deepOrange,
      //   ),
      // );

      if (await audioRecord.hasPermission()) {
        final tempDir = Directory.systemTemp;
        final filePath = '${tempDir.path}/audio.m4a';

        final recordConfig = RecordConfig(
          encoder: AudioEncoder.flac,
          bitRate: 128000,
          sampleRate: 44100,
        );

        await audioRecord.start(recordConfig, path: filePath);

        setState(() {
          _isRecording = true;
          audioPath = filePath;
          transcription = null;
        });
      } else {
        throw Exception('Permission non accordée !');
      }
    } catch (e) {
      throw Exception('Erreur lors du démarrage de l\'enregistrement : $e');
    }
  }

  // Method to stop recording
  Future<void> _stopRecording() async {
    try {
      if (await audioRecord.isRecording()) {
        final path = await audioRecord.stop();
        setState(() {
          _isRecording = false;
          audioPath = path;
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Recording stopped'),
        //     duration: Duration(seconds: 1),
        //     backgroundColor: Colors.grey,
        //   ),
        // );

        if (path != null && File(path).existsSync()) {
          SpeechToTextService sttService = SpeechToTextService();
          String result = await sttService.speechToText(path);

          setState(() {
            transcription = result;
          });
        } else {
          throw Exception('Erreur : fichier introuvable.');
        }
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'arrêt de l\'enregistrement : $e');
    }
  }
}
