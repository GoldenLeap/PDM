import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Cadastro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Cadastro de Alunos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  bool _loading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  void _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      try {
        final nomeAluno = _nomeController.text.trim();

        await _firestoreService.adicionarAluno(
          nome: nomeAluno,
          idade: int.parse(_idadeController.text),
          curso: _cursoController.text.trim(),
        );

        _nomeController.clear();
        _idadeController.clear();
        _cursoController.clear();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aluno $nomeAluno salvo com sucesso!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 50,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Novo Aluno',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nomeController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Nome Completo',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? 'Digite o nome' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _idadeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: 'Idade',
                            prefixIcon: const Icon(Icons.cake_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Digite a idade';
                            final idade = int.tryParse(value);
                            if (idade == null || idade <= 0 || idade >= 140) return 'Idade inválida';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _cursoController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: 'Curso',
                            prefixIcon: const Icon(Icons.school_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? 'Digite o curso' : null,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _cadastrar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle_outline),
                                      SizedBox(width: 8),
                                      Text(
                                        "Cadastrar",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child:Text(
                      "Alunos Cadastrados",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ),
              ),
              const SizedBox(height: 10),
              ListaAlunosWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaAlunosWidget extends StatelessWidget {
  final FirestoreService _service = FirestoreService();

  ListaAlunosWidget({super.key});

  void _confirmarExclusao(BuildContext context, String id, String nome){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Aluno'),
        content: Text('Tem certeza que deseja excluir $nome?'),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.pop(ctx), 
            child: const Text('Cancelar')),
          TextButton(onPressed: () async {
            Navigator.pop(ctx); 
            await _service.deletarAluno(id);
            if(ctx.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aluno deletado com sucesso'))
              );
            }
          }, child: Text('Confirmar'))
        ]
      )
    )   ;
  }

  void _abrirModalEdicao(
      BuildContext context, String id, Map<String, dynamic> aluno) {
    final nomeEditController = TextEditingController(text: aluno['nome']);
    final idadeEditController =
        TextEditingController(text: aluno['idade']?.toString());
    final cursoEditController = TextEditingController(text: aluno['curso']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Aluno'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeEditController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: idadeEditController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Idade'),
              ),
              TextField(
                controller: cursoEditController,
                decoration: const InputDecoration(labelText: 'Curso'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final novaIdade = int.tryParse(idadeEditController.text);
              if (novaIdade != null &&
                  nomeEditController.text.isNotEmpty &&
                  cursoEditController.text.isNotEmpty) {
                Navigator.pop(ctx);
                await _service.atualizarAluno(
                  id: id,
                  nome: nomeEditController.text.trim(),
                  idade: novaIdade,
                  curso: cursoEditController.text.trim(),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dados atualizados!')),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _service.listarAlunos(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar alunos: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Nenhum aluno cadastrado."),
          );
        }

        return ListView.builder(
          shrinkWrap: true, // Garante que a lista ocupe apenas a altura necessária
          physics: const NeverScrollableScrollPhysics(), // Desativa a rolagem própria para rolar junto com a tela
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final docId = doc.id;
            final aluno = doc.data() as Map<String, dynamic>;
            final nome = aluno['nome'] ?? 'Sem nome';
            final primeiraLetra = nome.isNotEmpty ? nome[0].toUpperCase() : '?';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(primeiraLetra),
                ),
                title: Text(nome, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${aluno["curso"] ?? "Sem curso"} • ${aluno['idade'] ?? 0} anos'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: ()=>_abrirModalEdicao(context, docId, aluno), 
                    icon: Icon(Icons.edit_outlined, color: Colors.blue)
                  ),
                  IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmarExclusao(context, docId, nome),
                  )
                ],
              ),
              ),
            );
          },
        );
      },
    );
  }
}