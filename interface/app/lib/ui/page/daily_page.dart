import 'dart:math';
import 'package:app/data/database/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/network/entity/http_paged_result.dart';
import '../../domain/pokemon.dart';
import '../../data/repository/pokemon_repository_impl.dart';

class PokemonRandomPage extends StatefulWidget {
  const PokemonRandomPage({super.key});

  @override
  State<PokemonRandomPage> createState() => _PokemonRandomPageState();
}

class _PokemonRandomPageState extends State<PokemonRandomPage> {
  late final PokemonRepositoryImpl pokemonRepo;
  Pokemon? randomPokemon;
  final Random _random = Random();
  bool isLoading = true;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    pokemonRepo = Provider.of<PokemonRepositoryImpl>(context, listen: false);
    fetchRandomPokemon();
  }

  Future<void> fetchRandomPokemon() async {
    int randomNumber = _random.nextInt(800) + 1;

    try {
      final result = await pokemonRepo.getPokemonById(randomNumber);
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
    if (randomPokemon != null) {
      try {
        await Future.delayed(Duration(milliseconds: 50));

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
            randomPokemon!.name, // Incluindo o nome do Pokémon
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Você capturou ${randomPokemon!.name}!'),
              backgroundColor: Colors.green,
            ),
          );
          // Busca um novo Pokémon aleatório após a captura
          fetchRandomPokemon();
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
      this.split(' ').map((str) => str.capitalize()).join(' ');

  String capitalize() =>
      this.isEmpty ? '' : '${this[0].toUpperCase()}${this.substring(1)}';
}
