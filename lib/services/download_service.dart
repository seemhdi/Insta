import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<String?> downloadMedia(String url, String filename) async {
    try {
      // Request permissions
      if (!await requestPermissions()) {
        return null;
      }

      // Get download directory
      final directory = await getDownloadsDirectory();
      if (directory == null) return null;

      final filepath = '${directory.path}/$filename';

      // Download file
      await _dio.download(
        url,
        filepath,
        onReceiveProgress: (received, total) {
          print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
        },
      );

      return filepath;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }

  Future<String?> downloadImage(String imageUrl, String username, {String? postId}) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'insta_${username}_$postId\_$timestamp.jpg';
      return await downloadMedia(imageUrl, filename);
    } catch (e) {
      print('Download image error: $e');
      return null;
    }
  }

  Future<String?> downloadVideo(String videoUrl, String username, {String? postId}) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'insta_${username}_$postId\_$timestamp.mp4';
      return await downloadMedia(videoUrl, filename);
    } catch (e) {
      print('Download video error: $e');
      return null;
    }
  }

  Future<List<String>?> downloadMultipleMedia(
    List<String> urls,
    List<String> types,
    String username, {
    String? postId,
  }) async {
    try {
      final downloadedPaths = <String>[];

      for (int i = 0; i < urls.length; i++) {
        final url = urls[i];
        final type = types[i];
        String? path;

        if (type == 'image') {
          path = await downloadImage(url, username, postId: postId);
        } else if (type == 'video') {
          path = await downloadVideo(url, username, postId: postId);
        }

        if (path != null) {
          downloadedPaths.add(path);
        }
      }

      return downloadedPaths.isNotEmpty ? downloadedPaths : null;
    } catch (e) {
      print('Download multiple error: $e');
      return null;
    }
  }
}
