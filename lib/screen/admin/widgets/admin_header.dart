import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AdminHeader({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
