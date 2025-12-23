import 'package:equatable/equatable.dart';
import '../data/models/comic_model.dart';

/// State untuk Comics feature
class ComicState extends Equatable {
  final bool isLoading;
  final List<ComicModel> featuredComics;
  final List<ComicModel> allComics;
  final ComicModel? selectedComic;
  final List<EpisodeModel> episodes;
  final ComicProgressModel? progress;
  final EpisodeModel? currentEpisode;
  final int currentPage;
  final String? errorMessage;

  const ComicState({
    this.isLoading = true,
    this.featuredComics = const [],
    this.allComics = const [],
    this.selectedComic,
    this.episodes = const [],
    this.progress,
    this.currentEpisode,
    this.currentPage = 0,
    this.errorMessage,
  });

  factory ComicState.initial() => const ComicState();

  ComicState copyWith({
    bool? isLoading,
    List<ComicModel>? featuredComics,
    List<ComicModel>? allComics,
    ComicModel? selectedComic,
    List<EpisodeModel>? episodes,
    ComicProgressModel? progress,
    EpisodeModel? currentEpisode,
    int? currentPage,
    String? errorMessage,
    bool clearError = false,
    bool clearSelectedComic = false,
  }) {
    return ComicState(
      isLoading: isLoading ?? this.isLoading,
      featuredComics: featuredComics ?? this.featuredComics,
      allComics: allComics ?? this.allComics,
      selectedComic: clearSelectedComic
          ? null
          : (selectedComic ?? this.selectedComic),
      episodes: episodes ?? this.episodes,
      progress: progress ?? this.progress,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    featuredComics,
    allComics,
    selectedComic,
    episodes,
    progress,
    currentEpisode,
    currentPage,
    errorMessage,
  ];
}
