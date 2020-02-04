CREATE SCHEMA authentic ;

ALTER database authentic  SET search_path TO authentic ;

CREATE ROLE prod5_1_01_minimal_user WITH
	NOSUPERUSER
	CREATEDB
	PASSWORD 'sl@l0m';

GRANT ALL PRIVILEGES ON DATABASE authentic to prod5_1_01_minimal_user;

--change owner
ALTER DATABASE authentic OWNER TO prod5_1_01_minimal_user;

-- restrict access
REVOKE CONNECT, TEMPORARY ON DATABASE authentic FROM public;