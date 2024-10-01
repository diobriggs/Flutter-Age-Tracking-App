import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }

  String get milestoneMessage {
    if (value <= 12) {
      return "👶 You're a child!";
    } else if (value <= 19) {
      return "🎉 Teenager time!";
    } else if (value <= 30) {
      return "💼 You're a young adult!";
    } else if (value <= 50) {
      return "👨‍💼 You're an adult now!";
    } else {
      return "👴 Golden years!";
    }
  }

  Color get backgroundColor {
    if (value <= 12) {
      return Colors.lightBlue;
    } else if (value <= 19) {
      return Colors.lightGreen;
    } else if (value <= 30) {
      return Colors.yellow;
    } else if (value <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Age Counter'),
          ),
          body: Container(
            color: counter.backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your age is:'),
                  Text(
                    '${counter.value}', 
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  // Display the milestone message
                  Text(
                    counter.milestoneMessage,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 40), 

                  // Buttons for increment and decrement
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          var counter = context.read<Counter>();
                          counter.increment();
                        },
                        icon: const Icon(Icons.arrow_upward),
                        label: const Text('Increment'),
                      ),
                      const SizedBox(height: 20), 
                      ElevatedButton.icon(
                        onPressed: () {
                          var counter = context.read<Counter>();
                          counter.decrement();
                        },
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text('Decrement'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
