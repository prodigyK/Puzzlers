import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/providers/update_puzzles.dart';

typedef MyFuncAction = void Function();
enum Device {
  ProMax,
  Pro,
  Mini,
  SE2nd,
  Plus8,
}

const Map<Device, Map<String, double>> devicesHeight = const {
  Device.ProMax: {
    'height': 896,
    'coef': 0.43,
  },
  Device.Pro: {
    'height': 844,
    'coef': 0.45,
  },
  Device.Mini: {
    'height': 812,
    'coef': 0.46,
  },
  Device.Plus8: {
    'height': 736,
    'coef': 0.50,
  },
  Device.SE2nd: {
    'height': 667,
    'coef': 0.53,
  },
};

class Congratulations extends StatefulWidget {
  bool isVisible = false;
  final Function closeDialog;
  final Function goToMenu;
  final Map<String, String> currentScore;
  final Map<String, String> bestScore;
  bool isBetter;

  Congratulations({
    required this.closeDialog,
    required this.goToMenu,
    required this.currentScore,
    required this.bestScore,
    this.isBetter = false,
  });

  @override
  _CongratulationsState createState() => _CongratulationsState();
}

class _CongratulationsState extends State<Congratulations> {
  final String buttonImage = 'assets/textures/wood_09.jpg';
  final String bodyImage = 'assets/textures/wood_02.jpg';
  final int duration = 200;

  Device _checkDevice(double height) {
    if (height >= devicesHeight[Device.ProMax]!['height']!) {
      return Device.ProMax;
    } else if (height >= devicesHeight[Device.Pro]!['height']!) {
      return Device.Pro;
    } else if (height >= devicesHeight[Device.Mini]!['height']!) {
      return Device.Mini;
    } else if (height >= devicesHeight[Device.Plus8]!['height']!) {
      return Device.Plus8;
    } else if (height >= devicesHeight[Device.SE2nd]!['height']!) {
      return Device.SE2nd;
    } else {
      return Device.SE2nd;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Device device = _checkDevice(size.height);
    Provider.of<UpdatePuzzles>(context);
    return AnimatedOpacity(
      duration: Duration(milliseconds: duration),
      opacity: widget.isVisible ? 1.0 : 0.0,
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              // color: Colors.brown.shade300.withOpacity(0.9),
              color: Colors.black12.withOpacity(0.7),
            ),
          ),
          Positioned(
            child: Center(
              child: Container(
                width: size.width * 0.75,
                height: size.height * devicesHeight[device]!['coef']!,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 20,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Stack(children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: AssetImage(bodyImage),
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            Colors.brown,
                            BlendMode.saturation,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height: 30),
                          Container(
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.brown.shade400.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                            ),
                            child: Center(
                              child: Text(
                                'Congratulations',
                                style: GoogleFonts.candal(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConsts.boardBgColor,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 2,
                                      offset: Offset(0.5, 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(height: 10),
                          Container(
                            height: 30,
                            color: widget.isBetter
                                ? Colors.green.shade400.withOpacity(0.15)
                                : Colors.indigo.shade400.withOpacity(0.15),
                            child: widget.isBetter
                                ? _textWidget(
                                    title: 'Your current result is the best one!',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                    blurRadius: 0.0,
                                    shadowOffset1: 0.0,
                                  )
                                : _textWidget(
                                    title: 'Do as few moves as possible!',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    blurRadius: 0,
                                    shadowOffset1: 0.0,
                                    color: Colors.indigo,
                                  ),
                          ),
                          Container(
                            width: 200,
                            height: size.height * 0.19,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: _buildDataTable(),
                            ),
                          ),
                          Spacer(),
                          _button(
                            title: 'Play again',
                            onPressed: () {
                              setState(() {
                                widget.isVisible = false;
                              });
                              Future.delayed(Duration(milliseconds: duration), () {
                                widget.closeDialog();
                              });
                            },
                          ),
                          SizedBox(height: 1),
                          _button(
                            title: 'Go to Menu',
                            bottomBoarder: 25,
                            onPressed: () {
                              widget.goToMenu();
                            },
                          ),
                          SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTable() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              // width: 60,
              // height: 30,
              child: _textWidget(
                title: 'Scores',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              // width: 60,
              // height: 30,
              child: _textWidget(
                title: 'Taps',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              // width: 60,
              // height: 30,
              child: _textWidget(
                title: 'Time',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ]
    );
  }

  DataTable _buildDataTable() {
    return DataTable(
      horizontalMargin: 16.0,
      dividerThickness: 2,
      columnSpacing: 30,
      showBottomBorder: true,
      columns: [
        DataColumn(
          label: _textWidget(
            title: 'Scores',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DataColumn(
          label: _textWidget(
            title: 'Taps',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DataColumn(
          label: _textWidget(
            title: 'Time',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
      rows: [
        DataRow(cells: [
          DataCell(_textWidget(title: 'Current', fontSize: 16)),
          DataCell(
            _textWidget(
              title: '${widget.currentScore["taps"]}',
              fontSize: 24,
              color: widget.isBetter ? Colors.green.shade700 : Colors.indigo,
            ),
          ),
          DataCell(
            _textWidget(
              title: '${widget.currentScore["time"]}',
              fontSize: 20,
              color: widget.isBetter ? Colors.green.shade700 : Colors.indigo,
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(_textWidget(title: 'Best', fontSize: 16)),
          DataCell(
            _textWidget(
              title: '${widget.bestScore["taps"]}',
              fontSize: 24,
            ),
          ),
          DataCell(
            _textWidget(
              title: '${widget.bestScore["time"]}',
              fontSize: 20,
            ),
          ),
        ]),
      ],
    );
  }

  Widget _button({required String title, required MyFuncAction onPressed, double bottomBoarder = 0}) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(bottomBoarder),
                  bottomRight: Radius.circular(bottomBoarder),
                ),
                image: DecorationImage(
                  image: AssetImage(buttonImage),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat,
                  colorFilter: const ColorFilter.mode(
                    Colors.brown,
                    BlendMode.screen,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1,
                    spreadRadius: 0,
                    offset: Offset(1, 1),
                  ),
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1,
                    spreadRadius: 0,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$title',
                  style: GoogleFonts.candal(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorConsts.boardBgColor,
                    shadows: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // borderRadius: BorderRadius.all(Radius.circular(25)),
                onTap: onPressed,
                highlightColor: Colors.brown.shade300.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textWidget({
    String? title,
    double? fontSize,
    Color color = const Color(0xFF795548), //Color(0xFF5D4037),
    FontWeight? fontWeight = FontWeight.normal,
    double blurRadius = 1.0,
    double shadowOffset1 = 0.2,
  }) {
    return Center(
      child: Text(
        '$title',
        style: GoogleFonts.balooTammudu(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          shadows: [
            BoxShadow(
              color: Colors.black,
              blurRadius: blurRadius,
              offset: Offset(shadowOffset1, shadowOffset1),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
