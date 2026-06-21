import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayerPanelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  final VoidCallback onAddPlayerTap;
  final void Function(int) onPenaltyTap;
  final void Function(int) onUseTimeBankTap;

  const PlayerPanelWidget({
    Key? key,
    required this.players,
    required this.onAddPlayerTap,
    required this.onPenaltyTap,
    required this.onUseTimeBankTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161721),
        border: Border.all(color: const Color(0xFF7b6326), width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFffeba0), Color(0xFFc09b43)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text(
                      'PLAYER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onAddPlayerTap,
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFFc09b43),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Text(
                'Time Bank',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...players.asMap().entries.map((entry) {
            int idx = entry.key;
            Map<String, dynamic> p = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        p['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => onPenaltyTap(idx),
                        child: SvgPicture.asset(
                          'assets/Rectangle 1888.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      if (p['penalty'] != null && p['penalty'] > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '${p['penalty']}',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        p['timeBank'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: p['timeBank'] > 0 ? () => onUseTimeBankTap(idx) : null,
                        child: SvgPicture.asset(
                          'assets/Vector.svg',
                          width: 20,
                          height: 20,
                          colorFilter: p['timeBank'] > 0
                              ? null
                              : const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.srcIn,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
