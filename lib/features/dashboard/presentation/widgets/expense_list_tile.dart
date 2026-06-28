import 'package:flutter/material.dart';
import 'package:expense_tracker_pro/core/constants/expense_categories.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/core/theme/app_text_styles.dart';
import 'package:expense_tracker_pro/core/utils/currency_formatter.dart';
import 'package:expense_tracker_pro/core/utils/date_utils.dart';
import 'package:expense_tracker_pro/core/utils/extensions.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';

class ExpenseListTile extends StatelessWidget {
  const ExpenseListTile({
    super.key,
    required this.expense,
    this.onTap,
    this.onDelete,
  });

  final ExpenseEntity expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final cat = ExpenseCategories.findById(expense.categoryId);
    final isExpense = expense.isExpense;

    String dateLabel;
    if (expense.date.isToday) {
      dateLabel = 'Today';
    } else if (expense.date.isYesterday) {
      dateLabel = 'Yesterday';
    } else {
      dateLabel = AppDateUtils.formatShort(expense.date);
    }

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: cat.color.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(cat.icon, color: cat.color, size: 20),
      ),
      title: Text(
        expense.title,
        style: context.textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$dateLabel · ${cat.name}',
        style: AppTextStyles.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isExpense ? '-' : '+'}'
            '${CurrencyFormatter.format(expense.amount)}',
            style: AppTextStyles.amountMedium.copyWith(
              color: isExpense ? AppColors.expense : AppColors.income,
              fontSize: 15,
            ),
          ),
          if (!expense.isSynced)
            const Icon(Icons.cloud_off_rounded, size: 12, color: AppColors.grey400),
        ],
      ),
    );
  }
}
