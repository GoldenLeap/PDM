import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Referencia para a coleção alunos
  final CollectionReference _alunosRef =
    FirebaseFirestore.instance.collection('alunos');

  // Adicionar alunos
  Future<void> adicionarAluno({
    required String nome,
    required int idade,
    required String curso,
  }) async {
    await _alunosRef.add({
      'nome' : nome,
      'idade' : idade,
      'curso' : curso,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }


  Stream<QuerySnapshot> listarAlunos(){
    return _alunosRef.orderBy('criadoEm', descending: true).snapshots();
  }
  
  Future<void> atualizarAluno({
    required String id,
    required String nome,
    required int idade,
    required String curso
  } ) async{
    await _alunosRef.doc(id).update({
      'nome':nome,
      'idade':idade,
      'curso':curso
    });
  }

  Future<void> deletarAluno(String id) async{
    await _alunosRef.doc(id).delete();
  }

  }