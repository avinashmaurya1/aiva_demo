import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_bloc.dart';
import '../controllers/auth_event.dart';
import '../controllers/auth_state.dart';

/// Professional Login Screen for AgenticBox & Travog
class LoginScreen extends StatefulWidget {
  final String? initialCompanyId;
  final String? initialUserName;

  const LoginScreen({
    super.key,
    this.initialCompanyId,
    this.initialUserName,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _companyController;
  late final TextEditingController _userController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.initialCompanyId ?? '');
    _userController = TextEditingController(text: widget.initialUserName ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthLoginSubmitted(
            companyId: _companyController.text.trim(),
            userName: _userController.text.trim(),
            password: _passwordController.text,
            source: 'SBT',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(isDark),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: _companyController,
                      label: 'Company ID',
                      hintText: 'e.g. ACME or DEMO',
                      prefixIcon: Icons.business_rounded,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Company ID is required' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _userController,
                      label: 'Username / Email',
                      hintText: 'Enter your username',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Username is required' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Password is required' : null,
                    ),
                    const SizedBox(height: 28),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return AppButton(
                          text: 'Sign In to AIVA Agent',
                          isLoading: isLoading,
                          onPressed: _submitLogin,
                          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildFooterNote(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accentCyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(80),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.flight_takeoff_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'AIVA Travel Agent',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sign in to search & book flights, hotels, and track PNR with AI',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterNote(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, size: 15, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              'Secured with Travog / AgenticBox OAuth & JWT',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withAlpha(140),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
