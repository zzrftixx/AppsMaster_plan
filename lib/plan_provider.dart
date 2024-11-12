import 'package:flutter/material.dart';
import '../models/data_layer.dart';

class PlanProvider extends InheritedNotifier<ValueNotifier<List<Plan>>> {
  const PlanProvider({
    super.key,
    required Widget child,
    required ValueNotifier<List<Plan>> notifier,
  }) : super(child: child, notifier: notifier);

  static ValueNotifier<List<Plan>> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PlanProvider>()!
        .notifier!;
  }

  // Metode untuk menambah plan baru
  void addPlan(Plan plan) {
    final plans = notifier!.value;
    plans.add(plan);
    notifier!.value = List.from(plans); // Memperbarui nilai notifier
  }

  // Metode untuk menghapus plan berdasarkan index
  void removePlan(int index) {
    final plans = notifier!.value;
    if (index >= 0 && index < plans.length) {
      plans.removeAt(index);
      notifier!.value = List.from(plans); // Memperbarui nilai notifier
    }
  }

  // Metode untuk memperbarui plan berdasarkan index
  void updatePlan(int index, Plan updatedPlan) {
    final plans = notifier!.value;
    if (index >= 0 && index < plans.length) {
      plans[index] = updatedPlan;
      notifier!.value = List.from(plans); // Memperbarui nilai notifier
    }
  }
}
