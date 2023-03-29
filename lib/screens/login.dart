import 'package:demo_news_app/models/api_response.dart';
import 'package:demo_news_app/screens/register.dart';
import 'package:demo_news_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/user.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
// creating controller for text fields
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // loading false
  bool loading = false;

  // text field controller
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();

  // login user function
  void _loginUser() async {
    ApiResponse response = await login(
      textEmail.text,
      textPassword.text,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
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
    debugPrint('Login Success with user id =>  ${user.id}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // textEmail.text = 'admin@example.com';
    // textPassword.text = 'password';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Login'),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // app short Logo
                      Image.asset(
                        shortLogoBlackURL,
                        width: 250.0,
                        height: 60.0,
                      ),

                      // vertical space
                      const SizedBox(
                        height: 40.0,
                      ),

                      // email
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: textEmail,
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
                        controller: textPassword,
                        obscureText: true,
                        validator: (val) =>
                            val!.length < 8 ? 'Minimum 8 character' : null,
                        decoration: kInputDecoration('Password'),
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
                          // login button
                          Container(
                              width: 250.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              child: TextButton(
                                onPressed: () {
                                  print('login pressed');
                                  if (formKey.currentState!.validate()) {
                                    _loginUser();
                                    setState(() {
                                      loading = true;
                                      _loginUser();
                                      print('login clicked');
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                    (states) => Theme.of(context).primaryColor,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(15.0)),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      // if not have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(' Login as '),
                          GestureDetector(
                            child: const Text(
                              'Guest',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onTap: () {
                              textEmail.text = "guest@example.com";
                              textPassword.text = "password";
                            },
                          ),
                        ],
                      ),

                      // if not have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(' Dont have an account? '),
                          GestureDetector(
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new Register())),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
