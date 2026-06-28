import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/constants/expense_categories.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/core/theme/app_text_styles.dart';
import 'package:expense_tracker_pro/core/utils/date_utils.dart';
import 'package:expense_tracker_pro/core/utils/validators.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/presentation/controllers/expense_controller.dart';
import 'package:expense_tracker_pro/shared/widgets/app_button.dart';
import 'package:expense_tracker_pro/shared/widgets/app_text_field.dart';

class AddExpensePage extends GetView<ExpenseController> {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type toggle
                Obx(
                  () => _TypeToggle(
                    selected: controller.selectedType.value,
                    onChanged: controller.setType,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Amount
                AppTextField(
                  controller: controller.amountController,
                  label: 'Amount',
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: Validators.amount,
                  prefixIcon: Icons.attach_money_rounded,
                ),
                const SizedBox(height: AppSpacing.md),

                // Title
                AppTextField(
                  controller: controller.titleController,
                  label: 'Title',
                  hint: 'e.g. Lunch at restaurant',
                  validator: (v) => Validators.required(v, field: 'Title'),
                  prefixIcon: Icons.title_rounded,
                ),
                const SizedBox(height: AppSpacing.md),

                // Category
                Text('Category', style: context.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                Obx(() => _CategoryGrid(
                      selected: controller.selectedCategory.value,
                      onSelect: controller.setCategory,
                    )),
                const SizedBox(height: AppSpacing.md),

                // Date
                Text('Date', style: context.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                Obx(
                  () => _DatePicker(
                    date: controller.selectedDate.value,
                    onChanged: controller.setDate,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Note
                AppTextField(
                  controller: controller.noteController,
                  label: 'Note (optional)',
                  hint: 'Add a note...',
                  maxLines: 2,
                  prefixIcon: Icons.notes_rounded,
                ),
                const SizedBox(height: AppSpacing.xl),

                Obx(
                  () => AppButton(
                    label: 'Save Transaction',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.saveExpense,
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

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.selected, required this.onChanged});
  final ExpenseType selected;
  final ValueChanged<ExpenseType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: ExpenseType.values.map((type) {
          final isSelected = selected == type;
          final isExpense = type == ExpenseType.expense;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isExpense ? AppColors.expense : AppColors.income)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isExpense ? 'Expense' : 'Income',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected ? AppColors.white : AppColors.grey500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ExpenseCategories.all.map((cat) {
        final isSelected = selected == cat.id;
        return GestureDetector(
          onTap: () => onSelect(cat.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  isSelected ? cat.color.withAlpha(30) : context.theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? cat.color : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat.icon, size: 16, color: cat.color),
                const SizedBox(width: 6),
                Text(
                  cat.name,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected ? cat.color : AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({required this.date, required this.onChanged});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 18, color: AppColors.grey500),
            const SizedBox(width: 12),
            Text(
              AppDateUtils.formatDate(date),
              style: context.textTheme.bodyMedium,
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
