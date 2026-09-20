import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MathPage(),
      );
}

class MathPage extends StatefulWidget {
  const MathPage({super.key});

  @override
  State<MathPage> createState() => _MathPageState();
}

class _MathPageState extends State<MathPage> {
  final r = Random();
  final input = TextEditingController();
  final history = <String>[];

  String op = '+', msg = '';
  int a = 0, b = 0, result = 0;
  int good = 0, bad = 0, skip = 0;

  @override
  void initState() {
    super.initState();
    next();
  }

  int number() => r.nextBool()
      ? r.nextInt(90) + 10
      : r.nextInt(900) + 100;

  void next() {
    input.clear();
    msg = '';

    if (op == '×') {
      a = r.nextInt(90) + 10;
      b = r.nextInt(90) + 10;
      result = a * b;
    } else if (op == '÷') {
      result = r.nextInt(8) + 2;
      b = r.nextInt(40) + 10;
      a = b * result;
      while (a > 99) {
        result = r.nextInt(8) + 2;
        b = r.nextInt(40) + 10;
        a = b * result;
      }
    } else {
      a = number();
      b = number();

      if (op == '-' && b > a) {
        final x = a;
        a = b;
        b = x;
      }

      result = op == '+' ? a + b : a - b;
    }

    if (mounted) setState(() {});
  }

  void change(String value) {
    op = value;
    next();
  }

  void check() {
    final n = int.tryParse(input.text);

    if (n == null) {
      setState(() => msg = 'Wpisz liczbę');
      return;
    }

    if (n == result) {
      good++;
      history.add('$a $op $b = $result ✓');
      setState(() => msg = '✓ Dobrze!');
      Future.delayed(
        const Duration(milliseconds: 600),
        () {
          if (mounted) next();
        },
      );
    } else {
      bad++;
      history.add('$a $op $b = $result, wpisano $n ✗');
      setState(() => msg = '✗ Błędna odpowiedź');
    }
  }

  void dontKnow() {
    skip++;
    history.add('$a $op $b = $result — Nie wiem');
    setState(() {});

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Prawidłowy wynik'),
        content: Text(
          '$a $op $b = $result',
          style: const TextStyle(fontSize: 26),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              next();
            },
            child: const Text('Dalej'),
          ),
        ],
      ),
    );
  }

  void showHistory() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Historia'),
        content: SizedBox(
          width: 400,
          child: history.isEmpty
              ? const Text('Brak historii')
              : ListView(
                  shrinkWrap: true,
                  children: history
                      .map((x) => Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(x),
                          ))
                      .toList(),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Zamknij'),
          ),
        ],
      ),
    );
  }

  void finish() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Wyniki'),
        content: Text(
          'Poprawne: $good\n'
          'Błędne: $bad\n'
          'Nie wiem: $skip',
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Wróć'),
          ),
        ],
      ),
    );
  }

  Widget button(String text, String symbol) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: FilledButton.tonal(
            onPressed: () => change(symbol),
            child: Text(text),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Trening matematyczny'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              button('Dodawanie', '+'),
              button('Odejmowanie', '-'),
            ]),
            Row(children: [
              button('Mnożenie', '×'),
              button('Dzielenie', '÷'),
            ]),
            const SizedBox(height: 35),
            Text(
              '$a $op $b = ?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: input,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Wpisz wynik',
              ),
              onSubmitted: (_) => check(),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 55,
              child: FilledButton(
                onPressed: check,
                child: const Text(
                  'SPRAWDŹ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: dontKnow,
                  child: const Text('Nie wiem'),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: showHistory,
                  child: const Text('Historia'),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: finish,
                  child: const Text('Zakończ'),
                ),
              ),
            ]),
            const SizedBox(height: 25),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '✓ $good Poprawne     ✗ $bad Błędne     ? $skip Nie wiem',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }
}
