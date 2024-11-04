import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Importando o CachedNetworkImage
import 'package:app/domain/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({Key? key, required this.pokemon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.blueAccent, // Cor do AppBar
        foregroundColor: Colors.white, // Cor do texto do AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Adicionando o Center para centralizar o conteúdo
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centraliza os filhos na horizontal
            children: [
              // Exibição da imagem do Pokémon com CachedNetworkImage
              CachedNetworkImage(
                imageUrl:
                    'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${pokemon.id.toString().padLeft(3, '0')}.png',
                height: 200,
                width: 200,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported, size: 200),
              ),
              const SizedBox(height: 20),
              // Exibição do nome do Pokémon
              Text(
                pokemon.name.capitalizeFirstOfEach,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              // Exibição dos atributos do Pokémon
              Container(
                width: MediaQuery.of(context).size.width *
                    0.9, // Definindo a largura do cartão
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atributos',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('HP: ${pokemon.base.hp}'),
                    Text('Attack: ${pokemon.base.attack}'),
                    Text('Defense: ${pokemon.base.defense}'),
                    Text('Sp. Attack: ${pokemon.base.spAttack}'),
                    Text('Sp. Defense: ${pokemon.base.spDefense}'),
                    Text('Speed: ${pokemon.base.speed}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Exibição dos tipos do Pokémon
              Text(
                'Tipos: ${pokemon.type.join(', ')}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
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
