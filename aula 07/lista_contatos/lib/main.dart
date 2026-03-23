import 'package:flutter/material.dart';
import "package:lista_contatos/widgets/contat_card.dart";

void main() {
  runApp(MaterialApp(home: ListaContatos()));
}

class Contato {
  final String nome;
  final String numero;
  final String imgPath;
  final String email;
  final String endereco;

  Contato({
    required this.nome,
    required this.numero,
    required this.imgPath,
    this.email = '',
    this.endereco = '',
  });
}

class ListaContatos extends StatelessWidget {
  final List<Contato> contatos = [
    Contato(
      nome: 'João Silva',
      numero: '(11) 98765-4321',
      imgPath: 'assets/images/placeholder.png',
      email: '',
      endereco: '',
    ),
    Contato(
      nome: 'Maria Santos',
      numero: '(11) 99876-5432',
      imgPath: 'assets/images/placeholder.png',
      email: '',
      endereco: '',
    ),
    Contato(
      nome: 'Pedro Costa',
      numero: '(11) 97654-3210',
      imgPath: 'assets/images/placeholder.png',
      email: '',
      endereco: '',
    ),
    Contato(
      nome: 'Ana Oliveira',
      numero: '(11) 96543-2109',
      imgPath: 'assets/images/placeholder.png',
      email: '',
      endereco: '',
    ),
  ];

  ListaContatos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de contatos"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final contato = contatos[index];
          return ContatCard(
            nome: contato.nome,
            number: contato.numero,
            imgPath: contato.imgPath,
            callFunc: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Chamando...'),
                    content: Text("Ligando para ${contato.nome}..."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  );
                },
              );
            },
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaginaDetalhes(
                    nome: contato.nome,
                    numero: contato.numero,
                    imagem: contato.imgPath,
                    email: contato.email,
                    endereco: contato.endereco,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PaginaDetalhes extends StatelessWidget {
  final String nome;
  final String numero;
  final String imagem;
  final String email;
  final String endereco;

  const PaginaDetalhes({
    super.key,
    required this.nome,
    required this.numero,
    required this.imagem,
    required this.email,
    required this.endereco,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações de contato'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                imagem,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Chamando...'),
                                content: Text("Ligando para $nome..."),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.phone,
                          size: 28,
                          color: Colors.blue,
                        ),
                      ),
                      const Text("Chamar", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.message,
                          size: 28,
                          color: Colors.green,
                        ),
                      ),
                      const Text("Texto", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chat,
                          size: 28,
                          color: Colors.green,
                        ),
                      ),
                      const Text("WhatsApp", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.videocam,
                          size: 28,
                          color: Colors.purple,
                        ),
                      ),
                      const Text("Vídeo", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.blue),
                title: const Text('Telefone'),
                subtitle: Text(numero),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text('E-mail'),
                subtitle: Text(email.isEmpty ? 'Não informado' : email),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text('Endereço'),
                subtitle: Text(endereco.isEmpty ? 'Não informado' : endereco),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
