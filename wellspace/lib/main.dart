import 'package:Wellspace/viewmodels/ReservaViewModel.dart';
import 'package:Wellspace/views/MinhasReservas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:Wellspace/viewmodels/SalaDetailViewModel.dart';
import 'package:Wellspace/viewmodels/SalaImagemViewModel.dart';
import 'package:Wellspace/viewmodels/SalaListViewModel.dart';
import 'package:Wellspace/viewmodels/UsuarioDetailViewModel.dart';
import 'package:Wellspace/viewmodels/PasswordRecoveryViewModel.dart';
import 'package:Wellspace/views/widgets/ThemeNotifer.dart';
import 'package:Wellspace/views/LoginPage.dart';
import 'package:Wellspace/views/CadastroPage.dart';
import 'package:Wellspace/views/HomePage.dart';
import 'package:Wellspace/views/CadastroSalaPage.dart';
import 'package:Wellspace/views/ProfilePage.dart';
import 'package:Wellspace/views/EditProfilePage.dart';
import 'package:Wellspace/views/EspacoPage.dart';
import 'package:Wellspace/views/SuportePage.dart';
import 'package:Wellspace/views/SplashPage.dart';
import 'package:Wellspace/views/AlugarPage.dart';
import 'package:Wellspace/views/EsqueciSenhaPage.dart';
import 'package:Wellspace/views/RecuperacaoSenhaPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF007BFF);

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
        surface: Colors.white,
        background: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      )),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => SalaDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SalaImagemViewModel()),
        ChangeNotifierProvider(create: (_) => SalaListViewModel()),
        ChangeNotifierProvider(create: (_) => UsuarioDetailViewModel()),
        ChangeNotifierProvider(create: (_) => PasswordRecoveryViewModel()),
        ChangeNotifierProvider(create: (_) => ReservaViewModel()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Wellspace',
            debugShowCheckedModeBanner: false,
            themeMode: themeNotifier.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
            ],
            locale: const Locale('pt', 'BR'),
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashPage(),
              '/login': (context) => const LoginPage(),
              '/cadastro': (context) => CadastroPage(),
              '/home': (context) => const HomePage(),
              '/cadastroSala': (context) => CadastroSalaPage(),
              '/Perfil': (context) => const ProfilePage(),
              '/editar-perfil': (context) => const EdiProfilePage(),
              '/espacos': (context) => const EspacosPage(),
              '/suporte': (context) => const SuportePage(),
              '/forgot-password': (context) => const ForgotPasswordForm(),
              '/minhas-reservas': (context) => const MinhasReservasScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/alugar') {
                final salaId = settings.arguments as String?;
                if (salaId != null && salaId.isNotEmpty) {
                  return MaterialPageRoute(
                    builder: (context) => Alugapage(salaId: salaId),
                  );
                } else {
                  return _errorRoute(
                      'Erro ao carregar detalhes da sala: ID não fornecido.');
                }
              } else if (settings.name != null &&
                  settings.name!.startsWith('/reset-password')) {
                String? token;
                final Uri uri = Uri.parse(settings.name!);

                if (uri.queryParameters.containsKey('token')) {
                  token = uri.queryParameters['token'];
                } else if (settings.arguments is Map<String, dynamic>) {
                  final arguments = settings.arguments as Map<String, dynamic>?;
                  token = arguments?['token'] as String?;
                }

                if (token != null && token.isNotEmpty) {
                  return MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(token: token!),
                  );
                } else {
                  return _errorRoute(
                      'Token de redefinição ausente ou inválido.');
                }
              }
              return null;
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Página Não Encontrada')),
                  body: const Center(
                    child: Text('A rota solicitada não foi encontrada.'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro de Rota')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
