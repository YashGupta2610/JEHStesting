import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:SchoolBot/providers/gallery.dart';
import 'package:provider/provider.dart';

class SliderImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    List<GalleryImage> _galleryData = Provider.of<Gallery>(context).galleryData;
    return CarouselSlider(
      options: CarouselOptions(
          height: deviceSize.height,
          viewportFraction: 0.9,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 2),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal),
      items: _galleryData.map((imageData) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              child: ListView(
                children: [
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 10,
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            imageData.imageUrl,
                          ),
                          placeholder:
                              AssetImage("assets/images/defaultImage.png"),
                        ),
                      )),
                  Text(
                    imageData.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(imageData.description),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
