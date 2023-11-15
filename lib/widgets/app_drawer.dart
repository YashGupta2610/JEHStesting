import 'dart:ui';

import 'package:SchoolBot/screens/contact_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:SchoolBot/screens/home_screen.dart';
import 'package:SchoolBot/screens/messages_screen.dart';
import 'package:SchoolBot/screens/notification_screen.dart';
import 'package:SchoolBot/screens/gallery_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
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

    Widget divder = Divider(
      indent: 15,
      endIndent: 15,
      height: 1,
      thickness: 0.5,
      // color: Colors.white,
    );
    Widget text(String data) => Text(
          data,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18,
              // fontWeight: FontWeight.w400,
              color: Colors.grey[700]),
        );
    Widget icon(IconData data, Color color) => Icon(
          data,
          size: 28,
          color: color,
        );
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        _showErrorDialog('Could not launch webpage $url');
      }
    }

    return Drawer(
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          color: Colors.white60,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AppBar(
                    elevation: 0,
                    // title: Container(
                    //     height: deviceSize.height * 0.1,
                    //     child: Image.asset("assets/images/elogo_trans.png")),
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    backgroundColor: Colors.transparent),
                Card(
                  elevation: 5,
                  color: Colors.white.withOpacity(0.95),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 60,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 1.5, color: Colors.orange[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/sb_logo.png',
                            // height: deviceSize.height * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${Provider.of<Auth>(context).userName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      height: 0.80,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 22),
                            ),
                            Text(
                              "${Provider.of<Auth>(context).loginusername}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  color: Colors.white.withOpacity(0.95),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: icon(Icons.school, Colors.lightGreen[300]!),
                        title: text("Students"),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(HomeScreen.routeName);
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),
                      divder,
                      ListTile(
                        leading:
                            icon(Icons.mail_outline, Colors.redAccent[100]!),
                        title: text("Messages"),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(MessagesScreen.routeName);
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),
                      divder,
                      ListTile(
                        leading:
                            icon(Icons.notifications_none, Colors.blue[200]!),
                        title: text('Notifications'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              NotificationScreen.routeName);
                        },
                      ),
                      divder,
                      ListTile(
                        leading: icon(Icons.photo_library, Colors.teal[200]!),
                        title: text('Gallery'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(GalleryScreen.routeName);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  color: Colors.white.withOpacity(0.95),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading:
                            icon(Icons.phone_iphone, Colors.amberAccent[200]!),
                        title: text("Contact"),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(ContactUsScreen.routeName);
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),
                      divder,
                      ListTile(
                        leading:
                            icon(Icons.info_outline, Colors.purpleAccent[100]!),
                        title: text('About'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                        onTap: () {
                          _launchURL("https://jubileecbsenri.in/about.html");
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(
                      Icons.power_settings_new,
                      size: 28,
                      color: Colors.red,
                    ),
                    title: text('Logout'),
                    onTap: () {
                      // Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/');
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
