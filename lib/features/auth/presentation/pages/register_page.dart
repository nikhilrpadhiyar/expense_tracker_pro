import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/core/utils/validators.dart';
import 'package:expense_tracker_pro/features/auth/presentation/controllers/auth_controller.dart';
import 'package:expense_tracker_pro/shared/widgets/app_button.dart';
import 'package:expense_tracker_pro/shared/widgets/app_logo.dart';
import 'package:expense_tracker_pro/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(child: AppLogo(size: 48)),
                const SizedBox(height: AppSpacing.lg),
                Text('Create Account', style: context.textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text(
                  'Start your journey to smarter spending',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  controller: controller.nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  validator: (String? v) =>
                      Validators.required(v, field: 'Name'),
                  prefixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: AppSpacing.md),
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
                    hint: 'At least 8 characters',
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
                const SizedBox(height: AppSpacing.xl),
                Obx(
                  () => AppButton(
                    label: 'Create Account',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account?',
                      style: context.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Sign In'),
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
