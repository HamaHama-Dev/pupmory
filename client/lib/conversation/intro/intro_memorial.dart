import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/style.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:client/sign/sign_in.dart' as sign_in;
import 'intro2.dart';

/// 인트로에서 추억 작성하기
class IntroMemorialPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => IntroMemorialPage(),
      ),
    );
  }

  @override
  _IntroMemorialPageState createState() => _IntroMemorialPageState();
}

class _IntroMemorialPageState extends State<IntroMemorialPage> {

  String _imageDate = "사진을 추가해주세요.";

  // 텍스트에디팅컨트롤러를 생성하여 필드에 할당
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final locationController = TextEditingController();
  final contentController = TextEditingController();
  final hashtagController = TextEditingController();

  bool title = false;
  bool date = false;
  bool location = false;
  bool content = false;
  bool hashtag = false;

  // 날짜를 직접 조정인지 확인
  bool modiDate = false;

  // 공개 비공개: 처음에는 공개로 설정되어 있음
  String isPrivate = "False";
  bool private = false;

  bool isPicSelected = false; // 사진이 들어가는지 확인하는 코드 -> UI 바뀜
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _pickedImages = [];

  // 이미지 여러개 불러오기
  void getMultiImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      setState(() async {
        print("check it");
        //_picker.pickMultiImage().printInfo();
        _pickedImages.addAll(images);
        print("??: "+ images[0].path);

        // /(?<year>20(?:0|1|2)\d{1})(?:-|\.|_)?(?<month>\d{2})(?:-|\.|_)?(?<day>\d{2})(?:-|_|\.|\s)?(?<hour>\d{2})(?:-|\.|_)?(?<minute>\d{2})(?:-|\.|_)?(?<second>\d{2})/
        final dateMatch = RegExp(r'(\d{4})(\d{2})(\d{2})').firstMatch(images[0].path);

        if (dateMatch != null) {
          final year = dateMatch.group(1);
          final month = dateMatch.group(2);
          final day = dateMatch.group(3);

          setState(() {
            _imageDate = '$year-$month-$day';

            print("확인 부탁" + _imageDate.toString());
          });
        }

        isPicSelected = true;
        setState(() {

        });

      });
    }
  }

  Future<void> uploadImagesAndData2(String aToken, List<XFile> images, String title, String date, String place, String content, String hashtag, String isPrivate) async {
    print('test');
    try {
      var dio = Dio(); // Dio 인스턴스 생성

      // JSON 데이터 추가
      final jsonData = {
        "title": title,
        "date":date,
        "place": place,
        "content": content,
        "hashtag": hashtag,
        "isPrivate": isPrivate
      };

      // JSON 데이터를 문자열로 인코딩
      final jsonString = jsonEncode(jsonData);

      final List<MultipartFile> _files2 = images
          .map((img) => MultipartFile.fromFileSync(img.path,
          contentType: MediaType("image", "jpeg")))
          .toList();

      //final List<MultipartFile> _files = images.map((img) => MultipartFile.fromFileSync(img!.path,  contentType: new MediaType("image", "jpg"))).toList();

      //print('Content-Type: ${_files.contentType}');


      final data = FormData.fromMap({
        "image": _files2,
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
        'http://3.38.1.125:8080/memorial', // 서버 엔드포인트 경로 설정
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


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;
    return
      Container(
          child: Scaffold(
              backgroundColor: Color(0xffF2F4F6),
              appBar: AppBar(
                actions: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 15),
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        InkWell(
                          onTap: (){
                            // 여기에 db로  image path도 보내기
                            //uploadImages(_pickedImages);
                            print("test: " + _pickedImages.toString());
                            //List<XFile> images, String title, String place, String content, String hashtag, String isPrivate
                            uploadImagesAndData2(
                                sign_in.userAccessToken,
                                _pickedImages,
                                titleController.text.toString(),
                                _imageDate,
                                locationController.text.toString(),
                                contentController.text.toString(),
                                hashtagController.text.toString(),
                                isPrivate);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Intro2Page()));
                        },
                          child: SvgPicture.asset(
                            'assets/images/memorial/upload_button.svg',
                          ),
                        ),

                      ],
                    ),)
                ],
                // actions: <Widget>[
                //   new IconButton(
                //     icon: Container(
                //       child: SvgPicture.asset(
                //         'assets/images/memorial/upload_button.svg',
                //       ),),
                //     onPressed: (){
                //       // 여기에 db로  image path도 보내기
                //       print("test: "+_pickedImages.toString());
                //       //List<XFile> images, String title, String place, String content, String hashtag, String isPrivate
                //       uploadImagesAndData2(sign_in.userAccessToken, _pickedImages,titleController.text.toString(),_imageDate,locationController.text.toString(),
                //           contentController.text.toString(), hashtagController.text.toString(), isPrivate);
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => Intro2Page()));
                //     },
                //   ),
                // ],
                title: Text("기억 남기기", style: textStyle.bk20normal),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                iconTheme: IconThemeData(color: Colors.black),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),

              ),
              body: Container(
                // width: screenSize.width,
                // height: screenSize.height,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  //scrollDirection: Axis.vertical,
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        width: screenSize.width,
                        height: screenSize.width - 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GridView.builder(
                            itemCount:9,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                              childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                              mainAxisSpacing: 16, //수평 Padding
                              crossAxisSpacing: 16, //수직 Padding
                            ),
                            itemBuilder: (BuildContext context, int index){
                              return
                                Stack(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/memorial/memorial_img.svg',
                                      width: 128,
                                      height: 128,
                                    ),
                                    if(isPicSelected && index == 0 && _pickedImages.length >= 1)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),

                                    ],
                                    if(isPicSelected && index == 1 && _pickedImages.length >= 2)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                    if(isPicSelected && index == 2 && _pickedImages.length >= 3)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                    if(isPicSelected && index == 3 && _pickedImages.length >= 4)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                    if(isPicSelected && index == 4 && _pickedImages.length >= 5)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                    if(isPicSelected && index == 5 && _pickedImages.length >= 6)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                    if(isPicSelected && index == 6 && _pickedImages.length >= 7)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                    if(isPicSelected && index == 7 && _pickedImages.length >= 8)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                    if(isPicSelected && index == 8 && _pickedImages.length >= 9)...[
                                      Container(
                                        width: 128,
                                        height: 128,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child:  Image.file(File(_pickedImages![index]!.path), fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 72,),
                                          Container(
                                              width: 24,
                                              height: 24,
                                              child:InkWell(
                                                child: SvgPicture.asset(
                                                  'assets/images/memorial/delete_bt.svg',
                                                ),
                                                onTap: (){
                                                  _pickedImages.removeAt(index);
                                                  setState(() {});
                                                  print("remove");
                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                    // Row(
                                    //   children: [
                                    //     SizedBox(width: 70,),
                                    //     Container(
                                    //       width: 20,
                                    //       height: 20,
                                    //       child: IconButton(
                                    //           onPressed: (){
                                    //             _pickedImages.removeAt(index);
                                    //             setState(() {});
                                    //             print("remove");
                                    //           }, icon: Icon(Icons.cancel, color: Colors.black,)),
                                    //     ),
                                    //   ],),
                                    if(index == 0 && _pickedImages.length >= 1)...[
                                      Padding(padding: EdgeInsets.only(top: 70, left: 5),
                                        child: SvgPicture.asset(
                                          'assets/images/memorial/image_rep.svg',
                                        ),
                                      ),
                                    ],

                                    if(index == 8 && _pickedImages.length < 9)...[
                                      Center(
                                          child: IconButton(
                                            onPressed: (){
                                              getMultiImage();
                                            },
                                            icon: Image.asset('assets/images/memorial/memorial_upload.png'),
                                          ))
                                    ],

                                  ],
                                );

                            }),
                      ),

                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Padding(padding: EdgeInsets.only(top:16, left: 16, right:16),
                                child: Text("제목",style: textStyle.bk14midium,),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top:0,left: 20, right:20),
                              child: TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top:3, left: 0),
                                    hintStyle: textStyle.grey16normal,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: '제목을 입력하세요.'),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

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
                              child: Padding(padding: EdgeInsets.only(top:16,left: 16, right:16),
                                child: Text("날짜", style: textStyle.bk14midium,),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Padding(padding: EdgeInsets.only(top:0, left: 16, right:16, bottom: 8),
                              child:
                              Row(children: [
                                Container(
                                  width: 225,
                                  child: modiDate?
                                  Container(
                                    height: 20,
                                    child: TextField(
                                      controller: dateController,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(bottom:13),
                                          hintStyle: textStyle.grey16normal,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          hintText: '2000-00-00'),
                                      onTap: (){

                                      },
                                    ),)

                                      : Text( "${_imageDate}", style: textStyle.bk16normal,),
                                ),
                                if(modiDate == false)...[
                                  SizedBox(width: 30,),
                                  Container(
                                    height: 24,
                                    width: 62,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiDate = true;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().pinkbtn2,
                                        child: Text("수정", style: textStyle.white16midium,)
                                    ),)
                                ]else...[
                                  SizedBox(width: 30,),
                                  Container(
                                    height: 24,
                                    width: 62,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          modiDate = false;
                                          _imageDate = dateController.text;
                                          setState(() {
                                          });
                                        },
                                        style: buttonChart().bluebtn,
                                        child: Text("완료", style: textStyle.white16midium,)
                                    ),)
                                ]
                              ],),
                            ),
                            SizedBox(height: 6,),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Padding(padding: EdgeInsets.only(top:16,left: 16, right:16),
                                child: Text("위치",style: textStyle.bk14midium,),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top:0,left: 16, right:16),
                              child:
                              Row(children: [
                                Container(width: 255,
                                  child: TextField(
                                    controller: locationController,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top:3, left: 0),
                                        hintStyle: textStyle.grey16normal,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: '위치를 적거나 입력해주세요.'),),
                                ),
                                // Container(
                                //   height: 25,
                                //   width: 57,
                                //   child: ElevatedButton(
                                //       onPressed: (){
                                //       },
                                //       style: buttonChart().pinkbtn2,
                                //       child: Text("검색", style: textStyle.white16midium,)
                                //   ),)
                              ],),

                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Padding(padding: EdgeInsets.only(top:16,left: 16, right:16),
                                child: Text("내용", style: textStyle.bk14midium,),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                              child: TextField(
                                controller: contentController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top:3, left:0),
                                    hintStyle: textStyle.grey16normal,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: '그날의 이야기를 적어주세요.'),
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 8,
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Padding(padding: EdgeInsets.only(top:16,left: 16, right:16),
                                child: Text("해시태그", style: textStyle.bk14midium,),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:0,left: 16, right:16),
                              child: TextField(
                                controller: hashtagController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top:3, left: 0),
                                    hintStyle: textStyle.grey16normal,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: '#해시태그를 사용해보세요.'),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8,),

                      Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Padding(padding: EdgeInsets.only(top:0),
                                  child: Text("공개 설정",style: textStyle.bk14midium),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Padding(padding: EdgeInsets.only(top:8),
                                  child: Text("이 메모리얼을 공개하면 다른 반려인들의 '구경하기'페이지에 공유됩니다.",style: TextStyle(fontSize: 11, color: Color(0xff555555)),),
                                ),
                              ),
                              SizedBox(height: 16,),
                              Row(
                                children: [
                                  //SizedBox(width: 20,),
                                  Container(
                                    height: 26,
                                    width: 100,
                                    child: ElevatedButton(onPressed: (){
                                      isPrivate = "False";
                                      private = false;
                                      setState(() {
                                      });
                                    },
                                        style: private? buttonChart().bluebtn4 : buttonChart().bluebtn2,
                                        child: Text("공개", style: private? textStyle.bk14light :textStyle.bk14midium,)
                                    ),
                                  ),
                                  SizedBox(width: 8,),
                                  Container(
                                    height: 26,
                                    width: 100,
                                    child: ElevatedButton(onPressed: (){
                                      isPrivate = "True";
                                      private = true;
                                      setState(() {
                                      });
                                    },
                                        style: private? buttonChart().bluebtn2 : buttonChart().bluebtn4,
                                        child: Text("비공개", style: private? textStyle.bk14midium :textStyle.bk14light,)
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                      ),

                    ],
                  ),
                ),
              )

          )
      );

  }
}
