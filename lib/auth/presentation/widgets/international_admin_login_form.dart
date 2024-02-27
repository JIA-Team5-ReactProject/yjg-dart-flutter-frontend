import "package:flutter/material.dart";
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/auth/presentation/widgets/auto_login_check_box.dart";
import "package:yjg/auth/presentation/widgets/login_button.dart";

class InternationalAdminLoginForm extends StatefulWidget {
  const InternationalAdminLoginForm({super.key});

  @override
  _InternationalAdminLoginForm createState() => _InternationalAdminLoginForm();
}

class _InternationalAdminLoginForm extends State<InternationalAdminLoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
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
            AutoLoginCheckBox(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
              child: SizedBox(
                width: double.infinity, // 버튼을 부모의 가로 길이만큼 확장
                child: LoginButton(
                  emailController: emailController,
                  passwordController: passwordController,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
