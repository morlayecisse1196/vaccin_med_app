import 'package:get/get.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  void goToHome() => changePage(0);
  void goToCalendar() => changePage(1);
  void goToJournal() => changePage(2);
  void goToChat() => changePage(3);
  void goToMap() => changePage(4);
}
