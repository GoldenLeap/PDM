import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ItensPage(),
  ));
}

class ItensPage extends StatefulWidget {
  const ItensPage({super.key});

  @override
  ItensPageState createState() => ItensPageState();
}

class ItensPageState extends State<ItensPage> {
  List<String> itens = [];
  List<bool> comprado = [];
  TextEditingController controller = TextEditingController();

  void adicionarItem() {
    if (controller.text.isNotEmpty) {
      setState(() {
        itens.add(controller.text);
        comprado.add(false);
        controller.clear();
      });
      salvarItens();
    }
  }

  void removerItem(int index) {
    setState(() {
      itens.removeAt(index);
      comprado.removeAt(index);
    });
    salvarItens();
  }

  void alternarItem(int index) {
    setState(() {
      comprado[index] = !comprado[index];
    });
    salvarItens();
  }

  void salvarItens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("itens", itens);
    await prefs.setStringList(
      "comprado",
      comprado.map((e) => e.toString()).toList(),
    );
  }
  void limparItens() async {
    setState(() {
      itens.clear();
      comprado.clear();
    });
    salvarItens();
  }
  void carregarItens() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? itensSalvos = prefs.getStringList("itens");
    final List<String>? compradoSalvo = prefs.getStringList("comprado");

    if (itensSalvos != null) {
      setState(() {
        itens = itensSalvos;
        if (compradoSalvo != null && compradoSalvo.length == itensSalvos.length) {
          comprado = compradoSalvo.map((e) => e == 'true').toList();
        } else {
          comprado = List<bool>.filled(itensSalvos.length, false);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carregarItens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas anotações"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          ElevatedButton(onPressed: limparItens, child: Text('Limpar itens')),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: AlignmentGeometry.centerStart,
            child:Text("Itens: ${itens.length}"),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Digite uma nota",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.note_add),
              ),
               onSubmitted: (_) => adicionarItem(), 
            ),
          ),
          ElevatedButton.icon(
            onPressed: adicionarItem,
            icon: const Icon(Icons.add),
            label: const Text('Salvar Nota'),
          ),
          const Divider(), 
          Expanded(
            child: itens.isEmpty
                ? const Center(child: Text('Nenhuma nota.'))
                : ListView.builder(
                    itemCount: itens.length,
                    itemBuilder: (context, index) {
                      return Card( 
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          onTap: () => alternarItem(index),
                          leading: Checkbox(
                            value: comprado[index],
                            onChanged: (value) => alternarItem(index),
                          ),
                          title: Text(
                            itens[index],
                            style: TextStyle(
                              decoration: comprado[index]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: comprado[index] ? const Color.fromARGB(255, 255, 46, 46) : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () => removerItem(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
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