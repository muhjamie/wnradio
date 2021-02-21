import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mailto/mailto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wnradio/Screens/ChangePasswordScreen.dart';
import 'package:wnradio/Utils/Colors.dart';
import 'package:wnradio/Utils/Images.dart';
import 'package:wnradio/Utils/Strings.dart';
import 'package:wnradio/Utils/constant.dart';
import 'package:wnradio/theme/style.dart';
import 'package:http/http.dart' as http;

class RadioScreen extends StatefulWidget {
  var playerState = FlutterRadioPlayer.flutter_radio_paused;
  var volume = 0.8;

  @override
  _RadioScreenState createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  bool isPlaying = false;
  IconData playButton = Icons.play_arrow;
  FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();
  String songTitle;
  Stream meta;

  @override
  void initState() {
    super.initState();
    initRadioService();
    playingStatus();
  }

  String songTitleRegex(String fullName) {
    String pattern = r'^[a-z A-Z]+$';
    RegExp regExp = new RegExp(pattern);
    if (fullName.length == 0) {
      return 'Please enter full name';
    } else if (!regExp.hasMatch(fullName)) {
      return 'Please enter valid full name';
    }
    return null;
  }

  Future<Map> getInfoDataFromIceCastStream(String url) async {
    var request = http.Request('GET', Uri.parse(url));
    request.headers['Icy-MetaData'] = '1';
    var response = await request.send();
    var headers = response.headers;

    return headers;
  }

  Future<int> getIcyMetaInt(String url) async {
    Map metaData = await getInfoDataFromIceCastStream(url);
    print('--------oo---------');
    print(metaData['icy-metaint']);
    return int.parse(metaData['icy-metaint']);
  }

  Future<void> initRadioService() async {
    try {
      await _flutterRadioPlayer.init("Worship Nation Radio", "Live", "https://streaming.radio.co/s455471b48/listen", "false");
      //getIcyMetaInt('https://streaming.radio.co/s455471b48/listen');
      setState(() {
        meta = _flutterRadioPlayer.metaDataStream;
      });
    } on PlatformException {
      print("Exception occurred while trying to register the services.");
    }
  }

  Future<void> submitSongRequest() async {
    final mailtoLink = Mailto(
      to: ['worshipnationradio@gmail.com'],
      subject: 'Song Request',
      body: '',
    );
    await launch('$mailtoLink');
  }

  Future playingStatus() async {
    bool isP = await _flutterRadioPlayer.isPlaying();
    setState(() {
      isPlaying = isP;
      meta = _flutterRadioPlayer.metaDataStream;
    });
  }

  Stream<String> processTitle(Stream text) {
    String text = 'ICY: title="FLO - Twale (WorshipNationRadio) [2JZE]", url="null", rawMetadata.length="54"';
    String newText = ((text).split('=')[1]);
    String latestText = (newText.split('(')[0]);
    String lastText = (latestText.replaceAll('"', ''));
    //return lastText;
  }

  @override
  Widget build(BuildContext context) {
    void _showButtonPressDialog(BuildContext context, String provider) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('$provider Button Pressed!'),
        backgroundColor: Colors.black26,
        duration: Duration(milliseconds: 400),
      ));
    }
    return Scaffold(
      body: Container(
        color: app_Background,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 240,
              color: app_Background,
              child: Padding(
                padding: EdgeInsets.only(top: 0.0, left: 0, right: 0, bottom: 0.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipPath(
                              clipper: OvalBottomBorderClipper(),
                              child: Container(
                                height: context.height() * 0.30,
                                color: primaryColor,
                              )
                          ),
                          Image.asset(WNR_logo,height: context.height() * 0.25, width: context.width(),)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Text("Now Playing", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
            10.height,
            /*Center(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: StreamBuilder<String>(
                    initialData: '',
                    stream: meta,
                    builder: (context, snapshot) {
                      return Text(snapshot.data);
                    }),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: white_color,
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: StreamBuilder(
                  stream: _flutterRadioPlayer.isPlayingStream,
                  initialData: widget.playerState,
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    String returnData = snapshot.data;
                    print("object data: " + returnData);
                    switch(returnData) {
                      case FlutterRadioPlayer.flutter_radio_stopped:
                        return Container(
                          height: 50,
                          width: double.infinity,
                          child: Center(
                            child: GestureDetector(
                              child: Text("Start Radio"),
                              onTap: () async {
                                await initRadioService();
                              },
                            ),
                          ),
                        );
                        break;
                      case FlutterRadioPlayer.flutter_radio_loading:
                        return Center(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              backgroundColor: secondary,
                              valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                            ),
                          ).paddingOnly(top: 5, bottom: 5),
                        );
                      case FlutterRadioPlayer.flutter_radio_error:
                        return RaisedButton(
                            child: Text("Retry ?"),
                            onPressed: () async {
                              await initRadioService();
                            });
                        break;
                      default:
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () async {
                                        print("button press data: " +
                                            snapshot.data.toString());
                                        _flutterRadioPlayer.metaDataStream;
                                        await _flutterRadioPlayer.playOrPause();
                                      },
                                      icon: snapshot.data == FlutterRadioPlayer
                                          .flutter_radio_playing
                                          ? Icon(Icons.pause, size: 30,)
                                          : Icon(Icons.play_arrow, size: 30,)
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await _flutterRadioPlayer.stop();
                                      },
                                      icon: Icon(Icons.stop, size: 30,))
                                ]
                            ),
                          ],
                        );
                        break;
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: app_Background,
                child: Column(
                  children: [
                    20.height,
                    GestureDetector(
                      onTap: () {
                        submitSongRequest();
                      },
                      child: Center(child: Text('Click to make request', style: boldTextStyle(color: textColorPrimary, size: textSizeMedium),).paddingOnly(left: 12.0,right: 4.0)),
                    ) ,
                    Divider(),
                    SizedBox(height: 10),
                    20.height,
                    Text('Contact us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                              onTap: () async {
                                print('twitter');
                                var facebookURL ="https://twitter.com/worshipnation1";
                                await canLaunch(facebookURL) ? launch(facebookURL):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                              },
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.network('https://www.freeiconspng.com/thumbs/logo-twitter-png/logo-twitter-icon-symbol-0.png')
                              ),
                            ),
                          ).paddingAll(5),
                        ),
                        SizedBox(width: 20,),
                        ClipOval(
                          child: Material(
                            color: Colors.red, // button color
                            child: InkWell( // inkwell color
                              onTap: () async {
                                var facebookURL ="https://facebook.com/worshipnation1";
                                await canLaunch(facebookURL) ? launch(facebookURL):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                              },
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.network('https://toppng.com/uploads/preview/facebook-icon-facebook-icon-red-11563140071g3x2ama4cd.png')
                              ),
                            ),
                          ),
                        ),
                        20.width,
                        ClipOval(
                          child: Material(
                            color: Colors.white, // button color
                            child: InkWell(// inkwell color
                              onTap: () async {
                                var facebookURL ="https://instagram.com/worshipnation1";
                                await canLaunch(facebookURL) ? launch(facebookURL):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                              },
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.network('https://i.pinimg.com/originals/28/be/c9/28bec933c52453d402d92ad5de6a755a.png')
                              ),
                            ),
                          ).paddingAll(5),
                        ),
                        20.width,
                        ClipOval(
                          child: Material(
                            color: Colors.white, // button color
                            child: InkWell(// inkwell color
                              onTap: () async {
                                var youtubeUrl ="https://www.youtube.com/channel/UC5yUhqVWCvQbIboTXjr7L0A";
                                await canLaunch(youtubeUrl) ? launch(youtubeUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                              },
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.network('https://i.pinimg.com/originals/f0/bf/e6/f0bfe6f3b051934eb67b1b49e9481be4.png')
                              ),
                            ),
                          ).paddingAll(5),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
