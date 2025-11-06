// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import '../controllers/admin_guard_controller.dart';
import '../pages/admin_dashboard_page.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../core/widgets/site_app_bar/CustomDrawer.dart';
import '../../../features/product/widgets/gradient_bg.dart';

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
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: const SiteAppBar(transparent: false),

      body: Stack(
        children: [
          const GradientBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.admin_panel_settings,
                              size: 34,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "لوحة الأدمن",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        _buildInput(
                          controller: email,
                          icon: Icons.email_outlined,
                          label: "البريد الإلكتروني",
                          validator: (v) {
                            if (v == null || v.isEmpty) return "أدخل البريد";
                            if (!v.contains("@")) return "بريد غير صالح";
                            return null;
                          },
                          keyboard: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        _buildInput(
                          controller: pass,
                          icon: Icons.lock_outline_rounded,
                          label: "كلمة المرور",
                          obscure: obscure,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "أدخل كلمة المرور";
                            }
                            if (v.length < 8) return "8 أحرف على الأقل";
                            return null;
                          },
                          suffix: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(() => obscure = !obscure),
                          ),
                          onSubmit: (_) => _login(),
                        ),

                        const SizedBox(height: 22),

                        // زر تسجيل الدخول
                        SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3527B0), Color(0xFFE91E63)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ElevatedButton(
                              onPressed: loading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: loading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "تسجيل الدخول",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "يُرجى استخدام حساب أدمن فقط",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
    void Function(String)? onSubmit,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      keyboardType: keyboard,
      onFieldSubmitted: onSubmit,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
