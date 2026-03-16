import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TemperaturaApp()
  ));
}

class TemperaturaApp extends StatefulWidget {
  const TemperaturaApp({super.key});

  @override
  _TemperaturaAppState createState() => _TemperaturaAppState();
}

class _TemperaturaAppState extends State<TemperaturaApp>{
  int temp = 20;

  void aumentar(){
    setState(() {
      temp++;
    });
    
  }
  void diminuir(){
    setState((){
      if(temp > -273){
        temp--;
      }

      });
  }

  @override
  Widget build(BuildContext context){
    Color corFundo;
    IconData icon;
    String status;
    if(temp < 14){
      corFundo = Colors.lightBlueAccent;
      icon = Icons.ac_unit;
      status = "Frio";
    }else if(temp < 25){
      corFundo = Color(0xFFFBF090);
      icon = Icons.wb_sunny;
      status = "Agradavel";
    }else{
      corFundo = Color(0xFFB22222);
      icon = Icons.local_fire_department;
      status= "Quente";
    }
    return Scaffold(
      backgroundColor: corFundo,
      
      appBar: AppBar(
        title: Text("Controle de Temperatura"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$temp ºC",
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               HoldDetector(onHold: diminuir, 
               child: ElevatedButton(
                  onPressed: diminuir,
                  child: Text('-'),
                )
              ),
              SizedBox(width: 20),
               HoldDetector(onHold: aumentar, 
               child: ElevatedButton(
                  onPressed: aumentar,
                  child: Text('+'),
                )
              ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 80),
                Text(status, style: TextStyle(fontSize: 30),)
              ],
            )
          ],
        ),
      ),
    );
  }

}
