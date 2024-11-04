abstract class EquipeRepository {
  // Adicionar um Pokémon à equipe
  Future<void> addPokemonToTeam(String pokemonId);

  // Remover um Pokémon da equipe
  Future<void> removePokemonFromTeam(String pokemonId);

  // Contar o número de Pokémon na equipe
  Future<int> getTeamCount();
}
