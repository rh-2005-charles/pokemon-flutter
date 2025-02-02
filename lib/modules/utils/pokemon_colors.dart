import 'package:flutter/material.dart';

class PokemonColors {
  static Map<String, List<Color>> typeColors = {
    'normal': [Colors.grey[300]!, Colors.grey[500]!],
    'fire': [Colors.red[300]!, Colors.red[600]!],
    'water': [Colors.blue[300]!, Colors.blue[600]!],
    'grass': [Colors.green[300]!, Colors.green[600]!],
    'electric': [Colors.yellow[300]!, Colors.yellow[600]!],
    'ice': [Colors.cyan[300]!, Colors.cyan[600]!],
    'fighting': [Colors.brown[300]!, Colors.brown[600]!],
    'poison': [Colors.purple[300]!, Colors.purple[600]!],
    'ground': [Colors.orange[300]!, Colors.orange[600]!],
    'psychic': [Colors.pink[300]!, Colors.pink[600]!],
    'bug': [Colors.green[200]!, Colors.green[400]!],
    'rock': [Colors.brown[200]!, Colors.brown[400]!],
    'ghost': [Colors.indigo[300]!, Colors.indigo[600]!],
    'dragon': [Colors.blue[700]!, Colors.blue[900]!],
    'dark': [Colors.black, Colors.grey[800]!],
    'steel': [Colors.grey[600]!, Colors.grey[800]!],
    'fairy': [Colors.pink[200]!, Colors.pink[500]!],
  };

  static List<Color> getColorsForType(String type) {
    return typeColors[type] ?? [Colors.grey[300]!, Colors.grey[500]!];
  }
}
