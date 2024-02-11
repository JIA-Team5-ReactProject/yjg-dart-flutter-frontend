import 'package:flutter/material.dart';
import 'package:yjg/salon/presentaion/widgets/booking_service_select.dart';
import 'package:yjg/shared/theme/palette.dart';

class BookingNextButton extends StatelessWidget {
  const BookingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookingServiceSelect()),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Palette.mainColor.withOpacity(0.8);
          }
          return Palette.mainColor; 
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.white.withOpacity(0.8);
          }
          return Colors.white; 
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Palette.mainColor), 
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(Size(100, 40)), 
      ),
      child: Text('다음'), 
    );
  }
}
