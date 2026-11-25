import 'package:material_ui/material_ui.dart';

import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import 'app_scope.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class ZipGameApp extends StatefulWidget {
  const ZipGameApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<ZipGameApp> createState() => _ZipGameAppState();
}

class _ZipGameAppState extends State<ZipGameApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AuthStatus _lastStatus;

  @override
  void initState() {
    super.initState();
    final auth = widget.dependencies.authController;
    _lastStatus = auth.status;
    auth.addListener(_onAuthChange);
    auth.restore();
  }

  /// Regresa a la raíz únicamente cuando ocurre una transición real de autenticación:
  /// - De autenticado a no autenticado (logout o sesión expirada)
  /// - De no autenticado a autenticado (login o registro completado)
  /// No debe cerrarse la pantalla cuando solo se actualizan datos del usuario (p. ej. dificultad recomendada).
  void _onAuthChange() {
    final status = widget.dependencies.authController.status;
    if (status != _lastStatus) {
      final oldStatus = _lastStatus;
      _lastStatus = status;
      if (oldStatus != AuthStatus.unknown) {
        _navigatorKey.currentState?.popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  void dispose() {
    widget.dependencies.authController.removeListener(_onAuthChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      dependencies: widget.dependencies,
      child: MaterialApp(
        title: 'ZIP Game',
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: ListenableBuilder(
          listenable: widget.dependencies.authController,
          builder: (context, _) {
            switch (widget.dependencies.authController.status) {
              case AuthStatus.unknown:
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              case AuthStatus.unauthenticated:
                return const LoginPage();
              case AuthStatus.authenticated:
                return const HomePage();
            }
          },
        ),
      ),
    );
  }
}
