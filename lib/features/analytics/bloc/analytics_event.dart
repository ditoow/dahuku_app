import 'analytics_state.dart';

/// Base class for analytics events
abstract class AnalyticsEvent {}

/// Load analytics data
class LoadAnalytics extends AnalyticsEvent {}

/// Refresh analytics data (pull-to-refresh)
class RefreshAnalytics extends AnalyticsEvent {}

/// Filter transactions
class FilterTransactions extends AnalyticsEvent {
  final TransactionFilter filter;
  FilterTransactions(this.filter);
}

/// Search transactions
class SearchTransactions extends AnalyticsEvent {
  final String query;
  SearchTransactions(this.query);
}
