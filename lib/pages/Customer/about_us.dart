import 'package:flutter/material.dart';

class About_us extends StatefulWidget {
  const About_us({super.key});

  @override
  State<About_us> createState() => _About_usState();
}

class _About_usState extends State<About_us> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About Us'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Center(
                  child: Text(
                    'Welcome to Eatopia',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Welcome to our food ordering and hotel reservation app! Our mission is to make it easy and convenient for you to order food and make hotel reservations from the comfort of your own device. ',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'We believe that food and travel are some of life\'s greatest pleasures, and our app is designed to enhance your dining and hotel experiences. Whether you\'re craving your favorite dish from a nearby restaurant or looking for the perfect hotel for your next vacation, our app has got you covered.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Our app is powered by a team of dedicated professionals who are passionate about food and travel. We work hard every day to ensure that our app is user-friendly, reliable, and secure. Our goal is to provide you with a seamless and enjoyable experience, from the moment you open our app to the moment you receive your food or check into your hotel.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'We value your feedback and are always looking for ways to improve our app. If you have any comments, questions, or suggestions, please feel free to contact us. We are here to help you and are committed to providing you with the best possible service.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Thank you for choosing our app! We hope you enjoy your food and hotel experiences with us.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Sincerely,',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'The Eatopia Team',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Ghufran Nazir \nAbdullah Zahid \nMuzamil Ali',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ));
  }
}
