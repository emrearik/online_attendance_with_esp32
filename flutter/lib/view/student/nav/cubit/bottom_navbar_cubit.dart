import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:online_yoklama/core/constants/enums/bottom_nav_item.dart';

part 'bottom_navbar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit()
      : super(const BottomNavBarState(selectedItem: BottomNavItem.homepage));

  void updateSelectedItem(BottomNavItem item) {
    if (item != state.selectedItem) {
      emit(BottomNavBarState(selectedItem: item));
    }
  }
}
