import 'package:flutter/material.dart';

import '../../utils/assets.dart';
import '../widgets/fakestagram_app_bar.dart';
import 'account_page.dart';
import 'feed_page.dart';

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
    // warning this could cause double callbacks
    _tabController.addListener(_handleTabSelection);
    // TODO check if user is logged in
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        color: const Color(0xFF212121),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFF212121),
            appBar: FakestagramAppBar(),
            body: TabBarView(
              controller: _tabController,
              children: [
                const FeedPage(),
                Container(
                  color: Colors.blue,
                ),
                const AccountPage()
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
        ),
      ),
    );
  }
}
