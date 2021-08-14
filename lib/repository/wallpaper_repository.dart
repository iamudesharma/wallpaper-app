import 'package:http/http.dart' as http;
import 'package:wallpaper_app/key.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';

const String url = 'https://api.pexels.com/v1/curated?page=2&per_page=40';

class Repository {
  static Future<Wallpaper?> getWallpaper() async {
    http.Response response = await http.get(Uri.parse(url), headers: {
      "Authorization": "${Api.key}",
      "content-type": "application/json; charset=utf-8",
      "X-Ratelimit-Limit": "20000",
      "X-Ratelimit-Remaining": "19684",
      "X-Ratelimit-Reset": "1590529646"
    });

    try {
      if (response.statusCode == 200) {
        var jsonString = response.body;
        final wallpaper = wallpaperFromJson(jsonString);
        print('Length of wallpaper' + wallpaper.photos!.length.toString());
        return wallpaper;
      }
    } catch (e) {
      throw 'wallpaper not found';
    }
  }
}
