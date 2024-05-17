import 'dart:developer';

import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/repository/auth_repo.dart';
import 'package:find_your_room_nepal/utils/utils.dart';
import 'package:find_your_room_nepal/view/main_screen.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final _authRepo = AuthRepository();
  final _appUrl = AppUrl();

  bool _isLoading = false;
  get isLoading => _isLoading;

  setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  List _districtList = [];
  List get districtList => _districtList;

  set districtList(value) => _districtList = value;

  String _selectedDistrict = "";
  String get selectedDistrict => _selectedDistrict;

  setSelectedDistrict(String value) {
    _selectedDistrict = value;
    notifyListeners();
  }

  initCall(BuildContext context) async {
    setIsLoading(true);
    try {
      final response = await _authRepo.getDistrict(context);
      setIsLoading(false);
      log("CityResponse $response ");
      _districtList = response['data'];
      _selectedDistrict = _districtList.first.toString();

      notifyListeners();
    } catch (e) {
      setIsLoading(false);
      log('Erroer $e');
    }
  }

  bool _registerLoader = false;
  get registerLoader => _registerLoader;

  setRegisterLoader(value) {
    _registerLoader = value;
    notifyListeners();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  registerUser(BuildContext context) async {
    log("MOBILE NUMBER ${mobileController.text}");
    var bodyToSend = {
      "name": nameController.text,
      "email": emailController.text,
      "mobile": "+91${mobileController.text}",
      "city": "Kathmandu",
      "district": _selectedDistrict,
      "address": addressController.text,
      "password": passwordController.text,
      "password2": confirmPasswordController.text
    };
   log("SSSTEDTTSS $bodyToSend");
    setRegisterLoader(true);
    try {
      final response = await _authRepo.registerUser(context, bodyToSend);
      log("RESPONSE USER REGISTER: $response");
      if (response != null) {
        Utils.snackBar(response['data'].toString(), context);
        Navigator.pop(context);
      }
      setRegisterLoader(false);
    } catch (e) {
      setRegisterLoader(false);
      log('Erroer $e');
    }
  }

//Login
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  bool _loginLoader = false;
  get loginLoader => _loginLoader;

  setLoginLoader(value) {
    _loginLoader = value;
    notifyListeners();
  }

  loginUser(BuildContext context) async {
    log("MOBILE NUMBER ${mobileController.text}");
    var bodyToSend = {
      "email": loginEmailController.text,
      "password": loginPasswordController.text
    };

    log("RESPONSE USER Login: $bodyToSend");

    setLoginLoader(true);
    try {
      final response = await _authRepo.loginUser(context, bodyToSend);
      log("RESPONSE USER Login: $response");
      if (response != null) {
        _appUrl.storeToken(response['token']['access']);
        _appUrl.storeUserId(response['user']);
        Utils.snackBar("User Login Successfully".toString(), context);
        loginEmailController.text="";
        loginPasswordController.text="";
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
      setLoginLoader(false);
    } catch (e) {
      setLoginLoader(false);
      log('Erroer $e');
    }
  }
}
