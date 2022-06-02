import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:online_yoklama/core/constants/enums/admin_bottom_nav_item.dart';

part 'admin_bottom_navbar_state.dart';

class AdminBottomNavBarCubit extends Cubit<AdminBottomNavBarState> {
  AdminBottomNavBarCubit()
      : super(const AdminBottomNavBarState(
            selectedItem: AdminBottomNavItem.homepage));

  void updateSelectedItem(AdminBottomNavItem item) {
    if (item != state.selectedItem) {
      emit(AdminBottomNavBarState(selectedItem: item));
    }
  }
}
