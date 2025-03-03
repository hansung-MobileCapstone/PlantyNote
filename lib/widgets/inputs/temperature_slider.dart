import 'package:flutter/material.dart';

class TemperatureSlider extends StatelessWidget {
  final double temperature;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;

  const TemperatureSlider({
    Key? key,
    required this.temperature,
    required this.onChanged,
    this.min = -10,
    this.max = 40,
    this.divisions = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "온도: ${temperature.toStringAsFixed(1)}°C",
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF697386),
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "-10",
              style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
            ),
            SizedBox(
              width: 250,
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFE6E6E6),
                  inactiveTrackColor: const Color(0xFFE6E6E6),
                  thumbColor: const Color(0xFF4B7E5B),
                  trackHeight: 3.0,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6.0,
                  ),
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: const Color(0xFF4B7E5B),
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: temperature,
                  min: min,
                  max: max,
                  divisions: divisions,
                  label: '${temperature.toStringAsFixed(1)}°C',
                  onChanged: onChanged,
                ),
              ),
            ),
            const Text(
              "40",
              style: TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
            ),
          ],
        ),
      ],
    );
  }
}
