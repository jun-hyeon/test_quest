import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

class PermissionService {
  Future<PermissionStatus> requestNotificationPermission() async {
    return await Permission.notification.request();
  }

  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  Future<PermissionStatus> requestPhotoPermission() async {
    return await Permission.photos.request();
  }

  Future<PermissionStatus> requestTrackingPermission() async {
    return await Permission.appTrackingTransparency.request();
  }
}
