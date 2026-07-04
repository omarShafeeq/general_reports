import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_reports/app.dart';
import 'package:general_reports/blocs/theme/theme_cubit.dart';
import 'package:general_reports/report_engine/blocs/report_registry_cubit.dart';
import 'package:general_reports/report_engine/config/report_registry.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => ReportRegistryCubit()..registerAll(allReportDefinitions),
        ),
      ],
      child: const App(),
    ),
  );
}
