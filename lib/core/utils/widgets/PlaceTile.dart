// PlaceTile.dart
import 'package:flutter/material.dart';

class Placetile extends StatelessWidget {
  final double? width;
  final String title;
  final VoidCallback? onTap;

  const Placetile({
    super.key,
    this.width,
    required this.title,
    this.onTap, required Color color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.place, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.add),
        onTap: onTap,
      ),
    );
  }
}
