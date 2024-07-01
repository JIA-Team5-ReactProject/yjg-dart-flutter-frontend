import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/auth/domain/usecases/register_usecase.dart";
import 'package:yjg/auth/presentation/viewmodels/email_viewmodel.dart';
import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
import "package:yjg/shared/theme/palette.dart";

class InternationalRegisteration extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCheckResult = ref.watch(emailStateProvider);

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
                child: Text(
                  'registration.description'.tr(),
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
                          labelText: "registration.form.name".tr(),
                          validatorText:
                              "registration.form.validatorText.name".tr(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        child: AuthTextFormField(
                          controller: emailController,
                          labelText: "registration.form.email".tr(),
                          validatorText:
                              "registration.form.validatorText.email".tr(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.check_circle_outline),
                            onPressed: () async {
                              final email =
                                  emailController.text; // 이메일 입력값 가져오기
                              if (email.isNotEmpty) {
                                // 이메일 필드가 비어있지 않을 때만 중복 검사 실행
                                bool emailCheckResult = await ref
                                    .read(emailStateProvider.notifier)
                                    .checkEmail(email);

                                if (!emailCheckResult) {
                                  ref
                                      .read(emailCheckSuccessStateProvider
                                          .notifier)
                                      .setEmailCheckSuccessStateNotifier(true);
                                  // 사용 가능한 이메일
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Palette.mainColor,
                                      content: Text(
                                          'registration.form.validatorText.emailNotExist'
                                              .tr()),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // 이미 사용중인 이메일
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          'registration.form.validatorText.emailExist'
                                              .tr()),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              } else {
                                // 필요한 경우 사용자에게 알림 표시
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'registration.form.validatorText.email'
                                            .tr()),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        // 중복 검사 결과 표시
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        child: AuthTextFormField(
                          controller: passwordController,
                          labelText: "registration.form.password".tr(),
                          validatorText:
                              "registration.form.validatorText.password".tr(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        child: AuthTextFormField(
                          controller: studentIdController,
                          labelText: "registration.form.studentNumber".tr(),
                          validatorText:
                              "registration.form.validatorText.studentNumber"
                                  .tr(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        child: AuthTextFormField(
                          controller: phoneNumberController,
                          labelText: "registration.form.phoneNumber".tr(),
                          validatorText:
                              "registration.form.validatorText.phoneNumber"
                                  .tr(),
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
                              bool emailCheckSuccess =
                                  ref.watch(emailCheckSuccessStateProvider);

                              debugPrint('체크:  $emailCheckSuccess');
                              if (!emailCheckSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'registration.form.validatorText.emailDuplicateCheck'
                                            .tr()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (emailCheckSuccess &&
                                  _formKey.currentState!.validate()) {
                                // Form이 유효한 경우에만 회원가입 로직 실행
                                final registerUseCase = RegisterUseCase(
                                    ref: ref); // RegisterUseCase 인스턴스 생성

                                // 전화번호 입력값에서 숫자만 추출
                                String phoneNumber = phoneNumberController.text
                                    .replaceAll(RegExp(r'[^\d]'), '');

                                // execute 메소드를 비동기적으로 호출하고, 사용자 입력을 전달
                                await registerUseCase.execute(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phoneNumber: phoneNumber,
                                  studentId: studentIdController.text,
                                  context: context,
                                );
                              } else {
                                // Form이 유효하지 않은 경우, 사용자에게 알림
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'registration.form.validatorText.formInvalid'
                                            .tr()),
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
                            child: Text(
                              'registration.form.registerButton'.tr(),
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
