import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/models/device.dart';
import 'package:puzzlers/utils/stats_util.dart';
import 'package:puzzlers/widgets/custom_button.dart';
import 'package:puzzlers/widgets/custom_text.dart';
import 'package:puzzlers/utils/screen_util.dart';

final String bodyImage = 'assets/textures/wood_02.jpg';

class Statistics extends StatefulWidget {
  final int boardSize;
  final Device device;
  final Function closeDialog;
  final Function resetStats;

  Statistics({
    required this.boardSize,
    required this.device,
    required this.closeDialog,
    required this.resetStats,
  });

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Map<String, dynamic>? stats;
  bool firstInit = true;

  @override
  void didChangeDependencies() {
    if (firstInit) {
      getStats().then((stat) async {
        if (stat['games'] == null || stat['games'] == 0) {
          await widget.resetStats();
          await getStats().then((_) => setState(() {}));
        } else {
          setState(() {});
        }
        print('await getStats().then((_) => setState(() {}))');
      });
      firstInit = false;
    }
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>> getStats() async {
    stats = await StatsUtil.getStats(boardSize: widget.boardSize);
    return stats!;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.black12.withOpacity(0.7),
            ),
          ),
          onTap: () {
            Future.delayed(const Duration(milliseconds: 200), () {
              widget.closeDialog();
            });
          },
        ),
        Positioned(
          child: Center(
            child: Container(
              width: size.width * 0.75,
              height: size.height * ScreenUtil.devicesHeight[widget.device]!['stat']!,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
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
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              title: 'Statistics',
                              fontSize: 25,
                              fontFamily: 'Candal',
                              fontWeight: FontWeight.bold,
                              color: ColorConsts.textColor,
                              blurRadius: 2.0,
                              shadowOffset1: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            children: [
                              _rowStat(title: 'Games', value: stats?['games'].toString() ?? '0'),
                              Divider(thickness: 1.0, height: 5.0),
                              _rowStat(title: 'Min Taps', value: stats?['minTaps'].toString() ?? '0'),
                              Divider(thickness: 1.0, height: 5.0),
                              _rowStat(title: 'Max Taps', value: stats?['maxTaps'].toString() ?? '0'),
                              Divider(thickness: 1.0, height: 5.0),
                              _rowStat(title: 'Min Time', value: stats?['minTime'] ?? '0:00'),
                              Divider(thickness: 1.0, height: 5.0),
                              _rowStat(title: 'Max Time', value: stats?['maxTime'] ?? '0:00'),
                              Divider(thickness: 1.0, height: 5.0),
                            ],
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          child: TextButton(
                            child: CustomText(
                              title: 'Reset Stats',
                              fontSize: 18,
                              fontFamily: 'Candal',
                              color: Colors.red.shade700,
                              blurRadius: 1.0,
                              shadowOffset1: 0.3,
                            ),
                            onPressed: () {
                              final dialog = CupertinoAlertDialog(
                                title: CustomText(
                                  title: 'Reset Statistics',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                ),
                                content: CustomText(
                                  title: 'Are you sure you want to reset your statistics?',
                                  fontSize: 18,
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    isDefaultAction: false,
                                    onPressed: () async {
                                      await widget.resetStats();
                                      await getStats().then((_) => setState(() {}));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        color: Colors.brown.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                              showDialog(context: context, builder: (_) => dialog);
                            },
                          ),
                        ),
                        // SizedBox(height: 10),
                        CustomButton(
                          title: 'Close',
                          bottomBoarder: 25,
                          onPressed: () {
                            Future.delayed(const Duration(milliseconds: 200), () {
                              widget.closeDialog();
                            });
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
    );
  }

  Widget _rowStat({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [
        CustomText(
          title: title,
          fontSize: 18,
          fontFamily: 'Candal',
          fontWeight: FontWeight.bold,
          color: ColorConsts.boardBorderColor,
          blurRadius: 0.0,
          shadowOffset1: 0.2,
        ),
        Spacer(),
        CustomText(
          title: value,
          fontSize: 18,
          fontFamily: 'Candal',
          fontWeight: FontWeight.bold,
          color: ColorConsts.boardBorderColor,
          blurRadius: 0.0,
          shadowOffset1: 0.2,
        ),
      ]),
    );
  }
}
