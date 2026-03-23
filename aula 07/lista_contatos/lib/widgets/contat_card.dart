import 'dart:ui';

import 'package:flutter/material.dart';

class ContatCard extends StatelessWidget {
  final String nome;
  final String imgPath;
  final String number;
  final VoidCallback callFunc;
  final GestureTapCallback onPressed;
  const ContatCard({
    super.key,
    required this.nome,
    required this.imgPath,
    required this.number,
    required this.onPressed,
    required this.callFunc,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
      color: Colors.white,
      elevation: 4, 
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [

            ClipOval(
              child: Image.asset(
                imgPath,
                height: 50, 
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(
                    nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    number,
                    style: const TextStyle(
                      color: Color(0xFFcf2f2f),
                    ),
                  ),
                ],
              ),
            ),
            
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: callFunc,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "LIGAR",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}