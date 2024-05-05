import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_services.dart';
import '../utils/utils.dart';

class RoomRepository {
  final _networkService = NetworkApiService();

  getDistrict(context) async {
    try {
      final response = await _networkService
          .getGetApiResponse('${AppUrl.primaryUrl}api/user/district/')
          .catchError((error, stackTrace) {
        Utils.showMyDialog(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
      });

      return response;
    } catch (e) {
      throw e;
    }
  }

  getRooms(context) async {
    try {
      final response = await _networkService
          .getGetApiResponseWithToken('${AppUrl.primaryUrl}api/room/')
          .catchError((error, stackTrace) {
        Utils.showMyDialog(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
      });

      return response;
    } catch (e) {
      throw e;
    }
  }

  getRoomsByDistrict(BuildContext context, String district) async {
    try {
      final response = await _networkService
          .getGetApiResponseWithToken(
              '${AppUrl.primaryUrl}api/room/?district=$district')
          .catchError((error, stackTrace) {
        Utils.showMyDialog(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
      });

      return response;
    } catch (e) {
      throw e;
    }
  }

  getUserDetail(context) async {
    try {
      final response = await _networkService
          .getGetApiResponseWithToken('${AppUrl.primaryUrl}api/user/profile/')
          .catchError((error, stackTrace) {
        Utils.showMyDialog(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
      });

      return response;
    } catch (e) {
      throw e;
    }
  }

  getUserRooms(context, String userId) async {
    try {
      final response = await _networkService
          .getGetApiResponseWithToken(
              '${AppUrl.primaryUrl}api/room/user/$userId')
          .catchError((error, stackTrace) {
        Utils.showMyDialog(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
      });

      return response;
    } catch (e) {
      throw e;
    }
  }

  getRoomsByID(BuildContext context, dynamic roomId) async {
    try {
      final response = await _networkService
          .getGetApiResponseWithToken('${AppUrl.primaryUrl}api/room/$roomId')
          .catchError((error, stackTrace) {
        Utils.showMyDialog(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
      });

      return response;
    } catch (e) {
      throw e;
    }
  }

  uploadRoom(BuildContext context, var bodyToSend, List<XFile> images) async {
    try {
      final response = await _networkService
          .postImageWithBody(
              '${AppUrl.primaryUrl}/api/room/', bodyToSend, images)
          .catchError((error, stackTrace) {
        Utils.showMyDialog(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
      });

      return response;
    } catch (e) {
      throw e;
    }
  }

  loginUser(BuildContext context, var bodyToSend) async {
    try {
      final response = await _networkService
          .getPostApiResponse(
              '${AppUrl.primaryUrl}/api/user/login/', bodyToSend)
          .catchError((error, stackTrace) {
        Utils.showMyDialog(error.toString(), context);
        if (kDebugMode) {
          print(error.toString());
        }
      });

      return response;
    } catch (e) {
      throw e;
    }
  }
}
