import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/utilities/cache_manger.dart';

import 'package:eatopia/utilities/custom_shimmer.dart';

import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatopia/services/auth_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eatopia/pages/Restaurant/res_items_page.dart';
import 'package:eatopia/pages/Restaurant/res_more.dart';
import 'package:eatopia/pages/Restaurant/res_order.dart';

class ResHome extends StatefulWidget {
  const ResHome({super.key});

  @override
  State<ResHome> createState() => _ResHomeState();
}

class _ResHomeState extends State<ResHome> {
  late Size scrSize;
  int selectedIndex = 0;
  List<String> headings = ['Home', 'Manage Items', 'Orders', 'More'];
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    scrSize = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) => setState(() {
                selectedIndex = value;
                pageController.animateToPage(value,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }),
          showUnselectedLabels: false,
          elevation: 5,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.discount),
              label: 'Orders',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'More'),
          ]),
      appBar: AppBar(
        title: Text(headings[selectedIndex]),
      ),
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: const [
            ResMainHome(),
            ResItemsPage(),
            ResOrders(),
            ResMore(),
          ]),
    );
  }
}

class ResMainHome extends StatefulWidget {
  const ResMainHome({
    super.key,
  });

  @override
  State<ResMainHome> createState() => _ResMainHomeState();
}

class _ResMainHomeState extends State<ResMainHome>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: ListView(
        children: const [
          //Restaurant Name Display
          RestOpenToggle(),
          SizedBox(height: 20),
          //VIew Orders Button

          RestaurantNameWidget(),
          SizedBox(height: 20),
          AddDescriptionWidget(),
          SizedBox(
            height: 20,
          ),
          //Image Select Widget
          ImageSelectWidget(),
        ],
      ),
    );
  }
}

class RestOpenToggle extends StatefulWidget {
  const RestOpenToggle({super.key});

  @override
  State<RestOpenToggle> createState() => _RestOpenToggleState();
}

class _RestOpenToggleState extends State<RestOpenToggle> {
  bool isSwitched = false;
  bool isLoading = true;
  void loadStatus() async {
    String uid = AuthServices().auth.currentUser!.uid;
    bool status = await Db().getIsOpenStatus(uid);
    setState(() {
      isSwitched = status;
      isLoading = false;
    });
  }

  Future<bool> _showConfirmationDialog(String text) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Confirm"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: isLoading
          ? const CustomShimmer()
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    isSwitched
                        ? 'Your Restaurant is Live !'
                        : 'Your Restaurant is Closed',
                    style: const TextStyle(
                        fontFamily: 'ubuntu-bold',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Switch(
                  onChanged: (value) async {
                    bool confirm = await _showConfirmationDialog(isSwitched
                        ? 'Are you Sure you want to Close Restaurant ?'
                        : 'Are you Sure you want to Open Restaurant ?');
                    if (confirm) {
                      setState(() {
                        isSwitched = value;
                      });
                      String uid = AuthServices().auth.currentUser!.uid;
                      await Db().toggleOpenStatus(uid, value);
                    }
                  },
                  value: isSwitched,
                  activeColor: Colors.white,
                  activeTrackColor: const Color.fromARGB(255, 58, 255, 67),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.red,
                ),
              ],
            ),
    );
  }
}

class AddDescriptionWidget extends StatefulWidget {
  const AddDescriptionWidget({super.key});

  @override
  State<AddDescriptionWidget> createState() => _AddDescriptionWidgetState();
}

class _AddDescriptionWidgetState extends State<AddDescriptionWidget> {
  late Size scrSize;
  String description = "";
  bool isEnabled = false;
  bool isLoading = true;
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> getDescription() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection('Restaurants').doc(uid);
    final data = await doc.get();
    try {
      setState(() {
        description = data.get('description');
        controller.text = description;
      });
    } catch (e) {}

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDescription();
  }

  @override
  Widget build(BuildContext context) {
    scrSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      width: scrSize.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Description: ',
                  style: TextStyle(
                      fontFamily: 'ubuntu-bold',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    isEnabled = !isEnabled;
                  });
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,

            //Close the text field when tap outside copilot
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            maxLines: 3,
            enabled: isEnabled,
            maxLength: 50,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              labelText: 'Add Description',
            ),
          ),

          //Save Button
          if (isEnabled)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                setState(() {
                  description = controller.text;
                });
                final String uid = AuthServices().auth.currentUser!.uid;
                final doc = FirebaseFirestore.instance
                    .collection('Restaurants')
                    .doc(uid);
                await doc.update({"description": description});
                setState(() {
                  isEnabled = false;
                });
              },
              child: const Text('Save'),
            ),
        ],
      ),
    );
  }
}

class RestaurantNameWidget extends StatefulWidget {
  const RestaurantNameWidget({super.key});

  @override
  State<RestaurantNameWidget> createState() => _RestaurantNameWidgetState();
}

class _RestaurantNameWidgetState extends State<RestaurantNameWidget> {
  late Size scrSize;
  late String resName = "";
  bool isLoading = true;

  Future<void> changeResName() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection('Restaurants').doc(uid);
    final String lower = resName.toLowerCase();
    List<String> split = lower.split(RegExp(r'[\s,-]'));

    await doc.update({
      "restaurant": resName,
      "restaurantLower": lower,
      "restaurantArray": split
    });

    setState(() {});
  }

  Future<void> getResName() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection('Restaurants').doc(uid);
    final data = await doc.get();
    setState(() {
      resName = data.get('restaurant');
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getResName();
  }

  @override
  Widget build(BuildContext context) {
    scrSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      width: scrSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Center(
        child: isLoading
            ? const CustomShimmer()
            : Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      resName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'ubuntu-bold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final TextEditingController conroller =
                          TextEditingController();
                      conroller.text = resName;
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: const Text('Change Restaurant Name'),
                          content: TextField(
                            controller: conroller,
                            decoration: const InputDecoration(
                              hintText: 'Enter new name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                resName = conroller.text;
                                await changeResName();
                                Navigator.pop(context, resName);
                              },
                              child: const Text('Change'),
                            ),
                          ],
                        ),
                      );
                      await changeResName();
                      setState(() {});
                      conroller.dispose();
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
      ),
    );
  }
}

class ImageSelectWidget extends StatefulWidget {
  const ImageSelectWidget({super.key});

  @override
  State<ImageSelectWidget> createState() => _ImageSelectWidgetState();
}

class _ImageSelectWidgetState extends State<ImageSelectWidget> {
  Future<void> loadImage() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection('Restaurants').doc(uid);
    final data = await doc.get();
    isLoading = true;
    try {
      final url = data.get('ImageURL');
      setState(() {
        imageURL = url;
        isImageLoaded = true;
      });
    } catch (e) {
      isImageLoaded = false;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> imagePicker() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile = File(picked.path);
      setState(() {
        isImageLoaded = true;
      });

      final String uid = AuthServices().auth.currentUser!.uid;
      // Get the file extension from the file path
      final String fileExtension = p.extension(imageFile!.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('RestaurantImages/$uid/ResImage$fileExtension');

      setState(() {
        isLoading = true;
      });
      final taskSnap = await ref.putFile(imageFile!);
      final url = await taskSnap.ref.getDownloadURL();

      //Adding the image url to the database
      final doc = FirebaseFirestore.instance.collection('Restaurants').doc(uid);
      await doc.update({
        "ImageURL": url,
      });

      setState(() {
        imageURL = url;
        isLoading = false;
      });
    }
  }

  final picker = ImagePicker();
  late Size scrSize;
  late File? imageFile = File('');
  late String? imageURL;
  bool isImageLoaded = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    scrSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      height: 250,
      width: scrSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Restauarant Image',
                style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
              ),
              const Spacer(),
              IconButton(onPressed: imagePicker, icon: const Icon(Icons.edit)),
            ],
          ),
          isLoading
              ? CustomShimmer(height: 150, width: scrSize.width)
              : (!isImageLoaded
                  ? Center(
                      child: TextButton(
                      onPressed: imagePicker,
                      child: const Text('Upload a Photo'),
                    ))
                  : CachedNetworkImage(
                      cacheManager: appCacheManager,
                      imageUrl: imageURL!,
                      placeholder: (context, url) => CustomShimmer(
                        height: 150,
                        width: scrSize.width,
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 150,
                        width: scrSize.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider),
                        ),
                      ),
                    )),
        ],
      ),
    );
  }
}

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  List<String> categories = [];
  bool isLoading = true;

  Future<void> addCategory(String text) async {
    final doc = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(AuthServices().auth.currentUser!.uid);
    await doc.update({
      "Categories": FieldValue.arrayUnion([text])
    });

    setState(() {
      categories.add(text);
    });
  }

  Future<void> removeCategory(int index) async {
    final doc = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(AuthServices().auth.currentUser!.uid);

    await doc.update({
      "Categories": FieldValue.arrayRemove([categories[index]])
    });

    setState(() {
      categories.removeAt(index);
    });
  }

  Future<void> getCategories() async {
    categories = await Db()
        .getRestaurantCategories(AuthServices().auth.currentUser!.uid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final Size scrSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      width: scrSize.width,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isLoading
          ? Center(child: CustomShimmer(height: 300, width: scrSize.width))
          : Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final categoryControl = TextEditingController();
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Text('Create Category'),
                                content: TextField(
                                  controller: categoryControl,
                                  decoration: const InputDecoration(
                                      hintText: 'Category Name'),
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
                            });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                //Category List
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: max(categories.length, 1),
                    itemBuilder: (context, index) {
                      return categories.isEmpty
                          ? const SizedBox(
                              height: 300,
                              child: Center(child: Text('No Categories!')))
                          : Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                leading: SizedBox(
                                  width: 20,
                                  child: IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            final categoryControl =
                                                TextEditingController();
                                            categoryControl.text =
                                                categories[index];
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              title:
                                                  const Text('Edit Category'),
                                              content: TextField(
                                                controller: categoryControl,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            'Category Name'),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text('CANCEL'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('EDIT'),
                                                  onPressed: () async {
                                                    final doc =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Restaurants')
                                                            .doc(AuthServices()
                                                                .auth
                                                                .currentUser!
                                                                .uid);
                                                    await doc.update({
                                                      "Categories": FieldValue
                                                          .arrayRemove([
                                                        categories[index]
                                                      ]),
                                                    });
                                                    await doc.update({
                                                      "Categories": FieldValue
                                                          .arrayUnion([
                                                        categoryControl.text
                                                      ]),
                                                    });
                                                    setState(() {
                                                      categories[index] =
                                                          categoryControl.text;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ),
                                tileColor: Colors.white,
                                title: Text(categories[index]),
                                trailing: IconButton(
                                  onPressed: () async {
                                    await removeCategory(index);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
