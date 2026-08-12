import 'package:flutter/material.dart';
import 'databasehelper/DatabaseHelper.dart';

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
  // Instância do DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Controllers para os TextFields (Nome e Idade)
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> _labels = ["Nome", "Idade"];

  // Variáveis para os Cursos e Lista vindos do Banco
  int? _cursoIdSelecionado;
  List<Map<String, dynamic>> _cursosDoBanco = [];
  List<Map<String, dynamic>> _listaAlunosMatriculados = [];

  @override
  void initState() {
    super.initState();
    _carregarCursos();
    _carregarAlunos();
  }

  // Carrega os cursos cadastrados no banco para preencher o Dropdown
  Future<void> _carregarCursos() async {
    final cursos = await _dbHelper.listarCursos();
    setState(() {
      _cursosDoBanco = cursos;
    });
  }

  // Carrega os alunos com seus cursos e datas usando o JOIN do banco
  Future<void> _carregarAlunos() async {
    final alunos = await _dbHelper.listarAlunosComCursos();
    setState(() {
      _listaAlunosMatriculados = alunos;
    });
  }

  @override
  void dispose() {
    for (var _c in _controllers) {
      _c.dispose();
    }
    super.dispose();
  }

  // Função para realizar o cadastro salvando no SQLite
  Future<void> _cadastrar() async {
    final nome = _controllers[0].text.trim();
    final idadeStr = _controllers[1].text.trim();
    final cursoId = _cursoIdSelecionado;

    if (nome.isNotEmpty && idadeStr.isNotEmpty && cursoId != null) {
      final idade = int.tryParse(idadeStr) ?? 0;

      // Insere o aluno e pega o ID gerado
      int alunoId = await _dbHelper.insertAluno({
        'nome': nome,
        'idade': idade,
      });

      // Insere a matrícula vinculando o aluno ao curso selecionado
      await _dbHelper.insertMatricula(alunoId, cursoId);

      // Limpa os campos e atualiza a lista na tela
      setState(() {
        _controllers[0].clear();
        _controllers[1].clear();
        _cursoIdSelecionado = null;
      });

      // Recarrega os dados do banco
      _carregarAlunos();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos e selecione um curso!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Cadastro de Alunos com SQLite"),
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

            // Dropdown de Cursos Dinâmico (Vindo do Banco)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Cursos",
                  border: OutlineInputBorder(),
                ),
                value: _cursoIdSelecionado,
                items: _cursosDoBanco.map((curso) {
                  return DropdownMenuItem<int>(
                    value: curso['id'], // O valor salvo é o ID do curso
                    child: Text(curso['nome']), // O texto exibido é o nome
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _cursoIdSelecionado = newValue;
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

            // Lista dos alunos cadastrados vinda do SQLite
            Expanded(
              child: _listaAlunosMatriculados.isEmpty
                  ? const Center(child: Text("Nenhum aluno cadastrado ainda."))
                  : ListView.builder(
                      itemCount: _listaAlunosMatriculados.length,
                      itemBuilder: (context, index) {
                        final item = _listaAlunosMatriculados[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text("${item['aluno_nome']} (${item['idade']} anos)"),
                            subtitle: Text(
                              "Curso: ${item['curso_nome']}\nData: ${item['data_matricula']}",
                            ),
                            isThreeLine: true,
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