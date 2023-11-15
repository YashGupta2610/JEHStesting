import 'package:flutter/material.dart';
import 'package:SchoolBot/providers/messages.dart';

class MessageWidget extends StatelessWidget {
  final SchoolMessages _messageData;

  MessageWidget(this._messageData);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      // color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              colors: [
                // Colors.white,
                Colors.yellow[100]!,
                Colors.redAccent[100]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            )),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.today,
                  color: Colors.orange[900],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  _messageData.create_timestamp,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Divider(
              endIndent: 10,
              indent: 10,
              color: Colors.grey,
              height: 20,
              thickness: 1,
            ),
            Text(
              _messageData.message,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
      ),
    );
  }
}
