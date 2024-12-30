import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatopia/utilities/cache_manger.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';

class ReviewInfoPage extends StatefulWidget {
  const ReviewInfoPage({super.key, required this.resData});

  final Map<String, dynamic> resData;

  @override
  State<ReviewInfoPage> createState() => _ReviewInfoPageState();
}

class _ReviewInfoPageState extends State<ReviewInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: Stack(children: [
          CachedNetworkImage(
            imageUrl: widget.resData['image'],
            cacheManager: appCacheManager,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            placeholder: (context, url) => const CustomShimmer(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: SafeArea(
              child: FloatingActionButton.small(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: appGreen,
                  )),
            ),
          ),
        ]),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(widget.resData['restaurant'],
                  style: const TextStyle(
                      fontFamily: 'ubuntu-bold',
                      color: Colors.black,
                      fontSize: 17)),
              const SizedBox(height: 5),
              SelectableText(widget.resData['address'],
                  style: const TextStyle(
                      fontFamily: 'ubuntu', color: Colors.black, fontSize: 12)),
              const SizedBox(height: 5),
              const Text(
                'Contact',
                style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 17),
              ),
              const SizedBox(height: 5),
              SelectableText(widget.resData['email'],
                  style: const TextStyle(
                      fontFamily: 'ubuntu', color: Colors.black, fontSize: 12)),
              const SizedBox(height: 5),
              SelectableText(widget.resData['phone'],
                  style: const TextStyle(
                      fontFamily: 'ubuntu', color: Colors.black, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            //widget.resData['reviews'][index]['user'],
                            'User',
                            style: TextStyle(
                                fontFamily: 'ubuntu-bold',
                                color: Colors.black,
                                fontSize: 17)),
                        SizedBox(height: 5),
                        Text(
                            //widget.resData['reviews'][index]['review'],
                            'This is a Sample Review',
                            style: TextStyle(
                                fontFamily: 'ubuntu',
                                color: Colors.black,
                                fontSize: 12)),
                      ],
                    ),
                  );
                }),
          ),
        )
      ]),
    );
  }
}
