import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/page/wallpaper_page.dart';
import 'package:wallpaper_app/provider/wallpaper_provider.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final data = watch(wallpaperProvider);
    return Scaffold(
      body: data.when(
        data: (data) {
          return WallpaperPage(wallpaper: data!);
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              '${error.toString()}',
            ),
          );
        },
      ),
    );
  }
}
