import "package:flutter/material.dart";
import "package:yjg/auth/presentation/widgets/auth_text_button.dart";
import "package:yjg/auth/presentation/widgets/international_admin_login_form.dart";

class LoginStandardInternational extends StatelessWidget {
  const LoginStandardInternational({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 160.0, bottom: 20.0),
                child: Image(
                  image: AssetImage('assets/img/yju_tiger_logo.png'),
                  width: 120,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Image(
                    image: AssetImage('assets/img/yju_text_logo.png'),
                    width: 130),
              ),
              InternationalAdminLoginForm(),
              AuthTextButton(
                authText: "아이디가 아직 없을 경우",
                onPressed: () => {
                  Navigator.pushNamed(context, '/registration_international'),
                },
              ),
              AuthTextButton(
                authText: "구글 로그인으로 이동",
                onPressed: () => {
                  Navigator.pushNamed(context, '/login_domestic'),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
