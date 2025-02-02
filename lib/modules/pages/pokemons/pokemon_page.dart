import 'package:flutter/material.dart';
import '../../services/pokemon_api_service.dart';
import '../../widgets/pokemon_card.dart';
import 'pokemon_detail.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  List<dynamic> _pokemonList = [];
  List<dynamic> _filteredPokemonList = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchPokemonList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        fetchPokemonList();
      }
    });
  }

  Future<void> fetchPokemonList() async {
    if (_isLoading || !_hasMore)
      return; // Evitar cargar si ya se está cargando o no hay más datos

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await PokemonApiService().fetchPokemonList(page: _page);

      List<dynamic> fullPokemonList = [];
      for (var pokemon in data) {
        final pokemonDetails = await PokemonApiService()
            .fetchPokemonDetailsFromUrl(pokemon['url']);
        fullPokemonList.add(pokemonDetails);
      }

      setState(() {
        _page++;
        _pokemonList.addAll(fullPokemonList);
        _filteredPokemonList = _pokemonList;
        _isLoading = false;

        _hasMore = data.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Error al cargar Pokémon: $e');
    }
  }

  void _filterPokemonList(String query) {
    final validQuery = RegExp(r'^[a-zA-Z]+$');

    if (validQuery.hasMatch(query)) {
      final filteredList = _pokemonList.where((pokemon) {
        final name = pokemon['name'].toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();

      setState(() {
        _filteredPokemonList = filteredList;
      });
    } else {
      setState(() {
        _filteredPokemonList = _pokemonList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPokemonList,
              decoration: const InputDecoration(
                hintText: 'Buscar Pokémon...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _filteredPokemonList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: _filteredPokemonList.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _filteredPokemonList.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final pokemon = _filteredPokemonList[index];
                  final pokemonId = pokemon['id'];
                  final imageUrl =
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';

                  List types = pokemon['types'] != null ? pokemon['types'] : [];
                  return PokemonCard(
                    name: pokemon['name'].toString().toUpperCase(),
                    imageUrl: imageUrl,
                    types: types.map<String>((type) {
                      return type['type']['name'];
                    }).toList(),
                    attack: pokemon['stats'][4]['base_stat'],
                    defense: pokemon['stats'][3]['base_stat'],
                    speed: pokemon['stats'][0]['base_stat'],
                    hp: pokemon['stats'][5]['base_stat'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PokemonDetail(pokemonId: pokemonId),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
