import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:share/share.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/untils/untils.dart';
import 'package:wallpaper_app/widgets/Side_icon_widget.dart';
import 'package:wallpaper_app/widgets/apply_button_widget.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperPrviewPage extends StatefulWidget {
  final Photo photo;

  const WallpaperPrviewPage({Key? key, required this.photo}) : super(key: key);

  @override
  _WallpaperPrviewPageState createState() => _WallpaperPrviewPageState();
}

class _WallpaperPrviewPageState extends State<WallpaperPrviewPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  bool isWallpaperSettings = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: '${widget.photo.id}',
              child: PinchZoom(
                maxScale: 3.5,
                onZoomStart: () {
                  print('Start zooming');
                },
                onZoomEnd: () {
                  print('Stop zooming');
                },
                child: CachedNetworkImage(
                  placeholder: (_, value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  imageUrl: widget.photo.src!.large2X!,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  scaffoldKey.currentState!.showBottomSheet(
                    (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Applybutton(
                            title: 'Set to Lock screen',
                            onTap: () async {
                              await Untils.setWallpaper(
                                widget.photo.src!.portrait!,
                                WallpaperManagerFlutter.LOCK_SCREEN,
                              ).then((value) {
                                Navigator.pop(context);
                                Untils.snackBar('Wallpaper Applied', context);
                              });
                            }),
                        Applybutton(
                          title: 'Set to Home Screen',
                          onTap: () {
                            Untils.setWallpaper(widget.photo.src!.large2X!,
                                    WallpaperManagerFlutter.HOME_SCREEN)
                                .then(
                              (value) {
                                Navigator.pop(context);
                                Untils.snackBar('Wallpaper Applied', context);
                              },
                            );
                          },
                        ),
                        Applybutton(
                          title: 'Set to Both',
                          onTap: () {
                            Untils.setWallpaper(
                              widget.photo.src!.portrait!,
                              WallpaperManagerFlutter.BOTH_SCREENS,
                            ).then(
                              (value) {
                                Navigator.pop(context);
                                Untils.snackBar('Wallpaper Applied', context);
                              },
                            );
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
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              left: 10,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SideIcons(
                // icon: Icons.picture_as_pdf_outlined,
                icon: Icons.share,
                onPressed: () {
                  // Share.
                  Share.share(widget.photo.url!);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              right: 10,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SideIcons(
                icon: Icons.download,
                onPressed: () async {
                  await Untils.askstoragePermission();
                  Untils.imageDownload(widget.photo.src!.original!);

                  Untils.snackBar('Downloaded', context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
