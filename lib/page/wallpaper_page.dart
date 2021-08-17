import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pexels_null_safety/pexels_null_safety.dart';
import 'package:search_page/search_page.dart';
import 'package:wallpaper_app/key.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/page/wallpaper_preview_page.dart';
import 'package:wallpaper_app/provider/wallpaper_provider.dart';

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
          context.refresh(intProvider);

          context.read(intProvider);
          await context.refresh(wallpaperProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () => showSearch(
                    context: context,
                    delegate: SearchPage<Photo>(
                      items: wallpaper.photos!,
                      searchLabel: 'Search people',
                      suggestion: Center(
                        child: Text('Filter people by name, surname or age'),
                      ),
                      failure: Center(
                        child: Text('No person found :('),
                      ),
                      filter: (person) => [
                        // PexelsClient(Api.key).getPhoto(id: person.id),
                        person.photographer,
                        person.id.toString(),
                        person.photographerId.toString(),
                      ],
                      builder: (person) => Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Container(
                            height: 250,
                            width: 250,
                            child: Image.network(
                              person.src!.medium!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.search,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ],
              // pinned: true,
              // floating: true,
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Wallpaper ',
                    style: TextStyle(
                      color: Paint().color = Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    )),
                TextSpan(
                    text: 'Hub',
                    style: TextStyle(
                      color: Paint().color = Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ))
              ])),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, int index) {
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
                          builder: (_) =>
                              WallpaperPrviewPage(photo: _wallpaper!),
                        ),
                      );
                    },
                    child: Hero(
                      tag: '${_wallpaper?.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: _wallpaper!.src!.large!,
                          filterQuality: FilterQuality.high,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: wallpaper.photos?.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
