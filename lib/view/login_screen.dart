import 'dart:developer';

import 'package:find_your_room_nepal/constant/app_text.dart';
import 'package:find_your_room_nepal/view/register_screen.dart';
import 'package:find_your_room_nepal/view_model.dart/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validation_plus/validate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                const Text(
                  'Welcome,',
                  style: AppTextStyle.boldTitle,
                ),
                const Text(
                  'Sign in to continue!',
                  style: AppTextStyle.greySubTitle,
                ),
              ],
            ),
          ),
          // Positioned(
          //     top: MediaQuery.of(context).size.height * 0.3,
          //     left: MediaQuery.of(context).size.height * 0.08,
          //     child:
          //         const Text('Shopping App', style: AppTextStyle.appLogoText)),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    )),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email',
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: provider.loginEmailController,
                          onChanged: (value) {
                            if (Validate.isValidEmail(value)) {
                              log("Email valid  ");
                            } else {
                              log("Email not valid");
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Enter your email',
                              hintText: 'Email'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Password',
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: provider.loginPasswordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Enter your password',
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                          alignment: Alignment.topRight,
                          child: Text('Forget password?',
                              style: TextStyle(color: Colors.blue))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Consumer<AuthViewModel>(
                        builder: (context, value, child) => Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.indigo,
                          ),
                          child: InkWell(
                            onTap: () {
                              provider.loginUser(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: value.loginLoader
                                    ? CircularProgressIndicator()
                                    : Text('LOGIN',
                                        style: AppTextStyle.buttonText),
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const RegisterScreen();
                          }));
                        },
                        child: Center(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: "Don't have account "),
                                TextSpan(
                                  text: 'Signup',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          // Consumer<SignInViewModel>(
          //   builder: (context, value, child) => Positioned(
          //       top: MediaQuery.of(context).size.height * 0.5,
          //       left: MediaQuery.of(context).size.width * 0.45,
          //       child: value.loading
          //           ? const Center(child: CircularProgressIndicator())
          //           : Container()),
          // )
        ],
      ),
    ));
  }
}
