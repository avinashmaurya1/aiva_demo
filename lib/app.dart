import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/auth/domain/repositories/auth_repository.dart';
import 'src/features/auth/domain/usecases/get_bootstrap_usecase.dart';
import 'src/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'src/features/auth/domain/usecases/login_usecase.dart';
import 'src/features/auth/domain/usecases/logout_usecase.dart';
import 'src/features/auth/data/datasources/auth_local_data_source.dart';
import 'src/features/auth/presentation/controllers/auth_bloc.dart';
import 'src/features/auth/presentation/controllers/auth_event.dart';
import 'src/features/auth/presentation/controllers/auth_state.dart';
import 'src/features/auth/presentation/screens/login_screen.dart';
import 'src/features/chat/domain/repositories/chat_repository.dart';
import 'src/features/chat/presentation/controllers/chat_bloc.dart';
import 'src/features/chat/presentation/screens/chat_screen.dart';
import 'src/shared/widgets/app_loading_indicator.dart';

class AivaApp extends StatelessWidget {
  final AuthRepository authRepository;
  final AuthLocalDataSource authLocalDataSource;
  final ChatRepository chatRepository;

  const AivaApp({
    super.key,
    required this.authRepository,
    required this.authLocalDataSource,
    required this.chatRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(authRepository),
            getBootstrapUseCase: GetBootstrapUseCase(authRepository),
            getSavedSessionUseCase: GetSavedSessionUseCase(authRepository),
            logoutUseCase: LogoutUseCase(authRepository),
            localDataSource: authLocalDataSource,
          )..add(const AuthCheckRequested()),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            chatRepository: chatRepository,
            tokenProvider: () {
              final authState = context.read<AuthBloc>().state;
              if (authState is Authenticated) {
                return authState.token.accessToken;
              }
              return '';
            },
          ),
        ),
      ],
      child: MaterialApp(
        title: 'AIVA AI Travel Agent',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthGatekeeper(),
      ),
    );
  }
}

/// Switches between LoginScreen and ChatScreen based on AuthState
class AuthGatekeeper extends StatelessWidget {
  const AuthGatekeeper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const ChatScreen();
        }

        if (state is Unauthenticated) {
          return LoginScreen(
            initialCompanyId: state.savedCompanyId,
            initialUserName: state.savedUserName,
          );
        }

        if (state is AuthLoading) {
          return Scaffold(
            body: AppLoadingIndicator(
              message: state.message ?? 'Loading AIVA...',
            ),
          );
        }

        return const LoginScreen();
      },
    );
  }
}
