import 'package:get/get.dart';

class HomeController extends GetxController {
  // Sample data - will be replaced with API calls
  final RxString userName = 'Aissatou Diop'.obs;
  final RxInt pregnancyWeek = 26.obs;
  final RxString nextAppointment = '2 jours'.obs;
  final RxString nextAppointmentDate = '6 Dec 2025'.obs;

  @override
  void onInit() {
    super.onInit();
    // TODO: Load user data from API
    loadUserData();
  }

  Future<void> loadUserData() async {
    // TODO: Implement API call
    // GET /api/user/profile
    await Future.delayed(const Duration(seconds: 1));
  }
}
