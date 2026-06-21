import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopupHelpers {
  static void showPenaltyPopup(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> players,
    VoidCallback onUpdate, [
    void Function(void Function())? setStateDialog,
  ]) {
    final String playerName = players[index]['name'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161721),
          title: Text(
            'Penalty $playerName ?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                players[index]['penalty'] = (players[index]['penalty'] ?? 0) + 1;
                onUpdate();
                if (setStateDialog != null) setStateDialog(() {});
                Navigator.pop(context);
              },
              child: const Text('yes', style: TextStyle(color: Color(0xFFc09b43))),
            ),
          ],
        );
      },
    );
  }

  static void showUseTimeBankPopup(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> players,
    VoidCallback onUpdate,
    VoidCallback onResetTimer, [
    void Function(void Function())? setStateDialog,
  ]) {
    final String playerName = players[index]['name'];
    if ((players[index]['timeBank'] ?? 0) <= 0) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161721),
          title: Text(
            '$playerName use time bank?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                players[index]['timeBank'] = players[index]['timeBank'] - 1;
                onResetTimer();
                onUpdate();
                if (setStateDialog != null) setStateDialog(() {});
                Navigator.pop(context);
              },
              child: const Text('yes', style: TextStyle(color: Color(0xFFc09b43))),
            ),
          ],
        );
      },
    );
  }

  static void showDeletePlayerPopup(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> players,
    VoidCallback onUpdate, [
    void Function(void Function())? setStateDialog,
  ]) {
    final String playerName = players[index]['name'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161721),
          title: Text(
            'bạn có muốn xoá $playerName ?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                players.removeAt(index);
                onUpdate();
                if (setStateDialog != null) setStateDialog(() {});
                Navigator.pop(context);
              },
              child: const Text('yes', style: TextStyle(color: Color(0xFFc09b43))),
            ),
          ],
        );
      },
    );
  }

  static void showAddPlayerPopup(
    BuildContext context,
    List<Map<String, dynamic>> players,
    VoidCallback onUpdate,
    VoidCallback onResetTimer,
  ) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: 400,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF161721),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF7b6326), width: 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFc09b43), width: 1.5),
                            ),
                            child: TextField(
                              controller: nameController,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                              decoration: const InputDecoration(
                                hintText: 'Enter name',
                                hintStyle: TextStyle(color: Color(0xFF8B7330)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFc09b43),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white, size: 28),
                            onPressed: () {
                              if (nameController.text.trim().isNotEmpty) {
                                String name = nameController.text.trim();
                                int existingIndex = players.indexWhere((p) => p['name'] == name);
                                if (existingIndex != -1) {
                                  players[existingIndex]['timeBank'] = 2;
                                  players[existingIndex]['penalty'] = 0;
                                } else {
                                  players.add({'name': name, 'timeBank': 2});
                                }
                                onUpdate();
                                setStateDialog(() {});
                                nameController.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    if (players.isNotEmpty) const SizedBox(height: 16),
                    ...players.asMap().entries.map((entry) {
                      int idx = entry.key;
                      Map<String, dynamic> p = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onDoubleTap: () => showDeletePlayerPopup(context, idx, players, onUpdate, setStateDialog),
                                  child: Text(
                                    p['name'],
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => showPenaltyPopup(context, idx, players, onUpdate, setStateDialog),
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
                                    style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  p['timeBank'].toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: p['timeBank'] > 0 ? () => showUseTimeBankPopup(context, idx, players, onUpdate, onResetTimer, setStateDialog) : null,
                                  child: SvgPicture.asset(
                                    'assets/Vector.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: p['timeBank'] > 0
                                        ? null
                                        : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
              ),
            );
          },
        );
      },
    );
  }
}
