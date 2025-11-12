import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../widgets/mica_card.dart';
import '../utils/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Settings')),
      children: [
        MicaCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Application settings'),
                const SizedBox(height: 16),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Row(
                      children: [
                        const Text('Theme: '),
                        ToggleSwitch(
                          checked: themeProvider.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(themeProvider.themeMode == ThemeMode.dark ? 'Dark' : 'Light'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}