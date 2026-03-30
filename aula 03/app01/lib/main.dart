import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PaginaContador(),
  )
  );
}

class PaginaContador extends StatefulWidget{
  const PaginaContador({super.key});

  @override
    PaginaContadorState createState() => PaginaContadorState();
}


class PaginaContadorState extends State<PaginaContador>{
  int count = 0; 

  void increment(){
    setState(
      (){
        count++;
      }
    );

  } 

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("App Interativo"),
      ),
      body: Center(
        child: Text("Cliques: $count",
        style: TextStyle(fontSize: 109,
         fontWeight: FontWeight.w900,
         fontStyle: FontStyle.italic,
         color: Colors.deepPurpleAccent
         )),
      ),
      floatingActionButton: FloatingActionButton(onPressed: increment,
      child: Icon(Icons.add),
      
      ),
    );

  }
}


