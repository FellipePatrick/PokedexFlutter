import 'package:app/data/database/databaseHelper.dart';
import 'package:app/domain/pokemon.dart';
import 'package:app/ui/page/PokemonDetailPage.dart';
import 'package:app/ui/widgets/PokemonDetailCard.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Importando o Awesome Dialog
import 'package:flutter/material.dart';
import 'package:app/ui/widgets/pokemon_card.dart'; // Importando o PokemonCard
import '../../data/database/entity/pokemon_database_entity.dart';

class MeusPokemonsPage extends StatefulWidget {
  const MeusPokemonsPage({Key? key}) : super(key: key);

  @override
  State<MeusPokemonsPage> createState() => _MeusPokemonsPageState();
}

class _MeusPokemonsPageState extends State<MeusPokemonsPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<PokemonDatabaseEntity> meusPokemons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMeusPokemons();
  }

  Future<void> fetchMeusPokemons() async {
    setState(() {
      isLoading = true;
    });

    try {
      final equipeIds = await _databaseHelper.selectAllEquipePokemons();
      List<PokemonDatabaseEntity> pokemons = [];
      for (int id in equipeIds) {
        final pokemon = await _databaseHelper.selectPokemonById(id);
        if (pokemon != null) {
          pokemons.add(pokemon);
        }
      }
      meusPokemons = pokemons;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar Pokémon da equipe: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _removePokemon(PokemonDatabaseEntity pokemon) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Confirmação',
      desc: 'Você realmente deseja soltar ${pokemon.name}?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _databaseHelper
            .deletePokemon(pokemon.id); // Chame o método para remover do banco
        fetchMeusPokemons(); // Atualiza a lista
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meus Pokémon",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : meusPokemons.isEmpty
              ? const Center(child: Text('Você não capturou nenhum Pokémon.'))
              : ListView.builder(
                  itemCount: meusPokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = meusPokemons[index];
                    final convertedPokemon = Pokemon(
                      id: pokemon.id,
                      name: pokemon.name,
                      type: [pokemon.type],
                      base: Base(
                        hp: pokemon.hp,
                        attack: pokemon.attack,
                        defense: pokemon.defense,
                        spAttack: pokemon.spAttack,
                        spDefense: pokemon.spDefense,
                        speed: pokemon.speed,
                      ),
                    );

                    return PokemonDetailCard(
                      pokemon: convertedPokemon,
                      onTap: () {
                        // Navegação para a página de detalhes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PokemonDetailPage(pokemon: convertedPokemon),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
