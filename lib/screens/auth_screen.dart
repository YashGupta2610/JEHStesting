// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/models/http_exception.dart';
import 'package:SchoolBot/providers/auth.dart';

enum LoginMode { Password, Phone }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print("Auth Screen Active");
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            // PushNotification(),
            Column(
              children: [
                Container(
                  height: deviceSize.height * 0.22,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(251, 213, 159, 1)),
                ),
                Container(
                  height: deviceSize.height * 0.01,
                  decoration: BoxDecoration(color: Colors.orange[300]),
                ),
                Container(
                  height: deviceSize.height * 0.77,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: deviceSize.height * 0.10),
                  Flexible(
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      // width: deviceSize.width * 0.6,
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/sb_logo.png',
                          height: deviceSize.height * 0.25,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  AuthCard(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Powered By  "),
                      Image.asset(
                        "assets/images/ibottic_logo.png",
                        width: 80,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, Object> _authData = {'username': '', 'password': '', 'otp': ''};
  var _isLoading = false;
  var _passwordVisible = false;
  final _passwordController = TextEditingController();
  bool _checkOtp = false;
  bool _resendOtpButton = false;
  LoginMode _loginmode = LoginMode.Password;

  late Timer _timer;
  int _start = 30;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _resendOtpButton = true;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });
    try {
      if (_loginmode == LoginMode.Password) {
        await Provider.of<Auth>(context, listen: false).loginPassword(
            _authData["username"].toString(), _authData["password"].toString());
      } else {
        if (_checkOtp) {
          // print("OTP check");
          await Provider.of<Auth>(context, listen: false).loginOtp(
              _authData["username"].toString(), _authData["otp"].toString());
        } else {
          await Provider.of<Auth>(context, listen: false)
              .getOtp(_authData["username"].toString());
          _checkOtp = true;
          startTimer();
        }
      }

      // Log user in
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .getOtp(_authData["username"].toString());
      _checkOtp = true;
      _start = 30;
      startTimer();

      // Log user in
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          width: deviceSize.width * 0.80,
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: (_checkOtp)
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          key: ValueKey(1),
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4)
                          ],
                          initialValue: _authData['otp'].toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0),
                                  borderRadius: BorderRadius.circular(30)),
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              labelText: 'OTP',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 32)),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          onSaved: (value) {
                            _authData['otp'] = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter OTP';
                            }
                            Pattern pattern = r'^\d{4,4}$';
                            RegExp regex = new RegExp(pattern.toString());
                            if (!regex.hasMatch(value)) {
                              return 'Enter a 4 OTP';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_resendOtpButton)
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                child: Text(
                                  'RESEND OTP',
                                  style: TextStyle(color: Colors.brown[800]),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _resendOtpButton = false;
                                    _loginmode = LoginMode.Phone;
                                  });
                                  _resendOtp();
                                },
                              ),
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.brown[800],
                              ),
                              child: Text(
                                'SUBMIT',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _loginmode = LoginMode.Phone;
                                  print(_loginmode);
                                });
                                _submit();
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (!_resendOtpButton)
                          Text(
                            "Resend OTP in $_start seconds",
                            style: TextStyle(fontSize: 18),
                          ),
                        // Row(
                        //   children: <Widget>[
                        //     Flexible(
                        //       child: Divider(
                        //         height: 40,
                        //         thickness: 1,
                        //         endIndent: 5,
                        //       ),
                        //     ),
                        //     Text(
                        //       'Or',
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         color: Colors.orange[300],
                        //       ),
                        //     ),
                        //     Flexible(
                        //       child: Divider(
                        //         indent: 5,
                        //         height: 50,
                        //         thickness: 1,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // FlatButton(
                        //   padding: EdgeInsets.symmetric(horizontal: 40),
                        //   child: Text(
                        //     'Login using password',
                        //     style: TextStyle(
                        //       color: Theme.of(context).primaryColor,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     setState(() {
                        //       _checkOtp = false;
                        //       _loginmode = LoginMode.Password;
                        //     });
                        //     _submit();
                        //   },
                        //   // shape: RoundedRectangleBorder(
                        //   //   borderRadius: BorderRadius.circular(20),
                        //   // ),
                        //   // color: Theme.of(context).primaryColorDark,
                        // ),
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        TextFormField(
                          key: ValueKey(2),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          initialValue: _authData['username'].toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0),
                                  borderRadius: BorderRadius.circular(30)),
                              labelStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              labelText: 'Phone number',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 36,
                              )),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          onSaved: (value) {
                            _authData['username'] = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Phone number';
                            }
                            Pattern pattern = r'^\d{10,10}$';
                            RegExp regex = new RegExp(pattern.toString());
                            if (!regex.hasMatch(value)) {
                              return 'Enter a 10 digit Phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // TextFormField(
                        //   key: ValueKey(3),
                        //   style: TextStyle(
                        //       fontSize: 18, fontWeight: FontWeight.w500),
                        //   decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: Colors.white,
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(30),
                        //         borderSide:
                        //             BorderSide(color: Colors.grey, width: 0.5),
                        //       ),
                        //       border: OutlineInputBorder(
                        //           borderSide: BorderSide(width: 0),
                        //           borderRadius: BorderRadius.circular(30)),
                        //       labelStyle: TextStyle(
                        //           fontSize: 18, fontWeight: FontWeight.w400),
                        //       labelText: 'Password',
                        //       contentPadding: EdgeInsets.symmetric(
                        //         horizontal: 36,
                        //       ),
                        //       suffixIcon: IconButton(
                        //         icon: Icon(_passwordVisible
                        //             ? Icons.visibility
                        //             : Icons.visibility_off),
                        //         disabledColor: Colors.grey,
                        //         onPressed: () {
                        //           setState(() {
                        //             _passwordVisible = !_passwordVisible;
                        //           });
                        //         },
                        //         color: Colors.orange[300],
                        //       )),
                        //   obscureText: !_passwordVisible,
                        //   controller: _passwordController,
                        //   validator: (value) {
                        //     if (_loginmode == LoginMode.Password &&
                        //         value.isEmpty) {
                        //       return 'Enter Password';
                        //     }

                        //     return null;
                        //   },
                        //   onSaved: (value) {
                        //     _authData['password'] = value;
                        //   },
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        (_isLoading)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              )
                            : Column(
                                children: [
                                  // RaisedButton(
                                  //   padding:
                                  //       EdgeInsets.symmetric(horizontal: 50),
                                  //   elevation: 4,
                                  //   child: Text(
                                  //     'LOGIN',
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       _loginmode = LoginMode.Password;
                                  //     });
                                  //     _submit();
                                  //   },
                                  //   shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(20),
                                  //   ),
                                  //   color: Colors.brown[600],
                                  // ),
                                  // Row(
                                  //   children: <Widget>[
                                  //     Flexible(
                                  //       child: Divider(
                                  //         height: 40,
                                  //         thickness: 1,
                                  //         endIndent: 5,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       'Or',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         color: Colors.orange[300],
                                  //       ),
                                  //     ),
                                  //     Flexible(
                                  //       child: Divider(
                                  //         indent: 5,
                                  //         height: 50,
                                  //         thickness: 1,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 40),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.brown[800],
                                    ),
                                    child: Text(
                                      'GET OTP',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _loginmode = LoginMode.Phone;
                                      });

                                      _submit();
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
