import 'package:flutter/material.dart';
import '../utils/pokemon_colors.dart';

class PokemonCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final List<String> types;
  final int attack;
  final int defense;
  final int speed;
  final int hp;
  final VoidCallback onTap;

  const PokemonCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.hp,
    required this.onTap,
  });

  String capitalizeName(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final typeColor =
        PokemonColors.getColorsForType(types.isNotEmpty ? types[0] : 'normal');
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -60,
                left: -20,
                right: -20,
                child: CustomPaint(
                  size: Size(double.infinity, 180),
                  painter: OvalBackgroundPainter(colors: typeColor),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'HP $hp',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5),
                  Expanded(
                    child: Image.network(imageUrl,
                        height: 170, width: 170, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    capitalizeName(name),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(attack, 'Attack'),
                      _buildStat(defense, 'Defense'),
                      _buildStat(speed, 'Speed'),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class OvalBackgroundPainter extends CustomPainter {
  final List<Color> colors;

  OvalBackgroundPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    final Path path = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.22),
        width: size.width * 0.9,
        height: size.height * 2,
      ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
