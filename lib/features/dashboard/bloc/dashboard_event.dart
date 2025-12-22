import 'package:equatable/equatable.dart';

/// Dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Load dashboard data
class DashboardLoadRequested extends DashboardEvent {
  const DashboardLoadRequested();
}

/// Refresh dashboard data
class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}
