import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'src/core/network/api_client.dart';
import 'src/core/network/sse_client.dart';
import 'src/features/auth/data/datasources/auth_local_data_source.dart';
import 'src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'src/features/auth/data/repositories/auth_repository_impl.dart';
import 'src/features/chat/data/datasources/chat_remote_data_source.dart';
import 'src/features/chat/data/repositories/chat_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();

  // 2. Initialize Core Network Clients
  final apiClient = ApiClient();
  final sseClient = SseClient();

  // 3. Initialize Auth Data Sources & Repository
  final authLocalDataSource = AuthLocalDataSourceImpl(prefs);
  final authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );

  // 4. Initialize Chat Data Sources & Repository
  final chatRemoteDataSource = ChatRemoteDataSourceImpl(
    sseClient: sseClient,
    apiClient: apiClient,
  );
  final chatRepository = ChatRepositoryImpl(
    remoteDataSource: chatRemoteDataSource,
  );

  runApp(
    AivaApp(
      authRepository: authRepository,
      authLocalDataSource: authLocalDataSource,
      chatRepository: chatRepository,
    ),
  );
}
