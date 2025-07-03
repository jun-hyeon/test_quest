import 'dart:io';

import 'package:image_picker/image_picker.dart';

extension XfileExtension on XFile {
  File toFile() => File(path);
}
