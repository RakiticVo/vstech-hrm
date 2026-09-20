import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/router/app_router.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/theme/app_theme.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

/// Root application widget configuring Theme, Router, Bloc, and Localization.
class VSTechHrmApp extends StatefulWidget {
  const new({super.key});

  @override
  State<VSTechHrmApp> createState() => _VSTechHrmAppState();
}

class _VSTechHrmAppState extends State<VSTechHrmApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(authCubit: sl<AuthCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: sl<AuthCubit>(),
      child: MaterialApp.router(
        title: 'VSTech HRM',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
