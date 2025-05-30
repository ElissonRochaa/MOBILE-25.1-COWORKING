import 'package:Wellspace/viewmodels/SalaDetailViewModel.dart';
import 'package:Wellspace/viewmodels/SalaImagemViewModel.dart';
import 'package:Wellspace/viewmodels/SalaListViewModel.dart';
import 'package:Wellspace/viewmodels/UsuarioDetailViewModel.dart';
import 'package:Wellspace/views/AlugarPage.dart';
import 'package:Wellspace/views/CadastroPage.dart';
import 'package:Wellspace/views/CadastroSalaPage.dart';
import 'package:Wellspace/views/EspacoPage.dart';
import 'package:Wellspace/views/HomePage.dart';
import 'package:Wellspace/views/LoginPage.dart';
import 'package:Wellspace/views/ProfilePage.dart';
import 'package:Wellspace/views/widgets/ThemeNotifer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/views/EditProfilePage.dart';
import 'package:Wellspace/views/SuportePage.dart';
import 'package:Wellspace/views/SplashPage.dart';

void main() {
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
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          print(
              "MyApp Consumer: Reconstruindo MaterialApp com themeMode: ${themeNotifier.themeMode}");

          return MaterialApp(
            title: 'Wellspace',
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
            themeMode: themeNotifier.themeMode,
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => const SplashPage(),
              '/login': (context) => LoginPage(),
              '/cadastro': (context) => CadastroPage(),
              '/home': (context) => const HomePage(),
              '/cadastroSala': (context) => CadastroSalaPage(),
              '/Perfil': (context) => ProfilePage(),
              '/editar-perfil': (context) => EdiProfilePage(),
              '/espacos': (context) => EspacosPage(),
              '/suporte': (context) => SuportePage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/alugar') {
                final salaId = settings.arguments as String?;
                if (salaId != null && salaId.isNotEmpty) {
                  return MaterialPageRoute(
                    builder: (context) => Alugapage(salaId: salaId),
                  );
                } else {
                  print(
                      'Erro de Rota: ID da sala ausente ou inválido para /alugar');
                  return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text('Erro de Rota')),
                      body: const Center(
                          child: Text(
                              'Erro ao carregar detalhes da sala: ID não fornecido.')),
                    ),
                  );
                }
              }
              return null;
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Página não encontrada')),
                  body: const Center(
                      child:
                          Text('A página que você tentou acessar não existe.')),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
