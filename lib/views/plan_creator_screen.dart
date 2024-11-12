import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Untuk ValueNotifier
import '../plan_provider.dart'; // Pastikan Anda mengimpor provider yang sesuai
import '../models/plan.dart'; // Pastikan Anda mengimpor model Plan
import 'plan_screen.dart'; // Pastikan Anda mengimpor layar rencana

class PlanCreatorScreen extends StatefulWidget {
  const PlanCreatorScreen({Key? key}) : super(key: key);

  @override
  _PlanCreatorScreenState createState() => _PlanCreatorScreenState();
}

class _PlanCreatorScreenState extends State<PlanCreatorScreen> {
  final TextEditingController textController =
      TextEditingController(); // Menambahkan TextEditingController

  @override
  void dispose() {
    textController
        .dispose(); // Membersihkan controller saat widget di-unmounted
    super.dispose();
  }

  void addPlan() {
    final text = textController.text; // Mengambil input dari TextField
    if (text.isEmpty) {
      return; // Jika input kosong, keluar dari fungsi
    }

    final plan = Plan(name: text, tasks: []); // Membuat objek Plan baru
    ValueNotifier<List<Plan>> planNotifier =
        PlanProvider.of(context); // Mendapatkan ValueNotifier dari provider
    planNotifier.value = List<Plan>.from(planNotifier.value)
      ..add(plan); // Menambahkan plan baru ke dalam daftar
    textController
        .clear(); // Mengosongkan TextField setelah menambahkan rencana
    FocusScope.of(context)
        .requestFocus(FocusNode()); // Menghilangkan fokus dari TextField
    setState(() {}); // Memperbarui tampilan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Master Plans Muh Andra Ariesfi'), // Ganti '[Nama Panggilan Anda]' dengan nama panggilan Anda
      ),
      body: Column(
        children: [
          _buildListCreator(), // Memanggil widget _buildListCreator
          Expanded(
              child: _buildMasterPlans()), // Memanggil widget _buildMasterPlans
        ],
      ),
    );
  }

  Widget _buildListCreator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        color: Theme.of(context).cardColor,
        elevation: 10,
        child: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Add a plan',
            contentPadding: EdgeInsets.all(20),
          ),
          onEditingComplete: addPlan, // Memanggil addPlan saat editing selesai
        ),
      ),
    );
  }

  Widget _buildMasterPlans() {
    ValueNotifier<List<Plan>> planNotifier =
        PlanProvider.of(context); // Mendapatkan ValueNotifier
    List<Plan> plans = planNotifier.value; // Mendapatkan daftar rencana

    if (plans.isEmpty) {
      // Jika tidak ada rencana, tampilkan pesan
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.note, size: 100, color: Colors.grey),
          Text(
            'Anda belum memiliki rencana apapun.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      );
    }

    // Jika ada rencana, tampilkan dalam ListView
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index]; // Mengambil rencana berdasarkan index
        return ListTile(
          title: Text(plan.name), // Menampilkan nama rencana
          subtitle:
              Text(plan.completenessMessage), // Menampilkan pesan kelengkapan
          onTap: () {
            // Navigasi ke layar detail rencana saat ditap
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PlanScreen(
                    plan: plan), // Ganti dengan layar rencana yang sesuai
              ),
            );
          },
        );
      },
    );
  }
}
