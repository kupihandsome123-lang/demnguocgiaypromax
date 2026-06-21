import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/center_timer.dart';
import 'widgets/player_panel.dart';
import 'widgets/popups.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Pro Max',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Segoe UI', useMaterial3: true),
      home: const MainTimerScreen(),
    );
  }
}

class MainTimerScreen extends StatefulWidget {
  const MainTimerScreen({super.key});

  @override
  State<MainTimerScreen> createState() => _MainTimerScreenState();
}

class _MainTimerScreenState extends State<MainTimerScreen> {
  late TextEditingController _secController;
  late FocusNode _focusNode;

  Timer? _timer;
  
  // State quản lý thời gian
  late ValueNotifier<int> _mainTimeMsNotifier;
  int _lastSetTimeMs = 20000;
  bool _isRunning = false;
  bool _isEditing = false;

  final List<Map<String, dynamic>> _players = [];

  @override
  void initState() {
    super.initState();
    _mainTimeMsNotifier = ValueNotifier<int>(20000);
    _secController = TextEditingController(text: '20');
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isEditing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _secController.dispose();
    _focusNode.dispose();
    _mainTimeMsNotifier.dispose();
    super.dispose();
  }

  void _updateMainFromInput() {
    if (!_isRunning) {
      int seconds = int.tryParse(_secController.text) ?? 0;
      int newTimeMs = seconds * 1000;
      _mainTimeMsNotifier.value = newTimeMs;
      if (newTimeMs > 0) {
        _lastSetTimeMs = newTimeMs;
      }
      setState(() {});
    }
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      if (_mainTimeMsNotifier.value <= 0) return;
      setState(() {
        _isRunning = true;
      });
      FocusScope.of(context).unfocus();

      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        // Cập nhật ValueNotifier thay vì setState toàn màn hình
        int nextValue = _mainTimeMsNotifier.value - 10;
        if (nextValue <= 0) {
          _mainTimeMsNotifier.value = 0;
          _timer?.cancel();
          setState(() {
            _isRunning = false;
          });
        } else {
          _mainTimeMsNotifier.value = nextValue;
        }
        
        // Update secController khi đếm ngược để đồng bộ nếu cần
        if (_isRunning) {
          _secController.text = (_mainTimeMsNotifier.value ~/ 1000).toString();
        }
      });
    }
  }

  void _resetAndStart() {
    _timer?.cancel();
    _mainTimeMsNotifier.value = _lastSetTimeMs;
    _secController.text = (_mainTimeMsNotifier.value ~/ 1000).toString();
    setState(() {
      _isRunning = false;
    });
    _toggleTimer();
  }

  void _onPlayersUpdated() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11121a),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_isEditing) {
            _focusNode.unfocus();
            setState(() {
              _isEditing = false;
            });
            _updateMainFromInput();
          } else {
            _toggleTimer();
          }
        },
        onDoubleTap: () {
          if (_isRunning) {
            _toggleTimer();
          }
          setState(() {
            _isEditing = true;
          });
          _focusNode.requestFocus();
        },
        onPanEnd: (details) {
          if (details.velocity.pixelsPerSecond.distance > 300) {
            _resetAndStart();
          }
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [Color(0xFF24273d), Color(0xFF11121a)],
                ),
              ),
              child: CenterTimerWidget(
                mainTimeMsNotifier: _mainTimeMsNotifier,
                secController: _secController,
                focusNode: _focusNode,
                isEditing: _isEditing,
                updateMainFromInput: _updateMainFromInput,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: PlayerPanelWidget(
                    players: _players,
                    onAddPlayerTap: () => PopupHelpers.showAddPlayerPopup(
                      context,
                      _players,
                      _onPlayersUpdated,
                      _resetAndStart,
                    ),
                    onPenaltyTap: (idx) => PopupHelpers.showPenaltyPopup(
                      context,
                      idx,
                      _players,
                      _onPlayersUpdated,
                    ),
                    onUseTimeBankTap: (idx) => PopupHelpers.showUseTimeBankPopup(
                      context,
                      idx,
                      _players,
                      _onPlayersUpdated,
                      _resetAndStart,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
