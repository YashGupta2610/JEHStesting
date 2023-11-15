import 'package:SchoolBot/providers/fees.dart';
import 'package:SchoolBot/providers/payment.dart';
import 'package:SchoolBot/widgets/child_invoice_overview.dart';
import 'package:SchoolBot/widgets/student_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/providers/auth.dart';
import 'package:SchoolBot/models/http_exception.dart';

class FeesScreen extends StatefulWidget {
  static const routeName = '/FeesScreen';

  @override
  _FeesScreenState createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  bool _isInit = true;
  bool _isloading = true;
  late String _studentId;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _studentId = ModalRoute.of(context)?.settings.arguments as String;
      await _fetchFeeDetails();
      await _fetchPaymentDetails();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message, textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              _fetchFeeDetails();
              _fetchPaymentDetails();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _fetchFeeDetails() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<SchoolFees>(context, listen: false)
          .getFeeDetails(_studentId);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  //Fetching payment data

  Future<void> _fetchPaymentDetails() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<SchoolPayment>(context, listen: false)
          .getPaymentDetails(_studentId);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    StudentData _studentData =
        Provider.of<Auth>(context, listen: false).findStudentById(_studentId);
    List<FeesData> _feeDetails = Provider.of<SchoolFees>(context).feesData;
    List<Payment> _paymentDetails =
        Provider.of<SchoolPayment>(context).paymentData;
    print(_paymentDetails);
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Fee Details",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.amber[700]),
            )),
        backgroundColor: Colors.white,
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColorDark,
                ),
              )
            : Column(
                children: [
                  StudentHeader(_studentData),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          ..._feeDetails.map((_feeData) => Card(
                              elevation: 10,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Text(
                                      "${_feeData.fee_type}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                        fontSize: 22,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    color: Colors.amber[700],
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Invoice No. ${_feeData.invoice_id}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                            "${_feeData.month}, ${_feeData.year}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total Fee",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("${_feeData.amount}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Amount Paid"),
                                            Text(
                                              "${_feeData.amount_paid}",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Amount due"),
                                            Text("${_feeData.due}",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ],
                                        ),
                                        Divider(
                                          height: 16,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Due Date"),
                                            Text(
                                              "${_feeData.due_date}",
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ))),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    color: Colors.amber[700],
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            "Payment Summary",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Amount",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Date ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Mode ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Fee Type ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "Ref. No.",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),
                                ..._paymentDetails.map((item) {
                                  return ChildrenPaymentOverview(item);
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Download Summary")))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
