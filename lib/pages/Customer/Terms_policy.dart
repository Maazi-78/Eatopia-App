import 'package:flutter/material.dart';

class Terms_policy extends StatefulWidget {
  const Terms_policy({super.key});

  @override
  State<Terms_policy> createState() => _Terms_policyState();
}

class _Terms_policyState extends State<Terms_policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Policy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Introduction',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Welcome to our food ordering and hotel reservation app. By using our app, you agree to these Terms of Service.\n',
              ),
              Text(
                '2. Use of Our App',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Our app is for personal and non-commercial use only. You agree not to use our app for any illegal or unauthorized purpose.\n',
              ),
              Text(
                '3. Ordering Food',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'You may order food through our app from participating restaurants. We do not guarantee the availability or quality of the food ordered through our app, nor do we guarantee the accuracy of any restaurant information displayed on our app. Any issues with the food ordered through our app should be addressed directly with the restaurant.\n',
              ),
              Text(
                '4. Hotel Reservations',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'You may make pre-reservations for hotel rooms through our app. We do not guarantee the availability or quality of the hotel rooms reserved through our app, nor do we guarantee the accuracy of any hotel information displayed on our app. Any issues with the hotel reservation should be addressed directly with the hotel.\n',
              ),
              Text(
                '5. User Content',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'You are solely responsible for any content that you post or transmit through our app. You agree not to post or transmit any content that is illegal, defamatory, or infringes on any third party\'s intellectual property rights.\n',
              ),
              Text(
                '6. Intellectual Property',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'All intellectual property rights in our app, including but not limited to trademarks, logos, and copyrights, are owned by us or our licensors. You may not use any of our intellectual property without our prior written consent.\n',
              ),
              Text(
                '7. Limitation of Liability',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We are not liable for any indirect, incidental, or consequential damages arising out of your use of our app, including but not limited to lost profits, lost data, or business interruption.\n',
              ),
              Text(
                '8. Termination',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We may terminate your use of our app at any time, without notice or liability.\n',
              ),
              Text(
                '9. Governing Law',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'These Terms of Service shall be governed by and construed in accordance with the laws of Pakistan. Any disputes arising out of these Terms of Service shall be resolved exclusively in the courts of Pakistan.\n',
              ),
              SizedBox(height: 16.0),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Introduction',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and disclose your personal information.\n',
              ),
              Text(
                '2. Collection of Personal Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We collect personal information, such as your name, email address, and phone number, when you register for our app or make an order or reservation through our app.\n',
              ),
              Text(
                '3. Use of Personal Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We use your personal information to provide you with the services offered through our app, such as processing your orders and reservations. We may also use your personal information to send you promotional emails or messages about our app.\n',
              ),
              Text(
                '4. Disclosure of Personal Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We may disclose your personal information to our partners or service providers who help us provide the services offered through our app. We may also disclose your personal information if required by law.\n',
              ),
              Text(
                '5. Security of Personal Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We take reasonable measures to protect your personal information from unauthorized access, disclosure, or misuse.\n',
              ),
              Text(
                '6. Retention of Personal Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We will retain your personal information for as long as necessary to provide you with the services offered through our app, or as required by law.\n',
              ),
              Text(
                '7. Changes to Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'We may change this Privacy Policy at any time, without notice to you. We encourage you to review this Privacy Policy regularly.\n',
              ),
              Text(
                '8. Use of Personal Info',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'By agreeing to our Terms and Policies you are agreeing that we can use your personal information to any extent, even sell it to another person and you can\'t object it or you don\'t have any other authorities. Also, by using our app, you will become our slave.\n',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
