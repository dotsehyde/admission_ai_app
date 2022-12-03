import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(useMaterial3: true),
      title: 'Admission AI',
      theme: ThemeData.light(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _greScore = 0;
  double _toeflScore = 0;
  double _cgpa = 0;
  double _research = 0;
  bool _isLoading = false;
  final _dio = Dio();

  Future<void> getPrediction() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var data = FormData.fromMap({
        'gre_score': _greScore,
        'toefl_score': _toeflScore,
        'cgpa': _cgpa,
        'research': _research,
      });
      var res = await _dio.post(
        "http://127.0.0.1:5000/",
      );
      if (res.statusCode == 200) {
        print(res.data);
      }
    } on DioError catch (e) {
      // setState(() {
      //   _isLoading = false;
      // });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admission AI"),
      ),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10),
                    child: Image.asset(
                      getLoading,
                      height: mq.height * 0.5,
                      // width: mq.width * 0.5,
                    ),
                  ),
                  const Text(
                    "Getting prediction\nPlease wait...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Predict your chance of getting into a university",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  textBox(
                      text: "GRE Score",
                      changed: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _greScore = double.parse(value);
                          });
                        }
                      }),
                  textBox(
                      text: "TOEFL Score",
                      changed: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _toeflScore = double.parse(value);
                          });
                        }
                      }),
                  textBox(
                      text: "CGPA",
                      changed: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _cgpa = double.parse(value);
                          });
                        }
                      }),
                  textBox(
                      text: "Research",
                      changed: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _research = double.parse(value);
                          });
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(mq.width, 50)),
                        onPressed: () {
                          getPrediction();
                        },
                        icon: const Icon(
                          Icons.rocket_launch_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Predict",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  )
                ],
              ),
      ),
    );
  }
}

String get getLoading {
  final List<String> gifs = [
    "./gif/1.gif",
    "./gif/2.gif",
    "./gif/4.gif",
    "./gif/5.gif",
  ];
  gifs.shuffle();
  return gifs[0];
}

Widget textBox({
  required String text,
  required Function(String) changed,
}) {
  return Container(
    margin: const EdgeInsets.all(10),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter a valid value";
        }
        return null;
      },
      onChanged: changed,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 18,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: text,
      ),
    ),
  );
}
