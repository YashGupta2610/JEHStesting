import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/models/http_exception.dart';
import 'package:SchoolBot/providers/messages.dart';
import 'package:SchoolBot/widgets/app_drawer.dart';
import 'package:SchoolBot/widgets/message_widget.dart';

class MessagesScreen extends StatefulWidget {
  static const routeName = '/messagesScreen';

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _isInit = true;
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await _fetchMessages();
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
              _fetchMessages();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<Message>(context, listen: false).getMessages();
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
    final deviceSize = MediaQuery.of(context).size;
    final List<SchoolMessages> _messageData =
        Provider.of<Message>(context).messageData;

    return Scaffold(
        appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Messages",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.redAccent[100]),
            )),
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
                          "All messages",
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
                          backgroundColor: Colors.redAccent[100],
                          child: Text(
                            "${_messageData.length}",
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
                    (_messageData.length <= 0)
                        ? Container(
                            margin: EdgeInsets.only(top: 100),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              "assets/svg/empty-box.svg",
                              height: 180,
                            ),
                          )
                        : Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ..._messageData.reversed.map((item) {
                                    return MessageWidget(item);
                                  })
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ));
  }
}
