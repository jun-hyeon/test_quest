import 'package:flutter/material.dart';

class TestQuestSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isError ? Colors.red : Colors.green,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      duration: const Duration(milliseconds: 1500),
      content: Row(
        children: [
          Icon(
            isError ? Icons.error : Icons.check_circle,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
