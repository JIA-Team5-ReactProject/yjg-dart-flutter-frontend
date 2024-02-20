import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/auth/domain/usecases/register_usecase.dart";
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/shared/theme/palette.dart";

class InternationalRegisteration extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80.0,
              ),
              Icon(
                Icons.error_outline_rounded,
                size: 50.0,
                color: Palette.mainColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: const Text(
                  '정보를 입력해 주세요.',
                  style: TextStyle(fontSize: 18.0, color: Palette.textColor),
                ),
              ),

              // 폼 시작
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        child: AuthTextFormField(
                          controller: nameController,
                          labelText: "이름",
                          validatorText: "이름을 입력해 주세요.",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        child: AuthTextFormField(
                          controller: emailController,
                          labelText: "이메일",
                          validatorText: "이메일을 입력해 주세요.",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        child: AuthTextFormField(
                          controller: passwordController,
                          labelText: "비밀번호",
                          validatorText: "비밀번호를 입력해 주세요.",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        child: AuthTextFormField(
                          controller: phoneNumberController,
                          labelText: "전화번호",
                          validatorText: "전화번호를 입력해 주세요.",
                          inputFormatter: PhoneNumberInputFormatter(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 22.0),
                        child: SizedBox(
                          width: double.infinity, // 버튼을 부모의 가로 길이만큼 확장

                          // 버튼
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Form이 유효한 경우에만 회원가입 로직 실행
                                final registerUseCase = RegisterUseCase(
                                    ref: ref); // RegisterUseCase 인스턴스 생성

                                // execute 메소드를 비동기적으로 호출하고, 사용자 입력을 전달
                                await registerUseCase.execute(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phoneNumber: phoneNumberController.text,
                                  context: context,
                                );
                              } else {
                                // Form이 유효하지 않은 경우, 사용자에게 알림
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        '입력되지 않은 필드가 있습니다. 다시 한 번 확인해 주세요.'),
                                    backgroundColor: Palette.mainColor,
                                  ),
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Palette.mainColor.withOpacity(0.8);
                                }
                                return Palette.mainColor;
                              }),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white.withOpacity(0.8);
                                }
                                return Colors.white;
                              }),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Palette.mainColor),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(100, 40)),
                            ),
                            child: const Text(
                              '회원가입',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
