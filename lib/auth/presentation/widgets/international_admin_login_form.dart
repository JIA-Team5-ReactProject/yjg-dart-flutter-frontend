import "package:flutter/material.dart";
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/auth/presentation/widgets/auto_login_check_box.dart";
import "package:yjg/auth/presentation/widgets/login_button.dart";
import "package:yjg/shared/theme/palette.dart";

class InternationalAdminLoginForm extends StatefulWidget {
  const InternationalAdminLoginForm({super.key, this.studentOrAdmin});
  final bool? studentOrAdmin; // 관리자 로그인일 경우 회원가입 안 보이게 하기 위한 변수

  @override
  _InternationalAdminLoginForm createState() => _InternationalAdminLoginForm();
}

class _InternationalAdminLoginForm extends State<InternationalAdminLoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var fontSize = screenSize.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: AuthTextFormField(
                controller: emailController,
                labelText: "이메일",
                validatorText: "이메일을 입력해 주세요.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: AuthTextFormField(
                controller: passwordController,
                labelText: "비밀번호",
                validatorText: "비밀번호를 입력해 주세요.",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoLoginCheckBox(),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset_password');
                    },
                    child: Text(
                      "비밀번호 찾기",
                      style: TextStyle(
                        color: Palette.mainColor,
                        fontSize: fontSize * 0.035,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: height * 0.01),
              child: SizedBox(
                width: double.infinity, // 버튼을 부모의 가로 길이만큼 확장
                child: LoginButton(
                  emailController: emailController,
                  passwordController: passwordController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
