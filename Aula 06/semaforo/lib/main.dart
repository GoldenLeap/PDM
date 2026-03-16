import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SemaforoApp(),
  ));
}

class SemaforoApp extends StatefulWidget {
  const SemaforoApp({super.key});

  @override
  SemaforoAppState createState() => SemaforoAppState();
}

class SemaforoAppState extends State<SemaforoApp> {
  int state = 0;

  static const _stateNames = ['Siga', 'Atenção', 'Pare'];
  static const _stateSubtitles = [
    'Siga com atenção e mantenha a velocidade segura.',
    'Reduza a velocidade e prepare-se para parar.',
    'Pare totalmente e aguarde a próxima luz.',
  ];

  void _mudarSemaforo() {
    setState(() {
      state = (state + 1) % 3;
    });
  }

  Color _lightColor(int index) {
    if (state == index) {
      return index == 0
          ? Colors.green
          : index == 1
              ? Colors.yellow
              : Colors.red;
    }
    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: const Text('Semáforo de Trânsito'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTrafficLight(context),
              const SizedBox(height: 24),
              _buildStatusCard(context),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _mudarSemaforo,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Avançar semáforo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficLight(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF111111), Color(0xFF1A1A1A)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLightCircle(2, Colors.red),
          const SizedBox(height: 14),
          _buildLightCircle(1, Colors.yellow),
          const SizedBox(height: 14),
          _buildLightCircle(0, Colors.green),
        ],
      ),
    );
  }

  Widget _buildLightCircle(int index, Color activeColor) {
    final isActive = state == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: isActive ? 90 : 78,
      height: isActive ? 90 : 78,
      decoration: BoxDecoration(
        color: _lightColor(index),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withAlpha(140),
                  blurRadius: 26,
                  spreadRadius: 4,
                ),
              ]
            : null,
        border: Border.all(
          color: Colors.grey.shade800,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 26),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _lightColor(state),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _lightColor(state).withAlpha(89),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _stateNames[state],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _stateSubtitles[state],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              state == 2 ? Icons.directions_walk : Icons.traffic,
              size: 32,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
