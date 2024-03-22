import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가

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

  // 날짜 선택 함수
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year, now.month, now.day);
    DateTime lastDate;

    if (now.month == 12) {
      // 현재가 12월인 경우, 다음 해의 1월의 마지막 날로 설정
      lastDate = DateTime(now.year + 1, 2, 0);
    } else {
      // 그 외의 경우, 다음 달의 마지막 날로 설정
      lastDate = DateTime(now.year, now.month + 2, 0);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        day_controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

// API 연동 함수
  Future<void> sendData() async {

    final token = await storage.read(key: 'auth_token'); //정원이가 말해준 코드(토큰 불러오기)
    
    var uri = Uri.parse('$apiURL/api/after-service');
    var request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title_controller.text
      ..fields['content'] = input_controller.text
      ..fields['visit_place'] = place_controller.text
      ..fields['visit_date'] = day_controller.text
      ..headers['Authorization'] = //아래에 토큰을 $token으로 바꿔줘야함
          'Bearer $token';

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
      print(respStr); // 응답 본문을 출력하여 세부 정보 확인
    } else {
      print('전송 실패: ${response.reasonPhrase}');
      print(respStr); // 오류 응답 본문을 출력하여 문제 진단
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
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                '제목',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            //제목 입력 칸
            Container(
              width: 380,
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
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                '희망 처리일자',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            //날짜 선택 칸
            InkWell(
              onTap: () {
                _selectDate(context); // 날짜 선택기를 호출
              },
              child: Container(
                width: 380,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.2,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // 텍스트를 왼쪽으로 정렬
                  children: [
                    SizedBox(width: 16), // 텍스트와 컨테이너 왼쪽 가장자리 사이의 공간
                    Text(
                      day_controller.text.isEmpty
                          ? '희망 처리일자를 선택해주세요'
                          : day_controller.text,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            //장소
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                '장소를 입력하세요',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            //장소 입력 칸
            Container(
              width: 380,
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
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                '내용',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            //내용 입력 칸
            Container(
              width: 380,
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
              onPressed: () {
                // 버튼을 눌렀을 때, 각 TextField의 텍스트를 가져와 변수에 저장
                title = title_controller.text;
                day = day_controller.text;
                input = input_controller.text;
                place = place_controller.text;
                sendData();
                show();
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

  //신청완료버튼 위젯
  void show() {
    if (title != '' && day != '' && place != '' && input != '') {
      showDialog(
        context: context,
        barrierDismissible: false, // 바깥 영역 클릭시 닫히지 않도록 설정
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('AS신청완료'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text('제목: $title'),
                  Text('날짜: $day'),
                  Text('장소: $place'),
                  Text('내용: $input'),
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                child: Text('확인'),
                onTap: () {
                  Navigator.pop(context); // 첫 번째 대화상자 닫기.
                  Navigator.pop(context); // 두 번째 신청 페이지 닫기.
                  Navigator.popAndPushNamed(context, '/as_page');
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('내용을 모두 입력해주세요'),
            actions: <Widget>[
              GestureDetector(
                child: Text('확인'),
                onTap: () {
                  Navigator.pop(context, '/as_page');
                },
              ),
            ],
          );
        },
      );
    }
  }
}
