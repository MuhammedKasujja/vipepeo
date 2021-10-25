import 'package:flutter/material.dart';
import 'package:vipepeo_app/screens/screens.dart';

final Map<String, WidgetBuilder> appRoutes = <String, WidgetBuilder>{
  Routes.splash: (BuildContext context) => const SplashScreen(),
  Routes.home: (BuildContext context) => const HomeScreen(),
  Routes.login: (context) =>
      const LoginScreen(), //LoginPage(), //EnableLocationPage(),
  Routes.register: (context) => const RegisterScreen(),
  Routes.changePassword: (context) => const ChangePasswordScreen(),
  // Routes.forgotPassword: (context) => ForgotPasswordPage(),
  Routes.profile: (context) => const UserProfileScreen(),
  // Routes.lockScreen: (context) => PasswordLockScreen(),
  // Routes.dashboard: (context) => DashboardPage(),
  // Routes.settings: (context) => SettingsMenuPage(),
};

class Routes {
  Routes._();
  static const home = '/home';
  static const login = '/';
  static const register = '/register';
  static const changePassword = '/change_password';
  static const forgotPassword = '/forgot_password';
  static const history = '/history';
  static const profile = '/profile';
  static const splash = '/splah';
  static const lockScreen = '/lockScreen';
  static const dashboard = '/dashboard';
  static const settings = '/settings';
  static const test = '/test';
}
