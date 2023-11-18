import 'package:flutter/widgets.dart';
import 'dart:io';

class ImageLoader {
  static ImageProvider loadImage(String? imagePath) {
    try {
      if (imagePath == null) {
        return AssetImage('res/placeholder.jpg');
      } else {
        File file = File(imagePath);

        if (file.existsSync()) {
          // File exists, create FileImage
          return FileImage(file);
        } else {
          // File doesn't exist, use placeholder
          print('File not found: $imagePath');
          return AssetImage('res/placeholder.jpg');
        }
      }
    } catch (e) {
      // Handle other potential exceptions
      print('Error loading image: $e');
      return AssetImage('res/placeholder.jpg');
    }
  }
}