import 'package:SchoolBot/providers/attendance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatefulWidget {
  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  // CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events = {};
  late List<dynamic> _selectedEvents;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    List<AttanDanceData> _attandanceData =
        Provider.of<Attandance>(context, listen: false).attendanceData;
    _attandanceData.forEach((data) {
      _events[data.datetime] = [data.comment];
    });
    // _events = {
    //
    // };
    _selectedEvents = _events[_selectedDay] ?? [];
    // _calendarController = CalendarController();
  }

  @override
  void dispose() {
    // _calendarController.dispose();
    _events.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
        : TableCalendar(
            // events: _events,
            // calendarController: CalendarController(),
            headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                )),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            calendarBuilders: CalendarBuilders(
                singleMarkerBuilder: (context, date, _) => SizedBox(),
                dowBuilder: (context, date) => Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: (events == null)
                        //     ? Colors.transparent
                        //     : events.first == "Present"
                        //         ? Colors.green
                        //         : events.first == "Absent"
                        //             ? Colors.red
                        //             : events.first == "Holiday"
                        //                 ? Colors.blue[300]
                        //                 : events.first ==
                        //                         "Attendance not taken"
                        //                     ? Colors.grey
                        //                     : events.first == "Sunday"
                        //                         ? Colors.yellow
                        //                         : events.first == "Halfday"
                        //                             ? Colors.pink
                        //                             : Colors.transparent),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                selectedBuilder: (context, date, events) => Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
            calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                ),
                selectedTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                todayTextStyle: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).secondaryHeaderColor,
                )),
            focusedDay: DateTime.now(),
            firstDay: DateTime(DateTime.now().year - 1),
            lastDay: DateTime(DateTime.now().year + 2),
          );
  }
}
