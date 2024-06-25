import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:laundromat/state/state.dart';
import 'package:laundromat/utils/folder_picker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/toast.dart';

class SortState {
  initState() async {
    await checkAndRequestPermissions();
  }

  final OnAudioQuery _onAudioQuery = OnAudioQuery();

  bool _hasPermission = false;
  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _onAudioQuery.checkAndRequest(
      retryRequest: retry,
    );
    await _allFilesPermissionRequest();
  }

  _allFilesPermissionRequest() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
  }

  bool confirmPermissions() {
    if (_hasPermission) {
      return true;
    } else {
      return false;
    }
  }

  SortType sortType = SortType.album;
  String? queryPath;
  String? outputPath;

  setQueryPath(String initPath, context) async {
    String? path = await pickFolderPath(initPath, context);
    if (path != null) {
      queryPath = path;
    }
  }

  setOutputPath(String initPath, context) async {
    String? path = await pickFolderPath(initPath, context);
    if (path != null) {
      outputPath = path;
    }
  }

  List<Album>? _albumsToSort;
  List<Album> albumsToDisplay = [];
  StreamController<List<Album>> albumsDisplayStream =
      StreamController.broadcast();

  bool queryOngoing = false;
  StreamController<bool> queryOngoingStream = StreamController.broadcast();

  _updateQueryOngoingState(bool state) {
    queryOngoing = state;
    queryOngoingStream.add(state);
  }

  initQuery() async {
    if (queryPath != null) {
      _updateQueryOngoingState(true);
      await _query();
      _updateQueryOngoingState(false);
      await _displayQueryResult();
    }
  }

  initSort() async {
    if (_albumsToSort != null &&
        _albumsToSort!.isNotEmpty &&
        outputPath != null) {
      await _sort();
    }
  }

  _displayQueryResult() {
    albumsToDisplay = _albumsToSort!;
    albumsDisplayStream.add(_albumsToSort!);
    interfaceState.controller.jumpToPage(1);
  }

  _query() async {
    List<SongModel> allSongs = await _onAudioQuery.querySongs(path: queryPath!);
    List<Track> tracks = allSongs
        .map((song) => Track(
              id: song.id,
              albumId: song.albumId,
              title: song.title,
              trackNumber: song.track ?? 0,
              artists: song.artist,
              path: song.data,
            ))
        .toList();
    List<AlbumModel> allAlbums = await _onAudioQuery.queryAlbums();
    Map<int, List<Track>> albumMap = {};
    _albumsToSort = [];

    for (AlbumModel album in allAlbums) {
      albumMap[album.id] = [];
    }

    for (Track track in tracks) {
      albumMap[track.albumId]?.add(track);
    }

    for (List<Track> albumTracks in albumMap.values) {
      if (albumTracks.isNotEmpty) {
        albumTracks.sort((a, b) => a.trackNumber!.compareTo(b.trackNumber!));
        AlbumModel thisAlbumModel =
            allAlbums.firstWhere((album) => album.id == albumTracks[0].albumId);
        final Album currentAlbum = Album(
          id: thisAlbumModel.id,
          albumArt: await _getAlbumArt(thisAlbumModel.id),
          albumArtist: thisAlbumModel.artist ?? "Unknown Artist",
          albumTracks: albumTracks,
          albumTitle: thisAlbumModel.album,
        );
        _albumsToSort!.add(currentAlbum);
      }
    }
  }

  Future<Uint8List?> _getAlbumArt(int id) async {
    final Uint8List? art =
        await _onAudioQuery.queryArtwork(id, ArtworkType.ALBUM);
    return art;
  }

  _sort() async {
    for (Album album in _albumsToSort!) {
      await _createAndMoveToNewPath(album);
    }
  }

  _createAndMoveToNewPath(Album album) async {
    String albumPathSuffix = "${album.albumArtist} - ${album.albumTitle}";
    String forbiddenChars = r'^[/\?%*:|"<>]';
    for (String i in forbiddenChars.split("")) {
      albumPathSuffix = albumPathSuffix.replaceAll(i, '-');
    }
    final String albumPath = "$outputPath/$albumPathSuffix";
    for (Track track in album.albumTracks!) {
      String parentPath = File(track.path!).parent.path;
      String trackName = track.path!.split("$parentPath/")[1];
      String newTrackPath = "$albumPath/$trackName";
      try {
        await _moveToNewPath(track.path!, newTrackPath);
      } catch (e) {
        showToast(e.toString());
      }
    }
  }

  _moveToNewPath(String oldPath, String newPath) async {
    File oldFile = File(oldPath);
    await File(newPath).create(recursive: true);
    await oldFile.rename(newPath);
  }
}

enum SortType { album, artist }

class Album {
  int? id;
  String? albumTitle;
  String? albumArtist;
  Uint8List? albumArt;
  List<Track>? albumTracks;
  Album({
    this.id,
    this.albumTitle,
    this.albumArtist,
    this.albumArt,
    this.albumTracks,
  });
}

class Track {
  int? id;
  int? albumId;
  String? title;
  int? trackNumber;
  String? artists;
  String? path;
  Track({
    this.id,
    this.albumId,
    this.title,
    this.trackNumber,
    this.artists,
    this.path,
  });
}
