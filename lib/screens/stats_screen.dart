import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/utils/components/show_snackbar.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final TextEditingController _goalController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<StatsCubit>().getGoal();
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsCubitState>(
      builder: (context, state) {
        final cubit = context.read<StatsCubit>();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Productivity Stats'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
            ),

            leading: const LeadingIcon(),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                TextField(
                  controller: _goalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText:
                        cubit.getGoal() == 0
                            ? 'Set weekly productivity goal (minutes)'.tr()
                            : '${'Your weekly goal focus minutes:'.tr()} ${cubit.getGoal()}',
                    hintStyle: const TextStyle(fontSize: 14),

                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withAlpha(25),
                        width: 5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withAlpha(25),
                        width: 5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withAlpha(25),
                        width: 5,
                      ),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.red, width: 5),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value == '0') {
                      showSnackBar(
                        context,
                        'Set weekly productivity goal (minutes)'.tr(),
                      );
                      return;
                    }
                    final goal =
                        int.tryParse(value) ??
                        300; // إذا لم يدخل المستخدم قيمة صحيحة
                    cubit.saveGoal(goal);
                    _goalController.clear();
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '${'Weekly Goal Minutes:'.tr()} ${cubit.getGoal()} ${'minutes.'.tr()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${'Minutes Achieved:'.tr()} ${cubit.totalFocusTime()} ${'minutes.'.tr()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${'Weekly Goal Achieved:'.tr()} ${(cubit.progress() * 100).toStringAsFixed(0)} %.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(8),
                  value:
                      cubit.progress() > 1
                          ? 1
                          : cubit.progress(), // لا يتجاوز 100%
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '${'Completed Sessions:'.tr()} ${cubit.sessionCount()}.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: 220,
                    width: 320,
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(show: true),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(),
                          rightTitles: const AxisTitles(),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              minIncluded: false,
                              reservedSize: 40,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = cubit.generateWeekDays();
                                return Text(
                                  days[value.toInt()],
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: cubit.generateChartData(cubit.sessionBox),
                            isCurved: true,
                            color: Colors.blue,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withAlpha(50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
