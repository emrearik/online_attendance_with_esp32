import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/constants/enums/bottom_nav_item.dart';
import 'package:online_yoklama/view/student/nav/cubit/bottom_navbar_cubit.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys;
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;

  const CustomBottomNavBar(
      {Key? key,
      required this.items,
      required this.selectedItem,
      required this.navigatorKeys})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: BottomAppBar(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        child: Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: items
                .map((item, icon) {
                  return MapEntry(
                    item.toString(),
                    InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        final selectedItem = BottomNavItem.values[item.index];
                        _selectBottomNavItem(
                          context,
                          selectedItem,
                          selectedItem ==
                              context
                                  .read<BottomNavBarCubit>()
                                  .state
                                  .selectedItem,
                        );
                      },
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(
                          icon,
                          size: 30,
                          color: selectedItem.index == item.index
                              ? Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .selectedItemColor
                              : Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .unselectedItemColor,
                        ),
                      ),
                    ),
                  );
                })
                .values
                .toList(),
          ),
        ),
        shape: const CircularNotchedRectangle(),
      ),
    );
  }

  void _selectBottomNavItem(
      BuildContext context, BottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      navigatorKeys[selectedItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }
}
