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
import 'package:client/home.dart' as home;


class AnswerHelpRequestPage extends StatefulWidget {
  @override
  State<AnswerHelpRequestPage> createState() => _AnswerHelpRequestPageState();
}

class _AnswerHelpRequestPageState extends State<AnswerHelpRequestPage> {

  late Map<String, dynamic> parsedResponseHA; // 도움 답변 내역

  bool watchContent = true;

  bool answered = false; // 답변한 적이 있는지 확인
  int answerid = 0; // 답변한 적이 있다면 해당 내용들 가져오기 위한 정수

  bool send = false;

  // 내가 보낸 "도움" 내역 불러오기(GET) 및 상대방이 보낸 도움 내역 가져오기
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

      parsedResponseHA = json.decode(jsonResponse);
      // 답변을 했다면
      if(parsedResponseHA['answer'] != null){
        answered = true;
      }

      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 도움 답변 저장하기 (POST)
  void saveHelpAnswer(int id, String content, String aToken) async {

    // 요청 본문 데이터
    var data = {
      "helpId" : id,
      "content" : content,
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    var url = Uri.parse('http://3.38.1.125:8080/community/answer'); // 엔드포인트 URL 설정

    try {
      var response = await http.post(
        url,
        body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
        headers: headers, // 헤더 추가
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
        });


        print('API 호출 성공!!: ${response.statusCode}');
      } else {
        // 요청 실패 시의 처리
        print('API 호출 실패!!: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 발생 시의 처리
      print('API 호출 중 예외 발생: $e');
    }
  }


  // 화면에 보이는 UI 설정 bool
  bool askHelp = true;
  bool sendHelp = false;
  bool popup = true;
  bool sent = false; // 처음에 답을 보냈을떄 화면 표시를 위한 것

  // 도움 보내기 수
  int countHelp = 0;

  // 도움을 보낸 시각 (시연용)
  String sentDate = "";
  String helpContents = "";


  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    callHelpRequest(help.hid,sign_in.userAccessToken);
  }

  void FlutterDialog2() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(12.0))),
          content: Builder(
            builder: (context) {

              return Container(
                  height: 298,
                  width: 412,
                  child:
                  Padding(padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        SizedBox(height: 12,),
                        Container(
                          width: 125,
                          height: 117,
                          child: SvgPicture.asset(
                            'assets/images/no_result.svg',
                            width: 132,
                            height: 123,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 32,),
                        Text("${main.fromUsernickname}님에게 도움을 보내시겠어요?",style: textStyle.bk16bold,),
                        SizedBox(height: 8,),
                        Text("한 번 보낸 도움은 수정하거나 회수할수 없어요!", style: textStyle.bk14normal,),
                        SizedBox(height: 32,),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 120,
                              child: ElevatedButton(
                                child: new Text("취소", style: textStyle.purple16midium),
                                style: buttonChart().purplebtn3,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(width: 16,),
                            Container(
                              height: 40,
                              width: 120,
                              child: ElevatedButton(
                                child: new Text("도움 보내기", style: textStyle.white16semibold),
                                style: buttonChart().purplebtn,
                                onPressed: () {
                                  var now = DateTime.now();
                                  sentDate = DateFormat('yy/MM/dd h:mm').format(now);
                                  helpContents = myController.text;
                                  countHelp ++;
                                  sent = true;

                                  // 서버에 전송
                                  saveHelpAnswer(help.hid, myController.text, sign_in.userAccessToken);

                                  // !!화면 갱신!!
                                  callHelpRequest(help.hid, sign_in.userAccessToken);

                                  setState(() {});
                                  myController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),)
              );
            },
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(72),
          child: AppBar(
            title:
            Container(
              child: Column(
                children: [
                  SizedBox(height: 24,),
                  Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 60),
                        child: Text(
                          '도움 보내기',
                          style: textStyle.bk20normal,
                        ),
                      )),
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
                SizedBox(height: 8,),
                Container(
                  width: Get.width,
                  height: 56,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xffF3F3F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      if(main.fromUserProfileImage.toString() == "null")...[
                        CircleAvatar(
                          radius: 12,
                          child: SvgPicture.asset('assets/images/user_null2.svg',),
                        ),
                      ]else...[
                        CircleAvatar(
                          radius: 12,
                          backgroundImage:
                          NetworkImage(main.fromUserProfileImage,
                          ),
                        ),
                      ],

                      SizedBox(width: 8,),
                      Text('${main.fromUsernickname}님이 요청한 도움입니다.', style: textStyle.bk14normal,)
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  width: Get.width,
                  child:
                  ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                      child:
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            Text('제목', style: answered? textStyle.grey14midium : textStyle.bk14semibold,),
                            SizedBox(height: 5,),
                            Text('${parsedResponseHA['title']}', style: answered? textStyle.grey16normalCon :textStyle.bk16normalCon,),
                            SizedBox(height: 5,),
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
                                  Text('내용', style: answered? textStyle.grey14midium : textStyle.bk14midium,),
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
                              Text('${parsedResponseHA['content']}', style: answered? textStyle.grey16normalCon : textStyle.bk16normalCon,)
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
                                  Text('내용', style: answered? textStyle.grey14regular : textStyle.bk14midium,),
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

                SizedBox(height: 16,),
                if(answered)...[
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
                            Container(width: 200,
                              child: Text('${main.toUsernickname}님이 보낸 도움', style: textStyle.bk14midium,),),
                            SizedBox(width: 22,),
                            Text(DateFormat('MM/dd HH:mm').format(DateTime.parse(parsedResponseHA['answeredAt'])), style: TextStyle(fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff4B5396)),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(parsedResponseHA['answer'], style: textStyle.bk16normalCon,)
                      ],
                    ),
                  ),
                ],
                // 처음에 답을 보냈을때 보여줄 부분
                if(sent)...[
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
                            if(home.userprof == "null")...[
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
                            Container(width: 180,
                              child: Text('${home.user}님이 보낸 도움', style: textStyle.bk14midium,),),
                            SizedBox(width: 25,),
                            Text(sentDate, style: TextStyle(fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xff4B5396)),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(helpContents, style: textStyle.bk16normalCon,)
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 15,),

              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:[
              if(answered == false && sent == false)...[
                Container(
                  color: Colors.white,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 16,right: 16),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: Get.width,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: send?Color(colorChart.blue):Color(0xffC0D2FC)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          right: 30,
                          bottom:-4,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            maxLines: 1,
                            controller: myController,
                            style: textStyle.bk14normal,
                            decoration: InputDecoration(
                                hintStyle: textStyle.grey14normal,
                                border: InputBorder.none, hintText: '도움을 보내려면 여기를 탭하세요.'),
                            onChanged: (s) {
                              //text = s;
                              send = true;
                              setState(() {

                              });
                            },
                            onTap: (){

                            },
                            //maxLines: null,
                          ),
                        ),
                        Positioned(
                          left: Get.width - 81,
                          //right: 30,
                          bottom: 3,
                          top: 3,
                          child: ElevatedButton(
                              onPressed: () {
                                if(send){
                                  FlutterDialog2();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: send?Color(colorChart.blue):Color(0xffDDE7FD),
                                fixedSize: const Size(23, 23),
                                shape: const CircleBorder(),
                              ),
                              child:Icon(Icons.arrow_upward, color: Colors.white, size: 16,)
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],

            ],
          ),
        )
    );
  }
}