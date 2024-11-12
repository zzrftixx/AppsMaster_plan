import '../models/data_layer.dart';
import 'package:flutter/material.dart';
import '../plan_provider.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan; // Menambahkan variabel plan
  const PlanScreen(
      {super.key, required this.plan}); // Menambahkan atribut pada konstruktor

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  // Getter untuk mengakses plan dari widget
  Plan get plan => widget.plan;

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
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(plan.name)), // Menggunakan getter plan
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          Plan currentPlan = plans.firstWhere((p) =>
              p.name == plan.name); // Mengambil currentPlan berdasarkan nama
          return Column(
            children: [
              Expanded(
                  child: _buildList(currentPlan)), // Menggunakan currentPlan
              SafeArea(
                  child: Text(currentPlan
                      .completenessMessage)), // Menggunakan currentPlan
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Plan currentPlan = plan; // Menggunakan getter plan
        int planIndex = planNotifier.value.indexWhere(
            (p) => p.name == currentPlan.name); // Mendapatkan index currentPlan
        List<Task> updatedTasks = List<Task>.from(currentPlan.tasks)
          ..add(const Task()); // Menambahkan task baru
        planNotifier.value = List<Plan>.from(planNotifier.value)
          ..[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );
        // Tidak perlu mengubah nilai dari plan, cukup memperbarui daftar rencana
      },
    );
  }

  Widget _buildList(Plan currentPlan) {
    return ListView.builder(
      controller: scrollController,
      itemCount: currentPlan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(currentPlan.tasks[index], index, context),
    );
  }

  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier =
        PlanProvider.of(context); // Mengubah ke List<Plan>
    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          Plan currentPlan = plan; // Menggunakan getter plan
          int planIndex = planNotifier.value.indexWhere((p) =>
              p.name == currentPlan.name); // Mendapatkan index currentPlan
          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(
                  description: task.description,
                  complete: selected ?? false,
                ),
            );
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          Plan currentPlan = plan; // Menggunakan getter plan
          int planIndex = planNotifier.value.indexWhere((p) =>
              p.name == currentPlan.name); // Mendapatkan index currentPlan
          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(
                  description: text,
                  complete: task.complete,
                ),
            );
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
