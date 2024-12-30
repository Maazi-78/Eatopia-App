import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatopia/pages/Restaurant/items.dart';
import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/utilities/cache_manger.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utilities/custom_text_field.dart';
import 'package:eatopia/utilities/colours.dart';

String? priceValidator(String? value) {
  if (value!.isEmpty) {
    return 'Please enter price';
  }
  if (double.tryParse(value) == null) {
    return 'Please enter a valid price';
  }
  if (double.parse(value) < 0) {
    return 'Please enter a valid price';
  }
  return null;
}

class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key, required this.categories, required this.item});
  final List<String> categories;
  final Item item;

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final itemNameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  Map<String, dynamic> addOns = {};

  String selectedCategory = '';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  late File imageFile = File('');
  String imageURL = '';

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.item.category;
    itemNameController.text = widget.item.name;
    descController.text = widget.item.desc;
    priceController.text = widget.item.price.toString();
    addOns = widget.item.addOns;
    imageURL = widget.item.ImageURL;
  }

  @override
  void dispose() {
    itemNameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 50)),
                        onPressed: () async {
                          bool result = await showDialog(
                            context: context,
                            builder: buildDeleteAlert,
                          );
                          if (result) {
                            await Db().deleteItem(
                                AuthServices().auth.currentUser!.uid,
                                widget.item.itemId);
                            Navigator.pop(context, [widget.item, true]);
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                          color: appRed,
                        ),
                        label: Text('Delete Item',
                            style: TextStyle(color: appRed, fontSize: 18))),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Item Name',
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'ubuntu-bold'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Item name text field
                    CustomTextField(
                        labelText: '',
                        hintText: '',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter item name';
                          }
                          return null;
                        },
                        emailController: itemNameController,
                        boxH: 100,
                        primaryColor: appGreen),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Item Description',
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'ubuntu-bold'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descController,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      maxLines: 3,
                      maxLength: 80,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: appGreen),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appGreen),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appGreen),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Item Price',
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'ubuntu-bold'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      inputType: TextInputType.number,
                      emailController: priceController,
                      boxH: 100,
                      primaryColor: appGreen,
                      hintText: '',
                      labelText: '',
                      validator: priceValidator,
                    ),
                    const SizedBox(height: 20),
                    //Item image
                    Row(
                      children: [
                        const Text(
                          'Item image',
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'ubuntu-bold'),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              picker
                                  .pickImage(source: ImageSource.gallery)
                                  .then((value) {
                                setState(() {
                                  imageFile = File(value!.path);
                                });
                              });
                            },
                            icon: const Icon(Icons.upload))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: buildEditImageWidget(imageFile, imageURL),
                    ),
                    const SizedBox(height: 20),

                    //Category select Dropdown
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Category',
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'ubuntu-bold'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(20),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: selectedCategory,
                        items: widget.categories.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Add ons',
                                style: TextStyle(
                                    fontFamily: 'ubuntu-bold', fontSize: 20),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  final key = GlobalKey<FormState>();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return buildAddonCreate(
                                            context, key, addOns);
                                      });
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),

                          //Addon List
                          buildAddOnList(context, addOns),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          Item item = await Db().updateItem(
                              AuthServices().auth.currentUser!.uid,
                              imageFile,
                              widget.item.itemId, {
                            'name': itemNameController.text,
                            'desc': descController.text,
                            'price': double.parse(priceController.text),
                            'category': selectedCategory,
                            'addOns': addOns,
                            'ImageURL': imageURL,
                          });
                          setState(() {
                            isLoading = false;
                          });

                          Navigator.pop(context, [item, false]);
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.white,
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(fontSize: 15),
                              )),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildDeleteAlert(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Delete Item'),
      content: const Text('Are you sure you want to delete this item?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Delete')),
      ],
    );
  }
}

Widget buildEditImageWidget(File imageFile, String imageURL) {
  if (imageFile.path.isEmpty) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      cacheManager: appCacheManager,
      placeholder: (context, url) => const CustomShimmer(),
    );
  } else {
    return Image.file(imageFile);
  }
}

Widget buildAddOnList(BuildContext context, Map<String, dynamic> addOns) {
  return SizedBox(
    height: 300,
    child: ListView.builder(
      itemCount: max(addOns.length, 1),
      itemBuilder: (context, index) {
        return addOns.isEmpty
            ? const SizedBox(
                height: 300, child: Center(child: Text('No Add ons!')))
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
                        final key = GlobalKey<FormState>();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return buildEditAddon(
                                  context, key, addOns, index);
                            });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  tileColor: Colors.white,
                  title: Text(
                    '${addOns.keys.toList()[index]}\nRs: ${addOns.values.toList()[index]}',
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      addOns.remove(addOns.keys.toList()[index]);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
      },
    ),
  );
}

Widget buildEditAddon(BuildContext context, GlobalKey<FormState> key,
    Map<String, dynamic> addOns, int index) {
  final nameController = TextEditingController();
  final addOnPriceController = TextEditingController();
  nameController.text = addOns.keys.toList()[index];
  addOnPriceController.text = addOns.values.toList()[index].toString();
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: const Text('Edit Add on'),
    content: Form(
        key: key,
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter add on name' : null,
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Add on name'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: priceValidator,
                controller: addOnPriceController,
                decoration: const InputDecoration(hintText: 'Add on Price'),
              ),
            ],
          ),
        )),
    actions: [
      TextButton(
        child: const Text('CANCEL'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: const Text('EDIT'),
        onPressed: () {
          if (key.currentState!.validate()) {
            addOns.remove(addOns.keys.toList()[index]);
            addOns[nameController.text] = int.parse(addOnPriceController.text);
            Navigator.of(context).pop();
          }
        },
      ),
    ],
  );
}

Widget buildAddonCreate(BuildContext context, GlobalKey<FormState> key,
    Map<String, dynamic> addOns) {
  final nameController = TextEditingController();
  final addOnPriceController = TextEditingController();
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: const Text('Create Add on'),
    content: Form(
        key: key,
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter add on name' : null,
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Add on name'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: priceValidator,
                controller: addOnPriceController,
                decoration: const InputDecoration(hintText: 'Add on Price'),
              ),
            ],
          ),
        )),
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
          if (key.currentState!.validate()) {
            addOns[nameController.text] = int.parse(addOnPriceController.text);
            Navigator.of(context).pop();
          }
        },
      ),
    ],
  );
}
