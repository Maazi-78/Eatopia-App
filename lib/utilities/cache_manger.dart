import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Create a single CacheManager instance to use across your app
final appCacheManager = CacheManager(
  Config('Eatopia-Images',
      stalePeriod: const Duration(days: 7), maxNrOfCacheObjects: 100),
);
