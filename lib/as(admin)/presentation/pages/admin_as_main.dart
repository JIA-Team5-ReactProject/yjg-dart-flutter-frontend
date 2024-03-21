import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/as(admin)/data/models/as_list.dart';
import 'package:yjg/as(admin)/presentation/viewmodels/as_viewmodel.dart';
import 'package:yjg/as(admin)/presentation/widgets/admin_as_card.dart';
import 'package:yjg/as(admin)/presentation/widgets/as_tabbar.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';

class AsMain extends ConsumerStatefulWidget {
  const AsMain({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AsMainState();
}

class _AsMainState extends ConsumerState<AsMain>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // 페이지 진입 시 미처리 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(asDataNotifierProvider.notifier).fetchAsData(0);
    });
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      final status = _tabController.index; // 0: 미처리, 1: 처리완료
      ref.read(asDataNotifierProvider.notifier).fetchAsData(status);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asDataState = ref.watch(asDataNotifierProvider);

    return Scaffold(
      appBar: BaseAppBar(title: 'AS 관리'),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Column(
        children: [
          AsTabBar(controller: _tabController), // 수정: TabBar를 커스텀 위젯으로 대체
          SizedBox(height: 20.0),
          Text(
            '게시글을 누르면 상세보기로 이동합니다.',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 30.0),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 미처리 탭의 내용
                _buildAsListTab(asDataState),
                // 처리완료 탭의 내용
                _buildAsListTab(asDataState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsListTab(AsyncValue<AfterServiceResponse> asDataState) {
    return asDataState.when(
      data: (data) => Column(
        children: [
          Expanded(
            child: CustomSingleChildScrollView(
              child: Column(
                children: data.data
                    .map((asItem) => AdminAsCard(asItem: asItem))
                    .toList(),
              ),
            ),
          ),
          if (data.lastPage > 1) _buildPaginationControls(data),
        ],
      ),
      loading: () => const Center(
          child: CircularProgressIndicator(color: Palette.stateColor4)),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

// 페이지네이션 컨트롤 위젯 생성 메서드
  Widget _buildPaginationControls(AfterServiceResponse data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(data.lastPage, (index) {
        return TextButton(
          onPressed: () => _changePage(index + 1),
          child: Text('${index + 1}',
              style: TextStyle(
                color: data.currentPage == index + 1
                    ? Palette.mainColor
                    : Colors.black,
              )),
        );
      }),
    );
  }

// 특정 페이지로 데이터를 로드
  void _changePage(int page) {
    // 현재 페이지 상태를 업데이트
    ref.read(currentPageProvider.notifier).state = page;
    // 새로운 페이지의 데이터를 가져옴
    final status = _tabController.index; // 현재 선택된 탭의 상태를 가져옴
    ref.read(asDataNotifierProvider.notifier).fetchAsData(status);
  }
}
