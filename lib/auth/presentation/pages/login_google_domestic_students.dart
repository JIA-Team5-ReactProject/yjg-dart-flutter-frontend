// 한국인 대상 로그인 페이지
import 'package:flutter/material.dart';
import 'package:yjg/auth/presentation/widgets/google_login_button.dart';
import 'package:yjg/shared/theme/palette.dart';

class LoginGoogleDomesticStudents extends StatelessWidget {
  const LoginGoogleDomesticStudents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 170.0, bottom: 20.0),
                child: Image(
                  image: AssetImage('assets/img/yju_tiger_logo.png'),
                  width: 120,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 100.0),
                child: Image(
                    image: AssetImage('assets/img/yju_text_logo.png'),
                    width: 130),
              ),
              Padding(
                padding: EdgeInsets.only(top: 150.0),
                child: GoogleLoginButton(),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamed(
                      context, '/login_international_admin'), // 외국인 학생 페이지로 이동
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    Palette.stateColor4.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  "외국인 학생 로그인으로 이동",
                  style: TextStyle(
                      color: Palette.mainColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
