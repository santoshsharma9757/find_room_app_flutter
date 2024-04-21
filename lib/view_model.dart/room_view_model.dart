import 'dart:developer';

import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/repository/room_repo.dart';
import 'package:find_your_room_nepal/utils/utils.dart';
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
    await getRoom(context);
    await getUserDetail(context);
  }

  getRoom(BuildContext context) async {
    setRoomLoader(true);
    try {
      final response = await _roomRepo.getRooms(context);
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
      "district": "Kathmandu",
      "address": addressController.text,
      "price": priceController.text,
      "description": descriptionController.text,
      // "user": "09f6435f-68d9-48bf-8077-fe934083821d"
    };

    try {
      final response = await _roomRepo.uploadRoom(context, bodyToSend, images!);
      log("RESPONSE USER upload: $response");
      if (response != null) {
        Utils.snackBar(response['data'].toString(), context);
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
    // var userId = await _appUrl.readUserId();
    setRoomLoader(true);
    try {
      final response = await _roomRepo.getUserDetail(context);
      log("SSSUSER DETAILS:$response");
      _userData = response;

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
}
