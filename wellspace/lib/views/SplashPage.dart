import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _elementController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late final AnimationController _lottieController;

  bool _showText = false;
  bool _showLottie = false;
  bool _showLogo = false;

  final Duration _initialDelay = const Duration(milliseconds: 450);
  final Duration _textDuration = const Duration(seconds: 2);
  final Duration _lottieDuration = const Duration(seconds: 2);
  final Duration _logoDuration = const Duration(seconds: 3);
  final Duration _transitionDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _elementController = AnimationController(
      vsync: this,
      duration: _transitionDuration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _elementController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _elementController, curve: Curves.easeOutBack),
    );

    _lottieController = AnimationController(vsync: this);

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    await Future.delayed(_initialDelay);
    if (!mounted) return;

    setState(() => _showText = true);
    _elementController.forward();
    await Future.delayed(_textDuration + _transitionDuration);
    _elementController.reverse();
    setState(() => _showText = false);

    setState(() => _showLottie = true);
    _elementController.forward();
    await Future.delayed(_lottieDuration + _transitionDuration);
    _elementController.reverse();
    _lottieController.stop();
    setState(() => _showLottie = false);

    setState(() => _showLogo = true);

    final logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeInOut),
    );
    final scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutBack),
    );

    setState(() {
      _fadeAnimation = fade;
      _scaleAnimation = scale;
    });

    logoController.forward();
    await Future.delayed(_logoDuration + const Duration(seconds: 2));
    logoController.dispose();

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _elementController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  Widget _buildAnimated({required bool visible, required Widget child}) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: _transitionDuration,
      child: visible
          ? ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: child,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showText)
              _buildAnimated(
                visible: _showText,
                child: const Text(
                  'Bem-vindo',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            if (_showLottie)
              _buildAnimated(
                visible: _showLottie,
                child: Lottie.asset(
                  'assets/animations/splash_animation.json',
                  controller: _lottieController,
                  width: 200,
                  height: 200,
                  onLoaded: (composition) {
                    _lottieController
                      ..duration = composition.duration * 1
                      ..forward(from: 0.0);
                  },
                ),
              ),
            if (_showLogo)
              _buildAnimated(
                visible: _showLogo,
                child: Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final screenHeight = MediaQuery.of(context).size.height;

                    return Image.asset(
                      'assets/images/logo.png',
                      width: screenWidth * 1,
                      height: screenHeight * 1,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
