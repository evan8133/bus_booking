import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/services/auth_services.dart';
import 'package:bus_booking/services/bus_services.dart';
import 'package:bus_booking/services/driver_services.dart';
import 'package:bus_booking/services/route_services.dart';
import 'package:bus_booking/services/schedule_services.dart';
import 'package:bus_booking/services/users_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebsaeAuthMethods>(
          create: (_) => FirebsaeAuthMethods(FirebaseAuth.instance),
        ),
        Provider<DriverService>(
          create: (_) => DriverService(),
        ),
        Provider<BusService>(
          create: (_) => BusService(),
        ),
        Provider<RouteService>(
          create: (_) => RouteService(),
        ),
        Provider<ScheduleService>(
          create: (_) => ScheduleService(),
        ),
        Provider<UserService>(
          create: (_) => UserService(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: FlexThemeData.light(
          scheme: FlexScheme.flutterDash,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.flutterDash,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        themeMode: ThemeMode.system,
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        builder: (context, router) {
          // initialize screen util here
          ScreenUtil.init(
            context,
            designSize: const Size(360, 690),
          );
          return router!;
        },
      ),
    );
  }
}
