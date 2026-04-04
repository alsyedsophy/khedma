import 'package:intl/intl.dart';

// كده يعتبر هذا الملف لم يستخدم استغنينا عنه باستخدام ال DateTimeExtentions لان هذا الملف يعتبر غير لائق حاليا
class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'ar').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy - hh:mm a', 'ar').format(date);
  }

  static String formatChatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inHours < 1) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inDays < 1) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return formatDate(date);
  }

  static bool isExpired(DateTime expiryDate) {
    return DateTime.now().isAfter(expiryDate);
  }

  static int daysRemaining(DateTime expiryDate) {
    return expiryDate.difference(DateTime.now()).inDays;
  }
}
