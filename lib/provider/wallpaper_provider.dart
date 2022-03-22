import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/repository/wallpaper_repository.dart';


final pageNoProvider = Provider((_) {
  Random random = Random();
  int value = random.nextInt(15);
  return value;
});


final wallpaperProvider = FutureProvider(
  (ref) => Repository.getWallpaper(ref.read(pageNoProvider)),
);
