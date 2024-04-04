import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/theme/theme.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가

DateTime _focusedDay = DateTime.now();
DateTime? _selectedDay;

class AsApplication extends StatefulWidget {
  const AsApplication({super.key});

  @override
  State<AsApplication> createState() => _AsApplicationState();
}

class _AsApplicationState extends State<AsApplication> {
  List<XFile> _images = []; //이미지를 담을 변수 선언

  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  static final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    debugPrint(pickedFile!.path);
    if (pickedFile != null) {
      setState(() {
        _images.add(XFile(pickedFile.path)); //가져온 이미지를 _images에 저장
      });
    }
  }

  // 선택한 정보 보내주는 POST API 함수
  Future<bool> sendData() async {
    final token = await storage.read(key: 'auth_token'); // 토큰 불러오기

    var uri = Uri.parse('$apiURL/api/after-service');
    var request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['content'] = input
      ..fields['visit_place'] = place
      ..fields['visit_date'] = day
      ..headers['Authorization'] = 'Bearer $token';

    // 이미지 파일을 요청에 추가
    for (var image in _images) {
      request.files
          .add(await http.MultipartFile.fromPath('images[]', image.path));
    }

    // 요청 전송 및 응답 처리
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('성공적으로 전송됨');
      print(respStr);
      return true; // 성공 시 true 반환
      
    } else {
      print('전송 실패: ${response.reasonPhrase}');
      print("이거이거이거: $day");
      print(respStr);
      return false; // 실패 시 false 반환
    }
  }

  // 제목 텍스트 컨트롤러를 생성 (TextFiled의 내용 접근을 위해서)
  final TextEditingController title_controller = TextEditingController();
  //제목 담는 변수
  String title = '';

  // 날짜 텍스트 컨트롤러를 생성 (TextFiled의 내용 접근을 위해서)
  final TextEditingController day_controller = TextEditingController();
  //날짜 담는 변수
  String day = '';

  //장소 텍스트 컨트롤러를 생성 (TextFiled의 내용 접근을 위해서)
  final TextEditingController place_controller = TextEditingController();
  //장소 담는 변수
  String place = '';

  // 내용 텍스트 컨트롤러를 생성 (TextFiled의 내용 접근을 위해서)
  final TextEditingController input_controller = TextEditingController();
  //내용 담는 변수
  String input = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: 'AS요청'),
      drawer: BaseDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),

            //제목
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, top: 20),
              child: Text(
                '제목',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            //제목 입력 칸
            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 화면 너비의 90%로 설정
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.2, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 226, 226, 226)
                        .withOpacity(0.5), // 그림자 색상
                    spreadRadius: 1, // 그림자 확산 반경
                    blurRadius: 5, // 그림자 흐림 정도
                    offset: Offset(2, 3), // 그림자 위치
                  ),
                ],
              ),
              child: TextField(
                controller: title_controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '제목을 입력하세요',
                  contentPadding: EdgeInsets.only(left: 16),
                ),
              ),
            ),

            //날짜
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, top: 20),
              child: Text(
                '희망 처리일자',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            // 날짜 선택 칸
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.2, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 226, 226, 226)
                        .withOpacity(0.5), // 그림자 색상
                    spreadRadius: 1, // 그림자 확산 반경
                    blurRadius: 5, // 그림자 흐림 정도
                    offset: Offset(2, 3), // 그림자 위치
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 20), // 좌우 여백
              child: TableCalendar(
                locale: 'ko_KR',
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 30)),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    day_controller.text =
                        DateFormat('yyyy-MM-dd').format(selectedDay);
                  });
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true, // 제목 가운데 정렬
                  formatButtonShowsNext: false,
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false, // 현재 달의 날짜만 표시
                  selectedDecoration: BoxDecoration(
                    // 선택된 날짜 스타일
                    color: Palette.mainColor, // 선택된 날짜의 배경 색상
                    shape: BoxShape.circle, // 원형 표시
                  ),
                  todayDecoration: BoxDecoration(
                    // 오늘 날짜 스타일
                    color: const Color.fromARGB(255, 128, 128, 128)
                        .withOpacity(0.5), // 오늘 날짜의 배경 색상 (투명도 포함)
                    shape: BoxShape.circle, // 원형 표시
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black),
                  weekendStyle: TextStyle(color: Colors.red),
                ),
              ),
            ),

            //장소
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, top: 20),
              child: Text(
                '장소를 입력하세요',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            //장소 입력 칸
            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 화면 너비의 90%로 설정
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.2, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 226, 226, 226)
                        .withOpacity(0.5), // 그림자 색상
                    spreadRadius: 1, // 그림자 확산 반경
                    blurRadius: 5, // 그림자 흐림 정도
                    offset: Offset(2, 3), // 그림자 위치
                  ),
                ],
              ),
              child: TextField(
                controller: place_controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'ex) B동 000호',
                  contentPadding: EdgeInsets.only(left: 16),
                ),
              ),
            ),

            //내용
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, top: 20),
              child: Text(
                '내용',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            //내용 입력 칸
            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 화면 너비의 90%로 설정
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.2, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 226, 226, 226)
                        .withOpacity(0.5), // 그림자 색상
                    spreadRadius: 1, // 그림자 확산 반경
                    blurRadius: 5, // 그림자 흐림 정도
                    offset: Offset(2, 3), // 그림자 위치
                  ),
                ],
              ),
              child: TextField(
                controller: input_controller,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '입력하세요',
                  contentPadding: EdgeInsets.only(left: 16),
                ),
              ),
            ),

            SizedBox(
              height: 15,
            ),

            //사진 보여주는 곳
            _buildPhotoArea(),

            //사진 추가 버튼
            _buildButton(),

            SizedBox(
              height: 20,
            ),

            //작성완료 버튼
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      const Color.fromARGB(255, 29, 127, 159))),
              onPressed: () async {
                title = title_controller.text;
                day = day_controller.text;
                input = input_controller.text;
                place = place_controller.text;

                setState(() {
                  _selectedDay = null;
                  _focusedDay = DateTime.now();
                  day_controller.clear();
                });

                bool success = await sendData();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('AS 요청이 성공적으로 전송되었습니다.')));
                  Navigator.pop(context, true);
                  Navigator.popAndPushNamed(context, '/as_page');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('AS 요청 전송에 실패했습니다.')));
                }
              },
              child: Text(
                '요청하기',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    if (_images.isNotEmpty) {
      return Container(
        margin: EdgeInsets.all(10),
        height: 200,
        width: 380,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // 가로 스크롤 추가
          itemCount: _images.length, // 이미지 개수만큼 아이템 생성
          itemBuilder: (context, index) {
            return Image.file(File(_images[index].path)); // 각 이미지를 화면에 띄움
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  //사진 추가 버튼 위젯
  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  const Color.fromARGB(255, 29, 127, 159))),
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  const Color.fromARGB(255, 29, 127, 159))),
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Icon(Icons.collections, color: Colors.white),
        ),
      ],
    );
  }
}
