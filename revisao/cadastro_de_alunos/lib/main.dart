import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CadastroAluno(),
    );
  }
}

class CadastroAluno extends StatefulWidget {
  const CadastroAluno({super.key});

  @override
  State<CadastroAluno> createState() => _CadastroAlunoState();
}

class _CadastroAlunoState extends State<CadastroAluno> {
  // Lista para armazenar as informações dos alunos cadastrados
  final List<String> listaAluno = [];

  // Controllers para os TextFields (Nome e Idade)
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> _labels = ["Nome", "Idade"];

  String? _opcaoSelecionada;
  final List<String> _cursos = [
    "Ciência da Computação",
    "Design Gráfico",
    "Administração",
  ];

  @override
  void dispose() {
    for (var _c in _controllers) {
      _c.dispose();
    }
    super.dispose();
  }

  // Função para realizar o cadastro
  void _cadastrar() {
    final nome = _controllers[0].text;
    final idade = _controllers[1].text;
    final curso = _opcaoSelecionada;

    if (nome.isNotEmpty && idade.isNotEmpty && curso != null) {
      setState(() {
        listaAluno.add("Nome: $nome | Idade: $idade | Curso: $curso");

        // Limpa os campos após o cadastro
        _controllers[0].clear();
        _controllers[1].clear();
        _opcaoSelecionada = null;
      });
    } else {
      // Exibe um aviso simples se algum campo estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Cadastro de Alunos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campos de Texto (Nome e Idade)
            SizedBox(
              height: 140,
              child: ListView.builder(
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: index == 1
                          ? TextInputType.number
                          : TextInputType.text,
                      decoration: InputDecoration(
                        labelText: _labels[index],
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Dropdown de Cursos
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Cursos",
                  border: OutlineInputBorder(),
                ),
                value: _opcaoSelecionada,
                items: _cursos.map((String valor) {
                  return DropdownMenuItem<String>(
                    value: valor,
                    child: Text(valor),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _opcaoSelecionada = newValue;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            // Botão Cadastrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _cadastrar,
                child: const Text("Cadastrar"),
              ),
            ),

            const Divider(height: 30),

            // Título da Lista
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Alunos Cadastrados:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // Lista dos alunos cadastrados exibida na tela
            Expanded(
              child: listaAluno.isEmpty
                  ? const Center(child: Text("Nenhum aluno cadastrado ainda."))
                  : ListView.builder(
                      itemCount: listaAluno.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(listaAluno[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
