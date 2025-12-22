import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/featurea_repository.dart';
import 'featurea_event.dart';
import 'featurea_state.dart';

class FeatureABloc extends Bloc<FeatureAEvent, FeatureAState> {
  final FeatureARepository repository;

  FeatureABloc(this.repository) : super(FeatureAInitial()) {
    on<LoadFeatureA>((event, emit) async {
      emit(FeatureALoading());
      try {
        final data = await repository.getTransactions();
        emit(FeatureALoaded(data));
      } catch (e) {
        emit(FeatureAError('Gagal memuat data'));
      }
    });
  }
}
