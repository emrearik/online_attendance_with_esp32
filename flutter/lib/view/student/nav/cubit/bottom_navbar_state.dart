part of 'bottom_navbar_cubit.dart';

@immutable
class BottomNavBarState extends Equatable {
  final BottomNavItem selectedItem;
  const BottomNavBarState({required this.selectedItem});

  @override
  List<Object> get props => [selectedItem];
}
