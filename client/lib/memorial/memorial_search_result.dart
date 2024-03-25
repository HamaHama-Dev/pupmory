import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/memorial/memorial_search_result_detail.dart';
import 'package:client/memorial/watch_others_memorial_detail.dart';
import 'package:client/style.dart';
import 'package:http/http.dart' as http;
import 'memorial_search.dart'as search;
import 'package:flutter_svg/flutter_svg.dart';
import 'memorial_search.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'others_memorial_main.dart';

String selectedOthersImage = "";
String selectedOthersProfileImage = "";
String selectedOthersNickaname = "";
String selectedUser = "";
int selectedPostId = 0;

class MemorialSearchResultPage extends StatefulWidget {
  @override
  State<MemorialSearchResultPage> createState() => _MemorialSearchResultPageState();
}

class _MemorialSearchResultPageState extends State<MemorialSearchResultPage> {

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final myController = TextEditingController();

  // 검색어 조회(GET)
  late List<dynamic> parsedResponseSR; // 검색 결과
  bool result = false;

  void fetchDataSearchResult(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/search?keyword=${search.searchKeyword}';

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

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseSR = json.decode(jsonResponse);

      // 데이터 처리
      print('서버로부터 받은 데이터S: $jsonResponse');

      result = true;
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    fetchDataSearchResult(sign_in.userAccessToken);
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: AppBar(
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MemorialSearchPage())); // 검색페이지로 이동
                },
              ),
            ),
          ],
          leading:
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Container(
              height: 50,
              width: screenSize.width,
              child: Column(
                children: [
                  SizedBox(height: 24,),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(right: 60),
                    child: Text(
                      '함께할개',
                      style: textStyle.bk20bold,
                    ),
                  )),
                ],
              )),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      body: Container(
        color: Color(0xffDDE7FD),
        //padding: EdgeInsets.only(left: 16, right: 16 ),
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                  child: Container(
                      padding: EdgeInsets.all(16),
                      width: Get.width,
                      color: Color(0xffF1F5FE),
                      child: Column(children: [
                        SizedBox(height: 8,),
                        Row(children: [
                          Text('"${search.searchKeyword}" ', style: textStyle.bk16semibold),
                          Text('${parsedResponseSR.length}건의 결과 ', style: textStyle.bk16normal),
                        ],),
                        SizedBox(height: 20,),

                        if(parsedResponseSR.length == 0)...[
                          Column(
                            children: [
                              SizedBox(height: 200,),
                              SvgPicture.asset(
                                'assets/images/no_result.svg',
                                height: 124,
                              ),
                              SizedBox(height: 16,),
                              Text("일치하는 내용이 없습니다.", style: textStyle.bk16normal,)
                            ],
                          ),
                        ],


                        if(result && parsedResponseSR != "[]")...[
                          Container(
                              width: Get.width,
                              height: 760,
                              color: Color(0xffF1F5FE),
                              child: GridView.builder(
                                  itemCount:parsedResponseSR.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                                    childAspectRatio: 1.56 / 2.04, //item 의 가로 1, 세로 2 의 비율
                                    mainAxisSpacing: 16, //수평 Padding
                                    crossAxisSpacing: 16, //수직 Padding
                                  ),
                                  itemBuilder: (BuildContext context, int index){
                                    return
                                      InkWell(
                                        onTap: (){
                                          selectedOthersImage = parsedResponseSR[index]['image'];
                                          //selectedOthersImage = parsedResponseSR[index]['image'];
                                          selectedOthersProfileImage = parsedResponseSR[index]['profileImage'].toString();
                                          selectedOthersNickaname = parsedResponseSR[index]['nickname'];
                                          selectedUser = parsedResponseSR[index]['userUid'];
                                          selectedPostId = parsedResponseSR[index]['id'];
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MemorialSearchResultDetailPage()));
                                        },
                                        child: Container(
                                          // width: 200,
                                          // height: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // SizedBox(height: 5,),
                                                // SizedBox(height: 2,),
                                                Container(
                                                  height: 166,
                                                  width: 204,
                                                  child:
                                                  Stack(
                                                    children: [
                                                      Container(
                                                          height: 204,
                                                          width: 204,
                                                          child:
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                                                            child:  Image.network(parsedResponseSR[index]['image'], fit: BoxFit.cover,),
                                                          )


                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => OthersMemorialMainPage()));
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 10, top: 10),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.black.withOpacity(0.2),
                                                              borderRadius: BorderRadius.circular(32),
                                                            ),
                                                            // color: Colors.white.withOpacity(0.7),
                                                            width: 81,
                                                            height: 32,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: 10,),
                                                                CircleAvatar(
                                                                  backgroundColor: Colors.white,
                                                                  radius: 10,
                                                                  child: CircleAvatar(
                                                                    radius: 9,
                                                                    backgroundImage: NetworkImage(parsedResponseSR[index]['profileImage']),
                                                                  ),
                                                                ),

                                                                // CircleAvatar(
                                                                //   minRadius: 10,
                                                                //   maxRadius: 15,
                                                                //   backgroundImage:
                                                                //   NetworkImage(parsedResponseSR[index]['profileImage'],
                                                                //   ),
                                                                // ),
                                                                SizedBox(width: 5,),
                                                                Text(parsedResponseSR[index]['nickname'], style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Pretendard',fontWeight: FontWeight.w600,),),
                                                                Container(
                                                                    width: 20,
                                                                    child:
                                                                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,size: 12,)
                                                                  //Image.asset('assets/images/memorial/look_others_arrow.png'),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],),

                                                ),
                                                SizedBox(height: 8,),
                                                Container(
                                                  height: 16,
                                                  width: 155,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 10,),
                                                      Container(
                                                        width: 145,
                                                        height: 65,
                                                        child: Text(parsedResponseSR[index]['title'],style: TextStyle(color: Color(0xff333333), fontSize: 13.5, fontFamily: 'Pretendard',fontWeight: FontWeight.w400,), ),
                                                      ),
                                                      //Text(parsedResponseSR[index]['title'],style: TextStyle(color: Color(0xff333333), fontSize: 14.5, fontFamily: 'Pretendard',fontWeight: FontWeight.w400,),)
                                                    ],
                                                  ),
                                                ),
                                                // Column(
                                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                                //   children: [
                                                //
                                                //   ],
                                                // )

                                              ],
                                            )

                                        ),
                                      );

                                  })
                          ),
                        ]
                      ],
                      ),),),



            ],
          ),

        ),
      ),

    );
  }
}