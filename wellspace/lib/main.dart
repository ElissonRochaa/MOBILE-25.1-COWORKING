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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SalaDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SalaImagemViewModel()),
        ChangeNotifierProvider(create: (_) => SalaListViewModel()),
        ChangeNotifierProvider(create: (_) => UsuarioDetailViewModel()),
      ],
      child: MaterialApp(
        title: 'Wellspace',
        initialRoute: '/login',
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginPage(),
          '/cadastro': (context) => CadastroPage(),
          '/home': (context) => HomePage(),
          '/cadastroSala': (context) => CadastroSalaPage(),
          '/Perfil': (context) => ProfilePage(),
          '/espacos': (context) => EspacosPage(),
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
                  appBar: AppBar(title: Text('Erro')),
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
          // ...
        },
      ),
    );
  }
}
