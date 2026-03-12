import 'package:flutter/material.dart';

import '../data/seeded_hadith_foundation_data.dart';
import 'hadith_subcategory_page.dart';

class ImportantHadithCollectionPage extends StatelessWidget {
  const ImportantHadithCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HadithSubcategoryPage(subcategoryId: essentialCollectionId);
  }
}
