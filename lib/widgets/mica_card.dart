import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_theme.dart';

class MicaCard extends StatelessWidget {
  final Widget child;

  const MicaCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.of(context).colors.micaColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppTheme.of(context).colors.micaBorder, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(padding: const EdgeInsets.all(16.0), child: child),
      ),
    );
  }
}