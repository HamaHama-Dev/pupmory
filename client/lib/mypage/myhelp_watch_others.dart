import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:client/conversation/early_period/memory2.dart';
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/style.dart';
import 'package:just_audio/just_audio.dart';
import 'package:client/conversation/intro/intro2.dart' as intro2;
import 'package:flutter_gif/flutter_gif.dart';

/// 함께할개_코치마크
class MyHelpWatchOthersPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => MyHelpWatchOthersPage(),
      ),
    );
  }

  @override
  _MyHelpWatchOthersPageState createState() => _MyHelpWatchOthersPageState();
}

class _MyHelpWatchOthersPageState extends State<MyHelpWatchOthersPage> {

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // 키보드 올리기
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  int nextPage = 0;

  int nextQuestion = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffE4ECFF),
                  Color(0xffA2BEFF),
                ],
              )
          ),
          child: GestureDetector(
            onTap: (){
              print(nextQuestion);
              if(nextPage == 3){
                // Navigator.pop(context); // early2로 가기
                // intro2.player2.setAsset(intro2.voice[2]);
                // intro2.player2.play();
              } else if(nextPage < 3){
                nextPage++;
              }

              setState(() {
              });
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                //title: Text("기억할개", style: TextStyle(fontSize:16, color: Colors.white ),),
                //centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                automaticallyImplyLeading: false,
              ),extendBodyBehindAppBar: true,

              body:
              Container(
                width: screenSize.width,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 0, top: 138),
                          child: Container(
                            width: 275,
                            height: 605,
                            //color: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 5.0,
                                      spreadRadius: 0.0,
                                      offset: const Offset(0,7),
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                width: 275,
                                height: 595,
                                //color: Colors.white,
                              ),

                            ),
                          ),
                        ),

                        if(nextPage == 0)...[
                          Padding(padding: EdgeInsets.only(left: 6, top: 145),
                            child: Container(
                              width: 260,
                              height: 575,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child:  Image.asset('assets/images/conversation/early/screen01.png',
                                    fit: BoxFit.fill,)
                              ),
                            ),
                          ),
                        ] else if(nextPage == 1)...[
                          Padding(padding: EdgeInsets.only(left: 6, top: 145),
                            child: Container(
                              width: 260,
                              height: 575,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child:  Image.asset('assets/images/conversation/early/screen02.png',
                                    fit: BoxFit.fill,)
                              ),
                            ),
                          ),
                        ] else if(nextPage == 2)...[
                          Padding(padding: EdgeInsets.only(left:6, top: 145),
                            child: Container(
                              width: 260,
                              height: 575,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child:  Image.asset('assets/images/conversation/early/screen03.png',
                                    fit: BoxFit.fill,)
                              ),
                            ),
                          ),
                        ] else if(nextPage == 3)...[
                          Padding(padding: EdgeInsets.only(left: 6, top: 145),
                            child: Container(
                              width: 260,
                              height: 575,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child:  Image.asset('assets/images/conversation/early/screen04.png',
                                    fit: BoxFit.fill,)
                              ),
                            ),
                          ),
                        ],

                        Padding(padding: EdgeInsets.only(left: 120, top: 706),
                          child: Container(
                              width: 40,
                              height: 2,
                              child: Container(
                                width: 40, height: 2,
                                color: Colors.white,
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              bottomSheet: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if(nextPage  == 3)...[
                      Container(
                        color: Color(0xffFFFFFF).withOpacity(0),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                          child: Container(

                            width: screenSize.width,
                            height: 40,
                            child: ElevatedButton(
                              style: buttonChart().bluebtn3,
                              onPressed: () {
                                Navigator.pop(context); // intro2로 돌아가기
                                setState(() {

                                });
                              },
                              child: Text("확인", style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                            ),
                          ),),
                      ),
                    ]
                  ],
                ),
              ),

            ),
          )

      );

  }
}
