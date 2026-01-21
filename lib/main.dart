import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/Feature/authentication/ui/login_view.dart';
import 'package:herbal_app/core/dependecy_injector/service_locator.dart';
import 'package:herbal_app/main_navigation.dart';
import 'package:herbal_app/core/themes/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

void main() async {
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_KEY"]!,
  );
  await setupServiceLocator();
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Herbal App',
            themeMode: ThemeMode.light,
            darkTheme: AppTheme.dark,
            theme: AppTheme.light,
            home: state is AuthAuthenticated
                ? const MainNavigation()
                : const LoginPage(),
          );
        },
      ),
    );
  }
}

ThemeData tema = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xAAF5F5F5),
    brightness: Brightness.light,
    primary: const Color(0xAA0A400C),
    secondary: const Color(0xAAB6CBBD),
    surface: const Color(0xAAFFFFFF),
  ),
);
