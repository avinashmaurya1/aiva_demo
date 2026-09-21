import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_bootstrap_usecase.dart';
import '../../domain/usecases/get_saved_session_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetBootstrapUseCase getBootstrapUseCase;
  final GetSavedSessionUseCase getSavedSessionUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthLocalDataSource localDataSource;

  AuthBloc({
    required this.loginUseCase,
    required this.getBootstrapUseCase,
    required this.getSavedSessionUseCase,
    required this.logoutUseCase,
    required this.localDataSource,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading('Checking saved session...'));
    try {
      final (token, profile) = await getSavedSessionUseCase();
      if (token != null && token.accessToken.isNotEmpty) {
        emit(Authenticated(token: token, userProfile: profile));
        return;
      }
    } catch (_) {}

    final (savedCompany, savedUser) = await localDataSource.getRememberedCredentials();
    emit(Unauthenticated(
      savedCompanyId: savedCompany,
      savedUserName: savedUser,
    ));
  }

  Future<void> _onAuthLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading('Signing in...'));
    try {
      final token = await loginUseCase(
        companyId: event.companyId,
        userName: event.userName,
        password: event.password,
        accountNo: event.accountNo,
        source: event.source,
      );

      UserProfile? profile = await localDataSource.getUserProfile();
      if (token.travogBaseUrl != null && token.travogBaseUrl!.isNotEmpty) {
        try {
          profile = await getBootstrapUseCase(
            accessToken: token.accessToken,
            travogBaseUrl: token.travogBaseUrl!,
          );
        } catch (_) {
          // If bootstrap fails, still allow proceeding with token
        }
      }

      emit(Authenticated(token: token, userProfile: profile));
    } catch (e) {
      final (savedCompany, savedUser) = await localDataSource.getRememberedCredentials();
      emit(AuthFailureState(e.toString()));
      emit(Unauthenticated(
        savedCompanyId: event.companyId.isNotEmpty ? event.companyId : savedCompany,
        savedUserName: event.userName.isNotEmpty ? event.userName : savedUser,
      ));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase();
    final (savedCompany, savedUser) = await localDataSource.getRememberedCredentials();
    emit(Unauthenticated(
      savedCompanyId: savedCompany,
      savedUserName: savedUser,
    ));
  }
}
