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
      width: 325, // 250 * 1.3 = 325
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16), // 16*1.3, 12*1.3
      decoration: BoxDecoration(
        color: const Color(0xFF161721),
        border: Border.all(color: const Color(0xFF7b6326), width: 1.5),
        borderRadius: BorderRadius.circular(16),
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
                        fontSize: 29, // 22 * 1.3
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onAddPlayerTap,
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFFc09b43),
                      size: 26, // 20 * 1.3
                    ),
                  ),
                ],
              ),
              const Text(
                'Time Bank',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21, // 16 * 1.3
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...players.asMap().entries.map((entry) {
            int idx = entry.key;
            Map<String, dynamic> p = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        p['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23, // 18 * 1.3
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Vùng bấm lớn hơn cho icon Penalty
                      GestureDetector(
                        onTap: () => onPenaltyTap(idx),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/Rectangle 1888.svg',
                            width: 26, // 20 * 1.3
                            height: 26,
                          ),
                        ),
                      ),
                      if (p['penalty'] != null && p['penalty'] > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '${p['penalty']}',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 21, // 16 * 1.3
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
                          fontSize: 23, // 18 * 1.3
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Vùng bấm lớn hơn cho icon Time Bank
                      GestureDetector(
                        onTap: p['timeBank'] > 0 ? () => onUseTimeBankTap(idx) : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/Vector.svg',
                            width: 26, // 20 * 1.3
                            height: 26,
                            colorFilter: p['timeBank'] > 0
                                ? null
                                : const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcIn,
                                  ),
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
