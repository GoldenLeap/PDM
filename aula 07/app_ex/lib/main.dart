import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaInicial(),
    )
  );
}


/* Tela 1 */

class TelaInicial extends StatelessWidget{
  const TelaInicial({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Inicial"),
        backgroundColor: Color(0xFF00abcf),
      ),
      body:Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SegundaTela()
              ),
              
            );
          },
          child: Text('Ir para a segunda tela'),
        ),
      ),
    );
  }
}

/* Tela 2 */

class SegundaTela extends StatelessWidget{
  const SegundaTela({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voltar para o inicio"),
        backgroundColor: Color.fromARGB(255, 162, 0, 255),
      ),
      body:Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Ir para a tela inicial'),
        ),
      ),
    );
  }
}