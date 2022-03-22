import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/page/wallpaper_preview_page.dart';
import 'package:wallpaper_app/repository/wallpaper_repository.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchProvider = FutureProvider((ref) => Repository.getSeacrh(query));

    return Consumer(
      builder: (context, watch, child) {
        final data = watch(searchProvider);
        return Scaffold(
          body: FutureBuilder(
            future: Repository.getSeacrh(query),
            // initialData: InitialData,
            builder:
                (BuildContext context, AsyncSnapshot<WallpaperModel?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final _data = snapshot.data?.photos;

                  return CustomScrollView(
                    slivers: [
                      SliverGrid(
                        delegate:
                            SliverChildBuilderDelegate((context, int index) {
                          final _wallpaper = _data![index];

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        WallpaperPrviewPage(photo: _wallpaper),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: _wallpaper.src!.large!,
                                  filterQuality: FilterQuality.high,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                          child: CircularProgressIndicator()),
                                ),
                              ),
                            ),
                          );
                        }, childCount: _data!.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.5,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                      ),
                    ],
                  );
                }
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
