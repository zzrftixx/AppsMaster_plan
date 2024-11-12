import '../models/data_layer.dart';
import 'package:flutter/material.dart';
import '../plan_provider.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Plan Muh Andra Ariesfi')),
      body: _buildList(),
      floatingActionButton: _buildAddTaskButton(context), // Pass context here
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<Plan> planNotifier =
        PlanProvider.of(context); // Ambil Plan dari PlanProvider
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Plan currentPlan = planNotifier.value; // Ambil nilai Plan saat ini
        planNotifier.value = Plan(
          name: currentPlan.name,
          tasks: List<Task>.from(currentPlan.tasks)
            ..add(const Task()), // Tambahkan tugas baru
        );
      },
    );
  }

  Widget _buildList() {
    ValueNotifier<Plan> planNotifier =
        PlanProvider.of(context); // Ambil Plan dari PlanProvider
    return ValueListenableBuilder<Plan>(
      valueListenable: planNotifier,
      builder: (context, plan, child) {
        return ListView.builder(
          controller: scrollController,
          keyboardDismissBehavior:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? ScrollViewKeyboardDismissBehavior.onDrag
                  : ScrollViewKeyboardDismissBehavior.manual,
          itemCount: plan.tasks.length,
          itemBuilder: (context, index) =>
              _buildTaskTile(plan.tasks[index], index),
        );
      },
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          ValueNotifier<Plan> planNotifier =
              PlanProvider.of(context); // Ambil Plan dari PlanProvider
          setState(() {
            Plan currentPlan = planNotifier.value; // Ambil nilai Plan saat ini
            planNotifier.value = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(
                  description: task.description,
                  complete: selected ?? false,
                ),
            );
          });
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          ValueNotifier<Plan> planNotifier =
              PlanProvider.of(context); // Ambil Plan dari PlanProvider
          setState(() {
            Plan currentPlan = planNotifier.value; // Ambil nilai Plan saat ini
            planNotifier.value = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(
                  description: text,
                  complete: task.complete,
                ),
            );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
