import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';

class AlbumCard extends StatefulWidget {
  final Map<String, Object?> album;
  final int id;

  const AlbumCard({super.key, required this.album, required this.id});

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  bool _hover = false;
  bool _pressed = false;

  void _setHover(bool value) {
    if (_hover == value) return;
    setState(() {
      _hover = value;
    });
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final album = widget.album;
    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: () {
          // Navigate using go_router so the app shell remains intact.
          context.go('/library/${widget.id}');
        },
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Stack(
            children: [
              // Base content (image + title + artist) wrapped in AnimatedContainer
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  // keep the base container transparent; we'll draw a subtle
                  // backdrop overlay separately so the thumbnail doesn't get fully darkened
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.of(context).colors.cardBackground,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.of(context).colors.cardBorder, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.of(context).colors.shadowColor,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Placeholder icon underneath while the network image loads
                                  Center(
                                    child: Icon(
                                      WindowsIcons.music_album,
                                      size: 56,
                                      color: AppTheme.of(context).colors.textSecondary,
                                    ),
                                  ),
                                  if (album['image'] is String)
                                    Positioned.fill(
                                      child: Image.network(
                                        album['image'] as String,
                                        fit: BoxFit.cover,
                                        // frameBuilder lets us fade the image when it first appears
                                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                          final bool loaded = frame != null || wasSynchronouslyLoaded;
                                          return AnimatedOpacity(
                                            opacity: loaded ? 1.0 : 0.0,
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            child: child,
                                          );
                                        },
                                        // handle errors by keeping the placeholder visible
                                        errorBuilder: (context, error, stackTrace) {
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // subtle backdrop slightly larger than the image
                          Center(
                            child: AnimatedOpacity(
                              opacity: _hover ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 160),
                              curve: Curves.easeOut,
                              child: FractionallySizedBox(
                                widthFactor: 1.08,
                                heightFactor: 1.08,
                                child: Container(
                                decoration: BoxDecoration(
                                  // color: AppTheme.of(context).colors.hoverBackdropColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                ),
                              ),
                            ),
                          ),
                          // play button bottom-left
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: AnimatedOpacity(
                              opacity: _hover ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 160),
                              curve: Curves.easeOut,
                              child: Container(
                                width: 30,
                                height: 30,
                              decoration: BoxDecoration(
                                color: AppTheme.of(context).colors.hoverButtonBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.of(context).colors.hoverButtonBorder, width: 1),
                              ),
                                child: IconButton(
                                      icon: Icon(FluentIcons.play_solid, color: AppTheme.of(context).colors.playButtonColor, size: 13),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                          // more button bottom-right
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: AnimatedOpacity(
                              opacity: _hover ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 160),
                              curve: Curves.easeOut,
                              child: Container(
                                width: 30,
                                height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.of(context).colors.hoverButtonBorder, width: 1),
                                color: AppTheme.of(context).colors.hoverButtonBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                                child: IconButton(
                                      icon: Icon(FluentIcons.more, color: AppTheme.of(context).colors.iconPrimary, size: 13),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Combined title + artist block limited to 3 lines total.
                    RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                                text: '${album['title']}\n',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                                color: AppTheme.of(context).colors.textPrimary,
                              ),
                          ),
                          TextSpan(
                            text: album['artist'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.of(context).colors.textSecondary,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // subtle full-card backdrop slightly larger than the card
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: _hover ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  child: IgnorePointer(
                    // Always ignore pointer events on the visual backdrop so
                    // underlying buttons remain clickable.
                    ignoring: true,
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 1.06,
                        heightFactor: 1.06,
                        child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.of(context).colors.hoverBackdropColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.of(context).colors.hoverButtonBorder,
                            width: 1,
                          ),
                        ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}