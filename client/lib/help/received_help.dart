import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'help_main.dart'as help ;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:client/sign/sign_in.dart' as sign_in;
import 'help_main.dart' as main;

// 도움 요청하기
class ReceivedHelpPage extends StatefulWidget {
  @override
  State<ReceivedHelpPage> createState() => _ReceivedHelpPageState();
}

class _ReceivedHelpPageState extends State<ReceivedHelpPage> {

  // 화면에 보이는 UI 설정 bool
  bool check = false;
  bool sent = true;

  bool watchContent = true;

  // 도움 보내기 수
  int countHelp = 0;

  // 도움을 보낸 시각 (시연용)
  String sentDate = "";

  /// 도움 요청하기
  bool receivedHelp = true; // 요청한 도움을 받았는지
  bool checkAskHelp = false; // 요청받은 도움을 확인했는지

  late Map<String, dynamic> parsedResponseHR; // 도움 요청 내역

  // 내가 보낸 "도움 요청" 내역에서 내가 보낸 요청 세부 내용 불러오기(GET)
  void callHelpRequest(int id, String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/help?hid=${id}'; // 실제 API 엔드포인트로 변경하세요

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
      print('서버로부터 받은 내용 데이터(세부내용): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      check = true;
      parsedResponseHR = json.decode(jsonResponse);

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
    callHelpRequest(help.hid, sign_in.userAccessToken);
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
                    child: Padding(
                      padding: EdgeInsets.only(right: 60),
                      child: Text(
                        '도움 요청하기',
                        style: textStyle.bk20normal,
                      ),
                    )),
              ],
            ),
          ),
          leading:
          Padding(
            padding: EdgeInsets.only(top: 20),
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
        //color: Color(0xffF3F3F3),
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if(check)...[
                SizedBox(height: 8,),
                Container(
                  width: Get.width,
                  height: 56,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: receivedHelp? Color(0xffFCCBCD) : Color(0xffF3F3F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      if(main.toUserProfileImage.toString() == "null")...[
                        CircleAvatar(
                          radius: 12,
                          child: SvgPicture.asset('assets/images/user_null2.svg',),
                        ),
                      ]else...[
                        CircleAvatar(
                          radius: 12,
                          backgroundImage:
                          NetworkImage(main.toUserProfileImage,),
                        ),
                      ],

                      SizedBox(width: 8,),
                      Row(children: [
                        Text('${main.toUsernickname}', style: textStyle.bk14semibold,),
                        Text('님에게 도움을 요청했습니다.', style: textStyle.bk14normal,)
                      ],)

                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  width: Get.width,
                  child:
                  ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                      child:
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8,),
                            Text('제목', style: textStyle.bk14midium,),
                            SizedBox(height: 8,),
                            Text('${parsedResponseHR['title']}', style: textStyle.bk16normalCon,),
                            SizedBox(height: 8,),
                          ],
                        ),
                      )
                  ),
                  //Image.network(parsedResponseCM[index]['image'], fit: BoxFit.cover,),
                ),
                SizedBox(height: 8,),

                if(watchContent)...[
                  Container(
                    width: Get.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                        child:
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('내용', style: textStyle.bk14midium,),
                                  SizedBox(width: 263,),
                                  Container(
                                      height: 30, child: IconButton(onPressed: (){
                                    watchContent = false;
                                    setState(() {
                                    });
                                  }, icon: SvgPicture.asset(
                                    'assets/images/help/dropdown_up.svg',
                                  ),
                                  )
                                  ),
                                ],
                              ),
                              Text('${parsedResponseHR['content']}', style: textStyle.bk16normalCon,)
                            ],
                          ),
                        )
                    ),
                  ),
                ]else...[
                  Container(
                    width: Get.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                        child:
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(top: 16, left: 16, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('내용', style: textStyle.bk14midium,),
                                  SizedBox(width: 263,),
                                  Container(
                                      height: 30, child: IconButton(onPressed: (){
                                    watchContent = true;
                                    setState(() {
                                    });
                                  }, icon: SvgPicture.asset(
                                    'assets/images/help/dropdown_down.svg',
                                  ),
                                  )
                                  ),

                                ],
                              ),
                              //SizedBox(height: 5,),
                            ],
                          ),
                        )
                    ),
                  ),
                ],

                if(parsedResponseHR['answer'] != null)...[
                  SizedBox(height: 24,),
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffFEFBAC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if(main.toUserProfileImage.toString() == "null")...[
                              CircleAvatar(
                                radius: 12,
                                child: SvgPicture.asset('assets/images/user_null2.svg',),
                              ),
                            ]else...[
                              CircleAvatar(
                                radius: 12,
                                backgroundImage:
                                NetworkImage(main.toUserProfileImage,
                                ),
                              ),
                            ],

                            SizedBox(width: 10,),
                            Container(
                              width: 180,
                              child: Text('${main.toUsernickname}님이 보낸 도움', style: textStyle.bk14midium,),
                            ),
                            SizedBox(width: 35,),
                            //
                            Text('${DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHR['answeredAt']))}', style: textStyle.purple12normal,),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text('${parsedResponseHR['answer']}', style: textStyle.bk16normalCon,)
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                ],
              ]
            ],
          ),
        ),
      ),
    );
  }
}