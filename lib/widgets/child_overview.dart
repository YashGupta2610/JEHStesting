import 'package:SchoolBot/screens/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:SchoolBot/providers/auth.dart';

class ChildOverview extends StatelessWidget {
  final StudentData _studentData;

  ChildOverview(this._studentData);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(StudentDetailsScreen.routeName,
            arguments: _studentData.studentId);
      },
      child: Card(
        // color: Colors.grey[50],
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.grey[50],
          ),
          child: Column(
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.amber[100],
                              child: Icon(
                                Icons.person,
                                color: Colors.amberAccent[400],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text("${_studentData.name}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.grey[700],
                                      )),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.lightGreen[100],
                              child: Icon(
                                Icons.school,
                                color: Colors.lightGreen[300],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                (_studentData.sectionName ==
                                        _studentData.className)
                                    ? "${_studentData.className}"
                                    : "${_studentData.className}-${_studentData.sectionName}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.grey[700],
                                    )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.purple[50],
                              child: Icon(
                                Icons.cake,
                                color: Colors.purple[200],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              _studentData.birthday,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.orangeAccent, width: 2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          placeholder: AssetImage("assets/images/profileO.png"),
                          image: NetworkImage("${_studentData.imageUrl}")),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.red[100],
                    child: Icon(
                      Icons.contact_mail,
                      size: 20,
                      color: Colors.redAccent[100],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      _studentData.email,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            height: 1,
                            color: Colors.grey[700],
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
