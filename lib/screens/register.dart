import 'package:demo_news_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
// creating controller for text fields
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // loading false
  bool loading = false;

  // text field controller
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  // register user function
  void _registerUser() async {
    ApiResponse response = await register(
      nameController.text,
      emailController.text,
      passwordController.text,
    );
    if (response.error == null) {
      // save and redirect to home screen
      _saveAndRedirectToHome(response.data as User);
    } else {
      // loading variable false
      setState(() {
        loading = false;
      });

      // showing error in snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  // save and redirect to home page
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    // redirecting to home screen
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Register'),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // app short Logo
                    Image.asset(
                      shortLogoURL,
                      width: 250.0,
                      height: 60.0,
                    ),

                    // vertical space
                    const SizedBox(
                      height: 60.0,
                    ),

                    // name
                    TextFormField(
                      controller: nameController,
                      validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                      decoration: kInputDecoration('Name'),
                    ),

                    // vertical space
                    const SizedBox(
                      height: 20.0,
                    ),

                    // email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid Email Address' : null,
                      decoration: kInputDecoration('Email'),
                    ),

                    // vertical space
                    const SizedBox(
                      height: 20.0,
                    ),

                    // password
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (val) =>
                          val!.length < 8 ? 'Minimum 8 character' : null,
                      decoration: kInputDecoration('Password'),
                    ),

                    // vertical space
                    const SizedBox(
                      height: 20.0,
                    ),

                    // confirm password
                    TextFormField(
                      controller: passwordConfirmController,
                      obscureText: true,
                      validator: (val) => val != passwordController.text
                          ? 'Confirm Password Does Not Match'
                          : null,
                      decoration: kInputDecoration('Confirm Password'),
                    ),

                    // vertical space
                    const SizedBox(
                      height: 30.0,
                    ),

                    loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        :
                        // register button
                        Container(
                            width: 250.0,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: TextButton(
                              onPressed: () {
                                print('Register pressed');
                                if (formKey.currentState!.validate()) {
                                  _registerUser();
                                  setState(() {
                                    loading = true;
                                    _registerUser();
                                    print('Register clicked');
                                  });
                                }
                              },

                              // button styling
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(15.0)),
                              ),

                              // button name
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                    // vertical space
                    const SizedBox(
                      height: 20.0,
                    ),

                    // if not have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(' Already have an account? '),
                        GestureDetector(
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Login())),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
