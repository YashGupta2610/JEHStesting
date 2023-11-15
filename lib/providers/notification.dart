// ignore_for_file: unused_import, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:SchoolBot/models/http_exception.dart';

class SchoolNotification {
  String notice_id;
  String notice_title;
  String notice;
  String date;

  SchoolNotification({
    required this.notice_id,
    required this.notice_title,
    required this.notice,
    required this.date,
  });
}

class Notice with ChangeNotifier {
  final String authenticationKey;

  Notice({this.authenticationKey = "required"});

  List<SchoolNotification> _notificationData = [];

  List<SchoolNotification> get notificationData {
    return [..._notificationData];
  }

  Future<void> getNotification() async {
    final url =
        'https://schoolbot.in/jehs/index.php/mobile/get_notices?user_type=parent&authenticate=$authenticationKey';

    try {
      // print("checking");
      final response = await https.get(Uri.parse(url));
      // print("checking");
      final responseData = json.decode(response.body);
      // print(responseData);

      List _notifications = responseData;
      if (_notifications.length > 0) {
        _notificationData.clear();
              _notifications.forEach((singleNotification) {
          var _notification = SchoolNotification(
            date: singleNotification["date"],
            notice: singleNotification["notice"]
                .toString()
                .replaceAll("&#039;", "\'"),
            notice_id: singleNotification["notice_id"],
            notice_title: singleNotification["notice_title"]
                .toString()
                .replaceAll("&#039;", "\'"),
          );
          _notificationData.add(_notification);
        });
      }

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
