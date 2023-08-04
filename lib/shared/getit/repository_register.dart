import 'package:get_it/get_it.dart';
import 'package:flutter_pokedex/shared/getit/getit.dart';
import 'package:flutter_pokedex/shared/repositories/pokemon_repository.dart';

class RepositoryRegister extends IGetItRegister {
  @override
  void register() {
    GetIt getIt = GetIt.instance;

    if (!GetIt.I.isRegistered<PokemonRepository>()) {
      getIt.registerSingleton<PokemonRepository>(PokemonRepository());
    }
  }
}
