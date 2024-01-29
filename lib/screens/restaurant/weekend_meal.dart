import 'package:flutter/material.dart';
import 'package:yjg/widgets/base_appbar.dart';
import 'package:yjg/widgets/bottom_navigation_bar.dart';
import 'package:group_button/group_button.dart';

class WeekendMeal extends StatefulWidget {
  const WeekendMeal({super.key});

  @override
  State<WeekendMeal> createState() => _WeekendMealState();
}

class _WeekendMealState extends State<WeekendMeal> {
  final controller = GroupButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: '주말식수'),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //파란 상자
            Container(
              height: 100,
              color: Color.fromARGB(255, 29, 127, 159),
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
                selectedTextStyle: TextStyle(fontSize: 16, color: Colors.white),
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
              onSelected: (index, isSelected, isPressed) => () {},

              //버튼 내용
              buttons: ['토요일', '일요일', '토요일 + 일요일'],
            ),

            //구분 점선
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Text(
                  '............................................................................................',
                  style: TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
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
              onSelected: (index, isSelected, isPressed) => () {},

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
                  style: TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
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
                selectedTextStyle: TextStyle(fontSize: 16, color: Colors.white),
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
              onSelected: (index, isSelected, isPressed) => () {},

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
                  style: TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
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
                      borderRadius: BorderRadius.circular(15), // 둥글기 정도를 조절하는 값
                    ),
                  ),
                ),
                onPressed: () {},
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
}
