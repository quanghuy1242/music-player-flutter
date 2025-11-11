import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await Window.setEffect(effect: WindowEffect.mica, dark: true);
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

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NavigationView(
            paneBodyBuilder: (item, child) {
              return Container(color: const Color(0x4D333333), child: child);
            },
            pane: NavigationPane(
              indicator: const StickyNavigationIndicator(),
              selected: _selectedIndex,
              onChanged: (index) => setState(() => _selectedIndex = index),
              displayMode: PaneDisplayMode.open,
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
                          icon: const WindowsIcon(FluentIcons.search),
                          onPressed: null,
                        ),
                      ),
                    ),
                  );
                },
              ),
              autoSuggestBoxReplacement: const Icon(FluentIcons.search),
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.home),
                  title: const Text('Home'),
                  body: _buildHomeContent(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.music_in_collection),
                  title: const Text('Music library'),
                  body: _buildLibraryContent(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.video),
                  title: const Text('Video library'),
                  body: _buildVideoContent(),
                ),
                PaneItemSeparator(),
                PaneItem(
                  icon: const Icon(FluentIcons.playlist_music),
                  title: const Text('Play queue'),
                  body: _buildQueueContent(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.list),
                  title: const Text('Playlists'),
                  body: _buildPlaylistsContent(),
                ),
              ],
              footerItems: [
                PaneItem(
                  icon: const Icon(FluentIcons.settings),
                  title: const Text('Settings'),
                  body: _buildSettingsContent(),
                ),
              ],
            ),
          ),
        ),
        _buildPlaybackBar(),
      ],
    );
  }

  Widget _buildPlaybackBar() {
    return Container(
      height: 120,
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
                Text('0:00:00', style: TextStyle(fontSize: 12)),
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
                Text('0:00:00', style: TextStyle(fontSize: 12)),
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            FluentIcons.music_note,
                            size: 20,
                            color: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Hans Zimmer • Inception (Music from the Motion Picture)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[120],
                              ),
                            ),
                          ],
                        ),
                      ],
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
                          icon: const Icon(FluentIcons.previous, size: 16),
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
                                border: Border.all(color: Colors.blue, width: 4),
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
                          icon: const Icon(FluentIcons.next, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(FluentIcons.repeat_all, size: 16),
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
                          icon: const Icon(FluentIcons.volume3, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(FluentIcons.full_screen, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(FluentIcons.refresh, size: 16),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(FluentIcons.more, size: 16),
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
                  child: Icon(FluentIcons.album, size: 80, color: Colors.white),
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
                        Icon(FluentIcons.folder_open, size: 14),
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
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 0,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildAlbumCard(index);
                },
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
    final albums = [
      {'title': 'Thiên Thần Sa Ngã', 'artist': 'Bùi Lan Hương', 'image': null},
      {
        'title': 'Firewatch (Original Score)',
        'artist': 'Chris Remo',
        'image': null,
      },
      {
        'title': 'By the Deep Sea',
        'artist': 'Federico Albanese',
        'image': null,
      },
      {
        'title': 'Nữ Thần Mất Trăng (Mônangel)',
        'artist': 'Bùi Lan Hương',
        'image': null,
      },
      {
        'title': 'Inception (Music from the Motion Picture)',
        'artist': 'Hans Zimmer',
        'image': null,
      },
    ];

    if (index >= albums.length) return const SizedBox.shrink();

    final album = albums[index];
    return HoverButton(
      onPressed: () {},
      builder: (context, states) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: album['image'] == null
                      ? const Color(0xFF2B2B2B)
                      : album['image'] == 'orange'
                      ? const Color(0xFFFF8C00)
                      : album['image'] == 'bw'
                      ? const Color(0xFF666666)
                      : const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: album['image'] == null
                    ? Center(
                        child: Icon(
                          FluentIcons.album,
                          size: 56,
                          color: Colors.grey[80],
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              // height: 34,
              child: Text(
                album['title'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 16,
              child: Text(
                album['artist'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[120],
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
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
                    FluentIcons.music_note,
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
