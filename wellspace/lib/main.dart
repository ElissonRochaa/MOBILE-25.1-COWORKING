import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
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
import 'package:Wellspace/views/RecumperacaoSenhaPage.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => SalaDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SalaImagemViewModel()),
        ChangeNotifierProvider(create: (_) => SalaListViewModel()),
        ChangeNotifierProvider(create: (_) => UsuarioDetailViewModel()),
        ChangeNotifierProvider(create: (_) => PasswordRecoveryViewModel()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          print(
              "MyApp Consumer: Reconstruindo MaterialApp com themeMode: ${themeNotifier.themeMode}");

          return MaterialApp(
            title: 'Wellspace',
            debugShowCheckedModeBanner: false,
            themeMode: themeNotifier.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[850],
                foregroundColor: Colors.white,
              ),
            ),
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
