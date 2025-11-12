import 'package:fluent_ui/fluent_ui.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Video Library')),
      children: [const Text('Your video collection will appear here')],
    );
  }
}