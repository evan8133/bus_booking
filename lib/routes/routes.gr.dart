// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/material.dart' as _i15;

import '../admin/home/admin_home_screen.dart' as _i5;
import '../admin/manage/admin_view_booking.dart' as _i10;
import '../admin/manage/admin_view_users.dart' as _i11;
import '../admin/manage/bus/admin_manage_bus.dart' as _i6;
import '../admin/manage/bus_route/admin_manage_route.dart' as _i8;
import '../admin/manage/driver/add_driver.dart' as _i12;
import '../admin/manage/driver/admin_manage_driver.dart' as _i7;
import '../admin/manage/driver/edit_driver.dart' as _i13;
import '../admin/manage/schedule/admin_manage_schdedule.dart' as _i9;
import '../models/driver.dart' as _i16;
import '../screens/home/home_screen.dart' as _i4;
import '../screens/login/login_screen.dart' as _i2;
import '../screens/registeration/register_screen.dart' as _i3;
import '../screens/splash/splash_screen.dart' as _i1;

class AppRouter extends _i14.RootStackRouter {
  AppRouter([_i15.GlobalKey<_i15.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    RegisterationRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.RegisterationScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.HomeScreen(),
      );
    },
    AdminRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.AdminScreen(),
      );
    },
    ManageBusRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ManageBusScreen(),
      );
    },
    ManageDriverRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.ManageDriverScreen(),
      );
    },
    ManageRouteRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.ManageRouteScreen(),
      );
    },
    ManageScheduleRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.ManageScheduleScreen(),
      );
    },
    ViewBookingRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.ViewBookingScreen(),
      );
    },
    ViewUserRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.ViewUserScreen(),
      );
    },
    AddDriverRoute.name: (routeData) {
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.AddDriverScreen(),
      );
    },
    EditDriverRoute.name: (routeData) {
      final args = routeData.argsAs<EditDriverRouteArgs>();
      return _i14.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i13.EditDriverScreen(
          key: args.key,
          driver: args.driver,
        ),
      );
    },
  };

  @override
  List<_i14.RouteConfig> get routes => [
        _i14.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i14.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i14.RouteConfig(
          RegisterationRoute.name,
          path: '/register',
        ),
        _i14.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i14.RouteConfig(
          AdminRoute.name,
          path: '/admin',
        ),
        _i14.RouteConfig(
          ManageBusRoute.name,
          path: '/manage-bus',
        ),
        _i14.RouteConfig(
          ManageDriverRoute.name,
          path: '/manage-driver',
        ),
        _i14.RouteConfig(
          ManageRouteRoute.name,
          path: '/manage-route',
        ),
        _i14.RouteConfig(
          ManageScheduleRoute.name,
          path: '/manage-schedule',
        ),
        _i14.RouteConfig(
          ViewBookingRoute.name,
          path: '/view-booking',
        ),
        _i14.RouteConfig(
          ViewUserRoute.name,
          path: '/view-user',
        ),
        _i14.RouteConfig(
          AddDriverRoute.name,
          path: '/add-driver',
        ),
        _i14.RouteConfig(
          EditDriverRoute.name,
          path: '/edit-driver:driver',
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashRoute extends _i14.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i14.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.RegisterationScreen]
class RegisterationRoute extends _i14.PageRouteInfo<void> {
  const RegisterationRoute()
      : super(
          RegisterationRoute.name,
          path: '/register',
        );

  static const String name = 'RegisterationRoute';
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i14.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i5.AdminScreen]
class AdminRoute extends _i14.PageRouteInfo<void> {
  const AdminRoute()
      : super(
          AdminRoute.name,
          path: '/admin',
        );

  static const String name = 'AdminRoute';
}

/// generated route for
/// [_i6.ManageBusScreen]
class ManageBusRoute extends _i14.PageRouteInfo<void> {
  const ManageBusRoute()
      : super(
          ManageBusRoute.name,
          path: '/manage-bus',
        );

  static const String name = 'ManageBusRoute';
}

/// generated route for
/// [_i7.ManageDriverScreen]
class ManageDriverRoute extends _i14.PageRouteInfo<void> {
  const ManageDriverRoute()
      : super(
          ManageDriverRoute.name,
          path: '/manage-driver',
        );

  static const String name = 'ManageDriverRoute';
}

/// generated route for
/// [_i8.ManageRouteScreen]
class ManageRouteRoute extends _i14.PageRouteInfo<void> {
  const ManageRouteRoute()
      : super(
          ManageRouteRoute.name,
          path: '/manage-route',
        );

  static const String name = 'ManageRouteRoute';
}

/// generated route for
/// [_i9.ManageScheduleScreen]
class ManageScheduleRoute extends _i14.PageRouteInfo<void> {
  const ManageScheduleRoute()
      : super(
          ManageScheduleRoute.name,
          path: '/manage-schedule',
        );

  static const String name = 'ManageScheduleRoute';
}

/// generated route for
/// [_i10.ViewBookingScreen]
class ViewBookingRoute extends _i14.PageRouteInfo<void> {
  const ViewBookingRoute()
      : super(
          ViewBookingRoute.name,
          path: '/view-booking',
        );

  static const String name = 'ViewBookingRoute';
}

/// generated route for
/// [_i11.ViewUserScreen]
class ViewUserRoute extends _i14.PageRouteInfo<void> {
  const ViewUserRoute()
      : super(
          ViewUserRoute.name,
          path: '/view-user',
        );

  static const String name = 'ViewUserRoute';
}

/// generated route for
/// [_i12.AddDriverScreen]
class AddDriverRoute extends _i14.PageRouteInfo<void> {
  const AddDriverRoute()
      : super(
          AddDriverRoute.name,
          path: '/add-driver',
        );

  static const String name = 'AddDriverRoute';
}

/// generated route for
/// [_i13.EditDriverScreen]
class EditDriverRoute extends _i14.PageRouteInfo<EditDriverRouteArgs> {
  EditDriverRoute({
    _i15.Key? key,
    required _i16.Driver driver,
  }) : super(
          EditDriverRoute.name,
          path: '/edit-driver:driver',
          args: EditDriverRouteArgs(
            key: key,
            driver: driver,
          ),
        );

  static const String name = 'EditDriverRoute';
}

class EditDriverRouteArgs {
  const EditDriverRouteArgs({
    this.key,
    required this.driver,
  });

  final _i15.Key? key;

  final _i16.Driver driver;

  @override
  String toString() {
    return 'EditDriverRouteArgs{key: $key, driver: $driver}';
  }
}
