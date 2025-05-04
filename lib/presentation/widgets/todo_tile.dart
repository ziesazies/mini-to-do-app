import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final String taskCategory;
  final bool taskCompleted;

  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  final VoidCallback? onTap;

  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCategory,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              // color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskName,
                      style: TextStyle(
                        decoration:
                            taskCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                    Text(
                      taskCategory,
                      style: TextStyle(
                        // color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                  // activeColor: Colors.black,
                  // checkColor: Theme.of(context).colorScheme.onSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
