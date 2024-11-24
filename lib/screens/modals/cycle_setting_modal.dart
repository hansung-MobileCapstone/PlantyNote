import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CycleSettingModal extends StatefulWidget {
  const CycleSettingModal({super.key});

  @override
  State<CycleSettingModal> createState() => _CycleSettingModalState();
}

class _CycleSettingModalState extends State<CycleSettingModal> {
  double waterCycle = 40;
  double fertilizerCycle = 3;
  double repottingCycle = 12;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSlider('물 주기', waterCycle, 1, 60, (value) {
              setState(() {
                waterCycle = value;
              });
            }),
            _buildSlider('영양제 주기', fertilizerCycle, 1, 18, (value) {
              setState(() {
                fertilizerCycle = value;
              });
            }),
            _buildSlider('분갈이 주기', repottingCycle, 1, 18, (value) {
              setState(() {
                repottingCycle = value;
              });
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toInt()}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
