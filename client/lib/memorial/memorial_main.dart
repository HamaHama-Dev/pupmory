import 'dart:convert';
import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/conversation/intro/intro_memorial.dart';
import 'package:client/memorial/modify_profile.dart';
import 'package:client/memorial/write_memorial.dart';
import 'package:client/style.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'memorial_detail.dart';
import 'watch_others.dart';
import 'write_memorial.dart';
import 'package:client/sign/sign_in.dart' as sign_in;

class MemorialMainPage extends StatefulWidget {
  @override
  State<MemorialMainPage> createState() => _MemorialMainPageState();
}

String selectedImage = "";
int postId = 0;
bool inUser = false;
String _dataFromPage = '';

class _MemorialMainPageState extends State<MemorialMainPage> {

  // 화면에 보이는 UI 설정 bool
  bool fetchDataSuccess = false;
  bool askHelp = true;
  bool sendHelp = false;

  bool checkCN = false;

  List<String> con0Text =[];

  late Map<String, dynamic> parsedResponseCN; // 글 내용

  late List<dynamic> postsList; // 포스트 하나 내용

  void fetchWithHeaders(String aToken) async {

    // API 엔드포인트 URL
    String apiUrl = 'http://3.38.1.125:8080/memorial/all'; // 실제 API 엔드포인트로 변경하세요

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

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    fetchWithHeaders(sign_in.userAccessToken);

    Timer(Duration(milliseconds: 500), () {
      fetchWithHeaders(sign_in.userAccessToken);
    });
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
    return Scaffold(
      appBar: AppBar(
        title:
        Container(
          width: screenSize.width,
          height: 46,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18,),
              SvgPicture.asset(
                'assets/images/logo/pup_logo.svg',
                height: 25.41,
                width: 110.19,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        // SvgPicture.asset(
        //   'assets/images/home/home_main_logo.svg',
        // ),
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 15),
          child: Padding(
            padding: EdgeInsets.only(top:16),
            child: Row(
              children: [
                Stack(
                  children: [
                    Text("${postsList.length.toInt()}개의 기억",style: TextStyle(
                      fontFamily: 'Bameuihaebyun',
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.white,
                      fontSize: 14,
                    ),),
                    Text("${postsList.length.toInt()}개의 기억",style: TextStyle(
                      fontFamily: 'Bameuihaebyun',
                      color: Color(0xff4B5396),
                      fontSize: 14,
                    ),),
                  ],
                ),
                SizedBox(width: 8,),
                SvgPicture.asset(
                  'assets/images/memorial/cloud.svg',
                ),
              ],
            ),
          )
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffDDE7FD),
        elevation: 0.0,
      ),
      body: Container(
        color: Color(0xffDDE7FD),
        // width: Get.width,
        // height: Get.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if(checkCN)...[
                SizedBox(height: 16,),
                Row(
                  children: [
                    SizedBox(width: 16,),
                    Stack(
                      children: [
                        if(parsedResponseCN['profileImage'].toString() == "null")...[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 59.5,
                            // minRadius: 50,
                            // maxRadius: 55,
                            //backgroundImage: NetworkImage(parsedResponseCN['profileImage']),
                            child: CircleAvatar(
                              child: SvgPicture.asset('assets/images/user_null2.svg',
                                width: 110,
                                height: 110,
                                fit: BoxFit.fill,),
                              radius: 54.5,
                            ),
                          ),
                        ]else...[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 59.5,
                            // minRadius: 50,
                            // maxRadius: 55,
                            //backgroundImage: NetworkImage(parsedResponseCN['profileImage']),
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
                                  fontWeight: FontWeight.w600, fontSize: 20),),
                              Text("님의 반려견", style: TextStyle(fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500, fontSize: 16),),
                            ],
                          ),
                          SizedBox(height: 4,),
                          Row(
                            children: [
                              Text("${parsedResponseCN['puppyName']}", style: TextStyle(fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600, fontSize: 20),),
                              Text("(${parsedResponseCN['puppyType']}, ${parsedResponseCN['puppyAge']}살)", style: TextStyle(fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500, fontSize: 16),),
                            ],
                          ),
                        ],
                      ),),

                  ],
                ),
                SizedBox(height: 14,),
                Row(
                  children: [
                    SizedBox(width: 16,),
                    Container(
                      width: 115,
                      height: 40,
                      child: ElevatedButton(
                        style: buttonChart().whitebtn2,
                        child: Text('프로필 수정', style: TextStyle(fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500, fontSize: 16),),
                        onPressed: (){
                          final result = Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ModifyProfilePage()),
                          );
                          // pop()으로 돌아온 결과를 사용하여 setState 호출
                          if (result != null) {
                            setState(() {
                              //_dataFromPage = result as String;

                              Timer(Duration(milliseconds: 800), () {
                                fetchWithHeaders(sign_in.userAccessToken);
                              });
                              // fetchWithHeaders(sign_in.userAccessToken);
                              print("성공");
                            });
                          }
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ModifyProfilePage()));
                        },
                      ),
                    ),
                    SizedBox(width: 8,),
                    Container(
                      width: 230,
                      height: 40,
                      child: ElevatedButton(
                        style: buttonChart().purplebtn,
                        child: Row(children: [
                          SizedBox(width: 52,),
                          Text('기억 남기기', style: TextStyle(fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xffF2F6FF)),),
                          SizedBox(width: 5,),
                          SvgPicture.asset(
                            'assets/images/memorial/upload_icon2.svg',
                          ),
                        ],),
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WriteMemorialPage()));
                        },
                      ),
                    ),
                  ],),
                SizedBox(height: 24,),
                Container(
                  color: Color(0xffF2F4F6),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  width: Get.width,
                  //height: 650,
                  child: Column(
                    children: [
                      SizedBox(height: 24,),
                      // Expanded(child: child),
                      Container(
                          width: Get.width,
                        //height: 318,
                          height: (postsList.length<7) ? 302 : calculateGridViewHeight() + 48,
                          color: Color(0xffF2F4F6),
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
                                  Container(
                                      width: 114,
                                      height: 114,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              selectedImage = postsList[index]['image'];
                                              postId = postsList[index]['id'];
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MemorialDetailPage()));
                                            },
                                            child: Container(
                                              width: 114,
                                              height: 114,
                                              child:
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child:  Image(
                                                  image: NetworkImage(postsList[index]['image'], ),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    // 오류 발생 시 대체 이미지를 표시
                                                    return SvgPicture.asset(
                                                      'assets/images/no_result.svg',);
                                                  },
                                                )
                                                //Image.network(postsList[index]['image'], fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          if(postsList[index]['private'] == true)...[
                                            Row(children: [
                                              SizedBox(width: 80,),
                                              Padding(padding: EdgeInsets.only(top:10),
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/private.svg',
                                                ),
                                              ),
                                            ],)

                                          ],
                                        ],
                                      )
                                  );

                              }),
                      ),
                      //SizedBox(height: 8,),
                      InkWell(
                        onTap: (){
                          inUser = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WatchOthersPage()));
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(24, 24, 0, 0),
                          width: Get.width,
                          height: 89,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Container(
                                  //   width: 41,
                                  //   height: 41,
                                  //   child: SvgPicture.asset(
                                  //     'assets/images/memorial/more_memorial.svg',
                                  //   ),
                                  // ),

                                  SvgPicture.asset(
                                    'assets/images/memorial/more_memorial.svg',
                                    width: 41,
                                    height: 41,
                                    fit: BoxFit.fill,
                                  ),

                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("다른 반려인들의 메모리얼을 구경해보세요!",style: TextStyle(color: Color(0xff4B5396), fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400, fontSize: 12, letterSpacing: 0.5),),
                                      SizedBox(height:6,),
                                      Text("메모리얼 구경하러 가기",style: TextStyle(color: Color(0xff4B5396),fontSize: 16, fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,),)

                                    ],
                                  ),
                                  SizedBox(width:15,),
                                  // assets/images/home/arrow.svg
                                  SvgPicture.asset(
                                    'assets/images/home/arrow.svg',
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12,),
                    ],
                  ),

                ),
              ],
            ],
          ),
        ),
      ),
      // floatingActionButton: SizedBox(
      //   height: 56,
      //   width: extended ? 120 : 56,
      //   child: extendButton(),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

  }
}