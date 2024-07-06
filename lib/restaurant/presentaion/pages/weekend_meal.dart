import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/restaurant/data/data_sources/meal_reservation_data_source.dart';
import 'package:yjg/restaurant/data/data_sources/weekend_meal_reservation_data_source.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:group_button/group_button.dart';
import 'package:easy_localization/easy_localization.dart';

// RefundOption 열거형 추가
enum RefundOption { refund, convenienceStore }

//선택 사항 저장하는 함수 초기화시 할당 되게 추가 해놔서 상관 없음
int sat = -1;
int sun = -1;
String mealType = '';
int refund = -1;

//신청 여부 확인 변수
int mealWeekend = -1;
int mealWeekendDeposit = -1;

class WeekendMeal extends StatefulWidget {
  const WeekendMeal({super.key});
  @override
  State<WeekendMeal> createState() => _WeekendMealState();
}

class _WeekendMealState extends State<WeekendMeal> {
  final controller = GroupButtonController();
  RefundOption? _refundOption; // 사용자가 선택한 환불 옵션을 저장하는 변수

  List<dynamic> mealTypes = []; // API로부터 가져온 식사 유형 데이터를 저장할 리스트
  final _weekendReservationDataSource = WeekendMealReservationDataSource();
  final _reservationDataSource = MealReservationDataSource();

  //get 함수로 불러온 신청 유저의 데이터를 저장할 변수들
  String studentId = '';
  String name = '';
  String phoneNumber = '';
  String mealDay = '';
  String mealTypeDetail = '';
  String refundOption = '';

  int applicationId = -1; // 신청 취소 하려고 신청건의 id 담아두는 변수

  //get 함수로 불러온 계좌번호 데이터를 저장할 변수들
  String bankName = '';
  String accountNumber = '';
  String accountHolder = '';

  // 휴대전화 번호 - 추가 함수
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      // 대부분의 한국 휴대폰 번호 길이는 11자리입니다.
      return phoneNumber.replaceRange(3, 3, '-').replaceRange(8, 8, '-');
    } else {
      return phoneNumber; // 다른 길이의 번호는 그대로 반환합니다.
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMealTypes(); // 위젯 초기화 시 식사 유형 데이터 가져오는 함수 호출
    fetchUserData(); //위젯 초기화 시 신청자 데이터를 가져오는 함수 호출
    fetchAccountData(); // 위젯 초기화 시 계좌번호 데이터를 가져오는 함수 호출
  }

  final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)

  //* 식수 유형 POST로 보내는 API 함수
  Future<void> sendApplication() async {
    try {
      await _weekendReservationDataSource.postMealTypeAPI(
          mealType, refund, sat, sun);
      // API 호출 성공
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('restaurant.weekendapp.8'.tr()),
          backgroundColor: Palette.mainColor,
        ),
      );

      // UI 업데이트를 위해 setState 호출
      setState(() {
        mealWeekend = 1;
        mealWeekendDeposit = 1;
      });

      // 추가적으로 유저 데이터를 다시 불러와서 상태를 업데이트할 수 있습니다.
      fetchUserData();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // * 식사 유형 데이터(버튼) 불러오는 GET API 함수
  Future<void> fetchMealTypes() async {
    try {
      final response = await _weekendReservationDataSource.fetchMealTypes();
      final data = response.data;
      setState(() {
        mealTypes = data['semester_meal_type'];
      });
    } catch (e) {
      debugPrint('식수 유형 불러오기 실패: $e');
      throw Exception('식사 유형을 불러오지 못했습니다.');
    }
  }

  // * 신청자 데이터 불러오는 GET API 함수
  Future<void> fetchUserData() async {
    try {
      final response = await _weekendReservationDataSource.fetchUserData();
      final responseData = response.data;
      final userData = responseData['userData']['data'];

      if (userData.isNotEmpty) {
        // userData 리스트가 비어있지 않은 경우
        final data = userData.first;

        setState(() {
          studentId = data['user']['student_id'];
          name = data['user']['name'];
          phoneNumber = data['user']['phone_number'];
          applicationId = data['id'];

          // 요일 처리
          if (data['sat'] == 1 && data['sun'] == 0) {
            mealDay = 'restaurant.appnum.2'.tr();
          } else if (data['sat'] == 0 && data['sun'] == 1) {
            mealDay = 'restaurant.appnum.3'.tr();
          } else if (data['sat'] == 1 && data['sun'] == 1) {
            mealDay = 'restaurant.appnum.6'.tr();
          }

          // 식사 유형 처리
          mealTypeDetail = data['weekend_meal_type']['meal_type'] +
              'restaurant.weekend.middle.2'.tr();

          // 환불 옵션 처리
          refundOption = data['refund'] == 1
              ? 'restaurant.weekend.middle.4'.tr()
              : 'restaurant.weekend.middle.5'.tr();

          // payment 값을 확인하여 mealWeekendDeposit 설정
          mealWeekendDeposit = data['payment'];

          // userData 리스트가 존재하므로 mealWeekend를 1로 설정
          mealWeekend = 1;
        });
      } else {
        // userData 리스트가 비어있는 경우
        setState(() {
          // mealWeekend를 0으로 설정하여 신청이 없음을 나타냄
          mealWeekend = 0;
        });
      }
    } catch (e) {
      // 오류 처리
      debugPrint('정보 불러오기 실패: $e');
      throw Exception('신청자 데이터를 불러오지 못했습니다.');
    }
  }

  // * 신청 취소하는 DELETE API 함수
  Future<void> deleteApplication(int id) async {
    try {
      await _weekendReservationDataSource.deleteApplication(id);

      // API 호출 성공
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('restaurant.weekendapp.10'.tr()),
          backgroundColor: Palette.mainColor,
        ),
      );

      // 신청 취소 후 UI 및 변수 초기화
      setState(() {
        // 선택 항목들을 초기화합니다.
        sat = -1;
        sun = -1;
        mealType = '';
        refund = -1;
        _refundOption = null; // 환불 옵션 초기화

        // 신청 여부와 결제 여부도 초기화
        mealWeekend = 0;
        mealWeekendDeposit = -1;
      });

      // 사용자 데이터를 다시 불러오고 UI 업데이트
      fetchUserData();
    } catch (e) {
      // 요청 실패 시 처리
      // API 호출 성공
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('신청 취소를 실패했습니다.'), backgroundColor: Colors.red),
      );
      debugPrint('취소 실패: $e');
      throw Exception('신청 취소를 실패했습니다.');
    }
  }

  // * 계좌 번호 데이터를 불러오는 GET API 함수
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
      print('계좌 정보를 불러오는 데 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    //주말 식수 신청 x인 경우
    if (mealWeekend == 0) {
      return Scaffold(
        appBar: BaseAppBar(title: 'restaurant.title.0.3'.tr()),
        drawer: BaseDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: CustomSingleChildScrollView(
          child: Column(
            children: [
              //상단 겹쳐져 있는 바
              SizedBox(
                height: 150.0,
                child: Stack(
                  children: [
                    BlueMainRoundedBox(),
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: WhiteMainRoundedBox(
                          iconData: Icons.restaurant,
                          mainText: 'restaurant.weekend.topbox.1'.tr(),
                          secondaryText: 'restaurant.weekend.topbox.2'.tr(),
                          actionText: 'restaurant.weekend.topbox.3'.tr(),
                          timeText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //요일 선택 글자
              Container(
                margin: const EdgeInsets.all(25),
                child: Text(
                  'restaurant.appnum.5'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //요일 선택 버튼
              GroupButton(
                  //버튼 디자인
                  options: const GroupButtonOptions(
                    //버튼 그림자
                    selectedShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 207, 207, 207), //그림자 색상
                        spreadRadius: 0.5, // 그림자 넓이
                        blurRadius: 5, // 그림자 흐림도
                        offset: Offset(3, 3), // 그림자가 박스랑 얼마나 떨어져서 나타날지
                      ),
                    ],
                    unselectedShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 207, 207, 207), //그림자 색상
                        spreadRadius: 0.5, // 그림자 넓이
                        blurRadius: 5, // 그림자 흐림도
                        offset: Offset(3, 3), // 그림자가 박스랑 얼마나 떨어져서 나타날지
                      ),
                    ],

                    //버튼 글자 스타일
                    selectedTextStyle:
                        TextStyle(fontSize: 16, color: Colors.white),
                    unselectedTextStyle: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 29, 127, 159),
                    ),

                    //버튼 컬러
                    selectedColor: Color.fromARGB(255, 29, 127, 159),

                    //버튼 테두리
                    borderRadius: BorderRadius.all(Radius.circular(15)),

                    //버튼 간격
                    spacing: 10,

                    //버튼 크기
                    buttonHeight: 50,
                    buttonWidth: 120,
                  ),
                  isRadio: true,

                  //버튼 클릭시 실행 되는 함수
                  onSelected: (index, isSelected, isPressed) {
                    if (isSelected == 0) {
                      setState(() {
                        sat = 1;
                        sun = 0;
                      });
                    } else if (isSelected == 1) {
                      setState(() {
                        sat = 0;
                        sun = 1;
                      });
                    } else if (isSelected == 2) {
                      setState(() {
                        sat = 1;
                        sun = 1;
                      });
                    }
                  },

                  //버튼 내용
                  buttons: [
                    'restaurant.appnum.2'.tr(),
                    'restaurant.appnum.3'.tr(),
                    '${'restaurant.appnum.2'.tr()}+${'restaurant.appnum.3'.tr()}',
                  ]),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //식사 정보 글자
              Container(
                margin: const EdgeInsets.all(25),
                child: Text(
                  'restaurant.weekend.middle.1'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //식사 정보 선택 버튼
              Wrap(
                spacing: 8.0, // 버튼 사이의 가로 간격
                runSpacing: 8.0, // 버튼 사이의 세로 간격
                children: mealTypes.map((type) {
                  bool isSelected = mealType == type['meal_type'];
                  return SizedBox(
                    width: 150, // 버튼의 너비를 고정
                    height: 80, // 버튼의 높이를 고정
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Color.fromARGB(255, 255, 255, 255),
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: isSelected
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          mealType = type['meal_type'];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "${type['meal_type']}${"restaurant.weekend.middle.2".tr()}\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Palette.mainColor),
                              ),
                              TextSpan(
                                text: "${type['content']}\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: "${type['price']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 214, 80, 70)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //인원 미충족 시 글자
              Container(
                margin: const EdgeInsets.all(25),
                child: Text(
                  'restaurant.weekend.middle.3'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //인원 미충족 시 버튼
              Container(
                margin: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Row 내부 항목을 중앙에 배치
                      children: <Widget>[
                        // '환불' 라디오 버튼
                        Radio<RefundOption>(
                          value: RefundOption.refund,
                          groupValue: _refundOption,
                          onChanged: (RefundOption? value) {
                            setState(() {
                              _refundOption = value;
                              refund = 1; // '환불' 옵션이 선택되었음을 나타내는 로직
                            });
                          },
                          activeColor: Palette.mainColor, // 선택 시 색상을 파란색으로 설정
                        ),
                        Text('restaurant.weekend.middle.4'.tr()), // '환불' 텍스트
                        SizedBox(width: 50), // 버튼 사이의 간격
                        // '편의점 도시락' 라디오 버튼
                        Radio<RefundOption>(
                          value: RefundOption.convenienceStore,
                          groupValue: _refundOption,
                          onChanged: (RefundOption? value) {
                            setState(() {
                              _refundOption = value;
                              refund = 0; // '편의점 도시락' 옵션이 선택되었음을 나타내는 로직
                            });
                          },
                          activeColor: Palette.mainColor, // 선택 시 색상을 파란색으로 설정
                        ),
                        Text('restaurant.weekend.middle.5'
                            .tr()), // '편의점 도시락' 텍스트
                      ],
                    ),
                  ],
                ),
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //계좌 정보 글자
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  'restaurant.weekend.middle.6'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //수요일 ~ 글자
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                child: Text(
                  'restaurant.weekend.middle.7'.tr(),
                  style: TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 168, 168, 168)),
                ),
              ),

              //계좌번호 박스
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
                  '$bankName    $accountNumber    $accountHolder',
                  style: TextStyle(
                    color: Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
              ),

              //신청 버튼
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15, right: 25),
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 29, 127, 159),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      // 테두리 둥글기 조절
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // 둥글기 정도를 조절하는 값
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (sat == -1 ||
                        sun == -1 ||
                        mealType.isEmpty ||
                        refund == -1) {
                      nonSelect(context);
                    } else {
                      sendApplication(); // API 호출 함수
                      fetchUserData();
                      setState(() {});
                    }
                  },
                  child: Text(
                    'restaurant.weekend.middle.8'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //주말 식수 신청 O 결제 X인 경우
    else if (mealWeekend == 1 && mealWeekendDeposit == 0) {
      return Scaffold(
        appBar: BaseAppBar(title: 'restaurant.title.0.3'.tr()),
        drawer: BaseDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //상단 겹쳐져 있는 바
              SizedBox(
                height: 150.0,
                child: Stack(
                  children: [
                    BlueMainRoundedBox(),
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: WhiteMainRoundedBox(
                          iconData: Icons.restaurant,
                          mainText: 'restaurant.weekend.topbox.1'.tr(),
                          secondaryText: 'restaurant.weekend.topbox.2'.tr(),
                          actionText: 'restaurant.weekend.topbox.3'.tr(),
                          timeText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //학생정보 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  'restaurant.weekendapp.1'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //학번 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'restaurant.weekendapp.2'.tr(),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            studentId,
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //이름 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'restaurant.weekendapp.3'.tr(),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            name,
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //전화번호 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'restaurant.weekendapp.4'.tr(),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            formatPhoneNumber(phoneNumber),
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //신청 유형 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'restaurant.weekendapp.5'.tr(),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '$mealDay  |  $mealTypeDetail  |  $refundOption',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //신청 현황 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  'restaurant.weekendapp.6'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //입금 x 컨테이너
              Container(
                margin: EdgeInsets.all(10),
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
                    Icon(Icons.sentiment_very_dissatisfied,
                        color: Colors.red, size: 40),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'restaurant.weekend.middle.7'.tr(),
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      '$bankName $accountNumber $accountHolder',
                      style: TextStyle(
                        color: Color.fromARGB(255, 162, 162, 162),
                      ),
                    )
                  ],
                ),
              ),

              //신청 취소 버튼
              Container(
                margin: EdgeInsets.all(15),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 159, 29, 29),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      // 테두리 둥글기 조절
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // 둥글기 정도를 조절하는 값
                      ),
                    ),
                  ),

                  //버튼 클릭 시 동작
                  onPressed: () {
                    mealCancel(context);
                  },
                  child: Text(
                    'restaurant.weekendapp.7'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //주말 식수 신청 O 결제 O인 경우
    else {
      return Scaffold(
        appBar: BaseAppBar(title: 'restaurant.title.0.3'.tr()),
        drawer: BaseDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //상단 겹쳐져 있는 바
              SizedBox(
                height: 150.0,
                child: Stack(
                  children: [
                    BlueMainRoundedBox(),
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: WhiteMainRoundedBox(
                          iconData: Icons.restaurant,
                          mainText: 'restaurant.weekend.topbox.1'.tr(),
                          secondaryText: 'restaurant.weekend.topbox.2'.tr(),
                          actionText: 'restaurant.weekend.topbox.3'.tr(),
                          timeText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //학생정보 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  'restaurant.weekendapp.1'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //학번 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'restaurant.weekendapp.2'.tr(),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            studentId,
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //이름 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'restaurant.weekendapp.3'.tr(),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            name,
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //전화번호 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'restaurant.weekendapp.4'.tr(),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            formatPhoneNumber(phoneNumber),
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //신청 유형 적힌 컨테이너
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'restaurant.weekendapp.5'.tr(),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 35,
                      margin: EdgeInsets.only(left: 15),

                      //박스 디자인
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214))),

                      //박스 텍스트
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0), // 왼쪽으로부터의 간격 추가
                        child: Align(
                          alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                          child: Text(
                            '$mealDay  |  $mealTypeDetail  |  $refundOption',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                            textAlign: TextAlign.left, // 텍스트를 왼쪽으로 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //구분 점선
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                    '............................................................................................',
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
              ),

              //신청 현황 글자
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  'restaurant.weekendapp.6'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              //입금 O 컨테이너
              Container(
                margin: EdgeInsets.all(10),
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
                    Icon(Icons.sentiment_satisfied_alt,
                        color: Color.fromARGB(255, 29, 127, 159), size: 40),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'restaurant.weekendapp.11'.tr(),
                      style:
                          TextStyle(color: Color.fromARGB(255, 29, 127, 159)),
                    ),
                    Text(
                      'Thank you',
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

  //취소 alert
  Future<dynamic> mealCancel(BuildContext context) {
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
              'restaurant.weekendapp.9'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // 신청 취소 처리
              await deleteApplication(applicationId);

              // 사용자 데이터를 다시 불러온 후 UI 업데이트
              await fetchUserData();
              setState(() {
                // UI 업데이트를 위한 코드. 필요에 따라 여기서 변수를 업데이트하세요.
              });

              // 알림 창 닫기
              Navigator.pop(context);
            },
            child: Text('Yes',
                style: TextStyle(
                    color: Palette.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ),
          TextButton(
            onPressed: () {
              // 알림 창 닫기
              Navigator.pop(context);
            },
            child: Text('No',
                style: TextStyle(
                    color: Palette.stateColor3,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }

  //다 골라라 alert
  Future<dynamic> nonSelect(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.campaign,
          size: 50,
          color: Color.fromARGB(255, 29, 127, 159),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '항목을 모두 선택해주세요.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined))
        ],
      ),
    );
  }
}
