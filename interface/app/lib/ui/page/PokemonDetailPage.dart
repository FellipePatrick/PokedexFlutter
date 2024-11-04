import 'package:app/data/database/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:app/ui/widgets/PokemonDetailCard.dart';
import 'package:app/domain/pokemon.dart';

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.name ?? 'Detalhes do Pokémon',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: PokemonDetailCard(
            pokemon: pokemon,
            onTap: () {}, // Você pode adicionar funcionalidade aqui
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning, // Tipo de diálogo para alerta
      title: 'Remover Pokémon',
      desc:
          'Você tem certeza que deseja remover ${pokemon.name} da sua equipe?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        // Chama o método para remover o Pokémon da equipe
        await DatabaseHelper().deletePokemonFromEquipe(pokemon.id.toString());

        // Exibir mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pokemon.name} removido com sucesso!')),
        );

        // Fecha a página de detalhes e retorna à lista de Pokémons
        Navigator.of(context).pop(); // Fecha o diálogo
        Navigator.of(context).pop(); // Fecha a página de detalhes
      },
    ).show();
  }
}
