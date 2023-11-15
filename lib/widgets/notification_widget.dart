import 'package:flutter/material.dart';
import 'package:SchoolBot/providers/notification.dart';

class NotificationWidget extends StatelessWidget {
  final SchoolNotification _notificationData;

  NotificationWidget(this._notificationData);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              colors: [
                // Colors.white,
                Colors.blue[200]!,
                Colors.deepOrange[100]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            )),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              _notificationData.notice_title,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.3),
            ),
            SizedBox(
              width: 10,
            ),
            Divider(
              endIndent: 10,
              indent: 10,
              color: Colors.grey,
              height: 20,
              thickness: 1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.notifications_none,
                  color: Colors.deepOrange[300],
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    _notificationData.notice,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.2),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.event_note,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  _notificationData.date,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
