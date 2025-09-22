import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';
import '../../utils/formatters.dart';

class TaskCardWidget extends StatefulWidget {
  final Task task;
  final TaskController controller;

  const TaskCardWidget({super.key, required this.task, required this.controller});

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> with TickerProviderStateMixin {
  late bool _isCompleted;
  bool _isAnimatingOut = false;
  bool _isSaving = false;
  static const _animDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.isCompleted;
  }

  @override
  void didUpdateWidget(covariant TaskCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.isCompleted != widget.task.isCompleted) {
      _isCompleted = widget.task.isCompleted;
    }
  }

  Future<void> _toggle(bool value) async {
    if (_isSaving) return;

    setState(() {
      _isAnimatingOut = true;
      _isCompleted = value;
      _isSaving = true;
    });

    await Future.delayed(_animDuration);

    try {
      await widget.controller.setTaskCompletion(widget.task, value);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCompleted = !value;
          _isAnimatingOut = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar la tarea: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnimatingOut = false;
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: _animDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedOpacity(
        duration: _animDuration,
        opacity: _isAnimatingOut ? 0.0 : 1.0,
        child: _isAnimatingOut && !_isSaving
            ? const SizedBox.shrink()
            : Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(child: Text(widget.task.name.isNotEmpty ? widget.task.name[0].toUpperCase() : '?')),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.task.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(formatRepeat(widget.task.repeatType, widget.task.specificDate)),
                      const SizedBox(height: 2),
                      Text('Creada: ${shortDate(widget.task.creationDate)}',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                    ],
                  ),
                ),
                if (_isSaving)
                  const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (v) {
                      if (v == null) return;
                      _toggle(v);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
