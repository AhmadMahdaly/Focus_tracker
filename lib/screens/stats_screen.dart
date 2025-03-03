import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/utils/components/text_field_border.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';
import 'package:fl_chart/fl_chart.dart';

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
              style: TextStyle(fontWeight: FontWeight.w200),
            ),

            leading: LeadingIcon(),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    cubit.goalBox.clear();
                    cubit.sessionBox.clear();
                    cubit.achievementsBox.clear();
                    cubit.hasSent50PercentNotification = false;
                    cubit.hasSent100PercentNotification = false;
                  });
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(32),
            child: ListView(
              children: [
                Row(
                  children: [
                    Text(
                      'Total Focus Time: ${cubit.totalFocusTime()} minutes',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Completed Sessions: ${cubit.sessionCount()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                List<String> days = cubit.generateWeekDays();
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
                            barWidth: 4,
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

                TextField(
                  controller: _goalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Set weekly productivity goal (minutes)",
                    border: border(),
                    focusedBorder: border(),
                    enabledBorder: border(),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  onSubmitted: (value) {
                    cubit.goal =
                        int.tryParse(value) ??
                        300; // إذا لم يدخل المستخدم قيمة صحيحة
                    setState(() {
                      cubit.saveGoal(cubit.goal);
                    });
                  },
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
                Text('Weekly Goal Minutes: ${cubit.goal}'),
                Text('Minutes Achieved: ${cubit.totalFocusTime()}'),

                Text(
                  "Weekly Goal Achieved: ${(cubit.progress() * 100).toStringAsFixed(0)}%",
                ),
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
