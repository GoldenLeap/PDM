class Matricula {
  final int? id;
  final int alunoId;
  final int cursoId;

  Matricula({this.id, required this.alunoId, required this.cursoId});

  factory Matricula.fromMap(Map<String, dynamic> map) {
    return Matricula(
      id: map['id'],
      alunoId: map['aluno_id'],
      cursoId: map['curso_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aluno_id': alunoId,
      'curso_id': cursoId,
    };
  }
}