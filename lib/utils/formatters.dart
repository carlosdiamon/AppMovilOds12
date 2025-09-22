import 'package:intl/intl.dart';
import '../models/task.dart';

String formatRepeat(RepeatType type, DateTime? specificDate) {
  switch (type) {
    case RepeatType.daily:
      return 'Diario';
    case RepeatType.weekly:
      return 'Semanal';
    case RepeatType.monthly:
      return 'Mensual';
    case RepeatType.specific:
      return specificDate == null ? 'Específico' : 'Específico: ${DateFormat.yMMMd().format(specificDate)}';
    }
}

String shortDate(DateTime date) => DateFormat.yMMMd().format(date);
