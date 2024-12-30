import 'package:eatopia/services/maps.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../services/auth_services.dart';

////IN FIRST PAGE WE WILL GET THE EMAIL AND PASSWORD AND VERIFY IF THE USER EXISTS OR NOT
class BuisnessSignup extends StatefulWidget {
  const BuisnessSignup({super.key});

  @override
  State<BuisnessSignup> createState() => _BuisnessSignupState();
}

class _BuisnessSignupState extends State<BuisnessSignup> {
  //This _formKey will help us validate the inputs (check whether the user has entered the correct input or not)
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = appGreen;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ownerController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final restaurantController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    ownerController.dispose();
    phoneController.dispose();
    addressController.dispose();
    confirmPasswordController.dispose();
    restaurantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            toolbarHeight: 70,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(image: AssetImage('images/eatopia.png'), height: 50),
                  SizedBox(width: 10),
                  Text('EATOPIA',
                      style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2,
                          fontSize: 30,
                          fontWeight: FontWeight.bold))
                ])),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'Setup Business Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //Owner NAME TEXT FIELD
                            CustomTextField(
                                icon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                labelText: 'Owner Name',
                                hintText: 'Enter your name',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                emailController: ownerController,
                                boxH: 100,
                                primaryColor: _primaryColor),
                            const SizedBox(height: 20),

                            //Restaurant NAME TEXT FIELD
                            CustomTextField(
                                icon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                labelText: 'Restaurant Name',
                                hintText: 'Enter your Restaurant name',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter Restaurant name';
                                  }
                                  return null;
                                },
                                emailController: restaurantController,
                                boxH: 100,
                                primaryColor: _primaryColor),
                            const SizedBox(height: 20),

                            //EMAIL TEXT FIELD
                            CustomTextField(
                                icon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!EmailValidator.validate(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                emailController: emailController,
                                boxH: 100,
                                primaryColor: _primaryColor),
                            const SizedBox(height: 20),

                            PasswordTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                passwordController: passwordController,
                                boxPassH: 100,
                                primaryColor: _primaryColor),
                            const SizedBox(height: 20),

                            //CONFIRM PASSWORD TEXT FIELD
                            PasswordTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                labelText: 'Confirm Password',
                                hintText: 'Confirm your password',
                                passwordController: confirmPasswordController,
                                boxPassH: 100,
                                primaryColor: _primaryColor),
                            const SizedBox(height: 20),

                            //Phone Number Text Field
                            CustomTextField(
                                inputType: TextInputType.phone,
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                ),
                                labelText: 'Phone Number',
                                hintText: 'Enter your phone number',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                                emailController: phoneController,
                                boxH: 100,
                                primaryColor: _primaryColor),
                            const SizedBox(height: 20),

                            //Address Text Field
                            CustomTextField(
                                readOnly: true,
                                inputType: TextInputType.streetAddress,
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                                labelText: 'Address',
                                hintText: 'Select your address',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Select your address';
                                  }
                                  return null;
                                },
                                emailController: addressController,
                                boxH: 100,
                                primaryColor: _primaryColor),
                            const SizedBox(height: 10),
                          ],
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: Colors.white,
                            fixedSize: const Size(210, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        onPressed: () async {
                          String? locTxt = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MapScreen()));
                          if (locTxt != null) {
                            setState(() {
                              addressController.text = locTxt;
                            });
                          }
                        },
                        child: Text(
                          'Select Location from Maps',
                          style: TextStyle(
                              color: appGreen, fontFamily: 'ubuntu-bold'),
                        )),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(_primaryColor),
                          fixedSize: MaterialStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width / 3,
                              MediaQuery.of(context).size.height / 18)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });
                        bool exists = await AuthServices()
                            .emailExists(emailController.text);

                        if (exists) {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  content: Text('Email already in use')));
                          return;
                        }

                        await AuthServices().signUpwithEmail(
                            emailController.text, passwordController.text);

                        await AuthServices().addRestaurant({
                          'owner': ownerController.text,
                          'restaurant': restaurantController.text,
                          'phone': phoneController.text,
                          'address': addressController.text,
                          'Categories': [],
                          'email': emailController.text,
                        });

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/ResHomePage', (route) => false);
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            )
                          : const Text('Register'),
                    ),
                  ],
                ),
              ),
            )));
  }
}
