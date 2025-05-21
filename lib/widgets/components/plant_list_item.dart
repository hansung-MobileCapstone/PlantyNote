import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../util/calculateDday.dart';
import 'ConfirmDialog.dart';

class PlantListItem extends StatefulWidget {
  final String plantName;
  final String imageUrl;
  final DateTime waterDate;     // ✅ 추가
  final int waterCycle;         // ✅ 유지
  final int dDayFertilizer;
  final String plantId;

  const PlantListItem({
    super.key,
    required this.plantName,
    required this.imageUrl,
    required this.waterDate,
    required this.waterCycle,
    required this.dDayFertilizer,
    required this.plantId,
  });

  @override
  State<PlantListItem> createState() => _PlantListItemState();
}

class _PlantListItemState extends State<PlantListItem> {
  late DateTime _lastWaterDate;

  @override
  void initState() {
    super.initState();
    _lastWaterDate = widget.waterDate;
  }

  @override
  Widget build(BuildContext context) {
    final int dDayWater = calculateWater(_lastWaterDate, widget.waterCycle.toDouble());

    return GestureDetector(
      onTap: () {
        context.push('/plants/timeline/${widget.plantId}');
      },
      child: SizedBox(
        height: 130,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          color: const Color(0xFFF5F5F5),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _plantName()),
                const SizedBox(width: 8),
                _plantImage(context),
                const SizedBox(width: 8),
                Expanded(child: _dDay(dDayWater)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _plantName() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        widget.plantName,
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }

  Widget _plantImage(BuildContext context) {
    final file = File(widget.imageUrl);

    return Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundImage: widget.imageUrl.isNotEmpty && file.existsSync()
                ? FileImage(file)
                : const AssetImage('assets/images/default_post.png') as ImageProvider,
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.water_drop, color: Color(0xFF8FD7FF), size: 20),
                padding: EdgeInsets.zero,
                onPressed: () => _showWateringDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWateringDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: '물 주기',
        content: '${widget.plantName}에게 물을 주시겠습니까?',
        onConfirm: () {
          Navigator.pop(context, true);
        },
      ),
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await _updateWaterDate();
          _showToast("${widget.plantName}에게 물을 주었습니다!");
        } catch (e) {
          _showToast("물 주기 실패..");
        }
      }
    });
  }

  Future<void> _updateWaterDate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants')
          .doc(widget.plantId)
          .update({
        'waterDate': now.toIso8601String(),
      });

      setState(() {
        _lastWaterDate = now;
      });
    } catch (e) {
      _showToast("업데이트 실패: $e");
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: const Color(0xFFECF7F2),
      textColor: Colors.black,
      fontSize: 13.0,
    );
  }

  Widget _dDay(int dDayWater) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _dDayBadge('D+${widget.dDayFertilizer}', const Color(0xFFE7B4BA)),
        const SizedBox(height: 8),
        _dDayBadge('D-$dDayWater', const Color(0xFF95CED5)),
      ],
    );
  }

  Widget _dDayBadge(String text, Color color) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
