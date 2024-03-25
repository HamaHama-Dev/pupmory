import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/mypage/announcement_detail.dart';
import 'package:client/sign/password_reset.dart';
import 'package:client/style.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:exif/exif.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client/sign/sign_in.dart' as sign_in;

int contentId = 0;

/// 공지사항
class AnnouncementMainPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => AnnouncementMainPage(),
      ),
    );
  }

  @override
  _AnnouncementMainPageState createState() => _AnnouncementMainPageState();
}

class _AnnouncementMainPageState extends State<AnnouncementMainPage> {

  late Map<String, dynamic> parsedResponseUser; // 사용자 정보
  bool takeUser = false;

  late List<dynamic> parsedResponseCM; // 글
  bool addComment = false;
  bool isComment = false;

  int comments = 0;
  // 글 가져오기
  void fetchDataA() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/mypage/announcement/all';

    // HTTP GET 요청 보내기
    var response = await http.get(Uri.parse(apiUrl));

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);

      // 데이터 처리
      print('서버로부터 받은 데이터: $jsonResponse');

      takeUser = true;
      isComment = true;
      comments = parsedResponseCM.length;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchDataA(); // 사용자 정보 가져오기
  }

  @override
  void dispose() async {
    super.dispose();
  }

  // 리스트 위젯
  Widget listview_builder(){
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: parsedResponseCM.length,
        itemBuilder: (BuildContext context, int index){
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                height: 95,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                    onTap: (){
                      contentId = parsedResponseCM[index]['id'];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnnouncementDetailPage()));
                      // 해당 글으로 이동
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            width: 262,
                            child:Text('함께할개 이용 규칙 안내',style: textStyle.bk14midium,),
                          ),
                          Text('2023-11-19',style: textStyle.bg10normal,),
                        ],),
                        SizedBox(height: 8,),
                        Container(
                          width: 308,
                          height: 32,
                          child:Text('${parsedResponseCM[index]['metaContent']}',style: textStyle.bk14normal,),
                        ),

                      ],
                    )
                ),
              ),
              SizedBox(height: 16,),

            ],
          );

        }
    );
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Scaffold(
          backgroundColor: Color(0xffF2F4F6),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(72),
            child: AppBar(
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
                              '공지사항',
                              style: textStyle.bk20normal,
                            ),
                          )),
                    ],)
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              leading: Padding(
                padding: EdgeInsets.only(top: 20),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),extendBodyBehindAppBar: false,
          body: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              scrollDirection: Axis.vertical,
              child:
              Column(
                children: [
                  listview_builder()
                ],
              )
            ),
          )

      );

  }
}
