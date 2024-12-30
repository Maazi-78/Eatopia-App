import 'dart:developer';
import 'package:eatopia/pages/Customer/user_home.dart';
import 'package:eatopia/pages/Restaurant/res_home.dart';
import 'package:eatopia/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utilities/colours.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  //Function to check if the current logged in user is a customer or restaurant
  Future<bool> isCustomer() async {
    final docRef = FirebaseFirestore.instance
        .collection('Customers')
        .doc(auth.currentUser!.uid);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  //Recieves the Restaurant information Map
  Future<void> addRestaurant(Map<String, dynamic> data) async {
    data['restaurantLower'] = data['restauarant'].toString().toLowerCase();
    //Split the restaurant name into an array of words sepertaed by spaces, commas, dashes
    data['restaurantArray'] =
        data['restauarantLower'].toString().split(RegExp(r'[\s,-]'));
    await db.collection('Restaurants').doc(auth.currentUser!.uid).set(data);
  }

  //Recieves the Customer information Map
  Future<void> addCustomers(Map<String, dynamic> data) async {
    await db.collection('Customers').doc(auth.currentUser!.uid).set(data);
  }

  Future<String?> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }

    return null;
  }

  void isSignedIn(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () async {
      if (auth.currentUser != null) {
        bool isCustomer = await AuthServices().isCustomer();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    isCustomer ? const UserHomePage() : const ResHome()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomePage()));
      }
    });
  }

  Future<bool> emailExists(String email) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email, password: "someBOdyNeverGOOnnaUsEthisPassWOrDDMDK");
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
      switch (e.code) {
        case "user-not-found":
          return false;
      }
    }
    return true;
  }

  Future<void> signUpwithEmail(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return;
    }
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: appRed,
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              content: const Text('Account already exists'),
            ),
          );
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: appRed,
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              content: const Text('Invalid Credential'),
            ),
          );
        }
      } catch (e) {
        return null;
        // handle the error here
      }
    }

    return user;
  }
}
