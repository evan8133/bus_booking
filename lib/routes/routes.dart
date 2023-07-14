import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/screens/home/home_screen.dart';
import 'package:bus_booking/screens/login/login_screen.dart';
import 'package:bus_booking/screens/registeration/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/splash/splash_screen.dart';


@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    MaterialRoute(
      initial: true,
      page: SplashScreen,
      path: '/',
    ),
    MaterialRoute(
      page: LoginScreen,
      path: '/login',
    ),
    MaterialRoute(
      page: RegisterationScreen,
      path: '/register',
    ),
    MaterialRoute(
      page: HomeScreen,
      path: '/home',
    )
  ],
)
class $AppRouter {}
