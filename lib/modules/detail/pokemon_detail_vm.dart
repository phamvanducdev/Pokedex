import 'dart:async';
import 'package:flutter_pokedex/modules/detail/pages/about/widgets/sound_player.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_pokedex/shared/models/pokemon.dart';
import 'package:flutter_pokedex/shared/models/pokemon_summary.dart';
import 'package:flutter_pokedex/shared/repositories/pokemon_repository.dart';
import 'package:rxdart/rxdart.dart';

class PokemonDetailViewModel {
  PokemonRepository pokemonRepository = GetIt.instance<PokemonRepository>();

  int _pokemonIndex = 0;
  int get pokemonIndex => _pokemonIndex;

  List<PokemonSummary> _pokemonsSummary = [];
  List<PokemonSummary> get pokemonsSummary => _pokemonsSummary;

  PokemonSummary get currentPokemon => _pokemonsSummary[_pokemonIndex];

  bool get previousPokemonEnable => _pokemonIndex > 0;
  bool get nextPokemonEnable => _pokemonIndex < _pokemonsSummary.length - 1;

  final BehaviorSubject<PokemonSummary> _streamPokemonSummary = BehaviorSubject();
  Stream<PokemonSummary> get streamPokemonSummary => _streamPokemonSummary.stream;

  final BehaviorSubject<Pokemon?> _streamPokemon = BehaviorSubject();
  Stream<Pokemon?> get streamPokemon => _streamPokemon.stream;

  final BehaviorSubject<bool> _streamFavoritedPokemon = BehaviorSubject();
  Stream<bool> get streamFavoritedPokemon => _streamFavoritedPokemon.stream;

  final BehaviorSubject<double> _streamAppbarOpacity = BehaviorSubject();
  Stream<double> get streamAppbarOpacity => _streamAppbarOpacity.stream;

  final BehaviorSubject<AudioDurations> _streamAudio = BehaviorSubject();
  Stream<AudioDurations> get streamAudio => _streamAudio.stream;

  Future<void> initial(int index, List<PokemonSummary> pokemons) async {
    _pokemonsSummary = pokemons;
    await setPokemon(index);
  }

  Future<void> setPokemon(int pokemonIndex) async {
    _pokemonIndex = pokemonIndex;
    _streamPokemonSummary.add(_pokemonsSummary[_pokemonIndex]);
    await resetAudioValue();
    await fetchPokemonDetail();
  }

  Future<void> resetAudioValue() async {
    _streamAudio.add(
      AudioDurations(
        total: Duration.zero,
        progress: Duration.zero,
      ),
    );
  }

  Future<void> fetchPokemonDetail() async {
    String pokemonNumber = _pokemonsSummary[pokemonIndex].number;
    var pokemonsFavorite = await pokemonRepository.fetchPokemonsFavorite();
    _streamFavoritedPokemon.add(pokemonsFavorite.contains(pokemonNumber));
    var pokemonInfo = await pokemonRepository.fetchPokemonDetail(pokemonNumber);
    _streamPokemon.add(pokemonInfo);
  }

  Future<void> onPageChanged(int index) async {
    await setPokemon(index);
  }

  Future<void> onFavorite(bool favorited) async {
    var pokemonsFavorite = await pokemonRepository.fetchPokemonsFavorite();
    var pokemonNumber = _pokemonsSummary[_pokemonIndex].number;
    if (favorited) {
      pokemonsFavorite.add(pokemonNumber);
    } else {
      pokemonsFavorite.remove(pokemonNumber);
    }
    await pokemonRepository.savePokemonsFavorite(pokemonsFavorite);
    _streamFavoritedPokemon.add(favorited);
  }

  Future<void> setOpacityProgress(double progress) async {
    _streamAppbarOpacity.add(progress);
  }

  Future<void> setAudioTotal(Duration total) async {
    _streamAudio.add(
      AudioDurations(
        total: total,
        progress: _streamAudio.value.progress,
      ),
    );
  }

  Future<void> setAudioProgress(Duration progress) async {
    _streamAudio.add(
      AudioDurations(
        total: _streamAudio.value.total,
        progress: progress,
      ),
    );
  }
}
