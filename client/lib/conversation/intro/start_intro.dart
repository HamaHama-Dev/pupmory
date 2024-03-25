import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:client/conversation/intro/intro.dart';
import 'package:client/style.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';

/// 인트로 시작

AudioPlayer player2 = AudioPlayer();

late FlutterGifController controller1, controller2, controller3;

class StartIntroPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => StartIntroPage(),
      ),
    );
  }

  @override
  _StartIntroPageState createState() => _StartIntroPageState();
}

class _StartIntroPageState extends State<StartIntroPage> with TickerProviderStateMixin {


  FocusNode _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    // 음원 적용

    controller1 = FlutterGifController(vsync: this);

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

  List<String> introText =[];
  int nextQuestion = 0;
  int voiceCount = 0;

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
              print("확인: " + nextQuestion.toString());
              setState(() {
              });
            },
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title:
                  Container(
                    width: screenSize.width,
                    height: 46,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 18,),
                        SvgPicture.asset(
                          'assets/images/logo/pup_logo.svg',
                          height: 25.41,
                          width: 110.19,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),

                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                ),
                //extendBodyBehindAppBar: true,
                body:
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 60,),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                Container(
                                    height: 157,
                                    width: screenSize.width,
                                    child:
                                    Stack(
                                      children: [
                                        Center(child: SvgPicture.asset('assets/images/conversation/intro/intro_bubble.svg',fit: BoxFit.fill,),),
                                        Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12, ),
                                            child: Center(
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 39,),
                                                    Text(
                                                      "당신의 마음에 안정이 찾아오는 그날까지.\n기억할개와 함께.",
                                                      textAlign: TextAlign.center,
                                                      style: textStyle.introbubbletext,
                                                    ),
                                                  ],
                                                )
                                            )
                                        ),
                                      ],
                                    )
                                ),
                                // 무지 위치
                                Column(
                                  children: [
                                    SizedBox(height: 188,),
                                    Image.asset(
                                      'assets/images/story/bbkcloud.png',
                                      width: screenSize.width,
                                      fit: BoxFit.fill,
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 95, top: 245),
                                  child: SvgPicture.asset(
                                    'assets/images/story/muji3.svg',
                                    height: 215,
                                    width: 204,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // // nextQuestion 이 3과 7일때 등장
                bottomSheet: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        color: Color(0xffFFFFFF).withOpacity(0.0),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                          child: Container(

                            width: screenSize.width,
                            height: 40,
                            child: ElevatedButton(
                              style: buttonChart().bluebtn3,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => IntroPage()));
                              },
                              child: Text("기억할개 시작하기", style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                            ),
                          ),),
                      ),
                    ],
                  ),
                )),
          )

      );

  }
}

