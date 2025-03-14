import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/task_manegment_cubit/task_manegment_cubit.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FloatingActionButton(
        onPressed:
            () => context.read<TaskManegmentCubit>().addTaskDialog(context),
        elevation: 0.5,
        tooltip: 'Add a task'.tr(),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(320)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
