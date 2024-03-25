
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:client/style.dart';
import 'package:client/conversation/intro/intro2.dart' as intro2;

/// 인트로_코치마크
class IntroMarkCoachPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => IntroMarkCoachPage(),
      ),
    );
  }

  @override
  _IntroMarkCoachPageState createState() => _IntroMarkCoachPageState();
}

class _IntroMarkCoachPageState extends State<IntroMarkCoachPage> {

  bool finish = false; // 메모리얼 및 마무리

  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
  final userNameController = TextEditingController(); // nextQuestion = 3일때
  final dogNameController = TextEditingController(); // nextQuestion = 7일때
  final dogAgeController = TextEditingController(); // nextQuestion = 10일때
  final dogTypeController = TextEditingController(); // nextQuestion = 10일때


  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _callAPI();
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

  int nextQuestion = 0;


  void _callAPI() async {
    // 요청 본문 데이터
    var data = {
      "stage" : "0",
      "set" : "0",
      "lineId" : "0"
    };

    var url = Uri.parse('http://3.38.1.125:8080/conversation/line'); // 엔드포인트 URL 설정

    try {
      var response = await http.post(
        url,
        body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
        headers: {'Content-Type': 'application/json',}, // 요청 헤더에 Content-Type 설정
      );

      if (response.statusCode == 200) {
        // 응답 성공 시의 처리

        var jsonResponse = utf8.decode(response.bodyBytes); // 응답 본문을 JSON 형식으로 디코딩
        // JSON 값을 활용한 원하는 동작 수행
        //utf8.decode(jsonResponse);
        print(jsonResponse);

        List<String> contentList = [];

        List<dynamic> parsedResponse = json.decode(jsonResponse);

        setState(() {
          for (var item in parsedResponse) {
            if (item['content'] != null) {
              introText.add(item['content']);
            }
          }
        });


        print(introText);

        print('API 호출 성공: ${response.statusCode}');
      } else {
        // 요청 실패 시의 처리
        print('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 발생 시의 처리
      print('API 호출 중 예외 발생: $e');
    }
  }


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
                        // Padding(padding: EdgeInsets.only(left: 12, top: 125),
                        //   child: SvgPicture.asset('assets/images/conversation/intro/coach01.svg',
                        //     height: 624,
                        //     width: 380, fit: BoxFit.fill,),
                        // ),

                        if(nextPage == 0)...[
                          Padding(padding: EdgeInsets.only(left: 6, top: 145),
                            child: Container(
                              width: 260,
                              height: 575,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child:  Image.asset('assets/images/conversation/intro/iscreen1.png',
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
                                  child:  Image.asset('assets/images/conversation/intro/iscreen2.png',
                                    fit: BoxFit.fill,)
                              ),
                            ),
                          ),
                        ] else if(nextPage == 2)...[
                          Padding(padding: EdgeInsets.only(left: 6, top: 145),
                            child: Container(
                              width: 260,
                              height: 575,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child:  Image.asset('assets/images/conversation/intro/iscreen3.png',
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
                                  child:  Image.asset('assets/images/conversation/intro/iscreen4.png',
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
                      if(nextPage == 3)...[
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
                                  Navigator.pop(context); // intro2로 돌아가기
                                  intro2.player2.setAsset(intro2.voice[2]);
                                  intro2.player2.play();
                                  // 2.5초 적정
                                  intro2.controller1.repeat(
                                      min: 0,
                                      max: 30,
                                      period: const Duration(milliseconds: 1000)
                                  );
                                  Timer(Duration(milliseconds: 1000), () {
                                    intro2.controller1.stop();
                                  });
                                  // _player.play();
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
                )

            ),
          )

      );

  }
}
