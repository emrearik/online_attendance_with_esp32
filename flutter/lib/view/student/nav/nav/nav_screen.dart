import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/constants/enums/bottom_nav_item.dart';
import 'package:online_yoklama/view/student/nav/cubit/bottom_navbar_cubit.dart';
import 'package:online_yoklama/view/student/nav/nav/widgets/custom_bottom_navbar.dart';
import 'package:online_yoklama/view/student/nav/nav/widgets/tab_navigator.dart';

class NavScreen extends StatefulWidget {
  static const String routeName = "/nav_screen";
  const NavScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => const NavScreen());
  }

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.homepage: GlobalKey<NavigatorState>(),
    BottomNavItem.details: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.homepage: Icons.home,
    BottomNavItem.details: Icons.book,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<BottomNavBarCubit, BottomNavBarState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Stack(
                children: items
                    .map((item, _) {
                      return MapEntry(
                        item,
                        _buildOffStageNavigator(
                            item, item == state.selectedItem),
                      );
                    })
                    .values
                    .toList()),
            bottomNavigationBar: CustomBottomNavBar(
              selectedItem: state.selectedItem,
              navigatorKeys: navigatorKeys,
              items: items,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOffStageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem]!,
        item: currentItem,
      ),
    );
  }
}
