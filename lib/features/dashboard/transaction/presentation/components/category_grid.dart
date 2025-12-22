import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../data/models/transaction_category.dart';
import '../widgets/category_tile.dart';

/// Grid of category tiles for expense or income selection
class CategoryGrid extends StatelessWidget {
  final bool isIncome;
  final ExpenseCategory? selectedExpenseCategory;
  final IncomeSource? selectedIncomeSource;
  final ValueChanged<ExpenseCategory>? onExpenseCategorySelected;
  final ValueChanged<IncomeSource>? onIncomeSourceSelected;

  const CategoryGrid({
    super.key,
    required this.isIncome,
    this.selectedExpenseCategory,
    this.selectedIncomeSource,
    this.onExpenseCategorySelected,
    this.onIncomeSourceSelected,
  });

  IconData _getExpenseIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.makanan:
        return Icons.restaurant;
      case ExpenseCategory.transportasi:
        return Icons.directions_car;
      case ExpenseCategory.rumah:
        return Icons.home;
      case ExpenseCategory.anak:
        return Icons.child_care;
      case ExpenseCategory.kesehatan:
        return Icons.local_hospital;
      case ExpenseCategory.lainnya:
        return Icons.grid_view;
    }
  }

  IconData _getIncomeIcon(IncomeSource source) {
    switch (source) {
      case IncomeSource.gaji:
        return Icons.attach_money;
      case IncomeSource.usaha:
        return Icons.business;
      case IncomeSource.bantuan:
        return Icons.volunteer_activism;
      case IncomeSource.hadiah:
        return Icons.card_giftcard;
      case IncomeSource.lainnya:
        return Icons.grid_view;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          isIncome ? 'SUMBER PENDAPATAN' : 'PILIH KATEGORI',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSub,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),

        // Category grid
        if (isIncome) _buildIncomeGrid() else _buildExpenseGrid(),
      ],
    );
  }

  Widget _buildExpenseGrid() {
    return Column(
      children: [
        // Row 1: Makanan, Transportasi, Rumah
        Row(
          children: [
            Expanded(
              child: CategoryTile(
                icon: _getExpenseIcon(ExpenseCategory.makanan),
                label: ExpenseCategory.makanan.displayName,
                isSelected: selectedExpenseCategory == ExpenseCategory.makanan,
                onTap: () => onExpenseCategorySelected?.call(ExpenseCategory.makanan),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryTile(
                icon: _getExpenseIcon(ExpenseCategory.transportasi),
                label: ExpenseCategory.transportasi.displayName,
                isSelected: selectedExpenseCategory == ExpenseCategory.transportasi,
                onTap: () => onExpenseCategorySelected?.call(ExpenseCategory.transportasi),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryTile(
                icon: _getExpenseIcon(ExpenseCategory.rumah),
                label: ExpenseCategory.rumah.displayName,
                isSelected: selectedExpenseCategory == ExpenseCategory.rumah,
                onTap: () => onExpenseCategorySelected?.call(ExpenseCategory.rumah),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 2: Anak, Kesehatan, Lainnya
        Row(
          children: [
            Expanded(
              child: CategoryTile(
                icon: _getExpenseIcon(ExpenseCategory.anak),
                label: ExpenseCategory.anak.displayName,
                isSelected: selectedExpenseCategory == ExpenseCategory.anak,
                onTap: () => onExpenseCategorySelected?.call(ExpenseCategory.anak),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryTile(
                icon: _getExpenseIcon(ExpenseCategory.kesehatan),
                label: ExpenseCategory.kesehatan.displayName,
                isSelected: selectedExpenseCategory == ExpenseCategory.kesehatan,
                onTap: () => onExpenseCategorySelected?.call(ExpenseCategory.kesehatan),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryTile(
                icon: _getExpenseIcon(ExpenseCategory.lainnya),
                label: ExpenseCategory.lainnya.displayName,
                isSelected: selectedExpenseCategory == ExpenseCategory.lainnya,
                onTap: () => onExpenseCategorySelected?.call(ExpenseCategory.lainnya),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIncomeGrid() {
    return Column(
      children: [
        // Row 1: Gaji, Usaha, Bantuan
        Row(
          children: [
            Expanded(
              child: CategoryTile(
                icon: _getIncomeIcon(IncomeSource.gaji),
                label: IncomeSource.gaji.displayName,
                isSelected: selectedIncomeSource == IncomeSource.gaji,
                onTap: () => onIncomeSourceSelected?.call(IncomeSource.gaji),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryTile(
                icon: _getIncomeIcon(IncomeSource.usaha),
                label: IncomeSource.usaha.displayName,
                isSelected: selectedIncomeSource == IncomeSource.usaha,
                onTap: () => onIncomeSourceSelected?.call(IncomeSource.usaha),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryTile(
                icon: _getIncomeIcon(IncomeSource.bantuan),
                label: IncomeSource.bantuan.displayName,
                isSelected: selectedIncomeSource == IncomeSource.bantuan,
                onTap: () => onIncomeSourceSelected?.call(IncomeSource.bantuan),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 2: Hadiah, Lainnya, Empty
        Row(
          children: [
            Expanded(
              child: CategoryTile(
                icon: _getIncomeIcon(IncomeSource.hadiah),
                label: IncomeSource.hadiah.displayName,
                isSelected: selectedIncomeSource == IncomeSource.hadiah,
                onTap: () => onIncomeSourceSelected?.call(IncomeSource.hadiah),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryTile(
                icon: _getIncomeIcon(IncomeSource.lainnya),
                label: IncomeSource.lainnya.displayName,
                isSelected: selectedIncomeSource == IncomeSource.lainnya,
                onTap: () => onIncomeSourceSelected?.call(IncomeSource.lainnya),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // Empty space for alignment
          ],
        ),
      ],
    );
  }
}
