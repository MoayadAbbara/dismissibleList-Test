import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String? title;
  final String? message;

  const MyDialog({super.key, this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Confirm Delete'),
      content: Text(message ?? 'Are you sure you want to delete this item?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Return false for cancel
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true), // Return true for confirm
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  static Future<bool?> show({required BuildContext context, String? title, String? message}) {
    return showDialog<bool>(
      context: context,
      builder: (context) => MyDialog(title: title, message: message),
    );
  }
}
