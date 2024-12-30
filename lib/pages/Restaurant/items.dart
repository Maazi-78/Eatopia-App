import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatopia/utilities/cache_manger.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';

class Item {
  String name;
  String ImageURL;
  double price;
  String desc;
  String category;
  String itemId;
  Map<String, dynamic> addOns;

  Item(
      {required this.itemId,
      required this.name,
      required this.ImageURL,
      required this.price,
      required this.desc,
      required this.category,
      required this.addOns});

  Widget buildItemCard() {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'ubuntu-bold',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  'RS. ${price.toInt()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'ubuntu-bold',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          CachedNetworkImage(
            imageUrl: ImageURL,
            cacheManager: appCacheManager,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            height: 100,
            width: 100,
            placeholder: (context, url) => const CustomShimmer(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
