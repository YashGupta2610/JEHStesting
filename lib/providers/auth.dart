import 'dart:convert';
import 'dart:io';

import 'package:SchoolBot/models/version_exception.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as https;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:SchoolBot/models/http_exception.dart';

class StudentData {
  String studentId;
  String studentCode;
  String name;
  String birthday;
  String gender;
  String religion;
  String cast;
  String bloodGroup;
  String address;
  String phone;
  String email;
  String password;
  String dormitoryRoomNumber;
  String authenticationKey;
  String aadharNumber;
  String admissionNumber;
  String className;
  String sectionName;
  String imageUrl;

  StudentData({
    required this.aadharNumber,
    required this.address,
    required this.admissionNumber,
    required this.birthday,
    required this.authenticationKey,
    required this.bloodGroup,
    required this.cast,
    required this.className,
    required this.dormitoryRoomNumber,
    required this.email,
    required this.gender,
    required this.imageUrl,
    required this.name,
    required this.password,
    required this.phone,
    required this.religion,
    required this.sectionName,
    required this.studentCode,
    required this.studentId,
  });
}

class Auth with ChangeNotifier {
  List<StudentData> _studentData = [];
  String _authenticationKey = "";
  late String _loginType;
  late String _loginUserId;
  late String _username;
  late String _loginusername;
  // String _password;
  var birthday;
  String? titleCase(String text) {
    if (text == null) return null;
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      if (word.isNotEmpty) {
        var first = word.substring(0, 1).toUpperCase();
        var rest = word.substring(1);
        return '$first$rest';
      }
      return "";
    });
    return capitalized.join(' ');
  }

  List<StudentData> get studentData {
    return [..._studentData];
  }

  bool get isAuth {
    return authenticationKey != "";
  }

  String? get authenticationKey {
    print(_authenticationKey + "auth");
    return _authenticationKey;
    return null;
  }

  String get userName {
    return titleCase(_username)!;
  }

  String get loginType {
    return titleCase(_loginType)!;
  }

  String get loginUserId {
    return (_loginUserId);
  }

  String get loginusername {
    return (_loginusername);
  }

  // String get password {
  //   return (_password);
  // }

  StudentData findStudentById(String id) {
    return _studentData.firstWhere((_student) => _student.studentId == id);
  }

  Future<void> _authenticate(
      String username, String password, String login) async {
    String url = '';

    if (login == "password") {
      url =
          'https://schoolbot.in/jehs/index.php/mobile/login?authenticate=false&email=$username&password=$password';
    }
    if (login == "otp") {
      url =
          'https://schoolbot.in/jehs/index.php/mobile/login_otp?authenticate=false&mobile=$username&otp=$password';
    }
    try {
      // print("checking");

      final response = await https.get(Uri.parse(url));
      // print("checking");
      final responseData = json.decode(response.body);
      // print(responseData);
      if (responseData.containsKey("error")) {
        throw HttpException(responseData["error"]);
      }
      _authenticationKey = responseData['authentication_key'];
      _loginType = responseData['login_type'];
      _loginUserId = responseData['login_user_id'];
      _username = responseData['name'];
      _loginusername = username;

      // _password = password;

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'authenticationKey': _authenticationKey,
          'loginType': _loginType,
          'loginUserId': _loginUserId,
          'username': _username,
          'loginusername': _loginusername,
          // 'password': _password
        },
      );
      prefs.setString('userData', userData);
      notifyListeners();
    } on SocketException catch (error) {
      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
      throw HttpException("Check Internet Connectivity\nor\nTry again later");
    } on FormatException catch (_) {
      throw HttpException("Incorrect Username or Password");
    } catch (error) {
      if (login == "otp" &&
          error.toString().contains("email or password incorrect")) {
        throw HttpException("Incorrect OTP");
      } else {
        // print("this error : $error");
        throw error;
      }
    }
  }

  Future<void> loginPassword(String phone, String password) async {
    return _authenticate(phone, password, 'password');
  }

  Future<void> loginOtp(String phone, String otp) async {
    // print("$phone and $otp");
    return _authenticate(phone, otp, 'otp');
  }

  Future<void> getOtp(String phone) async {
    // print("running1");
    final url =
        'https://schoolbot.in/jehs/index.php/mobile/send_otp?authenticate=false&mobile=$phone';

    try {
      // print("running2");

      final response = await https.get(Uri.parse(url));
      // print("running2");
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData.containsKey("error")) {
        throw HttpException(responseData["error"]);
      }
    } on SocketException catch (error) {
      // print(error);

      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
      throw HttpException("Check Internet Connectivity\nor\nTry again later");
    } on FormatException catch (_) {
      throw HttpException("Incorrect Username or Password");
    } catch (error) {
      // print("error : $error");
      throw error;
    }
  }

  Future<void> fetchChildrenData() async {
    final url =
        'https://schoolbot.in/jehs/index.php/mobile/get_parent_info?mobile=$loginusername&user_type=parent&authenticate=$authenticationKey';
    try {
      final response = await https.get(Uri.parse(url));
      // print("response ${response.statusCode}");
      final responseData = json.decode(response.body);
      // print("responseData ${responseData}");
      if (responseData.containsKey("error")) {
        throw HttpException(responseData["error"]);
      }
      // print(responseData);
      List _responseChildren = responseData['children'];
      _studentData.clear();
      _responseChildren.forEach((child) {
        var _child = StudentData(
          aadharNumber: child["aadhar_number"].toString(),
          address: child["address"].toString(),
          admissionNumber: child["admission_number"].toString(),
          authenticationKey: child["authentication_key"].toString(),
          birthday: child["birthday"].toString(),
          bloodGroup: child["blood_group"].toString(),
          cast: child["cast"].toString(),
          className: child["class_name"].toString(),
          dormitoryRoomNumber: child["dormitory_room_number"].toString(),
          email: child["email"].toString(),
          gender: child["sex"].toString(),
          imageUrl: child["image_url"].toString(),
          name: child["name"].toString(),
          password: child["password"].toString(),
          phone: child["phone"].toString(),
          religion: child["religion"].toString(),
          sectionName: child["section_name"].toString(),
          studentCode: child["student_code"].toString(),
          studentId: child["student_id"].toString(),
        );
        _studentData.add(_child);
        // print(_child.name);
      });

      notifyListeners();
    } on SocketException catch (error) {
      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
      throw HttpException("Check Internet Connectivity\nor\nTry again later");
    } catch (error) {
      // print("fetching child data : $error");
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print("tryAutoLogin false");
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, Object>;

    _authenticationKey = extractedUserData['authenticationKey'].toString();
//    print(_authenticationKey + " private auth ");
    _loginType = extractedUserData['loginType'].toString();
    _loginUserId = extractedUserData['loginUserId'].toString();
    _username = extractedUserData['username'].toString();
    _loginusername = extractedUserData['loginusername'].toString();
    // _password = extractedUserData['password'];

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    // String deviceToken = await _firebaseMessaging.getToken();
    // await _deletedeviceToken(deviceToken);
    _authenticationKey = "";
    _loginType = "";
    _loginUserId = "";
    _username = "";
    _loginusername = "";
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('token');
    prefs.clear();
  }

  Future<void> versionCheck() async {
    final url =
        'https://schoolbot.in/jehs/index.php/mobile/get_version?authenticate=false&mobile=$loginusername';
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    // print("currentVersion $currentVersion");
    // print("info.version ${info.version}");

    try {
      final response = await https.get(Uri.parse(url));
      // print("response ${response.statusCode}");
      final responseData = json.decode(response.body);
      if (responseData.containsKey("error")) {
        throw HttpException(responseData["error"]);
      }
      double newVersion =
          double.parse(responseData["version"].trim().replaceAll(".", ""));

      // print("newVersion $newVersion");

      if (newVersion > currentVersion) {
        throw VersionException(
            "https://play.google.com/store/apps/details?id=com.ibottic.jehs");
      }
    } on SocketException catch (error) {
      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
      throw HttpException("Check Internet Connectivity\nor\nTry again later");
    } catch (error) {
      // print(error);
      throw error;
    }
  }
}
