import 'package:expense_tracker_pro/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  AuthController(this._auth);
  final FirebaseAuth _auth;

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> signIn() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Sign in failed.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
      await credential.user?.updateDisplayName(nameController.text.trim());
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Registration failed.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
