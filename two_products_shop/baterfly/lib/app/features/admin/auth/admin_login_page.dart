// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import '../controllers/admin_guard_controller.dart';
import '../pages/admin_dashboard_page.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  final _ctrl = AdminGuardController();

  bool loading = false;
  bool obscure = true;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final err = await _ctrl.login(email.text, pass.text);
      if (err != null) {
        _toast(err);
        return;
      }
      final ok = await _ctrl.isAdmin();
      if (!ok) {
        _toast('هذا الحساب ليس أدمن');
        return;
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
      );
    } catch (e) {
      _toast(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final insets = MediaQuery.of(context).viewInsets;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primaryContainer.withOpacity(.35), cs.surface],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              24,
              16,
              (insets.bottom > 0 ? insets.bottom : 24) + 16,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings_rounded,
                                size: 36,
                                color: cs.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'لوحة الأدمن',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // البريد الإلكتروني
                          TextFormField(
                            controller: email,
                            autofillHints: const [AutofillHints.username],
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            enableSuggestions: true,
                            decoration: const InputDecoration(
                              labelText: 'البريد الإلكتروني',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              final t = v?.trim() ?? '';
                              if (t.isEmpty) return 'أدخل البريد الإلكتروني';
                              if (!RegExp(
                                r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+$',
                              ).hasMatch(t)) {
                                return 'بريد غير صالح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // كلمة المرور
                          TextFormField(
                            controller: pass,
                            autofillHints: const [AutofillHints.password],
                            obscureText: obscure,
                            autocorrect: false,
                            enableSuggestions: false,
                            onFieldSubmitted: (_) => _login(),
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => obscure = !obscure),
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (v) {
                              final t = v ?? '';
                              if (t.isEmpty) return 'أدخل كلمة المرور';
                              if (t.length < 8) return 'الحد الأدنى 8 أحرف';
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // زر الدخول
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: loading ? null : _login,
                              icon: loading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.login_rounded),
                              label: const Text('دخول'),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Opacity(
                            opacity: .75,
                            child: Text(
                              'يُرجى استخدام حساب الأدمن المسجل مسبقًا ',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
