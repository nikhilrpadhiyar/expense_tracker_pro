import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/core/utils/validators.dart';
import 'package:expense_tracker_pro/features/auth/presentation/controllers/auth_controller.dart';
import 'package:expense_tracker_pro/routes/app_pages.dart';
import 'package:expense_tracker_pro/shared/widgets/app_button.dart';
import 'package:expense_tracker_pro/shared/widgets/app_logo.dart';
import 'package:expense_tracker_pro/shared/widgets/app_text_field.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                const Center(child: AppLogo()),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Welcome back',
                  style: context.textTheme.headlineLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Sign in to continue tracking your expenses',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  controller: controller.emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: AppSpacing.md),
                Obx(
                  () => AppTextField(
                    controller: controller.passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: !controller.isPasswordVisible.value,
                    validator: Validators.password,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Obx(
                  () => AppButton(
                    label: 'Sign In',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.signIn,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: context.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
