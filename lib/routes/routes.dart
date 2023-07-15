import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/admin/home/admin_home_screen.dart';
import 'package:bus_booking/admin/manage/bus/add_bus.dart';
import 'package:bus_booking/admin/manage/bus/admin_manage_bus.dart';
import 'package:bus_booking/admin/manage/bus/edit_bus.dart';
import 'package:bus_booking/admin/manage/bus_route/add_route.dart';
import 'package:bus_booking/admin/manage/driver/admin_manage_driver.dart';
import 'package:bus_booking/admin/manage/bus_route/admin_manage_route.dart';
import 'package:bus_booking/admin/manage/driver/edit_driver.dart';
import 'package:bus_booking/admin/manage/driver/select_driver.dart';
import 'package:bus_booking/admin/manage/schedule/admin_manage_schdedule.dart';
import 'package:bus_booking/admin/manage/admin_view_booking.dart';
import 'package:bus_booking/admin/manage/admin_view_users.dart';
import 'package:bus_booking/screens/home/home_screen.dart';
import 'package:bus_booking/screens/login/login_screen.dart';
import 'package:bus_booking/screens/registeration/register_screen.dart';

import '../admin/manage/bus_route/edit_route.dart';
import '../admin/manage/bus_route/view_route_info.dart';
import '../admin/manage/driver/add_driver.dart';
import '../admin/manage/schedule/add_schedule.dart';
import '../admin/manage/schedule/edit_schedule.dart';
import '../admin/manage/schedule/view_schedule.dart';
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
    ),
    MaterialRoute(
      page: AdminScreen,
      path: '/admin',
    ),
    MaterialRoute(
      page: ManageBusScreen,
      path: '/manage-bus',
    ),
    MaterialRoute(
      page: ManageDriverScreen,
      path: '/manage-driver',
    ),
    MaterialRoute(
      page: ManageRouteScreen,
      path: '/manage-route',
    ),
    MaterialRoute(
      page: ManageScheduleScreen,
      path: '/manage-schedule',
    ),
    MaterialRoute(
      page: ViewBookingScreen,
      path: '/view-booking',
    ),
    MaterialRoute(
      page: ViewUserScreen,
      path: '/view-user',
    ),
    MaterialRoute(
      page: AddDriverScreen,
      path: '/add-driver',
    ),
    MaterialRoute(
      page: EditDriverScreen,
      path: '/edit-driver:driver',
    ),
    MaterialRoute(
      page: AddBusScreen,
      path: '/add-bus',
    ),
    MaterialRoute(
      page: EditBusScreen,
      path: '/edit-bus:bus',
    ),
    MaterialRoute(
      page: SelectDriverScreen,
      path: '/select-driver',
    ),
    MaterialRoute(
      page: AddRouteScreen,
      path: '/add-route',
    ),
    MaterialRoute(
      page: ViewRouteInfoScreen,
      path: '/view-route-info:route',
    ),
    MaterialRoute(
      page: EditRouteScreen,
      path: '/edit-route:route',
    ),
    MaterialRoute(
      page: AddScheduleScreen,
      path: '/add-schedule',
    ),
    MaterialRoute(
      page: EditScheduleScreen,
      path: '/edit-schedule:schedule',
    ),
    MaterialRoute(
      page: ViewScheduleScreen,
      path: '/view-schedule:schedule',
    ),
  ],
)
class $AppRouter {}
