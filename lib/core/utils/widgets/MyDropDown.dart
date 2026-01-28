import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';

class MyDropdown<T> extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final double width;
  final double radius;

  const MyDropdown({
    super.key,
    this.labelText,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.width = double.infinity,
    this.radius = 14.0,
  });

String _labelForValue() {
  if (value == null) return hintText;

  final item = items.firstWhere((e) => e.value == value);

  if (item.child is Text) {
    return (item.child as Text).data ?? hintText;
  }

  return hintText;
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        AppColors.surfaceDark;

    final borderColor =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;

    final textColor =
        isDark ? AppColors.Light : AppColors.Dark;

    final hintColor =
        AppColors.secondaryLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: GestureDetector(
        onTap: () => _openSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
  _labelForValue(),
  style: theme.textTheme.bodyMedium?.copyWith(
    color: value == null ? hintColor : textColor,
    fontWeight: FontWeight.w500,
  ),
),

              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: borderColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _DropdownSearchSheet<T>(
          items: items,
          onChanged: onChanged,
        );
      },
    );
  }
}

/* ───────────────── SEARCH SHEET ───────────────── */

class _DropdownSearchSheet<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownSearchSheet({
    required this.items,
    required this.onChanged,
  });

  @override
  State<_DropdownSearchSheet<T>> createState() =>
      _DropdownSearchSheetState<T>();
}

class _DropdownSearchSheetState<T>
    extends State<_DropdownSearchSheet<T>> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        AppColors.surfaceDark;

    final textColor =
        isDark ? AppColors.Light : AppColors.primaryDark;

    final filtered = widget.items.where((item) {
      return item.child
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // 🔍 SEARCH
            TextField(
              style: TextStyle(
                color: AppColors.Light,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppColors.primaryDark,
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: AppColors.textDisabledDark,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.MenuButton,
                  size: 22,
                ),
                filled: true,
                fillColor: AppColors.surfaceDark.withOpacity(0.85),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.primaryDark.withOpacity(0.35),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.primaryDark,
                    width: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 📋 LIST
Expanded(
  child: ListView.separated(
    physics: const BouncingScrollPhysics(),
    itemCount: filtered.length,
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder: (_, index) {
      final item = filtered[index];

      final label = item.child is Text
          ? (item.child as Text).data ?? ''
          : '';

      return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          widget.onChanged(item.value);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark.withOpacity(0.15),
                AppColors.surfaceDark,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryDark.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.Light,
              fontWeight: FontWeight.w600,
              fontSize: 15.5,
              letterSpacing: 0.3,
            ),
          ),
        ),
      );
    },
  ),
),

          ],
        ),
      ),
    );
  }
}
