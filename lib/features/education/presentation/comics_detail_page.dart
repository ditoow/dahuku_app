import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../bloc/comic_bloc.dart';
import '../bloc/comic_event.dart';
import '../bloc/comic_state.dart';
import '../data/models/comic_model.dart';

/// Comics detail page showing comic info and episodes
class ComicsDetailPage extends StatelessWidget {
  final String comicId;

  const ComicsDetailPage({super.key, required this.comicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ComicBloc>()..add(LoadComicDetail(comicId)),
      child: const _ComicsDetailContent(),
    );
  }
}

class _ComicsDetailContent extends StatelessWidget {
  const _ComicsDetailContent();

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicBloc, ComicState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.bgPage,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.selectedComic == null) {
          return Scaffold(
            backgroundColor: AppColors.bgPage,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Text(
                state.errorMessage ?? 'Komik tidak ditemukan',
                style: GoogleFonts.poppins(color: AppColors.textSub),
              ),
            ),
          );
        }

        final comic = state.selectedComic!;
        final themeColor = _parseColor(comic.warnaTema);

        return Scaffold(
          backgroundColor: AppColors.bgPage,
          body: CustomScrollView(
            slivers: [
              // Hero header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: themeColor,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [themeColor, themeColor.withAlpha(180)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              comic.judul,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (comic.deskripsi != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                comic.deskripsi!,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.white.withAlpha(204),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats row
                      Row(
                        children: [
                          _buildStatChip(
                            Icons.book,
                            '${state.episodes.length} Episode',
                            themeColor,
                          ),
                          const SizedBox(width: 12),
                          _buildStatChip(
                            Icons.category,
                            comic.kategori,
                            themeColor,
                          ),
                          if (state.progress != null) ...[
                            const SizedBox(width: 12),
                            _buildStatChip(
                              state.progress!.selesai
                                  ? Icons.check_circle
                                  : Icons.play_circle,
                              state.progress!.selesai
                                  ? 'Selesai'
                                  : 'Ep ${state.progress!.episodeTerakhir}',
                              state.progress!.selesai
                                  ? Colors.green
                                  : themeColor,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Continue reading button
                      if (state.episodes.isNotEmpty) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final startEpisode = state.progress != null
                                  ? state.episodes.firstWhere(
                                      (e) =>
                                          e.nomorEpisode ==
                                          state.progress!.episodeTerakhir,
                                      orElse: () => state.episodes.first,
                                    )
                                  : state.episodes.first;

                              _openReader(
                                context,
                                startEpisode,
                                state.episodes,
                              );
                            },
                            icon: Icon(
                              state.progress != null
                                  ? Icons.play_arrow
                                  : Icons.menu_book,
                            ),
                            label: Text(
                              state.progress != null
                                  ? 'Lanjut Baca'
                                  : 'Mulai Baca',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Episodes list
                      Text(
                        'Daftar Episode',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (state.episodes.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Belum ada episode',
                              style: GoogleFonts.poppins(
                                color: AppColors.textSub,
                              ),
                            ),
                          ),
                        )
                      else
                        ...state.episodes.map((episode) {
                          final isRead =
                              state.progress != null &&
                              episode.nomorEpisode <=
                                  state.progress!.episodeTerakhir;

                          return _buildEpisodeCard(
                            context,
                            episode,
                            themeColor,
                            isRead,
                            state.episodes,
                          );
                        }),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeCard(
    BuildContext context,
    EpisodeModel episode,
    Color themeColor,
    bool isRead,
    List<EpisodeModel> allEpisodes,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openReader(context, episode, allEpisodes),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRead ? themeColor.withAlpha(77) : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${episode.nomorEpisode}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        episode.judul,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${episode.gambarUrls.length} episode',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSub,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isRead)
                  Icon(Icons.check_circle, color: themeColor, size: 24)
                else
                  Icon(
                    Icons.play_circle_outline,
                    color: AppColors.textLight,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openReader(
    BuildContext context,
    EpisodeModel episode,
    List<EpisodeModel> allEpisodes,
  ) {
    context.read<ComicBloc>().add(StartEpisode(episode.id));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => BlocProvider.value(
          value: context.read<ComicBloc>(),
          child: _ComicReaderPage(episode: episode, allEpisodes: allEpisodes),
        ),
      ),
    );
  }
}

/// Simple comic reader page with navigation buttons
class _ComicReaderPage extends StatefulWidget {
  final EpisodeModel episode;
  final List<EpisodeModel> allEpisodes;

  const _ComicReaderPage({required this.episode, required this.allEpisodes});

  @override
  State<_ComicReaderPage> createState() => _ComicReaderPageState();
}

class _ComicReaderPageState extends State<_ComicReaderPage> {
  late EpisodeModel _currentEpisode;
  late int _currentEpisodeIndex;

  @override
  void initState() {
    super.initState();
    _currentEpisode = widget.episode;
    _currentEpisodeIndex = widget.allEpisodes.indexWhere(
      (e) => e.id == widget.episode.id,
    );
  }

  void _goToEpisode(int index) {
    if (index >= 0 && index < widget.allEpisodes.length) {
      setState(() {
        _currentEpisodeIndex = index;
        _currentEpisode = widget.allEpisodes[index];
      });
      context.read<ComicBloc>().add(StartEpisode(_currentEpisode.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicBloc, ComicState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text(
              'Episode ${_currentEpisode.nomorEpisode}: ${_currentEpisode.judul}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context.read<ComicBloc>().add(SaveProgress());
                Navigator.pop(context);
              },
            ),
          ),
          body: _currentEpisode.gambarUrls.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada gambar',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                )
              : SingleChildScrollView(
                  child: Image.network(
                    _currentEpisode.gambarUrls.first,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                : null,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Gagal memuat gambar',
                            style: GoogleFonts.poppins(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.black,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  IconButton(
                    onPressed: _currentEpisodeIndex > 0
                        ? () => _goToEpisode(_currentEpisodeIndex - 1)
                        : null,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: _currentEpisodeIndex > 0
                          ? Colors.white
                          : Colors.white24,
                    ),
                  ),
                  // Episode indicator
                  Text(
                    'Episode ${_currentEpisodeIndex + 1} / ${widget.allEpisodes.length}',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  // Next button
                  IconButton(
                    onPressed:
                        _currentEpisodeIndex < widget.allEpisodes.length - 1
                        ? () => _goToEpisode(_currentEpisodeIndex + 1)
                        : null,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color:
                          _currentEpisodeIndex < widget.allEpisodes.length - 1
                          ? Colors.white
                          : Colors.white24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
