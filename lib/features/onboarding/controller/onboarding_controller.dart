import 'package:get/get.dart';
import '../../../app/services/local_storage_service.dart';

class OnboardingController extends GetxController {
  final LocalStorageService storage;
  OnboardingController(this.storage);

  final seenOnboarding = false.obs;

  @override
  void onInit() {
    super.onInit();
    seenOnboarding.value = storage.seenOnboarding;
  }

  Future<void> complete() async {
    await storage.setSeenOnboarding(true);
    seenOnboarding.value = true;
  }
}
