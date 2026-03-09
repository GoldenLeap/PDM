import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InterruptorApp(),
  ));
}

class InterruptorApp extends StatefulWidget {
  const InterruptorApp({super.key});
  
  @override
  State<InterruptorApp> createState() => _InterruptorAppState();
}


class _InterruptorAppState extends State<InterruptorApp>{
  bool aceso = false;

  void alternarLuz(){
  setState((){
    aceso = !aceso;
  }); 

}
@override
Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: aceso? Color.fromARGB(255, 132, 0, 255) : Colors.black,
    appBar: AppBar(
      backgroundColor: aceso? Colors.white: Colors.black,
      
      title: Center(
        child: Text('Interruptor',
        style: TextStyle(color: aceso? Colors.black: Colors.white
        ),
       ),
      ),
    actions: [
       Icon(
        aceso? Icons.lightbulb : Icons.lightbulb_outline,
        size: 10,
        color: aceso? Color.fromARGB(255, 198, 194, 202) : const Color.fromARGB(255, 73, 72, 72),
      ),
      ElevatedButton(
        onPressed: alternarLuz,
        style: ElevatedButton.styleFrom(
          backgroundColor: aceso ?  Color.fromARGB(255, 149, 139, 158): Colors.black,
          textStyle: TextStyle(color: aceso? Colors.black:  Colors.white),
        ),
        child: Text('Interruptor'),
      ),
      ],
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: alternarLuz,
            child: Icon(
              aceso ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 150,
              color: aceso ? Colors.yellow : Colors.grey,
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: alternarLuz,
            style: ElevatedButton.styleFrom(
              backgroundColor: aceso ? Color.fromARGB(255, 132, 0, 255) : Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: Text(
              aceso ? 'Desligar' : 'Ligar',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    )
  );

}


}