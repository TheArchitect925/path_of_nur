enum BedtimeStoryIllustrationUseCase {
  cover,
  backdrop,
  inline,
  endScene,
  quizCompanion,
}

class BedtimeStorySceneIllustration {
  const BedtimeStorySceneIllustration({
    required this.id,
    required this.storyId,
    required this.sortOrder,
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.caption,
    required this.useCase,
  });

  final String id;
  final String storyId;
  final int sortOrder;
  final String title;
  final String description;
  final String imageAssetPath;
  final String caption;
  final BedtimeStoryIllustrationUseCase useCase;
}
