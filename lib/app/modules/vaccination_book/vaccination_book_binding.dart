import 'package:get/get.dart';
import 'vaccination_book_controller.dart';

class VaccinationBookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccinationBookController>(
      () => VaccinationBookController(),
    );
  }
}
