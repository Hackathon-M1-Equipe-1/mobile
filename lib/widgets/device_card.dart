import 'package:flutter/material.dart';
import 'package:hackaton_m1_team1/models/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final Function(bool) onToggle;

  const DeviceCard({
    Key? key,
    required this.device,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Device icon placeholder
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(device.name),
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Device details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  device.value,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          // Toggle switch
          Switch(
            value: device.isActive,
            onChanged: onToggle,
            activeColor: Colors.white,
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.withOpacity(0.3),
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  // Helper method to get icon based on device name
  IconData _getIconData(String deviceName) {
    switch (deviceName.toLowerCase()) {
      case 'lamp':
      case 'light':
      case 'main light':
        return Icons.lightbulb;
      case 'tv':
        return Icons.tv;
      case 'ac':
      case 'air conditioner':
        return Icons.ac_unit;
      case 'fridge':
      case 'refrigerator':
        return Icons.kitchen;
      case 'cctv cam.':
        return Icons.videocam;
      case 'microwave':
        return Icons.microwave;
      case 'coffee machine':
        return Icons.coffee;
      default:
        return Icons.devices;
    }
  }
}