import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final TextEditingController _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsCubitState>(
      builder: (context, state) {
        final cubit = context.read<StatsCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Productivity Stats',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
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
                        cubit.goal == 0
                            ? 'Set weekly productivity goal (minutes)'
                            : 'Your weekly goal focus minutes: ${cubit.goal}',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      // decoration: TextDecoration.underline,
                      // decorationColor: Colors.grey,
                    ),

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
                    cubit
                      ..goal =
                          int.tryParse(value) ??
                          0 // إذا لم يدخل المستخدم قيمة صحيحة
                      ..saveGoal(cubit.goal);
                    _goalController.clear();
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Weekly Goal Minutes: ${cubit.goal} minutes.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Minutes Achieved: ${cubit.totalFocusTime()} minutes.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Weekly Goal Achieved: ${(cubit.progress() * 100).toStringAsFixed(0)} %.',
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
                      'Completed Sessions: ${cubit.sessionCount()}.',
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
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey),
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
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

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }
}
