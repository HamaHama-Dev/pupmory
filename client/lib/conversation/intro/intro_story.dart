import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:client/conversation/intro/start_intro.dart';
import 'package:client/style.dart';
import 'package:just_audio/just_audio.dart';

/// 인트로_스토리보드
class IntroStoryPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => IntroStoryPage(),
      ),
    );
  }

  @override
  _IntroStoryPageState createState() => _IntroStoryPageState();
}

class _IntroStoryPageState extends State<IntroStoryPage> {

  List<dynamic> voice =[
    "",
    "assets/voice/story/pup1.mp3",
    "assets/voice/story/muji1.mp3",
    "assets/voice/story/pup2.mp3",
    "assets/voice/story/muji2.mp3",
    "assets/voice/story/pup3.mp3",
    "assets/voice/story/pup4.mp3",
    "assets/voice/story/pup5.mp3",
    "assets/voice/story/pup6.mp3",
    "",
    "", "","",
  ];

  List<dynamic> img =[
    "assets/images/story/story1.svg",
    "assets/images/story/story2.svg",
    "assets/images/story/story3.svg",
    "assets/images/story/story4.svg",
    "assets/images/story/story5.svg",
    "assets/images/story/story6.svg",
    "assets/images/story/story7.svg",
    "assets/images/story/story8.svg",
    "assets/images/story/story9.svg",
    "assets/images/story/story10.svg",
    "assets/images/story/story11.svg",
  ];

  bool finish = false; // 마무리
  AudioPlayer player2 = AudioPlayer();

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
  List<String> introText =[];
  int voiceCount = 0;
  int nextQuestion = 0;


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/story/background2.png'), // 배경 이미지
            ),
          ),
          //color: Color(0xffDDE7FD),
          child: GestureDetector(
            onTap: (){
              print(nextQuestion);
              if(nextPage <11){
                nextPage++;
                voiceCount++;
                player2.setAsset(voice[voiceCount]);
                player2.play();
                if(nextPage == 11){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StartIntroPage()));
                }
              }else if(nextPage == 11){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StartIntroPage()));
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
                child: Column(
                  children: [
                    if(nextPage == 0)...[
                      SizedBox(height: 300,),
                      Center(
                        child: Image.asset(
                          'assets/images/story/bbk1.png',
                        ),
                      ),
                      SizedBox(height: 16,),
                      Stack(
                        children: [
                          Text(
                            '"..."',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white,
                            ),
                          ),
                          Text('"..."',style: textStyle.bubbletext2,textAlign: TextAlign.center,),
                        ],
                      )

                    ]else if(nextPage == 1)...[
                      SizedBox(height: 300,),
                      Center(
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/story/bbk2.png',
                            ),
                            Padding(padding: EdgeInsets.only(left: 80, top: 50),
                              child: SvgPicture.asset(
                                'assets/images/story/st1.svg',
                              ),
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: 16,),
                      Stack(
                        children: [
                          Text(
                            '"그렇게 나는 여기로 오게 됐어.\n무지는 항상 이곳에서 강아지들을 배웅해 주는거야?"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white,
                            ),
                          ),

                          Text('"그렇게 나는 여기로 오게 됐어.\n무지는 항상 이곳에서 강아지들을 배웅해 주는거야?"',
                            style: textStyle.bubbletext2,textAlign: TextAlign.center,),
                        ],
                      )

                    ]else if(nextPage == 2)...[
                      SizedBox(height: 236,),
                      Stack(
                        children: [
                          Text(
                            '"맞아. 강아지별로 향하는\n이 무지개 다리에서 말동무가 되어주곤 하지."',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Color(0xffFCCBCD),
                            ),
                          ),
                          Text('"맞아. 강아지별로 향하는\n이 무지개 다리에서 말동무가 되어주곤 하지."',
                            style: textStyle.bubbletext2,textAlign: TextAlign.center,),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk2.png',
                              ),
                              Padding(padding: EdgeInsets.only(left: 100, top: 52),
                                child: SvgPicture.asset(
                                  'assets/images/story/st2.svg',
                                ),
                              ),
                            ],
                          )
                      ),

                    ]else if(nextPage == 3)...[
                      SizedBox(height: 300,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk2.png',
                              ),
                              Padding(padding: EdgeInsets.only(left: 80, top: 50),
                                child: SvgPicture.asset(
                                  'assets/images/story/st3.svg',
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 16,),
                      Stack(
                        children: [
                          Text(
                            '"그렇구나. 덕분에 심심하지 않아.\n하지만…"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white,
                            ),
                          ),
                          Text('"그렇구나. 덕분에 심심하지 않아.\n하지만…"', style: textStyle.bubbletext2,textAlign: TextAlign.center,),
                        ],
                      )

                    ]else if(nextPage == 4)...[
                      SizedBox(height: 252,),
                      Stack(
                        children: [
                          Text(
                            '"무슨 일이야?"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Color(0xffFCCBCD),
                            ),
                          ),
                          Text('"무슨 일이야?"', style: textStyle.bubbletext2,),
                        ],
                      ),
                      SizedBox(height: 26,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk2.png',
                              ),
                              Padding(padding: EdgeInsets.only(left: 100, top: 51),
                                child: SvgPicture.asset(
                                  'assets/images/story/st4.svg',
                                ),
                              ),
                            ],
                          )
                      ),

                    ]else if(nextPage == 5)...[
                      SizedBox(height: 300,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk2.png',
                              ),
                              Padding(padding: EdgeInsets.only(left: 112, top: 50),
                                child: SvgPicture.asset(
                                  'assets/images/story/st5.svg',
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 16,),
                      Stack(
                        children: [
                          Text(
                            '"우리 주인이 걱정돼서.\n이젠 내가 주인 곁에 없으니,\n주인이 슬퍼할 때 위로해줄 수 없어."',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white,
                            ),
                          ),
                          Text('"우리 주인이 걱정돼서.\n이젠 내가 주인 곁에 없으니,\n주인이 슬퍼할 때 위로해줄 수 없어."',
                            style: textStyle.bubbletext2,textAlign: TextAlign.center,),
                        ],
                      )

                    ]else if(nextPage == 6)...[
                      SizedBox(height: 300,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk2.png',
                              ),
                              Padding(padding: EdgeInsets.only(left: 100, top: 50),
                                child: SvgPicture.asset(
                                  'assets/images/story/st6.svg',
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 16,),
                      Stack(
                        children: [
                          Text(
                            '"벌써 다 왔네."',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white,
                            ),
                          ),
                          Text('"벌써 다 왔네."', style: textStyle.bubbletext2,),
                        ],
                      )

                    ]else if(nextPage == 7)...[
                      SizedBox(height: 300,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk2.png',
                              ),
                              Padding(padding: EdgeInsets.only(left: 112, top: 50),
                                child: SvgPicture.asset(
                                  'assets/images/story/st7.svg',
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 16,),
                      Stack(
                        children: [
                          Text(
                            '"무지, 혹시 내가 부탁 하나만 해도 될까?"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white,
                            ),
                          ),
                          Text('"무지, 혹시 내가 부탁 하나만 해도 될까?"', style: textStyle.bubbletext2,textAlign: TextAlign.center,),
                        ],
                      )

                    ]else if(nextPage == 8)...[
                      SizedBox(height: 300,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk2.png',
                              ),
                              Padding(padding: EdgeInsets.only(left: 100, top: 52),
                                child: SvgPicture.asset(
                                  'assets/images/story/st8.svg',
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 16,),
                      Stack(
                        children: [
                          Text(
                            '"우리 주인이 나 없이도 안온한 일상을 보낼 수 있도록 도와줘."',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nanum-BaReunHiPi',
                              //color: Color(0xff4B5396),
                              fontSize: 16,height: 1.4,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white,
                            ),
                          ),
                          Text('"우리 주인이 나 없이도 안온한 일상을 보낼 수 있도록 도와줘."',
                            style: textStyle.bubbletext2,textAlign: TextAlign.center,),
                        ],
                      )
                    ]else if(nextPage == 9)...[
                      SizedBox(height: 300,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk1.png',
                              ),
                            ],
                          )
                      ),

                    ]else if(nextPage == 10)...[
                      SizedBox(height: 300,),
                      Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/story/bbk2.png',
                              ),
                              Padding(padding: EdgeInsets.only(left: 100, top: 74),
                                child: SvgPicture.asset(
                                  'assets/images/story/st9.svg',
                                ),
                              ),
                            ],
                          )
                      ),

                    ]else if(nextPage == 11)...[


                    ]
                  ],
                ),
              ),

            ),
          )

      );

  }
}
