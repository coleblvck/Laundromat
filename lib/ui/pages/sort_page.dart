import 'package:flutter/material.dart';

import 'package:laundromat/state/interface.dart';
import 'package:laundromat/state/sort_state.dart';
import 'package:laundromat/state/state.dart';

class SortPage extends StatelessWidget {
  const SortPage({
    super.key,
  });

  startSort(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Interface.of(context).palette.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
    await sortState.initSort();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        shadowColor: Interface.of(context).palette.shadow,
        color: Interface.of(context).palette.background,
        child: StreamBuilder<List<Album>>(
          stream: sortState.albumsDisplayStream.stream,
          builder: (context, snapshot) {
            final List<Album> albums =
                snapshot.data ?? sortState.albumsToDisplay;
            return albums.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: albums.length,
                          itemBuilder: (context, index) {
                            final Album album = albums[index];
                            return CustomScrollView(
                              slivers: [
                                album.albumArt != null
                                    ? SliverToBoxAdapter(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.memory(
                                                album.albumArt!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          album.albumTitle!,
                                          style: TextStyle(
                                            color: Interface.of(context)
                                                .palette
                                                .primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          album.albumArtist!,
                                          style: TextStyle(
                                            color: Interface.of(context)
                                                .palette
                                                .primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "${album.albumTracks!.length} Tracks",
                                          style: TextStyle(
                                            color: Interface.of(context)
                                                .palette
                                                .primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverFixedExtentList.builder(
                                  itemExtent: 80,
                                  itemCount: album.albumTracks!.length,
                                  itemBuilder: (context, index) {
                                    final track = album.albumTracks![index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Card(
                                        color: Interface.of(context)
                                            .palette
                                            .secondary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                track.title!,
                                                style: TextStyle(
                                                  color: Interface.of(context)
                                                      .palette
                                                      .onSecondary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                track.artists!,
                                                style: TextStyle(
                                                  color: Interface.of(context)
                                                      .palette
                                                      .onSecondary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Text(
                                "Swipe left or right to view multiple albums",
                                style: TextStyle(
                                  color: Interface.of(context).palette.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await startSort(context);
                                  context.mounted
                                      ? Interface.of(context)
                                          .controller
                                          .jumpToPage(0)
                                      : null;
                                },
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Interface.of(context).palette.primary),
                                ),
                                child: Text(
                                  "Confirm and begin sorting",
                                  style: TextStyle(
                                    color:
                                        Interface.of(context).palette.onPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      "Nothing to see here",
                      style: TextStyle(
                        color: Interface.of(context).palette.onBackground,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
