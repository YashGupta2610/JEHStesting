import 'package:SchoolBot/providers/attendance.dart';
import 'package:SchoolBot/providers/exam_marks.dart';
import 'package:SchoolBot/providers/fees.dart';
import 'package:SchoolBot/providers/payment.dart';
import 'package:SchoolBot/providers/timetable.dart';
import 'package:SchoolBot/screens/contact_us_screen.dart';
import 'package:SchoolBot/screens/fees_screen.dart';
// import 'package:SchoolBot/screens/notification_form.dart';
import 'package:SchoolBot/screens/progress_report_screen.dart';
import 'package:SchoolBot/screens/student_details_screen.dart';
import 'package:SchoolBot/screens/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:SchoolBot/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/providers/messages.dart';
import 'package:SchoolBot/providers/gallery.dart';
import 'package:SchoolBot/providers/notification.dart';
import 'package:SchoolBot/screens/account_screeen.dart';
import 'package:SchoolBot/screens/auth_screen.dart';
import 'package:SchoolBot/screens/home_screen.dart';
import 'package:SchoolBot/screens/initial_fetch.dart';
import 'package:SchoolBot/screens/loading_screen.dart';
import 'package:SchoolBot/screens/messages_screen.dart';
import 'package:SchoolBot/screens/notification_screen.dart';
import 'package:SchoolBot/screens/attendance_screen.dart';
import 'package:SchoolBot/screens/gallery_screen.dart';

// import 'package:SchoolBot/services/local_notification_service.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// ///Recive message and open app when app is in background
// Future<void> backgroundHandler(RemoteMessage message) async {
//   // print('here');
//   print(message.data.toString());
//   print(message.notification!.title);
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // LocalNotificaitonService.initialize();
  // await Firebase.initializeApp();
  //
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // var token = await FirebaseMessaging.instance.getToken(
  //     vapidKey:
  //         'BBwdEYGhmew4W44ZNj51_R1pksmWgRxq4WmkkqstwBtH0EOxwsFV7IoiYWC6MVhdTJnC_r1cxILO6HlYOU-9QaU');
  // print(token);
  //
  // NotificationSettings settings =
  //     await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  //
  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }

  runApp(MyApp());

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // ///gives the message to open app from terminated state
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     final routeFromMessage = message.data["route"];
    //     print(routeFromMessage);
    //
    //     Navigator.of(context).pushNamed("/notificationScreen");
    //   }
    // });

    // ///foreground screen work
    // FirebaseMessaging.onMessage.listen((message) {
    //   if (message.notification != null) {
    //     // print(message.notification.body);
    //     // print(message.notification.title);
    //   }
    //   // LocalNotificaitonService.display(message);
    // });
    //
    // ///When app in background and open and user taps on the notification
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   final routeFromMessage = message.data["route"];
    //
    //   print(routeFromMessage);
    //   Navigator.of(context).pushNamed('/notificationScreen');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Notice>(
            update: (ctx, auth, _) =>
                Notice(authenticationKey: auth.authenticationKey!),
            create: (BuildContext context) {
              return Notice();
            },
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Message>(
            update: (ctx, auth, _) =>
                Message(authenticationKey: auth.authenticationKey!),
            create: (BuildContext context) {
              return Message();
            },
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Gallery>(
            update: (ctx, auth, _) =>
                Gallery(authenticationKey: auth.authenticationKey!),
            create: (BuildContext context) {
              return Gallery();
            },
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, TimeTable>(
            update: (ctx, auth, _) =>
                TimeTable(authenticationKey: auth.authenticationKey!),
            create: (BuildContext context) {
              return TimeTable();
            },
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, ExamMarks>(
            update: (ctx, auth, _) =>
                ExamMarks(authenticationKey: auth.authenticationKey!),
            create: (BuildContext context) {
              return ExamMarks();
            },
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, SchoolFees>(
            update: (ctx, auth, _) =>
                SchoolFees(authenticationKey: auth.authenticationKey!),
            create: (BuildContext context) {
              return SchoolFees();
            },
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, SchoolPayment>(
            update: (ctx, auth, _) =>
                SchoolPayment(authenticationKey: auth.authenticationKey!),
            create: (BuildContext context) {
              return SchoolPayment();
            },
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Attandance>(
            update: (ctx, auth, _) =>
                Attandance(authenticationKey: auth.authenticationKey!),
            create: (BuildContext context) {
              return Attandance();
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                child: SizedBox(),
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              );
            },
            debugShowCheckedModeBanner: false,
            title: 'SchoolBot',
            theme: ThemeData(
              primaryColor: Color.fromRGBO(87, 27, 47, 1),
              secondaryHeaderColor: Colors.white,
              canvasColor: Colors.white70,
              fontFamily: 'BalooPaaji2',
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor,
              ),
              primaryColorDark: Colors.brown[900],
              textTheme: TextTheme(
                labelLarge:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                titleSmall:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                titleMedium:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                bodySmall: TextStyle(fontWeight: FontWeight.w400),
                displayLarge:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                bodyLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                bodyMedium:
                    TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                displayMedium:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              appBarTheme: AppBarTheme(
                  color: Color.fromRGBO(109, 76, 65, 1),
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.grey)),
            ),
            home: auth.isAuth
                ? InitialScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? LoadingScreen()
                            : AuthScreen(),
                  ),
            routes: {
              HomeScreen.routeName: (ctx) => HomeScreen(),
              MessagesScreen.routeName: (ctx) => MessagesScreen(),
              NotificationScreen.routeName: (ctx) => NotificationScreen(),
              AccountScreen.routeName: (ctx) => AccountScreen(),
              StudentDetailsScreen.routeName: (ctx) => StudentDetailsScreen(),
              GalleryScreen.routeName: (ctx) => GalleryScreen(),
              AttendanceScreen.routeName: (ctx) => AttendanceScreen(),
              TimeTableScreen.routeName: (ctx) => TimeTableScreen(),
              ProgressReportScreen.routeName: (ctx) => ProgressReportScreen(),
              FeesScreen.routeName: (ctx) => FeesScreen(),
              ContactUsScreen.routeName: (ctx) => ContactUsScreen(),
            },
          ),
        ));
  }
}
