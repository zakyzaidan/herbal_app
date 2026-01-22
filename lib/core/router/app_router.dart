// lib/core/router/app_router.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/Feature/authentication/ui/form_create_practitioner.dart';
import 'package:herbal_app/Feature/authentication/ui/form_create_seller.dart';
import 'package:herbal_app/Feature/authentication/ui/login_view.dart';
import 'package:herbal_app/Feature/authentication/ui/otp_verification_view.dart';
import 'package:herbal_app/Feature/authentication/ui/register_view.dart';
import 'package:herbal_app/Feature/home/bloc/home_bloc.dart';
import 'package:herbal_app/Feature/home/ui/home_screen.dart';
import 'package:herbal_app/Feature/praktisi/bloc/praktisi_bloc.dart';
import 'package:herbal_app/Feature/praktisi/ui/praktisi_view.dart';
import 'package:herbal_app/Feature/praktisi/ui/practitioner_detail_view.dart';
import 'package:herbal_app/Feature/product/bloc/product_bloc.dart';
import 'package:herbal_app/Feature/product/ui/form_create_product_view.dart';
import 'package:herbal_app/Feature/product/ui/form_edit_product_view.dart';
import 'package:herbal_app/Feature/product/ui/product_detail_view.dart';
import 'package:herbal_app/Feature/product/ui/product_view.dart';
import 'package:herbal_app/Feature/profile/ui/form_edit_practitioner.dart';
import 'package:herbal_app/Feature/profile/ui/profil_view.dart';
import 'package:herbal_app/Feature/settings/ui/settings_view.dart';
import 'package:herbal_app/Feature/forum/ui/forums_home_view.dart';
import 'package:herbal_app/core/dependecy_injector/service_locator.dart';
import 'package:herbal_app/core/router/shell_route_scaffold.dart';
import 'package:herbal_app/data/models/practitioner_model.dart';
import 'package:herbal_app/data/models/product_cart_model.dart';
import 'package:herbal_app/data/models/product_model.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  final navigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    navigatorKey: navigatorKey,
    redirect: (context, state) {
      final authState = authBloc.state;

      final isSplash = state.matchedLocation == '/splash';
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      final isAuthenticated = authState is AuthAuthenticated;

      if (authState is AuthInitial) {
        return isSplash ? null : '/splash';
      }

      if (isSplash) {
        return isAuthenticated ? '/home' : '/auth/login';
      }

      if (!isAuthenticated && !isGoingToAuth) {
        return '/auth/login';
      }

      return null;
    },

    routes: [
      // ===== SPLASH SCREEN =====
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ===== AUTHENTICATION ROUTES =====
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/auth/login',
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: 'otp-verification',
            name: 'otp-verification',
            builder: (context, state) {
              final extra = state.extra as Map<String, String>?;
              return OTPVerificationPage(
                email: extra?['email'] ?? '',
                pass: extra?['pass'] ?? '',
              );
            },
          ),
          GoRoute(
            path: '/auth/create-seller',
            name: 'create-seller',
            builder: (context, state) => const SellerProfileFormScreen(),
          ),
          GoRoute(
            path: '/auth/create-practitioner',
            name: 'create-practitioner',
            builder: (context, state) => const PractitionerProfileFormScreen(),
          ),
        ],
      ),

      // ===== MAIN APP SHELL (Bottom Navigation) =====
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(
                create: (_) => getIt<HomeBloc>()..add(LoadHomeDataEvent()),
              ),
              BlocProvider<ProductBloc>(create: (_) => getIt<ProductBloc>()),
              BlocProvider<PraktisiBloc>(create: (_) => getIt<PraktisiBloc>()),
            ],
            child: BottomNavigation(navshell: child),
          );
        },
        branches: [
          // HOME
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const HomeScreen()),
              ),
            ],
          ),

          // PRODUCTS
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                name: 'products',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const ProductView()),
                routes: [
                  // ===== PRODUCT DETAIL ROUTES =====
                  GoRoute(
                    parentNavigatorKey: navigatorKey,
                    path: '/:id',
                    name: 'product-detail',
                    builder: (context, state) {
                      final product = state.extra as ProductCartModel;
                      state.extra as ProductCartModel;
                      return BlocProvider.value(
                        value: getIt<ProductBloc>()
                          ..add(
                            LoadProductDetailEvent(product.id, authBloc.state),
                          ),
                        child: ProductDetailView(),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: navigatorKey,
                    path: '/create',
                    name: 'product-create',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return BlocProvider.value(
                        value: getIt<ProductBloc>(),
                        child: ProductFormScreen(
                          umkmId: extra?['umkmId'] ?? '',
                          isFirstProduct: extra?['isFirstProduct'] ?? false,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: navigatorKey,
                    path: '/:id/edit',
                    name: 'product-edit',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return BlocProvider.value(
                        value: getIt<ProductBloc>(),
                        child: ProductEditFormScreen(
                          product: extra['product'] as Product,
                          umkmId: extra['umkmId'] as String,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // FORUMS
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/forums',
                name: 'forums',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const ForumsHomeView()),
              ),
            ],
          ),

          // PRACTITIONERS
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/practitioners',
                name: 'practitioners',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const PraktisiView()),
                routes: [
                  // ===== PRACTITIONER ROUTES =====
                  GoRoute(
                    parentNavigatorKey: navigatorKey,
                    path: '/:id',
                    name: 'practitioner-detail',
                    builder: (context, state) {
                      final practitioner = state.extra as PractitionerProfile;
                      return PractitionerDetailView(practitioner: practitioner);
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: navigatorKey,
                    path: '/:id/edit',
                    name: 'practitioner-edit',
                    builder: (context, state) {
                      final profile = state.extra as PractitionerProfile;
                      return PractitionerEditFormScreen(profile: profile);
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const ProfilView()),
              ),
            ],
          ),
          // PROFILE
        ],
      ),

      // ===== SETTINGS =====
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// ===== HELPER: GoRouter Refresh Stream =====
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// ===== SPLASH SCREEN =====
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Theme.of(context).primaryColor.toARGB32()),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_filled, size: 100, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Herbal App',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
