import '../data/models/featurea_model.dart';

abstract class FeatureAState {}

class FeatureAInitial extends FeatureAState {}

class FeatureALoading extends FeatureAState {}

class FeatureALoaded extends FeatureAState {
  final List<FeatureATransaction> transactions;

  FeatureALoaded(this.transactions);
}

class FeatureAError extends FeatureAState {
  final String message;

  FeatureAError(this.message);
}
