// import 'package:eshop/res/app_text_style.dart';
// import 'package:eshop/view_model/signup_view_model.dart';
import 'package:find_your_room_nepal/constant/app_text.dart';
import 'package:find_your_room_nepal/view_model.dart/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    final provider = Provider.of<AuthViewModel>(context, listen: false);
    provider.initCall(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthViewModel>(context, listen: false);
    return Consumer<AuthViewModel>(
      builder: (context, value, child) => Scaffold(
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
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
                  SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Create Account,',
                    style: AppTextStyle.boldTitle,
                  ),
                  const Text(
                    'Sign up to started!',
                    style: AppTextStyle.greySubTitle,
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
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
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: value.nameController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Name',
                              hintText: 'Name'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: value.emailController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Email',
                              hintText: 'Email'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: value.mobileController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Phone',
                              hintText: 'Phone'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      value.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          value: value.selectedDistrict,
                                          items: value.districtList.map((item) {
                                            return DropdownMenuItem(
                                                value: item.toString(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(item.toString()),
                                                ));
                                          }).toList(),
                                          onChanged: (selectedItem) {
                                            value.setSelectedDistrict(
                                                selectedItem.toString());
                                          }),
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    child: const Text(
                                      "Select District",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          backgroundColor: Colors.white),
                                    )),
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 70,
                        child: TextField(
                          controller: value.addressController,
                          maxLines: 2,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.apartment),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Address',
                              hintText: 'Address'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: value.passwordController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.remove_red_eye),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Password',
                              hintText: 'Password'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: value.confirmPasswordController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.remove_red_eye),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Confirm Password',
                              hintText: 'Confirm Password'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                              provider.registerUser(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: value.registerLoader
                                    ? CircularProgressIndicator()
                                    : Text("Register",
                                        style: AppTextStyle.buttonText),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Consumer<SignUpViewModel>(
            //   builder: (context, value, child) => Positioned(
            //       top: MediaQuery.of(context).size.height * 0.5,
            //       left: MediaQuery.of(context).size.width * 0.45,
            //       child: value.loading
            //           ? const Center(child: CircularProgressIndicator())
            //           : Container()),
            // )
          ],
        ),
      )),
    );
  }
}
