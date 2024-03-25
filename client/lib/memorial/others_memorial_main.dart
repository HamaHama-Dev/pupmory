import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/memorial/others_memorial_detail.dart';
import 'package:client/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../help/write_help_request.dart';
import 'memorial_detail.dart';
import 'package:flutter_svg/svg.dart';
import 'package:word_cloud/word_cloud_data.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import '../flutter_hashtags.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:client/memorial/watch_others.dart' as watchmain;

String selectedImage = "";
String proImage = "";
int postId = 0;
String userUid = "";
String userName = "";

class OthersMemorialMainPage extends StatefulWidget {
  @override
  State<OthersMemorialMainPage> createState() => _OthersMemorialMainPageState();
}


class _OthersMemorialMainPageState extends State<OthersMemorialMainPage> {

  // 화면에 보이는 UI 설정 bool
  bool fetchDataSuccess = false;
  bool memorial = true;
  bool wordCloud = false;
  bool helpList = false;


  void fetchWithHeaders(String aToken, String targetUid) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/guest/all?targetUid=${targetUid}'; // 실제 API 엔드포인트로 변경하세요

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
      fetchDataSuccess = true;
      print('서버로부터 받은 내용 데이터: ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseCN = json.decode(jsonResponse);

      userName = parsedResponseCN['nickname'];

      proImage = parsedResponseCN['profileImage'].toString();

      // JSON 문자열을 Map<String, dynamic>으로 파싱
      Map<String, dynamic> data = json.decode(jsonResponse);

      // "posts" 배열의 내용을 추출
      //List<dynamic> postsList = data["posts"];
      postsList = data["posts"];

      print(postsList);

      // 추출된 "posts" 배열의 내용 출력
      postsList.forEach((post) {
        print('게시물 ID: ${post["id"]}');
        print('게시물 제목: ${post["title"]}');
        print('게시물 내용: ${post["content"]}');
        // 필요한 다른 정보도 출력하거나 처리할 수 있습니다.
      });

      checkCN = true;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }


  late Map<String, dynamic> parsedResponseCN; // 글 내용
  bool checkCN = false;
  late List<dynamic> postsList; // 포스트 하나 내용


  // 워드 클라우드
  // 최근 검색어 조회(GET)
  late List<dynamic> parsedResponseRS; // 최근 검색어
  bool recentKeyword = false;
  // http://3.38.1.125:8080/community/wcloud

  List<FlutterHashtag> kFlutterHashtags2 = [];

  void fetchDataWordCloud(String aToken, String targetUid) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/wcloud?targetUid=${targetUid}';

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

      print("확인~~~"+parsedResponseRS.length.toString());

      if(parsedResponseRS.length<10){
        for(int i=0; i<parsedResponseRS.length; i++){
          if(i % 2 ==0){
            kFlutterHashtags2.add(FlutterHashtag('${parsedResponseRS[i]['word']}', FlutterColors.popular, parsedResponseRS[i]['value'] * 33, false),);
          }else if(i %3 == 0){
            kFlutterHashtags2.add(FlutterHashtag('${parsedResponseRS[i]['word']}', FlutterColors.medium, parsedResponseRS[i]['value']* 33, true),);
          } else{
            kFlutterHashtags2.add(FlutterHashtag('${parsedResponseRS[i]['word']}', FlutterColors.less, parsedResponseRS[i]['value']* 33, false),);
          }
        }
      }else{
        for(int i=0; i<parsedResponseRS.length; i++){
          if(i % 2 ==0){
            kFlutterHashtags2.add(FlutterHashtag('${parsedResponseRS[i]['word']}', FlutterColors.popular, parsedResponseRS[i]['value'] * 55, false),);
          }else if(i %3 == 0){
            kFlutterHashtags2.add(FlutterHashtag('${parsedResponseRS[i]['word']}', FlutterColors.medium, parsedResponseRS[i]['value']* 55, true),);
          } else{
            kFlutterHashtags2.add(FlutterHashtag('${parsedResponseRS[i]['word']}', FlutterColors.less, parsedResponseRS[i]['value']* 55, false),);
          }
        }
      }



      recentKeyword = true;
      setState(() {
      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }

  late List<dynamic> parsedResponseH; // 댓글

  void fetchHelp(String aToken, String targetUid) async {
    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/community/help/log?targetUid=${targetUid}';

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

      parsedResponseH = json.decode(jsonResponse);

      // 데이터 처리
      print('서버로부터 받은 데이터S: $jsonResponse');

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

    fetchWithHeaders(sign_in.userAccessToken, watchmain.selectedUser);
    fetchDataWordCloud(sign_in.userAccessToken, watchmain.selectedUser);
    fetchHelp(sign_in.userAccessToken, watchmain.selectedUser);
    //mydata.addData(String word, Double value);
  }

  double calculateGridViewHeight() {
    // 그리드뷰의 아이템 수
    int itemCount = postsList.length;

    // 그리드뷰의 열 수 (3개의 아이템이 한 행에 있을 때)
    int columnCount = 3;

    // 아이템의 높이 (가로:세로 비율을 설정할 수 있음)
    double itemHeight = 104.0; // 이 값은 적절히 조정

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

    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < kFlutterHashtags2.length; i++) {
      widgets.add(ScatterItem(kFlutterHashtags2[i], i));
    }
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
              child:
              Column(
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
              )
          ),
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
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //SizedBox(height: 16,),
              Row(
                children: [
                  SizedBox(width: 16,),
                  Stack(
                    children: [
                      if(parsedResponseCN['profileImage'].toString() == "null")...[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 59.5,
                          child: CircleAvatar(
                            radius: 54.5,
                            child: SvgPicture.asset('assets/images/user_null2.svg',width: 110,
                              height: 110,
                              fit: BoxFit.fill,),
                          ),
                        ),
                      ]else...[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 59.5,
                          child: CircleAvatar(
                            radius: 54.5,
                            backgroundImage: NetworkImage(parsedResponseCN['profileImage'].toString()),
                          ),
                        ),
                      ],

                      Padding(padding: EdgeInsets.fromLTRB(80, 80, 15, 15),
                        child: SvgPicture.asset('assets/images/memorial/foot.svg'),)
                    ],
                  ),


                  SizedBox(width: 8,),
                  Padding(padding: EdgeInsets.only(bottom:22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("${parsedResponseCN['nickname']}", style: TextStyle(fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700, fontSize: 20),),
                            Text("님의 반려견,", style: TextStyle(fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500, fontSize: 16),),
                          ],
                        ),
                        SizedBox(height: 4,),
                        Row(
                          children: [
                            Text("${parsedResponseCN['puppyName']}", style: TextStyle(fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700, fontSize: 20),),
                            Text("(${parsedResponseCN['puppyType']}, ${parsedResponseCN['puppyAge']}살)", style: TextStyle(fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500, fontSize: 16),),
                          ],
                        ),
                      ],
                    ))
                ],
              ),
              SizedBox(height: 12,),

              Container(
                width: screenSize.width - 32,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xffF2F6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5,),
                    if(memorial && wordCloud == false && helpList == false)...[
                      Container(
                          decoration: BoxDecoration(
                            color: Color(0xffC0D2FC),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          width: 98,
                          height: 32,
                          child: Center(child: Text("기억할개",style: TextStyle(color: Color(0xff4B5396), fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 16))
                            ,)
                      ),
                      SizedBox(width: 24,),
                      TextButton(onPressed: (){
                        memorial = false;
                        wordCloud = true;
                        helpList = false;
                        setState(() {});
                      }, child: Text("워드클라우드", style: textStyle.bk16normal,)),
                      SizedBox(width: 32,),
                      TextButton(onPressed: (){
                        memorial = false;
                        wordCloud = false;
                        helpList = true;
                        setState(() {});
                      }, child: Text("도움이력", style: textStyle.bk16normal,)),

                    ]else if(memorial  == false && wordCloud && helpList == false)...[
                      SizedBox(width: 5,),
                      Container(width: 88,
                        height: 38,
                        child: TextButton(onPressed: (){
                          memorial = true;
                          wordCloud = false;
                          helpList = false;
                          setState(() {});
                        }, child: Text("기억할개", style: textStyle.bk16normal,)),
                      ),
                      SizedBox(width: 10,),
                      Container(
                          decoration: BoxDecoration(
                            color: Color(0xffC0D2FC),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          width: 136,
                          height: 32,
                          child: Center(child: Text("워드클라우드", style: TextStyle(color: Color(0xff4B5396), fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 16)),)
                      ),

                      SizedBox(width: 14,),
                      TextButton(onPressed: (){
                        memorial = false;
                        wordCloud = false;
                        helpList = true;
                        setState(() {});
                      }, child: Text("도움이력", style: textStyle.bk16normal,)),
                    ] else if(memorial  == false && wordCloud == false && helpList)...[
                      SizedBox(width: 5,),
                      Container(
                        width: 88,
                        child: TextButton(onPressed: (){
                          memorial = true;
                          wordCloud = false;
                          helpList = false;
                          setState(() {});
                        }, child: Text("기억할개", style: textStyle.bk16normal,)),
                      ),
                      SizedBox(width: 18,),
                      Container(
                        width: 120,
                        child: TextButton(onPressed: (){
                          memorial = false;
                          wordCloud = true;
                          helpList = false;
                          setState(() {});
                        }, child: Text("워드클라우드", style: textStyle.bk16normal,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                          decoration: BoxDecoration(
                            color: Color(0xffC0D2FC),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          width: 106,
                          height: 32,
                          child: Center(child: Text("도움이력",style: TextStyle(color: Color(0xff4B5396), fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 16)),)
                      ),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     TextButton(onPressed: (){
                      //       memorial = false;
                      //       wordCloud = false;
                      //       helpList = true;
                      //       setState(() {});
                      //     }, child: Text("도움 이력", style: textStyle.bk16bold,)),
                      //     Container(
                      //       color: Colors.black,
                      //       width: 100,
                      //       height: 2,
                      //     )
                      //   ],
                      // ),
                    ]
                  ],
                ),
              ),

              SizedBox(height: 18,),

              Container(
                //padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  width: Get.width,
                  //height: Get.height,
                  color: Color(0xffF2F4F6),
                  child:
                  Column(
                    children: [
                      if(memorial)...[
                        Container(
                            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                            width: Get.width,
                            height: (postsList.length < 13)? 524 :calculateGridViewHeight() + 195,
                            child: GridView.builder(
                                shrinkWrap: true, // 그리드뷰가 자신의 내용에 맞게 크기를 조절하도록 함
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:postsList.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                                  childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                                  mainAxisSpacing: 10, //수평 Padding
                                  crossAxisSpacing: 10, //수직 Padding
                                ),
                                itemBuilder: (BuildContext context, int index){
                                  return
                                    InkWell(
                                      onTap: (){
                                        postId = postsList[index]['id'];
                                        selectedImage = postsList[index]['image'];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OthersMemorialDetailPage()));
                                      },
                                      child: Container(
                                        width: 114,
                                        height: 114,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child: Image.network(postsList[index]['image'], fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              // 오류 발생 시 대체 이미지를 표시
                                              return SvgPicture.asset(
                                                'assets/images/no_result.svg',);
                                            },
                                          ),
                                        ),
                                        // Image.network(
                                        //   parsedResponse[index],
                                        //   //'https://images.unsplash.com/photo-1519098901909-b1553a1190af?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80',
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                    );

                                })
                        ),
                      ] else if(helpList)...[
                        if(parsedResponseH.length > 0)...[
                          SizedBox(height: 4,),
                          Center(
                            child: Container(
                                padding: EdgeInsets.all(16),
                                width: Get.width,
                                height: 524,
                                // color: Colors.white,
                                child: GridView.builder(
                                    itemCount:parsedResponseH.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                                      childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                                      mainAxisSpacing: 16, //수평 Padding
                                      crossAxisSpacing: 16, //수직 Padding
                                    ),
                                    itemBuilder: (BuildContext context, int index){
                                      return
                                        Container(
                                          width: 96,
                                          height: 96,
                                          child: Stack(
                                            children: [

                                              if(parsedResponseH[index]['profileImage'].toString() == "null")...[
                                                CircleAvatar(
                                                  radius: 56,
                                                  child: SvgPicture.asset('assets/images/user_null2.svg',),
                                                ),
                                              ]else...[
                                                CircleAvatar(
                                                  radius: 56,
                                                  backgroundImage: NetworkImage(parsedResponseH[index]['profileImage'].toString()),
                                                ),
                                              ],
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.4),
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                              ),
                                              Center(
                                                child: Text("${parsedResponseH[index]['nickname']}", style: textStyle.white14normal),
                                              )
                                            ],
                                          ),
                                        );
                                    })
                            ),
                          ),
                        ]else...[
                          Container(
                              padding:
                              EdgeInsets.only(top: 16, left: 16, right: 16),
                              width: Get.width,
                              height: 524,
                              child: Padding(
                                padding: EdgeInsets.only(top: 136),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/no_result.svg',
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "도움이력 정보가 없어요!",
                                      style: textStyle.bk16normal,
                                    )
                                  ],
                                ),
                              )),
                        ]
                      ]else if(wordCloud)...[
                        if(recentKeyword && parsedResponseRS.length > 0)...[
                          Container(
                            padding: EdgeInsets.all(16.0),
                            width: screenSize.width,
                            height: 524,
                            // color: Colors.black,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  width: screenSize.width,
                                  height: 414,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 66, bottom: 16, left: 16, right: 16),
                                    width: Get.width,
                                    //height: ,
                                    child: FittedBox(
                                      child: Scatter(
                                        fillGaps: true,
                                        delegate: ArchimedeanSpiralScatterDelegate(ratio: 17 / 15),
                                        children: widgets,
                                      ),
                                    )
                                ),
                                // FittedBox(
                                //   child: Scatter(
                                //     fillGaps: true,
                                //     delegate: ArchimedeanSpiralScatterDelegate(ratio: Get.width / Get.height),
                                //     children: widgets,
                                //   ),
                                // ),
                              ],
                            ),
                          )

                        ] else if(recentKeyword == false)...[
                          Container(
                              padding:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              width: Get.width,
                              height: 524,
                              child: Padding(
                                padding: EdgeInsets.only(top: 136),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/no_result.svg',
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "워드클라우드 정보가 없어요!",
                                      style: textStyle.bk16normal,
                                    )
                                  ],
                                ),
                              )),
                        ],

                        //SizedBox(height: 65,),
                      ],
                    ],
                  )
              ),


            ],
          ),
        ),
      ),
      floatingActionButton: 
      Padding(
        padding: EdgeInsets.only(bottom:10),
        child: SizedBox(
        height: 44,
        width: 153,
        child: extendButton(),
      ),)
      ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  FloatingActionButton extendButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        userUid = watchmain.selectedUser;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WriteHelpRequestPage()));
      },
      label: Row(children: [
        Text("도움 요청하기", style: textStyle.white16bold,),
        SizedBox(width: 5),
        SvgPicture.asset(
          'assets/images/memorial/help_btn2.svg',
        ),

      ],),
      //icon: ImageIcon(AssetImage('assets/images/memorial/white_heart.png'),color: Colors.white,),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),

      /// 텍스트 컬러
      foregroundColor: Colors.black,
      backgroundColor: Color(0xffEFA1B6),
    );
  }
}

class ScatterItem extends StatelessWidget {
  ScatterItem(this.hashtag, this.index);
  final FlutterHashtag hashtag;
  final int index;

  @override
  Widget build(BuildContext context) {
    // final TextStyle style = Theme.of(context).textTheme.body1.copyWith(
    //   fontSize: hashtag.size.toDouble(),
    //   color: hashtag.color,
    // );
    final TextStyle style = Theme.of(context).textTheme.bodySmall!.copyWith(
      fontSize: hashtag.size.toDouble(),
      fontFamily: 'Cafe24SsurroundAir-v1.1',
      color: hashtag.color,
    );

    final TextStyle style2 = Theme.of(context).textTheme.bodySmall!.copyWith(
      fontSize: hashtag.size.toDouble(),
      fontFamily: 'Cafe24SsurroundAir-v1.1',
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = hashtag.color,
    );

    return RotatedBox(
      quarterTurns: hashtag.rotated ? 1 : 0,
      child: Stack(
        children: [
          Text(
            hashtag.hashtag,
            textAlign: TextAlign.center,
            style: style2,
          ),
          Text(
            hashtag.hashtag,
            style: style,
          ),
        ],
      )
    );
  }
}