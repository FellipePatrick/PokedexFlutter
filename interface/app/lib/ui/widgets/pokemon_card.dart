import 'package:app/ui/page/pokemon_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/domain/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard(
      {super.key,
      required this.pokemon,
      required void Function() onRemove,
      required Null Function() onTap});

  String getPokemonImageUrl(int id) {
    final formattedId = '${id.toString().padLeft(3, '0')}MS';
    return 'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/sprites/$formattedId.png';
  }

  @override
  Widget build(BuildContext context) {
    final imgUrl = getPokemonImageUrl(pokemon.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailScreen(pokemon: pokemon),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                pokemon.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Tipos: ${pokemon.type.join(', ')}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAttributeRow('HP', pokemon.base.hp.toString()),
                  _buildAttributeRow('Attack', pokemon.base.attack.toString()),
                  _buildAttributeRow(
                      'Defense', pokemon.base.defense.toString()),
                  _buildAttributeRow(
                      'Sp. Attack', pokemon.base.spAttack.toString()),
                  _buildAttributeRow(
                      'Sp. Defense', pokemon.base.spDefense.toString()),
                  _buildAttributeRow('Speed', pokemon.base.speed.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
