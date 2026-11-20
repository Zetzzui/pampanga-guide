import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'location_permission_screen.dart';

/// Sign Up / Log In — placed before Location Permission per AGENTS.md.
///
/// UI only for now. Firebase Authentication is wired in a later step.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.startOnLogin = false});

  final bool startOnLogin;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLogin = widget.startOnLogin;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continue() {
    // TODO: replace with FirebaseAuth sign up / log in.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LocationPermissionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          children: [
            Text(
              'LOCALINGO',
              style: AppText.small.copyWith(
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 26),
            Text(
              _isLogin ? 'Welcome back.' : 'Join the table.',
              style: AppText.h1.copyWith(color: AppColors.navy),
            ),
            const SizedBox(height: 8),
            Text(
              _isLogin
                  ? 'Log in to pick up your saved places and lessons.'
                  : 'Create an account to save places and track your streak.',
              style: AppText.body.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 24),
            _SegmentToggle(
              isLogin: _isLogin,
              onChanged: (value) => setState(() => _isLogin = value),
            ),
            const SizedBox(height: 22),
            if (!_isLogin) ...[
              _FieldLabel('Name'),
              const SizedBox(height: 6),
              _TextField(
                controller: _nameController,
                hint: 'Your name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
            ],
            _FieldLabel('Email'),
            const SizedBox(height: 6),
            _TextField(
              controller: _emailController,
              hint: 'you@email.com',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _FieldLabel('Password'),
            const SizedBox(height: 6),
            _TextField(
              controller: _passwordController,
              hint: 'At least 8 characters',
              icon: Icons.lock_outline,
              obscure: _obscure,
              trailing: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.muted,
                ),
              ),
            ),
            if (_isLogin) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset comes in a later step.'),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: AppText.small.copyWith(color: AppColors.navy),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            PrimaryButton(
              label: _isLogin ? 'Log in' : 'Create account',
              onPressed: _continue,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.line)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'or',
                    style: AppText.small.copyWith(color: AppColors.muted),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.line)),
              ],
            ),
            const SizedBox(height: 18),
            SecondaryButton(label: 'Continue as guest', onPressed: _continue),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin ? 'New here? ' : 'Already have an account? ',
                  style: AppText.small.copyWith(color: AppColors.grey),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? 'Create an account' : 'Log in',
                    style: AppText.small.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({required this.isLogin, required this.onChanged});

  final bool isLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: 'Sign Up',
              selected: !isLogin,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _Segment(
              label: 'Log In',
              selected: isLogin,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.grey,
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.small.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.trailing,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? trailing;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: AppColors.navy),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.muted),
        prefixIcon: Icon(icon, size: 20, color: AppColors.muted),
        suffixIcon: trailing,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.7),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navy),
        ),
      ),
    );
  }
}
