import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tela Inicial',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Azul mais forte para o AppBar
      ),
      body: Container(
        color: Colors.blue[50], // Fundo azul claro
        child: GridView.count(
          padding: const EdgeInsets.all(16.0),
          crossAxisCount: 2, // Dois botões por linha
          childAspectRatio: 1, // Proporção dos itens
          children: [
            _buildGridItem(
              context,
              icon: Icons.list,
              label: 'Pokédex',
              onTap: () {
                Navigator.pushNamed(context, '/pokedex');
              },
            ),
            _buildGridItem(
              context,
              icon: Icons.today,
              label: 'Encontro Diário',
              onTap: () {
                Navigator.pushNamed(context, '/encontro_diario');
              },
            ),
            _buildGridItem(
              context,
              icon: Icons.star, // Ícone para Meus Pokémons
              label: 'Meus Pokémons',
              onTap: () {
                Navigator.pushNamed(
                    context, '/meus_pokemons'); // Navegação para Meus Pokémons
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8, // Sombra mais forte para dar destaque
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)), // Bordas arredondadas
        color: Colors.white, // Cor do cartão
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.blueAccent, // Cor do ícone
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Cor do texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
