import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatopia/pages/Restaurant/search_result_class.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/utilities/cache_manger.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'user_res_page.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.query});
  final String query;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  bool isLoading = true;
  List<SearchResult> results = [];
  void getResults() async {
    results = await Db().searchRestauarants(widget.query);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CustomShimmer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: results.isEmpty ? 1 : results.length + 1,
              itemBuilder: (context, eIndex) {
                int index = eIndex - 1;

                if (results.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 120,
                          color: appGreen,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '(Please try a different search term)',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                } else if (eIndex == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        '${results.length} Search Results for "${widget.query}"',
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'ubuntu-bold',
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserRestauarantPage(data: {
                                  'id': results[index].restDoc['id'],
                                  'restaurant':
                                      results[index].restDoc['restaurant'],
                                  'image': results[index].restDoc['ImageURL'],
                                  'description':
                                      results[index].restDoc['description'],
                                })));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: index == results.length - 1 ? 0 : 20),
                    constraints: const BoxConstraints(minHeight: 140),
                    padding: const EdgeInsets.all(10),
                    // height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 3)),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: results[index].restDoc['ImageURL'],
                          cacheManager: appCacheManager,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Shimmer(
                              child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                            ),
                          )),
                          errorWidget: (context, url, error) => Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.error)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            results[index].restDoc['restaurant'],
                            style: const TextStyle(
                                fontFamily: 'Ubuntu-bold',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            results[index].restDoc['description'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        buildSearchItemList(results, index),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}

Widget buildSearchItemList(List<SearchResult> results, int index) {
  if (results[index].items.isEmpty) {
    return const SizedBox();
  }
  return Container(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    ),
    height: 80,
    padding: const EdgeInsets.only(top: 10),
    margin: const EdgeInsets.only(top: 10),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (var item in results[index].items)
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: item.ImageURL,
                  cacheManager: appCacheManager,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Shimmer(
                      child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                  )),
                  errorWidget: (context, url, error) => Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.error)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                            fontFamily: 'Ubuntu-bold',
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        'Rs ${item.price}',
                        style: const TextStyle(
                            fontFamily: 'Ubuntu-bold',
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      ],
    ),
  );
}
