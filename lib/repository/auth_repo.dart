import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';
import '../utils/utils.dart';

class AuthRepository {
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

  registerUser(BuildContext context, var bodyToSend) async {
    try {
      final response = await _networkService
          .getPostApiResponse(
              '${AppUrl.primaryUrl}/api/user/register/', bodyToSend)
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



   resetUserPassword(BuildContext context, var bodyToSend) async {
    try {
      final response = await _networkService
          .getPostApiResponse(
              '${AppUrl.primaryUrl}/api/user/reset-password/', bodyToSend)
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
