import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/page/home.dart';

void main() async {
  // PexelsClient(Api.key).then((value) => print(value?.url));

  // await Repository.getWallpaper().then(
  //   (value) => print(
  //     value!.photos?.elementAt(0).id,
  //   ),

  // );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
