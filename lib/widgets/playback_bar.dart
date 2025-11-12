import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_theme.dart';

class PlaybackBar extends StatelessWidget {
  const PlaybackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: AppTheme.of(context).colors.backgroundOverlay,
        border: Border(
          top: BorderSide(color: AppTheme.of(context).colors.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Progress bar with time
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('0:00:00', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: 0.0,
                    max: 100,
                    onChanged: (value) {},
                    // style: const SliderThemeData(useThumbBall: false),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('0:00:00', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          // Controls
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  // Left: Track info
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppTheme.of(context).colors.cardBackground,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppTheme.of(context).colors.cardBorder,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.of(context).colors.shadowColor,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              WindowsIcons.music_note,
                              size: 20,
                              color: AppTheme.of(context).colors.iconPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Time',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Hans Zimmer • Inception (Music from the Motion Picture)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.of(context).colors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Center: Playback controls
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(WindowsIcons.shuffle, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(WindowsIcons.previous, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                // color: Color(0xFF60CDFF),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 4),
                              ),
                              child: Center(
                                child: Icon(
                                  WindowsIcons.play_solid,
                                  size: 23,
                                  color: AppTheme.of(context).colors.playButtonColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(WindowsIcons.next, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(WindowsIcons.repeat_all, size: 16),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // Right: Volume and other controls
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(WindowsIcons.volume3, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(WindowsIcons.full_screen, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(WindowsIcons.refresh, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(WindowsIcons.more, size: 16),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}