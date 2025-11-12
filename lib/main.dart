import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window_manager first
  await windowManager.ensureInitialized();

  // Load saved window preferences
  final prefs = await SharedPreferences.getInstance();
  final savedWidth = prefs.getDouble('window_width') ?? 1000.0;
  final savedHeight = prefs.getDouble('window_height') ?? 700.0;
  final savedX = prefs.getDouble('window_x');
  final savedY = prefs.getDouble('window_y');

  WindowOptions windowOptions = WindowOptions(
    size: Size(savedWidth, savedHeight),
    minimumSize: const Size(400, 600),
    center: savedX == null || savedY == null,
    // titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await Window.initialize();
    await Window.setEffect(effect: WindowEffect.mica, dark: true);
    if (savedX != null && savedY != null) {
      await windowManager.setPosition(Offset(savedX, savedY));
    }
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Music Player',
      theme: FluentThemeData(
        accentColor: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.transparent,
        micaBackgroundColor: Colors.transparent,
        acrylicBackgroundColor: Colors.transparent,
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        micaBackgroundColor: Colors.transparent,
        acrylicBackgroundColor: Colors.transparent,
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 200),
          animationCurve: Curves.easeInOutCubic,
        ),
      ),
      home: const MyHomePage(title: 'Media Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  int _selectedIndex = 0;
  final ScrollController _gridController = ScrollController();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('window_width', size.width);
    await prefs.setDouble('window_height', size.height);
  }

  @override
  void onWindowMove() async {
    final position = await windowManager.getPosition();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('window_x', position.dx);
    await prefs.setDouble('window_y', position.dy);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NavigationView(
            // appBar: NavigationAppBar(
            //   height: 40,
            //   automaticallyImplyLeading: true,
            //   leading: DragToMoveArea(
            //     child: Row(
            //       children: const [
            //         SizedBox(width: 15),
            //         Icon(WindowsIcons.music_note, size: 16),
            //         SizedBox(width: 15),
            //       ],
            //     ),
            //   ),
            //   title: const DragToMoveArea(
            //     child: Align(
            //       alignment: AlignmentDirectional.centerStart,
            //       child: Text('Music Player'),
            //     ),
            //   ),
            //   actions: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       WindowCaptionButton.minimize(
            //         brightness: Brightness.dark,
            //         onPressed: () async {
            //           await windowManager.minimize();
            //         },
            //       ),
            //       WindowCaptionButton.maximize(
            //         brightness: Brightness.dark,
            //         onPressed: () async {
            //           bool isMaximized = await windowManager.isMaximized();
            //           if (isMaximized) {
            //             await windowManager.unmaximize();
            //           } else {
            //             await windowManager.maximize();
            //           }
            //         },
            //       ),
            //       WindowCaptionButton.close(
            //         brightness: Brightness.dark,
            //         onPressed: () async {
            //           await windowManager.close();
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            
            paneBodyBuilder: (item, child) {
              return Container(
                color: const Color(0x4D333333),
                child: child,
              );
            },
            pane: NavigationPane(
              indicator: const StickyNavigationIndicator(),
              selected: _selectedIndex,
              onChanged: (index) => setState(() => _selectedIndex = index),
              displayMode: PaneDisplayMode.auto,
              toggleable: true,
              autoSuggestBox: Builder(
                builder: (context) {
                  return SizedBox(
                    height: 35,
                    child: AutoSuggestBox(
                      placeholder: "Search anything",
                      items: const [],
                      trailingIcon: IgnorePointer(
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                          icon: const Icon(WindowsIcons.search),
                          onPressed: null,
                        ),
                      ),
                    ),
                  );
                },
              ),
              autoSuggestBoxReplacement: const Icon(WindowsIcons.search),
              items: [
                PaneItem(
                  icon: const Icon(WindowsIcons.home),
                  title: const Text('Home'),
                  body: _buildHomeContent(),
                ),
                PaneItem(
                  icon: const Icon(WindowsIcons.music_album),
                  title: const Text('Music library'),
                  body: _buildLibraryContent(),
                ),
                PaneItem(
                  icon: const Icon(WindowsIcons.video),
                  title: const Text('Video library'),
                  body: _buildVideoContent(),
                ),
                PaneItemSeparator(),
                PaneItem(
                  icon: const Icon(WindowsIcons.music_info),
                  title: const Text('Play queue'),
                  body: _buildQueueContent(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.playlist_music),
                  title: const Text('Playlists'),
                  body: _buildPlaylistsContent(),
                ),
              ],
              footerItems: [
                PaneItem(
                  icon: const Icon(WindowsIcons.settings),
                  title: const Text('Settings'),
                  body: _buildSettingsContent(),
                ),
              ],
            ),
          ),
        ),
        RepaintBoundary(child: _buildPlaybackBar()),
      ],
    );
  }

  Widget _buildPlaybackBar() {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0x4D333333),
        border: const Border(
          top: BorderSide(color: Color(0xFF3A3A3A), width: 1),
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
                    style: const SliderThemeData(useThumbBall: false),
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
                              color: const Color(0xFF2B2B2B),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0x33FFFFFF),
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x4D000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              WindowsIcons.music_note,
                              size: 20,
                              color: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time',
                                  style: const TextStyle(
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
                                    color: Colors.grey[120],
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
                              child: const Center(
                                child: Icon(
                                  WindowsIcons.play_solid,
                                  size: 23,
                                  color: Colors.white,
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

  Widget _buildHomeContent() {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Home')),
      children: [
        _MicaCard(
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
                child: const Center(
                  child: Icon(WindowsIcons.music_album, size: 80, color: Colors.white),
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
                style: TextStyle(fontSize: 16, color: Colors.grey[130]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryContent() {
    return ScaffoldPage(
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(34, 0, 34, 0),
              child: Row(
                children: [
                  const Text(
                    'Music',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 40),
                  _buildTabBar(),
                  const Spacer(),
                  Button(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(WindowsIcons.folder_open, size: 14),
                        SizedBox(width: 6),
                        Text('Add folder', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Action bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Row(
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Icon(WindowsIcons.shuffle, size: 14),
                        SizedBox(width: 8),
                        Text('Shuffle and play'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 8),
                  ComboBox<String>(
                    selectedItemBuilder: (context) {
                      return ['Date added', 'Name', 'Artist', 'Album']
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
                                  Text("Sort by:"),
                                  SizedBox(width: 8),
                                  Text(e, style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                          )
                          .toList();
                    },
                    value: 'Date added',
                    items: ['Date added', 'Name', 'Artist', 'Album']
                        .map((e) => ComboBoxItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(width: 15),
                  ComboBox<String>(
                    selectedItemBuilder: (context) {
                      return ['All genres', 'Rock', 'Pop', 'Jazz', 'Classical']
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
                                  Text("Genre:"),
                                  SizedBox(width: 8),
                                  Text(e, style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                          )
                          .toList();
                    },
                    value: 'All genres',
                    items: ['All genres', 'Rock', 'Pop', 'Jazz', 'Classical']
                        .map((e) => ComboBoxItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Album grid
            Expanded(
              child: Listener(
                onPointerSignal: (PointerSignalEvent signal) {
                  if (signal is PointerScrollEvent) {
                    _gridController.animateTo(
                      _gridController.offset + signal.scrollDelta.dy * 2,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  }
                },
                child: SingleChildScrollView(
                  controller: _gridController,
                  // Keep left padding so content aligns with header,
                  // but remove right padding so the scrollbar can sit
                  // at the very edge of the window.
                  padding: const EdgeInsets.only(left: 34, right: 0, top: 10, bottom: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 20,
                          children: List.generate(5, (index) {
                            return SizedBox(
                              width: 200,
                              height: 260,
                              child: RepaintBoundary(
                                child: _buildAlbumCard(index),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Songs', 'Albums', 'Artists'];
    return Row(
      children: tabs.map((tab) {
        final isSelected = tab == 'Albums';
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 18,
                        color: isSelected ? Colors.white : Colors.grey[120],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              if (isSelected)
                Container(
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF60CDFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlbumCard(int index) {
    const baseUrl = 'https://contents.quanghuy.dev/';
    final albums = [
      {
        'title': 'Nữ Thần Mất Trăng (Mônangel)',
        'artist': 'Bùi Lan Hương',
        'image': '${baseUrl}118CD291-17C4-4E0E-B51C-D8504A57E4D5_sk1.jpeg'
      },
      {
        'title': 'The Human Era (Original Soundtrack)',
        'artist': 'Epic Mountain',
        'image': '${baseUrl}35F87834-A50F-40FB-9F76-E994D99D2656_sk1.jpeg'
      },
      {
        'title': 'Thiên Thần Sa Ngã',
        'artist': 'Bùi Lan Hương',
        'image': '${baseUrl}60080A59-43AF-448E-99C1-85887045E5DC_sk1.jpeg'
      },
      {
        'title': 'Lust for Life',
        'artist': 'Lana Del Rey',
        'image': '${baseUrl}73494CD3-B6D7-4931-8978-CD3E3C6EC7EF_sk1.jpeg'
      },
      {
        'title': 'Firewatch (Original Soundtrack)',
        'artist': 'Chris Remo',
        'image': '${baseUrl}79EEE411-BF3C-4F63-BD5E-39C673FFA737_sk1.jpeg'
      },
    ];

    if (index >= albums.length) return const SizedBox.shrink();

    final album = albums[index];
    return AlbumCard(album: album);
  }

  Widget _buildVideoContent() {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Video Library')),
      children: [const Text('Your video collection will appear here')],
    );
  }

  Widget _buildQueueContent() {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Play Queue')),
      children: [const Text('Your play queue is empty')],
    );
  }

  Widget _buildPlaylistsContent() {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Playlists')),
      children: [
        _MicaCard(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    WindowsIcons.music_note,
                    size: 80,
                    color: Colors.grey[100],
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

  Widget _buildSettingsContent() {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Settings')),
      children: [
        _MicaCard(
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Application settings'),
          ),
        ),
      ],
    );
  }
}

class _MicaCard extends StatelessWidget {
  final Widget child;

  const _MicaCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0x22FFFFFF),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0x33FFFFFF), width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(padding: const EdgeInsets.all(16.0), child: child),
      ),
    );
  }
}

class AlbumCard extends StatefulWidget {
  final Map<String, Object?> album;

  const AlbumCard({super.key, required this.album});

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  bool _hover = false;

  void _setHover(bool value) {
    if (_hover == value) return;
    setState(() {
      _hover = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final album = widget.album;
    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: () {},
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
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x4D000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
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
                                  color: Colors.grey[80],
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
                                color: Colors.black.withOpacity(0.06),
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
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                            ),
                            child: IconButton(
                              icon: const Icon(FluentIcons.play_solid, color: Colors.white, size: 13),
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
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(FluentIcons.more, color: Colors.white, size: 13),
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
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: album['artist'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[120],
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
                          color: Colors.black.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
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
    );
  }
}
