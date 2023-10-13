import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Slider Chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 시간 (가로) , 온도 (세로)
  double myTime = 0;
  double myTemp = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'slider chart test',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  debugPrint('다이얼로그 갱신 확인 ');
                  // 프로그램 설정
                  return SizedBox(
                    height: 300,
                    child: AlertDialog(
                      contentPadding: const EdgeInsets.all(0),
                      insetPadding: EdgeInsets.zero,
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: null,
                              icon: Icon(Icons.arrow_left_outlined)),
                          Text('Period'),
                          IconButton(
                              onPressed: null,
                              icon: Icon(Icons.arrow_right_outlined)),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Text('Temp:${myTemp.toStringAsFixed(0)}'),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text('time:${myTime.toStringAsFixed(0)}'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 250,
                            child: Row(
                              children: [
                                //온도 슬라이더
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                        thumbShape: const SliderThumbShape(),
                                        trackHeight: 15,
                                        activeTrackColor: myTemp <= 30
                                            ? const Color.fromARGB(
                                                94, 68, 137, 255)
                                            : const Color.fromARGB(
                                                105, 255, 82, 82),
                                        thumbColor: myTemp <= 30
                                            ? Colors.blueAccent
                                            : Colors.redAccent,
                                        overlayColor: Colors.transparent),
                                    child: Slider(
                                        value: myTemp,
                                        min: 10,
                                        max: 40,
                                        divisions: 30,
                                        onChanged: (vlaue) {
                                          setState(() {
                                            myTemp = vlaue;
                                            print(myTemp);
                                          });
                                        }),
                                  ),
                                ),
                                Stack(children: [
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            // height: 80,
                                            width: 150,
                                            decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color.fromARGB(
                                                    197, 244, 67, 54),
                                                Color.fromARGB(
                                                    125, 255, 255, 255),
                                                Color.fromARGB(
                                                    190, 33, 149, 243),
                                              ],
                                            )),
                                            child: CustomPaint(
                                              size: const Size(
                                                  200, 250), // 그래픽의 크기 조정
                                              painter:
                                                  ChartPainter(myTime, myTemp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: SliderTheme(
                                      data: const SliderThemeData(
                                          trackHeight: 1,
                                          thumbShape: SliderThumbShape(),
                                          thumbColor:
                                              Color.fromARGB(255, 0, 0, 0),
                                          overlayColor: Colors.transparent),
                                      child: Slider(
                                          //시간 슬라이더
                                          value: myTime,
                                          min: 0,
                                          max: 10,
                                          divisions: 10,
                                          onChanged: (vlaue) {
                                            setState(() {
                                              myTime = vlaue;
                                            });
                                          }),
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: const [
                        // ok 버튼을 누르면 나가도록
                      ],
                    ),
                  );
                },
              );
            },
          ).then((value) {
            setState(() {});
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.bar_chart_sharp),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SliderThumbShape extends SliderComponentShape {
  const SliderThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(16.0, 16.0); // 마름모 모양의 크기를
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double>? activationAnimation,
      Animation<double>? enableAnimation,
      bool? isDiscrete,
      TextPainter? labelPainter,
      RenderBox? parentBox,
      SliderThemeData? sliderTheme,
      TextDirection? textDirection,
      double? value,
      double? textScaleFactor,
      Size? sizeWithOverflow}) {
    final canvas = context.canvas;

    const radius = 8.0; // 마름모의 반지름
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius, center.dy)
      ..close();

    final paint = Paint()
      ..color = sliderTheme!.thumbColor!
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }
}

class ChartPainter extends CustomPainter {
  final double myTime;
  final double myTemp;

  ChartPainter(this.myTime, this.myTemp);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    //  시간 선 (높이) 온도에 따라 timeY 높낮이 계산
    final timeY = size.height * (1 - (myTemp - 5) / 40); // 1을 빼줌으로써 뒤집어짐
    // 시간 선 (가로선)
    final timeStartX = size.width * myTime / 10; // 왼쪽에서 오른쪽으로 길어지도록 계산

    // final verticalLineLength =
    //     (size.height - timeY) * (myTemp / 40); // 온도에 비례한 세로선의 길이 계산

    canvas.drawLine(
      Offset(0, timeY), // 왼쪽에서 시작하도록 수정
      Offset(timeStartX, timeY),
      paint,
    );
    canvas.drawLine(
      Offset(timeStartX, timeY), // 수평선과 수직선이 만나는 지점에서 시작
      Offset(timeStartX, size.height / 2), // 아래로 수직선을 그림
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
