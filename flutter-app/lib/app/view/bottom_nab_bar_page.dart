import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/ui/view/inbox_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/view/search_ride_view.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/screen/profile_screen.dart';

import '../../modules/ride&booking/ui/view/booking_view.dart';


class BottomNabBarScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNabBarScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNabBarScreen> createState() => _BottomNabBarScreenState();
}

class _BottomNabBarScreenState extends State<BottomNabBarScreen> with SingleTickerProviderStateMixin {

  late final TabController _tabController ;

  final List<Widget> _pages = [
    const SearchScreenView(key: Key("SearchScreenView"),),
    const InboxScreen(key: Key("InboxScreen"),),
    const BookingScreen(key: Key("BookingScreen"),),
    const ProfileScreen(key: Key("ProfileScreen"),),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          _pages[0],
          _pages[1],
          _pages[2],
          _pages[3],
        ],
      ),
      bottomNavigationBar: SafeArea(
        
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade300
              )
            )
          ),
          child: _BottomTabBar(tabController: _tabController)),
      )
    );
  }
  
}

class _BottomTabBar extends StatefulWidget {
  final TabController tabController;
  const _BottomTabBar({super.key, required this.tabController});

  @override
  State<_BottomTabBar> createState() => __BottomTabBarState();
}

class __BottomTabBarState extends State<_BottomTabBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    widget.tabController.animateTo(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: AppColors.background,
          child: TabBar(
            
            controller: widget.tabController,
            labelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            dividerColor: Colors.grey.shade300,
            onTap: _onItemTapped,
            //type: BottomNavigationBarType.fixed,
            tabs: [
              Tab(
                icon: Image.asset(
                  _selectedIndex == 0
                      ? 'assets/images/searchpng.png'
                      : 'assets/images/search-normal.png',
                  height: 22,
                  width: 22,
                ),
                text: 'Search'.tr(),
              ),
              Tab(
                icon: Image.asset(
                  _selectedIndex == 1
                      ? 'assets/images/inbobxblue.png'
                      : 'assets/images/Inbox.png',
                  height: 22,
                  width: 22,
                ),
                text: 'Inbox'.tr(),
              ),
              Tab(
                icon: Image.asset(
                  _selectedIndex == 2
                      ? 'assets/images/booking.png'
                      : 'assets/images/bookingnormal.png',
                  height: 22,
                  width: 22,
                ),
                text: 'Booking'.tr(),
              ),
              Tab(
                icon: Image.asset(
                  _selectedIndex == 3
                      ? 'assets/images/profileblue.png'
                      : 'assets/images/profilenormal.png',
                  height: 22,
                  width: 22,
                ),
                text: 'My Profile'.tr(),
              ),
            ],
          ),
        );
      },
    );
  }
}

