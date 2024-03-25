import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:client/conversation/early_period/memory2.dart';
import 'package:client/style.dart';


/// 초기_코치마크
class EarlyMarkCoachPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => EarlyMarkCoachPage(),
      ),
    );
  }

  @override
  _EarlyMarkCoachPageState createState() => _EarlyMarkCoachPageState();
}

class _EarlyMarkCoachPageState extends State<EarlyMarkCoachPage> {

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

  List<dynamic> questions0 =[
    "다른 사람들의\n기억할개를 구경할 수 있습니다.",
    "필터로 나와 비슷한 사람들의\n얘기를 들어보야요.",
    "도움 요청하기:\n다른 반려인에게\n도움을 요청할 수 있습니다.",
    "도움 보내기:\n다른 반려인이 도움을 요청하면\n도움을 보낼수 있습니다.\n감정을 교류하거나 정보를 나누어보세요!",
  ];

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
                                // 초기2로 이동
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Memory2Page()));
                              },
                              child: Text("다음", style: TextStyle(
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
