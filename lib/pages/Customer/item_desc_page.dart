import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatopia/pages/Restaurant/items.dart';
import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/utilities/cache_manger.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';

class ItemDescPage extends StatefulWidget {
  const ItemDescPage({super.key, required this.item, required this.restId});
  final Item item;
  final String restId;

  @override
  State<ItemDescPage> createState() => _ItemDescPageState();
}

class _ItemDescPageState extends State<ItemDescPage> {
  Map<String, dynamic> data = {};
  final spInstrCOntroller = TextEditingController();
  int itemCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180.0),
        child: Stack(children: [
          CachedNetworkImage(
            imageUrl: widget.item.ImageURL,
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
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: ListView(
          children: [
            Text(
              widget.item.name,
              style: const TextStyle(fontFamily: 'ubuntu-bold', fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Rs ${widget.item.price}',
              style: const TextStyle(fontSize: 18, fontFamily: 'ubuntu-bold'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(widget.item.desc),
            const SizedBox(
              height: 30,
            ),

            //Add ons section
            widget.item.addOns.isNotEmpty
                ? AddOnWidget(addOns: widget.item.addOns)
                : const SizedBox(),
            const Text(
              'Special Instructions',
              style: TextStyle(fontSize: 18, fontFamily: 'ubuntu-bold'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
                'Any additional Information you want to provide about your order you can write here (Optional)'),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLength: 200,
              controller: spInstrCOntroller,
              maxLines: 3,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                  label: const Text('Special Instructions'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            InkWell(
              onTap: () {
                if (itemCount != 1) {
                  setState(() {
                    itemCount--;
                  });
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: itemCount != 1 ? appGreen : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              '$itemCount',
              style: const TextStyle(fontSize: 20, fontFamily: 'ubuntu-bold'),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  itemCount++;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: appGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  //Showing A confirmation dialog
                  if (AuthServices().auth.currentUser != null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: const Text('Item Added to Cart'),
                            content: const Text(
                                'Your item has been added to the cart'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                    await Db().addOrderItemToCart(
                        AuthServices().auth.currentUser!.uid,
                        {
                          'name': widget.item.name,
                          'basePrice': widget.item.price,
                          'quantity': itemCount,
                          'spcInstr': spInstrCOntroller.text,
                          'addOns': data,
                          'restId': widget.restId,
                          'itemId': widget.item.itemId,
                        },
                        setState: setState);
                  } else {
                    //Showing A dialog to Say user to login
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title:
                                const Text('PLease Login to Add Items to cart'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 15, fontFamily: 'ubuntu-bold'),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AddOnWidget extends StatefulWidget {
  const AddOnWidget({super.key, required this.addOns});
  final Map<String, dynamic> addOns;

  @override
  State<AddOnWidget> createState() => _AddOnWidgetState();
}

class _AddOnWidgetState extends State<AddOnWidget> {
  List<bool> checked = [];
  List<String> addOnsName = [];

  @override
  Widget build(BuildContext context) {
    checked = List.filled(widget.addOns.length, false);
    addOnsName = widget.addOns.keys.toList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              const Text(
                'Add-ons (Optional)',
                style: TextStyle(fontSize: 18, fontFamily: 'ubuntu-bold'),
              ),
            ] +
            widget.addOns.entries.map((e) {
              return Row(
                children: [
                  StatefulBuilder(builder: (context, setState) {
                    return Checkbox(
                        value: checked[addOnsName.indexOf(e.key)],
                        onChanged: (value) {
                          setState(() {
                            checked[addOnsName.indexOf(e.key)] = value!;
                          });
                        });
                  }),
                  Text(
                    e.key,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  Text(
                    '+ Rs ${e.value}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              );
            }).toList() +
            [const SizedBox(height: 20)]);
  }
}
