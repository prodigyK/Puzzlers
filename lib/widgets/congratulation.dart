import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/providers/update_puzzles_provider.dart';
import 'package:puzzlers/widgets/custom_button.dart';
import 'package:puzzlers/widgets/custom_text.dart';

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
    'coef': 0.41,
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

final String bodyImage = 'assets/textures/wood_02.jpg';

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
    Provider.of<UpdatePuzzlesProvider>(context);
    return AnimatedOpacity(
      duration: Duration(milliseconds: duration),
      opacity: widget.isVisible ? 1.0 : 0.0,
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
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
                          Container(
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.brown.shade400.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                            ),
                            child: Center(
                              child: CustomText(
                                title: 'Congratulations',
                                fontSize: 25,
                                fontFamily: 'Candal',
                                fontWeight: FontWeight.bold,
                                color: ColorConsts.textColor,
                                blurRadius: 2.0,
                                shadowOffset1: 0.5,
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
                                ? CustomText(
                                    title: 'Your current result is the best one!',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  )
                                : CustomText(
                                    title: 'Do as few moves as possible!',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
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
                          CustomButton(
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
                          CustomButton(
                            title: 'Go to Menu',
                            textColor: Colors.red.shade100,
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

  DataTable _buildDataTable() {
    return DataTable(
      horizontalMargin: 16.0,
      dividerThickness: 2,
      columnSpacing: 30,
      showBottomBorder: false,
      columns: [
        DataColumn(
          label: CustomText(
            title: 'Scores',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DataColumn(
          label: CustomText(
            title: 'Taps',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DataColumn(
          label: CustomText(
            title: 'Time',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
      rows: [
        DataRow(cells: [
          DataCell(CustomText(title: 'Current', fontSize: 16)),
          DataCell(
            CustomText(
              title: '${widget.currentScore["taps"]}',
              fontSize: 24,
              color: widget.isBetter ? Colors.green.shade700 : Colors.indigo,
            ),
          ),
          DataCell(
            CustomText(
              title: '${widget.currentScore["time"]}',
              fontSize: 20,
              color: widget.isBetter ? Colors.green.shade700 : Colors.indigo,
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(CustomText(title: 'Best', fontSize: 16)),
          DataCell(
            CustomText(
              title: '${widget.bestScore["taps"]}',
              fontSize: 24,
            ),
          ),
          DataCell(
            CustomText(
              title: '${widget.bestScore["time"]}',
              fontSize: 20,
            ),
          ),
        ]),
      ],
    );
  }
}
