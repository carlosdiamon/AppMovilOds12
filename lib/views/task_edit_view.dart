import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../controllers/task_controller.dart';

class TaskEditView extends StatefulWidget {
  final Task? task;
  final TaskController controller;

  const TaskEditView({super.key, this.task, required this.controller});

  @override
  State<TaskEditView> createState() => _TaskEditViewState();
}

class _TaskEditViewState extends State<TaskEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late RepeatType _repeatType;
  DateTime? _specificDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _repeatType = widget.task?.repeatType ?? RepeatType.daily;
    _specificDate = widget.task?.specificDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _repeatLabel(RepeatType type) {
    switch (type) {
      case RepeatType.daily:
        return 'Diario';
      case RepeatType.weekly:
        return 'Semanal';
      case RepeatType.monthly:
        return 'Mensual';
      case RepeatType.specific:
        return 'Fecha específica';
      }
  }

  String _formatDate(DateTime date) => DateFormat.yMMMd().format(date);

  Future<void> _pickSpecificDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _specificDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _specificDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final name = _nameController.text.trim();

    try {
      if (widget.task != null) {
        final t = widget.task!;
        t.name = name;
        t.repeatType = _repeatType;
        t.specificDate = _repeatType == RepeatType.specific ? _specificDate : null;
        await widget.controller.editTask(t);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tarea actualizada')));
      } else {
        final newTask = Task(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          repeatType: _repeatType,
          creationDate: DateTime.now(),
          specificDate: _repeatType == RepeatType.specific ? _specificDate : null,
          isCompleted: false,
        );
        await widget.controller.addTask(newTask);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tarea creada')));
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarea' : 'Nueva Tarea'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del hábito',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'El nombre es requerido';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<RepeatType>(
                value: _repeatType,
                decoration: const InputDecoration(
                  labelText: 'Repetición',
                  border: OutlineInputBorder(),
                ),
                items: RepeatType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_repeatLabel(type)),
                  );
                }).toList(),
                onChanged: (type) {
                  if (type == null) return;
                  setState(() {
                    _repeatType = type;
                    if (_repeatType != RepeatType.specific) _specificDate = null;
                  });
                },
              ),
              const SizedBox(height: 12),

              if (_repeatType == RepeatType.specific)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Fecha específica', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _pickSpecificDate,
                            child: Text(_specificDate == null ? 'Elige fecha' : _formatDate(_specificDate!)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_specificDate != null)
                          IconButton(
                            tooltip: 'Quitar fecha',
                            onPressed: () => setState(() => _specificDate = null),
                            icon: const Icon(Icons.clear),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(isEditing ? 'Guardar cambios' : 'Crear tarea'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
