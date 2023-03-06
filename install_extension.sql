-- Install zhparser
CREATE EXTENSION zhparser;
CREATE TEXT SEARCH CONFIGURATION chinese (PARSER = zhparser);
-- add full lexical category
ALTER TEXT SEARCH CONFIGURATION chinese ADD MAPPING FOR a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z WITH simple;

--- Install pg_stat_statements
CREATE EXTENSION pg_stat_statements;
