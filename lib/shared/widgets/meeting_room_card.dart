import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

class MeetingRoomCard extends StatelessWidget {
  final String roomNumber;
  final String reservationDate;
  final String startTime;
  final String endTime;
  final int status;
  final int reservationId; // 예약 ID를 위한 새로운 필드
  final VoidCallback onTap; // 카드 탭 콜백

  const MeetingRoomCard({
    Key? key,
    required this.roomNumber,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.reservationId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // startTime에서 '시:분' 부분만 추출
    String formattedStartTime = startTime.split(":").sublist(0, 2).join(":");

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
        height: 85.0,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white, //color: Palette.mainColor
            side: BorderSide(
              color: status == 1 ?Palette.mainColor : Colors.red.withOpacity(0.5),
              width: 3.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: onTap,
          child: Row(
            children: [
              Icon(Icons.meeting_room_rounded,size: 40, color: status == 1 ? Palette.mainColor : Colors.red),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('B동 ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
                        Text(roomNumber, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
                        Text('호', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black))
                      ],
                    ),
                    Row(
                      children: [
                        Text(reservationDate,style: TextStyle(color: Colors.black),),
                        Text(' / ',style: TextStyle(color: Colors.black),),
                        Text("$formattedStartTime ~ ${endTime.split(":")[0]}:59",style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                status == 1 ? '수락' : '거절',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status == 1 ? Colors.blue : Colors.red, // 상태에 따라 색상 변경
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}