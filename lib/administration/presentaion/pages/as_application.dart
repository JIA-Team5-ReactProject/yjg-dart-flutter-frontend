import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';

class AsApplication extends StatefulWidget {
  const AsApplication({super.key});

  @override
  State<AsApplication> createState() => _AsApplicationState();
}

class _AsApplicationState extends State<AsApplication> {
  List<XFile> _images = []; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _images.add(XFile(pickedFile.path)); //가져온 이미지를 _images에 저장
      });
    }
  }

  // 제목 텍스트 컨트롤러를 생성 (TextFiled의 내용 접근을 위해서)
  final TextEditingController title_controller = TextEditingController();
  //제목 담는 변수
  String title = '';

  // 날짜 텍스트 컨트롤러를 생성 (TextFiled의 내용 접근을 위해서)
  final TextEditingController day_controller = TextEditingController();
  //날짜 담는 변수
  String day  = '';

  //장소 텍스트 컨트롤러를 생성 (TextFiled의 내용 접근을 위해서)
  final TextEditingController place_controller = TextEditingController();
  //장소 담는 변수
  String place  = '';

  // 내용 텍스트 컨트롤러를 생성 (TextFiled의 내용 접근을 위해서)
  final TextEditingController input_controller = TextEditingController();
  //내용 담는 변수
  String input  = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: 'AS요청'),
      drawer: const BaseDrawer(),
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

            //날짜 입력 칸
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
                controller: day_controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0000-00-00',
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
                  Navigator.popAndPushNamed(context, '/as_page');
                },
              ),
            ],
          );
        },
      );
    }
    else {
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
