/// Base class untuk Comic events
abstract class ComicEvent {}

/// Load all comics (featured + all)
class LoadComics extends ComicEvent {}

/// Load comic detail by ID
class LoadComicDetail extends ComicEvent {
  final String comicId;
  LoadComicDetail(this.comicId);
}

/// Start reading episode
class StartEpisode extends ComicEvent {
  final String episodeId;
  StartEpisode(this.episodeId);
}

/// Update page position
class UpdatePage extends ComicEvent {
  final int page;
  UpdatePage(this.page);
}

/// Save progress and exit reader
class SaveProgress extends ComicEvent {}

/// Clear selected comic (when navigating back)
class ClearSelectedComic extends ComicEvent {}
