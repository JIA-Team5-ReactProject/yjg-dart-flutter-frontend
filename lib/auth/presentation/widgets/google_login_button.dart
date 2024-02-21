import 'package:flutter/material.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/shared/theme/palette.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: OutlinedButton(
        onPressed: () async {
         await LoginDataSource().signInWithGoogle();
         
        },
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            BorderSide(width: 1.0, color: Palette.stateColor4.withOpacity(0.5)),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Palette.stateColor4.withOpacity(0.1); // 스플래시 색상 설정
              return null;
            },
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/google_logo.png', width: 15.0),
            const SizedBox(width: 20.0),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Text(
                '구글 아이디로 로그인하기',
                style: TextStyle(color: Palette.textColor, letterSpacing: -0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
