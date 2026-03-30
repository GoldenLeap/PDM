import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SalvarTextoApp(),
    );
  }
}


class SalvarTextoApp extends StatefulWidget{

  const SalvarTextoApp({super.key});

  @override 
  SalvarTextoState createState() => SalvarTextoState();
}

class SalvarTextoState extends State<SalvarTextoApp>{
  TextEditingController controller = TextEditingController();
  String textoSalvo = "";

  void salvarTexto() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("texto", controller.text);
    setState((){
      textoSalvo = controller.text;
    });
  }

  void loadTexto() async {
    final prefs = await SharedPreferences.getInstance();

    setState((){
      textoSalvo =  prefs.getString('texto') ?? '';
    });
  }

  @override 
  void initState(){
    super.initState();
    loadTexto();
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Salvar Dados"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Digite algo'),
            ),
            SizedBox(height: 20,),
            
            ElevatedButton(
              onPressed: salvarTexto,
              child: Text("Salvar"),
            ),

            SizedBox(height: 20,),

            Text(
              "Salvo: $textoSalvo",
              style: TextStyle(fontSize: 69),
            ),
          ],
        )
      ),
    );

  }

}
