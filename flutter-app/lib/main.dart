import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttrueno_fo827e642a0c4/app/view/bottom_nab_bar_page.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/signin_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/onboarding/onboarding1.dart';
import 'app/app_manager.dart';
import 'core/services/app_pigeon/app_pigeon.dart';
import 'core/theme/app_theme.dart';
import 'app/widget/background_image.dart';
import 'modules/onboarding/splash_screen.dart';
import 'app/init_dependency.dart';
import 'app/routing/route_names.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initDependencies();

  // Load saved locale from SharedPreferences (language only, no country)
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('lang_code') ?? 'en';

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('bn'),
        Locale('gr'),
        Locale('bs'),
        Locale('de'),
        Locale('el'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('hi'),
        Locale('hu'),
        Locale('id'),
        Locale('it'),
        Locale('ja'),
        Locale('ko'),
        Locale('nl'),
        Locale('pl'),
        Locale('pt'),
        Locale('ro'),
        Locale('ru'),
        Locale('sq'),
        Locale('sw'),
        Locale('th'),
        Locale('zh'),
        Locale('zu'),
      ],
      path: 'assets/lang',
      fallbackLocale: Locale('en'),
      startLocale: Locale(langCode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late AppManager appManager;
  @override
  void initState() {
    super.initState();
    debugPrint("App started");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appManager = AppManager();
    Get.put(appManager);
  }

  @override
  void dispose() async {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Hoplift',
      theme: AppTheme.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteNames.home:
            if (appManager.authStatus is Authenticated) {
              return MaterialPageRoute(
                  builder: (_) => BottomNabBarScreen());  
            } else {
              return MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              );
            }
          case RouteNames.login:
            return MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              );

          case RouteNames.onboarding:
            return MaterialPageRoute(
                builder: (context) {
                  return OnboardingScreen();
                },
              );
          default:
            return MaterialPageRoute(
                builder: (context) {
                  return SplashScreen();
                },
              );
        }
      },
      locale: context.locale,
      builder: (context, child) {
        return BackgroundWidget(child: child ?? const SizedBox());
      },
      home: SplashScreen()
    );
  }
}
