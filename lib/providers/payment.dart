import 'dart:convert';
import 'dart:io';

import 'package:SchoolBot/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;

class Payment {
  Payment({
    // this.paymentId,
    // this.expenseCategoryId,
    // this.expenseId,
    // this.title,
    // this.paymentType,
    // this.invoiceId,
    // this.studentId,
    // this.method,
    // this.description,
    // this.amount,
    // this.timestamp,
    // this.year,
    // this.feeType,
    // this.totalAmount,
    // this.chequeNumber,
    // this.chequeDateTimestamp,
    // this.cardNumber,
    // this.createTimestamp,
    // this.dueDate,

    required this.receiptId,
    required this.receiptNumber,
    required this.amountPaid,
    required this.invoiceId,
    required this.studentId,
    required this.method,
    required this.feeType,
    required this.timestamp,
    required this.paymentId,
    required this.cardNumber,
    required this.refNo,
  });

  // final String paymentId;
  // final dynamic expenseCategoryId;
  // final dynamic expenseId;
  // final String title;
  // final String paymentType;
  // final String invoiceId;
  // final String studentId;
  // final dynamic method;
  // final dynamic description;
  // final String amount;
  // final String timestamp;
  // final String year;
  // final String feeType;
  // final String totalAmount;
  // final dynamic chequeNumber;
  // final String chequeDateTimestamp;
  // final String cardNumber;
  // final String createTimestamp;
  // final dynamic dueDate;

  final String receiptId;
  final String receiptNumber;
  final String amountPaid;
  final String invoiceId;
  final String studentId;
  final String method;
  final String feeType;
  final String timestamp;
  final String paymentId;
  final dynamic cardNumber;
  final String refNo;
}

class SchoolPayment with ChangeNotifier {
  final String authenticationKey;

  SchoolPayment({this.authenticationKey = ""});

  List<Payment> _paymentData = [];

  List<Payment> get paymentData {
    return _paymentData;
  }

  Future<void> getPaymentDetails(String studentId) async {
    print(studentId);
    final url =
        "https://schoolbot.in/jehs/index.php/mobile/get_single_student_payment?authenticate=$authenticationKey&student_id=$studentId&user_type=parent";

    try {
      final response = await https.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      // print(responseData);

      List _responseFeesData = responseData;
      _paymentData.clear();

      _responseFeesData.forEach((payment) {
        var _payment = Payment(
          // paymentId: payment["payment_id"],
          // expenseCategoryId: payment["expense_category_id"],
          // expenseId: payment["expense_id"],
          // title: payment["title"],
          // paymentType: payment["payment_type"],
          // invoiceId: payment["invoice_id"],
          // studentId: payment["student_id"],
          // method: payment["method"],
          // description: payment["description"],
          // amount: payment["amount"],
          // timestamp: payment["timestamp"],
          // year: payment["year"],
          // feeType: payment["fee_type"],
          // totalAmount: payment["total_amount"],
          // chequeNumber: payment["cheque_number"],
          // chequeDateTimestamp: payment["cheque_date_timestamp"],
          // cardNumber: payment["card_number"],
          // createTimestamp: payment["create_timestamp"],
          // dueDate: payment["due_date"],

          receiptId: payment["receipt_id"],
          receiptNumber: payment["receipt_number"],
          amountPaid: payment["amount_paid"],
          invoiceId: payment["invoice_id"],
          studentId: payment["student_id"],
          method: payment["method"],
          feeType: payment["fee_type"],
          timestamp: payment["timestamp"],
          paymentId: payment["payment_id"],
          cardNumber: payment["card_number"],
          refNo: payment["ref_no"],
        );
        _paymentData.add(_payment);
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
