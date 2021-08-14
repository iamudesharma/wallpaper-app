// import 'package:cache_image/cache_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file/src/interface/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pexels_null_safety/pexels_null_safety.dart';

import 'package:wallpaper_app/key.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/provider/wallpaper_provider.dart';
import 'package:wallpaper_app/repository/wallpaper_repository.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

void main() async {
  PexelsClient(Api.key).getPhoto().then((value) => print(value?.url));
  await Repository.getWallpaper().then(
    (value) => print(
      value!.photos?.elementAt(0).id,
    ),
  );
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final data = watch(wallpaperProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Wallpaper App',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
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

class WallpaperPage extends StatelessWidget {
  final Wallpaper wallpaper;
  const WallpaperPage({
    Key? key,
    required this.wallpaper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
      onRefresh: () async {
        await context.refresh(wallpaperProvider);
      },
      child: GridView.builder(
        itemCount: wallpaper.photos?.length,
        // shrinkWrap: true,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemBuilder: (context, index) {
          final _wallpaper = wallpaper.photos?[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WallpaperPrviewPage(photo: _wallpaper!),
                  ),
                );
              },
              child: Hero(
                tag: '${_wallpaper?.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: _wallpaper!.src!.medium!,
                    filterQuality: FilterQuality.high,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}

class WallpaperPrviewPage extends StatefulWidget {
  // const WallpaperPrviewPage({Key? key}) : super(key: key);
  final Photo photo;

  const WallpaperPrviewPage({Key? key, required this.photo}) : super(key: key);

  @override
  _WallpaperPrviewPageState createState() => _WallpaperPrviewPageState();
}

class _WallpaperPrviewPageState extends State<WallpaperPrviewPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> setWallpaper(String url, int location) async {
    // Image url

    File cachedimage =
        await DefaultCacheManager().getSingleFile(url); //image file

    //Choose screen type

    WallpaperManagerFlutter().setwallpaperfromFile(cachedimage, location);
  }

  bool isWallpaperSettings = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: '${widget.photo.id}',
              child: CachedNetworkImage(
                placeholder: (_, value) {
                  return Center(child: CircularProgressIndicator());
                },
                imageUrl: widget.photo.src!.portrait!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (isWallpaperSettings == true)
            Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Settings',
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30.0,
            ),
            child: Align(
                alignment: Alignment.bottomCenter,
                // bottom: 0.0,
                child: GestureDetector(
                  onTap: () async {
// ScaffoldMessenger.of(context)
// .
                    scaffoldKey.currentState!.showBottomSheet(
                      (context) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Applybutton(
                              title: 'Set to Lock screen',
                              onTap: () async {
                                await setWallpaper(widget.photo.src!.portrait!,
                                        WallpaperManagerFlutter.LOCK_SCREEN)
                                    .then((value) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Wallpaper Applied'),
                                    ),
                                  );
                                });
                              }),
                          Applybutton(
                            title: 'Set to Home Screen',
                            onTap: () {
                              setWallpaper(widget.photo.src!.portrait!,
                                      WallpaperManagerFlutter.HOME_SCREEN)
                                  .then((value) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Wallpaper Applied'),
                                  ),
                                );
                              });
                            },
                          ),
                          Applybutton(
                            title: 'Set to Lock screen',
                            onTap: () {
                              setWallpaper(
                                widget.photo.src!.portrait!,
                                WallpaperManagerFlutter.BOTH_SCREENS,
                              ).then((value) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Wallpaper Applied'),
                                  ),
                                );
                              });
                            },
                          )
                        ],
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
                      ),
                    );
                  },
                  child: Container(
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.black38,
                        border: Border.all(
                          color: Colors.white70.withOpacity(0.3),
                          width: 1.5,
                        )),
                  ),
                )),
          )
        ],
      )),
    );
  }
}

class Applybutton extends StatelessWidget {
  const Applybutton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final void Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }
}

// Column(
//                                 // mainAxisSize: MainAxisSize.min,

                                //                               ),
