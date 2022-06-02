part of 'admin_bottom_navbar_cubit.dart';

@immutable
class AdminBottomNavBarState extends Equatable {
  final AdminBottomNavItem selectedItem;
  const AdminBottomNavBarState({required this.selectedItem});

  @override
  List<Object> get props => [selectedItem];
}
