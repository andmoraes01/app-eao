import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import '../services/auth_service.dart';
import '../widgets/app_logo.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _hammerController;
  late AnimationController _signController;
  late AnimationController _fadeController;
  late Animation<double> _hammerAnimation;
  late Animation<double> _signAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animação do martelo (batendo)
    _hammerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _hammerAnimation = Tween<double>(
      begin: -0.3,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _hammerController,
      curve: Curves.easeInOut,
    ));

    // Animação da placa (balançando)
    _signController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _signAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _signController,
      curve: Curves.easeInOut,
    ));

    // Fade out após 3 segundos
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Verificar autenticação após 5 segundos
    Future.delayed(const Duration(seconds: 5), () async {
      // Verificar se há token salvo
      final storage = TokenStorage();
      final token = await storage.getToken();
      
      Widget nextScreen = const LoginScreen();
      
      // Se tem token, verificar se é válido
      if (token != null) {
        final authService = AuthService();
        final isValid = await authService.verifyToken(token);
        
        if (isValid) {
          // Token válido, ir direto para Home (auto-login)
          nextScreen = const HomeScreen();
        }
      }
      
      // Fade out e navegar
      _fadeController.forward().then((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => nextScreen),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _hammerController.dispose();
    _signController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700), // Fundo amarelo
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placa de obra animada
              AnimatedBuilder(
                animation: _signAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _signAnimation.value,
                    child: child,
                  );
                },
                child: const AppLogo.large(),
              ),
              const SizedBox(height: 50),
              // Martelo animado
              AnimatedBuilder(
                animation: _hammerAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _hammerAnimation.value,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.construction,
                  size: 60,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              // Indicador de carregamento
              SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Carregando...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

