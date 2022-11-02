import 'package:fakestagram/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';

import '../../utils/assets.dart';
import '../widgets/fakestagram_app_bar.dart';
import 'account_page.dart';
import 'feed_page.dart';
import 'new_post_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        appBar: FakestagramAppBar(
          onNewPostPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewPostPage())),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            FeedPage(),
            SearchPage(),
            AccountPage()
          ],
        ),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: _tabController.index == 0
                  ? Image.asset(
                      Assets.home,
                      height: 24,
                    )
                  : Image.asset(
                      Assets.homeOutline,
                      height: 24,
                    ),
            ),
            Tab(
              icon: _tabController.index == 1
                  ? Image.asset(
                      Assets.search,
                      height: 24,
                    )
                  : Image.asset(
                      Assets.searchOutline,
                      height: 24,
                    ),
            ),
            Tab(
              icon: _tabController.index == 2
                  ? Image.asset(
                      Assets.person,
                      height: 24,
                    )
                  : Image.asset(
                      Assets.personOutline,
                      height: 24,
                    ),
            ),
          ],
          indicatorColor: Colors.transparent,
        ),
      ),
    );
  }
}
