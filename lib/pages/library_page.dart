import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import '../widgets/album_card.dart';
// album_detail_page is routed from the app router; not directly referenced here
// anymore, so we don't need to import it.
import '../data/albums.dart';
import '../utils/app_theme.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final ScrollController _gridController = ScrollController();
  int _selectedTabIndex = 1; // 0: Songs, 1: Albums, 2: Artists

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Widget _buildContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const _SongsView();
      case 1:
        return _AlbumsView(controller: _gridController);
      case 2:
        return const _ArtistsView();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _TabBar(
                    selectedIndex: _selectedTabIndex,
                    onChanged: _onTabChanged,
                  ),
                  const Spacer(),
                  Button(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
            // Action bar - only show for Albums tab
            if (_selectedTabIndex == 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Row(
                  children: [
                    FilledButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(WindowsIcons.shuffle, size: 14),
                          SizedBox(width: 8),
                          Text('Shuffle and play'),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 8),
                    const _SortComboBox(),
                    const SizedBox(width: 15),
                    const _GenreComboBox(),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Content
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = ['Songs', 'Albums', 'Artists'];
    return Row(
      children: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final isSelected = index == selectedIndex;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onChanged(index),
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
                        color: isSelected ? AppTheme.of(context).colors.textPrimary : AppTheme.of(context).colors.textSecondary,
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
                    color: AppTheme.of(context).colors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SortComboBox extends StatelessWidget {
  const _SortComboBox();

  static const _sortOptions = ['Date added', 'Name', 'Artist', 'Album'];

  @override
  Widget build(BuildContext context) {
    return ComboBox<String>(
      selectedItemBuilder: (context) {
        return _sortOptions.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            child: Row(
              children: [
                const Text("Sort by:"),
                const SizedBox(width: 8),
                Text(e, style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ).toList();
      },
      value: 'Date added',
      items: _sortOptions.map((e) => ComboBoxItem(value: e, child: Text(e))).toList(),
      onChanged: (value) {},
    );
  }
}

class _GenreComboBox extends StatelessWidget {
  const _GenreComboBox();

  static const _genreOptions = ['All genres', 'Rock', 'Pop', 'Jazz', 'Classical'];

  @override
  Widget build(BuildContext context) {
    return ComboBox<String>(
      selectedItemBuilder: (context) {
        return _genreOptions.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            child: Row(
              children: [
                const Text("Genre:"),
                const SizedBox(width: 8),
                Text(e, style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ).toList();
      },
      value: 'All genres',
      items: _genreOptions.map((e) => ComboBoxItem(value: e, child: Text(e))).toList(),
      onChanged: (value) {},
    );
  }
}

class _SongsView extends StatelessWidget {
  const _SongsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Songs view - Coming soon'),
    );
  }
}

class _AlbumsView extends StatelessWidget {
  const _AlbumsView({required this.controller});

  final ScrollController controller;

  static const _albums = albumsData;

  @override
  Widget build(BuildContext context) {
    // Show the albums grid directly. We're not using a nested Navigator
    // anymore because routing is handled at the app level via go_router.
    return Listener(
      onPointerSignal: (PointerSignalEvent signal) {
        if (signal is PointerScrollEvent) {
          controller.animateTo(
            controller.offset + signal.scrollDelta.dy * 2,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      },
      child: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.only(left: 34, right: 0, top: 10, bottom: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Wrap(
                spacing: 15,
                runSpacing: 20,
                children: List.generate(_albums.length, (index) {
                  return SizedBox(
                    width: 200,
                    height: 260,
                    child: RepaintBoundary(
                      child: AlbumCard(album: _albums[index], id: index),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ArtistsView extends StatelessWidget {
  const _ArtistsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Artists view - Coming soon'),
    );
  }
}