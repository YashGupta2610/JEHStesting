import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as https;

import 'package:SchoolBot/models/http_exception.dart';

class GalleryImage {
  String title;
  String imageUrl;
  String description;

  GalleryImage({
    required this.title,
    required this.imageUrl,
    required this.description,
  });
}

class Gallery with ChangeNotifier {
  final String authenticationKey;

  Gallery({this.authenticationKey = ""});

  List<GalleryImage> _galleryData = [];

  List<GalleryImage> get galleryData {
    return [..._galleryData];
  }

  Future<void> getGalleryImages() async {
    final url =
        "https://schoolbot.in/jehs/index.php/mobile/gallery?authenticate=$authenticationKey&user_type=parent";

    try {
      final response = await https.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      // print(responseData);

      List _responseImages = responseData["galleries"];
      if (_responseImages.length > 0) {
        _galleryData.clear();
            }

      _responseImages.forEach((image) {
        // print(image);
        // print("description ${image["description"]}");
        var _image = GalleryImage(
          title: image["title"].toString().replaceAll("&#039;", "\'"),
          imageUrl: image["image_url"],
          description:
              image["description"].toString().replaceAll("&#039;", "\'"),
        );
        _galleryData.add(_image);
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
      // print(error);
      throw error;
    }
  }
}
