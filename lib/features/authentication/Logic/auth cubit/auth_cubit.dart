import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static AuthCubit get(context) => BlocProvider.of(context);

  AuthCubit() : super(AuthInitial()) {
    pageController = PageController();
  }

  int currentIndex = 0;
  late PageController pageController;

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(ChangeDotState());
  }

  void nextPage() {
    currentIndex++;
    pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );
    emit(NextPageState());
  }
}
