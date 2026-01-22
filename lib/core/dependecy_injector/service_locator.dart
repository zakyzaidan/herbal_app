// lib/core/di/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:herbal_app/Feature/authentication/bloc/auth_bloc.dart';
import 'package:herbal_app/Feature/home/bloc/home_bloc.dart';
import 'package:herbal_app/Feature/praktisi/bloc/praktisi_bloc.dart';
import 'package:herbal_app/Feature/product/bloc/product_bloc.dart';
import 'package:herbal_app/core/router/app_router.dart';
import 'package:herbal_app/data/services/auth_services.dart';
import 'package:herbal_app/data/services/practitioner_services.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ========== External Dependencies ==========
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // ========== Services (Singleton) ==========
  getIt.registerLazySingleton<AuthServices>(() => AuthServices());
  getIt.registerLazySingleton<SellerServices>(() => SellerServices());
  getIt.registerLazySingleton<PractitionerServices>(
    () => PractitionerServices(),
  );

  // ========== BLoCs ==========

  // AuthBloc - Singleton (shared across app)
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc()..add(AuthCheckRequested()),
  );

  // Other BLoCs - Factory (new instance setiap kali dipanggil)
  getIt.registerFactory<ProductBloc>(() => ProductBloc());

  getIt.registerFactory<HomeBloc>(() => HomeBloc());

  getIt.registerFactory<PraktisiBloc>(() => PraktisiBloc());

  // ========== Router (Singleton) ==========
  getIt.registerLazySingleton<AppRouter>(() => AppRouter(getIt<AuthBloc>()));
}
