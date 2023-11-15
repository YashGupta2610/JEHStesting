import 'package:SchoolBot/providers/auth.dart';
import 'package:flutter/material.dart';

class StudentHeader extends StatelessWidget {
  final StudentData _studentData;
  StudentHeader(this._studentData);
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(12),
      width: deviceSize.width * 0.90,
      // color: Colors.white70
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_studentData.name}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                      height: 1.2),
                ),
                Text(
                  "${_studentData.className}-${_studentData.sectionName}",
                  style: TextStyle(
                    color: Colors.grey[800],
                    height: 1.2,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage(
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: AssetImage("assets/images/profileO.png"),
                  image: NetworkImage("${_studentData.imageUrl}")),
            ),
          )
        ],
      ),
    );
  }
}
