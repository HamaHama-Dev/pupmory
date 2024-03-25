import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/memorial/watch_others_memorial_detail.dart';
import 'package:client/style.dart';
import 'package:http/http.dart' as http;
import 'package:client/sign/sign_in.dart' as sign_in;
import 'memorial_search_result.dart';

String searchKeyword = "";

class MemorialSearchPage extends StatefulWidget {
  @override
  State<MemorialSearchPage> createState() => _MemorialSearchPageState();
}

class _MemorialSearchPageState extends State<MemorialSearchPage> {

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final myController = TextEditingController();

  // 최근 검색어 조회(GET)
  late List<dynamic> parsedResponseRS; // 최근 검색어
  bool recentKeyword = false;

  void fetchDataRecentSearch(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/search/history';

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

      parsedResponseRS = json.decode(jsonResponse);

      // 데이터 처리
      print('서버로부터 받은 데이터S: $jsonResponse');

      recentKeyword = true;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 추천 검색어 조회(GET)
  late List<dynamic> parsedResponseSR; // 최근 검색어
  bool rankKeyword = false;
  void fetchDataSearchRank() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/search/rank';

    // HTTP GET 요청 보내기
    var response = await http.get(
      Uri.parse(apiUrl),
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      var data = json.decode(response.body);
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseSR = json.decode(jsonResponse);

      // 데이터 처리
      print('서버로부터 받은 데이터: $jsonResponse');

      rankKeyword = true;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 검색어 전체 삭제
  void deleteAllSearch(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/search/history/all';

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      print("삭제성공");
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 최근 검색어 삭제
  void deleteDataSearch(String aToken, String search) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/search/history?keyword=${search}';

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    // HTTP GET 요청 보내기
    var response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers, // 헤더 추가
    );

    ///var jsonResponse = utf8.decode(response.bodyBytes);
    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터를 JSON 형식으로 디코딩
      print("삭제성공");
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
    fetchDataRecentSearch(sign_in.userAccessToken);
    fetchDataSearchRank();
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: AppBar(
          leading:
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
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
                        '함께할개',
                        style: textStyle.bk20normal,
                      ),
                    )),
              ],)
          ),

          backgroundColor: Color(0xffF3F3F3),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      body: Container(
        color: Color(0xffF3F3F3),
        padding: EdgeInsets.only(left: 15, right: 15 ),
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: Get.width- 25,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xff99A8CB),),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Positioned(
                      left: 34,
                      right: 80,
                      bottom: 0,
                      top: 15,
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '검색',
                            hintStyle: textStyle.grey16normal),
                        onChanged: (s) {
                          //text = s;
                        },
                        onTap: (){

                        },
                      ),
                    ),
                    Positioned(
                        right: Get.width - 75,
                        //right: 30,
                        bottom: 7,
                        top: -3,
                        child: IconButton(
                          onPressed: (){
                            searchKeyword = myController.text;
                            setState(() {
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemorialSearchResultPage()));
                          },
                          icon: Icon(Icons.search, color: Color(0xff99A8CB),),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Text('최근 검색어', style: TextStyle(color: Color(0xff4B5396), fontSize: 14, fontFamily: 'Pretendard',fontWeight: FontWeight.w500,),),
                  SizedBox(width: 225, ),
                  TextButton(
                    onPressed: (){
                      deleteAllSearch(sign_in.userAccessToken);
                    },
                    child: Text('전체 삭제', style: TextStyle(color: Color(0xff4B5396), fontSize: 12, fontFamily: 'Pretendard',fontWeight: FontWeight.w500,),),
                  )
                ],
              ),
              Container(
                width: Get.width,
                height: 350,
                child:Column(
                  children: [
                    if(recentKeyword)...[
                      for(int i=0; i<parsedResponseRS.length; i++)...[
                        Container(
                          height: 35,
                          child: Row(
                            children: [
                              Container(width: 270,
                                child: Text('${parsedResponseRS[i]['keyword']}',style: textStyle.bk14normal,),),
                              SizedBox(width: 35,),
                              IconButton(onPressed: (){
                                // 검색어 삭제
                                print(parsedResponseRS[i]['keyword']);
                                deleteDataSearch(sign_in.userAccessToken, parsedResponseRS[i]['keyword']);
                                parsedResponseRS.removeAt(i);
                                setState(() {});
                                //fetchDataRecentSearch(sign_in.userAccessToken);
                                fetchDataSearchRank();

                              }, icon: SvgPicture.asset(
                                'assets/images/cancel_icon.svg',
                              ),)
                            ],
                          ),
                        )
                      ]
                    ],
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Text('인기 검색어', style: TextStyle(color: Color(0xff4B5396), fontSize: 14, fontFamily: 'Pretendard',fontWeight: FontWeight.w500,),),
              SizedBox(height: 15,),
              if(rankKeyword)...[
                Container(
                    width: Get.width,
                    height: 300,
                    color: Color(0xffF3F3F3),
                    child: GridView.builder(
                        itemCount:parsedResponseSR.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 2.8 / 1, //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 8, //수평 Padding
                          crossAxisSpacing: 8, //수직 Padding
                        ),
                        itemBuilder: (BuildContext context, int index){
                          return
                            ElevatedButton(
                              style:  buttonChart().whitebtn3,
                              onPressed: (){
                                searchKeyword = parsedResponseSR[index]['keyword'];
                                setState(() {
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MemorialSearchResultPage()));
                              },
                              child: Text('${parsedResponseSR[index]['keyword']}', style: TextStyle(color: Color(0xff333333),fontSize: 14, fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w300,),),
                            );

                        })
                ),
              ],


            ],
          ),

        ),
      ),

    );
  }
}