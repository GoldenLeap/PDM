import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp(MaterialApp(
    home: PaginaRandNum(),
  )
  );
}

class PaginaRandNum extends StatefulWidget
{
  const PaginaRandNum({super.key});

  @override
    PaginaRandNumState createState() => PaginaRandNumState();
}


int sortear(){
  var random = Random();
  return 1+random.nextInt(10);
}


class PaginaRandNumState extends State<PaginaRandNum>
{
  int randNum = sortear();

  void _update(){
    setState((){
      randNum = sortear();
    });
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Numero Aleatorio"),

      ),
      body: Center(
        child: Text("Numero aleatorio: $randNum",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromARGB(255, 100, 0, 100),
        )
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _update,
      child:Icon(Icons.question_mark),
      ),
      );
  }
}

