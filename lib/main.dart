import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/library_page.dart';
import 'pages/video_page.dart';
import 'pages/queue_page.dart';
import 'pages/playlists_page.dart';
import 'pages/settings_page.dart';
import 'pages/album_detail_page.dart';
import 'data/albums.dart';
import 'widgets/playback_bar.dart';
import 'widgets/custom_app_bar.dart';
import 'utils/platform_utils.dart';
import 'utils/theme_provider.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isWindowsPlatform()) {
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
      // Determine whether to use the dark mica effect. Prefer a saved
      // theme preference (stored by `ThemeProvider`) when available,
      // otherwise fall back to the platform/system brightness.
      final themeString = prefs.getString('theme_mode');
      bool useDarkMica = true;
      if (themeString != null) {
        try {
          final savedMode = ThemeMode.values.firstWhere((m) => m.toString() == themeString, orElse: () => ThemeMode.system);
          if (savedMode == ThemeMode.light) {
            useDarkMica = false;
          } else if (savedMode == ThemeMode.dark) {
            useDarkMica = true;
          } else {
            // system - fall through to platform brightness below
            useDarkMica = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
          }
        } catch (_) {
          useDarkMica = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
        }
      } else {
        useDarkMica = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      }

      await Window.setEffect(effect: WindowEffect.mica, dark: useDarkMica);
      if (savedX != null && savedY != null) {
        await windowManager.setPosition(Offset(savedX, savedY));
      }
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) => FluentAppShell(child: child),
          routes: [
            GoRoute(path: '/', builder: (ctx, state) => const HomePage()),
            GoRoute(path: '/library', builder: (ctx, state) => const LibraryPage()),
            GoRoute(path: '/library/:id', builder: (ctx, state) {
              // Extract the ':id' parameter in a way that's compatible with
              // multiple go_router versions. Try several common property names
              // and fall back to parsing the URI path segments.
              String? idStr;
              try {
                final s = state as dynamic;
                try {
                  idStr = s.params?['id'] as String?;
                } catch (_) {}
                if (idStr == null) {
                  try {
                    idStr = s.pathParameters?['id'] as String?;
                  } catch (_) {}
                }
                if (idStr == null) {
                  try {
                    idStr = s.namedParameters?['id'] as String?;
                  } catch (_) {}
                }
                if (idStr == null) {
                  try {
                    final Uri? uri = (s.uri as Uri?);
                    if (uri != null && uri.pathSegments.isNotEmpty) {
                      idStr = uri.pathSegments.last;
                    }
                  } catch (_) {}
                }
              } catch (_) {}

              final id = int.tryParse(idStr ?? '') ?? 0;
              final Map<String, Object?> album =
                  (albumsData.length > id) ? Map<String, Object?>.from(albumsData[id]) : <String, Object?>{};
              return AlbumDetailPage(album: album);
            }),
            GoRoute(path: '/video', builder: (ctx, state) => const VideoPage()),
            GoRoute(path: '/queue', builder: (ctx, state) => const QueuePage()),
            GoRoute(path: '/playlists', builder: (ctx, state) => const PlaylistsPage()),
            GoRoute(path: '/settings', builder: (ctx, state) => const SettingsPage()),
          ],
        ),
      ],
    );

    return FluentApp.router(
      routerConfig: router,
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
        extensions: [AppTheme(colors: AppTheme.lightColors)],
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
        extensions: [AppTheme(colors: AppTheme.darkColors)],
      ),
      themeMode: themeProvider.themeMode,
      // The shell handles layout; set a placeholder home
      // home: const MyHomePage(title: 'Media Player'),
    );
  }
}

class FluentAppShell extends StatelessWidget {
  final Widget child;
  const FluentAppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return FluentAppShellScaffold(child: child);
  }
}

class FluentAppShellScaffold extends StatefulWidget {
  final Widget child;
  const FluentAppShellScaffold({required this.child, super.key});

  @override
  State<FluentAppShellScaffold> createState() => _FluentAppShellScaffoldState();
}

class _FluentAppShellScaffoldState extends State<FluentAppShellScaffold> with WindowListener {
  // left-over from earlier experiment; not required by this fluent_ui version
  // so keep no key here.
  // final GlobalKey _paneKey = GlobalKey();

    // Cache the NavigationPane templates to avoid rebuilding them on every
    // `build`. This reduces GC churn and unnecessary widget allocations.
    late final List<dynamic> _itemTemplates = [
      PaneItem(key: const ValueKey('/'), icon: const Icon(WindowsIcons.home), title: const Text('Home'), body: const SizedBox.shrink()),
      PaneItem(key: const ValueKey('/library'), icon: const Icon(WindowsIcons.music_album), title: const Text('Music library'), body: const SizedBox.shrink()),
      PaneItem(key: const ValueKey('/video'), icon: const Icon(WindowsIcons.video), title: const Text('Video library'), body: const SizedBox.shrink()),
      PaneItemSeparator(),
      PaneItem(key: const ValueKey('/queue'), icon: const Icon(WindowsIcons.music_info), title: const Text('Play queue'), body: const SizedBox.shrink()),
      PaneItem(key: const ValueKey('/playlists'), icon: const Icon(FluentIcons.playlist_music), title: const Text('Playlists'), body: const SizedBox.shrink()),
    ];

    late final List<dynamic> _footerTemplates = [
      PaneItemSeparator(),
      PaneItem(key: const ValueKey('/settings'), icon: const Icon(WindowsIcons.settings), title: const Text('Settings'), body: const SizedBox.shrink()),
    ];
    // Memoized mapped items (built once in didChangeDependencies so we can
    // capture a valid BuildContext for navigation callbacks).
    late List<NavigationPaneItem> _mappedItems;
    late List<NavigationPaneItem> _mappedFooter;
    bool _paneInitialized = false;
    // Track ThemeProvider so we can react to theme changes and update
    // the window mica effect to match the app's light/dark mode.
    ThemeProvider? _themeProvider;

    PaneItem _buildPaneItem(PaneItem item) {
      return PaneItem(
        key: item.key,
        icon: item.icon,
        title: item.title,
        body: item.body,
        onTap: () {
          final path = (item.key as ValueKey).value as String;
          final current = Router.of(context).routeInformationProvider?.value.uri.path ?? Uri.base.path;
          if (current != path) {
            context.go(path);
          }
          item.onTap?.call();
        },
      );
    }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      // Subscribe to ThemeProvider changes so we can update the
      // Windows mica effect live when the user toggles theme.
      final provider = Provider.of<ThemeProvider>(context);
      if (_themeProvider != provider) {
        _themeProvider?.removeListener(_onThemeChanged);
        _themeProvider = provider;
        _themeProvider?.addListener(_onThemeChanged);
      }
      if (!_paneInitialized) {
        _mappedItems = _itemTemplates.map<NavigationPaneItem>((e) {
          if (e is PaneItemExpander) {
            return PaneItemExpander(
              key: e.key,
              icon: e.icon,
              title: e.title,
              body: e.body,
              items: e.items.map((item) {
                if (item is PaneItem) return _buildPaneItem(item);
                return item;
              }).toList(),
            );
          }
          if (e is PaneItem) return _buildPaneItem(e);
          return e as NavigationPaneItem;
        }).toList();

        _mappedFooter = _footerTemplates.map<NavigationPaneItem>((e) {
          if (e is PaneItemExpander) {
            return PaneItemExpander(
              key: e.key,
              icon: e.icon,
              title: e.title,
              body: e.body,
              items: e.items.map((item) {
                if (item is PaneItem) return _buildPaneItem(item);
                return item;
              }).toList(),
            );
          }
          if (e is PaneItem) return _buildPaneItem(e);
          return e as NavigationPaneItem;
        }).toList();

        _paneInitialized = true;
      }
    }

    Future<void> _onThemeChanged() async {
      if (!isWindowsPlatform()) return;
      try {
        final mode = _themeProvider?.themeMode ?? ThemeMode.system;
        bool useDarkMica;
        if (mode == ThemeMode.light) {
          useDarkMica = false;
        } else if (mode == ThemeMode.dark) {
          useDarkMica = true;
        } else {
          useDarkMica = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
        }
        await Window.setEffect(effect: WindowEffect.mica, dark: useDarkMica);
      } catch (_) {}
    }

  @override
  void initState() {
    super.initState();
    if (isWindowsPlatform()) {
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
    if (isWindowsPlatform()) {
      windowManager.removeListener(this);
    }
    _themeProvider?.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  void onWindowResize() async {
    if (!isWindowsPlatform()) return;
    final size = await windowManager.getSize();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('window_width', size.width);
    await prefs.setDouble('window_height', size.height);
  }

  @override
  void onWindowMove() async {
    if (!isWindowsPlatform()) return;
    final position = await windowManager.getPosition();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('window_x', position.dx);
    await prefs.setDouble('window_y', position.dy);
  }

  @override
  Widget build(BuildContext context) {
    // Map navigation indices to routes used by GoRouter
    // routes array matches the positions of the pane template list.
    // We include an empty placeholder for the separator position so
    // onChanged indexing doesn't go out of range.
    final routes = [
      '/',
      '/library',
      '/video',
      '', // separator placeholder
      '/queue',
      '/playlists',
    ];

    // Resolve current location using multiple fallbacks to support several
    // go_router versions. Prefer routerDelegate.currentConfiguration.location
    // when available, otherwise fall back to Uri.base.path.
    String location = '/';
    try {
      final router = GoRouter.of(context);
      try {
        final dynamicLoc = (router as dynamic).location as String?;
        if (dynamicLoc != null && dynamicLoc.isNotEmpty) location = dynamicLoc;
      } catch (_) {}
      try {
        final info = Router.of(context).routeInformationProvider?.value;
        if (info != null) {
          if (info.location.isNotEmpty) {
            location = info.location;
          }
        }
      } catch (_) {}
      if (location.isEmpty) location = Uri.base.path;
    } catch (_) {
      location = Uri.base.path;
    }

    // Determine selected index by searching the memoized (items + footer)
    // lists. Those are built once in didChangeDependencies to reduce
    // allocations.
    final combinedWithKeys = <NavigationPaneItem>[];
    combinedWithKeys.addAll(_mappedItems.where((it) => it.key != null));
    combinedWithKeys.addAll(_mappedFooter.where((it) => it.key != null));

    int selectedIndex = combinedWithKeys.indexWhere((item) {
      final key = item.key;
      if (key is ValueKey) {
        final path = key.value as String;
        return location == path || location.startsWith(path + '/') || (path != '/' && location.startsWith(path));
      }
      return false;
    });
    if (selectedIndex < 0) selectedIndex = 0;

    return Column(
      children: [
        Expanded(
          child: NavigationView(
            appBar: isMobilePlatform() ? createCustomAppBar() : null,
            paneBodyBuilder: (item, child) {
              return Container(
                color: AppTheme.of(context).colors.backgroundOverlay,
                child: widget.child,
              );
            },
            pane: NavigationPane(
              indicator: const StickyNavigationIndicator(),
              selected: selectedIndex >= 0 ? selectedIndex : 0,
              onChanged: (index) {
                final path = routes[index];
                GoRouter.of(context).go(path);
              },
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
              items: _mappedItems,
              footerItems: _mappedFooter,
            ),
          ),
        ),
        RepaintBoundary(child: PlaybackBar()),
      ],
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

  @override
  void initState() {
    super.initState();
    if (isWindowsPlatform()) {
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
    if (isWindowsPlatform()) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowResize() async {
    if (!isWindowsPlatform()) return;
    final size = await windowManager.getSize();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('window_width', size.width);
    await prefs.setDouble('window_height', size.height);
  }

  @override
  void onWindowMove() async {
    if (!isWindowsPlatform()) return;
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
            appBar: isMobilePlatform() ? createCustomAppBar() : null,
            paneBodyBuilder: (item, child) {
              return Container(
                color: AppTheme.of(context).colors.backgroundOverlay,
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
                  body: const HomePage(),
                ),
                PaneItem(
                  icon: const Icon(WindowsIcons.music_album),
                  title: const Text('Music library'),
                  body: const LibraryPage(),
                ),
                PaneItem(
                  icon: const Icon(WindowsIcons.video),
                  title: const Text('Video library'),
                  body: const VideoPage(),
                ),
                PaneItemSeparator(),
                PaneItem(
                  icon: const Icon(WindowsIcons.music_info),
                  title: const Text('Play queue'),
                  body: const QueuePage(),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.playlist_music),
                  title: const Text('Playlists'),
                  body: const PlaylistsPage(),
                ),
              ],
              footerItems: [
                PaneItem(
                  icon: const Icon(WindowsIcons.settings),
                  title: const Text('Settings'),
                  body: const SettingsPage(),
                ),
              ],
            ),
          ),
        ),
        RepaintBoundary(child: PlaybackBar()),
      ],
    );
  }
}
