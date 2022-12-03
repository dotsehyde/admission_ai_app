import 'package:countup/countup.dart';
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
  Map<String, dynamic> result = {};
  final _dio = Dio();
  final _formKey = GlobalKey<FormState>();

  Future<void> getPrediction() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var data = FormData.fromMap({
        'gre': _greScore,
        'toefl': _toeflScore,
        'cgpa': _cgpa,
        'research': _research,
      });
      var res = await _dio.post<Map<String, dynamic>>(
        "http://10.0.2.2:5000/",
        data: data,
      );
      if (res.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        print(res.data);
        result = res.data!;
      }
    } on DioError catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text("Error"),
              content: Text(e.message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admission AI"),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
            : result.isNotEmpty
                ?
                //Result Page
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Countup(
                        begin: 0,
                        end: result["coa"] * 100,
                        duration: const Duration(seconds: 2),
                        separator: ',',
                        textAlign: TextAlign.center,
                        suffix: "%",
                        style: TextStyle(
                            fontSize: mq.width * 0.4,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        result["text"].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: mq.width * 0.15),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextButton.icon(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: Size(mq.width, 50)),
                            onPressed: () {
                              setState(() {
                                result.clear();
                              });
                            },
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              size: 35,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Go Back",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                      )
                    ],
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: mq.height * 0.05,
                        ),
                        Image.asset(
                          "./gif/ai.gif",
                          height: mq.height * 0.2,
                          // width: mq.width * 0.5,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        const Text(
                          "Predict your chance of getting into a university",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22),
                        ),
                        textBox(
                            text: "GRE Score",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a valid value";
                              } else if (double.parse(value) > 340) {
                                return "Score cannot be greater than 340";
                              }
                              return null;
                            },
                            changed: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _greScore = double.parse(value);
                                });
                              }
                            }),
                        textBox(
                            text: "TOEFL Score",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a valid value";
                              } else if (double.parse(value) > 120) {
                                return "Score cannot be greater than 120";
                              }
                              return null;
                            },
                            changed: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _toeflScore = double.parse(value);
                                });
                              }
                            }),
                        textBox(
                            text: "CGPA",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a valid value";
                              } else if (double.parse(value) > 10) {
                                return "Score cannot be greater than 10";
                              }
                              return null;
                            },
                            changed: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _cgpa = double.parse(value);
                                });
                              }
                            }),
                        const Text(
                          "Research Experience",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: mq.width * 0.45,
                              child: radioBtn(
                                text: "Yes",
                                value: 1,
                              ),
                            ),
                            SizedBox(
                              width: mq.width * 0.45,
                              child: radioBtn(
                                text: "No",
                                value: 0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextButton.icon(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: Size(mq.width, 50)),
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                getPrediction();
                              },
                              icon: const Icon(
                                Icons.rocket_launch_rounded,
                                size: 22,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Predict",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget radioBtn({
    required String text,
    required double value,
  }) {
    return RadioListTile<double>(
        value: value,
        title: Text(text),
        groupValue: _research,
        toggleable: true,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _research = value;
            });
          }
        });
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
  required String? Function(String?)? validator,
}) {
  return Container(
    margin: const EdgeInsets.all(10),
    child: TextFormField(
      validator: validator,
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
