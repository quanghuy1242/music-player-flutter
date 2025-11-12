import 'package:fluent_ui/fluent_ui.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Play Queue')),
      children: [const Text('Your play queue is empty')],
    );
  }
}