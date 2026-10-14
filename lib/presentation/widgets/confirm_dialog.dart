import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dialog konfirmasi. Mengembalikan true jika pengguna menekan tombol konfirmasi.
Future<bool> showConfirmDialog({
  required String title,
  required String message,
  String confirmText = 'Ya',
  String cancelText = 'Batal',
  bool destructive = false,
}) async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(cancelText),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: Colors.red.shade700)
              : null,
          onPressed: () => Get.back(result: true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return result ?? false;
}
