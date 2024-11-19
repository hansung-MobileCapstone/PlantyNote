// my_plant_register_screen.dart    # 4-1번 화면
import 'package:flutter/material.dart';

class MyPlantRegisterScreen extends StatefulWidget {
  const MyPlantRegisterScreen({super.key});

  @override
  State<MyPlantRegisterScreen> createState() => _MyPlantRegisterScreenState();
}

class _MyPlantRegisterScreenState extends State<MyPlantRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plantNameController = TextEditingController();
  final _plantSpeciesController = TextEditingController();
  bool isError = false;
  bool isImageUploaded = false;

  @override
  void dispose() {
    _plantNameController.dispose();
    _plantSpeciesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() {
      isError = !_formKey.currentState!.validate();
    });
    if (!isError) {
      // 완료 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 식물 등록')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // 사진 업로드 로직 추가
                  setState(() {
                    isImageUploaded = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: isImageUploaded
                        ? const Icon(Icons.check, size: 32, color: Colors.green)
                        : const Text('사진 추가 (10MB 이하)'),
                  ),
                ),
              ),
              if (!isImageUploaded && isError)
                const Text(
                  '사진 용량 초과',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plantNameController,
                decoration: const InputDecoration(
                  labelText: '식물 이름',
                  hintText: '애칭을 정해주세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '식물의 이름을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plantSpeciesController,
                decoration: const InputDecoration(
                  labelText: '식물 종',
                  hintText: '식물의 종을 입력하세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '식물의 종을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
