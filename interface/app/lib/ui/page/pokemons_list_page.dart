import 'package:app/data/network/entity/http_paged_result.dart';
import 'package:app/domain/pokemon.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/widgets/pokemon_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../data/repository/pokemon_repository_impl.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late final PokemonRepositoryImpl pokemonRepo;
  late final PagingController<int, Pokemon> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    pokemonRepo = Provider.of<PokemonRepositoryImpl>(context, listen: false);
    _pagingController.addPageRequestListener(
      (pageKey) async {
        await _fetchPokemons(pageKey);
      },
    );
  }

  Future<void> _fetchPokemons(int pageKey) async {
    try {
      final result = await pokemonRepo.getPokemons(page: pageKey, limit: 10);

      // Ordena a lista de Pokémons pelo id antes de adicioná-los ao controle de paginação
      result.sort((a, b) => a.id.compareTo(b.id));

      final isLastPage =
          result.length < 10; // Se menos que o limite, é a última página
      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, pageKey + 1);
      }
    } catch (e) {
      _pagingController.error = e;
      print('Erro ao carregar Pokémons: $e');
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pokédex",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.blue[50], // Fundo azul claro
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: PagedListView<int, Pokemon>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Pokemon>(
            itemBuilder: (context, pokemon, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: PokemonCard(
                  pokemon: pokemon,
                  onRemove: () {},
                  onTap: () {},
                ),
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => const Center(
                child: Text(
              'Nenhum Pokémon encontrado.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            )),
            firstPageErrorIndicatorBuilder: (context) => const Center(
                child: Text(
              'Erro ao carregar Pokémons. Tente novamente.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            )),
          ),
        ),
      ),
    );
  }
}
