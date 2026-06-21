import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CenterTimerWidget extends StatelessWidget {
  final ValueNotifier<int> mainTimeMsNotifier;
  final TextEditingController secController;
  final FocusNode focusNode;
  final bool isEditing;
  final VoidCallback updateMainFromInput;

  const CenterTimerWidget({
    Key? key,
    required this.mainTimeMsNotifier,
    required this.secController,
    required this.focusNode,
    required this.isEditing,
    required this.updateMainFromInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double secFontSize = screenWidth * 0.45;
    double msFontSize = screenWidth * 0.15;

    if (secFontSize > 250) secFontSize = 250;
    if (msFontSize > 80) msFontSize = 80;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            flex: 6,
            child: IgnorePointer(
              ignoring: !isEditing,
              child: TextField(
                controller: secController,
                focusNode: focusNode,
                readOnly: !isEditing,
                onChanged: (val) => updateMainFromInput(),
                onSubmitted: (val) {
                  updateMainFromInput();
                  focusNode.unfocus();
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFFf9f5e8),
                  fontSize: secFontSize,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: ValueListenableBuilder<int>(
              valueListenable: mainTimeMsNotifier,
              builder: (context, value, child) {
                String msText = ((value % 1000) ~/ 10).toString().padLeft(2, '0');
                return Text(
                  msText,
                  style: TextStyle(
                    color: const Color(0xFFa0a5b5),
                    fontSize: msFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
