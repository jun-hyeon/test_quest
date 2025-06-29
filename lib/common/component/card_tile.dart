import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.style,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.primary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: colors.onSurface),
        title: Text(title, style: style.copyWith(color: colors.onSurface)),
        trailing:
            Icon(Icons.arrow_forward_ios, color: colors.onSurface, size: 16),
        onTap: onTap,
      ),
    );
  }
}
