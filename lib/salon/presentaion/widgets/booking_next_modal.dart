import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

void bookingNextModal(BuildContext context, String price) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(0),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 120,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'salon.salonBooking.stepOne.description2'.tr(),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        price,
                        style:
                            TextStyle(fontSize: 14.0, color: Palette.mainColor),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        backgroundColor: Palette.mainColor // 버튼 색상 지정
                        ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/salon_booking_step_two');
                    },
                    child: Text(
                      'salon.salonBooking.stepOne.nextButton'.tr(),
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
