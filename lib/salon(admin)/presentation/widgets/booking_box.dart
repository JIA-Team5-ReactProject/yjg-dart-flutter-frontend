import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

enum BookingAction { confirm, reject }

class BookingBox extends StatelessWidget {
  final String bookText;
  final String time;

  const BookingBox({
    super.key,
    required this.bookText,
    required this.time,
  });

  void _showBookingActionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        BookingAction? _selectedAction = BookingAction.confirm; // 기본값 설정
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text(
                      '해당 예약건을 어떻게 하시겠습니까?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: const Text('승인하기'),
                    leading: Radio<BookingAction>(
                      value: BookingAction.confirm,
                      activeColor: Palette.mainColor,
                      groupValue: _selectedAction,
                      onChanged: (BookingAction? value) {
                        setState(() => _selectedAction = value);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('거절하기'),
                    leading: Radio<BookingAction>(
                      value: BookingAction.reject,
                      groupValue: _selectedAction,
                      onChanged: (BookingAction? value) {
                        setState(() => _selectedAction = value);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // 완료 버튼 로직
                        Navigator.pop(context);
                      },
                      child: Text(
                        '완료',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.mainColor,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBookingActionModal(context),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          margin: EdgeInsets.symmetric(vertical: 7.0),
          height: 70.0,
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Palette.backgroundColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bookText,
                style: TextStyle(color: Palette.textColor, fontSize: 15),
              ),
              Text(
                time,
                style: TextStyle(color: Palette.stateColor1, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
