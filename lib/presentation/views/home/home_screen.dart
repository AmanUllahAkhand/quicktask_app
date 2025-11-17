import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../components/task_card.dart';
import '../../components/reminder_card.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/models/reminder_model.dart';
import '../../../core/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getFormattedDate(), style: TextStyle(fontSize: 18, color: Colors.grey[700])),
          ],
        ),
        actions: [
          CircleAvatar(backgroundImage: AssetImage('assets/images/profile.jpg'), radius: 20),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset('assets/images/wave_bg.svg', fit: BoxFit.cover, height: 200),
          ),
          RefreshIndicator(
            onRefresh: taskController.loadTasks,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _filterChip('All', null, taskController),
                        _filterChip('Work', TaskCategory.work, taskController),
                        _filterChip('Personal', TaskCategory.personal, taskController),
                        _filterChip('Health', TaskCategory.health, taskController),
                        _filterChip('Study', TaskCategory.study, taskController),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('My Tasks', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (taskController.isLoading.value) return const Center(child: CircularProgressIndicator());
                    if (taskController.tasks.isEmpty) return _buildEmptyTask();
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskController.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskController.tasks[index];
                        return TaskCard(
                          task: task,
                          onToggle: () => taskController.toggleTask(task),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Reminders', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Reminder>>(
                    future: AppDatabase.instance.getReminders(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      final reminders = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reminders.length,
                        itemBuilder: (context, index) {
                          final reminder = reminders[index];
                          return ReminderCard(title: reminder.title, iconPath: 'assets/images/${reminder.icon}');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          // FAB
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => Get.toNamed(Routes.ADD_TASK)?.then((_) => taskController.loadTasks()),
              backgroundColor: const Color(0xFF6C5CE7),
              child: const Icon(Icons.add, size: 32),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _filterChip(String label, TaskCategory? category, TaskController controller) {
    final isSelected = controller.selectedCategory.value == category;
    return GestureDetector(
      onTap: () => controller.filterByCategory(category),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyTask() {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Center(child: Text('No tasks yet. Tap + to add!', style: TextStyle(color: Colors.grey))),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/task.svg', width: 24), label: 'Tasks'),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/news.svg', width: 24), label: 'News'),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/profile.svg', width: 24), label: 'Profile'),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.purple,
      onTap: (index) {
        if (index == 1) Get.toNamed('/news');
        if (index == 2) Get.toNamed(Routes.PROFILE);
      },
    );
  }
}
