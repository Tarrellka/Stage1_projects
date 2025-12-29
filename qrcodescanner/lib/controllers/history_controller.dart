import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../l10n/app_localizations.dart';

class HistoryController extends ChangeNotifier {
  final DatabaseService db = DatabaseService();

  void showDeleteDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              db.clearAllHistory();
              Navigator.pop(context);
            },
            child: Text(
              l10n.deleteButton,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}