import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_pro/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(FirebaseAuth.instance));
  }
}
