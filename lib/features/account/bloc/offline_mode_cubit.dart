import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../../core/services/sync_service.dart';
import '../../../../core/services/offline_mode_service.dart';
import '../../../../core/data/services/connectivity_service.dart';
import '../../dashboard/data/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import '../../../app.dart'; // Import for rootScaffoldMessengerKey

class OfflineModeCubit extends Cubit<bool> {
  final OfflineModeService _service;
  final TransactionRepository _transactionRepository;
  final ConnectivityService _connectivityService;
  final SyncService _syncService;
  StreamSubscription? _subscription;

  OfflineModeCubit(
    this._service,
    this._transactionRepository,
    this._connectivityService,
    this._syncService,
  ) : super(_service.isOfflineMode) {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _subscription = _connectivityService.onConnectivityChanged.listen((
      isConnected,
    ) {
      if (!isConnected && !state) {
        // Lost connection -> Go Offline
        toggleOfflineMode(true);
      } else if (isConnected && state) {
        // Regained connection -> Go Online (Optional: depends on UX)
        // For "Auto", we probably want to go back online to sync
        toggleOfflineMode(false);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> toggleOfflineMode(bool value) async {
    print('📱 CUBIT: toggleOfflineMode($value)');
    await _service.setOfflineMode(value);
    emit(value);

    if (!value) {
      // Trigger sync when going online
      print('📱 CUBIT: Going ONLINE, starting sync...');

      try {
        print('📱 CUBIT: Calling syncPendingTransactions...');
        await _transactionRepository.syncPendingTransactions();
        print('📱 CUBIT: syncPendingTransactions DONE');
      } catch (e) {
        print('📱 CUBIT: syncPendingTransactions FAILED: $e');
      }

      _showSnackbar('Mulai Sinkronisasi...', Colors.blue);

      try {
        // Give Supabase a moment to process updates before fetching fresh data
        print('📱 CUBIT: Waiting 2s for Supabase...');
        await Future.delayed(const Duration(seconds: 2));

        print('📱 CUBIT: Calling syncAllData...');
        await _syncService.syncAllData(); // Then fetch latest data
        print('📱 CUBIT: syncAllData DONE');

        // NOTE: Dashboard will refresh when user navigates to it
        // since syncAllData updates the cache

        _showSnackbar('Sinkronisasi Berhasil!', Colors.green);
      } catch (e) {
        print('📱 CUBIT: syncAllData FAILED: $e');
        _showSnackbar('Gagal Sinkronisasi: $e', Colors.red);
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
