import 'package:Travelon/core/utils/theme/cubit/theme_cubit.dart';
import 'package:Travelon/core/utils/theme/cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Travelon/core/utils/theme/AppTheme.dart';

import 'package:Travelon/routes/app_router.dart';

class YenApp extends StatelessWidget {
  const YenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: state.mode, // ✅ dynamic
          routerConfig: appRouter,
        );
      },
    );
  }
}
