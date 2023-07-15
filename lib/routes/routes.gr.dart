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
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/material.dart' as _i20;

import '../admin/home/admin_home_screen.dart' as _i5;
import '../admin/manage/admin_view_booking.dart' as _i10;
import '../admin/manage/admin_view_users.dart' as _i11;
import '../admin/manage/bus/add_bus.dart' as _i14;
import '../admin/manage/bus/admin_manage_bus.dart' as _i6;
import '../admin/manage/bus/edit_bus.dart' as _i15;
import '../admin/manage/bus_route/add_route.dart' as _i17;
import '../admin/manage/bus_route/admin_manage_route.dart' as _i8;
import '../admin/manage/bus_route/view_route_info.dart' as _i18;
import '../admin/manage/driver/add_driver.dart' as _i12;
import '../admin/manage/driver/admin_manage_driver.dart' as _i7;
import '../admin/manage/driver/edit_driver.dart' as _i13;
import '../admin/manage/driver/select_driver.dart' as _i16;
import '../admin/manage/schedule/admin_manage_schdedule.dart' as _i9;
import '../models/bus.dart' as _i22;
import '../models/driver.dart' as _i21;
import '../models/route.dart' as _i23;
import '../screens/home/home_screen.dart' as _i4;
import '../screens/login/login_screen.dart' as _i2;
import '../screens/registeration/register_screen.dart' as _i3;
import '../screens/splash/splash_screen.dart' as _i1;

class AppRouter extends _i19.RootStackRouter {
  AppRouter([_i20.GlobalKey<_i20.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i19.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    RegisterationRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.RegisterationScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.HomeScreen(),
      );
    },
    AdminRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.AdminScreen(),
      );
    },
    ManageBusRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ManageBusScreen(),
      );
    },
    ManageDriverRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.ManageDriverScreen(),
      );
    },
    ManageRouteRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.ManageRouteScreen(),
      );
    },
    ManageScheduleRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.ManageScheduleScreen(),
      );
    },
    ViewBookingRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.ViewBookingScreen(),
      );
    },
    ViewUserRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.ViewUserScreen(),
      );
    },
    AddDriverRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.AddDriverScreen(),
      );
    },
    EditDriverRoute.name: (routeData) {
      final args = routeData.argsAs<EditDriverRouteArgs>();
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i13.EditDriverScreen(
          key: args.key,
          driver: args.driver,
        ),
      );
    },
    AddBusRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i14.AddBusScreen(),
      );
    },
    EditBusRoute.name: (routeData) {
      final args = routeData.argsAs<EditBusRouteArgs>();
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i15.EditBusScreen(
          key: args.key,
          bus: args.bus,
        ),
      );
    },
    SelectDriverRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i16.SelectDriverScreen(),
      );
    },
    AddRouteRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i17.AddRouteScreen(),
      );
    },
    ViewRouteInfoRoute.name: (routeData) {
      final args = routeData.argsAs<ViewRouteInfoRouteArgs>();
      return _i19.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i18.ViewRouteInfoScreen(
          key: args.key,
          route: args.route,
        ),
      );
    },
  };

  @override
  List<_i19.RouteConfig> get routes => [
        _i19.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i19.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i19.RouteConfig(
          RegisterationRoute.name,
          path: '/register',
        ),
        _i19.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i19.RouteConfig(
          AdminRoute.name,
          path: '/admin',
        ),
        _i19.RouteConfig(
          ManageBusRoute.name,
          path: '/manage-bus',
        ),
        _i19.RouteConfig(
          ManageDriverRoute.name,
          path: '/manage-driver',
        ),
        _i19.RouteConfig(
          ManageRouteRoute.name,
          path: '/manage-route',
        ),
        _i19.RouteConfig(
          ManageScheduleRoute.name,
          path: '/manage-schedule',
        ),
        _i19.RouteConfig(
          ViewBookingRoute.name,
          path: '/view-booking',
        ),
        _i19.RouteConfig(
          ViewUserRoute.name,
          path: '/view-user',
        ),
        _i19.RouteConfig(
          AddDriverRoute.name,
          path: '/add-driver',
        ),
        _i19.RouteConfig(
          EditDriverRoute.name,
          path: '/edit-driver:driver',
        ),
        _i19.RouteConfig(
          AddBusRoute.name,
          path: '/add-bus',
        ),
        _i19.RouteConfig(
          EditBusRoute.name,
          path: '/edit-bus:bus',
        ),
        _i19.RouteConfig(
          SelectDriverRoute.name,
          path: '/select-driver',
        ),
        _i19.RouteConfig(
          AddRouteRoute.name,
          path: '/add-route',
        ),
        _i19.RouteConfig(
          ViewRouteInfoRoute.name,
          path: '/view-route-info:route',
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashRoute extends _i19.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i19.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.RegisterationScreen]
class RegisterationRoute extends _i19.PageRouteInfo<void> {
  const RegisterationRoute()
      : super(
          RegisterationRoute.name,
          path: '/register',
        );

  static const String name = 'RegisterationRoute';
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i19.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i5.AdminScreen]
class AdminRoute extends _i19.PageRouteInfo<void> {
  const AdminRoute()
      : super(
          AdminRoute.name,
          path: '/admin',
        );

  static const String name = 'AdminRoute';
}

/// generated route for
/// [_i6.ManageBusScreen]
class ManageBusRoute extends _i19.PageRouteInfo<void> {
  const ManageBusRoute()
      : super(
          ManageBusRoute.name,
          path: '/manage-bus',
        );

  static const String name = 'ManageBusRoute';
}

/// generated route for
/// [_i7.ManageDriverScreen]
class ManageDriverRoute extends _i19.PageRouteInfo<void> {
  const ManageDriverRoute()
      : super(
          ManageDriverRoute.name,
          path: '/manage-driver',
        );

  static const String name = 'ManageDriverRoute';
}

/// generated route for
/// [_i8.ManageRouteScreen]
class ManageRouteRoute extends _i19.PageRouteInfo<void> {
  const ManageRouteRoute()
      : super(
          ManageRouteRoute.name,
          path: '/manage-route',
        );

  static const String name = 'ManageRouteRoute';
}

/// generated route for
/// [_i9.ManageScheduleScreen]
class ManageScheduleRoute extends _i19.PageRouteInfo<void> {
  const ManageScheduleRoute()
      : super(
          ManageScheduleRoute.name,
          path: '/manage-schedule',
        );

  static const String name = 'ManageScheduleRoute';
}

/// generated route for
/// [_i10.ViewBookingScreen]
class ViewBookingRoute extends _i19.PageRouteInfo<void> {
  const ViewBookingRoute()
      : super(
          ViewBookingRoute.name,
          path: '/view-booking',
        );

  static const String name = 'ViewBookingRoute';
}

/// generated route for
/// [_i11.ViewUserScreen]
class ViewUserRoute extends _i19.PageRouteInfo<void> {
  const ViewUserRoute()
      : super(
          ViewUserRoute.name,
          path: '/view-user',
        );

  static const String name = 'ViewUserRoute';
}

/// generated route for
/// [_i12.AddDriverScreen]
class AddDriverRoute extends _i19.PageRouteInfo<void> {
  const AddDriverRoute()
      : super(
          AddDriverRoute.name,
          path: '/add-driver',
        );

  static const String name = 'AddDriverRoute';
}

/// generated route for
/// [_i13.EditDriverScreen]
class EditDriverRoute extends _i19.PageRouteInfo<EditDriverRouteArgs> {
  EditDriverRoute({
    _i20.Key? key,
    required _i21.Driver driver,
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

  final _i20.Key? key;

  final _i21.Driver driver;

  @override
  String toString() {
    return 'EditDriverRouteArgs{key: $key, driver: $driver}';
  }
}

/// generated route for
/// [_i14.AddBusScreen]
class AddBusRoute extends _i19.PageRouteInfo<void> {
  const AddBusRoute()
      : super(
          AddBusRoute.name,
          path: '/add-bus',
        );

  static const String name = 'AddBusRoute';
}

/// generated route for
/// [_i15.EditBusScreen]
class EditBusRoute extends _i19.PageRouteInfo<EditBusRouteArgs> {
  EditBusRoute({
    _i20.Key? key,
    required _i22.Bus bus,
  }) : super(
          EditBusRoute.name,
          path: '/edit-bus:bus',
          args: EditBusRouteArgs(
            key: key,
            bus: bus,
          ),
        );

  static const String name = 'EditBusRoute';
}

class EditBusRouteArgs {
  const EditBusRouteArgs({
    this.key,
    required this.bus,
  });

  final _i20.Key? key;

  final _i22.Bus bus;

  @override
  String toString() {
    return 'EditBusRouteArgs{key: $key, bus: $bus}';
  }
}

/// generated route for
/// [_i16.SelectDriverScreen]
class SelectDriverRoute extends _i19.PageRouteInfo<void> {
  const SelectDriverRoute()
      : super(
          SelectDriverRoute.name,
          path: '/select-driver',
        );

  static const String name = 'SelectDriverRoute';
}

/// generated route for
/// [_i17.AddRouteScreen]
class AddRouteRoute extends _i19.PageRouteInfo<void> {
  const AddRouteRoute()
      : super(
          AddRouteRoute.name,
          path: '/add-route',
        );

  static const String name = 'AddRouteRoute';
}

/// generated route for
/// [_i18.ViewRouteInfoScreen]
class ViewRouteInfoRoute extends _i19.PageRouteInfo<ViewRouteInfoRouteArgs> {
  ViewRouteInfoRoute({
    _i20.Key? key,
    required _i23.Route route,
  }) : super(
          ViewRouteInfoRoute.name,
          path: '/view-route-info:route',
          args: ViewRouteInfoRouteArgs(
            key: key,
            route: route,
          ),
        );

  static const String name = 'ViewRouteInfoRoute';
}

class ViewRouteInfoRouteArgs {
  const ViewRouteInfoRouteArgs({
    this.key,
    required this.route,
  });

  final _i20.Key? key;

  final _i23.Route route;

  @override
  String toString() {
    return 'ViewRouteInfoRouteArgs{key: $key, route: $route}';
  }
}
