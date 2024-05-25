import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/services/app_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class NetworkApiService {
  final _appUrl = AppUrl();
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future getGetApiResponseWithToken(String url) async {
    var token = await _appUrl.readToken();
    log("SSSSTOKEN:$token");
    dynamic responseJson;
    var headersTobeSend = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    log("AAASSESSS:$headersTobeSend");

    try {
      final response = await http.get(Uri.parse(url), headers: headersTobeSend);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    log("URL:::$url");
    log("BODYTODSEDN:SSSL:$data");

    try {
      Response response = await post(
        Uri.parse(url), body: jsonEncode(data),

        headers: {
           "Content-Type": "application/json",
          // "Authorization":"Token ${AppUrl.token}"
        }
      );
      log("RESPONSE::::${response.body}and ${response.statusCode}");

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  postImageWithBody(url, queryParameters, List<XFile> image) async {
     var token = await _appUrl.readToken();
    log("SSSSTOKEN:$token");
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    log("HEADERS: $headers");
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(queryParameters);

    for (int i = 0; i <= image.length - 1; i++) {
      request.files
          .add(await http.MultipartFile.fromPath('images', image[i].path));
    }

    // request.files.add(await http.MultipartFile.fromPath('file[]', image!));
    request.headers.addAll(headers);
    print(image);

    http.StreamedResponse response = await request.send();

    var responseData = await http.Response.fromStream(response);
    log("responseData.body postImage ${responseData.statusCode} and ${responseData.body}");

    return returnResponse(responseData);
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error accured while communicating with server' +
                'with status code' +
                response.statusCode.toString());
    }
  }
}
