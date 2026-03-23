import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: TelaInicial()),
  );  
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Atividade")),
      body: Center(
        child: Column(
          children: [
            Text("Aperta não."),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SegundaTela(name:"AAAAAAAA")),
                );
              },
              child: Text("Aperta."),
            ),
          ],
        ),
      ),
    );
  }
}

class SegundaTela extends StatelessWidget {
  final String name;
  const SegundaTela({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Segunda página")),
      body: Center(
        child: Column(
          children: [
            Text('Bem vindo a segunda tela :D'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Agora aperta :D $name"),
            ),
          ],
        ),
      ),
    );
  }
}
