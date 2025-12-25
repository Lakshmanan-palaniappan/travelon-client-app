import 'package:Travelon/core/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void showThemeSelector(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      final cubit = context.read<ThemeCubit>();

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _themeTile(context, "System", ThemeMode.system, cubit),
            _themeTile(context, "Light", ThemeMode.light, cubit),
            _themeTile(context, "Dark", ThemeMode.dark, cubit),
          ],
        ),
      );
    },
  );
}

Widget _themeTile(
  BuildContext context,
  String title,
  ThemeMode mode,
  ThemeCubit cubit,
) {
  return ListTile(
    title: Text(title),
    trailing: cubit.state.mode == mode
        ? const Icon(Icons.check, color: Colors.green)
        : null,
    onTap: () {
      cubit.setTheme(mode);
      Navigator.pop(context);
    },
  );
}
