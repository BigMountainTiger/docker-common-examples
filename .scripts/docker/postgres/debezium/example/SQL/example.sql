show wal_level;
show max_replication_slots;
show max_wal_senders;

-- slot
-- output plugin - test_decoding, pgoutput, wal2json
SELECT pg_create_logical_replication_slot('replication_slot', 'test_decoding');
SELECT pg_create_logical_replication_slot('replication_slot', 'pgoutput');
SELECT slot_name, plugin, slot_type, database, active, restart_lsn, confirmed_flush_lsn FROM pg_replication_slots;


-- publication
CREATE PUBLICATION pub FOR ALL TABLES;
DROP publication if exists pub;
SELECT * FROM pg_publication_tables;


create table t (id int, name text);
INSERT INTO t(id, name)
	SELECT g.id, k.name 
	FROM generate_series(1, 10) as g(id), substr(md5(random()::text), 0, 25) as k(name);

INSERT INTO t(id, name) values(88, 'Song Li');

-- Drop slot
SELECT pg_drop_replication_slot('replication_slot');

-- peek/get changes
SELECT * FROM pg_logical_slot_peek_changes('replication_slot', NULL, NULL);
SELECT * FROM pg_logical_slot_get_changes('replication_slot', NULL, NULL);

SELECT * FROM pg_logical_slot_peek_binary_changes('replication_slot',
	null, null, 'proto_version', '1', 'publication_names', 'pub');
SELECT * FROM pg_logical_slot_get_binary_changes('replication_slot',
	null, null, 'proto_version', '1', 'publication_names', 'pub');
