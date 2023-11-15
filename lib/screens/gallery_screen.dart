import 'package:SchoolBot/widgets/slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/models/http_exception.dart';
import 'package:SchoolBot/widgets/app_drawer.dart';
import 'package:SchoolBot/providers/gallery.dart';

class GalleryScreen extends StatefulWidget {
  static const routeName = '/GalleryScreen';

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool _isInit = true;
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await _fetchGalleryImages();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message, textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              _fetchGalleryImages();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _fetchGalleryImages() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<Gallery>(context, listen: false).getGalleryImages();
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<GalleryImage> _galleryData =
        Provider.of<Gallery>(context).galleryData;

    return Scaffold(
        appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Gallery",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.teal[200]),
            ),
            systemOverlayStyle: SystemUiOverlayStyle.dark),
        drawer: AppDrawer(),
        backgroundColor: Colors.white,
        drawerScrimColor: Colors.transparent,
        body: (_isloading)
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColorDark,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "Images",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600),
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
                          backgroundColor: Colors.teal[200],
                          child: Text(
                            "${_galleryData.length}",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    (_galleryData.length <= 0)
                        ? Container(
                            margin: EdgeInsets.only(top: 100),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              "assets/svg/image.svg",
                              height: 180,
                            ),
                          )
                        : Flexible(child: SliderImages()),
                  ],
                ),
              ));
  }
}
