import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResProfile extends StatefulWidget {
  const ResProfile({super.key});

  @override
  State<ResProfile> createState() => _ResProfileState();
}

class _ResProfileState extends State<ResProfile> {
  late User _user;
  String? _name;
  String? _ownerName;
  String? _phoneNumber;
  String? _address;
  String? _email;
  String? _description;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _getUserData();
  }

  Future<void> _getUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(_user.uid)
        .get();
    setState(() {
      _name = userData['restaurant'];
      _phoneNumber = userData['phone'];
      _address = userData['address'];
      _email = userData['email'];
      _description = userData['description'];
      _ownerName = userData['owner'];
    });
  }

  void _editUserData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Restaurant Data'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Owner Name',
                    hintText: _ownerName,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _ownerName = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: _name,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: _phoneNumber,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _phoneNumber = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: _address,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save the edited data to Firebase
                final userDataRef = FirebaseFirestore.instance
                    .collection('Customers')
                    .doc(_user.uid);
                await userDataRef.update({
                  'restaurant': _name,
                  'description': _description,
                  'owner': _ownerName,
                  'phone': _phoneNumber,
                  'address': _address,
                });
                // Update the UI to reflect the edited data
                _getUserData();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50,
                      backgroundImage: AssetImage('images/user.png'),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      _ownerName ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                buildCard(
                  title: 'Information',
                  child: Column(
                    children: [
                      buildInfoRow(
                        label: 'Name',
                        value: _name ?? '',
                      ),
                      buildInfoRow(
                        label: 'Email',
                        value: _email ?? '',
                      ),
                      buildInfoRow(
                        label: 'Phone Number',
                        value: _phoneNumber ?? '',
                      ),
                      buildInfoRow(
                        label: 'Address',
                        value: _address ?? '',
                      ),
                      const SizedBox(height: 20),
                      ButtonBar(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _editUserData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // make a floating button
        ],
      ),
    );
  }
}

Widget buildCard({
  required String title,
  required Widget child,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    ),
  );
}

Widget buildInfoRow({
  required String label,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
