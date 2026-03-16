

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: JogoApp(),
  ));
}

class JogoApp extends StatefulWidget {
  const JogoApp({super.key});

  @override
  _JogoAppState createState() => _JogoAppState();
}

class _JogoAppState extends State<JogoApp>{
  FaIconData iconeComp = FontAwesomeIcons.circleQuestion;
  String resultado = "Escolha uma opção";

  int pontosJogador = 0;
  int pontosComputador = 0;

  // Pedra = 0, tesoura = 1, papel = 2
  void resetarPlacar() {
    setState(() {
      pontosComputador = 0;
      pontosJogador = 0;
      iconeComp = FontAwesomeIcons.circleQuestion;
    });
  }
  void jogar(int escolhaUsuario){
    var escolhaComputador = Random().nextInt(3);
    setState((){
      var result = gerarResultado(escolhaUsuario, escolhaComputador);
      switch (result){
        case 1:
          pontosComputador++;
          resultado = "Computador venceu!";
          break;
        case 2:
          pontosJogador++;
          resultado = "Você venceu!";
          break;
        default:
          resultado = "Empate";
      }
      if(pontosComputador >= 5 || pontosJogador >= 5){
        resultado = pontosComputador >= 5? "Computador venceu" : "Você venceu";
        pontosComputador = 0;
        pontosJogador = 0;
      }
      iconeComp = switch(escolhaComputador){
        0 => FontAwesomeIcons.handBackFist,
        1 => FontAwesomeIcons.hand,
        2 => FontAwesomeIcons.handScissors,
        _ => FontAwesomeIcons.question
      };
    });
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedra Papel Tesoura'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Computador"),
            FaIcon(
              iconeComp, 
              size: 100
            ),
            Text(
              resultado,
              style: TextStyle(fontSize: 26),
            ),
            Text("Você: $pontosJogador | PC: $pontosComputador",),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: ()=>jogar(0),
                  icon: FaIcon(FontAwesomeIcons.handBackFist),
                ),
                IconButton(
                  onPressed: ()=>jogar(1),
                  icon: FaIcon(FontAwesomeIcons.hand),
                ),
                IconButton(
                  onPressed: ()=>jogar(2),
                  icon: FaIcon(FontAwesomeIcons.handScissors),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: resetarPlacar, 
              icon: FaIcon(FontAwesomeIcons.arrowsRotate), 
              label: Text('Resetar Placar'),)
          ],
        ),
      ),
    );
  }

}

int gerarResultado(int usuario, int comp){
  int result = (comp - usuario) % 3;
  return result;
}