import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class colorChart{
  static int black = 0xff000000;
  static int white = 0xffFFFFFF;
  static int grey = 0xffAAAAAA;
  static int lightgrey = 0xffD9D9D9;
  static int green = 0xff8CC63F;

  static int blue = 0xff83A8FF;
  static int lightblue = 0xffC0D2FC;
  static int lightblue2 = 0xffDDE7FD;

  static int pink = 0xffEFB3B5;
  static int lightpink = 0xffFCCBCD;

  // F2F6FF DDE7FD
  static int purple = 0xff4B5396;
  static int lightpurple = 0xffF2F6FF;
  static int lightpurple2 = 0xffDDE7FD;

  static int yellow = 0xffFEFBAC;

  //99A8CB
  static int bluegrey = 0xff99A8CB;

//4B5396


}

class buttonChart{
  static double btnheight = 40;

  // 83A8FF
  var blackbtn = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.black),
    onPrimary: Color(colorChart.grey),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var whitebtn = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.white),
    onPrimary: Color(colorChart.black),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(colorChart.blue), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var whitebtn_1 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.white),
    onPrimary: Color(colorChart.black),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(colorChart.blue), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(16.0),
    ),
  );

  var greybtn_1 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(0xffEFEFEF),
    onPrimary: Color(0xffAEAEAE),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(0xffAAAAAA), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(16.0),
    ),
  );

  var whitebtn2 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Colors.white,
    onPrimary: Color(0xff4B5396),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var whitebtn3 = ElevatedButton.styleFrom(
    shadowColor: Colors.black.withOpacity(0.08),
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 5,
    primary: Colors.white,
    onPrimary: Color(0xff4B5396),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var whitebtn4 = ElevatedButton.styleFrom(
    shadowColor: Colors.black.withOpacity(0.08),
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 5,
    primary: Colors.white,
    onPrimary: Color(0xff4B5396),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(0xff4F6AC9), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var signInbtn = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(0xff83A8FF),
    onPrimary: Color(colorChart.grey),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(colorChart.blue), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var greybtn = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.grey),
    onPrimary: Colors.white,
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var bluebtn = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.lightblue),
    onPrimary: Color(colorChart.black),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var bluebtn2 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.lightblue),
    onPrimary: Color(colorChart.black),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(colorChart.blue), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var bluebtn2_1 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.lightblue),
    onPrimary: Color(colorChart.black),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(colorChart.blue), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(16.0),
    ),
  );

  var bluebtn3 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.blue),
    onPrimary: Color(colorChart.white),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var bluebtn4 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.white),
    onPrimary: Color(colorChart.black),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(colorChart.lightblue2), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var pinkbtn = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.lightpink),
    onPrimary: Color(colorChart.pink),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var pinkbtn2 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.lightpink),
    onPrimary: Color(colorChart.lightpink),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var purplebtn = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.purple),
    onPrimary: Color(colorChart.purple),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var purplebtn2 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.purple),
    onPrimary: Color(colorChart.lightpurple),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var purplebtn3 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.lightpurple2),
    //onPrimary: Color(colorChart.white),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );


  var yellowbtn = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.yellow).withOpacity(0.8),
    onPrimary: Color(colorChart.purple),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color(colorChart.purple), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  var yellowbtn2 = ElevatedButton.styleFrom(
    minimumSize: Size(Get.width, btnheight),
    maximumSize: Size(Get.width, btnheight),
    elevation: 0,
    primary: Color(colorChart.yellow).withOpacity(0.8),
    onPrimary: Color(colorChart.purple),
    // shape: const StadiumBorder(),
    shape: RoundedRectangleBorder(
      //side: BorderSide(color: Color(colorChart.purple), width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

}

// style: TextStyle(color: Color(0xff4B5396),fontSize: 16, fontFamily: 'Pretendard',
//                                       fontWeight: FontWeight.w600,),

class textStyle {
  static TextStyle bk40bold = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  static TextStyle bk40normal = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle bk20semibold =
  TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black);

  static TextStyle bk20bold =
  TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black);

  static TextStyle bk20normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black);

  static TextStyle bk16light = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black);

  static TextStyle bk16normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);

  static TextStyle bk16normalCon = TextStyle(
      fontFamily: 'Pretendard', height: 1.5,
      fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff333333));

  static TextStyle bk16midium = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);

  static TextStyle bk16semibold =
  TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);

  static TextStyle wo16semibold =
  TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff4F6AC9));


  static TextStyle bk16bold =
  TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black);

  static TextStyle bk14light = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black);

  static TextStyle bk14normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);

  static TextStyle bk6614normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff666666));

  static TextStyle bk14midium = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);

  static TextStyle bk6614midium = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff666666));

  static TextStyle bk14semibold = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);

  static TextStyle pp1 = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff83A8FF));

  static TextStyle pp2 = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff4B5396));

  static TextStyle bk13light = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 13, fontWeight: FontWeight.w300, color: Colors.black);

  static TextStyle bk12normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black);

  static TextStyle bk12midium = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black);

  static TextStyle bk12light = TextStyle(
      fontFamily: 'Pretendard', height: 1.4,
      fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black);

  static TextStyle grey16bold = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 18, fontWeight: FontWeight.w700, color: Color(colorChart.grey));

  static TextStyle grey16semibold = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 18, fontWeight: FontWeight.w600, color: Color(colorChart.grey));

  static TextStyle grey14regular = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w600, color: Color(colorChart.grey));

  static TextStyle grey14midium = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w500, color: Color(colorChart.grey));

  static TextStyle grey12normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12, fontWeight: FontWeight.w400, color: Color(colorChart.grey));

  static TextStyle grey16normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.grey));

  static TextStyle grey14normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff99A8CB));

  static TextStyle grey16normal2 = TextStyle(
      fontFamily: 'Pretendard', height: 1.5,
      fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.grey));

  static TextStyle grey16normalCon = TextStyle(
      fontFamily: 'Pretendard', height: 1.4,
      fontSize: 16, fontWeight: FontWeight.w400, color: Color(colorChart.grey));

  static TextStyle white20bold = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white);

  static TextStyle white16normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);

  static TextStyle white16midium = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white);

  static TextStyle white16semibold = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle white16bold = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white);

  static TextStyle white14light = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white);

  static TextStyle white14normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);

  static TextStyle white12normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white);

  static TextStyle bg10normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 10, fontWeight: FontWeight.w400, color: Color(colorChart.bluegrey));

  static TextStyle purple12normal = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12, fontWeight: FontWeight.w400, color: Color(colorChart.purple));

  static TextStyle purple12light = TextStyle(
      fontFamily: 'Pretendard', letterSpacing: 0.6,
      fontSize: 12, fontWeight: FontWeight.w300, color: Color(colorChart.purple));

  static TextStyle purple16midium = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(colorChart.purple));

  static TextStyle green16bold = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(colorChart.green));

  static TextStyle bubbletext = TextStyle(
      fontFamily: 'Nanum-BaReunHiPi', height: 1.4,
      fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xff222222));

  static TextStyle bubbletext2 = TextStyle(
      fontFamily: 'Nanum-BaReunHiPi', height: 1.4,
      fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff222222));

  static TextStyle introbubbletext = TextStyle(
      fontFamily: 'Nanum-BaReunHiPi', height: 1.4,
      fontSize: 19, fontWeight: FontWeight.w500, color: Color(0xff4B5396));


  static TextStyle field = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff83A8FF));

  static TextStyle inputfield = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 20, fontWeight: FontWeight.w500, color: Color(colorChart.purple));
}