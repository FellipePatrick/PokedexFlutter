import 'package:app/ui/page/daily_page.dart';
import 'package:app/ui/page/equipe_page.dart';
import 'package:app/ui/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:app/core/di/configure_providers.dart';
import 'package:app/ui/page/pokemons_list_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final data = await ConfigureProviders.createDependencyTree();

  runApp(AppRoot(data: data));
}

class AppRoot extends StatelessWidget {
  final ConfigureProviders data;

  const AppRoot({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        initialRoute: '/', // Define a rota inicial como a HomePage
        routes: {
          '/': (context) => const HomePage(), // Tela inicial
          '/pokedex': (context) =>
              const PokemonListPage(), // Tela de listagem dos Pokémons
          '/encontro_diario': (context) =>
              PokemonRandomPage(), // Tela de Encontro Diário
          '/meus_pokemons': (context) =>
              MeusPokemonsPage(), // Tela dos Meus Pokémons
        },
      ),
    );
  }
}
