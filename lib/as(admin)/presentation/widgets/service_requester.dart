import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yjg/shared/theme/theme.dart';

class ServiceRequester extends StatefulWidget {
  final String requester; // 신청자 이름
  final String serviceLocation; // 위치
  final int stateNum; // 상태
  final String phoneNumber; // 전화번호
  final String visitDate; // 희망처리일자
  final bool isEditing; // 수정 모드 여부
  final Function(String) onVisitDateChanged; // 희망 처리일자 변경 시 호출할 콜백 함수
  final bool isEditable; // 수정 가능 여부

  ServiceRequester({
    required this.requester, // 신청자 이름
    required this.serviceLocation, // 위치
    required this.stateNum, // 상태
    required this.phoneNumber, // 전화번호
    required this.visitDate, // 희망처리일자
    this.isEditing = false, // 수정모드 여부 기본값은 false
    required this.onVisitDateChanged, // 희망 처리일자 변경 콜백 함수
    this.isEditable = true, // 기본값은 true로 설정
  });

  @override
  _ServiceRequesterState createState() => _ServiceRequesterState();
}

class _ServiceRequesterState extends State<ServiceRequester> {
  late String _formattedVisitDate; // 사용자가 선택한 날짜를 문자열로 저장

  @override
  void initState() {
    super.initState();
    _formattedVisitDate = widget.visitDate; // 초기값 설정
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          children: [
            SizedBox(height: 15.0),
            Row(
              children: [
                Text(
                  '신청자',
                  style: TextStyle(
                    color: Palette.textColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 50.0),
                Text(widget.requester),
              ],
            ),
            Row(
              children: [
                Text(
                  '전화번호',
                  style: TextStyle(
                    color: Palette.textColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 38.0),
                Text(formatPhoneNumber(widget.phoneNumber)),
              ],
            ),
            Row(
              children: [
                Text(
                  '위치',
                  style: TextStyle(
                    color: Palette.textColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 63.0),
                Text(widget.serviceLocation),
              ],
            ),
            Row(
              children: [
                Text(
                  '희망처리일자',
                  style: TextStyle(
                    color: Palette.textColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 13.0),
                widget.isEditing && widget.isEditable // isEditable 조건 추가
                    ? GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(), // 오늘 이후의 날짜만 선택 가능
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _formattedVisitDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              widget.onVisitDateChanged(_formattedVisitDate);
                            });
                          }
                        },
                        child: Text(
                          _formattedVisitDate,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    : Text(_formattedVisitDate),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '관리자 확인 전까지는 수정 가능',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  '상태',
                  style: TextStyle(
                    color: Palette.textColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 63.0),
                Text(
                  widget.stateNum == 0 ? '처리전' : '처리완료',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    color: widget.stateNum == 0
                        ? Palette.stateColor3
                        : Palette.stateColor1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  // 전화번호 000-0000-0000형식으로 보여주게 하는 함수 (11자리가 아닌 경우 원래 형식대로 반환)
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      return '${phoneNumber.substring(0, 3)} - ${phoneNumber.substring(3, 7)} - ${phoneNumber.substring(7, 11)}';
    }
    return phoneNumber;
  }
}
