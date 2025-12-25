import 'package:bloc/bloc.dart';
import 'package:herbal_app/data/models/seller_model.dart';
import 'package:herbal_app/data/services/auth_services.dart';
import 'package:herbal_app/data/services/seller_services.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SellerServices sellerServices = SellerServices();
  final authServices = AuthServices();
  
  SettingsBloc() : super(SettingsInitial()) {
    on<CreateSellerProfileEvent>(_onCreateSellerProfile);
    on<ResetSellerProfileEvent>(_onResetSellerProfile);
  }


  Future<void> _onCreateSellerProfile(
    CreateSellerProfileEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SellerProfileLoading());
    try {
      final profile = await sellerServices.createProfile(event.data, event.userId);
      final activeRole = await authServices.getActiveRole();
      print('Role saat ini: ${activeRole?.roleName}');
      
      // Assign role penjual (user sekarang punya 2 role)
      bool success = await authServices.assignRole('penjual', setActive: true);
      if (success) {
        print('Berhasil upgrade ke penjual!');
      }
      emit(SellerProfileSuccess(profile));
    } catch (e) {
      emit(SellerProfileError(e.toString()));
    }
  }

  void _onResetSellerProfile(
    ResetSellerProfileEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(SellerProfileInitial());
  }
}
