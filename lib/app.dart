import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_reports/blocs/theme/theme_cubit.dart';
import 'package:general_reports/blocs/theme/theme_state.dart';
import 'package:general_reports/routing/app_router.dart';
import 'package:general_reports/l10n/app_localizations.dart';
import 'package:general_reports/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp.router(
          title: 'Enterprise Reports',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeState.themeMode,
          locale: themeState.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: _router,
          builder: (context, child) {
            return Directionality(
              textDirection:
                  themeState.isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
        );
      },
    );
  }
}
