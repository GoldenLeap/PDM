import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotesPage(),
  ));
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  List<String> listaNotas = [];
  TextEditingController controller = TextEditingController();

  void adicionarNota() {
    if (controller.text.isNotEmpty) {
      setState(() {
        listaNotas.add(controller.text);
        controller.clear();
      });
      salvarNotas();
    }
  }

  void removerNota(int index) {
    setState(() {
      listaNotas.removeAt(index);
    });
    salvarNotas();
  }

  void salvarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("notas", listaNotas);
  }

  void carregarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      listaNotas = prefs.getStringList("notas") ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    carregarNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas anotações"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),  
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Digite uma nota",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: adicionarNota,
            child: const Text('Salvar Nota'),
          ),
          Expanded(
            child: listaNotas.isEmpty
                ? const Center(child: Text('Nenhuma nota.'))
                : ListView.builder(
                    itemCount: listaNotas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(listaNotas[index]),
                        trailing: IconButton(
                          onPressed: () => removerNota(index),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}