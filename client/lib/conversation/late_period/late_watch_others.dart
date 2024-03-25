import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'late_memorial_search.dart';
import 'late_watch_others_detail.dart';
import 'package:client/style.dart';
import 'package:http/http.dart' as http;
import '../../memorial/others_memorial_main.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'late.dart' as late_;

String selectedOthersImage = "";
String selectedOthersProfileImage = "";
String selectedOthersNickaname = "";
String selectedUser = "";
int selectedPostId = 0;

class LateWatchOthersPage extends StatefulWidget {
  @override
  State<LateWatchOthersPage> createState() => _LateWatchOthersPageState();
}

class _LateWatchOthersPageState extends State<LateWatchOthersPage> {

  late List<dynamic> parsedResponseCM; // 실시간 피드
  late List<dynamic> parsedResponseFC; // 실시간 피드_필터적용

  bool checkUser = false;
  bool isLastest = false;

  String dogType = ""; // 강아지 타입
  String dogAge = ""; // 강아지 나이

  // 필터링 선택 나이 or 견종
  bool selectType = false;
  bool selectAge = false;

  List<String> parsedResponseIMGS = []; // 이미지 개수

  // 내용 최신 피드 불러오기(GET)
  void fetchWithHeaders(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/feed?filter=false'; // 실제 API 엔드포인트로 변경하세요

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
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);


      isLastest = true;
      setState(() {});

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  void sendPostRequest(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/feed?filter=false'; // 실제 API 엔드포인트로 변경하세요

    // POST 요청 보내기
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
        'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
        //'Content-Type': 'application/json',
      }, // 요청 헤더에 Content-Type 설정
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);

      print("갯수:" + parsedResponseCM.length.toString());

      isLastest = true;
      setState(() {});
      // print('서버로부터 받은 데이터: ${response.body}');
    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  late Map<String, dynamic> parsedResponseUser; // 사용자 정보

  // 필터링 적용을 위한 사용자 정보 가져오기
  void fetchUserInfo(String aToken) async {
    // API 엔드포인트 URL
    print("받토:" + aToken);
    String apiUrl = 'http://3.38.1.125:8080/user/info'; // 실제 API 엔드포인트로 변경하세요

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
      print('서버로부터 받은 내용 데이터(사용자 정보): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseUser = json.decode(jsonResponse);

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  void sendPostRequestFilter(String aToken, String type) async {

    // 요청 본문 데이터
    var data = {
      "type" : type,
    };
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/feed?filter=true';

    // POST 요청 보내기
    var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
      headers: {
        'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
        'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
        //'Content-Type': 'application/json',
      }, // 요청 헤더에 Content-Type 설정
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);

      // isLastest = true;
      setState(() {});
      // print('서버로부터 받은 데이터: ${response.body}');
    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  void sendPostRequestFilter2(String aToken ,String age) async {

    // 요청 본문 데이터
    var data = {
      "age" : age,
    };
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/feed?filter=true';

    // POST 요청 보내기
    var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
      headers: {
        'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
        'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
        //'Content-Type': 'application/json',
      }, // 요청 헤더에 Content-Type 설정
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);

      selectAge = true;
      // isLastest = true;
      setState(() {});
      // print('서버로부터 받은 데이터: ${response.body}');
    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 두개 다 선택
  void sendPostRequestFilter3(String aToken, String age, String type) async {

    // 요청 본문 데이터
    var data = {
      "age" : age,
      "type" : type,
    };
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/feed?filter=true';

    // POST 요청 보내기
    var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(data), // 요청 본문에 데이터를 JSON 형식으로 인코딩하여 전달
      headers: {
        'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
        'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
        //'Content-Type': 'application/json',
      }, // 요청 헤더에 Content-Type 설정
    );

    // HTTP 응답 상태 확인
    if (response.statusCode == 200) {
      // 응답 데이터 처리
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCM = json.decode(jsonResponse);

      selectAge = true;
      // isLastest = true;
      setState(() {});
      // print('서버로부터 받은 데이터: ${response.body}');
    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    //fetchWithHeaders();

    fetchUserInfo(sign_in.userAccessToken);
    //_callAPI();
    sendPostRequest(sign_in.userAccessToken);
  }

  double calculateGridViewHeight() {
    // 그리드뷰의 아이템 수
    int itemCount = parsedResponseCM.length;

    // 그리드뷰의 열 수 (3개의 아이템이 한 행에 있을 때)
    int columnCount = 2;

    // 아이템의 높이 (가로:세로 비율을 설정할 수 있음)
    double itemHeight = 204; // 이 값은 적절히 조정

    // 아이템 간의 수직 간격
    double crossAxisSpacing = 8.0;

    // 그리드뷰의 높이 계산
    double gridHeight = ((itemCount / columnCount).ceil() * itemHeight) +
        ((itemCount / columnCount - 1).ceil() * crossAxisSpacing);

    return gridHeight;
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
            Padding(padding: EdgeInsets.only(top:15),
              child: new IconButton(
                icon:Icon(Icons.search, size: 24,),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LateMemorialSearchPage())); // 검색페이지로 이동
                },
              ),
            ),

          ],
          automaticallyImplyLeading:false,
          title:
          Container(
            height: 50,
            width: screenSize.width,
            child: Column(
              children: [
                SizedBox(height: 24,),
                Center(
                    child: Padding(padding: EdgeInsets.only(left: 60),
                      child: Text('함께할개', style: textStyle.bk20normal,),
                    )
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xffDDE7FD),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      body: Container(
        color: Color(0xffDDE7FD),
        //width: Get.width,
        //height: Get.height,
        child: SingleChildScrollView(

          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if(isLastest)...[
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: Get.width,
                    color: Color(0xffF1F5FE),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(bottom: 22, left: 0),
                          child: Row(
                            children: [
                              if(selectType)...[
                                Container(
                                  height: 28,
                                  width: 119,
                                  child: ElevatedButton(onPressed: (){
                                    dogType = "${parsedResponseUser['puppyType']}";
                                    selectType = false;
                                    if(selectAge){
                                      sendPostRequestFilter2(sign_in.userAccessToken,parsedResponseUser['puppyAge'].toString());
                                    }else{
                                      sendPostRequest(sign_in.userAccessToken);
                                    }
                                    setState(() {});
                                    //sendPostRequestFilter(sign_in.userAccessToken);
                                  },
                                      style: buttonChart().whitebtn4,
                                      child: Text("${parsedResponseUser['puppyType']}", style: textStyle.wo16semibold,)
                                  ),
                                ),
                              ]else...[
                                Container(
                                  height: 28,
                                  width: 119,
                                  child: ElevatedButton(onPressed: (){
                                    dogType = "${parsedResponseUser['puppyType']}";
                                    selectType = true;
                                    setState(() {});
                                    if(selectAge){
                                      sendPostRequestFilter3(sign_in.userAccessToken, parsedResponseUser['puppyAge'].toString() ,parsedResponseUser['puppyType']);
                                    }else{
                                      sendPostRequestFilter(sign_in.userAccessToken, parsedResponseUser['puppyType']);
                                    }
                                  },
                                      style: buttonChart().whitebtn3,
                                      child: Text("${parsedResponseUser['puppyType']}", style: textStyle.bk16light,)
                                  ),
                                ),
                              ],

                              SizedBox(width: 16,),
                              if(selectAge)...[
                                Container(
                                  height: 28,
                                  width: 63,
                                  child: ElevatedButton(onPressed: (){
                                    dogAge = "${parsedResponseUser['puppyAge']}살";
                                    selectAge = false;
                                    setState(() {});
                                    if(selectType){
                                      sendPostRequestFilter(sign_in.userAccessToken, parsedResponseUser['puppyType']);
                                    }else{
                                      sendPostRequest(sign_in.userAccessToken);
                                    }
                                  },
                                      style: buttonChart().whitebtn4,
                                      child: Text("${parsedResponseUser['puppyAge']}살", style: textStyle.wo16semibold,)
                                  ),
                                ),
                              ]
                              else...[
                                Container(
                                  height: 28,
                                  width: 63,
                                  child: ElevatedButton(onPressed: (){
                                    dogAge = "${parsedResponseUser['puppyAge']}살";
                                    selectAge = true;
                                    setState(() {});
                                    if(selectType){
                                      sendPostRequestFilter3(sign_in.userAccessToken, parsedResponseUser['puppyAge'].toString() ,parsedResponseUser['puppyType']);
                                    }else{
                                      sendPostRequestFilter2(sign_in.userAccessToken,parsedResponseUser['puppyAge'].toString());
                                    }
                                  },
                                      style: buttonChart().whitebtn3,
                                      child: Text("${parsedResponseUser['puppyAge']}살", style: textStyle.bk16light,)
                                  ),
                                ),
                              ],
                              SizedBox(width: 16,),
                              Container(
                                height: 28,
                                width: 52,
                                child: ElevatedButton(onPressed: (){
                                  setState(() {});
                                  selectAge = false;
                                  selectType = false;
                                  sendPostRequest(sign_in.userAccessToken);
                                },
                                  style: buttonChart().whitebtn3,
                                  child: SvgPicture.asset(
                                    'assets/images/memorial/reset.svg',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          //padding: EdgeInsets.all(8.0),
                            width: Get.width,
                            height: (parsedResponseCM.length) == 0? Get.height - 234 : calculateGridViewHeight() + 188,
                            color: Color(0xffF1F5FE),
                            child:
                            Column(
                              children: [
                                Expanded(
                                    child: Column(
                                      children: [
                                        (parsedResponseCM.length) != 0?
                                        GridView.builder(
                                            shrinkWrap: true, // 그리드뷰가 자신의 내용에 맞게 크기를 조절하도록 함
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount:parsedResponseCM.length,
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
                                                    selectedOthersImage = parsedResponseCM[index]['image'];
                                                    selectedOthersProfileImage = parsedResponseCM[index]['profileImage'].toString();
                                                    selectedOthersNickaname = parsedResponseCM[index]['nickname'];
                                                    selectedUser = parsedResponseCM[index]['userUid'];
                                                    selectedPostId = parsedResponseCM[index]['id'];
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => LateWatchOthersMemorialDetailPage()));
                                                  },
                                                  child: Container(
                                                    // width: 156,
                                                    // height: 204,
                                                      padding: EdgeInsets.all(1.0),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.05),
                                                            blurRadius: 10.0,
                                                            spreadRadius: 0.0,
                                                            offset: const Offset(0,7),
                                                          )
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(16),
                                                      ),
                                                      child:Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
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
                                                                      child:
                                                                      Image(
                                                                        image: NetworkImage(parsedResponseCM[index]['image'],),
                                                                        fit: BoxFit.cover,
                                                                        errorBuilder: (context, error, stackTrace) {
                                                                          // 오류 발생 시 대체 이미지를 표시
                                                                          return SvgPicture.asset(
                                                                            'assets/images/no_result.svg',);
                                                                        },
                                                                      )
                                                                    //Image.network(parsedResponseCM[index]['image'], fit: BoxFit.cover,),
                                                                  ),
                                                                  //Image.network(parsedResponseCM[index]['image'], fit: BoxFit.cover,),
                                                                ),

                                                                Padding(padding: EdgeInsets.only(left: 8, top:8),
                                                                  child: InkWell(
                                                                    onTap: (){
                                                                      // selectedUser = parsedResponseCM[index]['userUid'];
                                                                      // Navigator.push(
                                                                      //     context,
                                                                      //     MaterialPageRoute(
                                                                      //         builder: (context) => OthersMemorialMainPage()));
                                                                    },
                                                                    child:
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.black.withOpacity(0.2),
                                                                        borderRadius: BorderRadius.circular(32),
                                                                      ),
                                                                      // color: Colors.white.withOpacity(0.7),
                                                                      width: 86,
                                                                      height: 32,
                                                                      child: Row(
                                                                        children: [
                                                                          SizedBox(width: 5,),
                                                                          if(parsedResponseCM[index]['profileImage'].toString() == "null")...[
                                                                            CircleAvatar(
                                                                              backgroundColor: Colors.white,
                                                                              radius: 10,
                                                                              child: CircleAvatar(
                                                                                child: SvgPicture.asset('assets/images/user_null2.svg',),
                                                                                radius: 9,
                                                                              ),
                                                                            ),
                                                                          ]else...[
                                                                            CircleAvatar(
                                                                              backgroundColor: Colors.white,
                                                                              radius: 10,
                                                                              child: CircleAvatar(
                                                                                radius: 9,
                                                                                backgroundImage: NetworkImage(parsedResponseCM[index]['profileImage'].toString()),
                                                                              ),
                                                                            ),
                                                                          ],

                                                                          SizedBox(width: 5,),
                                                                          Container(
                                                                            width: 37,
                                                                            child:Text(parsedResponseCM[index]['nickname'],
                                                                              overflow: TextOverflow.ellipsis, // "..."으로 표시
                                                                              maxLines: 1, // 원하는 줄 수로 설정
                                                                              style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Pretendard',fontWeight: FontWeight.w600,),),
                                                                          ),
                                                                          SizedBox(width: 1,),
                                                                          Container(
                                                                              width: 11,
                                                                              child:
                                                                              Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,size: 12,)
                                                                            // SvgPicture.asset(
                                                                            //   'assets/images/memorial/blue_arrow.svg',
                                                                            //   //fit: BoxFit.cover,),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],),
                                                          ),
                                                          SizedBox(height: 8,),
                                                          Container(
                                                            height: 16,
                                                            width: 150,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: 10,),
                                                                Container(
                                                                  width: 140,
                                                                  height: 65,
                                                                  child: Text(parsedResponseCM[index]['title'],style: TextStyle(color: Color(0xff333333), fontSize: 13.5, fontFamily: 'Pretendard',fontWeight: FontWeight.w400,), ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                );

                                            }):
                                        Padding(padding: EdgeInsets.only(top: 200),
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/no_result.svg',
                                                  height: 124,
                                                ),
                                                SizedBox(height: 16,),
                                                Text("일치하는 내용이 없습니다.", style: textStyle.bk16normal,)
                                              ],
                                            )
                                        )
                                      ],
                                    )
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                      Navigator.pop(context);

                      late_.player2.setAsset(late_.voice[28]);
                      late_.player2.play();
                      // 2.5초 적정
                      late_.controller1.repeat(
                          min: 0,
                          max: 30,
                          period: const Duration(milliseconds: 1000)
                      );
                      Timer(Duration(milliseconds: 3500), () {
                        late_.controller1.stop();
                      });
                      setState(() {});
                    },
                    child: Text("대화로 돌아가기", style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF))),
                  ),
                ),),
            ),
          ],
        ),
      ),

    );
  }
}