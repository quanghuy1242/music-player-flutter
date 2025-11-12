import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';
import '../utils/platform_utils.dart';

NavigationAppBar createCustomAppBar() {
  return NavigationAppBar(
    height: 40,
    automaticallyImplyLeading: true,
    leading: DragToMoveArea(
      child: Row(
        children: const [
          SizedBox(width: 15),
          Icon(WindowsIcons.music_note, size: 16),
          SizedBox(width: 15),
        ],
      ),
    ),
    title: const DragToMoveArea(
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text('Music Player'),
      ),
    ),
    actions: isWindowsPlatform()
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              WindowCaptionButton.minimize(
                brightness: Brightness.dark,
                onPressed: () async {
                  await windowManager.minimize();
                },
              ),
              WindowCaptionButton.maximize(
                brightness: Brightness.dark,
                onPressed: () async {
                  bool isMaximized = await windowManager.isMaximized();
                  if (isMaximized) {
                    await windowManager.unmaximize();
                  } else {
                    await windowManager.maximize();
                  }
                },
              ),
              WindowCaptionButton.close(
                brightness: Brightness.dark,
                onPressed: () async {
                  await windowManager.close();
                },
              ),
            ],
          )
        : null,
  );
}