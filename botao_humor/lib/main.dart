// Crie um app que altere o humor 
// Feliz
// Neutro
// Bravo

import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp( MaterialApp(
    home: BotaoHumor(),
    debugShowCheckedModeBanner: false,
  ));
}


class BotaoHumor extends StatefulWidget{
  const BotaoHumor({super.key});

  @override 
  State<BotaoHumor> createState()=> _BotaoHumorState();
}

enum Humor {
    feliz,
    neutro,
    bravo, 
  }

const colors = [Colors.yellow, Colors.blue, Colors.red, Color.fromARGB(255, 132, 0, 255), Color.fromARGB(255, 255, 0, 98), Color.fromARGB(199, 0, 255, 76)];

class _BotaoHumorState extends State<BotaoHumor>{
  var iHumor = 0;
  var humor = Humor.neutro; 
  var col = colors[0];
  var texCol = colors[3];
  void mudarHumor(){
    setState((){
      iHumor = (iHumor + 1) % Humor.values.length;
      col = colors[iHumor];
      texCol = colors[iHumor + 3];
      humor = Humor.values[iHumor]; 
    });
  }
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: col,
      appBar: AppBar(
        backgroundColor: Color.alphaBlend(const Color.fromARGB(31, 0, 0, 0),col),
        title: Center(
          child: Text("Botão de humor",
                 style: TextStyle(color: texCol)
          ),
        ),
      actions: [
        Icon(
          size: 50,
          color: texCol,
          switch (humor) {
            Humor.bravo => Icons.sentiment_dissatisfied_outlined,
            Humor.neutro => Icons.sentiment_neutral_outlined,
            Humor.feliz => Icons.sentiment_satisfied,
          },
        ),
      ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              color: texCol,
              onPressed: mudarHumor,
              icon:  Icon(
              color: texCol,
              switch (humor) {
                Humor.bravo => Icons.sentiment_dissatisfied_outlined,
                Humor.neutro => Icons.sentiment_neutral_outlined,
                Humor.feliz => Icons.sentiment_satisfied_outlined,
              }),
              iconSize: 200,
            ),
            ElevatedButton(
              onPressed: mudarHumor, 
              style: ElevatedButton.styleFrom(
                backgroundColor: col,
                textStyle: TextStyle(color: texCol),
              ),
              child:  Text(
                'Mudar'
              ),
            ),
          ],
        )
      ),
      
    );

  }
}