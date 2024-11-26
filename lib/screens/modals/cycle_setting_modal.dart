import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CycleSettingModal extends StatefulWidget {
  final double initialWaterCycle;
  final double initialFertilizerCycle;
  final double initialRepottingCycle;
  final Function(double, double, double) onSave;

  const CycleSettingModal({
    super.key,
    required this.initialWaterCycle,
    required this.initialFertilizerCycle,
    required this.initialRepottingCycle,
    required this.onSave,
  });

  @override
  State<CycleSettingModal> createState() => _CycleSettingModalState();
}

class _CycleSettingModalState extends State<CycleSettingModal> {
  late double waterCycle;
  late double fertilizerCycle;
  late double repottingCycle;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    waterCycle = widget.initialWaterCycle;
    fertilizerCycle = widget.initialFertilizerCycle;
    repottingCycle = widget.initialRepottingCycle;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSlider('물 주기', waterCycle, 1, 60, (value) {
              setState(() {
                waterCycle = value;
              });
            }, "일"),
            _buildSlider('영양제 주기', fertilizerCycle, 0, 18, (value) {
              setState(() {
                fertilizerCycle = value;
              });
            }, "개월"),
            _buildSlider('분갈이 주기', repottingCycle, 0, 18, (value) {
              setState(() {
                repottingCycle = value;
              });
            }, "개월"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onSave(waterCycle, fertilizerCycle, repottingCycle); // 부모로 값 전달
                context.pop(); // 모달창 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B7E5B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                '완료',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 각 주기를 설정하는 슬라이더
  Widget _buildSlider(
      String label, double value, double min, double max, ValueChanged<double> onChanged, String unit) {
    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF697386),
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: '${value.toInt()}$unit',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF697386),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${min.toInt() != 0 ? min.toInt() : ""}${unit == "개월" ? "안함" : ""}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF697386),
                ),
              ),
              SizedBox(
                width: 250,
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF4B7E5B), // 활성
                    inactiveTrackColor: const Color(0xFFE6E6E6), // 비활성
                    thumbColor: const Color(0xFF4B7E5B), // 핸들
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
                    value: value,
                    min: min,
                    max: max,
                    divisions: (max - min).toInt(),
                    label: '${value.toInt()}$unit',
                    onChanged: onChanged,
                  ),
                ),
              ),
              Text(
                '${max.toInt()}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF697386),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
