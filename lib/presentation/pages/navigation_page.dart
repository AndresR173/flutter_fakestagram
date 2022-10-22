import 'package:flutter/material.dart';

import '../../utils/assets.dart';
import 'account_page.dart';
import 'feed_page.dart';
import 'login_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLogged = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // warning this could cause double callbacks
    _tabController.addListener(_handleTabSelection);
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
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              centerTitle: false,
              title: Image.asset(
                Assets.titleImage,
                height: 33,
              ),
              actions: <Widget>[
                Image.asset(
                  Assets.addOutline,
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.favorite_border,
                    size: 24,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.send,
                    size: 24,
                  ),
                ),
              ],
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                const FeedPage(),
                Container(
                  color: Colors.blue,
                ),
                if (_isLogged) const AccountPage() else const LoginPage()
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
