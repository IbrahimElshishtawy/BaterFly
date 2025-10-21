import 'package:flutter/material.dart';
import 'app/core/routing/app_router.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/errors/error_handler.dart';
import 'app/services/supabase/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supa.init(); // تهيئة Supabase
  FlutterError.onError = (details) => AppError.handleFlutter(details);
  runApp(const TwoProductsApp());
}

class TwoProductsApp extends StatelessWidget {
  const TwoProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Two Products Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.home,
      navigatorKey: AppRouter.navKey,
    );
  }
}
