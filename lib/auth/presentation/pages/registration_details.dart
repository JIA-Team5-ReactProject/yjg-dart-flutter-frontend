// import "package:flutter/material.dart";
// import "package:yjg/auth/domain/usecases/BirthDateInputFormatter.dart";
// import "package:yjg/auth/domain/usecases/PhoneNumberInpurtFormatter.dart";
// import "package:yjg/auth/presentation/widgets/auth_form_dropdown.dart";
// import "package:yjg/auth/presentation/widgets/auth_text_form_field.dart";
// import "package:yjg/shared/theme/theme.dart";

// class RegistrationDetails extends StatefulWidget {
//   const RegistrationDetails({super.key});

//   @override
//   _RegistrationDetails createState() => _RegistrationDetails();
// }

// class _RegistrationDetails extends State<RegistrationDetails> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController birthController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 80.0,
//               ),
//               Icon(
//                 Icons.error_outline_rounded,
//                 size: 50.0,
//                 color: Palette.mainColor,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                 child: const Text(
//                   '추가 정보를 입력해 주세요.',
//                   style: TextStyle(fontSize: 18.0, color: Palette.textColor),
//                 ),
//               ),

//               // 폼 시작
//               Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 16),
//                         child: AuthTextFormField(
//                           controller: nameController,
//                           labelText: "이름",
//                           validatorText: "이름을 입력해 주세요.",
//                         ),
//                       ),

//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 16),
//                         child: AuthTextFormField(
//                           controller: birthController,
//                           labelText: "생일",
//                           validatorText: "생일을 입력해 주세요.",
//                           inputFormatter: BirthDateInputFormatter(),
//                         ),
//                       ),
                      
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 8),
//                         child: AuthTextFormField(
//                           controller: phoneNumberController,
//                           labelText: "전화번호",
//                           validatorText: "전화번호를 입력해 주세요.",
//                           // inputFormatter: PhoneNumberInputFormatter(),
//                         ),
//                       ),
//                       Padding(padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 15),
//                         child: AuthFormDropDown(dropdownCategory: "성별"),
//                       ),
//                       Padding(padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 10),
//                         child: AuthFormDropDown(dropdownCategory: "학과"),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 22.0),
//                         child: SizedBox(
//                           width: double.infinity, // 버튼을 부모의 가로 길이만큼 확장
//                           child: ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 Navigator.pushNamed(context, '/login_domestic');
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content:
//                                           Text('입력되지 않은 필드가 있습니다. 다시 한 번 확인해 주세요.'),
//                                       backgroundColor: Palette.mainColor),
//                                 );
//                               }
//                             },
//                             style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.resolveWith<Color>(
//                                       (states) {
//                                 if (states.contains(MaterialState.pressed)) {
//                                   return Palette.mainColor.withOpacity(0.8);
//                                 }
//                                 return Palette.mainColor;
//                               }),
//                               foregroundColor:
//                                   MaterialStateProperty.resolveWith<Color>(
//                                       (states) {
//                                 if (states.contains(MaterialState.pressed)) {
//                                   return Colors.white.withOpacity(0.8);
//                                 }
//                                 return Colors.white;
//                               }),
//                               shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   side: BorderSide(color: Palette.mainColor),
//                                 ),
//                               ),
//                               fixedSize: MaterialStateProperty.all<Size>(
//                                   Size(100, 40)),
//                             ),
//                             child: const Text(
//                               '회원가입 완료',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//     );
//   }
// }
