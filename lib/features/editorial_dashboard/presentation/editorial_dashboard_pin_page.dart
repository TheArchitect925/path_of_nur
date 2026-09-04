import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/editorial_dashboard_access_provider.dart';

class EditorialDashboardPinPage extends ConsumerStatefulWidget {
  const EditorialDashboardPinPage({super.key});

  @override
  ConsumerState<EditorialDashboardPinPage> createState() =>
      _EditorialDashboardPinPageState();
}

class _EditorialDashboardPinPageState
    extends ConsumerState<EditorialDashboardPinPage> {
  final TextEditingController _pinController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    final notifier = ref.read(editorialDashboardAccessProvider.notifier);
    final isValid = notifier.verifyPin(_pinController.text);
    if (isValid) {
      setState(() => _errorText = null);
      context.goNamed('editorialDashboard');
      return;
    }
    setState(() {
      _errorText = AppLocalizations.of(context).editorialDashboardPinError;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppPageScaffold(
      title: l10n.editorialDashboardPinTitle,
      subtitle: l10n.editorialDashboardPinSubtitle,
      children: [
        PremiumCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.editorialDashboardPinHelper,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _pinController,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: l10n.editorialDashboardPinHint,
                    errorText: _errorText,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _submit,
                  child: Text(l10n.editorialDashboardPinSubmitAction),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
