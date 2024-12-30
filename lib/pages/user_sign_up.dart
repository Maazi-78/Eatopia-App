import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/services/maps.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

////IN FIRST PAGE WE WILL GET THE EMAIL AND PASSWORD AND VERIFY IF THE USER EXISTS OR NOT
class UserSignUpPageOne extends StatefulWidget {
  const UserSignUpPageOne({super.key});

  @override
  State<UserSignUpPageOne> createState() => _UserSignUpPageOneState();
}

class _UserSignUpPageOneState extends State<UserSignUpPageOne> {
  //This _formKey will help us validate the inputs (check whether the user has entered the correct input or not)
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = appGreen;
  final emailController = TextEditingController();
  bool isLoading = false;
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
          title:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Form(
                key: _formKey,
                child: Column(
                  children: [
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
                  ],
                )),
            //NEXT SCREEN BUTTON
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(_primaryColor),
                  fixedSize: MaterialStateProperty.all<Size>(Size(
                      MediaQuery.of(context).size.width / 3,
                      MediaQuery.of(context).size.height / 18)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                bool res =
                    await AuthServices().emailExists(emailController.text);
                if (res) {
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
                      content: const Text('Email already exists'),
                    ),
                  );
                  setState(() {
                    isLoading = false;
                  });
                  return;
                }
                Navigator.pushNamed(context, '/UserSignUpPageTwo', arguments: {
                  'email': emailController.text,
                });
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 1.2,
                      color: Colors.white,
                    )
                  : const Text('Continue'),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(_primaryColor),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/LoginPage');
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//USER SIGN - UP PAGE TWO TAKE INPUT FOR USERNAME, PHONE NUMBER AND ADDRESS AND THEN THE SIGN UP IS COMPLETE

class UserSignUpPageTwo extends StatefulWidget {
  const UserSignUpPageTwo({super.key});

  @override
  State<UserSignUpPageTwo> createState() => _UserSignUpPageTwoState();
}

class _UserSignUpPageTwoState extends State<UserSignUpPageTwo> {
  Map userData = {};
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = appGreen;
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    userNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //We got this data from first page of sign up
    userData = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
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
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //USER NAME TEXT FIELD
                        CustomTextField(
                            icon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            labelText: 'User Name',
                            hintText: 'Enter your user name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your user name';
                              }
                              return null;
                            },
                            emailController: userNameController,
                            boxH: 100,
                            primaryColor: _primaryColor),
                        const SizedBox(height: 20),
                        //PASSWORD TEXT FIELD
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
                        //Confirm PASSWORD TEXT FIELD
                        PasswordTextField(
                          labelText: 'Confirm',
                          hintText: 'Enter your password again',
                          passwordController: confirmPasswordController,
                          boxPassH: 100,
                          primaryColor: _primaryColor,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password again';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
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
                              } else if (int.tryParse(value) == null ||
                                  value.length < 10) {
                                return 'Please enter a valid phone number';
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
                      style:
                          TextStyle(color: appGreen, fontFamily: 'ubuntu-bold'),
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
                      await AuthServices().signUpwithEmail(
                          userData['email'], passwordController.text);
                      await AuthServices().addCustomers({
                        'name': userNameController.text,
                        'email': userData['email'],
                        'phone': phoneController.text,
                        'stAddress': addressController.text,
                      });
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.white,
                          )
                        : const Text('Sign Up')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
