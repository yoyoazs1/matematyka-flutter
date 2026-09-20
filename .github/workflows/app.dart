import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MathApp());
}

class MathApp extends StatelessWidget {
  const MathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trening matematyczny',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MathPage(),
    );
  }
}

class MathPage extends StatefulWidget {
  const MathPage({super.key});

  @override
  State<MathPage> createState() => _MathPageState();
}

class _MathPageState extends State<MathPage> {
  final Random random = Random();
  final TextEditingController controller = TextEditingController();

  String operation = '+';

  int a = 0;
  int b = 0;
  int correctAnswer = 0;

  int correct = 0;
  int wrong = 0;
  int dontKnow = 0;

  String message = '';

  final List<String> history = [];

  @override
  void initState() {
    super.initState();
    generateTask();
  }

  int randomTwoOrThreeDigit() {
    if (random.nextBool()) {
      return random.nextInt(90) + 10;
    }

    return random.nextInt(900) + 100;
  }

  void generateTask() {
    controller.clear();
    message = '';

    if (operation == '+') {
      a = randomTwoOrThreeDigit();
      b = randomTwoOrThreeDigit();
      correctAnswer = a + b;
    } else if (operation == '-') {
      a = randomTwoOrThreeDigit();
      b = randomTwoOrThreeDigit();

      if (b > a) {
        final int temp = a;
        a = b;
        b = temp;
      }

      correctAnswer = a - b;
    } else if (operation == '×') {
      a = random.nextInt(90) + 10;
      b = random.nextInt(90) + 10;
      correctAnswer = a * b;
    } else if (operation == '÷') {
      do {
        b = random.nextInt(90) + 10;
        correctAnswer = random.nextInt(8) + 2;
        a = b * correctAnswer;
      } while (a > 99);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void changeOperation(String newOperation) {
    operation = newOperation;
    generateTask();
  }

  void checkAnswer() {
    final int? entered = int.tryParse(controller.text.trim());

    if (entered == null) {
      setState(() {
        message = 'Wpisz odpowiedź';
      });
      return;
    }

    if (entered == correctAnswer) {
      setState(() {
        correct++;
        message = '✓ Dobrze!';
        history.add(
          '$a $operation $b = $correctAnswer ✓',
        );
      });

      Future.delayed(
        const Duration(milliseconds: 700),
        () {
          if (mounted) {
            generateTask();
          }
        },
      );
    } else {
      setState(() {
        wrong++;
        message = '✗ Błędna odpowiedź';
        history.add(
          '$a $operation $b = $correctAnswer, wpisano: $entered ✗',
        );
      });
    }
  }

  void showAnswer() {
    setState(() {
      dontKnow++;
      history.add(
        '$a $operation $b = $correctAnswer — Nie wiem',
      );
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prawidłowy wynik'),
          content: Text(
            '$a $operation $b = $correctAnswer',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                generateTask();
              },
              child: const Text('Dalej'),
            ),
          ],
        );
      },
    );
  }

  void showHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Historia'),
          content: SizedBox(
            width: double.maxFinite,
            child: history.isEmpty
                ? const Text('Brak historii')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Text(
                          history[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zamknij'),
            ),
          ],
        );
      },
    );
  }

  void finish() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wyniki'),
          content: Text(
            'Poprawne: $correct\n'
            'Błędne: $wrong\n'
            'Nie wiem: $dontKnow',
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Wróć'),
            ),
          ],
        );
      },
    );
  }

  Widget operationButton(
    String text,
    String symbol,
  ) {
    final bool selected = operation == symbol;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: selected
            ? FilledButton(
                onPressed: () {
                  changeOperation(symbol);
                },
                child: Text(text),
              )
            : FilledButton.tonal(
                onPressed: () {
                  changeOperation(symbol);
                },
                child: Text(text),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title
