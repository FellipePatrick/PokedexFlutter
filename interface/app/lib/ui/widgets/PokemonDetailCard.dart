import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Importando a biblioteca de cache
import 'package:app/domain/pokemon.dart'; // Importando a classe Pokemon

class PokemonDetailCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonDetailCard({
    Key? key,
    required this.pokemon,
    this.onTap, // Tornando onTap opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Chamando o callback onTap quando o card for tocado
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Imagem do Pokémon
            CachedNetworkImage(
              imageUrl:
                  'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${pokemon.id.toString().padLeft(3, '0')}.png',
              height: 150,
              width: 150,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 8),
            // Nome do Pokémon
            Text(
              pokemon.name?.capitalize() ?? 'Desconhecido',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Tipo do Pokémon
            Text(
              'Tipo: ${pokemon.type.join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Atributos do Pokémon
            _buildAttributeRow('HP', pokemon.base.hp),
            _buildAttributeRow('Ataque', pokemon.base.attack),
            _buildAttributeRow('Defesa', pokemon.base.defense),
            _buildAttributeRow('Ataque Especial', pokemon.base.spAttack),
            _buildAttributeRow('Defesa Especial', pokemon.base.spDefense),
            _buildAttributeRow('Velocidade', pokemon.base.speed),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeRow(String attributeName, int? attributeValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(attributeName, style: const TextStyle(fontSize: 16)),
          Text(attributeValue?.toString() ?? '0',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Extensão para capitalizar o nome
extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}
