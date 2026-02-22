SELECT name, setting, unit
FROM pg_settings
WHERE name IN (
  'shared_buffers','effective_cache_size','work_mem','maintenance_work_mem',
  'max_wal_size','min_wal_size','checkpoint_completion_target',
  'random_page_cost','effective_io_concurrency',
  'max_connections','shared_preload_libraries'
)
ORDER BY name;