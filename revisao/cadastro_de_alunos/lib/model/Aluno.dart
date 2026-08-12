import 'package:sqflite/utils/utils.dart';

class Aluno {
  final int? id;
  final String? nome;
  final int? idade;

  Aluno({this.id, required this.nome, required this.idade});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'columnId' : id,
      'columnNome': nome,
      'columnIdade': idade
    };
    return map;
  }
  
  factory Aluno.fromMap(Map<String, dynamic> map){
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade']
    );
  }

}