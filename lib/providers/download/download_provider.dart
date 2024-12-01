import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:id3_codec/id3_codec.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadProvider with ChangeNotifier{

  final dio = Dio();
  Map<String, double> _progress = {};
  List<SongMetadata> _recentDownloads = [];

  Map<String, double> get progress => _progress;
  List<SongMetadata> get recentDownloads => _recentDownloads;

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();


  Future<void> downloadSong(SongMetadata songData) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'download_channel',
        'Download Notifications',
        channelDescription: 'Notifications for ongoing downloads',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
        onlyAlertOnce: true, // Prevents repeated sound notifications
      );
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      // Show the initial notification
      int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Unique ID for each notification
      await notificationsPlugin.show(
        notificationId,
        'Downloading ${songData.fileName}',
        'Starting download...',
        platformChannelSpecifics,
      );

      if (!await Permission.manageExternalStorage.request().isGranted) {
        print("Storage permission denied");
        await Permission.storage.request();
        return;
      }

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/watchIt/Songs");
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        directory = Directory("${directory.path}/watchIt/Songs");
      }

      if (!(await directory!.exists())) {
        await directory.create(recursive: true);
      }

      if (!songData.fileName.contains('.')) {
        songData.fileName = "${songData.fileName}.mp3";
      }

      final songFilePath = '${directory.path}/${songData.fileName}';
      final thumbnailFilePath = '${directory.path}/thumbnail.jpg';

      // Track progress
      _progress[songData.fileName] = 0.0;
      notifyListeners();

      final songResponse = await dio.download(
        songData.downloadUrl!,
        songFilePath,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            double progress = received / total;

            // Update progress in the notification
            await notificationsPlugin.show(
              notificationId,
              'Downloading ${songData.fileName}',
              '${(progress * 100).toStringAsFixed(0)}% completed',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  'download_channel',
                  'Download Notifications',
                  channelDescription: 'Notifications for ongoing downloads',
                  importance: Importance.high,
                  priority: Priority.high,
                  showWhen: false,
                  onlyAlertOnce: true,
                  progress: (progress * 100).toInt(),
                  maxProgress: 100,
                ),
              ),
            );

            // Update progress in the UI
            _progress[songData.fileName] = progress;
            notifyListeners();
          }
        },
      );

      if (songResponse.statusCode != 200) {
        print('Failed to download song: ${songResponse.statusCode}');
        return;
      }
      print('Song downloaded successfully: $songFilePath');

      // Download thumbnail
      final thumbnailResponse = await dio.download(
        songData.songThumbnailUrl,
        thumbnailFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("Thumbnail Download Progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      if (thumbnailResponse.statusCode == 200) {
        await addID3Tags(songFilePath, thumbnailFilePath, songData);
      }

      // Remove progress and update UI
      _progress.remove(songData.fileName);
      _recentDownloads.add(songData);
      notifyListeners();

      // Show a completion notification
      await notificationsPlugin.show(
        notificationId,
        'Download Complete',
        '${songData.fileName} has been downloaded successfully!',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Error during download: $e');
    }
  }

  Future<void> addID3Tags(
      String songFilePath, String thumbnailFilePath, SongMetadata songData) async {
    try {
      // Read thumbnail file as bytes
      if (!File(thumbnailFilePath).existsSync()) {
        print('Thumbnail file does not exist: $thumbnailFilePath');
        return;
      }
      final headerImage = await File(thumbnailFilePath).readAsBytes();

      // Read the song file as bytes
      if (!File(songFilePath).existsSync()) {
        print('Song file does not exist: $songFilePath');
        return;
      }
      final bytes = await File(songFilePath).readAsBytes();
      final mutableBytes = bytes.toList();

      // Encode ID3 tags
      final encoder = ID3Encoder(Uint8List.fromList(mutableBytes));
      final resultBytes = encoder.encodeSync(
        MetadataV2p3Body(
          title: songData.fileName,
          artist: songData.artist,
          album: songData.album,
          imageBytes: headerImage, // Attach the thumbnail image
        ),
      );

      // Write back the encoded song file with updated metadata
      final songFile = File(songFilePath);
      await songFile.writeAsBytes(resultBytes, mode: FileMode.write);

      print('ID3 tags added successfully to: $songFilePath');
    } on Exception catch (e) {
      print('Error adding ID3 tags: $e');
    }
  }

}



class SongMetadata {
  String fileName;
  String filePath;
  String artist;
  String album;
  String songThumbnailUrl;
  String downloadUrl; // Added field for artwork

  SongMetadata( {
    required this.fileName,
    required this.filePath,
    required this.artist,
    required this.album,
    required this.songThumbnailUrl,
    required this.downloadUrl,// Added to constructor
  });
}