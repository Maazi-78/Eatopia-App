import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatopia/pages/Restaurant/items.dart';
import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'add_items.dart';
import 'edit_item.dart';

class ResItemsPage extends StatefulWidget {
  const ResItemsPage({super.key});

  @override
  State<ResItemsPage> createState() => _ResItemsPageState();
}

class _ResItemsPageState extends State<ResItemsPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  Map<String, List<Item>> ctgItems = {};

  Future<void> addCategory(String text) async {
    final doc = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(AuthServices().auth.currentUser!.uid);
    await doc.update({
      "Categories": FieldValue.arrayUnion([text])
    });

    setState(() {
      ctgItems[text] = [];
    });
  }

  void getCtgItems() async {
    ctgItems = await Db().getCtgItems(AuthServices().auth.currentUser!.uid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCtgItems();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? CustomShimmer(
            height: MediaQuery.of(context).size.height,
          )
        : Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: ctgItems.keys.toList().length + 1,
                itemBuilder: (context, mainIdx) {
                  if (mainIdx < 1) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: buildCreateCtgAlert,
                                );
                              },
                              child: const Text(
                                'Create New Category',
                                style: TextStyle(
                                    fontFamily: 'ubuntu-bold',
                                    color: Colors.black,
                                    fontSize: 16),
                              )),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                Item? newItem = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddItemPage(
                                              categories:
                                                  ctgItems.keys.toList(),
                                            )));
                                if (newItem != null) {
                                  setState(() {
                                    ctgItems[newItem.category]!.add(newItem);
                                  });
                                }
                              },
                              child: const Text(
                                'Add New Item',
                                style: TextStyle(
                                    fontFamily: 'ubuntu-bold',
                                    color: Colors.black,
                                    fontSize: 16),
                              )),
                        ],
                      ),
                    );
                  }
                  int index = mainIdx - 1;
                  final ctg = ctgItems.keys.toList()[index];
                  return ExpansionTile(
                    backgroundColor: Colors.white,
                    maintainState: true,
                    title: Row(
                      children: [
                        Text(ctg,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'ubuntu-bold',
                              color: Colors.black,
                            )),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return buildEditCtg(
                                        context, ctgItems, index);
                                  });
                              setState(() {});
                            },
                            icon: const Icon(Icons.edit, color: Colors.black)),
                      ],
                    ),
                    children: ctgItems[ctg]!
                        .map((item) => InkWell(
                            onTap: () async {
                              List? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditItemPage(
                                            item: item,
                                            categories: ctgItems.keys.toList(),
                                          )));
                              if (result == null) {
                                return;
                              }
                              Item changedItem = result[0];
                              bool isDeleted = result[1];
                              if (!isDeleted) {
                                setState(() {
                                  updateItem(changedItem);
                                });
                              } else {
                                setState(() {
                                  ctgItems[changedItem.category]!.removeWhere(
                                      (element) =>
                                          element.itemId == changedItem.itemId);
                                });
                              }
                            },
                            child: item.buildItemCard()))
                        .toList(),
                  );
                }),
          );
  }

  void updateItem(Item changedItem) {
    for (int i = 0; i < ctgItems[changedItem.category]!.length; i++) {
      if (ctgItems[changedItem.category]![i].itemId == changedItem.itemId) {
        ctgItems[changedItem.category]![i] = changedItem;
        break;
      }
    }
  }

  Widget buildCreateCtgAlert(BuildContext context) {
    final categoryControl = TextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Create Category'),
      content: TextField(
        controller: categoryControl,
        decoration: const InputDecoration(hintText: 'Category Name'),
      ),
      actions: [
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('CREATE'),
          onPressed: () async {
            await addCategory(categoryControl.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

Widget buildEditCtg(
    BuildContext context, Map<String, List<Item>> ctgItems, int index) {
  bool isEnabled = true;
  final categories = ctgItems.keys.toList();
  final categoryControl = TextEditingController();
  categoryControl.text = categories[index];
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: const Text('Edit Category'),
    content: TextField(
      controller: categoryControl,
      decoration: const InputDecoration(hintText: 'Category Name'),
    ),
    actions: [
      TextButton(
        child: const Text('CANCEL'),
        onPressed: () {
          if (!isEnabled) {
            return;
          }
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: const Text('EDIT'),
        onPressed: () async {
          if (!isEnabled) {
            return;
          }
          String oldName = categories[index];
          categories[index] = categoryControl.text;
          Map<String, List<Item>> newCtgItems = {};
          for (String ctg in categories) {
            newCtgItems[ctg] = [];
          }
          for (String ctg in ctgItems.keys) {
            if (ctg == oldName) {
              newCtgItems[categoryControl.text] = ctgItems[ctg]!;
            } else {
              newCtgItems[ctg] = ctgItems[ctg]!;
            }
          }
          //Change the orignal Map
          ctgItems.clear();
          ctgItems.addAll(newCtgItems);

          for (Item item in ctgItems[categoryControl.text]!) {
            item.category = categoryControl.text;
            final doc = FirebaseFirestore.instance
                .collection('Restaurants')
                .doc(AuthServices().auth.currentUser!.uid)
                .collection('Items')
                .doc(item.itemId);

            await doc.update({'category': categoryControl.text});
          }
          final doc = FirebaseFirestore.instance
              .collection('Restaurants')
              .doc(AuthServices().auth.currentUser!.uid);
          categories[index] = categoryControl.text;
          await doc.update({
            "Categories": categories,
          });
          isEnabled = true;
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
