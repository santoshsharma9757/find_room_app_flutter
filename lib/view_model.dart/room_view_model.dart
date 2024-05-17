import 'dart:developer';

import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/repository/auth_repo.dart';
import 'package:find_your_room_nepal/repository/room_repo.dart';
import 'package:find_your_room_nepal/utils/utils.dart';
import 'package:find_your_room_nepal/view/upload_room.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RoomViewModel extends ChangeNotifier {
  final _roomRepo = RoomRepository();
  final _appUrl = AppUrl();

  List _roomList = [];
  List get roomList => _roomList;

  bool _roomLoader = false;
  get roomLoader => _roomLoader;

  setRoomLoader(value) {
    _roomLoader = value;
    notifyListeners();
  }

  initCall(BuildContext context) async {
    await getUserDetail(context);
    await getDistrict(context);
    await getRoom(context);
  }

  getRoom(BuildContext context, [bool isDropdownChanged = false]) async {
    setRoomLoader(true);
    try {
      var response;
      if (isDropdownChanged == false) {
        // response = await _roomRepo.getRooms(context);
        response =
            await _roomRepo.getRoomsByDistrict(context, selectedDistrict);
      } else {
        response =
            await _roomRepo.getRoomsByDistrict(context, selectedDistrict);
      }
      _roomList = response['data'];

      setRoomLoader(false);
      log("CityResponse $_roomList ");

      notifyListeners();
    } catch (e) {
      setRoomLoader(false);
      log('Erroer $e');
    }
  }

  Map<String, dynamic> _roomData = {};
  get roomData => _roomData;

  set roomData(value) => _roomData = value;

  getRoomByID(BuildContext context, dynamic roomId) async {
    setRoomLoader(true);
    try {
      final response = await _roomRepo.getRoomsByID(context, roomId);

      _roomData = response['data'];
      setRoomLoader(false);
      log("roomDetail Response $_roomData ");

      notifyListeners();
    } catch (e) {
      setRoomLoader(false);
      log('Erroer $e');
    }
  }

  List<XFile> _images = [];
  List<XFile>? get images => _images;

  set images(value) => _images = value;

  Future<void> pickImages() async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();

    if (selectedImages != null) {
      _images = selectedImages;
      notifyListeners();
    }
  }

  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  uploadRoom(BuildContext context) async {
    var bodyToSend = {
      "city": "Kathmandu",
      "district": selectedDistrict.toString(),
      "address": addressController.text,
      "price": priceController.text,
      "description": descriptionController.text,
    };

    log("UPLOAD BODYTOSEND $bodyToSend");

    try {
      final response = await _roomRepo.uploadRoom(context, bodyToSend, images!);
      log("RESPONSE USER upload: $response");
      if (response != null) {
        Utils.snackBar("Room posted successfully!!!", context);
        getRoom(context);
        Navigator.pop(context);
      }
    } catch (e) {
      log('Erroer $e');
    }
  }

  //GET USER DETAIL

  Map<String, dynamic> _userData = {};
  Map get userData => _userData;

  set userData(value) => _userData = value;

  getUserDetail(BuildContext context) async {
    _selectedDistrict = "";
    setRoomLoader(true);
    try {
      final response = await _roomRepo.getUserDetail(context);
      log("SSSUSER DETAILS:$response");
      _userData = response;
      _selectedDistrict = userData['district'];

      setRoomLoader(false);

      notifyListeners();
    } catch (e) {
      setRoomLoader(false);
      log('Erroer $e');
    }
  }

  List _userRooms = [];
  List get userRooms => _userRooms;

  set userRooms(List value) => _userRooms = value;

  getUserRooms(BuildContext context) async {
    var userId = await _appUrl.readUserId();
    setRoomLoader(true);
    try {
      final response = await _roomRepo.getUserRooms(context, userId);
      log("UserRooms:$response");
      _userRooms = response;
      setRoomLoader(false);
      notifyListeners();
    } catch (e) {
      setRoomLoader(false);
      log('Erroer $e');
    }
  }

  //
  bool _isDistrictLoading = false;
  bool get isDistrictLoading => this._isDistrictLoading;

  List _districtList = [];
  List get districtList => _districtList;

  set districtList(value) => _districtList = value;

  String _selectedDistrict = "";
  get selectedDistrict => this._selectedDistrict;

  setSelectedDistrict(value, BuildContext context) {
    _selectedDistrict = value;
    getRoom(context, true);
    notifyListeners();
  }

  setIsDistrictLoading(bool value) {
    _isDistrictLoading = value;
    notifyListeners();
  }

  final _authRepo = AuthRepository();
  getDistrict(BuildContext context) async {
    setIsDistrictLoading(true);
    try {
      final response = await _authRepo.getDistrict(context);
      setIsDistrictLoading(false);
      log("CityResponse $response ");
      _districtList = response['data'];

      notifyListeners();
    } catch (e) {
      setIsDistrictLoading(false);
      log('Erroer $e');
    }
  }

  bool _isExpanded = false;

  get isExpanded => this._isExpanded;

  setIsExpanded(value) {
    this._isExpanded = value;
    notifyListeners();
  }

  Future transactionValidate(BuildContext context) async {
    if (isUnderReview) {
      Utils.showMyDialog("Your payment is under progress please wait 10-20 min",
          context, "Verifying...");
    }
    var user_id = await _appUrl.readUserId();

    var bodyToSend = {"userid":user_id};
    log("UPLOAD BODYTOSEND For TRANSaction $bodyToSend");
    try {
      final response = await _roomRepo.transactionValidate(context, bodyToSend);
      log("RESPONSE USER upload Trancation: $response");

      if (response != null) {
        _isUnderReview = false;

        String message = response["message"];
        log("MESSAFE:::$message");
        if (message == "You do not have access.") {
          _appUrl.storeToken("");
          // Utils.showSubscriptionDialog(
          //     "Unlock premium features with our subscription plan.Rs:10/Month"
          //         .toString(),
          //     "Subscribe Now",
          //     context);
          Utils.showSubscriptionDialogForQRScanner(
              "Unlock premium features with our subscription plan.Rs:10/Month"
                  .toString(),
              "Subscribe Now",
              context);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UploadYourRoomScreen();
          }));
        }

        notifyListeners();
      }
    } catch (e) {
      log('Erroer $e');
    }
  }

  TextEditingController _transactionCodeController = TextEditingController();
  TextEditingController get transactionCodeController =>
      this._transactionCodeController;

  set transactionCodeController(TextEditingController value) =>
      this._transactionCodeController = value;

  bool _isSubmitLoading = false;
  get isSubmitLoading => _isSubmitLoading;

  setIsSubmitLoading(bool value) {
    _isSubmitLoading = value;
    notifyListeners();
  }

  bool _isUnderReview = false;
  get isUnderReview => this._isUnderReview;

  setIsUnderReview(value) {
    this._isUnderReview = value;
  }

  Future transactionSubmit(BuildContext context) async {
    setIsSubmitLoading(true);
    var user_id = await _appUrl.readUserId();

    var bodyToSend = {
      "user": user_id,
      "transaction_id": _transactionCodeController.text
    };
    log("UPLOAD BODYTOSEND For TRANSaction Submit $bodyToSend");
    try {
      final response = await _roomRepo.transactionSubmit(context, bodyToSend);
      log("RESPONSE USER upload Trancation: $response");
      setIsSubmitLoading(false);
      if (response != null) {
        _isUnderReview = true;
        Navigator.pop(context);
        _transactionCodeController.clear();
        Utils.showMyDialog(
            "Your payment is under progress please wait 10-20 min",
            context,
            "Verifying...");
        notifyListeners();
      }
    } catch (e) {
      setIsSubmitLoading(false);
      log('Erroer $e');
    }
  }
}
