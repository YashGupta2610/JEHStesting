// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:SchoolBot/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;

class FeesData {
  String invoice_id;
  String student_id;
  String title;
  String description;
  String amount;
  String amount_paid;
  String due;
  String creation_timestamp;
  String payment_timestamp;
  String due_date;
  String payment_method;
  String payment_details;
  String status;
  String year;
  String month;
  String sms_timestamp;
  String fee_type;
  String cheque_number;
  String cheque_date_timestamp;
  String card_number;
  String discount;
  String create_timestamp;

  FeesData({
    required this.invoice_id,
    required this.student_id,
    required this.title,
    required this.description,
    required this.amount,
    required this.amount_paid,
    required this.due,
    required this.creation_timestamp,
    required this.payment_timestamp,
    required this.due_date,
    required this.payment_method,
    required this.payment_details,
    required this.status,
    required this.year,
    required this.month,
    required this.sms_timestamp,
    required this.fee_type,
    required this.cheque_number,
    required this.cheque_date_timestamp,
    required this.card_number,
    required this.discount,
    required this.create_timestamp,
  });
}

class SchoolFees with ChangeNotifier {
  final String authenticationKey;

  SchoolFees({this.authenticationKey = ""});

  List<FeesData> _feesData = [];

  List<FeesData> get feesData {
    return _feesData;
  }

  Future<void> getFeeDetails(String studentId) async {
    print(studentId);
    final url =
        "https://schoolbot.in/jehs/index.php/mobile/get_single_student_accounting?authenticate=$authenticationKey&student_id=$studentId&user_type=parent";

    try {
      final response = await https.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      // print(responseData);

      List _responseFeesData = responseData;
      _feesData.clear();

      _responseFeesData.forEach((fees) {
        var _fees = FeesData(
            invoice_id: fees["invoice_id"],
            amount: fees["amount"],
            amount_paid: fees["amount_paid"],
            card_number: fees["card_number"],
            cheque_date_timestamp: fees["cheque_date_timestamp"],
            cheque_number: fees["cheque_number"],
            create_timestamp: fees["create_timestamp"],
            creation_timestamp: fees["creation_timestamp"],
            description: fees["description"],
            discount: fees["discount"],
            due: fees["due"],
            due_date: fees["due_date"],
            fee_type: fees["fee_type"],
            month: fees["month"],
            payment_details: fees["payment_details"],
            payment_method: fees["payment_method"],
            payment_timestamp: fees["payment_timestamp"],
            sms_timestamp: fees["sms_timestamp"],
            status: fees["status"],
            student_id: fees["student_id"],
            title: fees["title"],
            year: fees["year"]);
        _feesData.add(_fees);
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
