import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/auth/domain/usecases/reset_password_new_usecase.dart";
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/shared/theme/palette.dart";

class newPasswordUpdate extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

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
                  '새로운 비밀번호를 입력해 주세요.',
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
                          controller: passwordController,
                          labelText: "비밀번호",
                          validatorText: "새로운 비밀번호를 입력해 주세요.",
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
                                try {
                                  final resetPasswordNewUsecase =
                                      ResetPasswordNewUseCase(ref: ref);

                                  await resetPasswordNewUsecase.execute(
                                    newPassword: passwordController.text,
                                    context: context,
                                  );
                                } catch (e) {
                                  debugPrint('비밀번호 업데이트 실패: $e');
                                }
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
                              '비밀번호 변경',
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
