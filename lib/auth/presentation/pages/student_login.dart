// 한국인 대상 로그인 페이지
import 'package:flutter/material.dart';
import 'package:yjg/auth/presentation/widgets/google_login_button.dart';
import 'package:yjg/auth/presentation/widgets/international_admin_login_form.dart';
import 'package:yjg/shared/theme/palette.dart';

class StudentLogin extends StatelessWidget {
  const StudentLogin({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    var fontSize = screenSize.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: width * 0.3, bottom: height * 0.02),
                child: Image(
                  image: AssetImage('assets/img/yju_tiger_logo.png'),
                  width: width * 0.2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.01),
                child: Image(
                    image: AssetImage('assets/img/yju_text_logo.png'),
                    width: width * 0.3),
              ),
              InternationalAdminLoginForm(studentOrAdmin: true),
              Padding(
                padding:
                    EdgeInsets.only(top: height * 0.001, bottom: height * 0.02),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/registration_international');
                  },
                  child: Text(
                    "계정이 없을 경우",
                    style: TextStyle(
                      color: Palette.mainColor,
                      fontSize: fontSize * 0.035,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.003),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login_admin');
                  },
                  child: Text(
                    "관리자 로그인으로 이동",
                    style: TextStyle(
                      color: Palette.stateColor4,
                      fontSize: fontSize * 0.035,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // 선
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.3, vertical: height * 0.02),
                child: Divider(
                  color: Palette.stateColor4.withOpacity(0.3),
                  thickness: 1.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.003),
                child: Text(
                  "학교 이메일이 있을 경우",
                  style: TextStyle(
                      color: Palette.textColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize * 0.035),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.02),
                child: GoogleLoginButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
