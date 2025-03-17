import 'package:flutter/material.dart';
import '../models/device.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(device.name),
              color: Colors.deepOrange,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  device.value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
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
            activeTrackColor: Colors.deepOrange,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
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
      default:
        return Icons.devices;
    }
  }
}