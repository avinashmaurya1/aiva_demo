import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aiva_ai_agent/src/core/theme/app_theme.dart';
import 'package:aiva_ai_agent/src/features/auth/domain/entities/auth_token.dart';
import 'package:aiva_ai_agent/src/features/auth/domain/entities/user_profile.dart';
import 'package:aiva_ai_agent/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:aiva_ai_agent/src/features/auth/domain/usecases/get_bootstrap_usecase.dart';
import 'package:aiva_ai_agent/src/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'package:aiva_ai_agent/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:aiva_ai_agent/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:aiva_ai_agent/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:aiva_ai_agent/src/features/auth/data/models/auth_token_model.dart';
import 'package:aiva_ai_agent/src/features/auth/data/models/user_profile_model.dart';
import 'package:aiva_ai_agent/src/features/auth/presentation/controllers/auth_bloc.dart';
import 'package:aiva_ai_agent/src/features/auth/presentation/screens/login_screen.dart';
import 'package:aiva_ai_agent/src/features/travel/presentation/widgets/flight_result_card.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthToken> login({
    required String companyId,
    required String userName,
    required String password,
    String? accountNo,
    String source = 'SBT',
  }) async {
    return const AuthToken(accessToken: 'mock_jwt_token', travogBaseUrl: 'https://test.travog.com');
  }

  @override
  Future<UserProfile> bootstrap({
    required String accessToken,
    required String travogBaseUrl,
  }) async {
    return const UserProfile(userId: '1001', userName: 'jdoe', companyId: 'ACME');
  }

  @override
  Future<AuthToken?> getSavedToken() async => null;

  @override
  Future<UserProfile?> getSavedUserProfile() async => null;

  @override
  Future<AuthToken> refreshToken({required String refreshToken, required String travogBaseUrl}) async {
    return const AuthToken(accessToken: 'refreshed_token');
  }

  @override
  Future<void> logout() async {}
}

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  @override
  Future<void> clearSession() async {}

  @override
  Future<(String?, String?)> getRememberedCredentials() async => ('ACME', 'jdoe');

  @override
  Future<AuthTokenModel?> getToken() async => null;

  @override
  Future<UserProfileModel?> getUserProfile() async => null;

  @override
  Future<void> saveRememberedCredentials({required String companyId, required String userName}) async {}

  @override
  Future<void> saveToken(AuthTokenModel token) async {}

  @override
  Future<void> saveUserProfile(UserProfileModel profile) async {}
}

void main() {
  testWidgets('FlightResultCard displays flight details correctly', (WidgetTester tester) async {
    final flightData = {
      'airline': 'IndiGo',
      'flight_number': '6E-204',
      'origin': 'DEL',
      'destination': 'BOM',
      'departure_time': '06:00 AM',
      'arrival_time': '08:15 AM',
      'duration': '2h 15m',
      'stops': 'Non-stop',
      'price': 4599,
    };

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: FlightResultCard(flightData: flightData),
        ),
      ),
    );

    expect(find.text('IndiGo'), findsOneWidget);
    expect(find.text('6E-204'), findsOneWidget);
    expect(find.text('DEL'), findsOneWidget);
    expect(find.text('BOM'), findsOneWidget);
    expect(find.text('06:00 AM'), findsOneWidget);
    expect(find.text('08:15 AM'), findsOneWidget);
    expect(find.text('Select Flight'), findsOneWidget);
  });

  testWidgets('LoginScreen renders all input fields and sign in button with AuthBloc', (WidgetTester tester) async {
    final repo = FakeAuthRepository();
    final local = FakeAuthLocalDataSource();
    final authBloc = AuthBloc(
      loginUseCase: LoginUseCase(repo),
      getBootstrapUseCase: GetBootstrapUseCase(repo),
      getSavedSessionUseCase: GetSavedSessionUseCase(repo),
      logoutUseCase: LogoutUseCase(repo),
      localDataSource: local,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const LoginScreen(
            initialCompanyId: 'ACME',
            initialUserName: 'jdoe',
          ),
        ),
      ),
    );

    expect(find.text('AIVA Travel Agent'), findsOneWidget);
    expect(find.text('Company ID'), findsOneWidget);
    expect(find.text('Username / Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In to AIVA Agent'), findsOneWidget);
  });
}
