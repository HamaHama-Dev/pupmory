import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/style.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'received_help.dart';
import 'answer_help_request.dart';
import 'package:client/sign/sign_in.dart' as sign_in;

String selectedProfile = "";
int hid = 0;
String fromUsernickname = "";
String fromUserProfileImage = "";
String toUsernickname = "";
String toUserProfileImage = "";

class HelpMainPage extends StatefulWidget {
  @override
  State<HelpMainPage> createState() => _HelpMainPageState();
}

class _HelpMainPageState extends State<HelpMainPage> {

  // 화면에 보이는 UI 설정 bool
  bool askHelp = true;
  bool sendHelp = false;

  bool newAns = false;
  bool newAsk = false;

  int askHelpCount = 5;
  int sendHelpCount = 5;

  /// 도움 요청하기
  bool receivedHelp = false; // 요청한 도움을 받았는지
  bool checkAskHelp = false; // 요청받은 도움을 확인했는지

  /// 도움 보내기
  bool checkSendHelp = false; // 도움을 잘 보냈는지

  late List<dynamic> parsedResponseHR; // 도움 요청 내역
  late List<dynamic> parsedResponseHA; // 도움 답변 내역
  bool isLastest = false;

  // 내가 보낸 "도움 요청" 내역 불러오기(GET)
  void callHelpRequest(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/help/all?type=req'; // 실제 API 엔드포인트로 변경하세요

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터(도움요청하기): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseHR = json.decode(jsonResponse);

      print("몇개인지 확인(도움요청하기) "+parsedResponseHR.length.toString());

      for(int i = 0; i< parsedResponseHR.length; i++){
        if(parsedResponseHR[i]['isFromUserReadAnswer'] == 1){
          newAns = true;
        }
      }

      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 내가 보낸 "도움" 내역 불러오기(GET)
  void callHelpAnswer(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/help/all?type=ans'; // 실제 API 엔드포인트로 변경하세요

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터(내가 보낸도움): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseHA = json.decode(jsonResponse);

      print("몇개인지 확인(내가 보낸도움) "+parsedResponseHA.length.toString());

      for(int i = 0; i< parsedResponseHA.length; i++){
        if(parsedResponseHA[i]['answeredAt'] == null){
          newAsk = true;
        }
      }

      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    callHelpRequest(sign_in.userAccessToken);
    callHelpAnswer(sign_in.userAccessToken);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return Scaffold(
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(72),
        child:AppBar(
          title:
          Container(
            height: 50,
            width: screenSize.width,
            child: Column(
              children: [
                SizedBox(height: 24,),
                Center(
                    child: Padding(padding: EdgeInsets.only(right: 60),
                      child: Text('도움 내역', style: textStyle.bk20normal,),
                    )
                ),
              ],
            ),
          ),
          leading:
          Padding(padding: EdgeInsets.only(top:20),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      body: Container(
        color: Color(0xffDDE7FD),
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                width: screenSize.width - 32,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xffF2F6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [

                    if(askHelp && sendHelp == false)...[
                      SizedBox(width: 5,),
                      Container(
                          decoration: BoxDecoration(
                            color: Color(0xffC0D2FC),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          width: 174,
                          height: 32,
                          child: Center(
                            child:Row(children: [
                              SizedBox(width: 44,),
                              Text("도움 요청하기", style: TextStyle(color: Color(0xff4B5396),fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600, fontSize: 16),),
                              if(newAns)...[
                                Padding(padding: EdgeInsets.only(bottom: 15, left: 3),
                                  child: Container(width: 4, height:4, child: Icon(Icons.circle,color: Color(0xffFEFBAC), size: 5,),),)
                              ]
                            ],
                            ),
                          )
                      ),
                      SizedBox(width: 40,),
                      TextButton(onPressed: (){
                        askHelp = false;
                        sendHelp = true;
                        callHelpAnswer(sign_in.userAccessToken);
                        setState(() {});
                      }, child: Row(children: [
                        Text("도움 보내기", style: textStyle.bk16light,),
                        if(newAsk)...[
                          Padding(padding: EdgeInsets.only(bottom: 15, left: 3),
                            child: Container(width: 4, height:4, child: Icon(Icons.circle,color: Color(0xff83A8FF), size: 5,),),)
                        ]
                      ],)

                      ),
                      SizedBox(width: 20,),

                    ]else if(askHelp  == false && sendHelp)...[
                      SizedBox(width: 41,),
                      TextButton(onPressed: (){
                        askHelp = true;
                        sendHelp = false;
                        callHelpRequest(sign_in.userAccessToken);
                        setState(() {});
                      }, child:
                      Container(
                        width: 96,
                        child: Row(
                          children: [
                            Text("도움 요청하기", style: textStyle.bk16light,),
                            if(newAns)...[
                              Padding(padding: EdgeInsets.only(bottom: 15, left: 3),
                                child: Container(width: 4, height:4, child: Icon(Icons.circle,color: Color(0xff83A8FF), size: 5,),),)
                            ]
                          ],),
                      ),


                        //Text("도움 요청하기", style: textStyle.bk16light,)

                      ),
                      SizedBox(width: 22,),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffC0D2FC),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        width: 174,
                        height: 32,
                        child:

                        Row(children: [
                          SizedBox(width: 52,),
                          Text("도움 보내기", style: TextStyle(color: Color(0xff4B5396),fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600, fontSize: 16),),
                          if(newAsk)...[
                            Padding(padding: EdgeInsets.only(bottom: 15, left: 3),
                              child: Container(width: 4, height:4, child: Icon(Icons.circle,color: Color(0xffFEFBAC), size: 5,),),)
                          ]
                        ],
                        ),
                        //
                        // Center(child: Text("도움 보내기", style: TextStyle(color: Color(0xff4B5396),fontFamily: 'Pretendard',
                        //     fontWeight: FontWeight.w500, fontSize: 16)),)
                      ),
                      //SizedBox(width: 20,),
                    ]
                  ],
                ),
              ),

              //SizedBox(height: 5,),

              if(askHelp)...[
                if(parsedResponseHR.length == 0)...[
                  Container(
                    width: Get.width,
                    height: 128,
                    color: Color(0xffDDE7FD),
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        SvgPicture.asset(
                          'assets/images/help/no_help.svg',
                        ),
                        SizedBox(width: 30,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 34,),
                            Text('도움을 요청하고 받은 내역이 없습니다.', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 1.0)),
                            SizedBox(height: 5,),
                            Text('               어려움을 겪고 있다면 언제든지\n다른 반려인들에게 도움을 요청해보세요!', style: textStyle.bk12light)
                          ],)
                      ],
                    ),
                  ),
                ]
                else...[
                  Container(
                    width: Get.width,
                    height: 128,
                    color: Color(0xffDDE7FD),
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        SvgPicture.asset(
                          'assets/images/help/ask_help.svg',
                          width: 93,
                          height: 76,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 32,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 34,),
                            Text('총 ${parsedResponseHR.length}번의 소중한 도움을 받았습니다.', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 1.0,)),
                            SizedBox(height: 5,),
                            Text('               어려움을 겪고 있다면 언제든지\n다른 반려인들에게 도움을 요청해보세요!', style: textStyle.bk12light)
                          ],)
                      ],
                    ),
                  ),
                ]

              ] else if(sendHelp)...[
                if(parsedResponseHA.length == 0)...[
                  Container(
                    width: Get.width,
                    height: 128,
                    color: Color(0xffDDE7FD),
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        SvgPicture.asset(
                          'assets/images/help/no_help.svg',
                        ),
                        SizedBox(width: 30,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 34,),
                            Text('도움을 요청받고 보낸 내역이 없습니다.', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 1.0,)),
                            SizedBox(height: 5,),
                            Text('             다른 반려인이 도움을 요청하면 \n따뜻한 마음을 담아 도움을 보내주세요!', style: textStyle.bk12light,)
                          ],)
                      ],
                    ),
                  ),
                ]
                else...[
                  Container(
                    width: Get.width,
                    height: 128,
                    color: Color(0xffDDE7FD),
                    child:
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        SvgPicture.asset(
                          'assets/images/help/send_help.svg',
                          width: 82,
                          height: 82,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 44,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 34,),
                            Text('총 ${parsedResponseHA.length}번의 소중한 도움을 보냈습니다.', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 1.0,)),
                            SizedBox(height: 5,),
                            Text('             다른 반려인이 도움을 요청하면 \n따뜻한 마음을 담아 도움을 보내주세요!', style: textStyle.bk12light)
                          ],)
                      ],
                    ),
                  ),
                ]
              ],

              Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  width: Get.width,
                  //height: Get.height-30,
                  color: Color(0xffF2F4F6),
                  child:
                  Column(
                    children: [
                      if(askHelp)...[
                        if(parsedResponseHR.length == 0)...[
                          SizedBox(height: 180,),
                          Container(
                            height: 600,
                            child: Center(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/no_result.svg',
                                    height: 140,
                                    width: 128,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('도움을 요청한 내역이 없습니다.', style: textStyle.bk16normal),
                                ],
                              ),
                            ),
                          )

                        ]
                        else...[
                          Container(
                              height: (parsedResponseHR.length >= 6)? parsedResponseHR.length * 104 : 600,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(0),
                                              itemCount: parsedResponseHR.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return
                                                  Padding(padding: EdgeInsets.only(bottom: 9),
                                                    child: InkWell(
                                                      onTap: (){
                                                        fromUsernickname = parsedResponseHR[index]['fromUserNickname'];
                                                        fromUserProfileImage = parsedResponseHR[index]['fromUserProfileImage'].toString();
                                                        toUsernickname = parsedResponseHR[index]['toUserNickname'];
                                                        toUserProfileImage = parsedResponseHR[index]['toUserProfileImage'].toString();
                                                        hid = parsedResponseHR[index]['id'];
                                                        setState(() {

                                                        });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => ReceivedHelpPage()));
                                                      },
                                                      child: Container(
                                                        width: Get.width,
                                                        height: 89,
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            if(parsedResponseHR[index]['toUserProfileImage'].toString() == "null")...[
                                                              CircleAvatar(
                                                                minRadius: 28,
                                                                maxRadius: 28,
                                                                child: SvgPicture.asset('assets/images/user_null2.svg',),
                                                              ),
                                                            ]else...[
                                                              CircleAvatar(
                                                                minRadius: 28,
                                                                maxRadius: 28,
                                                                backgroundImage:
                                                                NetworkImage(parsedResponseHR[index]['toUserProfileImage'].toString(),
                                                                ),
                                                              ),
                                                            ],

                                                            SizedBox(width: 16,),
                                                            Container(width: 165,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: 12,),
                                                                  Row(
                                                                    children: [
                                                                      Text('${parsedResponseHR[index]['toUserNickname']}', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold),),
                                                                      Text('님에게', style: textStyle.bk14normal),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  if(parsedResponseHR[index]['isFromUserReadAnswer'] == 0)...[
                                                                    Text('도움을 요청했습니다.', style: textStyle.bk14normal),
                                                                  ] else if(parsedResponseHR[index]['isFromUserReadAnswer'] == 1)...[
                                                                    Text('받은 도움을 확인해보세요!', style: textStyle.bk14normal),
                                                                  ] else if(parsedResponseHR[index]['isFromUserReadAnswer'] == 2)...[
                                                                    Text('도움을 받았습니다.', style: textStyle.bk14normal),
                                                                  ],
                                                                  //Text('도움을 요청했습니다', style: TextStyle(color: Color(0xff99A8CB), fontSize: 14),),
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(width: 28,),
                                                            Column(children: [
                                                              // DateFormat("MM/dd hh:mm").format(parsedResponseHR[index]['createdAt'])
                                                              // DateFormat('dd/MM HH:mm').parse(parsedResponseHR[index]['createdAt'])
                                                              // DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))
                                                              Text('${DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR[index]['createdAt']))}', style: textStyle.bg10normal),
                                                              SizedBox(height: 25,),
                                                              if(parsedResponseHR[index]['answeredAt'] == null)...[
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Color(0xffFCCBCD),
                                                                      borderRadius: BorderRadius.circular(16),
                                                                    ),
                                                                    width: 49,
                                                                    height: 18,
                                                                    child: Center(child: Text('요청중', style: textStyle.white12normal),)
                                                                )
                                                              ],

                                                            ],)

                                                          ],
                                                        ),
                                                      ),
                                                    ),);
                                              }),
                                        ],
                                      )
                                  )
                                ],
                              )
                          )
                        ]
                      ]
                      else if(sendHelp)...[
                        if(parsedResponseHA.length == 0)...[
                          SizedBox(height: 180,),
                          Container(
                            height: 600,
                            child: Center(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/help/no_send.svg',
                                    height: 140,
                                    width: 128,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('도움을 요청 받은 내역이 없습니다.', style: textStyle.bk16normal,),
                                ],
                              ),
                            ),
                          )
                        ]
                        else...[
                          Container(
                              height: (parsedResponseHA.length >= 6)? parsedResponseHA.length * 104 : 600,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(0),
                                              itemCount: parsedResponseHA.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return
                                                  Padding(padding: EdgeInsets.only(bottom: 9),
                                                    child: InkWell(
                                                      onTap: (){
                                                        hid = parsedResponseHA[index]['id'];
                                                        fromUsernickname = parsedResponseHA[index]['fromUserNickname'];
                                                        fromUserProfileImage = parsedResponseHA[index]['fromUserProfileImage'].toString();
                                                        toUsernickname = parsedResponseHA[index]['toUserNickname'];
                                                        toUserProfileImage = parsedResponseHA[index]['toUserProfileImage'].toString();
                                                        setState(() {

                                                        });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => AnswerHelpRequestPage()));
                                                      },
                                                      child: Container(
                                                        width: Get.width,
                                                        height: 89,
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            if(parsedResponseHA[index]['fromUserProfileImage'].toString() == "null")...[
                                                              CircleAvatar(
                                                                minRadius: 28,
                                                                maxRadius: 28,
                                                                child: SvgPicture.asset('assets/images/user_null2.svg',),
                                                              ),
                                                            ] else ...[
                                                              CircleAvatar(
                                                                minRadius: 28,
                                                                maxRadius: 28,
                                                                backgroundImage:
                                                                NetworkImage(
                                                                  parsedResponseHA[index]['fromUserProfileImage'].toString(),
                                                                ),
                                                              ),
                                                            ],
                                                            SizedBox(width: 16,),
                                                            Container(width: 165,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: 12,),
                                                                  Row(
                                                                    children: [
                                                                      Text('${parsedResponseHA[index]['fromUserNickname']}', style: textStyle.bk14semibold),
                                                                      Text('님이', style: textStyle.bk14normal),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Text('도움을 요청했습니다.', style: textStyle.bk14normal),
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(width: 28,),
                                                            Column(children: [
                                                              Text('${DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHA[index]['createdAt']))}', style: textStyle.bg10normal,),
                                                              SizedBox(height: 25,),
                                                              if(parsedResponseHA[index]['answeredAt'] == null)...[
                                                                Row(children: [
                                                                  SizedBox(width: 10,),
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Color(0xffFCCBCD),
                                                                        borderRadius: BorderRadius.circular(16),
                                                                      ),
                                                                      width: 35,
                                                                      height: 18,
                                                                      child: Center(child: Text('요청', style: textStyle.white12normal),)
                                                                  )
                                                                ],),

                                                              ]else...[
                                                                Row(children: [
                                                                  SizedBox(width: 10,),
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Color(0xffC0D2FC),
                                                                        borderRadius: BorderRadius.circular(16),
                                                                      ),
                                                                      width: 35,
                                                                      height: 18,
                                                                      child: Center(child: Text('완료', style: textStyle.white12normal,),)
                                                                  )
                                                                ],)

                                                              ]
                                                            ],)
                                                          ],
                                                        ),
                                                      ),
                                                    ),);
                                              }),
                                        ],
                                      )
                                  )
                                ],
                              )
                          )
                        ]
                      ]
                    ],
                  )
              ),


            ],
          ),
        ),
      ),
    );
  }
}