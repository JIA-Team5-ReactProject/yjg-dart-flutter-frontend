import 'package:flutter/material.dart';
import 'package:yjg/common/blue_main_rounded_box.dart';
import 'package:yjg/common/white_main_rounded_box.dart';
import 'package:yjg/widgets/base_appbar.dart';
import 'package:yjg/widgets/base_drawer.dart';
import 'package:yjg/widgets/bottom_navigation_bar.dart';
import 'package:group_button/group_button.dart';

//선택 유형 담는 변수
var weekend = '';
var category = '';
var not_enough_person = '';

//신청 여부 확인 변수
var meal_weekend = false;
var meal_weekend_deposit = false;

class WeekendMeal extends StatefulWidget {
  const WeekendMeal({super.key});
  @override
  State<WeekendMeal> createState() => _WeekendMealState();
}

class _WeekendMealState extends State<WeekendMeal> {
  final controller = GroupButtonController();

  @override
  Widget build(BuildContext context) {
    
    //주말 식수 신청 x인 경우
    if (meal_weekend == false) {
      return Scaffold(
        appBar: BaseAppBar(title: '주말식수'),
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
                          iconData: Icons.restaurant,
                          mainText: '주말 식수 신청입니다.',
                          secondaryText: '신청기간 수요일 21시까지',
                          actionText: '신청 인원 50명 이상 시 식사 제공됩니다.',
                          timeText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //요일 선택 글자
              Container(
                margin: const EdgeInsets.all(25),
                child: const Text(
                  '요일 선택',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //요일 선택 버튼
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
                  selectedTextStyle:
                      TextStyle(fontSize: 16, color: Colors.white),
                  unselectedTextStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 29, 127, 159),
                  ),

                  //버튼 컬러
                  selectedColor: Color.fromARGB(255, 29, 127, 159),

                  //버튼 테두리
                  borderRadius: BorderRadius.all(Radius.circular(15)),

                  //버튼 간격
                  spacing: 10,

                  //버튼 크기
                  buttonHeight: 50,
                  buttonWidth: 120,
                ),
                isRadio: true,

                //버튼 클릭시 실행 되는 함수
                onSelected: (index, isSelected, isPressed) {
                  if (isSelected == 0) {
                    setState(() {
                      weekend = '토요일';
                    });
                  } else if (isSelected == 1) {
                    setState(() {
                      weekend = '일요일';
                    });
                  } else if (isSelected == 2) {
                    setState(() {
                      weekend = '토요일+일요일';
                    });
                  }
                },

                //버튼 내용
                buttons: ['토요일', '일요일', '토요일 + 일요일'],
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //식사 정보 글자
              Container(
                margin: const EdgeInsets.all(25),
                child: const Text(
                  '식사 정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //식사 정보 선택 버튼
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
                    fontSize: 16,
                    color: Color.fromARGB(255, 29, 127, 159),
                  ),
                  unselectedTextStyle: TextStyle(
                    fontSize: 16,
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
                    setState(() {
                      category = 'A유형';
                    });
                  } else if (isSelected == 1) {
                    setState(() {
                      category = 'B유형';
                    });
                  } else if (isSelected == 2) {
                    setState(() {
                      category = 'C유형';
                    });
                  }
                },

                //버튼 내용
                buttons: const [
                  'A유형\n점심+저녁\n\n750,000',
                  'B유형\n점심\n\n520,000',
                  'C유형\n저녁\n\n520,000'
                ],
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //인원 미충족 시 글자
              Container(
                margin: const EdgeInsets.all(25),
                child: const Text(
                  '인원 미충족 시',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //인원 미충족 시 버튼
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
                  selectedTextStyle:
                      TextStyle(fontSize: 16, color: Colors.white),
                  unselectedTextStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 29, 127, 159),
                  ),

                  //버튼 컬러
                  selectedColor: Color.fromARGB(255, 29, 127, 159),

                  //버튼 테두리
                  borderRadius: BorderRadius.all(Radius.circular(15)),

                  //버튼 간격
                  spacing: 10,

                  //버튼 크기
                  buttonHeight: 50,
                  buttonWidth: 120,
                ),
                isRadio: true,

                //버튼 클릭시 실행 되는 함수
                onSelected: (index, isSelected, isPressed) {
                  if (isSelected == 0) {
                    setState(() {
                      not_enough_person = '환불';
                    });
                  } else if (isSelected == 1) {
                    setState(() {
                      not_enough_person = '편의점 도시락';
                    });
                  }
                  ;
                },

                //버튼 내용
                buttons: [
                  '환불',
                  '편의점 도시락',
                ],
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //계좌 정보 글자
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: const Text(
                  '계좌 정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //수요일 ~ 글자
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                child: const Text(
                  '수요일 21:00까지 입금 완료',
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
                  onPressed: () {
                    weekend_application(context);
                    setState(() {
                      meal_weekend = true;
                    });
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

    //주말 식수 신청 O 결제 X인 경우
    else if (meal_weekend = true && meal_weekend_deposit == false){
      return Scaffold(
        appBar: BaseAppBar(title: '주말식수'),
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
                          iconData: Icons.restaurant,
                          mainText: '주말 식수 신청입니다.',
                          secondaryText: '신청기간 수요일 21시까지',
                          actionText: '신청 인원 50명 이상 시 식사 제공됩니다.',
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
                            '$weekend'' | ''$category' ' | ' '$not_enough_person',
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
                      '수요일 21시까지 입금해주세요',
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
                    meal_cancel(context);
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

    //주말 식수 신청 O 결제 O인 경우
    else {
      return Scaffold(
        appBar: BaseAppBar(title: '주말식수'),
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
                          iconData: Icons.restaurant,
                          mainText: '주말 식수 신청입니다.',
                          secondaryText: '신청기간 수요일 21시까지',
                          actionText: '신청 인원 50명 이상 시 식사 제공됩니다.',
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
                            '$weekend'' | ''$category' ' | ' '$not_enough_person',
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


  //신청 alert
  Future<dynamic> weekend_application(BuildContext context) {
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
             SizedBox(
              height: 25,
            ),
            Text(
              '신청이 완료 되었습니다.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
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

  //취소 alert
  Future<dynamic> meal_cancel(BuildContext context) {
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
              Navigator.popAndPushNamed(context,'/restaurant_main');
              setState(() {
                meal_weekend= false;
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
}
