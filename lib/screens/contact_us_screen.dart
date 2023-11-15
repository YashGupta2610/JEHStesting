// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:SchoolBot/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  static const routeName = '/contactUsScreen';

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error!'),
          content: Text(message, textAlign: TextAlign.center),
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

    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        _showErrorDialog('Could not launch WhatsApp');
      }
    }

    return Scaffold(
        appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Contact Details",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(color: Colors.amberAccent[400]),
            )),
        drawer: AppDrawer(),
        backgroundColor: Colors.white,
        drawerScrimColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/svg/contactUs.svg",
                  height: 140,
                ),
              ),
              Card(
                elevation: 10,
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "JUBILEE ENGLISH HIGH SCHOOL",
                        style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Welfare Desk :",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800]),
                      ),
                      Text(
                        "Timings 8AM to 4PM - Mon to Friday, and 8AM to 1PM on Saturday",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            height: 1.1,
                            fontWeight: FontWeight.w400),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.phone,
                          color: Colors.amberAccent[400],
                        ),
                        onPressed: () => launch("tel://6366372314"),
                        label: Text("636 637 2314",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            )),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.phone,
                          color: Colors.amberAccent[400],
                        ),
                        onPressed: () => launch("tel://6366372313"),
                        label: Text("636 637 2313",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            )),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.mail,
                          color: Colors.amberAccent[400],
                        ),
                        onPressed: () =>
                            launch("mailto:principal@jubileecbsenri.in"),
                        label: Text("principal@jubileecbsenri.in",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            )),
                      ),
                      Divider(),
                      Text(
                        "App Support :",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800]),
                      ),
                      Text(
                        "Please Contact only through whatsapp chat",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            height: 1.1,
                            fontWeight: FontWeight.w400),
                      ),
                      TextButton(
                        onPressed: () => _launchURL(
                            "https://wa.me/+919845871639/?text=Hello"),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/whatsapp.png",
                              height: 24,
                            ),
                            Text("+91 9845871639",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                )),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.mail,
                          color: Colors.amberAccent[400],
                        ),
                        onPressed: () => launch("mailto:support@ibottic.com"),
                        label: Text("support@ibottic.com",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
