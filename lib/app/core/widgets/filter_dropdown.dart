import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';

/// Reusable filter dropdown widget
/// Used for Sector Wise and Year Wise filters
class FilterDropdown<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final List<T> items;
  final String Function(T)? itemBuilder;
  final ValueChanged<T?>? onChanged;
  final bool isOpen;
  final VoidCallback? onTap;

  const FilterDropdown({
    super.key,
    required this.label,
    this.selectedValue,
    required this.items,
    this.itemBuilder,
    this.onChanged,
    this.isOpen = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ), // 👈 slightly reduced
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          // ❌ REMOVE mainAxisSize.min
          children: [
            Icon(
              Icons.arrow_drop_down,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 6),

            // ✅ THIS IS THE FIX
            Expanded(
              child: Text(
                selectedValue != null && selectedValue.toString().isNotEmpty
                    ? (itemBuilder != null
                        ? itemBuilder!(selectedValue as T)
                        : selectedValue.toString())
                    : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      selectedValue != null &&
                              selectedValue.toString().isNotEmpty
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dropdown menu widget that displays filter options
class FilterDropdownMenu<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T)? itemBuilder;
  final ValueChanged<T>? onItemSelected;
  final double? width;

  const FilterDropdownMenu({
    super.key,
    required this.items,
    this.itemBuilder,
    this.onItemSelected,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            items.map((item) {
              final isLast = items.last == item;
              return InkWell(
                onTap: () => onItemSelected?.call(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border:
                        isLast
                            ? null
                            : Border(
                              bottom: BorderSide(
                                color: AppColors.divider,
                                width: 0.5,
                              ),
                            ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          itemBuilder != null
                              ? itemBuilder!(item)
                              : item.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
