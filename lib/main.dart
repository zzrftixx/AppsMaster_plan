import 'package:flutter/material.dart';
import 'package:flutter_note_apps/models/plan.dart';
import 'package:flutter_note_apps/plan_provider.dart';
import 'views/plan_creator_screen.dart';

void main() => runApp(MasterPlanApp());

class MasterPlanApp extends StatelessWidget {
  const MasterPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlanProvider(
      notifier:
          ValueNotifier<List<Plan>>(const []), // Menggunakan List<Plan> kosong
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const PlanCreatorScreen(),
      ),
    );
  }
}
