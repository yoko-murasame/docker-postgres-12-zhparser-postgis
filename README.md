# postgres-docker

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

```shel
docker build -t postgres-12-zhparser-postgis:1.0 .
```

## Run

```shell
docker run --name postgres-12 -e POSTGRES_PASSWORD=<PASSWORD> -p <PORT>:5432 -d postgres-12-zhparser-postgis:1.0
```

## Using

```sql
psql -d <database>
-- CREATE EXTENSION zhparser;
-- CREATE TEXT SEARCH CONFIGURATION chinese (PARSER = zhparser);
-- ALTER TEXT SEARCH CONFIGURATION chinese
-- ADD MAPPING FOR a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
-- WITH simple;

SELECT to_tsvector('chinese', '人生苦短，乘早摸鱼，Good Morning~');
                      to_tsvector
--------------------------------------------------------
'good':8 'morning':9 '乘':4 '人生':1 '摸':6 '早':5 '短':3 '苦':2 '鱼':7
```

## Backup Data

```shell
docker exec -it postgres-12 pg_dump -Upostgres > backup.sql
```
