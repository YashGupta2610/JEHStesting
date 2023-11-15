import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/providers/auth.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = '/accountScreen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var _userData = Provider.of<Auth>(context, listen: false);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin:
                      EdgeInsets.only(top: 30, bottom: 80, right: 5, left: 5),
                  child: Container(
                    height: 170,
                    width: deviceSize.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            // ignore: deprecated_member_use
                            Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.7),
                            Theme.of(context).primaryColor.withOpacity(0.9),
                            Theme.of(context).primaryColor
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 0.6, 0.8],
                        )),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(20),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // border: Border.all(width: 2, color: Colors.white38),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/images/Account_Circle.png",
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(bottom: 20),
                  elevation: 10,
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 100,
                    width: deviceSize.width * 0.85,
                    // color: Colors.white70
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _userData.userName,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          _userData.loginusername,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                        Text(
                          "testUser@gmail.com",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: 20,
              ),
              Container(
                // height: 100,
                margin: EdgeInsets.only(
                  top: 80,
                ),
                padding: EdgeInsets.symmetric(horizontal: 100),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.vpn_key,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                        label: Text(
                          "Change Password",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: Colors.grey),
                        )),
                    Divider(
                      // thickness: 0.5,
                      color: Colors.grey,
                    ),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                        label: Text(
                          "Logout",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: Colors.grey),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
