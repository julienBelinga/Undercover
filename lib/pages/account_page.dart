import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:undercover/config/theme.dart';
import 'package:undercover/models/game_models.dart';
import 'package:undercover/services/auth_service.dart';
import 'package:undercover/widgets/app_scaffold.dart';
import 'package:undercover/widgets/primary_action_button.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, this.authService});

  final AuthService? authService;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthService _authService = widget.authService ?? AuthService();
  var _isSignUp = false;
  var _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });
    try {
      if (_isSignUp) {
        await _authService.signUpWithEmail(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        _message =
            'Compte cree. Verifie tes emails si Supabase demande une confirmation.';
      } else {
        await _authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        _message = 'Connecte.';
      }
    } on AuthException catch (error) {
      _message = error.message;
    } catch (_) {
      _message = 'Connexion impossible pour le moment.';
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWith(Future<void> Function() action) async {
    setState(() {
      _isLoading = true;
      _message = null;
    });
    try {
      await action();
    } on AuthException catch (error) {
      _message = error.message;
    } catch (_) {
      _message = 'Connexion impossible pour le moment.';
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Compte',
      showBack: true,
      child: StreamBuilder<AuthState>(
        stream: _authService.authStateChanges,
        builder: (context, _) {
          final user = _authService.currentUser;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Icon(AppIcons.user, color: AppTheme.primary, size: 64),
              const SizedBox(height: 16),
              if (!_authService.isConfigured)
                _InfoCard(
                  title: 'Supabase non configure',
                  text:
                      'Ajoute SUPABASE_URL et SUPABASE_ANON_KEY au lancement pour activer les comptes.',
                )
              else if (user != null)
                _SignedInCard(user: user, onSignOut: _signOut)
              else
                _AuthForm(
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isSignUp: _isSignUp,
                  isLoading: _isLoading,
                  message: _message,
                  onToggleMode: () => setState(() => _isSignUp = !_isSignUp),
                  onSubmit: _submitEmail,
                  onGoogle: () => _signInWith(_authService.signInWithGoogle),
                  onApple: () => _signInWith(_authService.signInWithApple),
                  canUseApple: _authService.canUseNativeAppleSignIn,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}

class _SignedInCard extends StatelessWidget {
  const _SignedInCard({required this.user, required this.onSignOut});

  final User user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connecte', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              user.email ?? user.id,
              style: const TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onSignOut,
                icon: const Icon(AppIcons.close),
                label: const Text('Se deconnecter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isSignUp,
    required this.isLoading,
    required this.message,
    required this.onToggleMode,
    required this.onSubmit,
    required this.onGoogle,
    required this.onApple,
    required this.canUseApple,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSignUp;
  final bool isLoading;
  final String? message;
  final VoidCallback onToggleMode;
  final VoidCallback onSubmit;
  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final bool canUseApple;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isSignUp) ...[
          TextField(
            key: const Key('account-name'),
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Prenom'),
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          key: const Key('account-email'),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('account-password'),
          controller: passwordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: 'Mot de passe'),
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        PrimaryActionButton(
          label: isSignUp ? 'Creer un compte' : 'Se connecter',
          onPressed: isLoading ? null : onSubmit,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: isLoading ? null : onToggleMode,
          child: Text(isSignUp ? 'J’ai deja un compte' : 'Creer un compte'),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onGoogle,
            icon: const Icon(AppIcons.user),
            label: const Text('Continuer avec Google'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: isLoading || !canUseApple ? null : onApple,
            icon: const Icon(AppIcons.user),
            label: const Text('Continuer avec Apple'),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(message!, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}
