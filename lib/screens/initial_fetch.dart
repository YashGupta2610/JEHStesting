import 'dart:io';

import 'package:SchoolBot/models/version_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './home_screen.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

class InitialScreen extends StatefulWidget {
  static const routeName = '/initialscreen';

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isInit = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isInit = false;
      await _fetchData();
    }

    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              _fetchData();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showVersionDialog(String appUrl) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    onPressed: () => _launchURL(appUrl),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    onPressed: () => _launchURL(appUrl),
                  ),
                ],
              );
      },
    );
  }

  Future<void> _fetchData() async {
    try {
      // await Provider.of<Auth>(context, listen: false).versionCheck();
      print("fetching data ");

      // print("calling childerdata");
      await Provider.of<Auth>(context, listen: false).fetchChildrenData();
      // await Provider.of<Notice>(context, listen: false).getNotification();
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } on VersionException catch (error) {
      _showVersionDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          width: deviceSize.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sb_logo.png',
                // fit: BoxFit.none,
              ),
              SizedBox(
                height: 20,
              ),
              LinearProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
