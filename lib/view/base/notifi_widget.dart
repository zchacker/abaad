
import 'package:flutter/material.dart';

class NotifIconWidget extends StatelessWidget {
  final Color color;
  final double size;
  final bool fromRestaurant;
  const NotifIconWidget({super.key, required this.color, required this.size, this.fromRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Icon(
        Icons.notifications_active, size: size,
        color: color,
      ),
    ]);
  }
}
