import 'package:SchoolBot/providers/payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChildrenPaymentOverview extends StatelessWidget {
  final Payment _studentData;

  ChildrenPaymentOverview(this._studentData);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: double.parse(_studentData.amountPaid) > 0
            ? (Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      _studentData.amountPaid,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                        "${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch((int.parse(_studentData.timestamp) * 1000)))}"),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      checkPaymentMode(int.parse(_studentData.method)),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      _studentData.feeType,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      _studentData.refNo,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ]))
            : SizedBox(
                height: 0,
              ));
  }

  String checkPaymentMode(int modeNumber) {
    if (modeNumber == 1) {
      return 'Cash';
    } else if (modeNumber == 2) {
      return 'Cheque';
    } else if (modeNumber == 3) {
      return 'Online';
    } else if (modeNumber == 4) {
      return 'Card';
    } else {
      return "";
    }
  }
}
