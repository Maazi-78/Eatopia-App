import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatopia/pages/Customer/dine_in.dart';
import 'package:eatopia/utilities/cache_manger.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:flutter/material.dart';

import '../../utilities/custom_shimmer.dart';

class Res_Dine extends StatefulWidget {
  const Res_Dine({Key? key}) : super(key: key);
  @override
  State<Res_Dine> createState() => _Res_DineState();
}

class _Res_DineState extends State<Res_Dine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants For Dining'),
        backgroundColor: appGreen,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Restaurants').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var res = snapshot.data!.docs[index];
              final doc = snapshot.data!.docs[index];
              String resDesc = (doc.data() as Map<String, dynamic>)
                      .containsKey('description')
                  ? doc['description']
                  : '';
              String imageURL =
                  (doc.data() as Map<String, dynamic>).containsKey('ImageURL')
                      ? doc['ImageURL']
                      : '';
              bool isOpen =
                  (doc.data() as Map<String, dynamic>).containsKey('isOpen')
                      ? doc['isOpen']
                      : false;
              String address = doc['address'];
              return Visibility(
                visible: isOpen,
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  child: InkWell(
                    onTap: () {
                      // navigate user res page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => const Res_Dine()));
                              builder: (context) => DineInPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageURL,
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
                            placeholder: (context, url) =>
                                const CustomShimmer(),
                            errorWidget: (context, url, error) => Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.error)),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            res['restaurant'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            res['address'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
