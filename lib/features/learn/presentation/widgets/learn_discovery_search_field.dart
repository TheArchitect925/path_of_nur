import 'package:flutter/material.dart';

class LearnDiscoverySearchField extends StatelessWidget {
  const LearnDiscoverySearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onClear,
    this.onTap,
    this.onSubmitted,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final query = controller.text.trim();
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      onTap: onTap,
      onSubmitted: onSubmitted,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: query.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  if (onClear != null) {
                    onClear!();
                    return;
                  }
                  controller.clear();
                  onChanged?.call('');
                },
                icon: const Icon(Icons.close_rounded),
              ),
        border: InputBorder.none,
      ),
    );
  }
}
