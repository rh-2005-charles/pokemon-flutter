import 'package:dio/dio.dart';

class PokemonApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchPokemonList({int page = 1}) async {
    try {
      final offset = (page - 1) * 20;
      final response = await _dio
          .get('https://pokeapi.co/api/v2/pokemon?limit=20&offset=$offset');
      return response.data['results'];
    } catch (e) {
      print('Error fetching Pokémon list: $e');
      return [];
    }
  }

  Future<dynamic> fetchPokemonDetailsFromUrl(String url) async {
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load Pokemon details');
      }
    } catch (e) {
      throw Exception('Failed to load Pokemon details: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(int id) async {
    try {
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon/$id');
      return response.data;
    } catch (e) {
      print('Error fetching Pokémon details: $e');
      return {};
    }
  }

  // Método para obtener la información de la especie
  Future<Map<String, dynamic>> fetchPokemonSpecies(String speciesUrl) async {
    try {
      final response = await _dio.get(speciesUrl);
      return response.data;
    } catch (e) {
      print('Error fetching species details: $e');
      return {};
    }
  }
}
