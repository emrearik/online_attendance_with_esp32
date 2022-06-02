import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/constants/enums/admin_bottom_nav_item.dart';
import 'package:online_yoklama/view/admin/nav/cubit/admin_bottom_navbar_cubit.dart';
import 'package:online_yoklama/view/admin/nav/widgets/admin_custom_bottom_navbar.dart';
import 'package:online_yoklama/view/admin/nav/widgets/admin_tab_navigator.dart';

class AdminNavScreen extends StatefulWidget {
  static const String routeName = "/admin_nav_screen";
  const AdminNavScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => const AdminNavScreen());
  }

  @override
  State<AdminNavScreen> createState() => _AdminNavScreenState();
}

class _AdminNavScreenState extends State<AdminNavScreen> {
  final Map<AdminBottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    AdminBottomNavItem.homepage: GlobalKey<NavigatorState>(),
    AdminBottomNavItem.lesson: GlobalKey<NavigatorState>(),
    AdminBottomNavItem.session: GlobalKey<NavigatorState>(),
  };

  final Map<AdminBottomNavItem, IconData> items = const {
    AdminBottomNavItem.homepage: Icons.home,
    AdminBottomNavItem.lesson: Icons.book,
    AdminBottomNavItem.session: Icons.add,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<AdminBottomNavBarCubit, AdminBottomNavBarState>(
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
            bottomNavigationBar: AdminCustomBottomNavBar(
              selectedItem: state.selectedItem,
              navigatorKeys: navigatorKeys,
              items: items,
            ),
          );
        },
      ),
    );
  }

  /*void _selectBottomNavItem(
      BuildContext context, AdminBottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      navigatorKeys[selectedItem]!.currentState!.popUntil(
            (route) => route.isFirst,
          );
    }
    context.read<AdminBottomNavBarCubit>().updateSelectedItem(selectedItem);
  }*/

  Widget _buildOffStageNavigator(
      AdminBottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: AdminTabNavigator(
        navigatorKey: navigatorKeys[currentItem]!,
        item: currentItem,
      ),
    );
  }
}
