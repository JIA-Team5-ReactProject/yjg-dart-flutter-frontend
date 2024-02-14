import 'package:flutter/material.dart';

class MeetingRoomCard extends StatefulWidget {
  //룸 예약 가능 여부
  final bool room;

  //호실
  final String roomNumber;

  const MeetingRoomCard(
      {super.key, required this.room, required this.roomNumber});

  get onTap => null;

  @override
  State<MeetingRoomCard> createState() => _MeetingRoomCardState();
}

class _MeetingRoomCardState extends State<MeetingRoomCard> {
  @override
  Widget build(BuildContext context) {
    //예약 가능한 경우
    if (widget.room == true) {
      return Container(
        width: 120,
        height: 80,
        margin: EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 234, 234, 234)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // 원하는 둥글기를 입력하세요.
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.roomNumber,
                style: TextStyle(
                    color: const Color.fromARGB(255, 29, 127, 159),
                    fontSize: 15),
              ),
              Text(
                '예약가능',
                style: TextStyle(color: Colors.black, fontSize: 13),
              )
            ],
          ),
        ),
      );
    }

    //예약 불가능인 경우
    else {
      return Container(
        width: 120,
        height: 80,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 189, 189, 189),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [                
            Text(
              widget.roomNumber,
              style: TextStyle(
                  color: Color.fromARGB(255, 118, 139, 146), fontSize: 15),
            ),
            Text(
              '예약 불가능',
              style: TextStyle(color: const Color.fromARGB(255, 255, 0, 0), fontSize: 13),
            )
          ],
        ),
      );
    }
  }
}
