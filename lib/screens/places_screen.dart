import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../services/places_service.dart';
import '../state/saved_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'main_shell.dart';
import 'restaurant_detail_screen.dart';

/// Places screen (Figma: B · iOS · 06 · Places and its state frames).
class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

/// One filter chip: its label, the list title, and the tag it matches.
class _Filter {
  const _Filter(this.label, this.title, this.tag);

  final String label;
  final String title;

  /// Tag to match, or null to show every place.
  final String? tag;
}

class _PlacesScreenState extends State<PlacesScreen> {
  // Figma chips and their list titles.
  // TODO: sort "Nearby" by distance in the Location step.
  static const _filters = [
    _Filter('Nearby', 'A taste of Pampanga', null),
    _Filter('Sisig', 'Sisig favorites', 'sisig'),
    _Filter('Heritage', 'Heritage tables', 'heritage'),
  ];

  int _filter = 0;

  final _searchController = TextEditingController();
  String _query = '';

  /// The spots request. Replaced on Retry or pull-to-refresh.
  late Future<PlacesResult> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = PlacesService.instance.fetchPlaces();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() => _placesFuture = PlacesService.instance.fetchPlaces());
  }

  /// Pull-to-refresh: load again and wait for the result.
  Future<void> _refresh() async {
    _reload();
    try {
      await _placesFuture;
    } catch (_) {
      // The error state is shown by the FutureBuilder.
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  void _openPlace(Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RestaurantDetailScreen(place: place)),
    );
  }

  void _openLearn() => MainShell.goTo(context, MainShell.learn);

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    // The bottom nav lives in MainShell, so it stays still between tabs.
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<PlacesResult>(
          future: _placesFuture,
          builder: (context, snapshot) {
            final loading = snapshot.connectionState != ConnectionState.done;
            final result = loading || snapshot.hasError ? null : snapshot.data;
            return RefreshIndicator(
              onRefresh: _refresh,
              color: c.accent,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  _PlacesHeader(onLearn: _openLearn),
                  // Figma: offline banner sits under the header.
                  if (result != null && result.isOffline) ...[
                    const SizedBox(height: 12),
                    const _OfflineNotice(),
                  ],
                  const SizedBox(height: 14),
                  _SearchField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: 2),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_filters.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterPill(
                            label: _filters[i].label,
                            selected: _filter == i,
                            onTap: () => setState(() => _filter = i),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (loading)
                    _LoadingList(title: _filters[_filter].title)
                  else if (snapshot.hasError)
                    _buildError(snapshot.error)
                  else
                    _buildPlaces(result!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Error and offline (nothing cached) states.
  Widget _buildError(Object? error) {
    final offline = error is PlacesException && error.isOffline;
    return StatusMessage(
      icon: offline ? Icons.wifi_off : Icons.error_outline,
      title: offline ? "You're offline" : 'Something went wrong',
      message: error is PlacesException
          ? error.message
          : 'Could not load places. Please try again.',
      actionLabel: 'Retry',
      onAction: _reload,
    );
  }

  /// The list of spots, or the empty / no-results state.
  Widget _buildPlaces(PlacesResult result) {
    // Empty state: Firestore has no spots yet.
    if (result.places.isEmpty) {
      return StatusMessage(
        icon: Icons.place_outlined,
        title: 'No places yet',
        message: 'New places will show up here soon.',
        actionLabel: 'Retry',
        onAction: _reload,
      );
    }

    final filter = _filters[_filter];
    final query = _query.trim();
    final shown = result.places.where((place) {
      final tagOk = filter.tag == null ||
          place.tags.any((t) => t.toLowerCase().contains(filter.tag!));
      return tagOk && place.matches(query);
    }).toList();

    // Figma: searching changes the title to: Results for "sisig".
    final title = query.isEmpty ? filter.title : 'Results for "$query"';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ListTitle(title: title, count: shown.length),
        const SizedBox(height: 10),
        // No Results state (workflow.md): nothing matched.
        if (shown.isEmpty)
          StatusMessage(
            icon: Icons.search_off,
            title: 'No results',
            message: query.isEmpty
                ? 'No places in this group yet.'
                : 'No places match "$query". Try another food or city.',
            actionLabel: query.isEmpty ? null : 'Clear search',
            onAction: query.isEmpty ? null : _clearSearch,
          )
        else ...[
          ...shown.map(
            (place) => _PlaceCard(
              place: place,
              onTap: () => _openPlace(place),
            ),
          ),
          // Figma: "Clear search" button under search results.
          if (query.isNotEmpty) ...[
            const SizedBox(height: 4),
            SecondaryButton(label: 'Clear search', onPressed: _clearSearch),
          ],
        ],
      ],
    );
  }
}

/// Blue header card: "Eat like / you belong." with a shortcut to Learn.
class _PlacesHeader extends StatelessWidget {
  const _PlacesHeader({required this.onLearn});

  final VoidCallback onLearn;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 14, 18),
      decoration: BoxDecoration(
        color: c.heroSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PAMPANGA / LOCAL TABLES',
                  style: AppText.label.copyWith(color: c.heroInk),
                ),
                const SizedBox(height: 8),
                // Figma: Lora heading in yellow.
                Text(
                  'Eat like\nyou belong.',
                  style: AppText.h1.copyWith(
                    fontSize: 32,
                    color: c.highlight,
                  ),
                ),
              ],
            ),
          ),
          // Figma: round soft-blue button with a book icon. Opens Learn.
          IconButton(
            onPressed: onLearn,
            tooltip: 'Learn Kapampangan phrases',
            style: IconButton.styleFrom(
              backgroundColor: c.soft,
              foregroundColor: c.ink,
              minimumSize: const Size(52, 52), // 48dp+ touch target
            ),
            icon: const Icon(Icons.menu_book_outlined, size: 24),
          ),
        ],
      ),
    );
  }
}

/// Figma offline frame: soft box under the header. Pull down to retry.
class _OfflineNotice extends StatelessWidget {
  const _OfflineNotice();

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: c.soft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You're offline",
              style: AppText.small.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: c.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Your saved places are still available.',
              style: AppText.small.copyWith(color: c.muted),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Search food or city" field.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14), // Figma: rounded search bar
      borderSide: BorderSide(color: c.line),
    );
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(fontSize: 16, color: c.ink),
      cursorColor: c.accent,
      decoration: InputDecoration(
        hintText: 'Search food or city',
        hintStyle: TextStyle(fontSize: 16, color: c.muted),
        prefixIcon: Icon(Icons.search, size: 24, color: c.ink),
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: c.accent, width: 2),
        ),
      ),
    );
  }
}

/// List title row: "A taste of Pampanga ........ 2 places".
class _ListTitle extends StatelessWidget {
  const _ListTitle({required this.title, this.count});

  final String title;

  /// Hidden while loading.
  final int? count;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
        ),
        if (count != null)
          Text(
            count == 1 ? '1 place' : '$count places',
            style: AppText.small.copyWith(color: c.muted),
          ),
      ],
    );
  }
}

/// Figma loading frame: grey skeleton cards instead of a spinner.
class _LoadingList extends StatelessWidget {
  const _LoadingList({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: c.soft,
            borderRadius: BorderRadius.circular(4),
          ),
        );
    Widget card() => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surface,
            border: Border.all(color: c.line),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bar(120, 14),
              const SizedBox(height: 8),
              bar(80, 10),
              const SizedBox(height: 14),
              bar(double.infinity, 48),
            ],
          ),
        );
    return Semantics(
      label: 'Loading places',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ListTitle(title: title),
          const SizedBox(height: 10),
          ExcludeSemantics(child: Column(children: [card(), card()])),
        ],
      ),
    );
  }
}

/// One spot: name, city, tags, star, and its Kapampangan phrase.
class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.onTap});

  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    // Tags are accent blue in Figma; in dark mode accent is too dim on the
    // card, so use ink there to keep WCAG AA contrast.
    final tagColor =
        Theme.of(context).brightness == Brightness.dark ? c.ink : c.accent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: c.line),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 6, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.name,
                              style: AppText.body.copyWith(
                                fontSize: 19,
                                height: 1.25,
                                fontWeight: FontWeight.w600,
                                color: c.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              place.city,
                              style: AppText.body.copyWith(color: c.muted),
                            ),
                            if (place.tags.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              // Figma: tags as plain text, "Sisig · Local favorite".
                              Text(
                                place.tags.join('  ·  '),
                                style: AppText.small.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: tagColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    _SaveStar(place: place),
                  ],
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _PhraseBox(phrase: place.phrase),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Star that saves or unsaves a place (workflow.md: "tap star").
class _SaveStar extends StatelessWidget {
  const _SaveStar({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    final store = SavedStore.instance;
    // Rebuild only the star when the saved list changes.
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final saved = store.isSaved(place);
        return IconButton(
          onPressed: () => store.toggle(place),
          tooltip: saved
              ? 'Remove ${place.name} from saved'
              : 'Save ${place.name}',
          isSelected: saved,
          color: c.ink,
          iconSize: 26,
          icon: const Icon(Icons.star_border),
          selectedIcon: const Icon(Icons.star),
        );
      },
    );
  }
}

/// Soft blue box with the Kapampangan phrase and its English meaning.
class _PhraseBox extends StatelessWidget {
  const _PhraseBox({required this.phrase});

  final Phrase phrase;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    if (phrase.kapampangan.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: c.soft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phrase.kapampangan,
            style: AppText.body.copyWith(
              fontSize: 19,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: c.ink,
            ),
          ),
          if (phrase.english.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              phrase.english,
              style: AppText.body.copyWith(color: c.muted),
            ),
          ],
        ],
      ),
    );
  }
}
