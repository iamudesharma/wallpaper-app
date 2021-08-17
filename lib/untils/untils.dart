import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class Untils {
  static snackBar(String title, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );
  }

  static Future<void> setWallpaper(String url, int location) async {
    File cachedimage = await DefaultCacheManager().getSingleFile(url);
    WallpaperManagerFlutter().setwallpaperfromFile(cachedimage, location);
  }

  static ask() async {
    var stautus = await Permission.storage.status;
    if (stautus.isDenied) {
      Permission.storage.request();
    } else {
      return;
    }
  }

  static imageDownload(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
    );
    print(result);
  }
}
