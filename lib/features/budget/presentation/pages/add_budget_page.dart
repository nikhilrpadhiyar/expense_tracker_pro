import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/constants/expense_categories.dart';
import 'package:expense_tracker_pro/core/utils/validators.dart';
import 'package:expense_tracker_pro/features/budget/presentation/controllers/budget_controller.dart';
import 'package:expense_tracker_pro/shared/widgets/app_button.dart';
import 'package:expense_tracker_pro/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBudgetPage extends GetView<BudgetController> {
  const AddBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Budget'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Category', style: context.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                Obx(
                  () => DropdownButtonFormField<String>(
                    initialValue: controller.selectedCategory.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ExpenseCategories.all
                        .map(
                          (ExpenseCategory cat) => DropdownMenuItem<String>(
                            value: cat.id,
                            child: Row(
                              children: <Widget>[
                                Icon(cat.icon, color: cat.color, size: 18),
                                const SizedBox(width: 8),
                                Text(cat.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (String? v) =>
                        controller.selectedCategory.value = v!,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: controller.limitController,
                  label: 'Monthly Limit',
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: Validators.amount,
                  prefixIcon: Icons.attach_money_rounded,
                ),
                const SizedBox(height: AppSpacing.xl),
                Obx(
                  () => AppButton(
                    label: 'Save Budget',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.saveBudget,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
