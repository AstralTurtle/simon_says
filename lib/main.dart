import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum SimonGesture {
  swipeUp,
  swipeDown,
  swipeLeft,
  swipeRight,
  doubleTap,
  tap,
  longPress,
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int highScore = 0;
  String simonGestureText = "";
  SimonGesture instruction = SimonGesture.swipeUp;

  SimonGesture? input;
  Random random = Random();

  IconData icon = Icons.error;

  static AudioPlayer player = AudioPlayer();
  final String dingPath = "ding.mp3";
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void resetStreak() {
    if (_counter > highScore) {
      highScore = _counter;
    }
    setState(() {
      _counter = 0;
      highScore = highScore;
    });
  }

  void getText(SimonGesture g) {
    if (g == SimonGesture.doubleTap) {
      simonGestureText = "Double Tap";
    } else if (g == SimonGesture.longPress) {
      simonGestureText = "Long Press";
    } else if (g == SimonGesture.tap) {
      simonGestureText = "Tap";
    }
    // } else if (g == SimonGesture.Spin) {
    //   simonGestureText = "Spin";
    // }
    else if (g == SimonGesture.swipeUp) {
      simonGestureText = "Swipe Up";
    } else if (g == SimonGesture.swipeDown) {
      simonGestureText = "Swipe Down";
    } else if (g == SimonGesture.swipeLeft) {
      simonGestureText = "Swipe Left";
    } else if (g == SimonGesture.swipeRight) {
      simonGestureText = "Swipe Right";
    }
    print(simonGestureText);

    setState(() {
      simonGestureText = simonGestureText;
    });
  }

  void genGesture() {
    instruction =
        SimonGesture.values[random.nextInt(SimonGesture.values.length)];
    getText(instruction);
    icon = getIcon();
  }

  @override
  void initState() {
    genGesture();

    super.initState();
  }

  playSound() async {
    await player.play(AssetSource(dingPath));
  }

  void simonSays(SimonGesture g) {
    print("simonSay");
    if (g == instruction) {
      _incrementCounter();
      genGesture();
      playSound();
    } else {
      resetStreak();
      genGesture();
    }
  }

  IconData getIcon() {
    if (instruction == SimonGesture.doubleTap) {
      return FontAwesomeIcons.handPointUp;
    } else if (instruction == SimonGesture.longPress) {
      return Icons.touch_app_rounded;
    } else if (instruction == SimonGesture.tap) {
      return Icons.touch_app_outlined;
    } else if (instruction == SimonGesture.swipeUp) {
      return Icons.arrow_circle_up_rounded;
    } else if (instruction == SimonGesture.swipeDown) {
      return Icons.arrow_circle_down_rounded;
    } else if (instruction == SimonGesture.swipeLeft) {
      return Icons.arrow_circle_left_rounded;
    } else if (instruction == SimonGesture.swipeRight) {
      return Icons.arrow_circle_right_rounded;
    } else {
      return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text("Simon Says: " + simonGestureText,
              style: const TextStyle(
                color: Colors.white,
              )),
        ),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTap: () {
                simonSays(SimonGesture.doubleTap);
              },
              onLongPress: () {
                simonSays(SimonGesture.longPress);
              },
              onTap: () {
                simonSays(SimonGesture.tap);
              },
              onHorizontalDragEnd: (details) {
                int sens = 1;
                if (details.velocity.pixelsPerSecond.dx > sens) {
                  simonSays(SimonGesture.swipeRight);
                } else if (details.velocity.pixelsPerSecond.dx < -sens) {
                  simonSays(SimonGesture.swipeLeft);
                }
              },
              onVerticalDragEnd: (details) {
                int sens = 1;
                if (details.velocity.pixelsPerSecond.dy > sens) {
                  simonSays(SimonGesture.swipeDown);
                } else if (details.velocity.pixelsPerSecond.dy < -sens) {
                  simonSays(SimonGesture.swipeUp);
                }
              },
              // detect one full rotation of the finger using onPanUpdate
              // onPanUpdate: (details) {
              //   double angle = details.delta.direction;
              //   if (angle > 0.5 && angle < 2.5) {
              //     simonSays(SimonGesture.Spin);
              //   }
              // }
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(icon, size: 200, color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Streak:',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  )),
                              Text('$_counter',
                                  style: const TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('High Score:',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  )),
                              Text('$highScore',
                                  style: const TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ],
                      )
                    ]),
              ))),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
