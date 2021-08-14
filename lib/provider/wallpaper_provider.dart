import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/repository/wallpaper_repository.dart';

final wallpaperProvider = FutureProvider(
  (ref) => Repository.getWallpaper(),
);
