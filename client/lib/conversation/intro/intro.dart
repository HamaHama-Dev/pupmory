import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:client/progressbar/animation_progressbar.dart';
import 'package:client/style.dart';
import 'intro_memorial.dart';
import 'package:client/main.dart'as main;
import 'package:client/sign/sign_in.dart' as sign_in;
import 'package:just_audio/just_audio.dart';
import 'package:flutter_gif/flutter_gif.dart';

/// 인트로
String userName_ = "";
String dogName_ ="";

class IntroPage extends StatefulWidget {

  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => IntroPage(),
      ),
    );
  }

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {

  late FlutterGifController controller1, controller2, controller3;

  bool startIntro = false;
  bool setUserName = false;
  bool setDogName = false;
  bool setDogAge = false;
  bool setDogType = false;

  bool isVisible = false;
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  bool dogTypeinput = false; // 강아지종을 사용자가 직접 입력하는가

  String userDogType = "";

  bool decidedAge = false;
  bool selectAT = false; // 오류 막기
  bool chooseType = false; // 견종을 선택하는 창이 뜨도록
  bool decidedType = false; // 견종을 선택하였다면 다음 페이지로 넘어갈 수 있도록 함

  bool grief = false; // 슬픔 선택 시
  bool ui_grief = false;
  bool miss = false; // 그리움 선택 시
  bool ui_miss = false;

  bool finish = false; // 메모리얼 및 마무리

  // 텍스트 에디팅 컨트롤러를 생성하여 필드에 할당
  final userNameController = TextEditingController(); // nextQuestion = 3일때
  final dogNameController = TextEditingController(); // nextQuestion = 7일때
  final dogAgeController = TextEditingController(); // nextQuestion = 10일때
  final dogTypeController = TextEditingController(); // nextQuestion = 10일때

  String userName = "";
  String dogName = "";
  int dogAge = 0;
  String dogType = "";

  // “비숑 프리제”, “포메라니안”, “프렌치 불독”, “치와와”, “몰티즈”, “토이 푸들”, “라브라도 리트리버”, “진돗개”, “이탈리안 그레이하운드”, “펨브록 웰시 코기”, “불독”, “셔틀랜드 쉽독”,
  // “시바견”, “골든 리트리버”, “로트와일러”, “케인 코르소”, “퍼그”, “베들링턴 테리어”, “저먼 셰퍼드”, “미니어처 닥스훈트”, “차우차우”, “도베르만”, “아메리칸 코카 스파니엘”, “카바리에 킹 찰스 스파니엘“,
  // “페키니즈“, “코카시안 오브차카“, “스탠다드 푸들“,  “요크셔 테리어“, “사모예드“, “센트럴 아시안 오브차카“, “시베리안 허스키“, “휘핏“, “아메리칸 아키타“, “빠비용“, “보더콜리“, “꼬동 드 툴레아“,
  // “미니어처 볼 테리어“, “미니어처 슈나우저“, “아프간 하운드“, “도고아르헨티노“, “티베탄 마스티프“, “벨지안 셰퍼드“, “잭 러쎌 테리어“, “미니어처 푸들“, “미디엄 푸들“, “시츄”, “래빗 닥스훈트”, “비글”, “기타(사용자 직접 입력)”

  List<String> dogType_ = [
    "비숑 프리제", "포메라니안", "프렌치 불독","치와와", "몰티즈","토이 푸들","라브라도 리트리버","진돗개","이탈리안 그레이하운드","웰시코기","불독","셔틀랜드 쉽독",
    "시바견", "골든 리트리버", "로트와일러", "케인 코르소", "퍼그", "베들링턴 테리어", "저먼 셰퍼드", "미니어처 닥스훈트", "차우차우", "도베르만", "아메리칸 코카 스파니엘", "카바리에 킹찰스 스파니엘",
    "페키니즈", "코카시안 오브차카", "스탠다드 푸들","요크셔 테리어", "사모예드", "센트럴 아시안 오브차카", "시베리안 허스키", "휘핏", "아메리칸 아키타", "빠비용", "보더콜리", "꼬동 드 툴레아",
    "미니어처 볼 테리어", "미니어처 슈나우저", "아프간 하운드","도고아르헨티노", "티베탄 마스티프","벨지안 셰퍼드","잭 러쎌 테리어","미니어처 푸들","미디엄 푸들","시츄","래빗 닥스훈트","비글", "직접 입력"
  ];

  void showToast(){
    Fluttertoast.showToast(
        msg: '화면을 탭하면 다음으로 넘어가요',
        gravity: ToastGravity.BOTTOM,
        textColor: Color(0xff4B5396),
        backgroundColor: Colors.white.withOpacity(0.5),
        toastLength: Toast.LENGTH_SHORT
    );
  }

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    main.play = true;
    main.player.setAsset(main.musics[0]);
    main.player.play();
    // 음원 적용
    for(int i= 0 ; i < voice.length; i++){
      _player.setAudioSource(AudioSource.uri(
          Uri.parse(voice[i]))
      );
    }

    controller1 = FlutterGifController(vsync: this);
    controller2 = FlutterGifController(vsync: this);
    controller3 = FlutterGifController(vsync: this);

    _focusNode.addListener(_onFocusChange);
    showToast();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // 키보드 올리기
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  int nextPage = 0;

  List<String> introText =[];

  int nextQuestion = 0;
  int nextQuestionGrief = 0;
  int nextQuestionMiss = 0;

  // 인트로 사용자 정보 저장하기 (POST)
  void saveUserInfo(String aToken, String nickname, String puppyName, int puppyAge, String puppyType) async {

    // 요청 본문 데이터
    var data = {
      "nickname": nickname,
      "puppyName": puppyName,
      "puppyAge" : puppyAge,
      "puppyType" : puppyType,
      "profile-image" : "null"
    };

    // 헤더 정보 설정
    Map<String, String> headers = {
      'Authorization': 'Bearer $aToken', // 예: 인증 토큰을 추가하는 방법
      'Content-Type': 'application/json', // 예: JSON 요청인 경우 헤더 설정
    };

    var url = Uri.parse('http://3.38.1.125:8080/conversation/intro/info'); // 엔드포인트 URL 설정

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

  final _player = AudioPlayer();
  int voiceCount = 0;

  List<dynamic> voice =[
    "assets/voice/intro/intro1.mp3", "assets/voice/intro/intro2.mp3", "assets/voice/intro/intro3.mp3",
    "assets/voice/intro/intro4.mp3", "assets/voice/intro/intro5.mp3", "assets/voice/intro/intro6.mp3",
    "assets/voice/intro/intro7.mp3", "assets/voice/intro/intro8.mp3", "assets/voice/intro/intro9.mp3",
    "assets/voice/intro/intro10.mp3", "assets/voice/intro/intro11.mp3", "assets/voice/intro/intro12.mp3",
    "assets/voice/intro/intro13.mp3", "assets/voice/intro/intro14.mp3", "assets/voice/intro/intro15.mp3",
    "assets/voice/intro/intro16.mp3", "assets/voice/intro/intro17.mp3",
  ];

  List<dynamic> questions0 =[
    "나를 가장 잘 아는 친구이자,\n나와 함께 자란 가족같은 반려견.",
    "반려견과의 이별은\n그 무엇보다 큰 슬픔입니다.",
    "모든 반려인에게는 충분하게 \n애도하고 슬퍼할 시간이 필요하답니다.",
    "그러기 위해서 반려견에 대해\n기억하는 것은 매우 중요한 과정이에요.",
    // "이별 도우미 무지와 함께\n반려견을 기억해보세요.",
  ];

  List<dynamic> question1_0= [
  "안녕하세요.", //0
  "저는 반려견과의 이별을 도와줄\n이별 도우미 무지에요!", //1
  "앞으로 저와 대화를 다누면서", //2
  "반려견을 기억하고\n애도할 수 있게 도와드릴게요.", //3
  "저는 당신을 뭐라고 부르면 좋을까요?", //4

    // 통으로 추가
  // "좋아요. 보호자님.", // this is modifi //5
  // "제가 보호자님과의 대화를 시작하기 위해", //6
  // "보호자님에 대해서\n더 알아가려고 해요.", //7
  // "다음 질문에 답해주세요!", // 8
  // "반려견의 이름은 무엇이었을까요?", // this is modifi //9
  //
  //   // 통으로 추가
  //   "아이의 모습은 어땠나요? \n빈칸을 채워 알려주세요.", // this is modifi //10
  // "아이의 모습은 어땠나요? \n빈칸을 채워 알려주세요.", // this is modifi //11
  // "좋아요, 보호자님!", // 12
  // "질문에 답하며,\n잠깐이나마", //13
  // "아이에 대해서 떠올려봤던 것 같아요.", //14
  // "아이에 대해서 생각하니", //15
  // "보호자님은 어떤 마음이 들었나요?", //16
  ];

  // 그리움 아예 통으로 추가하세요
  List<dynamic> questions1_2 =[
    // 이제는 아이의\n모습을 보거나 만질 수 없지만,
    // 아이를 생각하며\n그리움을 채워갈 수 있을 것 같아요.
    // 아이와의 기억을\n처음부터 떠올려볼까요?
    // 아이와의 기억이 시작되는\n그날의 사진과 이야기를 기록해봅시다!
  ];

  // 슬픔 아예 통으로 추가하세요
  List<dynamic> questions1_3 =[
    // "아이가 곁에 없는 지금…",
    // "보호자님의\n슬픈 마음이 제게도 느껴져요.",
    // "ㅁㅁ와의\n기억을 하나씩 되돌아보면",
    // "슬픈 마음을 덜기에 도움이 될거에요.",
    // "아이와의 기억이 시작되는\n그날의 사진과 이야기를 기록해봅시다!",
  ];

  // 아예 통으로 추가하세요
  List<dynamic> questions1_4 =[
    /// 보호자님! \n기억할개가 완성되었어요.
    // 기억할개를 확인해 보세요!
    // 보호자님!
    // 오늘은 보호자님과의 첫만남이었지만,
    // 아이가 얼마나 많은\n사랑을 받았는지 느낄 수 있었어요.
    // 앞으로 저와 함께\n아이와의 순간들을 기억하며,
    // 보호자님의\n마음 속 안정을 찾아가길 바라요.
    // 이제 우리가 다시 만나게 될\n시간을 알려주세요.
    // 네, 보호자님. \n그때 다시 만나요!

    "닉네임님!\n 기억할개가 완성되었어요.",
    "기억할개를 확인해보세요!",
    "닉네임님!",
    "오늘은 닉네임님과의 \n첫만남이었지만",
    "반려견이 얼마나 많은 사랑을 \n받았는지 느낄 수 있었어요.",
    "앞으로 저와 함께 \n반려견과의 순간들을 기억하며,",
    "닉네임님의 마음 속 안정을 \n찾아가길 바라요.",
    "이제 우리가 다시 만나게 될 \n시간을 알려주세요",
  ];

  bool _visible = true;
  bool _visible2 = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          decoration: startIntro ?
          BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffDDE7FD),
                  Color(0xffDDE7FD),
                ],
              )
          ) :
          BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffE4ECFF),
                  Color(0xffA2BEFF),
                ],
              )
          ),
          //color: startIntro? Color(0xffDDE7FD): Color(0xffC0D2FC),
          child: GestureDetector(
            onTap: (){
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
              print("확인수" + nextPage.toString());
              // _player.setAsset(voice[voiceCount]);

              toggleVisibility();
              if(_visible){
                _visible = false;
              } else if(_visible == false && nextPage <3){
                nextPage++;
                _visible = true;
              }
              if(nextPage == 3){
                nextPage++;
                startIntro = true;
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
                _player.play();
                // 2.5초 적정
                controller1.repeat(
                    min: 0,
                    max: 20,
                    period: const Duration(milliseconds: 1000)
                );

                controller3.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 2000)
                );

                Timer(Duration(milliseconds: 1500), () {
                  controller1.stop();
                });
                Timer(Duration(milliseconds: 1000), () {
                  controller3.stop();
                });
                // nextQuestion++;
                //Navigator.push(context, MaterialPageRoute(builder: (context) => Con01Page()));
              }
              // else if(nextPage == 3 && startIntro == true){
              //    nextPage++;
              //   //Navigator.push(context, MaterialPageRoute(builder: (context) => Con01Page()));
              // }

              else if(nextPage >3 && nextQuestion <4){
                nextQuestion++; // 인트로 시작 후 count
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
                _player.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );

                if(nextQuestion == 1){
                  Timer(Duration(seconds: 5), () {
                    controller1.stop();
                  });

                } else if(nextQuestion == 2){
                  Timer(Duration(seconds: 2), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 3){
                  Timer(Duration(seconds: 4), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 4){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                }

              }
              else if(nextQuestion == 4 && setUserName == true){
                //nextQuestion++; 이름 설정
                // voiceCount++;
                // _player.play();
              }
              else if(nextQuestion >4 && nextQuestion< 9){
                nextQuestion++;
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
                _player.play();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );

                controller3.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 2000)
                );

                Timer(Duration(milliseconds: 1500), () {
                  controller1.stop();
                });
                if(nextQuestion == 6){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestion == 7){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                }
                // 다음 질문에 답해주세요
                else if(nextQuestion == 8){
                  Timer(Duration(seconds: 2), () {
                    controller1.stop();
                  });
                  Timer(Duration(seconds: 1), () {
                    controller3.stop();
                  });
                }
                // 반려견의 이름은 무엇이었을까요
                else if(nextQuestion == 9){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestion == 9 && setDogName == true){
                //nextQuestion++; 강아지 이름 설정
                // voiceCount++;
                // _player.play();
              }
              // 빈칸을 채워알려주세요
              else if(nextQuestion == 10){
                nextQuestion++;
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
              }

              // 빈칸을 채워 알려주세요
              else if(nextQuestion == 11){
                chooseType = false;
                // _player.setAsset(voice[voiceCount]);
                // voiceCount++;
                // _player.play();
                setState(() {
                });
              }
              else if(nextQuestion > 11 && nextQuestion < 16){
                nextQuestion++;
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
                _player.play();
                //_player.play();
                // controller1.stop();
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                if(nextQuestion == 13){
                  Timer(Duration(seconds: 2), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 14){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 15){
                  Timer(Duration(seconds: 2), () {
                    controller1.stop();
                  });
                } else if(nextQuestion == 16){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                }
              }
              // 여기서 부터는 감정 선택
              else if(miss && nextQuestionMiss<3){
                nextQuestionMiss++;
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
                _player.play();
                controller2.repeat(
                    min: 0,
                    max: 32,
                    period: const Duration(milliseconds: 3500)
                );
                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 800)
                );
                if(nextQuestionMiss == 1){
                  Timer(Duration(seconds: 4), () {
                    controller1.stop();
                  });
                  Timer(Duration(seconds: 3), () {
                    controller2.stop();
                  });
                }
                else if(nextQuestionMiss == 2){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestionMiss == 3){
                  Timer(Duration(seconds: 5), () {
                    controller1.stop();
                  });
                }
              }
              else if(grief && nextQuestionGrief<4){
                nextQuestionGrief++;
                _player.setAsset(voice[voiceCount]);
                voiceCount++;
                _player.play();

                controller1.repeat(
                    min: 0,
                    max: 30,
                    period: const Duration(milliseconds: 1000)
                );
                controller2.repeat(
                    min: 0,
                    max: 32,
                    period: const Duration(milliseconds: 3500)
                );


                if(nextQuestionGrief == 1){
                  Timer(Duration(milliseconds: 2000), () {
                    controller2.stop();
                  });
                  Timer(Duration(seconds: 4), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestionGrief == 2){
                  Timer(Duration(seconds: 3), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestionGrief == 3){
                  Timer(Duration(seconds: 4), () {
                    controller1.stop();
                  });
                }
                else if(nextQuestionGrief == 4){
                  Timer(Duration(seconds: 6), () {
                    controller1.stop();
                  });
                }
              }
              else if(nextQuestionGrief == 4 || nextQuestionMiss == 3 ){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IntroMemorialPage()));
              }
              setState(() {
              });
            },
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  //title: Text("기억할개", style: TextStyle(fontSize:16, color: Colors.white ),),
                  //centerTitle: true,
                  leading: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/conversation/home_icon.svg',
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),
                //extendBodyBehindAppBar: true,
                body:
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(height: 3,),
                            Container(
                              width: screenSize.width,
                              height: 25,
                              child: Padding(
                                padding: EdgeInsets.only( left:16, right: 16),
                                child: Center(
                                    child: FAProgressBar(
                                      currentValue: 15,
                                      size: 5,
                                      backgroundColor: Colors.white,
                                    )
                                ),
                              ),
                            ),
                            if(startIntro == false)...[
                              Container(
                                width: screenSize.width,
                                height: screenSize.height,
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 64,),
                                    SvgPicture.asset('assets/images/conversation/intro/intro_star.svg',fit: BoxFit.fill,),
                                    SizedBox(height: 64,),
                                    Stack(
                                      children: [
                                        SvgPicture.asset('assets/images/conversation/intro/intro_bubble.svg',fit: BoxFit.fill,),
                                        Padding(padding:nextPage ==1? EdgeInsets.only(left:86, top:48):EdgeInsets.only(left:62, top:48),
                                          child: AnimatedOpacity(opacity: _visible? 1.0:0.0,
                                            duration:Duration(milliseconds: 500),
                                            child: Text(
                                                questions0[nextPage],
                                                textAlign: TextAlign.center,
                                                style: textStyle.introbubbletext
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 96,),
                                    Container(width: screenSize.width,
                                    child: SvgPicture.asset('assets/images/conversation/intro/intro_cloud.svg',fit: BoxFit.fill,),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                            // 무지 등장 후 대화
                            else...[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                          height: 157,
                                          width: screenSize.width,
                                          child:
                                          Stack(
                                            children: [
                                              Center(child: SvgPicture.asset('assets/images/conversation/bubble.svg',fit: BoxFit.fill,),),
                                              Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12, ),
                                                  child: Center(
                                                      child: Column(
                                                        children: [
                                                          // 대화전 선택 내용
                                                          if(grief == false && miss == false)...[
                                                            if(question1_0[nextQuestion].toString().contains("\n"))...[
                                                              SizedBox(height: 28,),
                                                              Text(
                                                                question1_0[nextQuestion],
                                                                textAlign: TextAlign.center,
                                                                style: textStyle.bubbletext,
                                                              ),
                                                            ]else...[
                                                              SizedBox(height: 42,),
                                                              Text(
                                                                question1_0[nextQuestion],
                                                                textAlign: TextAlign.center,
                                                                style: textStyle.bubbletext,
                                                              ),
                                                            ],
                                                          ]
                                                          // 그리움 선택 시
                                                          else if (miss) ...[
                                                            if(questions1_2[nextQuestionMiss].toString().contains("\n"))...[
                                                              SizedBox(height: 28,),
                                                              Text(
                                                                questions1_2[nextQuestionMiss],
                                                                textAlign: TextAlign.center,
                                                                style: textStyle.bubbletext,
                                                              ),
                                                            ]else...[
                                                              SizedBox(height: 42,),
                                                              Text(
                                                                questions1_2[nextQuestionMiss],
                                                                textAlign: TextAlign.center,
                                                                style: textStyle.bubbletext,
                                                              ),
                                                            ],
                                                            // 슬픔 선택 시
                                                          ] else if (grief) ...[
                                                            if(questions1_3[nextQuestionGrief].toString().contains("\n"))...[
                                                              SizedBox(height: 28,),
                                                              Text(
                                                                questions1_3[nextQuestionGrief],
                                                                textAlign: TextAlign.center,
                                                                style: textStyle.bubbletext,
                                                              ),
                                                            ]else...[
                                                              SizedBox(height: 42,),
                                                              Text(
                                                                questions1_3[nextQuestionGrief],
                                                                textAlign: TextAlign.center,
                                                                style: textStyle.bubbletext,
                                                              ),
                                                            ],
                                                          ]
                                                        ],
                                                      )
                                                  )
                                              ),
                                            ],
                                          )
                                      ),
                                      // 무지 위치
                                      if(nextQuestion < 11)...[
                                        Stack(
                                          children: [
                                            // 유저 위치
                                            Column(
                                              children: [
                                                SizedBox(height: 420,),
                                                Container(
                                                  child: SvgPicture.asset(
                                                    'assets/images/conversation/user7.svg',
                                                    height: 282,
                                                    width: screenSize.width,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(height: 144,),
                                                Container(
                                                    width: screenSize.width,
                                                    height: 375,
                                                    child:
                                                    Stack(
                                                      children: [
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_ear.gif',
                                                            fit: BoxFit.cover,),),
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_base.gif', fit: BoxFit.cover,),),

                                                        if(nextQuestion == 0 || nextQuestion == 12)...[
                                                          Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                            child: GifImage(
                                                              controller: controller3,
                                                              image: const AssetImage("assets/images/conversation/gif/smile_muji.gif"),
                                                            ),
                                                          ),
                                                        ] else if(nextQuestion == 2)...[
                                                          Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                            child: GifImage(
                                                              controller: controller2,
                                                              image: const AssetImage("assets/images/conversation/gif/sad_muji.gif"),
                                                            ),
                                                          ),
                                                        ]
                                                        else...[
                                                          Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                            child: Image.asset('assets/images/conversation/gif/muji_base_eye.gif',
                                                              fit: BoxFit.cover,),),
                                                        ],
                                                        // Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                        //   child: Image.asset('assets/images/conversation/gif/muji_base_eye.gif',
                                                        //     fit: BoxFit.cover,),),
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child:GifImage(
                                                            controller: controller1,
                                                            image: const AssetImage("assets/images/conversation/gif/muji_mouth1.gif"),
                                                          ),
                                                          // Image.asset('assets/images/conversation/gif/muji_mouth1.gif', fit: BoxFit.cover,),
                                                        )
                                                      ],
                                                    )


                                                  // SvgPicture.asset(
                                                  //   'assets/images/conversation/con_muji.svg', fit: BoxFit.cover,
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]
                                      else if(nextQuestion == 11)...[
                                        Padding(
                                          padding:EdgeInsets.only(top:175, left:90),
                                          child:
                                          Container(
                                            width: 250,
                                            //height: 120,
                                            child: Column(children: [
                                              SizedBox(height: 28,),
                                              Stack(children: [
                                                Row(children: [
                                                  Text("${dogName}의 나이는 ", style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                  Container(width: 25,
                                                    padding: EdgeInsets.only(bottom:16),
                                                    child: TextField(
                                                      style:textStyle.inputfield,
                                                      onTap: (){
                                                        chooseType = false;
                                                        setState(() {

                                                        });
                                                      },
                                                      onChanged: (text){
                                                        decidedAge = true;
                                                        if(decidedType){
                                                          selectAT = true;
                                                        }
                                                      },
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                                      controller: dogAgeController,
                                                      decoration: InputDecoration(
                                                        focusedBorder: InputBorder.none,
                                                        hintText: '몇',
                                                        contentPadding: EdgeInsets.only(top: 16),
                                                        suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                        hintStyle: textStyle.field,

                                                      ),
                                                    ),),
                                                  Text("살이고,", style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                ],),
                                                Column(
                                                  children: [
                                                    SizedBox(height: 48,),
                                                    Row(
                                                      children: [
                                                        Text("   견종은", style: TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),

                                                        if(dogTypeinput)...[
                                                          Container(width: 56,
                                                            padding: EdgeInsets.only(bottom:16),
                                                            child: TextField(
                                                              style: textStyle.inputfield,
                                                              onChanged: (text){
                                                                chooseType = true;
                                                                decidedType = true;
                                                                setState(() {
                                                                });
                                                              },
                                                              onTap: (){
                                                                chooseType = true;
                                                                //decidedType = true;
                                                                setState(() {
                                                                });
                                                              },
                                                              // inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                                              controller: dogTypeController,
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                focusedBorder: InputBorder.none,
                                                                hintText: '무슨',
                                                                contentPadding: EdgeInsets.only(top: 16),
                                                                suffixStyle: TextStyle(color: Color(0xff83A8FF), fontSize: 20,),
                                                                hintStyle: textStyle.field,
                                                              ),
                                                            ),
                                                          ),
                                                        ]else...[
                                                          TextButton(
                                                            child: Text(decidedType?"${userDogType}" :"무엇", style: decidedType?textStyle.inputfield : textStyle.field),
                                                            onPressed: (){
                                                              chooseType = true;
                                                              if(decidedAge){
                                                                selectAT = true;
                                                              }
                                                              setState(() {});
                                                            },
                                                          ),

                                                        ],
                                                        Text("입니다.", style: TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                                                      ],)
                                                  ],
                                                ),

                                              ],)

                                            ],),
                                          ),
                                        ),


                                      ] else if(nextQuestion > 11 && nextQuestion <16)...[
                                        Stack(
                                          children: [
                                            // 유저 위치
                                            Column(
                                              children: [
                                                SizedBox(height: 420,),
                                                Container(
                                                  child: SvgPicture.asset(
                                                    'assets/images/conversation/user7.svg',
                                                    height: 282,
                                                    width: screenSize.width,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(height: 144,),
                                                Container(
                                                    width: screenSize.width,
                                                    height: 375,
                                                    child:
                                                    Stack(
                                                      children: [
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_ear.gif',
                                                            fit: BoxFit.cover,),),
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_base.gif', fit: BoxFit.cover,),),
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_base_eye.gif',
                                                            fit: BoxFit.cover,),),
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child:GifImage(
                                                            controller: controller1,
                                                            image: const AssetImage("assets/images/conversation/gif/muji_mouth1.gif"),
                                                          ),
                                                          // Image.asset('assets/images/conversation/gif/muji_mouth1.gif', fit: BoxFit.cover,),
                                                        )
                                                      ],
                                                    )


                                                  // SvgPicture.asset(
                                                  //   'assets/images/conversation/con_muji.svg', fit: BoxFit.cover,
                                                  // ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),

                                      ] else if(nextQuestion == 16)...[
                                        Stack(
                                          children: [

                                            Column(
                                              children: [
                                                SizedBox(height: 418,),
                                                Container(
                                                  height: 284,
                                                  width: screenSize.width,
                                                  color: Color(0xffFFFFF7),
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(height: 418,),
                                                SvgPicture.asset(
                                                  'assets/images/conversation/shadow.svg', fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),

                                            Column(
                                              children: [
                                                SizedBox(height: 144,),
                                                Container(
                                                    width: screenSize.width,
                                                    height: 375,
                                                    child:
                                                    Stack(
                                                      children: [
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_ear.gif',
                                                            fit: BoxFit.cover,),),
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_base.gif', fit: BoxFit.cover,),),
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child: Image.asset('assets/images/conversation/gif/muji_base_eye.gif',
                                                            fit: BoxFit.cover,),),
                                                        Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                          child:GifImage(
                                                            controller: controller1,
                                                            image: const AssetImage("assets/images/conversation/gif/muji_mouth1.gif"),
                                                          ),
                                                          // Image.asset('assets/images/conversation/gif/muji_mouth1.gif', fit: BoxFit.cover,),
                                                        )
                                                      ],
                                                    )

                                                  // SvgPicture.asset(
                                                  //   'assets/images/conversation/con_muji.svg', fit: BoxFit.cover,
                                                  // ),
                                                ),
                                              ],
                                            ),
                                            // Container(
                                            //   width: screenSize.width,
                                            //   height: 258,
                                            //   child: SvgPicture.asset(
                                            //     'assets/images/conversation/con_muji.svg', fit: BoxFit.cover,
                                            //   ),
                                            // ),

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 444,),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 16,),
                                                    Container(
                                                      width: 168,
                                                      height: 168,
                                                      child: ElevatedButton(
                                                          style: ui_miss? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                          onPressed: () {
                                                            //miss = true;
                                                            ui_grief = false;
                                                            if(ui_miss == false){
                                                              ui_miss = true;
                                                            } else{
                                                              ui_miss = false;
                                                            }
                                                            // nextQuestion++;
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(height: 16,),
                                                                Text("그리움", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                                SizedBox(height: 16,),
                                                                Text("우리 ${dogName}가\n그리운 마음이 들어요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_miss? Color(0xff333333) : Color(0xff4B5396)),),
                                                                SizedBox(height: 16,),
                                                                Row(
                                                                  children: [
                                                                    SizedBox(width: 76,),
                                                                    SvgPicture.asset('assets/images/conversation/intro/miss.svg')
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                    SizedBox(width: 16,),
                                                    Container(
                                                      width: 168,
                                                      height: 168,
                                                      child: ElevatedButton(
                                                          style: ui_grief? buttonChart().bluebtn2_1 : buttonChart().whitebtn_1,
                                                          onPressed: () {
                                                            // grief = true;
                                                            ui_miss = false;
                                                            if(ui_grief == false){
                                                              ui_grief = true;
                                                            } else{
                                                              ui_grief = false;
                                                            }
                                                            // nextQuestion++;
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.only(top:8.0,left: 8.0, bottom: 8.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(height: 16,),
                                                                Text("슬픔", style: TextStyle(fontFamily: 'Pretendard',fontSize: 16, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                                SizedBox(height: 16,),
                                                                Text("${dogName}가 없어서\n슬픈 마음이 들어요.", style: TextStyle(fontFamily: 'Pretendard',fontSize: 12, color: ui_grief? Color(0xff333333) : Color(0xff4B5396)),),
                                                                SizedBox(height: 16,),
                                                                Row(
                                                                  children: [
                                                                    SizedBox(width: 76,),
                                                                    SvgPicture.asset('assets/images/conversation/intro/grief.svg')
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                      ]
                                      else if(nextQuestion > 16)...[
                                          Stack(
                                            children: [
                                              // 유저 위치
                                              Column(
                                                children: [
                                                  SizedBox(height: 420,),
                                                  Container(
                                                    child: SvgPicture.asset(
                                                      'assets/images/conversation/user7.svg',
                                                      height: 282,
                                                      width: screenSize.width,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(height: 144,),
                                                  Container(
                                                      width: screenSize.width,
                                                      height: 375,
                                                      child:
                                                      Stack(
                                                        children: [
                                                          Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                            child: Image.asset('assets/images/conversation/gif/muji_ear.gif',
                                                              fit: BoxFit.cover,),),
                                                          Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                            child: Image.asset('assets/images/conversation/gif/muji_base.gif', fit: BoxFit.cover,),),

                                                          if( (miss && nextQuestionMiss == 0) || (grief && nextQuestionGrief == 0) || (grief && nextQuestionGrief == 1))...[
                                                            Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                              child: GifImage(
                                                                controller: controller2,
                                                                image: const AssetImage("assets/images/conversation/gif/sad_muji.gif"),
                                                              ),
                                                            ),
                                                          ] else...[
                                                            Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                              child: Image.asset('assets/images/conversation/gif/muji_base_eye.gif',
                                                                fit: BoxFit.cover,),),
                                                          ],

                                                          Padding(padding: EdgeInsets.only(bottom: 0, left: 0),
                                                            child:GifImage(
                                                              controller: controller1,
                                                              image: const AssetImage("assets/images/conversation/gif/muji_mouth1.gif"),
                                                            ),
                                                            // Image.asset('assets/images/conversation/gif/muji_mouth1.gif', fit: BoxFit.cover,),
                                                          )
                                                        ],
                                                      )

                                                    // SvgPicture.asset(
                                                    //   'assets/images/conversation/con_muji.svg', fit: BoxFit.cover,
                                                    // ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ]
                                    ],
                                  )

                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      ),
                // 입력 및 리스트 추가 작업 - 매우 중요
                // // nextQuestion 이 3과 7일때 등장
                bottomSheet: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom * 0.001),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(nextQuestion == 4)...[
                        Container(
                          color: Colors.white,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 16,right: 16),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: screenSize.width,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: setUserName? Color(colorChart.blue):Color(0xffC0D2FC)),
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
                                    controller: userNameController,
                                    style: textStyle.bk14normal,
                                    decoration: InputDecoration(
                                        hintStyle: textStyle.grey14normal,
                                        border: InputBorder.none,
                                        hintText: '이렇게 불러주세요.'),
                                    onChanged: (s) {
                                      setUserName = true;
                                      setState(() {

                                      });
                                      //text = s;
                                    },
                                    onTap: () {},
                                  ),
                                ),
                                Positioned(
                                  left: screenSize.width - 80,
                                  //right: 30,
                                  bottom: 3,
                                  top: 3,
                                  child: ElevatedButton(
                                      onPressed: () {

                                        if(setUserName){
                                          nextQuestion++;
                                          _player.setAsset(voice[voiceCount]);
                                          voiceCount++;
                                          _player.play();
                                          controller1.repeat(
                                              min: 0,
                                              max: 53,
                                              period: const Duration(milliseconds: 1000)
                                          );

                                          Timer(Duration(milliseconds: 1500), () {
                                            controller1.stop();
                                          });

                                          controller3.repeat(
                                              min: 0,
                                              max: 30,
                                              period: const Duration(milliseconds: 2000)
                                          );

                                          Timer(Duration(milliseconds: 1000), () {
                                            controller3.stop();
                                          });

                                          // setUserName = true;
                                          userName = userNameController.text;
                                          userName_ = userName;
                                          // 닉네임 추가
                                          // 통으로 추가
                                          //"좋아요. 보호자님.", // this is modifi
                                          //"제가 보호자님과의 대화를 시작하기 위해",
                                          //"보호자님에 대해서\n더 알아가려고 해요.",
                                          //"다음 질문에 답해주세요!",
                                          question1_0.insertAll(5, [
                                            "좋아요. ${userName}님.",
                                            "제가 ${userName}님과의\n대화를 시작하기 위해",
                                            "${userName}님에 대해서\n더 알아가려고 해요.",
                                            "다음 질문에 답해주세요!",
                                            "반려견의 이름은 무엇이었을까요?",
                                          ]);
                                          setState(() {

                                          });
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: setUserName? Color(colorChart.blue):Color(0xffDDE7FD),
                                        fixedSize: const Size(3, 3),
                                        shape: const CircleBorder(),
                                      ),
                                      child: Icon(
                                        Icons.arrow_upward,
                                        color: Colors.white,
                                        size: 16,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ]else if(nextQuestion == 9)...[
                        Container(
                          color:Colors.white,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 16,right: 16),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: screenSize.width,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: setDogName? Color(colorChart.blue):Color(0xffC0D2FC)),
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
                                  // maxLength: 8,
                                  controller: dogNameController,
                                  style: textStyle.bk14normal,
                                  decoration: InputDecoration(
                                      hintStyle: textStyle.grey14normal,
                                      border: InputBorder.none,
                                      hintText: '반려견의 이름은...'),
                                  onChanged: (s) {
                                    //text = s;
                                    setDogName = true;
                                    setState(() {

                                    });
                                  },
                                  onTap: () {},
                                ),
                              ),
                              Positioned(
                                left: screenSize.width - 81,
                                //right: 30,
                                bottom: 3,
                                top: 3,
                                child: ElevatedButton(
                                    onPressed: () {
                                      // setDogName = true;
                                      if(setDogName){
                                        nextQuestion++;
                                        _player.setAsset(voice[voiceCount]);
                                        voiceCount++;
                                        _player.play();

                                        controller1.repeat(
                                            min: 0,
                                            max: 20,
                                            period: const Duration(
                                                milliseconds: 1000));

                                        Timer(Duration(milliseconds: 2000), () {
                                          controller1.stop();
                                        });
                                        dogName = dogNameController.text;
                                        dogName_ = dogName;

                                        question1_0.insertAll(10, [
                                          "${dogName}의 모습은 어땠나요? \n빈칸을 채워 알려주세요.",
                                          "${dogName}의 모습은 어땠나요? \n빈칸을 채워 알려주세요.",
                                          // this is modifi
                                          "좋아요, ${userName}님!",
                                          "질문에 답하며,\n잠깐이나마",
                                          "${dogName}에 대해서 떠올려봤던 것 같아요.",
                                          "${dogName}에 대해서 생각하니",
                                          "${userName}님은\n어떤 마음이 들었나요?",
                                        ]);

                                        setState(() {});
                                      }

                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: setDogName? Color(colorChart.blue):Color(0xffDDE7FD),
                                      fixedSize: const Size(23, 23),
                                      shape: const CircleBorder(),
                                    ),
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                      size: 16,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ]
                      else if(chooseType && dogTypeinput == false)...[
                        Container(
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: screenSize.width,
                                height: 280,
                                child:
                                GridView.builder(
                                    itemCount:49,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                                      childAspectRatio: 3 / 0.7, //item 의 가로 1, 세로 2 의 비율
                                      mainAxisSpacing: 8, //수평 Padding
                                      crossAxisSpacing: 8, //수직 Padding
                                    ),
                                    itemBuilder: (BuildContext context, int index){
                                      return
                                        ElevatedButton(
                                            style: buttonChart().whitebtn,
                                            onPressed: () {
                                              if(index == 48){
                                                dogTypeinput = true;
                                                setState(() {});
                                              } else{
                                                decidedType= true;
                                                chooseType = false;
                                                dogType = dogType_[index];
                                                userDogType = dogType_[index];
                                                setState(() {});
                                              }
                                            },
                                            child: Text("${dogType_[index]}", style: textStyle.bk14normal,)
                                        );
                                    }),
                              )
                          ),
                        ),
                        ]
                        else if(nextQuestion == 11 && selectAT)...[
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
                                    _player.setAsset(voice[voiceCount]);
                                    voiceCount++;
                                    _player.play();

                                    controller1.repeat(
                                        min: 0,
                                        max: 45,
                                        period: const Duration(milliseconds: 1000)
                                    );

                                    Timer(Duration(seconds: 1), () {
                                      controller1.stop();
                                    });
                                    controller3.repeat(
                                        min: 0,
                                        max: 30,
                                        period: const Duration(milliseconds: 2000)
                                    );

                                    Timer(Duration(milliseconds: 1000), () {
                                      controller3.stop();
                                    });

                                    decidedType = false;
                                    dogAge = int.parse(dogAgeController.text);
                                    if(dogTypeinput){
                                      dogType = dogTypeController.text;
                                    }
                                    nextQuestion++;
                                    setState(() {});
                                    saveUserInfo(sign_in.userAccessToken, userName, dogName, dogAge, dogType);
                                  },
                                  child: Text("다음"),
                                ),
                              ),),
                          ),
                        ]
                          else if(nextQuestion == 16 && (ui_miss || ui_grief) )...[
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
                                        nextQuestion++;
                                        if(ui_miss){
                                          voice.insertAll(17, [
                                            "assets/voice/intro/intro_miss1.mp3",
                                            "assets/voice/intro/intro_miss2.mp3",
                                            "assets/voice/intro/intro_miss3.mp3",
                                            "assets/voice/intro/intro_miss4.mp3",
                                            "assets/voice/intro/intro_miss4.mp3",
                                          ]);
                                          questions1_2.insertAll(0,[
                                            "이제는 ${dogName}의\n모습을 보거나 만질 수 없지만,",
                                            "${dogName}를 생각하며\n그리움을 채워갈 수 있을 것 같아요.",
                                            "${dogName}와의 기억을\n처음부터 떠올려볼까요?",
                                            "${dogName}와의 기억이 시작되는\n그날의 사진과 이야기를 기록해보아요.",
                                          ]);
                                          miss = true;
                                          _player.setAsset(voice[voiceCount]);
                                          voiceCount++;
                                          controller1.repeat(
                                              min: 0,
                                              max: 45,
                                              period: const Duration(milliseconds: 1000)
                                          );
                                          controller2.repeat(
                                              min: 0,
                                              max: 32,
                                              period: const Duration(milliseconds: 3500)
                                          );
                                          Timer(Duration(seconds: 3), () {
                                            controller2.stop();
                                          });
                                          Timer(Duration(milliseconds: 4000), () {
                                            controller1.stop();
                                          });
                                        }else if (ui_grief){
                                          voice.insertAll(17, [
                                            "assets/voice/intro/intro_grief1.mp3",
                                            "assets/voice/intro/intro_grief2.mp3",
                                            "assets/voice/intro/intro_grief3.mp3",
                                            "assets/voice/intro/intro_grief4.mp3",
                                            "assets/voice/intro/intro_grief5.mp3",
                                            "assets/voice/intro/intro_grief5.mp3",
                                          ]);
                                          questions1_3.insertAll(0,[
                                            "${dogName}가 곁에 없는 지금…",
                                            "${userName}님의\n슬픈 마음이 제게도 느껴져요.",
                                            "${dogName}와의\n기억을 하나씩 되돌아보면",
                                            "슬픈 마음을 덜기에 도움이 될거예요.",
                                            "${dogName}와의 기억이 시작되는\n그날의 사진과 이야기를 기록해보아요.",
                                          ]);
                                          grief = true;
                                          _player.setAsset(voice[voiceCount]);
                                          voiceCount++;
                                          controller1.repeat(
                                              min: 0,
                                              max: 45,
                                              period: const Duration(milliseconds: 1000)
                                          );
                                          controller2.repeat(
                                              min: 0,
                                              max: 32,
                                              period: const Duration(milliseconds: 3500)
                                          );
                                          Timer(Duration(milliseconds: 3000), () {
                                            controller1.stop();
                                          });
                                          Timer(Duration(seconds: 3), () {
                                            controller2.stop();
                                          });
                                        }

                                        setState(() {});
                                      },
                                      child: Text("다음"),
                                    ),
                                  ),),
                              ),
                            ]
                    ],
                  ),
                )),
          )
      );

  }
}
