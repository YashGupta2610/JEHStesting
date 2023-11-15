import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/widgets/app_drawer.dart';
import 'package:SchoolBot/widgets/child_overview.dart';
import 'package:SchoolBot/providers/auth.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final List<StudentData> _studentList =
        Provider.of<Auth>(context).studentData;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: deviceSize.height * 0.09,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
              Expanded(
                child: Text(
                  "Jublee English High School",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.grey[700]),
                ),
              )
            ],
          ),
        ),
        drawer: AppDrawer(),
        backgroundColor: Colors.white,
        drawerScrimColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Student Details",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.grey[700], fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                    child: Divider(
                      height: 50,
                      thickness: 1,
                      endIndent: 5,
                      indent: 5,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.purple[200],
                    child: Text(
                      "${_studentList.length}",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._studentList.map((item) {
                      return ChildOverview(item);
                    })
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
