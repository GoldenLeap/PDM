import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AppCadastro(),
  ));
}

class AppCadastro extends StatefulWidget {
  const AppCadastro({super.key});

  @override
  AppCadastroState createState() => AppCadastroState();
}

class AppCadastroState extends State<AppCadastro>{
  late AudioPlayer player = AudioPlayer();
  List<Map<String, dynamic>> dados= [];
  TextEditingController tituloController = TextEditingController();
  TextEditingController descController = TextEditingController();

  Future<Database> criarBanco() async{
    final caminho = await getDatabasesPath();
    final path = join(caminho, 'banco.db');

    return openDatabase(path, 
    onCreate: (db, version){
      db.execute(
        '''
          CREATE TABLE dados(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descricao TEXT
          )
        '''
      );

    },
    version: 1,
    );
  }
  Future<void> inserirDados(String titulo, String descricao) async{
    final db = await criarBanco();
    await db.insert("dados", 
      {
        "titulo": titulo,
        "descricao": descricao
      }
    );
    carregarDados();
  }

  Future<void> carregarDados() async{
    final db = await criarBanco();
    final lista = await db.query('dados');
    setState((){
      dados = lista;
    });

  }

  Future<void> deletarDado(int id) async{
    final db = await criarBanco();
    await db.delete(
      'dados',
      where: 'id = ?',
      whereArgs: [id],
    );

    carregarDados();
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    carregarDados();
  }

  @override Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('App de Cadastro')
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: tituloController,
              decoration: InputDecoration(
                labelText: "Titulo",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder()
              ),
            ),
          ),
          ElevatedButton(onPressed:  (){
            if(descController.text.isNotEmpty && tituloController.text.isNotEmpty){
              inserirDados(tituloController.text, descController.text);
              tituloController.clear();
              descController.clear();
              player.play(AssetSource('nuossa.mp3'));
            }

          }, 
          child: 
            Text('Cadastrar')
          ),
          Expanded(child: ListView.builder(
            itemCount: dados.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(dados[index]['titulo']),
                subtitle: Text(dados[index]['descricao']),
                trailing: IconButton(onPressed: (){
                  deletarDado(dados[index]['id']);

                }, 
                icon: Icon(Icons.delete),
                ),
              );
            },
          ),
          )
        ],
      )
    );
  }

}
