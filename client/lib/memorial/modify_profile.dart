import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/memorial/memorial_main.dart';
import 'package:client/screen.dart';
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
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

/// 프로필 수정
class ModifyProfilePage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => ModifyProfilePage(),
      ),
    );
  }

  @override
  _ModifyProfilePageState createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {

  Future<XFile?> urlToXFile(String imageUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        ui.Image image = await decodeImageFromList(bytes);

        // Use getTemporaryDirectory() from path_provider to get the temporary directory
        final tempDir = await getTemporaryDirectory();

        // Save the Image to a file in the temporary directory
        final file = File('${tempDir.path}/temp_image.jpg');
        await file.writeAsBytes(bytes);

        return XFile(file.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  bool takeUser = false; // 유저정보를 가져왔는지 확인

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final userNameController = TextEditingController(); // 사용자 닉네임
  final dogNameController = TextEditingController(); // 반려견 이름
  final dogAgeController = TextEditingController(); // 반려견 나이
  final dogTypeController = TextEditingController(); // 반려견 종

  // 수정 버튼을 눌렀는지?
  bool modiUserName = false;
  bool modiDogName = false;
  bool modiDogAge = false;
  bool modiDogType = false;

  bool modiImage = false;

  // 수정 possible?
  bool possUserName = false;
  bool possDogName = false;
  bool possDogAge = false;
  bool possDogType = false;
  bool userwriteType = false;

  String setedDogType = "";
  String setedUserName = "";
  String setedDogName = "";
  int setedDogAge = 0;
  String setedDogImage = "";


  String newDogType = "";
  String newUserName = "";
  String newDogName = "";
  int newDogAge = 0;
  String newDogImage = "";



  List<String> dogType_ = [
    "비숑 프리제", "포메라니안", "프렌치 불독","치와와", "몰티즈","토이 푸들","라브라도 리트리버","진돗개","이탈리안 그레이하운드","웰시코기","불독","셔틀랜드 쉽독",
    "시바견", "골든 리트리버", "로트와일러", "케인 코르소", "퍼그", "베들링턴 테리어", "저먼 셰퍼드", "미니어처 닥스훈트", "차우차우", "도베르만", "아메리칸 코카 스파니엘", "카바리에 킹 찰스 스파니엘",
    "페키니즈", "코카시안 오브차카", "스탠다드 푸들","요크셔 테리어", "사모예드", "센트럴 아시안 오브차카", "시베리안 허스키", "휘핏", "아메리칸 아키타", "빠비용", "보더콜리", "꼬동 드 툴레아",
    "미니어처 볼 테리어", "미니어처 슈나우저", "아프간 하운드","도고아르헨티노", "티베탄 마스티프","벨지안 셰퍼드","잭 러쎌 테리어","미니어처 푸들","미디엄 푸들","시츄","래빗 닥스훈트","비글", "찾는 종이 없다면 직접 입력해보세요!"
  ];

  bool isPicSelected = false; // 사진이 들어가는지 확인하는 코드 -> UI 바뀜
  // final ImagePicker _picker = ImagePicker();
  // final List<XFile> _pickedImages = [];

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        modiImage= true;
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
        //changeUserImage(sign_in.userAccessToken, _image as List<XFile>);
      });
    }
  }

  late Map<String, dynamic> parsedResponseUser; // 사용자 정보

  // 사용자 정보 조회
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
      print('서버로부터 받은 내용 데이터(사용자 정보-프로필): ${response.body}');
      var jsonResponse = utf8.decode(response.bodyBytes);

      parsedResponseUser = json.decode(jsonResponse);
      takeUser = true;

      setedUserName = parsedResponseUser['nickname'];
      setedDogName = parsedResponseUser['puppyName'];
      setedDogAge = parsedResponseUser['puppyAge'];
      setedDogType = parsedResponseUser['puppyType'];
      //setedDogImage = parsedResponseUser['profileImage'];

      setState(() {

      });

    } else {
      // 요청이 실패한 경우 오류 처리
      print('HTTP 요청 실패: ${response.statusCode}');
    }
  }


  // 사용자 정보 변경
  void changeUserName(String aToken, String nickname) async {

    try {
      var dio = Dio(); // Dio 인스턴스 생성

      // JSON 데이터 추가
      final jsonData = {
        "nickname": nickname,
        "puppyName": setedDogName,
        "puppyAge": setedDogAge,
        "puppyType": setedDogType,
        //"profileImage" : setedDogImage,
      };

      // JSON 데이터를 문자열로 인코딩
      final jsonString = jsonEncode(jsonData);

      // final List<MultipartFile> _files2 = images
      //     .map((img) => MultipartFile.fromFileSync(img.path,
      //     contentType: MediaType("image", "jpeg")))
      //     .toList();

      //final List<MultipartFile> _files = images.map((img) => MultipartFile.fromFileSync(img!.path,  contentType: new MediaType("image", "jpg"))).toList();

      //print('Content-Type: ${_files.contentType}');


      final data = FormData.fromMap({
        "image": "",
        "json": await MultipartFile.fromString(
          jsonString,
          contentType: MediaType.parse('application/json'),
        ),
      },
      );


      //dio.options.contentType = 'multipart/form-data';

      // http://3.38.1.125:8080/memorial
      // POST 요청 보내기
      var response = await dio.post(
        'http://3.38.1.125:8080/user/info', // 서버 엔드포인트 경로 설정
        data: data,
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'multipart/form-data', // Content-Type 설정
            'Authorization': 'Bearer $aToken',
          },
          //responseType: ResponseType.plain
        ),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        print('이미지 업로드 성공');
        // 응답 데이터 읽기
        final responseJson = json.decode(response.data);
        print('서버 응답 데이터: $responseJson');
      } else {
        print('이미지 업로드 실패. HTTP 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('서버 응답 에러 데이터: ${e.response?.data}');
        } else {
          print('Dio 에러: ${e.message}');
        }
      } else {
        print('에러 발생: $e');
      }
    }
  }

  // 반려견 이름 변경
  void changePuppyName(String aToken, String puppyName) async {
    try {
      var dio = Dio(); // Dio 인스턴스 생성

      // JSON 데이터 추가
      final jsonData = {
        "nickname" : setedUserName,
        "puppyName" : puppyName,
        "puppyAge" : setedDogAge,
        "puppyType" : setedDogType,
        //"profileImage" : setedDogImage,
      };

      // JSON 데이터를 문자열로 인코딩
      final jsonString = jsonEncode(jsonData);

      // final List<MultipartFile> _files2 = images
      //     .map((img) => MultipartFile.fromFileSync(img.path,
      //     contentType: MediaType("image", "jpeg")))
      //     .toList();

      //final List<MultipartFile> _files = images.map((img) => MultipartFile.fromFileSync(img!.path,  contentType: new MediaType("image", "jpg"))).toList();

      //print('Content-Type: ${_files.contentType}');


      final data = FormData.fromMap({
        "image": "",
        "json": await MultipartFile.fromString(
          jsonString,
          contentType: MediaType.parse('application/json'),
        ),
      },
      );


      //dio.options.contentType = 'multipart/form-data';

      // http://3.38.1.125:8080/memorial
      // POST 요청 보내기
      var response = await dio.post(
        'http://3.38.1.125:8080/user/info', // 서버 엔드포인트 경로 설정
        data: data,
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'multipart/form-data', // Content-Type 설정
            'Authorization': 'Bearer $aToken',
          },
          //responseType: ResponseType.plain
        ),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        print('이미지 업로드 성공');
        // 응답 데이터 읽기
        final responseJson = json.decode(response.data);
        print('서버 응답 데이터: $responseJson');
      } else {
        print('이미지 업로드 실패. HTTP 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('서버 응답 에러 데이터: ${e.response?.data}');
        } else {
          print('Dio 에러: ${e.message}');
        }
      } else {
        print('에러 발생: $e');
      }
    }
  }

  // 반려견 나이 변경
  void changePuppyAgeInfo(String aToken, int puppyAge) async {
    try {
      var dio = Dio(); // Dio 인스턴스 생성

      // JSON 데이터 추가
      final jsonData = {
        "nickname" : setedUserName,
        "puppyName" : setedDogName,
        "puppyAge" : puppyAge,
        "puppyType" : setedDogType,
        //"profileImage" : setedDogImage,
      };

      // JSON 데이터를 문자열로 인코딩
      final jsonString = jsonEncode(jsonData);

      // final List<MultipartFile> _files2 = images
      //     .map((img) => MultipartFile.fromFileSync(img.path,
      //     contentType: MediaType("image", "jpeg")))
      //     .toList();

      //final List<MultipartFile> _files = images.map((img) => MultipartFile.fromFileSync(img!.path,  contentType: new MediaType("image", "jpg"))).toList();

      //print('Content-Type: ${_files.contentType}');


      final data = FormData.fromMap({
        "image": "",
        "json": await MultipartFile.fromString(
          jsonString,
          contentType: MediaType.parse('application/json'),
        ),
      },
      );


      //dio.options.contentType = 'multipart/form-data';

      // http://3.38.1.125:8080/memorial
      // POST 요청 보내기
      var response = await dio.post(
        'http://3.38.1.125:8080/user/info', // 서버 엔드포인트 경로 설정
        data: data,
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'multipart/form-data', // Content-Type 설정
            'Authorization': 'Bearer $aToken',
          },
          //responseType: ResponseType.plain
        ),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        print('이미지 업로드 성공');
        // 응답 데이터 읽기
        final responseJson = json.decode(response.data);
        print('서버 응답 데이터: $responseJson');
      } else {
        print('이미지 업로드 실패. HTTP 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('서버 응답 에러 데이터: ${e.response?.data}');
        } else {
          print('Dio 에러: ${e.message}');
        }
      } else {
        print('에러 발생: $e');
      }
    }
  }

  // 반려견 종 변경
  void changePuppyTypeInfo(String aToken, String puppyType) async {
    try {
      var dio = Dio(); // Dio 인스턴스 생성

      // JSON 데이터 추가
      final jsonData = {
        "nickname" : setedUserName,
        "puppyName" : setedDogName,
        "puppyAge" : setedDogAge,
        "puppyType" : puppyType,
      };

      // JSON 데이터를 문자열로 인코딩
      final jsonString = jsonEncode(jsonData);

      // final List<MultipartFile> _files2 = images
      //     .map((img) => MultipartFile.fromFileSync(img.path,
      //     contentType: MediaType("image", "jpeg")))
      //     .toList();

      //final List<MultipartFile> _files = images.map((img) => MultipartFile.fromFileSync(img!.path,  contentType: new MediaType("image", "jpg"))).toList();

      //print('Content-Type: ${_files.contentType}');


      final data = FormData.fromMap({
        "image": "",
        "json": await MultipartFile.fromString(
          jsonString,
          contentType: MediaType.parse('application/json'),
        ),
      },
      );


      //dio.options.contentType = 'multipart/form-data';

      // http://3.38.1.125:8080/memorial
      // POST 요청 보내기
      var response = await dio.post(
        'http://3.38.1.125:8080/user/info', // 서버 엔드포인트 경로 설정
        data: data,
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'multipart/form-data', // Content-Type 설정
            'Authorization': 'Bearer $aToken',
          },
          //responseType: ResponseType.plain
        ),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        print('이미지 업로드 성공');
        // 응답 데이터 읽기
        final responseJson = json.decode(response.data);
        print('서버 응답 데이터: $responseJson');
      } else {
        print('이미지 업로드 실패. HTTP 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('서버 응답 에러 데이터: ${e.response?.data}');
        } else {
          print('Dio 에러: ${e.message}');
        }
      } else {
        print('에러 발생: $e');
      }
    }
  }

  // 프로필 사진 변경
  void changeUserImage(String aToken, XFile images) async {
    // 요청 본문 데이터
    try {
      var dio = Dio(); // Dio 인스턴스 생성
      // XFile에서 필요한 정보 추출
      List<int> imageBytes = await images.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // JSON 데이터 추가
      final jsonData = {
        "nickname" : setedUserName,
        "puppyName" : setedDogName,
        "puppyAge" : setedDogAge,
        "puppyType" : setedDogType,
      };

      // JSON 데이터를 문자열로 인코딩
      final jsonString = jsonEncode(jsonData);

      final data = FormData.fromMap({
        "image": MultipartFile.fromFileSync(
          images.path,
          contentType: MediaType("image", "jpeg"),
        ),
        "json": await MultipartFile.fromString(
          jsonString,
          contentType: MediaType.parse('application/json'),
        ),
      },
      );


      //dio.options.contentType = 'multipart/form-data';

      // http://3.38.1.125:8080/memorial
      // POST 요청 보내기
      var response = await dio.post(
        'http://3.38.1.125:8080/user/info', // 서버 엔드포인트 경로 설정
        data: data,
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'multipart/form-data', // Content-Type 설정
            'Authorization': 'Bearer $aToken',
          },
          //responseType: ResponseType.plain
        ),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        print('이미지 업로드 성공');
        // 응답 데이터 읽기
        final responseJson = json.decode(response.data);
        print('서버 응답 데이터: $responseJson');
      } else {
        print('이미지 업로드 실패. HTTP 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('서버 응답 에러 데이터: ${e.response?.data}');
        } else {
          print('Dio 에러: ${e.message}');
        }
      } else {
        print('에러 발생: $e');
      }
    }
  }

  // 수정 중 나갈 시 팝업
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
                        Text("수정 내용을 삭제 하시겠어요?",style: textStyle.bk16bold,),
                        SizedBox(height: 8,),
                        Text("지금 돌아가면 수정 내용이 삭제돼요!", style: textStyle.bk14normal,),
                        SizedBox(height: 32,),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 120,
                              child: ElevatedButton(
                                child: new Text("수정 계속", style: textStyle.purple16midium),
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
                                child: new Text("수정 취소", style: textStyle.white16semibold),
                                style: buttonChart().purplebtn,
                                onPressed: () {
                                  // 함께할개 화면으로 돌아가기
                                  Navigator.pop(context);
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


  bool ch = false;

  @override
  void initState() {
    super.initState();
    fetchUserInfo(sign_in.userAccessToken); // 사용자 정보 가져오기
  }

  @override
  void dispose() async {
    super.dispose();
  }

  double calculateListViewHeight() {
    // 리스트뷰의 아이템 수
    int itemCount = dogType_.length;

    // 리스트뷰의 열 수 (3개의 아이템이 한 행에 있을 때)
    int columnCount = 1;

    // 아이템의 높이 (가로:세로 비율을 설정할 수 있음)
    double itemHeight = 38; // 이 값은 적절히 조정

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

    // 강아지 종류 위젯
    Widget listview_builder(){
      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: dogType_.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              padding: EdgeInsets.all(8),
              height: 45,
              child: InkWell(
                child: Row(
                  children: [
                    SizedBox(width: 8,),
                    SvgPicture.asset(
                      'assets/images/memorial/paw.svg',
                    ),
                    SizedBox(width: 16,),
                    Text(dogType_[index]),
                  ],
                ),
                onTap: (){
                  print("test");
                  if(index == 48){
                    userwriteType = true;
                  }else{
                    setedDogType = dogType_[index];
                    newDogType = dogType_[index];
                    possDogType = true;
                  }

                  setState(() {});
                },
              ),
            );

          }
      );
    }
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
                            '프로필 수정',
                            style: textStyle.bk20normal,
                          ),
                        )),
                  ],
                )),

            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            leading:
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                onPressed: () {
                  if(modiDogAge || modiDogName || modiDogType || modiUserName || modiImage ||
                  possDogAge || possDogName || possDogType || possUserName){
                    FlutterDialog();
                  }else{
                    Navigator.pop(context, 'Data from Second Page');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyScreenPage(title: '홈페이지 이동')));
                  }

                },
              ),
            ),
          ),
        ),
        //extendBodyBehindAppBar: true,
          body: Container(
            // width: screenSize.width,
            // height: screenSize.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              scrollDirection: Axis.vertical,
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if(takeUser)...[
                    if(modiImage|| ch)...[
                      // Image.file(File(_image!.path)),
                      Container(
                        height: 104,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child:
                        CircleAvatar(
                          radius: 104,
                          backgroundImage: Image.file(
                            File(_image!.path),
                            fit: BoxFit.fill,
                          ).image,
                        )
                      ),

                    ]else...[
                      if(parsedResponseUser['profileImage'].toString() == "null")...[
                        CircleAvatar(
                          child: SvgPicture.asset('assets/images/user_null2.svg',),
                          radius: 52,
                        ),
                      ]else...[
                        CircleAvatar(
                          radius: 52,
                          // https://postfiles.pstatic.net/MjAyMzExMTJfMjEg/MDAxNjk5Nzc3NzE5NjIy.cSRDBIZh3A6YNZ_o2sk1PoXzLYppEITLa9k-TSb3t1Ug.9_txCKXoYkH4_TuOKIQbEShHgBz7DDKkfB0becw6lIUg.JPEG.hongyejin4/Group_1078.jpg?type=w966
                          backgroundImage: NetworkImage(parsedResponseUser['profileImage'].toString()),
                        ),
                      ]
                    ],
                    SizedBox(height: 32,),
                    if(modiImage == false || ch) ...[
                      Container(
                        height: 40,
                        width: 115,
                        child: ElevatedButton(
                            onPressed: (){
                              getImage(ImageSource.gallery);
                              modiImage = true;
                              setState(() {
                              });
                            },
                            style: buttonChart().whitebtn2,
                            child: Text("사진 수정", style: textStyle.bk16normal,)
                        ),),
                    ] else...[
                      Container(
                        height: 40,
                        width: 125,
                        child: ElevatedButton(
                            onPressed: (){
                              changeUserImage(sign_in.userAccessToken, _image!);
                              modiImage = false;
                              ch = true;
                              //modiImage = true;
                              setState(() {
                              });
                            },
                            style: buttonChart().whitebtn2,
                            child: Text("사진 수정 완료", style: textStyle.bk16normal,)
                        ),),
                    ],


                    SizedBox(height: 32,),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(padding: EdgeInsets.only(top:10,left: 20, right:20),
                              child: Text("닉네임", style: textStyle.bk14normal,),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top:8, left: 20, right:20, bottom: 8),
                            child:
                            Row(children: [
                              Container(
                                width: 220,
                                child: modiUserName?
                                Container(
                                  height: 25,
                                child: TextField(
                                  controller: userNameController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom:13, left: 0),
                                      hintStyle: textStyle.grey16normal,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: '이름을 입력하세요.'),
                                  onChanged: (text){
                                    if(text != setedUserName){
                                      possUserName = true;
                                      setState(() {});
                                    } else{
                                      possUserName = false;
                                      setState(() {});
                                    }
                                  },
                                  onTap: (){
                                    if(userNameController.text != setedUserName){
                                      print(userNameController.text);
                                      possUserName = true;
                                      setState(() {});
                                    } else{
                                      possUserName = false;
                                      setState(() {});
                                    }
                                  },
                                ),)
                                    : Text( setedUserName, style: textStyle.bk16normal,),
                              ),
                              if(possUserName == false)...[
                                if(modiUserName == false)...[
                                  SizedBox(width: 27,),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiUserName = true;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().pinkbtn2,
                                        child: Text("수정", style: textStyle.white16midium,)
                                    ),)
                                ]else...[
                                  SizedBox(width: 27,),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiUserName = false;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().bluebtn,
                                        child: Text("취소", style: textStyle.white16midium,)
                                    ),)
                                ]

                              ]else...[
                                Container(
                                  height: 24,
                                  width: 92,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        //changeUserInfo(sign_in.userAccessToken,"nickname", userNameController.text.toString());
                                        newUserName = userNameController.text;
                                        changeUserName(sign_in.userAccessToken, newUserName);
                                        setedUserName = newUserName;
                                        possUserName = false;
                                        modiUserName = false;
                                        setState(() {
                                        });
                                      },
                                      style: buttonChart().bluebtn3,
                                      child: Text("수정 완료", style: textStyle.white16midium,)
                                  ),)
                              ]


                            ],),
                          ),
                          SizedBox(height: 6,),
                        ],
                      ),
                    ),

                    SizedBox(height: 8,),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(padding: EdgeInsets.only(top:10,left: 20, right:20),
                              child: Text("반려견 이름", style: textStyle.bk14normal,),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top:8, left: 20, right:20, bottom: 8),
                            child:
                            Row(children: [
                              Container(
                                width: 220,
                                child: modiDogName?
                                Container(height: 25,
                                child: TextField(
                                  controller: dogNameController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom:13, left: 0),
                                      hintStyle: textStyle.grey16normal,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: '반려견 이름을 입력하세요.'),
                                  onChanged: (text){
                                    if(text != setedDogName){
                                      possDogName = true;
                                      setState(() {});
                                    } else{
                                      possDogName = false;
                                      setState(() {});
                                    }
                                  },
                                  onTap: (){
                                    if(dogNameController.text != setedDogName){
                                      print(dogNameController.text);
                                      possDogName = true;
                                      setState(() {});
                                    } else{
                                      possDogName = false;
                                      setState(() {});
                                    }
                                  },
                                ),)
                                    : Text( setedDogName, style: textStyle.bk16normal,),
                              ),
                              if(possDogName == false)...[
                                if(modiDogName == false)...[
                                  SizedBox(width: 27,),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiDogName = true;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().pinkbtn2,
                                        child: Text("수정", style: textStyle.white16midium,)
                                    ),)
                                ]else...[
                                  SizedBox(width: 27,),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiDogName = false;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().bluebtn,
                                        child: Text("취소", style: textStyle.white16midium,)
                                    ),)
                                ]

                              ]else...[
                                Container(
                                  height: 24,
                                  width: 92,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        //modiUserName = true;
                                        newDogName = dogNameController.text;
                                        changePuppyName(sign_in.userAccessToken, newDogName);
                                        setedDogName = newDogName;
                                        possDogName = false;
                                        modiDogName = false;
                                        //changeUserInfo(sign_in.userAccessToken,"puppynName", dogNameController.text.toString());
                                        setState(() {
                                        });
                                      },
                                      style: buttonChart().bluebtn3,
                                      child: Text("수정 완료", style: textStyle.white16midium,)
                                  ),)
                              ]
                            ],),
                          ),
                          SizedBox(height: 6,),
                        ],
                      ),
                    ),

                    SizedBox(height: 8,),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(padding: EdgeInsets.only(top:10,left: 20, right:20),
                              child: Text("반려견 나이", style: textStyle.bk14normal,),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top:8, left: 20, right:20, bottom: 8),
                            child:
                            Row(children: [
                              Container(
                                width: 220,
                                child: modiDogAge?
                                Container(
                                  height: 25,
                                  child: TextField(
                                    controller: dogAgeController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(bottom:13, left: 0),
                                        hintStyle: textStyle.grey16normal,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: '나이를 입력하세요.'),
                                    onChanged: (text){
                                      if(text != setedDogAge.toString()){
                                        possDogAge = true;
                                        setState(() {});
                                      } else{
                                        possDogAge = false;
                                        setState(() {});
                                      }
                                    },
                                    onTap: (){
                                      if(dogAgeController.text != setedDogAge.toString()){
                                        print(dogAgeController.text);
                                        possDogAge = true;
                                        setState(() {});
                                      } else{
                                        possDogAge = false;
                                        setState(() {});
                                      }
                                    },
                                  ),

                                )
                                    : Text( "${setedDogAge}살", style: textStyle.bk16normal,),
                              ),
                              if(possDogAge == false)...[
                                if(modiDogAge == false)...[
                                  SizedBox(width: 27,),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiDogAge = true;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().pinkbtn2,
                                        child: Text("수정", style: textStyle.white16midium,)
                                    ),)
                                ]else...[
                                  SizedBox(width: 27,),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiDogAge = false;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().bluebtn,
                                        child: Text("취소", style: textStyle.white16midium,)
                                    ),)
                                ]

                              ]else...[
                                Container(
                                  height: 24,
                                  width: 92,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        //modiUserName = true;
                                        // 나이는 int로 변경. 다시 작성
                                        newDogAge = int.parse(dogAgeController.text);
                                        setedDogAge = newDogAge;
                                        changePuppyAgeInfo(sign_in.userAccessToken, newDogAge);
                                        possDogAge = false;
                                        modiDogAge = false;
                                        //changePuppyAgeInfo(sign_in.userAccessToken, int.parse(dogAgeController.text));
                                        setState(() {
                                        });
                                      },
                                      style: buttonChart().bluebtn3,
                                      child: Text("수정 완료", style: textStyle.white16midium,)
                                  ),)
                              ]

                            ],),
                          ),
                          SizedBox(height: 6,),
                        ],
                      ),
                    ),

                    SizedBox(height: 8,),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(padding: EdgeInsets.only(top:10,left: 20, right:20),
                              child: Text("반려견 종", style: textStyle.bk14normal,),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top:8, left: 20, right:20, bottom: 8),
                            child:
                            Row(children: [
                              Container(
                                width: 220,
                                child: modiDogType?
                                    Column(
                                      children: [
                                        if(userwriteType)...[
                                          Container(
                                            height: 25,
                                            child: TextField(
                                              controller: dogTypeController,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(bottom:13, left: 0),
                                                  hintStyle: textStyle.grey16normal,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  hintText: '종을 입력하세요.'),
                                              onChanged: (text){
                                                if(text != setedDogType){
                                                  possDogType = true;
                                                  setState(() {});
                                                } else{
                                                  possDogType = false;
                                                  setState(() {});
                                                }
                                              },
                                              onTap: (){
                                                if(dogTypeController.text != setedDogType){
                                                  print(dogTypeController.text);
                                                  possDogType = true;
                                                  setState(() {});
                                                } else{
                                                  possDogType = false;
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          )
                                        ]
                                        else...[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${setedDogType}", style: textStyle.bk16normal,)
                                            ],
                                          )
                                        ]
                                      ],
                                    )
                                    : Text( setedDogType, style: textStyle.bk16normal,),
                              ),
                              if(possDogType == false)...[
                                if(modiDogType == false)...[
                                  SizedBox(width: 27,),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiDogType = true;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().pinkbtn2,
                                        child: Text("검색", style: textStyle.white16midium,)
                                    ),)
                                ]else...[
                                  SizedBox(width: 27,),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiDogType = false;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().bluebtn,
                                        child: Text("취소", style: textStyle.white16midium,)
                                    ),)
                                ]
                              ]else...[
                                Container(
                                  height: 24,
                                  width: 92,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        //modiUserName = true;
                                        modiDogType = false;
                                        possDogType = false;
                                        if(userwriteType){
                                          newDogType = dogTypeController.text;
                                          setedDogType = newDogType;
                                        }
                                        setedDogType = newDogType;
                                        changePuppyTypeInfo(sign_in.userAccessToken, newDogType);

                                        //changeUserInfo(sign_in.userAccessToken,"puppyType", dogTypeController.text.toString());
                                        setState(() {
                                        });
                                      },
                                      style: buttonChart().bluebtn3,
                                      child: Text("수정 완료", style: textStyle.white16midium,)
                                  ),)
                              ]

                            ],),
                          ),
                          SizedBox(height: 6,),
                        ],
                      ),
                    ),
                    SizedBox(height: 8,),
                    if(modiDogType)...[
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        width: screenSize.width,
                      height: calculateListViewHeight(),
                      child: Column(
                        children: [
                          Expanded(
                              child: Column(
                                children: [
                                  listview_builder()
                                ],
                          ))
                        ],
                      )
                      )

                    ]
                  ]

                ],
              ),
            ),
          )

      );

  }
}
