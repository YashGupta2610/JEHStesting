// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as https;

import 'package:SchoolBot/models/http_exception.dart';

class SchoolMessages {
  String comm_id;
  String message;
  String create_timestamp;

  SchoolMessages({
    required this.comm_id,
    required this.message,
    required this.create_timestamp,
  });
}

class Message with ChangeNotifier {
  final String authenticationKey;

  Message({this.authenticationKey = ""});

  List<SchoolMessages> _messageData = [];

  List<SchoolMessages> get messageData {
    return [..._messageData];
  }

  Future<void> getMessages() async {
    final url =
        "https://schoolbot.in/jehs/index.php/mobile/get_sms_all?authenticate=$authenticationKey&user_type=parent";

    try {
      // print("checking");
      final response = await https.get(Uri.parse(url));
      // print("checking");
      final responseData = json.decode(response.body);
      // print(responseData);

      List _responseMessage = responseData;
      if (_responseMessage.length > 0) {
        _messageData.clear();
            }

      _responseMessage.forEach((singleMessage) {
        var _message = SchoolMessages(
          comm_id:
              singleMessage["comm_id"].toString().replaceAll("&#039;", "\'"),
          create_timestamp: singleMessage["create_timestamp"],
          message:
              singleMessage["message"].toString().replaceAll("&#039;", "\'"),
        );
        _messageData.add(_message);
      });

      notifyListeners();
    } on SocketException catch (error) {
      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
      throw HttpException("Check Internet Connectivity\nor\nTry again later");
    } catch (error) {
      // print(error);
      throw error;
    }
  }
}
