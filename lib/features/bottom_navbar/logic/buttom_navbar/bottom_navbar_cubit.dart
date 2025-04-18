import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navbar_state.dart';

class BottomNavbarCubit extends Cubit<BottomNavbarState> {
  BottomNavbarCubit() : super(const BottomNavbarHome(0));

  void navigateTo(int index) {
    if (index == 0) {
      emit(BottomNavbarHome(index));
    } else if (index == 1) {
      emit(BottomNavbarProfile(index));
    } else if (index == 2) {
      emit(BottomNavbarMessage(index));
    } else if (index == 3) {
      emit(BottomNavbarSetting(index));
    }
  }
}
