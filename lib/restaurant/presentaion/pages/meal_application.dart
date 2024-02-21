import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

//신청 유형 확인 변수
var meal_category = '';

//신청 여부 확인 변수
var application = false;

//입금 여부 확인 변수
var deposit = false;

class MealApplication extends StatefulWidget {
  const MealApplication({super.key});

  @override
  State<MealApplication> createState() => _MealApplicationState();
}

class _MealApplicationState extends State<MealApplication> {
  @override
  Widget build(BuildContext context) {
    //첫 신청인 경우
    if (application == false) {
      return Scaffold(
        appBar: const BaseAppBar(title: '식수 신청'),
        drawer: const BaseDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: CustomSingleChildScrollView(
          child: Column(
            children: [
              //상단 겹쳐져 있는 바
              const SizedBox(
                height: 150.0,
                child: Stack(
                  children: [
                    BlueMainRoundedBox(),
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: WhiteMainRoundedBox(
                          iconData: Icons.campaign,
                          mainText: '현재 1학기 식수 신청 기간입니다.',
                          secondaryText: '신청기간 2024.02.20 ~ 2024.03.01',
                          actionText: '유형 외의 식사는 자유식 티켓을 구입해 주세요.',
                          timeText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //학생정보 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  '학생정보',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //학번 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('학번'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '2201333',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //이름 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('이름'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '김정원',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //전화번호 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('번호'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '010-6525-6480',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //식사 정보 글자
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  '식사정보',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //기간 산정 금액 글자
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        '2024.03.02 ~ 2024.07.18 ',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 29, 127, 159),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '기간 산정 금액',
                        style: TextStyle(
                          color: Color.fromARGB(255, 120, 120, 120),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //유형 선택 박스
              GroupButton(
                //버튼 디자인
                options: const GroupButtonOptions(
                  //버튼 그림자
                  selectedShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 207, 207, 207), //그림자 색상
                      spreadRadius: 0.5, // 그림자 넓이
                      blurRadius: 5, // 그림자 흐림도
                      offset: Offset(3, 3), // 그림자가 박스랑 얼마나 떨어져서 나타날지
                    ),
                  ],
                  unselectedShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 207, 207, 207), //그림자 색상
                      spreadRadius: 0.5, // 그림자 넓이
                      blurRadius: 5, // 그림자 흐림도
                      offset: Offset(3, 3), // 그림자가 박스랑 얼마나 떨어져서 나타날지
                    ),
                  ],

                  //버튼 글자 스타일
                  selectedTextStyle: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 29, 127, 159),
                  ),
                  unselectedTextStyle: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 29, 127, 159),
                  ),

                  //버튼 컬러
                  selectedColor: Colors.white,
                  selectedBorderColor: Color.fromARGB(255, 29, 127, 159),

                  //버튼 테두리
                  borderRadius: BorderRadius.all(Radius.circular(15)),

                  //버튼 간격
                  spacing: 10,

                  //버튼 크기
                  buttonHeight: 120,
                  buttonWidth: 120,
                ),
                isRadio: true,

                //버튼 클릭시 실행 되는 함수
                onSelected: (index, isSelected, isPressed) {
                  if (isSelected == 0) {
                    meal_category = 'A유형 : 750,000';
                  } else if (isSelected == 1) {
                    meal_category = 'B유형 : 520,000';
                  } else if (isSelected == 2) {
                    meal_category = 'C유형 : 520,000';
                  }
                },

                //버튼 내용
                buttons: const [
                  'A유형\n점심+저녁\n228식(1식3,000)\n750,000',
                  'B유형\n점심\n152식(1식3,500)\n520,000',
                  'C유형\n저녁\n152식(1식3,500)\n520,000'
                ],
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //계좌 정보 글자
              Container(
                child: const Text(
                  '계좌 정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //입금 기간 글자
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                child: const Text(
                  '2024.03.01까지 입금 완료',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 168, 168, 168)),
                ),
              ),

              //계좌번호 박스
              Container(
                alignment: Alignment.center,
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 168, 168, 168),
                  ),
                ),
                child: Text(
                  '농협 352 1299 5358 33',
                  style: TextStyle(
                    color: Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
              ),

              //신청 버튼
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15, right: 25),
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 29, 127, 159),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      // 테두리 둥글기 조절
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // 둥글기 정도를 조절하는 값
                      ),
                    ),
                  ),

                  //버튼 클릭 시 동작
                  onPressed: () {
                    if (meal_category == '') {
                      non_select(context);
                    } else {
                      meal_application(context);
                      setState(() {
                        application = true;
                      });
                    }
                  },
                  child: Text(
                    '신청',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //신청 완료 && 입금x인 경우
    else if (application == true && deposit == false) {
      return Scaffold(
        appBar: const BaseAppBar(title: '식수 신청'),
        drawer: const BaseDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //상단 겹쳐져 있는 바
              const SizedBox(
                height: 150.0,
                child: Stack(
                  children: [
                    BlueMainRoundedBox(),
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: WhiteMainRoundedBox(
                          iconData: Icons.campaign,
                          mainText: '현재 1학기 식수 신청 기간입니다.',
                          secondaryText: '신청기간 2024.02.20 ~ 2024.03.01',
                          actionText: '유형 외의 식사는 자유식 티켓을 구입해 주세요.',
                          timeText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //학생정보 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  '학생정보',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //학번 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('학번'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '2201333',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //이름 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('이름'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '김정원',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //전화번호 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('번호'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '010-6525-6480',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //신청 유형 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('신청'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '$meal_category',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //신청 현황 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  '신청 현황',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //입금 x 컨테이너
              Container(
                margin: EdgeInsets.all(10),
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 205, 205, 205),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_very_dissatisfied,
                        color: Colors.red, size: 40),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '기간내에 입금을 완료해주세요',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      '계좌번호 : 농협 352 1299 5358 33',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 162, 162, 162),
                      ),
                    )
                  ],
                ),
              ),

              //신청 취소 버튼
              Container(
                margin: EdgeInsets.all(15),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 159, 29, 29),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      // 테두리 둥글기 조절
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // 둥글기 정도를 조절하는 값
                      ),
                    ),
                  ),

                  //버튼 클릭 시 동작
                  onPressed: () {
                    meal_application_cancel(context);
                  },
                  child: Text(
                    '신청 취소',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //신청완료 && 입금O인 경우
    else {
      return Scaffold(
        appBar: const BaseAppBar(title: '식수 신청'),
        drawer: const BaseDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //상단 겹쳐져 있는 바
              const SizedBox(
                height: 150.0,
                child: Stack(
                  children: [
                    BlueMainRoundedBox(),
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: WhiteMainRoundedBox(
                          iconData: Icons.campaign,
                          mainText: '현재 1학기 식수 신청 기간입니다.',
                          secondaryText: '신청기간 2024.02.20 ~ 2024.03.01',
                          actionText: '유형 외의 식사는 자유식 티켓을 구입해 주세요.',
                          timeText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //학생정보 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  '학생정보',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //학번 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('학번'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '2201333',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //이름 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('이름'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '김정원',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //전화번호 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('번호'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: const Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '010-6525-6480',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //신청 유형 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text('신청'),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '$meal_category',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //신청 현황 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  '신청 현황',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //입금 O 컨테이너
              Container(
                margin: EdgeInsets.all(10),
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 205, 205, 205),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_satisfied_alt,
                        color: Color.fromARGB(255, 29, 127, 159), size: 40),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '입금 확인이 완료 되었습니다.',
                      style:
                          TextStyle(color: Color.fromARGB(255, 29, 127, 159)),
                    ),
                    Text(
                      '감사합니다.',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 162, 162, 162),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  //신청 완료 alert
  Future<dynamic> meal_application(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.campaign,
          size: 50,
          color: const Color.fromARGB(255, 29, 127, 159),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '신청 완료되었습니다!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '3월 1일까지 입금해 주세요.',
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 29, 127, 159),
              ),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  //취소 질문 버튼
  Future<dynamic> meal_application_cancel(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.campaign,
          size: 50,
          color: const Color.fromARGB(255, 29, 127, 159),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '정말 취소 하시겠습니까?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/restaurant_main');
              setState(() {
                application = false;
                meal_category = '';
              });
            },
            child: Text('예'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('아니오'),
          ),
        ],
      ),
    );
  }

  //다 골라라 alert
  Future<dynamic> non_select(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.campaign,
          size: 50,
          color: const Color.fromARGB(255, 29, 127, 159),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '유형을 선택해주세요.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined))
        ],
      ),
    );
  }
}
