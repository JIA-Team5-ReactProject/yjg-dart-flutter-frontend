import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/as(admin)/presentation/widgets/service_requester.dart';
import 'package:yjg/shared/widgets/as_comment_box.dart';
import 'package:yjg/shared/widgets/as_image_view.dart';
import 'package:yjg/as(admin)/presentation/widgets/as_notice_box.dart';
import 'package:intl/intl.dart';

class AsDetail extends StatefulWidget {
  const AsDetail({Key? key}) : super(key: key);

  @override
  State<AsDetail> createState() => _AsDetailState();
}

class _AsDetailState extends State<AsDetail> {
  bool _isEditing = false; // 수정 선택 여부
  TextEditingController _contentController = TextEditingController(); // 컨텐츠 컨트롤러
  String? _editedVisitDate; // 수정된 희망 처리일자를 저장하는 변수
  bool _isCommentsEmpty = true; // 댓글이 비어있는지 확인하는 변수, 초기값은 true

  static final storage = FlutterSecureStorage(); // 정원이가 말해준 코드(토큰)

  // API 함수(get으로 데이터 불러오기)
  Future<Map<String, dynamic>> fetchAsDetail(int id) async {
    final token = await storage.read(key: 'auth_token'); // 정원이가 말해준 코드(위에서 토큰 불러오기)
    final response = await http.get(
      Uri.parse('$apiURL/api/after-service/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // "after_service_comments" 배열이 비어 있는지 확인하여 _isCommentsEmpty 변수 업데이트
      _isCommentsEmpty = (data['afterService']['after_service_comments'] as List).isEmpty;
      return data;
    } else {
      throw Exception('에러(as_detail.dart GET 함수)');
    }
  }

  // API 함수 (PATCH로 데이터 통신)
  Future<void> updateAsDetail(int id, String content, String visitDate) async {
    final token = await storage.read(key: 'auth_token'); // 정원이가 말해준 코드(위에서 토큰 불러오기)
    final response = await http.patch(
      Uri.parse('$apiURL/api/after-service/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'content': content,
        'visit_date': visitDate, // 수정된 희망 처리일자 포함
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _isEditing = false; // 수정 완료 후 수정 모드 해제
      });
    } else {
      // 오류 처리
      print('에러(as_detail.dart PATCH 함수)');
    }
  }

  // API 함수 (DELETE 데이터 통신) 및 삭제 확인 대화상자 추가
  Future<void> deleteAsDetail(int id) async {
    // 삭제 확인 대화상자 표시
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('정말 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // '아니오' 선택 시 false 반환
              child: Text('아니오'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // '예' 선택 시 true 반환
              child: Text('예'),
            ),
          ],
        );
      },
    );

    // 사용자가 '예'를 선택한 경우에만 삭제 진행
    if (confirmDelete) {
      final token = await storage.read(key: 'auth_token'); // 정원이가 말해준 코드(위에서 토큰 불러오기)
      final response = await http.delete(
        Uri.parse('$apiURL/api/after-service/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // 삭제 성공 시 현재 페이지 닫기
      } else {
        print('에러(as_detail.dart DELETE 함수)'); // 오류 처리
      }
    }
  }

  // 임시 댓글 카운트
  final int? commentCount = 1;

  @override
  Widget build(BuildContext context) {
    // asCard에서 argument로 받아온 각 as목록의 ID
    final int asId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: BaseAppBar(title: 'AS관리'),
      drawer: const BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),

      // 수정, 삭제 버튼
      floatingActionButton: FutureBuilder<Map<String, dynamic>>(
        future: fetchAsDetail(asId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final asDetailData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 3.0), // 하단 간격
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                        // FutureBuilder의 snapshot.data를 사용하여 초기화
                        _contentController.text = asDetailData['afterService']['content'];
                        _editedVisitDate = asDetailData['afterService']['visit_date'];
                      });
                    },
                    child: Icon(Icons.edit, size: 20),
                    heroTag: 'editBtn',
                  ),
                  SizedBox(width: 5),
                  FloatingActionButton(
                    onPressed: () {
                      deleteAsDetail(asId);
                    },
                    child: Icon(Icons.delete, size: 20),
                    backgroundColor: Colors.red,
                    heroTag: 'deleteBtn',
                  ),
                ],
              ),
            );
          }
          return SizedBox(); // 데이터가 없을 경우 빈 위젯 반환
        },
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchAsDetail(asId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("에러(as_detail.dart)"));
          } else {
            final asDetail = snapshot.data!;
            DateTime createdAt = DateTime.parse(asDetail['afterService']['created_at']); // created_at 값을 DateTime 객체로
            String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(createdAt); // DateFormat으로 원하는 날짜 형식으로 변경
            final List<String> imageUrls = asDetail['afterService']['after_service_images']
                .map<String>((img) => img['image'] as String)
                .toList(); // as_image.view.dart에 이미지URL목록 넘겨주려고 API에서 이미지 URL 목록 뽑기

            return CustomSingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asDetail['afterService']['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                    ),
                    const SizedBox(height: 15.0),
                    const AsNoticeBox(),
                    ServiceRequester(
                      requester: asDetail['afterService']['user']['name'], // 신청자 이름
                      serviceLocation: asDetail['afterService']['visit_place'], // 처리장소
                      stateNum: asDetail['afterService']['status'], // 상태
                      phoneNumber: asDetail['afterService']['user']['phone_number'], // 전화번호
                      visitDate: asDetail['afterService']['visit_date'], // 희망처리일자
                      isEditing: _isEditing,
                      onVisitDateChanged: (newValue) {
                        _editedVisitDate = newValue;
                      },
                      isEditable: _isCommentsEmpty, // 댓글 배열이 비어있는 경우에만 수정 가능
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0, top: 50.0),
                      child: _isEditing
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextFormField(
                                  controller: _contentController,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: '내용 수정'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    updateAsDetail(asId, _contentController.text, _editedVisitDate ?? "");
                                  },
                                  child: Text('수정 완료'),
                                ),
                              ],
                            )
                          : Text(asDetail['afterService']['content']),
                    ),
                    Text(
                      "첨부파일(${asDetail['afterService']['after_service_images'].length})",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20.0),
                    AsImageView(imageUrls: imageUrls),
                    const SizedBox(height: 50.0),
                    Text(
                      "댓글($commentCount)",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const AsCommentBox(),
                    SizedBox(height: 60.0),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}