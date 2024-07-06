import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/restaurant/data/data_sources/meal_reservation_data_source.dart';
import 'package:yjg/restaurant/data/data_sources/semester_meal_reservation_data_source.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';

// 신청 여부 확인 변수
var application = false;

// 입금 여부 확인 변수
var deposit = false;

class MealApplication extends ConsumerStatefulWidget {
  const MealApplication({super.key});

  @override
  ConsumerState<MealApplication> createState() => _MealApplicationState();
}

class _MealApplicationState extends ConsumerState<MealApplication> {
  // 선택된 식사 유형 ID를 추적하는 변수 (버튼에서 선택 된 유형을 말하는 거임)
  String? selectedMealTypeId;

  //신청한 식수의 ID를 담는 변수
  int? applicationId;

  // 사용자 정보를 보여주는 위젯 (학번, 이름, 전화번호 등)
  Widget userInfoContainer(String title, String content) {
    return UserInfoContainer(title: title, content: content);
  }

  // 구분선 위젯
  Widget dottedLineSeparator() {
    return const DottedLineSeparator();
  }

  // 버튼 위젯
  Widget customElevatedButton(
      String text, Color color, VoidCallback onPressed) {
    return CustomElevatedButton(text: text, color: color, onPressed: onPressed);
  }

  final _semesterReservationDataSource = SemesterMealReservationDataSource();
  final _reservationDataSource = MealReservationDataSource();

  // 사용자 정보를 저장할 변수
  Map<String, dynamic> userData = {};

  // 버튼에 넣어줄 식수 유형의 정보를 저장할 변수
  List<dynamic> semesterMealTypes = [];

  //get 함수로 불러온 계좌번호 데이터를 저장할 변수들
  String bankName = '';
  String accountNumber = '';
  String accountHolder = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // 사용자 정보를 가져오는 메서드 호출
    fetchMealTypes(); // 식수 유형의 정보를 가져오는 메서드 호출
    fetchApplicationStatus(); // API로부터 식수 신청 상태를 가져오는 메서드
    fetchAccountData(); // 위젯 초기화 시 계좌번호 데이터를 가져오는 함수 호출
  }

  // * 사용자 정보를 가져오는 API 함수
  Future<void> fetchUserInfo() async {
    try {
      final response = await _semesterReservationDataSource.fetchUserInfo();
      final data = response.data as Map<String, dynamic>;
      setState(() {
        userData = data['userData'];
      });
    } catch (e) {
      debugPrint('사용자 정보 불러오기 실패: $e');
    }
  }

  // * 식수 유형의 정보를 가져오는 API 함수
  Future<void> fetchMealTypes() async {
    try {
      final response = await _semesterReservationDataSource.fetchMealTypes();
      final data = response.data as Map<String, dynamic>;
      setState(() {
        semesterMealTypes = data['semester_meal_type']; // 데이터 업데이트
      });
    } catch (e) {
      debugPrint('식사 유형 불러오기 실패: $e');
    }
  }

  // * 식수 신청을 하는 API 함수
  Future<void> submitMealApplication(String mealType) async {
    try {
      await _semesterReservationDataSource.submitMealApplication(mealType);
      // 신청 후 상태를 다시 가져와서 화면을 업데이트
      await fetchApplicationStatus();
      debugPrint('$mealType 유형으로 신청 완료');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('restaurant.submit.success'.tr()),
          backgroundColor: Palette.mainColor,
        ),
      );
    } catch (e) {
      debugPrint('식수 신청 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('restaurant.submit.failure'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // * 식수 신청 상태를 가져오는 API 함수
  Future<void> fetchApplicationStatus() async {
    try {
      final response =
          await _semesterReservationDataSource.fetchApplicationStatus();
      final data = response.data;
      final List<dynamic> applicationData = data['userData']['data'];

      setState(() {
        application = applicationData.isNotEmpty;
        if (applicationData.isNotEmpty) {
          applicationId = applicationData[0]['id']; // 신청 ID를 저장

          selectedMealTypeId =
              applicationData[0]['semester_meal_type']?['meal_type'];
          deposit = applicationData[0]['payment'] == 1;
        } else {
          selectedMealTypeId = null;
          applicationId = null; // 신청이 없을 경우 null로 설정
        }
      });
    } catch (e) {
      debugPrint('식수 신청 상태 불러오기 실패: $e');
    }
  }

  // 식수 신청을 취소하는 API 함수
  Future<void> cancelMealApplication() async {
    if (applicationId == null) {
      debugPrint("application id가 없습니다.");
    }

    try {
      await _semesterReservationDataSource
          .cancelMealApplication(applicationId!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('restaurant.cancel.success'.tr()),
          backgroundColor: Palette.mainColor,
        ),
      );
      await fetchApplicationStatus(); // 상태를 다시 가져와 화면을 업데이트
    } catch (e) {
      debugPrint('식수 신청 취소 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('restaurant.cancel.failure'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //계좌 번호 데이터를 불러오는 GET API 함수
  Future<void> fetchAccountData() async {
    try {
      final response = await _reservationDataSource.fetchAccountData();
      final data = response.data['data'];

      setState(() {
        bankName = data['bank_name'];
        accountNumber = data['account'];
        accountHolder = data['name'];
      });
    } catch (e) {
      debugPrint('계좌 정보를 불러오는 데 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    //신청 x인 경우
    if (application == false) {
      return Scaffold(
        appBar: BaseAppBar(title: 'restaurant.title.0.4'.tr()),
        drawer: BaseDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: CustomSingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150.0,
                child: Stack(
                  children: [
                    const BlueMainRoundedBox(),
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: WhiteMainRoundedBox(
                          iconData: Icons.campaign,
                          mainText: 'restaurant.application.period'.tr(),
                          secondaryText: 'restaurant.application.notice'.tr(),
                          actionText: '',
                          timeText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 학생정보 글자
              Container(
                margin: const EdgeInsets.all(15),
                child: Text(
                  'restaurant.student.info'.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              // 학번, 이름, 번호 컨테이너
              userInfoContainer(
                  'restaurant.weekendapp.3'.tr(), userData['name'] ?? 'none'),
              userInfoContainer('restaurant.weekendapp.2'.tr(),
                  userData['student_id'] ?? 'none'),
              userInfoContainer('restaurant.weekendapp.4'.tr(),
                  formatPhoneNumber(userData['phone_number'])),

              dottedLineSeparator(),

              // 식사정보 글자
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  'restaurant.meal.info'.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              // 기간 산정 금액 글자
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'restaurant.meal.period'.tr(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 29, 127, 159),
                      ),
                    ),
                    Text(
                      'restaurant.meal.amount'.tr(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 120, 120, 120),
                      ),
                    ),
                  ],
                ),
              ),

              // 유형 선택 버튼
              Wrap(
                spacing: 8.0, // 버튼 사이의 가로 간격
                runSpacing: 8.0, // 버튼 사이의 세로 간격
                children: semesterMealTypes.map((type) {
                  bool isSelected = selectedMealTypeId == type['meal_type'];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : const Color.fromARGB(
                              255, 255, 255, 255), // 선택된 버튼은 파란색, 그 외는 흰색
                      foregroundColor: isSelected
                          ? Colors.white
                          : Colors.black, // 선택된 버튼의 텍스트 색상은 흰색, 그 외는 검은색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                            color: isSelected
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(255, 255, 255,
                                    255)), // 선택된 버튼은 파란색 테두리, 그 외는 기본 색상
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedMealTypeId = type['meal_type'];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${type['meal_type']}\n",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: "${type['content']}\n",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                            TextSpan(
                              text: "${type['price']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Palette.mainColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              dottedLineSeparator(),

              // 계좌 정보 글자
              const Text(
                'restaurant.account.info',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ).tr(),

              // 입금 기간 글자
              const Text(
                'restaurant.account.period',
                style: TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 168, 168, 168)),
              ).tr(),

              // 계좌번호 박스
              Container(
                alignment: Alignment.center,
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 168, 168, 168),
                  ),
                ),
                child: Text(
                  '$bankName  $accountNumber $accountHolder',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // 신청 버튼
              customElevatedButton('restaurant.submit.button'.tr(),
                  const Color.fromARGB(255, 29, 127, 159), () async {
                if (selectedMealTypeId != null) {
                  await submitMealApplication(selectedMealTypeId!); // 알파벳을 전달
                } else {
                  non_select(context); // 사용자에게 식사 유형을 선택하라는 메시지를 보여줌
                }
              }),
            ],
          ),
        ),
      );
    }

    //신청 O 결제 x인 경우
    else if (application == true && deposit == false) {
      return Scaffold(
        appBar: BaseAppBar(title: 'restaurant.title.0.4'.tr()),
        drawer: BaseDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 상단 겹쳐져 있는 바, 학생정보 글자, 학번, 이름, 번호 컨테이너
              ...topSection(),
              userInfoContainer(
                  'restaurant.weekendapp.3'.tr(), userData['name'] ?? '정보 없음'),
              userInfoContainer('restaurant.weekendapp.2'.tr(),
                  userData['student_id'] ?? '정보 없음'),
              userInfoContainer('restaurant.weekendapp.4'.tr(),
                  formatPhoneNumber(userData['phone_number'])),
              userInfoContainer(
                'restaurant.application.status'.tr(),
                '$selectedMealTypeId',
              ),
              dottedLineSeparator(),

              // 신청 현황 글자
              Text(
                'restaurant.application.status1'.tr(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              // 입금 X 컨테이너
              Container(
                margin: const EdgeInsets.all(10),
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 205, 205, 205),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sentiment_very_dissatisfied,
                        color: Colors.red, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      'restaurant.payment.reminder'.tr(),
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text(
                      '$bankName  $accountNumber $accountHolder',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 162, 162, 162),
                      ),
                    )
                  ],
                ),
              ),

              // 신청 취소 버튼
              customElevatedButton('restaurant.cancel.button'.tr(),
                  const Color.fromARGB(255, 159, 29, 29), () {
                meal_application_cancel(context);
              }),
            ],
          ),
        ),
      );
    }

    //신청 O 결제 O인 경우
    else {
      return Scaffold(
        appBar: BaseAppBar(title: 'restaurant.title.0.4'.tr()),
        drawer: BaseDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 상단 겹쳐져 있는 바, 학생정보 글자, 학번, 이름, 번호 컨테이너
              ...topSection(),
              userInfoContainer(
                  'restaurant.weekendapp.3'.tr(), userData['name'] ?? '정보 없음'),
              userInfoContainer('restaurant.weekendapp.2'.tr(),
                  userData['student_id'] ?? '정보 없음'),
              userInfoContainer('restaurant.weekendapp.4'.tr(),
                  formatPhoneNumber(userData['phone_number'])),
              userInfoContainer(
                  'restaurant.application.status'.tr(), '$selectedMealTypeId'),
              dottedLineSeparator(),

              // 신청 현황 글자
              Text(
                'restaurant.application.status1'.tr(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              // 입금 O 컨테이너
              Container(
                margin: const EdgeInsets.all(10),
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 205, 205, 205),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sentiment_satisfied_alt,
                        color: Color.fromARGB(255, 29, 127, 159), size: 40),
                    const SizedBox(height: 10),
                    Text(
                      'restaurant.payment.confirmation'.tr(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 29, 127, 159)),
                    ),
                    Text(
                      'restaurant.payment.thankyou'.tr(),
                      style: TextStyle(
                        color: Color.fromARGB(255, 162, 162, 162),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  //상단 정보 컨테이너
  List<Widget> topSection() {
    return [
      SizedBox(
        height: 150.0,
        child: Stack(
          children: [
            const BlueMainRoundedBox(),
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: WhiteMainRoundedBox(
                  iconData: Icons.campaign,
                  mainText: 'restaurant.application.period'.tr(),
                  secondaryText: 'restaurant.application.notice'.tr(),
                  actionText: '',
                  timeText: '',
                ),
              ),
            ),
          ],
        ),
      ),
      Text(
        'restaurant.student.info'.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ];
  }

  // 다 골라라 alert
  Future<dynamic> non_select(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.campaign,
          size: 50,
          color: Color.fromARGB(255, 29, 127, 159),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'restaurant.non_select.message',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ).tr(),
            SizedBox(height: 25),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.cancel_outlined),
          )
        ],
      ),
    );
  }

  //신청 시 ALERT창
  Future<dynamic> meal_application(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.campaign,
          size: 50,
          color: Color.fromARGB(255, 29, 127, 159),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 25),
            Text(
              'restaurant.submit.alert',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ).tr(),
            const SizedBox(height: 10),
            const SizedBox(height: 25),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // 유저 데이터 불러오는 함수 다시 호출해서 화면 업데이트
              await fetchUserInfo();
            },
            child: Text('restaurant.submit.confirm').tr(),
          ),
        ],
      ),
    );
  }

  // 신청 취소 질문 버튼
  Future<dynamic> meal_application_cancel(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.campaign,
          size: 50,
          color: Color.fromARGB(255, 29, 127, 159),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'restaurant.cancel.confirm.message',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ).tr(),
            SizedBox(height: 25),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // 다이얼로그를 닫습니다.
              await cancelMealApplication(); // 신청 취소 API 호출
            },
            child: Text('restaurant.cancel.confirm.yes',
                    style: TextStyle(
                        color: Palette.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12))
                .tr(),
          ),
          TextButton(
            onPressed: () {
              // 알림 창 닫기
              Navigator.pop(context);
            },
            child: Text('restaurant.cancel.confirm.no',
                    style: TextStyle(
                        color: Palette.stateColor3,
                        fontWeight: FontWeight.w600,
                        fontSize: 12))
                .tr(),
          ),
        ],
      ),
    );
  }
}

//전화번호 사이에 하이픈 넣는 함수
String formatPhoneNumber(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return '정보 없음';
  }

  // 하이픈이 이미 있는 경우, 원본 번호를 반환
  if (phoneNumber.contains('-')) {
    return phoneNumber;
  }

  // 휴대폰 번호 형식에 맞게 하이픈 추가
  if (phoneNumber.length == 11) {
    return '${phoneNumber.substring(0, 3)} - ${phoneNumber.substring(3, 7)} - ${phoneNumber.substring(7, 11)}';
  }

  // 다른 형식의 번호는 원본 반환
  return phoneNumber;
}

//유저 정보 컨테이너
class UserInfoContainer extends StatelessWidget {
  final String title;
  final String content;

  const UserInfoContainer({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Text(title),
          ),
          Container(
            width: 300,
            height: 35,
            margin: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: const Color.fromARGB(255, 214, 214, 214))),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 134, 134, 134)),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//점선 컨테이너
class DottedLineSeparator extends StatelessWidget {
  const DottedLineSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: const Text(
          '............................................................................................',
          style: TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
    );
  }
}

//엘리베이터 버튼
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
