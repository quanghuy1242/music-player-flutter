import 'package:fluent_ui/fluent_ui.dart';
import '../widgets/mica_card.dart';
import '../utils/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Home')),
      children: [
        MicaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Icon(WindowsIcons.music_album, size: 80, color: AppTheme.of(context).colors.textPrimary),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Now Playing',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'No track selected',
                style: TextStyle(fontSize: 16, color: AppTheme.of(context).colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}