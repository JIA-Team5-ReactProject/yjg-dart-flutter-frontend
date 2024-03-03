import "package:flutter/material.dart";
import "package:yjg/auth/presentation/widgets/auth_text_button.dart";
import "package:yjg/auth/presentation/widgets/international_admin_login_form.dart";
import "package:yjg/shared/theme/theme.dart";

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

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
                padding: EdgeInsets.only(top: width * 0.3, bottom: height * 0.02),
                child: Image(
                  image: AssetImage('assets/img/yju_tiger_logo.png'),
                  width: width * 0.2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.05),
                child: Image(
                    image: AssetImage('assets/img/yju_text_logo.png'),
                    width: width * 0.3),
              ),
              Text('모바일 어플에서는 관리자 회원가입을 지원하지 않습니다.', style: TextStyle(color: Palette.textColor.withOpacity(0.8), fontSize: fontSize * 0.035),),
              InternationalAdminLoginForm(),
              AuthTextButton(
                authText: "학생 로그인으로 이동",
                onPressed: () => {
                  Navigator.pushNamed(context, '/login_student'),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
