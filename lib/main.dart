import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chabo/l10n/app_localizations.dart';
import 'package:chabo/models/models.dart';
import 'blocs/blocs.dart';
import 'screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String _fontFamily = 'openhuninn';

  @override
  Widget build(context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      builder: (context, child) {
        DeviceModel.init(context: context);
        return MultiBlocProvider(
          providers: [
            BlocProvider<AlarmClockBloc>(create: (context) => AlarmClockBloc()..add(const AlarmClockListed())),
            BlocProvider<DialogBloc>(create: (context) => DialogBloc()),
            BlocProvider<AlarmClockFormBloc>(create: (context) => AlarmClockFormBloc()),
          ],
          child: MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('zh')],
            locale: const Locale('en'),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: _fontFamily,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
              useMaterial3: true,
            ),
            home: child,
          ),
        );
      },
      child: const HomeScreen(),
    );
  }
}
