import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/theme/islamic_icons.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../data/names_of_allah_data.dart';

class NamesOfAllahPage extends ConsumerStatefulWidget {
  const NamesOfAllahPage({super.key});

  @override
  ConsumerState<NamesOfAllahPage> createState() => _NamesOfAllahPageState();
}

class _NamesOfAllahPageState extends ConsumerState<NamesOfAllahPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final normalized = _query.trim().toLowerCase();
    final filtered = namesOfAllah.where((name) {
      if (normalized.isEmpty) return true;
      return name.transliteration.toLowerCase().contains(normalized) ||
          name.meaning.toLowerCase().contains(normalized) ||
          name.arabic.contains(normalized);
    }).toList();

    return AppPageScaffold(
      headerIcon: IslamicIcons.allahText,
      title: '99 Names of الله',
      subtitle: 'Arabic, transliteration, and concise meanings for reflection.',
      children: [
        PremiumCard(
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Search by Arabic, transliteration, or meaning',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Text(
            '${filtered.length} / ${namesOfAllah.length} names',
            style: const TextStyle(
              color: Color(0xFF6A5A4A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...filtered.map(
          (name) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF1E7D8),
                    ),
                    child: Text(
                      '${name.index}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.arabic,
                          style: AppTextStyles.arabicLearning(
                            size: 32,
                            weight: FontWeight.w700,
                          ),
                          textAlign: textAlignForContent(name.arabic),
                          textDirection: textDirectionForContent(name.arabic),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name.transliteration,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF47382B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name.meaning,
                          style: const TextStyle(
                            color: Color(0xFF6A5A4A),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
