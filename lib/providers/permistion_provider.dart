import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider with ChangeNotifier {
  PermissionStatus _audioPermissionStatus = PermissionStatus.denied;
  PermissionStatus _photoPermissionStatus = PermissionStatus.denied;
  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;
  PermissionStatus _notificationPermissionStatus = PermissionStatus.denied;

  PermissionStatus get audioPermissionStatus => _audioPermissionStatus;

  PermissionStatus get photoPermissionStatus => _photoPermissionStatus;

  PermissionStatus get storagePermissionStatus => _storagePermissionStatus;

  PermissionStatus get notificationPermissionStatus =>
      _notificationPermissionStatus;

  PermissionProvider() {
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    try {
      // Using a bulk request for simplicity and to avoid overlaps
      Map<Permission, PermissionStatus> statuses = await [
        Permission.audio,
        Permission.photos,
        Permission.storage,
        Permission.notification,
        Permission.manageExternalStorage,
      ].request();

      _audioPermissionStatus =
          statuses[Permission.audio] ?? PermissionStatus.denied;
      _photoPermissionStatus =
          statuses[Permission.photos] ?? PermissionStatus.denied;
      _storagePermissionStatus =
          statuses[Permission.storage] ?? PermissionStatus.denied;
      _notificationPermissionStatus =
          statuses[Permission.notification] ?? PermissionStatus.denied;

      // For manage external storage, log the result if requested separately

      if (statuses[Permission.manageExternalStorage] ==
          PermissionStatus.granted) {
        print("Manage External Storage permission granted");
      } else if (statuses[Permission.manageExternalStorage] ==
          PermissionStatus.denied) {
        print("Manage External Storage permission denied");
      }

      notifyListeners();
    } catch (e) {
      print("Error while requesting permissions: $e");
    }
  }

  Future<void> requestAudioPermission() async {
    print("Requesting audio permission");
    if (_audioPermissionStatus != PermissionStatus.granted) {
      _audioPermissionStatus = await Permission.audio.request();
      print("Audio permission status: $_audioPermissionStatus");
      notifyListeners();
    }
  }

  Future<void> requestPhotoPermission() async {
    print("Requesting photo permission");
    if (_photoPermissionStatus != PermissionStatus.granted) {
      _photoPermissionStatus = await Permission.photos.request();
      print("Photo permission status: $_photoPermissionStatus");
      notifyListeners();
    }
  }

  Future<void> requestStoragePermissions() async {
    print("Requesting storage permissions");
    if (_storagePermissionStatus != PermissionStatus.granted) {
      _storagePermissionStatus = await Permission.storage.request();
      print("Storage permission status: $_storagePermissionStatus");
      notifyListeners();
    }

    PermissionStatus manageStatus =
        await Permission.manageExternalStorage.request();
    if (manageStatus == PermissionStatus.granted) {
      print("Manage External Storage permission granted");
    } else if (manageStatus == PermissionStatus.denied) {
      print("Manage External Storage permission denied");
    }
  }

  Future<void> requestNotificationPermission() async {
    print("Requesting notification permission");
    if (_notificationPermissionStatus != PermissionStatus.granted) {
      _notificationPermissionStatus = await Permission.notification.request();
      print("Notification permission status: $_notificationPermissionStatus");
      notifyListeners();
    }
  }
}
