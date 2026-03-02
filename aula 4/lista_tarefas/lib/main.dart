
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoPage()
      );
  }
}

class TodoPage extends StatefulWidget{
  const TodoPage({super.key});
  
  @override
    State<TodoPage> createState() => _TodoPageState();
  
}

class _TodoPageState extends State<TodoPage>{
  final List<String> listaTarefas = [];
  final TextEditingController _controller = TextEditingController();

  void adicionarTarefa(){
    setState((){
      if(_controller.text.trim().isEmpty){
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Erro'),
              content: const  Text('O nome da tarefa não pode ser vazio'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
          );
        _controller.clear();
      }else{
        listaTarefas.add(_controller.text);
      }
    });
    _controller.clear();
    print(listaTarefas);
  }

  void removerTarefa(int index){
    setState(() {
      listaTarefas.removeAt(index);
    },);

  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Tarefas", 
          style: TextStyle(
            fontFamily: 'Letters',
            fontWeight: FontWeight.bold
            ),
          ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 150),
            child: Text("Quantidade tarefas: ${listaTarefas.length.toString()}",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold
              
            ),
            
            ),
          ),
          
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            onSubmitted:(value) => adicionarTarefa(),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Tarefa a ser adicionada...",
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontFamily: 'Letters',
            fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: adicionarTarefa, 
            child: const Text('Adicionar Tarefa'),),
          Expanded(
            child: ListView.builder(
              itemCount: listaTarefas.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(
                    listaTarefas[index],
                    style: TextStyle(
                      fontFamily: 'Letters',
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: ()=>removerTarefa(index),
                    ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
