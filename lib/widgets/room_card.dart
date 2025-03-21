import 'package:flutter/material.dart';
import 'package:hackaton_m1_team1/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;
  final Function(bool) onToggle;

  const RoomCard({
    Key? key,
    required this.room,
    required this.onTap,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              '',
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            Text(
              '${room.devices} Devices',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.primary,
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Switch(
                value: room.isActive,
                onChanged: onToggle,
                activeColor: Colors.white,
                activeTrackColor: theme.colorScheme.primary,
                inactiveTrackColor: isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.withOpacity(0.3),
                inactiveThumbColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}