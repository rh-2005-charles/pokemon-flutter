import 'package:flutter/material.dart';
import '../../services/pokemon_api_service.dart';

class PokemonDetail extends StatefulWidget {
  final int pokemonId;

  const PokemonDetail({super.key, required this.pokemonId});

  @override
  _PokemonDetailState createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  Map<String, dynamic>? _pokemonDetails;
  String? _generation;

  String capitalizeName(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    fetchPokemonDetails();
  }

  Future<void> fetchPokemonDetails() async {
    final data =
        await PokemonApiService().fetchPokemonDetails(widget.pokemonId);
    final speciesData =
        await PokemonApiService().fetchPokemonSpecies(data['species']['url']);

    setState(() {
      _pokemonDetails = data;
      _generation = speciesData['generation']['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles de ${_pokemonDetails?['name'] != null ? capitalizeName(_pokemonDetails!['name']) : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _pokemonDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del Pokémon
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonId}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              'ID', _pokemonDetails!['id'].toString()),
                          _buildInfoRow(
                              'Altura', '${_pokemonDetails!['height'] / 10} m'),
                          _buildInfoRow(
                              'Peso', '${_pokemonDetails!['weight'] / 10} kg'),
                          _buildInfoRow(
                              'Generación', _generation ?? "Desconocida"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tipos
                  Text(
                    'Tipos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: (_pokemonDetails!['types'] != null
                            ? _pokemonDetails!['types']
                            : [])
                        .map<Widget>((type) {
                      return Chip(
                        label: Text(
                          type['type']['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Habilidades
                  Text(
                    'Habilidades',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: (_pokemonDetails!['abilities'] != null
                            ? _pokemonDetails!['abilities']
                            : [])
                        .map<Widget>((ability) {
                      return Chip(
                        label: Text(
                          ability['ability']['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
