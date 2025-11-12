import 'package:fluent_ui/fluent_ui.dart';
import '../widgets/mica_card.dart';
import '../utils/app_theme.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Playlists')),
      children: [
        MicaCard(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    WindowsIcons.music_note,
                    size: 80,
                    color: AppTheme.of(context).colors.textSecondary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "You don't have any playlists",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Create a new playlist'),
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