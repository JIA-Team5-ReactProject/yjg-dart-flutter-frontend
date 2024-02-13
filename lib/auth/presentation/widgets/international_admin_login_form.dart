import "package:flutter/material.dart";
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/shared/theme/theme.dart";

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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 22.0),
              child: SizedBox(
                width: double.infinity, // 버튼을 부모의 가로 길이만큼 확장
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/dashboard_main');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('로그인에 실패하였습니다. 다시 시도해 주세요.'),
                            backgroundColor: Palette.mainColor),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Palette.mainColor.withOpacity(0.8);
                      }
                      return Palette.mainColor;
                    }),
                    foregroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
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
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
