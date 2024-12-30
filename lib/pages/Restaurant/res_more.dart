import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/services/maps.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:flutter/material.dart';

class ResMore extends StatefulWidget {
  const ResMore({super.key});
  @override
  State<ResMore> createState() => _ResMoreState();
}

class _ResMoreState extends State<ResMore> {
  List<String> value = [
    'Profile',
    'Address',
    'Terms and Policies',
    'About us',
    'Logout'
  ];

  //create a list containing the name and icon
  List<IconData> icons = [
    Icons.person,
    Icons.location_on,
    Icons.policy,
    Icons.info,
    Icons.logout
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  value[index],
                  style: const TextStyle(fontSize: 15),
                ),
                tileColor: appGreen,
                textColor: Colors.white,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(icons[index]),
                iconColor: Colors.white,
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  if (value[index] == 'Profile') {
                    Navigator.pushNamed(context, '/Res_profile');
                  } else if (value[index] == 'Terms and Policies') {
                    Navigator.pushNamed(context, '/Terms_policy');
                  } else if (value[index] == 'About us') {
                    Navigator.pushNamed(context, '/About_us');
                  } else if (value[index] == 'Logout') {
                    await AuthServices().auth.signOut();
                    Navigator.pushReplacementNamed(context, '/WelcomePage');
                  } else if (value[index] == 'Address') {
                    String? locTxt = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapScreen()));
                    if (locTxt != null) {
                      await Db().updateRestaurantAddress(
                          AuthServices().auth.currentUser!.uid, locTxt);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: appGreen,
                          content: const Text('Address Updated !'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
            );
          }),
    ));
  }
}
