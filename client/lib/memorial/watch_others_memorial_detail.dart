import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/memorial/others_memorial_main.dart';
import 'package:client/style.dart';
import 'package:intl/intl.dart';
import 'package:client/memorial/watch_others.dart' as watchmain;
import 'package:http/http.dart' as http;
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:client/memorial/slide/flutter_image_slideshow.dart';
import 'package:client/home.dart' as home;

class WatchOthersMemorialDetailPage extends StatefulWidget {
  @override
  State<WatchOthersMemorialDetailPage> createState() => _WatchOthersMemorialDetailPageState();
}

class _WatchOthersMemorialDetailPageState extends State<WatchOthersMemorialDetailPage> {

  //watchmain.selectedPostId.toString()

  // 화면에 보이는 UI 설정 bool
  bool askHelp = true;
  bool sendHelp = false;

  bool fetchSuccess = false;

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final myController = TextEditingController();

  late Map<String, dynamic> parsedResponseCN; // 글 내용
  late List<dynamic> parsedResponseCM; // 댓글

  List<String> parsedResponseIMGS = []; // 이미지 개수

  bool addComment = false; // 바로 코멘트 붙였을 때
  bool isComment = false;

  // 코멘트 수와 좋아요 수
  int comments = 0;
  int hearts = 0;

  late bool myHeart;

  // 글내용 가져오기
  void fetchWithHeaders(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial?postId=${watchmain.selectedPostId.toString()}'; // 실제 API 엔드포인트로 변경하세요

    print("몇번? "+watchmain.selectedPostId.toString());
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
      fetchSuccess = true;
      setState(() {});
      print('서버로부터 받은 내용 데이터(글 내용): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCN = json.decode(jsonResponse);

      // List<dynamic> 형식
      print("image test" + parsedResponseCN['imageList'][0].toString());

      hearts = parsedResponseCN['likes'];
      setState(() {

      });

      for(int i = 0; i<parsedResponseCN.length; i++){
        parsedResponseIMGS.add(parsedResponseCN['imageList'][i].toString());
        print("image test: " + parsedResponseCN['imageList'][i]);
      }

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 댓글 가져오기
  void fetchDataComment() async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/comment?postId=${watchmain.selectedPostId.toString()}';

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
      print('서버로부터 받은 데이터(댓글): $jsonResponse');

      isComment = true;
      comments = parsedResponseCM.length;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 댓글 저장하기 (POST)
  void saveComment(String aToken,String content) async {

    // 요청 본문 데이터
    var data = {
      "content" : content,
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    var url = Uri.parse('http://3.38.1.125:8080/memorial/comment?postId=${watchmain.selectedPostId.toString()}'); // 엔드포인트 URL 설정

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

  // 좋아요 누르기(POST)
  void sendPostRequest(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/like?postId=${watchmain.selectedPostId.toString()}'; // 실제 API 엔드포인트로 변경하세요

    // POST 요청 보내기e
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

      setState(() {});
      // print('서버로부터 받은 데이터: ${response.body}');
    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 좋아요 가져오기- 클릭여부 확인(GET)
  void fetchDataLike(String aToken) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/like?postId=${watchmain.selectedPostId.toString()}'; /// postId=1 추후에 바꿔주기

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

      myHeart = json.decode(jsonResponse);

      // 데이터 처리
      print('좋아요: $myHeart');
      // if(myHeart == true){
      //   hearts = 1;
      // } else{
      //   hearts = 0;
      // }

      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  // 댓글 삭제하기
  void deleteComment(String aToken, int commentId) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/comment?commentId=${commentId}';

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

  int comIndex = 0; // 삭제할 댓글 인덱스

  // 댓글 삭제 팝업
  void FlutterDialog() {
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Text("댓글을 삭제 하시겠어요?",style: textStyle.bk16bold,),
                        SizedBox(height: 8,),
                        Text("삭제한 후, 내용이 복구되지 않아요!", style: textStyle.bk14normal,),
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
                                child: new Text("삭제하기", style: textStyle.white16semibold),
                                style: buttonChart().purplebtn,
                                onPressed: () {

                                  // 서버에 전송
                                  deleteComment(sign_in.userAccessToken, comIndex);
                                  setState(() {});
                                  Timer(Duration(milliseconds: 500), () {
                                    fetchDataComment();
                                  });

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
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    fetchWithHeaders(sign_in.userAccessToken);
    fetchDataLike(sign_in.userAccessToken);

    print("test" + watchmain.selectedPostId.toString());
    fetchDataComment();
    setState(() {

    });
  }

  // 댓글 위젯
  Widget listview_builder(){
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: parsedResponseCM.length,
        itemBuilder: (BuildContext context, int index){
          return Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                height: 104,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if(parsedResponseCM[index]['profileImage'].toString() == "null")...[
                          CircleAvatar(
                            radius: 10,
                            child: SvgPicture.asset('assets/images/user_null2.svg',),
                          ),
                        ]else...[
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(parsedResponseCM[index]['profileImage'].toString()),
                          ),
                        ],
                        SizedBox(width: 8,),
                        Container(width: 55,
                          child: Text(parsedResponseCM[index]['nickname'], style: textStyle.bk12normal,),),
                        SizedBox(width: 204,),
                        if(parsedResponseCM[index]['nickname'] == home.user)...[
                          Container(width: 78, height: 32,
                            child: TextButton(onPressed: (){
                              comIndex = parsedResponseCM[index]['id'];
                              setState(() {
                              });
                              FlutterDialog();
                            }, child: Row(
                              children: [
                                Text("삭제하기", style: textStyle.grey12normal,),
                                SvgPicture.asset('assets/images/memorial/deletecom.svg',),
                              ],
                            )

                            ),
                          ),

                        ],


                      ],
                    ),
                    SizedBox(height: 6,),
                    Text(parsedResponseCM[index]['content'], style: textStyle.bk12normal,),
                    SizedBox(height: 6,),
                    Text(DateFormat('MM/dd  HH:mm').format(DateTime.parse(parsedResponseCM[index]['createdAt'])).toString(), style: TextStyle(fontSize: 10, color: Color(0xffAAAAAA)),)

                    //DateFormat('yy/MM/dd - HH:mm:ss').format(parsedResponse[0]['createdAt'])
                  ],
                ),
              ),
              SizedBox(height: 4,),
            ],
          );

        }
    );
  }

  double calculateListViewHeight() {
    // 리스트뷰의 아이템 수
    int itemCount = parsedResponseCM.length;

    // 리스트뷰의 열 수 (3개의 아이템이 한 행에 있을 때)
    int columnCount = 1;

    // 아이템의 높이 (가로:세로 비율을 설정할 수 있음)
    double itemHeight = 90; // 이 값은 적절히 조정

    // 아이템 간의 수직 간격
    double crossAxisSpacing = 8.0;

    // 리스트뷰의 높이 계산
    double listHeight = ((itemCount / columnCount).ceil() * itemHeight) +
        ((itemCount / columnCount - 1).ceil() * crossAxisSpacing);

    return listHeight;
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
            backgroundColor: Color(0xffDDE7FD),
            elevation: 0.0,
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
                  ],
                )),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if(fetchSuccess)...[
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                    child:  Container(
                      width: Get.width,
                      //height: 578,
                      color: Colors.white,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
                                  height: Get.width - 32,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: Get.width,
                                        height: Get.width - 32,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:
                                          ImageSlideshow(
                                            indicatorColor: Color(0xffFEFBAC),
                                            onPageChanged: (value) {
                                              debugPrint('Page changed: $value');
                                            },
                                            //autoPlayInterval: 3000,
                                            isLoop: false,
                                            children: [
                                              for(int i= 0; i<parsedResponseIMGS.length; i++)
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: Get.width,
                                                      height: Get.width - 32,
                                                      child: Image.network(parsedResponseIMGS[i], fit: BoxFit.cover,),),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 300, top: 10),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Color(0xffDDE7FD).withOpacity(0.6),
                                                            borderRadius: BorderRadius.circular(32),
                                                          ),
                                                          // color: Colors.white.withOpacity(0.7),
                                                          width: 41,
                                                          height: 19,
                                                          child: Center(
                                                            child: Text('${i+1} / ${parsedResponseIMGS.length}',style: textStyle.white14light,),
                                                          )
                                                      ),
                                                    ),

                                                  ],
                                                )

                                            ],
                                          ),
                                          //Image.network(watchmain.selectedOthersImage, fit: BoxFit.cover,),
                                        ),
                                        // Image.network(watchmain.selectedOthersImage, fit: BoxFit.cover,),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          watchmain.selectedUser = parsedResponseCN['userUid'];
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
                                            width: 90,
                                            height: 32,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 6,),
                                                if(watchmain.selectedOthersProfileImage.toString() == "null")...[
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
                                                      backgroundImage: NetworkImage(watchmain.selectedOthersProfileImage.toString()),
                                                    ),
                                                  ),
                                                ],
                                                // CircleAvatar(
                                                //   backgroundColor: Colors.white,
                                                //   radius: 10,
                                                //   child: CircleAvatar(
                                                //     radius: 9,
                                                //     backgroundImage: NetworkImage(watchmain.selectedOthersProfileImage.toString(),),
                                                //   ),
                                                // ),

                                                SizedBox(width: 5,),
                                                Container(
                                                  width: 37,
                                                  child:Text(watchmain.selectedOthersNickaname,
                                                    overflow: TextOverflow.ellipsis, // "..."으로 표시
                                                    maxLines: 1, // 원하는 줄 수로 설정
                                                    style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Pretendard',fontWeight: FontWeight.w600,),),
                                                ),
                                                SizedBox(width: 5,),
                                                Container(
                                                  width: 11,
                                                  child:
                                                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,size: 12,),
                                                  // SvgPicture.asset(
                                                  //   'assets/images/memorial/blue_arrow.svg',
                                                  //   //fit: BoxFit.cover,
                                                  // ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 32,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${parsedResponseCN['date']}의 기억", style: textStyle.grey12normal,),
                                          SizedBox(height: 4,),
                                          Text(parsedResponseCN['place'], style: textStyle.grey12normal)
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 150,),
                                    Row(
                                      children: [
                                        Container(
                                          width: 19,
                                          height: 19,
                                          child: InkWell(
                                            onTap: (){},
                                            child: SvgPicture.asset(
                                              'assets/images/memorial/comments.svg',
                                            ),
                                          ),),
                                        SizedBox( width: 3,),
                                        Text('${comments}'),
                                        SizedBox( width: 10,),
                                        if(hearts >= 1)...[
                                          Container(
                                            // width: 22,
                                            // height: 22,
                                            child: InkWell(
                                              onTap: (){
                                                // 좋아요 누르기
                                                sendPostRequest(sign_in.userAccessToken);
                                                // fetchDataLike(sign_in.userAccessToken);
                                                hearts--;
                                                setState(() {
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/memorial/heart-fill.svg',
                                              ),
                                            ),),
                                        ] else...[
                                          SizedBox(width: 2,),
                                          Container(
                                            // width: 22,
                                            // height: 22,
                                            child: InkWell(
                                              onTap: (){
                                                // 좋아요 누르기
                                                sendPostRequest(sign_in.userAccessToken);
                                                // fetchDataLike(sign_in.userAccessToken);
                                                hearts++;
                                                setState(() {
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/memorial/heart-empty.svg',
                                              ),
                                            ),
                                          ),
                                        ],
                                        SizedBox( width: 3,),
                                        Text('${hearts}'),
                                      ],
                                    )

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(parsedResponseCN['title'],style: textStyle.bk16semibold,),
                                    SizedBox(height: 8,),
                                    Container(width: Get.width,
                                      //height: 50,
                                      child: Text(parsedResponseCN['content'], style: textStyle.bk14normal,),
                                    ),
                                    SizedBox(height: 8,),
                                    Container(width: Get.width,
                                      height: 12,
                                      child: Text('#${parsedResponseCN['hashtag']}', style: textStyle.grey12normal),
                                    ),
                                    SizedBox(height: 5,),
                                  ],
                                ),
                              ],
                            ),),

                        ],
                      ),

                    ),
                  ),

                  SizedBox(height: 4,),
                  Container(
                    width: Get.width,
                    height: calculateListViewHeight() + 86,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              listview_builder(),
                            ],
                          )
                        ),
                      ],
                    )
                  ),

                ],

              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:[
              Container(
                color:Color(0xffF2F4F6),
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
                          border: Border.all(color: Color(colorChart.blue)),
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
                              border: InputBorder.none, hintText: '댓글을 입력하려면 여기를 탭하세요.'),
                          onChanged: (s) {
                            //text = s;
                            addComment = true;
                            setState(() {

                            });
                          },
                          onTap: (){

                          },
                        ),
                      ),
                      Positioned(
                        left: Get.width - 81,
                        //right: 30,
                        bottom: 3,
                        top: 3,
                        child: ElevatedButton(
                            onPressed: () {
                              if(addComment){
                                saveComment(sign_in.userAccessToken, myController.text);
                              }
                              addComment = false;
                              setState(() {
                              });

                              myController.clear();
                              Timer(Duration(milliseconds: 500), () {
                                fetchDataComment();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: addComment?Color(colorChart.blue):Color(0xffDDE7FD),
                              fixedSize: const Size(23, 23),
                              shape: const CircleBorder(),
                            ),
                            child:Icon(Icons.arrow_upward, color: Colors.white,size: 16,)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}