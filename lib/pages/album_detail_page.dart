import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import '../widgets/mica_card.dart';
import '../utils/app_theme.dart';

class AlbumDetailPage extends StatelessWidget {
  final Map<String, Object?> album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final title = album['title'] as String? ?? 'Album Details';
    final artist = album['artist'] as String? ?? '';
    final image = album['image'] as String?;

    return ScaffoldPage.scrollable(
      header: PageHeader(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(25, 6, 15, 6),
          child: IconButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.all(12.0)),
            ),
            icon: const Icon(FluentIcons.back, size: 15),
            onPressed: () {
              // Use go_router APIs where possible. Prefer popping the current
              // shell route if there's a history entry, otherwise navigate
              // explicitly to the library route.
              final router = GoRouter.of(context);
              if (router.canPop()) {
                router.pop();
              } else {
                context.go('/library');
              }
            },
          ),
        ),
        title: Text(title),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: MicaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppTheme.of(context).colors.cardBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(WindowsIcons.music_album, size: 64),
                      ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Text(artist, style: TextStyle(color: AppTheme.of(context).colors.textSecondary, fontSize: 14)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              FilledButton(onPressed: () {}, child: const Text('Play all')),
                              FilledButton(onPressed: () {}, child: const Text('Shuffle and play')),
                              Button(onPressed: () {}, child: const Text('Add to')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Placeholder for track list
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Column(
            children: const [
              SizedBox(height: 8),
              Text('Album details and track list will appear here'),
            ],
          ),
        ),
      ],
    );
  }
}