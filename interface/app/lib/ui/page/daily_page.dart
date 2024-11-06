import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database/databaseHelper.dart';
import '../../data/repository/pokemon_repository_impl.dart';
import '../../domain/pokemon.dart';

class PokemonRandomPage extends StatefulWidget {
  const PokemonRandomPage({super.key});

  @override
  State<PokemonRandomPage> createState() => _PokemonRandomPageState();
}

class _PokemonRandomPageState extends State<PokemonRandomPage> {
  late final PokemonRepositoryImpl pokemonRepo;
  Pokemon? randomPokemon;
  bool isLoading = true;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool alreadyCapturedToday = false;

  @override
  void initState() {
    super.initState();
    pokemonRepo = Provider.of<PokemonRepositoryImpl>(context, listen: false);
    _loadRandomPokemon();
  }

  Future<void> _loadRandomPokemon() async {
    final prefs = await SharedPreferences.getInstance();
    final today =
        DateTime.now().toIso8601String().substring(0, 10); // Formato YYYY-MM-DD
    final savedDate = prefs.getString('pokemon_date');

    //Para burlar o sistema de captura de pokemons, basta alterar esse savedDate == today para false
    if (false) {
      // Já existe um Pokémon salvo para o dia atual
      final savedId = prefs.getInt('pokemon_id');
      final savedName = prefs.getString('pokemon_name');
      final savedType = prefs.getStringList('pokemon_type');
      final savedBaseJson = prefs.getString('pokemon_base');
      alreadyCapturedToday = prefs.getBool('pokemon_captured_today') ?? false;

      if (savedId != null &&
          savedName != null &&
          savedType != null &&
          savedBaseJson != null) {
        // Deserializa `Base` do JSON armazenado
        final savedBaseMap = jsonDecode(savedBaseJson) as Map<String, dynamic>;
        final savedBase = Base.fromJson(savedBaseMap);

        setState(() {
          randomPokemon = Pokemon(
            id: savedId,
            name: savedName,
            type: savedType,
            base: savedBase,
          );
          isLoading = false;
        });
        return;
      }
    }

    // Caso não tenha um Pokémon salvo ou o dia tenha mudado, sorteia um novo Pokémon
    await fetchRandomPokemon();
    await prefs.setString('pokemon_date', today);
    await prefs.setInt('pokemon_id', randomPokemon!.id);
    await prefs.setString('pokemon_name', randomPokemon!.name);
    await prefs.setStringList('pokemon_type', randomPokemon!.type);
    await prefs.setString(
        'pokemon_base', jsonEncode(randomPokemon!.base.toJson()));
    await prefs.setBool('pokemon_captured_today', false); // Reset captura
    alreadyCapturedToday = false;
  }

  // Função para buscar um Pokémon aleatório
  Future<void> fetchRandomPokemon() async {
    try {
      final result = await pokemonRepo.getPokemon();
      setState(() {
        randomPokemon = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar Pokémon: $e');
    }
  }

  Future<void> capturePokemon() async {
    if (randomPokemon != null && !alreadyCapturedToday) {
      try {
        await Future.delayed(const Duration(milliseconds: 5));

        int count = await _databaseHelper.getEquipeCount();

        if (count >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Você já capturou 6 Pokémon! Não pode capturar mais.'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Adiciona o Pokémon à tabela Equipe
          await _databaseHelper.insertPokemonToEquipe(
            randomPokemon!.id.toString(),
            randomPokemon!.name,
          );

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('pokemon_captured_today', true);
          setState(() {
            alreadyCapturedToday = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Você capturou ${randomPokemon!.name}!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print('Erro ao capturar Pokémon: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao capturar Pokémon: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você já capturou o Pokémon do dia.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pokémon Aleatório",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.blue[50],
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : randomPokemon != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${randomPokemon!.id.toString().padLeft(3, '0')}.png',
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          randomPokemon!.name.capitalizeFirstOfEach,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: capturePokemon,
                          child: const Text('Capturar Pokémon'),
                        ),
                      ],
                    )
                  : const Text(
                      'Nenhum Pokémon encontrado.',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
        ),
      ),
    );
  }
}

// Extensão para capitalizar a primeira letra
extension StringExtension on String {
  String get capitalizeFirstOfEach =>
      split(' ').map((str) => str.capitalize()).join(' ');

  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}
