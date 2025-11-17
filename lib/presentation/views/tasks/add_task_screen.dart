import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final TaskController taskController = Get.find();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = 'Medium';
  TaskCategory _selectedCategory = TaskCategory.work;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Work', 'icon': 'work.svg', 'color': Colors.blue},
    {'name': 'Personal', 'icon': 'personal.svg', 'color': Colors.purple},
    {'name': 'Health', 'icon': 'health.svg', 'color': Colors.green},
    {'name': 'Study', 'icon': 'study.svg', 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('Add New Task', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset('assets/images/wave_bg.svg', fit: BoxFit.cover, height: 200),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildTextField('Title', _titleController),
                const SizedBox(height: 16),
                _buildTextField(
                  'Description',
                  _descController,
                  iconPath: 'assets/images/calendar.svg',
                  onTap: _showDateTimePicker,
                ),
                const SizedBox(height: 32),
                const Text('Priority', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _priorityChip('Low', Colors.green),
                    _priorityChip('Medium', Colors.orange),
                    _priorityChip('High', Colors.red),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: categories.map((cat) {
                    final catEnum = TaskCategory.values[categories.indexOf(cat)];
                    final isSelected = _selectedCategory == catEnum;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = catEnum),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? cat['color'] : cat['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/images/${cat['icon']}', width: 20, color: isSelected ? Colors.white : cat['color']),
                            const SizedBox(width: 6),
                            Text(cat['name'], style: TextStyle(color: isSelected ? Colors.white : cat['color'], fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                _buildConfirmButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? iconPath, VoidCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        readOnly: onTap != null,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          suffixIcon: iconPath != null
              ? Padding(padding: const EdgeInsets.all(12), child: SvgPicture.asset(iconPath, width: 20))
              : null,
        ),
      ),
    );
  }

  Widget _priorityChip(String label, Color color) {
    bool isSelected = _priority == label;
    return GestureDetector(
      onTap: () => setState(() => _priority = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveTask,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 8,
          shadowColor: Colors.purple.withOpacity(0.4),
          gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFA29AFE)]),
        ),
        child: const Text('Confirm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  void _showDateTimePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: Colors.purple)), child: child!),
    );
    if (date != null) {
      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        setState(() {
          _selectedDate = date;
          _selectedTime = time;
          _descController.text = DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime(date.year, date.month, date.day, time.hour, time.minute));
        });
      }
    }
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      Get.snackbar('Error', 'Title is required', backgroundColor: Colors.red[100]);
      return;
    }

    final task = Task(
      title: _titleController.text,
      description: _descController.text.isEmpty ? null : _descController.text,
      dueDate: _selectedDate != null && _selectedTime != null
          ? DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute)
          : null,
      category: _selectedCategory,
      priority: _priority,
    );

    taskController.addTask(task).then((_) {
      Get.back();
      Get.snackbar('Success', 'Task added!', backgroundColor: Colors.green[100]);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}