DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
COMMENT ON SCHEMA public IS 'standard public schema';


CREATE OR REPLACE FUNCTION next_id(IN table_name varchar(50), OUT result bigint) AS $$
-- Reference: http://instagram-engineering.tumblr.com/post/10853187575/sharding-ids-at-instagram
-- http://stackoverflow.com/questions/17512611/instragrams-uuid-creation-failing
DECLARE
    our_epoch bigint := 1314220021721;
    seq_id bigint;
    now_millis bigint;
    shard_id int := 1;
BEGIN
    SELECT nextval('seq_' || table_name || '_id') % 1024 INTO seq_id;

    SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
    result := (now_millis - our_epoch) << 23;
    result := result | (shard_id << 10);
    result := result | (seq_id);
END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION update_version_and_updated_at()
	RETURNS TRIGGER AS $$
		BEGIN
			NEW.updated_at = now();
			NEW.version = OLD.version + 1;
			RETURN NEW;
		END;
$$ LANGUAGE PLPGSQL;

CREATE SEQUENCE seq_person_id;

CREATE TABLE person (
	id bigint PRIMARY KEY DEFAULT next_id('person'),
	email varchar(255) UNIQUE NOT NULL
		CHECK (email ~* '\A[[:alnum:]_\-\.]+@[a-z[:digit:]\-\.]+\.[a-z]+'),
	last_name varchar(50),
		CHECK (last_name <> '' AND last_name !~ ' {2,}' AND last_name = TRIM(last_name)),
	first_name varchar(50),
		CHECK (first_name <> '' AND first_name !~ ' {2,}' AND first_name = TRIM(first_name)),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_app_user_id;

CREATE TABLE app_user (
	id bigint PRIMARY KEY DEFAULT next_id('app_user'),
	name varchar(50),
	person_id bigint NOT NULL,
	password_salt varchar(255), -- NOT NULL
	password_digest varchar(255), -- NOT NULL
	password_last_changed timestamp NOT NULL DEFAULT current_timestamp,
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);


-- Populate seed values before making triggers and FK constraints
-- For prod system, these values need to be obtained during initial configuration prior to DB creation
SELECT * FROM INSERT INTO person(email, last_name, first_name, created_by, updated_by)
	VALUES('lbmaxwelll@gmail.com', 'Maxwell', 'Lewis', 1,1)
	RETURNING id INTO  first_person_id;

INSERT INTO app_user(username, personId)
		VALUES('lbmaxwell', (SELECT MIN(id) FROM person;))
		RETURNING id;

UPDATE person(created_by, updated_by)
	VALUES(first_user_i, first_user_id);

UPDATE app_user(created_by, updated_by)
	VALUES(first_user_id, first_user_id);

CREATE TRIGGER trg_person_update
	BEFORE UPDATE ON person FOR EACH ROW
		EXECUTE PROCEDURE update_version_and_updated_at();

CREATE TRIGGER trg_app_user_update
	BEFORE UPDATE ON app_user FOR EACH ROW
		EXECUTE PROCEDURE update_version_and_updated_at();


/*
-- Plan to place FK in app_user table from this one
-- This table will store settings for LDAP or other auth services
CREATE TABLE authentication_provider(
	id bigint PRIMARY KEY DEFAULT next_id(),
);
*/

CREATE SEQUENCE seq_campaign_id; 

CREATE TABLE campaign (
	id bigint PRIMARY KEY DEFAULT next_id('campaign'),
	name varchar(100),
	startDate date,
	endDate date,
	isClosed boolean DEFAULT FALSE
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE TRIGGER trg_campaign_update
	BEFORE UPDATE ON compaign FOR EACH ROW
		EXECUTE PROCEDURE update_version_and_updated_at();


CREATE SEQUENCE seq_system_id; 

CREATE TABLE system (
	id bigint PRIMARY KEY DEFAULT next_id('system'),
	name varchar(100) NOT NULL,
	description varchar(1000),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE TRIGGER trg_system_update
	BEFORE UPDATE ON system FOR EACH ROW
		EXECUTE PROCEDURE update_version_and_updated_at();

CREATE SEQUENCE seq_system_ownership_id; 

CREATE TABLE system_ownership (
	id bigint PRIMARY KEY DEFAULT next_id('system_ownership'),
	system_id NOT NULL REFERENCES system(id),
	person_id NOT NULL REFERENCES person(id),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_import_id; 

CREATE TABLE import (
	id bigint PRIMARY KEY DEFAULT next_id('import'),
	campaign_id NOT NULL REFERENCES campaign(id),
	system_id NOT NULL REFERENCES system(id),
	import_date date NOT NULL,
	data_source varchar(100),
	source_query text,
	raw_data text,
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_entitlement_id; 

CREATE TABLE entitlement (
	id bigint PRIMARY KEY DEFAULT next_id('entitlement'),
	system_id NOT NULL REFERENCES system(id),
	name varchar(100) NOT NULL,
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_entitlement_ownership_id; 

CREATE TABLE entitlement_ownership (
	id bigint PRIMARY KEY DEFAULT next_id('entitlement_ownership'),
	entitlement_id NOT NULL REFERENCES entitlement(id),
	person_id NOT NULL REFERENCES person(id),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_account_id; 

CREATE TABLE account (
	id bigint PRIMARY KEY DEFAULT next_id('account'),
	name varchar(100) NOT NULL,
	system_id NOT NULL REFERENCES system(id),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_account_history_id; 

CREATE TABLE account_history (
	id bigint PRIMARY KEY DEFAULT next_id('account_history'),
	account_id NOT NULL REFERENCES account(id),
	import_id NOT NULL REFERENCES import(id),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_account_entitlement_id; 

CREATE TABLE seq_account_entitlement (
	id bigint PRIMARY KEY DEFAULT next_id('account_entitlement'),
	account_id NOT NULL REFERENCES account(id),
	entitlement_id NOT NULL REFERENCES entitlement(id),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_account_entitlement_history_id; 

CREATE TABLE seq_account_entitlement_history (
	id bigint PRIMARY KEY DEFAULT next_id('account_entitlement_history'),
	account_entitlement_id NOT NULL REFERENCES account_entitlement(id),
	import_id NOT NULL REFERENECES import(id),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);

CREATE SEQUENCE seq_review_id; 

CREATE TABLE review (
	id bigint PRIMARY KEY DEFAULT next_id('review'),
	name varchar(100) NOT NULL,
	system_id NOT NULL REFERENCES system(id),
	created_by bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT current_timestamp,
	updated_by bigint NOT NULL,
	updated_at timestamp NOT NULL DEFAULT current_timestamp,
	version integer NOT NULL DEFAULT 0
);
