import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/comic_repository.dart';
import 'comic_event.dart';
import 'comic_state.dart';

class ComicBloc extends Bloc<ComicEvent, ComicState> {
  final ComicRepository _repository;

  ComicBloc({required ComicRepository repository})
    : _repository = repository,
      super(ComicState.initial()) {
    on<LoadComics>(_onLoadComics);
    on<LoadComicDetail>(_onLoadComicDetail);
    on<StartEpisode>(_onStartEpisode);
    on<UpdatePage>(_onUpdatePage);
    on<SaveProgress>(_onSaveProgress);
    on<ClearSelectedComic>(_onClearSelectedComic);
  }

  Future<void> _onLoadComics(LoadComics event, Emitter<ComicState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final featured = await _repository.getFeaturedComics();
      final all = await _repository.getComics();

      emit(
        state.copyWith(
          isLoading: false,
          featuredComics: featured,
          allComics: all,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat komik: $e',
        ),
      );
    }
  }

  Future<void> _onLoadComicDetail(
    LoadComicDetail event,
    Emitter<ComicState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final comic = await _repository.getComicById(event.comicId);
      if (comic == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Komik tidak ditemukan',
          ),
        );
        return;
      }

      final episodes = await _repository.getEpisodes(event.comicId);
      final progress = await _repository.getProgress(event.comicId);

      emit(
        state.copyWith(
          isLoading: false,
          selectedComic: comic,
          episodes: episodes,
          progress: progress,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat detail: $e',
        ),
      );
    }
  }

  Future<void> _onStartEpisode(
    StartEpisode event,
    Emitter<ComicState> emit,
  ) async {
    final episode = state.episodes.firstWhere(
      (e) => e.id == event.episodeId,
      orElse: () => state.episodes.first,
    );

    emit(state.copyWith(currentEpisode: episode, currentPage: 0));
  }

  void _onUpdatePage(UpdatePage event, Emitter<ComicState> emit) {
    emit(state.copyWith(currentPage: event.page));
  }

  Future<void> _onSaveProgress(
    SaveProgress event,
    Emitter<ComicState> emit,
  ) async {
    if (state.selectedComic == null || state.currentEpisode == null) return;

    try {
      final isLastPage =
          state.currentPage >= (state.currentEpisode!.gambarUrls.length - 1);
      final isLastEpisode =
          state.currentEpisode!.nomorEpisode >= state.episodes.length;
      final isComplete = isLastPage && isLastEpisode;

      final progress = await _repository.updateProgress(
        komikId: state.selectedComic!.id,
        episodeTerakhir: state.currentEpisode!.nomorEpisode,
        halamanTerakhir: state.currentPage,
        selesai: isComplete,
      );

      emit(state.copyWith(progress: progress));
    } catch (e) {
      // Silently fail - progress saving is not critical
    }
  }

  void _onClearSelectedComic(
    ClearSelectedComic event,
    Emitter<ComicState> emit,
  ) {
    emit(
      state.copyWith(
        clearSelectedComic: true,
        episodes: [],
        progress: null,
        currentEpisode: null,
        currentPage: 0,
      ),
    );
  }
}
