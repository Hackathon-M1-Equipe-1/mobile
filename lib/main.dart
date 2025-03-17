import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/room_provider.dart';
import 'providers/settings_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Home',
          themeMode: settingsProvider.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: const Color(0xFFF5F5DC),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: const Color(0xFF121212),
            brightness: Brightness.dark,
            cardColor: const Color(0xFF1E1E1E),
            colorScheme: const ColorScheme.dark().copyWith(
              primary: Colors.deepOrange,
              secondary: Colors.deepOrangeAccent,
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}