# docker-postgres-12-zhparser-postgis

> Self-use postgres docker image with following changes

## Extensions

1. postgresql-contrib `with pg_stat_statements enable`
1. [zhparser](https://github.com/amutu/zhparser/) `full-text search of Chinese`
1. [pg-safeupdate](https://github.com/eradman/pg-safeupdate) `require SQL Where Clause in update/delete`
1. [pg_cron](https://github.com/citusdata/pg_cron) `run cron job`
1. [postgis](https://github.com/postgis/docker-postgis/tree/master/12-3.3) `postgis`

## Cofnig

1. `default_text_search_config` set to `'chinese'` to use zhparser
1. `pg_stat_statements`, `safeupdate` load by default
1. `max_replication_slots` if `USE_REPLICATION` env is set

more in [this file](https://github.com/fengkx/postgres-docker/blob/master/init_extension.sh)

## Build

```shell
# amd64
docker build -t postgres-12-zhparser-postgis:latest -f ./Dockerfile .
docker save -o postgres-12-zhparser-postgis postgres-13-zhparser-postgis:latest
docker load -i postgres-12-zhparser-postgis
# arm64
docker build -t postgres-12-zhparser-postgis-arm:latest -f ./DockerfileArm64 .
docker save -o postgres-12-zhparser-postgis-arm postgres-13-zhparser-postgis-arm:latest
docker load -i postgres-12-zhparser-postgis-arm
```

## Run

```shell
docker run --name postgres-12 -e POSTGRES_PASSWORD=<PASSWORD> -p <PORT>:5432 -d postgres-13-zhparser-postgis:latest
```

## Using

```sql
psql -d <database>

SELECT to_tsvector('chinese', '人生苦短，乘早摸鱼，Good Morning~');
                      to_tsvector
--------------------------------------------------------
'good':8 'morning':9 '乘':4 '人生':1 '摸':6 '早':5 '短':3 '苦':2 '鱼':7

-- add custom dict
insert into zhprs_custom_word values ('摸鱼');
insert into zhprs_custom_word values ('荒天帝');
insert into zhprs_custom_word values ('独断万古');
insert into zhprs_custom_word values ('人生苦短');
-- make effect
select sync_zhprs_custom_word();

-- test
SELECT * FROM ts_parse('zhparser', '人生苦短，爆炸吧，小宇宙，独断万古荒天帝，摸鱼ing，Good Morning~');
SELECT to_tsquery('chinese', '荒天帝石昊');
SELECT to_tsvector('chinese', '人生苦短，爆炸吧，小宇宙，独断万古荒天帝，摸鱼ing，Good Morning~');
```

## Backup Data

```shell
docker exec -it postgres-12 pg_dump -Upostgres > backup.sql
```
