--
-- PostgreSQL database dump
--

\restrict Hnd1UczLtaGdqkvR1PqehDgXi059KxSaTIOxIufjA79Xgkjc9IrkrhESQh9CWHc

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO postgres;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


ALTER FUNCTION storage.add_prefixes(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
            SELECT bucket_id,
                   name,
                   storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
            SELECT p.bucket_id, p.name, p.level
            FROM storage.prefixes AS p
            JOIN uniq AS u
              ON u.bucket_id = p.bucket_id
                  AND u.name = p.name
                  AND u.level = p.level
            WHERE NOT EXISTS (
                SELECT 1
                FROM storage.objects AS o
                WHERE o.bucket_id = p.bucket_id
                  AND storage.get_level(o.name) = p.level + 1
                  AND o.name COLLATE "C" LIKE p.name || '/%'
            )
            AND NOT EXISTS (
                SELECT 1
                FROM storage.prefixes AS c
                WHERE c.bucket_id = p.bucket_id
                  AND c.level = p.level + 1
                  AND c.name COLLATE "C" LIKE p.name || '/%'
            )
        )
        DELETE FROM storage.prefixes AS p
        USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


ALTER FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


ALTER FUNCTION storage.delete_prefix(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.delete_prefix_hierarchy_trigger() OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;


ALTER FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_insert_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_update_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.prefixes_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.prefixes_insert_trigger() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0,
    broadcast_adapter character varying(255) DEFAULT 'gen_rpc'::character varying,
    max_presence_events_per_second integer DEFAULT 10000,
    max_payload_size_in_kb integer DEFAULT 3000
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_id text NOT NULL,
    client_secret_hash text NOT NULL,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applications (
    app_id integer NOT NULL,
    material_id integer,
    application_type text,
    metric text,
    value numeric,
    unit text,
    notes text
);


ALTER TABLE public.applications OWNER TO postgres;

--
-- Name: applications_app_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applications_app_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applications_app_id_seq OWNER TO postgres;

--
-- Name: applications_app_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applications_app_id_seq OWNED BY public.applications.app_id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials (
    material_id integer NOT NULL,
    paper_id integer,
    mxene_composition text,
    composite_material text,
    synthesis_method text,
    fabrication_method text
);


ALTER TABLE public.materials OWNER TO postgres;

--
-- Name: materials_material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.materials_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.materials_material_id_seq OWNER TO postgres;

--
-- Name: materials_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materials_material_id_seq OWNED BY public.materials.material_id;


--
-- Name: papers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.papers (
    paper_id integer NOT NULL,
    title text,
    authors text,
    journal text,
    year integer,
    doi_url text,
    sciencedirect_url text,
    issn character varying,
    abstract text,
    keywords character varying[]
);


ALTER TABLE public.papers OWNER TO postgres;

--
-- Name: papers_paper_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.papers_paper_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.papers_paper_id_seq OWNER TO postgres;

--
-- Name: papers_paper_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.papers_paper_id_seq OWNED BY public.papers.paper_id;


--
-- Name: properties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.properties (
    property_id integer NOT NULL,
    material_id integer,
    property_type text,
    value numeric,
    unit text,
    test_conditions text
);


ALTER TABLE public.properties OWNER TO postgres;

--
-- Name: properties_property_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.properties_property_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.properties_property_id_seq OWNER TO postgres;

--
-- Name: properties_property_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.properties_property_id_seq OWNED BY public.properties.property_id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2025_10_05; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_10_05 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_10_05 OWNER TO supabase_admin;

--
-- Name: messages_2025_10_06; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_10_06 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_10_06 OWNER TO supabase_admin;

--
-- Name: messages_2025_10_07; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_10_07 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_10_07 OWNER TO supabase_admin;

--
-- Name: messages_2025_10_08; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_10_08 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_10_08 OWNER TO supabase_admin;

--
-- Name: messages_2025_10_09; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_10_09 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_10_09 OWNER TO supabase_admin;

--
-- Name: messages_2025_10_10; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_10_10 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_10_10 OWNER TO supabase_admin;

--
-- Name: messages_2025_10_11; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_10_11 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_10_11 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: iceberg_namespaces; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_namespaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.iceberg_namespaces OWNER TO supabase_storage_admin;

--
-- Name: iceberg_tables; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace_id uuid NOT NULL,
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.iceberg_tables OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE storage.prefixes OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: messages_2025_10_05; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_10_05 FOR VALUES FROM ('2025-10-05 00:00:00') TO ('2025-10-06 00:00:00');


--
-- Name: messages_2025_10_06; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_10_06 FOR VALUES FROM ('2025-10-06 00:00:00') TO ('2025-10-07 00:00:00');


--
-- Name: messages_2025_10_07; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_10_07 FOR VALUES FROM ('2025-10-07 00:00:00') TO ('2025-10-08 00:00:00');


--
-- Name: messages_2025_10_08; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_10_08 FOR VALUES FROM ('2025-10-08 00:00:00') TO ('2025-10-09 00:00:00');


--
-- Name: messages_2025_10_09; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_10_09 FOR VALUES FROM ('2025-10-09 00:00:00') TO ('2025-10-10 00:00:00');


--
-- Name: messages_2025_10_10; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_10_10 FOR VALUES FROM ('2025-10-10 00:00:00') TO ('2025-10-11 00:00:00');


--
-- Name: messages_2025_10_11; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_10_11 FOR VALUES FROM ('2025-10-11 00:00:00') TO ('2025-10-12 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: applications app_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications ALTER COLUMN app_id SET DEFAULT nextval('public.applications_app_id_seq'::regclass);


--
-- Name: materials material_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials ALTER COLUMN material_id SET DEFAULT nextval('public.materials_material_id_seq'::regclass);


--
-- Name: papers paper_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.papers ALTER COLUMN paper_id SET DEFAULT nextval('public.papers_paper_id_seq'::regclass);


--
-- Name: properties property_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.properties ALTER COLUMN property_id SET DEFAULT nextval('public.properties_property_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
aa6f1e51-db2a-445c-8bde-c59ee1c7f479	postgres_cdc_rls	{"region": "us-east-1", "db_host": "V5usjcn6PmB6ohoae87mfNpwO0j5fO3WazKKzA/81Fc=", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "sWBpZNdjggEPTQVlI52Zfw==", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2025-10-08 08:43:16	2025-10-08 08:43:16
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2025-09-11 15:17:29
20220329161857	2025-09-11 15:17:29
20220410212326	2025-09-11 15:17:29
20220506102948	2025-09-11 15:17:29
20220527210857	2025-09-11 15:17:29
20220815211129	2025-09-11 15:17:29
20220815215024	2025-09-11 15:17:29
20220818141501	2025-09-11 15:17:29
20221018173709	2025-09-11 15:17:29
20221102172703	2025-09-11 15:17:29
20221223010058	2025-09-11 15:17:29
20230110180046	2025-09-11 15:17:29
20230810220907	2025-09-11 15:17:29
20230810220924	2025-09-11 15:17:29
20231024094642	2025-09-11 15:17:29
20240306114423	2025-09-11 15:17:29
20240418082835	2025-09-11 15:17:29
20240625211759	2025-09-11 15:17:29
20240704172020	2025-09-11 15:17:29
20240902173232	2025-09-11 15:17:29
20241106103258	2025-09-11 15:17:29
20250424203323	2025-09-11 15:17:29
20250613072131	2025-09-11 15:17:29
20250711044927	2025-09-11 15:17:29
20250811121559	2025-09-11 15:17:29
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only, migrations_ran, broadcast_adapter, max_presence_events_per_second, max_payload_size_in_kb) FROM stdin;
c72008e1-4607-47ae-b136-ebdb0af6baf1	realtime-dev	realtime-dev	iNjicxc4+llvc9wovDvqymwfnj9teWMlyOIbJ8Fh6j2WNU8CIJ2ZgjR6MUIKqSmeDmvpsKLsZ9jgXJmQPpwL8w==	200	2025-10-08 08:43:16	2025-10-08 08:43:16	100	postgres_cdc_rls	100000	100	100	f	{"keys": [{"k": "c3VwZXItc2VjcmV0LWp3dC10b2tlbi13aXRoLWF0LWxlYXN0LTMyLWNoYXJhY3RlcnMtbG9uZw", "kty": "oct"}]}	f	f	64	gen_rpc	10000	3000
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applications (app_id, material_id, application_type, metric, value, unit, notes) FROM stdin;
1698	759	sensors	response_time	10.0	ms	pressure sensors have fast response recovery times
1699	759	sensors	detection_threshold	1.0	Pa	pressure sensors have low detection thresholds
1700	759	sensors	sensitivity	5.11	kPa-1	pressure mode has high sensitivity
1701	759	sensors	accuracy	98.33	%	speech recognition accuracy with MLP neural network
1702	759	sensors	sensitivity	0.63	mm-1	proximity sensor has sensitivity
1703	759	sensors	accuracy	99.85	%	material recognition accuracy with MLP neural network
1704	759	AI_applications	accuracy	98.33	%	speech recognition accuracy with MLP neural network
1705	759	AI_applications	accuracy	99.85	%	material recognition accuracy with MLP neural network
1706	760	energy_storage	capacitance_retention	100.0	%	after 9500 cycles
1707	761	energy_storage	Energy_Density	19.6	Wh/kg	Achieved at a specific power of 742.7 W/kg
1708	761	sensors	Sensitivity	2.66	μA/μM/cm²	For furazolidone detection
1709	761	sensors	Detection_Limit	16.1	nM	For furazolidone detection
1710	762	energy_storage	Energy_Density	23.8	Wh/kg	Achieved by the asymmetric supercapacitor
1711	763	energy_storage	Energy_Density	70.0	Wh/kg	for symmetric MXene-based supercapacitors
1712	763	energy_storage	Power_Density	5000.0	W/kg	for symmetric MXene-based supercapacitors
1713	763	energy_storage	Energy_Density	100.0	Wh/kg	for asymmetric MXene-based supercapacitors
1714	763	energy_storage	Power_Density	8000.0	W/kg	for asymmetric MXene-based supercapacitors
1715	764	energy_storage	Energy_Density	93.17	Wh/kg	GQDs MTZ AC asymmetric supercapacitor
1716	764	energy_storage	Power_Density	1240.0	W/kg	GQDs MTZ AC asymmetric supercapacitor
1717	764	energy_storage	Cycling_Stability	10000.0	cycles	97% capacity retention after 10,000 cycles
1718	765	energy_storage	Energy_Density	85.6	Wh/kg	for solid-state asymmetrical supercapacitors
1719	766	Energy_storage	Capacitance	31.7	F/g	AQ-2-MX showed a 14.8 fold increase over the control
1720	766	Energy_storage	Capacitance	29.4	F/g	MA-NTCDA-MX showed a 17.3 fold increase over the control
1721	766	Energy_storage	Cycling_stability	99.5	%	MA-PTCDA-MX showed 99.5% cycling stability in aqueous electrolyte
1722	767	energy_storage	energy_density	43.2	Wh/kg	asymmetric supercapacitor (ASC) with MXene rGO W18O49 and activated carbon
1723	767	energy_storage	voltage_window	1.6	V	asymmetric supercapacitor (ASC) with MXene rGO W18O49 and activated carbon
1724	768	energy_storage	specific_capacitance	417.4	F/g	Achieved in 1 M H2SO4 at 1 mV s
1725	769	energy_storage	Capacitance	353.77	F/g	MXene has high specific surface area and metal-like conductivity, making it suitable for supercapacitors
1726	770	energy_storage	voltage_window	1.5	V	in 3 M H2SO4
1727	770	energy_storage	energy_density	20.0	Wh/kg	in 3 M H2SO4
1728	770	energy_storage	capacitance_retention	80.0	%	after 10,000 charge discharge cycles
1729	771	energy_storage	electrochemical performance	0.0		Improvements in ion transport and kinetic limitations for energy storage applications
1730	772	energy_storage	specific_capacitance	223.4	F/g	At a scan rate of 1000 mV/s
1731	772	energy_storage	energy_density	16.88	Wh/kg	At a power density of 799 W/kg
1732	772	energy_storage	energy_density	13.11	Wh/kg	At a power density of 8 kW/kg
1733	772	energy_storage	cycling_stability	90.4	%	Capacitance retention after 10,000 cycles
1734	773	energy_storage	energy_density	105.15	μWh/cm²	for aqueous Zn-ion hybrid micro-supercapacitors
1735	773	energy_storage	capacity_retention	89.29	%	after 3000 cycles
1736	773	energy_storage	capacity_retention	96.05	%	after 5000 cycles
1737	773	mechanical_flexibility	bending_stability	93.27	%	maintained capacity under 90 bending
1738	775	energy_storage	specific_capacitance	0.0		improved supercapacitor efficiency for multifunctional applications
1739	775	energy_storage	cycle_life	0.0		extended cycle lives
1740	775	energy_storage	power_density	0.0		high power densities
1741	776	energy_storage	Energy_Density	56.41	Wh/kg	Achieved at a power density of 800 W/kg
1742	776	energy_storage	Cycling_Stability	93.24	%	Retention after 5000 cycles
1743	777	energy_storage	Capacitance	10.5	F/cm²	at 1 mA/cm²
1744	777	energy_storage	Capacitance	232.8	F/g	at 1 mA/cm²
1745	777	energy_storage	Energy_Density	0.705	mWh/cm²	symmetric supercapacitor
1746	777	energy_storage	Energy_Density	3.53	mWh/cm³	symmetric supercapacitor
1747	777	energy_storage	Power_Density	54200.0	mW/cm²	symmetric supercapacitor
1748	777	energy_storage	Power_Density	271000.0	mW/cm³	symmetric supercapacitor
1749	777	energy_storage	Capacitance_Retention	93.0	%	after 10,000 cycles at 50 mA/cm²
1750	778	energy_storage	energy_density	96.4	Wh/kg	for the fabricated supercapacitor device (MXene NiCo-LDH Co9S8 activated carbon)
1751	778	energy_storage	capacitance_retention	70.26	%	after 9000 cycles
1752	779	energy_storage	specific_capacitance	0.0		Enhanced performance in supercapacitors due to synergy between MXenes and aerogels
1753	779	energy_storage	cycling_stability	0.0		Excellent cycling stability with minimal performance degradation during extended charge-discharge cycles
1754	779	energy_storage	charge_discharge_rate	0.0		Fast ion diffusion within the electrode leads to fast charging and discharging rates
1755	780	energy_storage	specific capacitance	418.2	C/g	Achieved at 0.5 A/g in 3 M H2SO4
1756	780	energy_storage	energy density	20.9	Wh/kg	At 491.5 W/kg
1757	781	energy_storage	Capacitance	565.0	F/g	Mass-specific capacitance of the film electrode
1758	781	energy_storage	Capacitance	1582.0	mF/cm²	Area-specific capacitance of the film electrode
1759	781	energy_storage	Energy_Density	6.3	Wh/kg	Energy density at 400 W/kg
1760	781	energy_storage	Cycle_Stability	99.6	%	Capacity retention after 20,000 cycles at 10 A/g
1761	782	energy_storage	energy_density	54.3	Wh/kg	asymmetric supercapacitor (ASC) fabricated with MX NCP and porous nanocarbon (PNC)
1762	782	energy_storage	energy_density	32.6	Wh/kg	at a high-power density of 6270 W/kg
1763	782	energy_storage	cycling_stability	93.8	%	after 10,000 cycles
1764	782	wearable_devices	adaptability	1.0	n/a	planar device was successfully fabricated
1765	783	energy_storage	Capacitance	1102.9	F/g	LDH Ti3C2Tx nanohybrids exhibit high capacitance for energy storage
1766	783	energy_storage	Energy_Density	47.3	Wh/kg	LDH Ti3C2Tx AC hybrid supercapacitor achieves high energy density
1767	783	energy_storage	Durability	91.7	%	HSC device demonstrates high durability after 5000 cycles
1768	783	energy_storage	Coulombic_Efficiency	99.0	%	HSC device shows high Coulombic efficiency after 5000 cycles
1769	784	energy_storage	Energy_Density	61.7	Wh/kg	asymmetric supercapacitor (ASC) using the composite as the negative electrode
1770	784	energy_storage	Power_Density	426.21	W/kg	asymmetric supercapacitor (ASC) using the composite as the negative electrode
1771	784	energy_storage	Cycling_Stability	25000.0	cycles	retaining 92.92% of initial capacitance at 0.5 A/g
1772	785	energy_storage	energy_density	0.7	μWh/cm²	The flexible supercapacitor device fabricated by using the 1 MT nanocomposites as electrode materials can reach this energy density at a power density of 80.0 μW/cm²
1773	785	energy_storage	capacitance_retention	100.0	%	The MnO2 Ti3C2Tx nanocomposite flexible supercapacitor shows superior electrochemical stability with more than 100% capacitance retention after 1000 cycles at 0.2 mA/cm²
1774	786	energy_storage	energy_density	26.8	Wh/kg	achieved by assembled aqueous ASCs based on porous MXene and graphene films
1775	787	energy_storage	specific_capacitance	353.77	F/g	improved specific capacitance in supercapacitors
1776	788	energy_storage	specific_capacitance	265.0	F/g	as used as an electrode material for supercapacitors
1777	789	energy_storage	Capacitance	679.0	mF/cm²	Delivered by the flexible quasi-solid-state symmetric supercapacitor
1778	789	energy_storage	Energy_Density	16.2	μWh/cm²	Delivered by the flexible quasi-solid-state symmetric supercapacitor
1779	789	energy_storage	Cycling_Capability	85.3	%	Capacitance retention after 10,000 cycles
1780	790	energy_storage	Capacitance	542.6	F/g	observed in basic media (1 M KOH)
1781	790	energy_storage	Energy_Density	14.58	kWh/kg	observed in basic media (1 M KOH)
1782	790	energy_storage	Power_Density	271.2	kW/kg	observed in basic media (1 M KOH)
1783	791	energy_storage	cycling_performance	10000.0		no capacitance loss after 10,000 cycles
1784	791	energy_storage	capacity_retention	100.0	%	capacity retention close to 100 after 10,000 cycles
1785	792	energy_storage	Energy_Density	172.8	Wh/kg	Zinc-ion hybrid supercapacitor (ZHSC)
1786	792	energy_storage	Power_Density	9625.5	Wh/kg	Zinc-ion hybrid supercapacitor (ZHSC)
1787	792	energy_storage	Cycling_Stability	79.5	%	ZHSC performance retention after 5000 cycles
1788	793	catalysis		0.0		The study suggests the method is suitable for catalysis applications.
1789	793	electronic_applications		0.0		The study suggests the method is suitable for electronic applications.
1790	794	energy_storage	capacitance	300.0	F/g	not explicitly mentioned in the text
1791	794	sensors	sensitivity	10.0	mV/kPa	not explicitly mentioned in the text
1792	795	energy_storage	specific_capacity	110.0	C/g	pseudocapacitive battery-like storage mechanism
1793	795	energy_storage	cycle_life	20000.0	cycles	excellent capacity retention
1794	796	energy_storage	specific_capacitance	1520.0	F/g	CeO2 MnO2 MXene electrode
1795	796	energy_storage	specific_capacitance	1370.0	F/g	CeO2 MnO2 MXene electrode
1796	796	energy_storage	cyclic_stability	73.5	%	CeO2 MnO2 MXene electrode after 10,000 cycles
1797	796	energy_storage	cyclic_stability	73.4	%	CeO2 MnO2 MXene electrode after 10,000 cycles
1798	797	energy_storage	specific_capacitance	448.8	F/g	Achieved at a current density of 0.5 A/g
1799	798	energy_storage	Capacitance	777.7	F/g	Outstanding pseudocapacitive performance in a three-electrode system
1800	798	energy_storage	Capacitance_Retention	88.5	%	Retains 88.5% of initial capacity after 10,000 cycles
1801	798	energy_storage	Energy_Density	73.3	Wh/kg	Achieves an energy density of 73.3 Wh/kg
1802	798	energy_storage	Power_Density	849.9	W/kg	Achieves a power density of 849.9 W/kg
1803	799	energy_storage	specific_capacitance	263.0	F/g	CVT PEDOT composite shows high specific capacitance at 1 A/g
1804	799	energy_storage	capacitance_retention	86.0	%	CVT PEDOT composite retains 86% of its capacitance after 5000 cycles at 10 A/g
1805	799	energy_storage	energy_density	15.26	Wh/kg	CVT PEDOT composite achieves an energy density of 15.26 Wh/kg at 600 W/kg
1806	800	macro-architectures	tensile strength	155.0	MPa	for fabricating functional MXene macroarchitectures
1807	800	macro-architectures	breaking energy	4.5	MJ/m3	for fabricating functional MXene macroarchitectures
1808	801	energy_storage	capacitance	1520.0	F/g	Achieved with P-doped CoNi2Se4 Ti3C2Tx heterostructure
1809	801	energy_storage	energy_density	37.4	Wh/kg	Achieved with HSC (hybrid supercapacitor) using the cathode
1810	802	energy_storage	capacitance_retention	95.98	%	after 2000 charge-discharge cycles
1811	802	energy_storage	energy_density	30.8	Wh/kg	for 6-MnO2 Ti3C2Tx asymmetric capacitor
1812	803	energy_storage	cycle_life	5000.0	cycles	all solid-state supercapacitor (ASSC) showed 96.36 coulombic efficiency and 92.98 capacitance retention
1813	803	energy_storage	specific_capacitance	407.0	F/g	measured in aqueous electrolyte
1814	804	energy_storage	energy_density	47.5	Wh/L	The artificially created symmetrical supercapacitor exhibits a remarkable energy density.
1815	805	energy_storage	Capacitance	113.03	F/g	AA-HPCs with Ti3C2Tx TiN as cathode and activated carbon as anode
1816	805	energy_storage	Charge_Retention	99.44	%	after 15,000 cycles in AA-HPCs
1817	805	energy_storage	Energy_Density	40.19	Wh/kg	at 800 W/kg in AA-HPCs
1818	806	energy_storage	energy_density	54.1	Wh/kg	achieved under 800 W/kg power density
1819	806	energy_storage	specific_capacitance	232.37	mAh/g	at 1 A/g in a three-electrode device
1820	807	energy_storage	operating_potential	1.2	V	wide operating potential of 1.2 V
1821	808	photocatalytic_degradation	removal_efficiency	1.27	mg gcat. 1 h 1	for 2 mg L 1 of roxarsone wastewater within 0.5 h
1822	808	photocatalytic_degradation	removal_rate	1.5	times	higher removal rate at 3 h compared to pure Ti3C2Tx
1823	809	sensors	response_time	210.0	ms	pressure sensor for monitoring external pressure changes and human limb movements
1824	809	energy_storage	capacitance_retention	83.0	%	after 2000 cycles in quasi-solid-state AIHSC
1825	809	sensors	pressure_monitoring_interval	1.0	N	pressure sensor for monitoring external pressure changes and human limb movements
1826	809	sensors	pressure_monitoring_interval	11.0	N	pressure sensor for monitoring external pressure changes and human limb movements
1827	811	energy_storage		0.0		Promising potential for use in supercapacitor applications
1828	812	energy_storage	specific_capacitance	92.0	F/g	Ti3C2Tx MXene in 3 M KOH shows high electrochemical performance for supercapacitors
1829	813	energy_storage	Energy_Density	60.2	Wh/kg	PANI Ti3C2Tx Ni3S4 AC
1830	813	energy_storage	Energy_Density	86.7	Wh/kg	PPY Ti3C2Tx Ni3S4 AC
1831	813	energy_storage	Energy_Density	53.4	Wh/kg	PEDOT Ti3C2Tx Ni3S4 AC
1832	813	energy_storage	Capacitance_Retention	93.42	%	PANI Ti3C2Tx Ni3S4 AC after 20,000 cycles
1833	813	energy_storage	Capacitance_Retention	93.28	%	PPY Ti3C2Tx Ni3S4 AC after 20,000 cycles
1834	813	energy_storage	Capacitance_Retention	96.16	%	PEDOT Ti3C2Tx Ni3S4 AC after 20,000 cycles
1835	814	energy_storage	specific_capacitance	619.7	F/g	37-fold enhancement over pure PPy NS
1836	814	energy_storage	rate_performance	74.2	%	capacitance retention from 1 to 100 mV/s scan rate
1837	814	energy_storage	cyclic_stability	81.6	%	capacitance retention after 10,000 cycles
1838	815	energy_storage	specific_capacitance	224.57	F/g	At 5 mV s-1
1839	815	energy_storage	specific_capacitance	193.67	F/g	At 0.5 A g-1
1840	816	energy_storage	Energy_Density	67.3	W h/kg	Achieved using NFMM and activated carbon as electrodes in an asymmetric supercapacitor
1841	816	energy_storage	Cyclic_Stability	89.0	%	Retained after 5000 cycles in an asymmetric supercapacitor
1842	817	energy_storage	energy storage efficiency	0.0		MXene-based supercapacitors have seen significant advancements in terms of energy storage efficiency
1843	818	energy_storage	Capacitance	52.02	mF/cm²	Flexible supercapacitor performance at 0°C
1844	818	energy_storage	Capacitance_Retention	82.5	%	After 1000 cycles at 0°C
1845	818	wearable_devices	Operational_Temperature	0.0	°C	Capable of operating at low temperatures
1846	820	energy_storage	capacitance	30.0	wt%	improved electrochemical performance compared with MnO2 NSs and p-Ti3C2Tx nanosheets
1847	821	energy_storage	Capacitance	226.6	F/g	MG-80 electrode exhibited the highest specific capacitance
1848	821	energy_storage	Capacitance_Retention	84.2	%	MG-80 electrode showed 84.2% retention after 5000 cycles
1849	821	energy_storage	Capacitance_Retention	63.58	%	ANN model predicted 63.58% retention after 10,000 cycles
1850	821	AI_applications	Accuracy	0.93	dimensionless	ANN model had an accuracy range of 0.93-0.97
1851	821	AI_applications	Error_Metric	1.96	dimensionless	ANN model had an error metric of 1.96-2.02
1852	822	energy_storage	Capacitance	555.0	F/g	Highest specific capacitance in H2SO4 electrolyte
1853	822	energy_storage	Energy_Density	81.2	Wh/kg	Maximum energy density achieved in H2SO4 electrolyte
1854	822	energy_storage	Power_Density	1023.0	W/kg	High power density in H2SO4 electrolyte
1855	823	energy_storage	Capacitance	71.5	F/g	maximum capacitance at 0.5 A/g in a voltage window of 1 V
1856	823	energy_storage	Energy_Density	9.3	Wh/kg	at a power density of 2.5 kW/kg
1857	825	energy_storage	specific_capacitance	214.65	F/g	at 100 mA/g
1858	825	energy_storage	energy_density	10.73	Wh/kg	
1859	825	energy_storage	cycling_stability	93.1	%	after 10,000 cycles at 500 mA/g
1860	825	energy_storage	mechanical_flexibility	90.0	degrees	can withstand bending at 0-90 degrees
1861	826	sensors	pH sensitivity	0.0		pH-dependent photoluminescence analysis indicated a decrease in excitation intensity at pH 2, suggesting a loss of intrinsic properties under acidic conditions.
1862	827	energy_storage	energy_density	91.4	Wh/kg	asymmetric supercapacitor constructed from the material
1863	827	energy_storage	energy_density	56.6	Wh/kg	at a high power density of 8000 W/kg
1864	828	energy_storage	specific_capacitance	353.77	F/g	Exceptional specific capacitance and remarkable capacitance retention
1865	828	energy_storage	capacitance_retention	98.0	%	Exceptional capacitive retention
1866	829	energy_storage	Energy_Density	18.4	Wh/kg	Assembled Fe-MXene-500 AC asymmetric supercapacitor
1867	830	energy_storage	specific_capacitance	916.0	F/g	high specific capacitance at 5 mV s
1868	830	energy_storage	energy_density	0.0	Wh/kg	govern its implementation for developing highly efficient supercapacitors with high energy and power densities
1869	831	energy_storage	Energy_Density	49.5	Wh/kg	for asymmetric supercapacitors (ASCs) Cu2O NCL M AC
1870	831	energy_storage	Energy_Density	45.0	Wh/kg	for asymmetric supercapacitors (ASCs) Cu2O NCL M AC
1871	832	energy_storage	capacitance	0.0		The paper mentions excellent capacitance and rate performance for supercapacitor electrode
1872	833	energy_storage	specific_capacitance	883.0	F/g	TGO-3 FeNi-MnO2 demonstrated the greatest specific capacitance
1873	835	energy_storage	specific_capacitance	1.3	times	increase in specific capacitance due to N-doping
1874	835	energy_storage	specific_capacitance	8.0	times	increase in specific capacitance due to N-doping
1875	836	energy_storage	specific_capacitance	615.3	μF/cm²	achieved at 1 V s⁻¹
1876	836	shielding	frequency	20.0	kHz	AC line-filtering circuit
1877	836	energy_storage	cutoff_frequency	1.21	kHz	for AC-DC conversion
1878	837	energy_storage	capacitance	356.0	mF/cm²	Observed in Ethaline electrolyte at 5 mV/s scan rate
1879	837	energy_storage	capacitance	640.0	mF/cm²	Observed in Ethaline electrolyte at 1 mV/s scan rate
1880	838	energy_storage	specific_capacitance	1500.0	F/g	MXene-based supercapacitors can achieve specific capacitance values exceeding 1,500 F g
1881	839	shielding	shielding_effectiveness	44.0	dB	EMI shielding in flexible micro-supercapacitors
1882	839	energy_storage	energy_density	11.8	mWh/cm³	Energy storage ability of Mn ions-introduced Ti3C2Tx MSCs
1883	839	energy_storage	capacitance	87.0	mF/cm²	Areal capacitance of Mn ion-intercalated Ti3C2Tx MSCs
1884	840	energy_storage	Capacitance	1323.7	F/g	Ti3C2 V3S4 electrode
1885	840	energy_storage	Capacitance	258.4	F/g	asymmetric supercapacitor Ti3C2 V3S4 activated carbon
1886	840	energy_storage	Energy_Density	60.6	Wh/kg	asymmetric supercapacitor Ti3C2 V3S4 activated carbon
1887	841	energy_storage	specific_capacitance	184.72	F/g	Sb MX AC device outperforms Sb-ball mill and MXene AC devices
1888	841	energy_storage	specific_capacitance	65.1	F/g	Sb-ball mill AC device
1889	841	energy_storage	specific_capacitance	36.61	F/g	MXene AC device
1890	842	energy_storage	specific_capacitance	1673.8	F/g	for asymmetric pseudocapacitive supercapacitors (APSC)
1891	842	energy_storage	cyclic_stability	98.81	%	for APSC over 10,000 cycles
1892	842	water_splitting	Tafel_slope	51.3	mV/dec	for oxygen evolution reaction (OER)
1893	842	water_splitting	Tafel_slope	36.9	mV/dec	for hydrogen evolution reaction (HER)
1894	843	energy_storage	Capacitance Retention	84.9	%	after 10,000 charge-discharge cycles
1895	843	energy_storage	Capacitance Retention	90.0	%	when bent at 90
1896	843	energy_storage	Power_Density	\N	not applicable	device successfully powered the red LED
1897	844	energy_storage	Capacitance	257.6	F/g	Mo2VC2Tz film electrode in 1M H2SO4
1898	844	energy_storage	Cycling_Stability	95.71	%	after 20,000 cycles in 1M H2SO4
1899	845	shielding	shielding_effectiveness	18.75	dB	5MXC5 specimen in X-band range
1900	845	shielding	shielding_effectiveness	23.21	dB	10MXC5 specimen in X-band range
1901	845	flame_retardant	burning_rate_reduction	15.25	unitless	5MXC5 specimen compared to C1
1902	845	flame_retardant	burning_rate_reduction	26.31	unitless	10MXC5 specimen compared to C1
1903	845	mechanical	hardness	133.29	HV	5MXC5 specimen
1904	845	mechanical	hardness	145.05	HV	10MXC5 specimen
1905	845	mechanical	flexural_strength	23.88	unitless	10MXC5 specimen
1906	845	mechanical	ILSS	24.37	unitless	10MXC5 specimen
1907	846	energy_storage	Capacitance	2.26	F/cm²	Achieved in Na2SO4 electrolyte for asymmetric supercapacitors
1908	846	energy_storage	Energy_Density	0.44	mWh/cm²	Achieved in an asymmetric device operating at 1.6 V
1909	847	energy_storage	specific_capacitance	361.0	C/g	for Co1-xNixFe2O4 (x = 0.10)
1910	847	energy_storage	specific_capacitance	367.0	C/g	for Co1-xNixFe2O4 (x = 0.10) with MXene
1911	848	energy_storage	Capacitance	552.6	F/g	Supercapacitor performance
1912	848	energy_storage	Energy_Density	1056.0	mAh/g	Li-ion storage capacity
1913	849	energy_storage	specific_capacitance	2675.0	F/g	MNCS electrode in three-electrode system
1914	849	energy_storage	cycling_stability	96.51	%	retains capacity after 10,000 cycles
1915	849	energy_storage	energy_density	61.0	Wh/kg	asymmetric flexible solid-state supercapacitor
1916	849	energy_storage	power_density	763.0	W/kg	asymmetric flexible solid-state supercapacitor
1917	850	shielding	reflection_loss	42.3	dB	maximum reflection loss value at 12.3 GHz
1918	850	microwave_absorption	effective_absorption_bandwidth	5.6	GHz	impressive effective absorption bandwidth
1919	851	energy_storage	volumetric energy density	83.5	Wh/L	achieved at a power density of 1800 W/L
1920	851	energy_storage	volumetric capacitance	601.0	F/cm³	achieved using H2SO4 KI redox additive electrolyte
1921	852	energy_storage	Capacitance	347.0	F/g	At 5 mV/s
1922	852	infrared_stealth	emissivity	\N		Low mid-infrared emissivity
1923	853	energy_storage	capacitance	300.0	F/g	not explicitly mentioned in the text
1924	853	sensors	sensitivity	10.0	mV/kPa	not explicitly mentioned in the text
1925	853	AI_applications	prediction_accuracy	95.0	%	not explicitly mentioned in the text
1926	854	sensors	sensitivity	1878.05	kPa-1	For pressure detection
1927	854	sensors	sensitivity	0.67	(RH)-1	For humidity detection
1928	854	sensors	response_time	3.46	s	For humidity detection
1929	854	sensors	recovery_time	1.5	s	For humidity detection
1930	854	sensors	response_range	8.0	kPa	For pressure detection
1931	854	sensors	response_range	125.0	kPa	For pressure detection
1932	854	sensors	response_range	11.5	RH	For humidity detection
1933	854	sensors	response_range	98.1	RH	For humidity detection
1934	855	energy_storage	Energy_Density	38.0	Wh/kg	for supercapacitors
1935	855	energy_storage	Power_Density	1280.0	W/kg	for supercapacitors
1936	855	energy_storage	Capacitance	1632.0	C/g	for supercapacitors
1937	855	energy_storage	Capacity_Retention	84.0	%	after 10,000 cycles
1938	855	electrocatalysis	Overpotential	158.0	mV	for hydrogen evolution reaction (HER)
1939	856	energy_storage	specific_capacitance	1428.0	F/g	ZIF 8 GO electrode demonstrated the highest specific capacitance
1940	856	energy_storage	capacitance_retention	83.5	%	ZIF 8 GO electrode maintained 83.50 of its capacity after 10,000 cycles
1941	857	energy_storage	specific_capacitance	1960.0	F/g	Achieved at 1 A/g
1942	857	energy_storage	rate_capability	87.3	%	Capacitance retention at 118 A/g
1943	857	energy_storage	cycle_stability	90.2	%	Capacitance retention after 8000 cycles at 5 A/g
1944	858	energy_storage	Capacitance	235.0	F/g	High-rate performance in AlCl3 electrolyte
1945	858	energy_storage	Potential_Window	1.2	V	Expanded voltage window using 3 M AlCl3 electrolyte
1946	859	energy_storage	specific capacity	708.7	F/g	Twice that of pure MXene
1947	859	energy_storage	rate performance	87.5	%	capacity retention after 20-times current increasing
1948	859	energy_storage	cycling stability	85.5	%	capacity retention after 10000 cycles
1949	859	energy_storage	energy density	\N	not specified	as shown by the constructed interdigital supercapacitor
1950	859	energy_storage	power density	\N	not specified	as shown by the constructed interdigital supercapacitor
1951	859	energy_storage	mechanical flexibility	\N	not specified	at various bending angles
1952	860	energy_storage	Capacitance_retention	80.0	%	After 5000 cycles at 6 A/g
1953	860	energy_storage	Operating_Voltage	1.4	V	All-solid-state symmetrical supercapacitor with PVA-KOH electrolyte
1954	860	energy_storage	Operating_Temperature	60.0	C	Extreme environment
1955	860	energy_storage	Operating_Temperature	-20.0	C	Extreme environment
1956	861	energy_storage	stability	85.0	%	retained initial capacitance after 10,000 charge-discharge cycles
1957	862	energy_storage	Capacitance	0.0		The review discusses improvements in specific capacitance, energy density, power density, and long-term cycling stability of integrated electrodes.
1958	862	energy_storage	Energy_Density	0.0		The review discusses improvements in specific capacitance, energy density, power density, and long-term cycling stability of integrated electrodes.
1959	862	energy_storage	Power_Density	0.0		The review discusses improvements in specific capacitance, energy density, power density, and long-term cycling stability of integrated electrodes.
1960	862	energy_storage	Cycling_Stability	0.0		The review discusses improvements in specific capacitance, energy density, power density, and long-term cycling stability of integrated electrodes.
1961	863	energy_storage	specific_capacitance	93.7	F/g	asymmetric supercapacitor device
1962	863	energy_storage	energy_density	42.2	Wh/kg	asymmetric supercapacitor device
1963	863	energy_storage	power_density	1801.5	W/kg	asymmetric supercapacitor device
1964	863	energy_storage	cyclic_life	96.0	%	after 10,000 cycles
1965	863	energy_storage	capacitance_retention	96.0	%	after 10,000 cycles
1966	864	energy_storage	Energy_Density	62.8	Wh/kg	Zn-ion hybrid supercapacitor
1967	864	energy_storage	Power_Density	10.1	kW/kg	Zn-ion hybrid supercapacitor
1968	865	energy_storage	discharge_capacity	628.7	mAh/g	Co9S8 modified with Fe2O3 Ti3C2 composite demonstrates significantly enhanced discharge capacity
1969	866	energy_storage	Capacitance	420.99	F/g	High-performance flexible supercapacitors
1970	866	energy_storage	Energy_Density	14.5	μWh/cm²	Flexible gel electrolyte and composite film used as electrode
1971	866	energy_storage	Capacitance_Retention	87.2	%	At 10,000 cycles
1972	867	energy_storage	energy_density	71.1	Wh/kg	achieved in an asymmetric supercapacitor device
1973	867	energy_storage	power_density	800.0	W/kg	achieved in an asymmetric supercapacitor device
1974	868	packaging	mechanical_strength	669.0	%	Improvement in Young's modulus with 10 wt% MXene
1975	868	packaging	tensile_strength	292.0	%	Improvement in tensile strength with 10 wt% MXene
1976	868	packaging	water_barrier	91.0	%	Reduction in water vapor permeability with MXene
1977	868	packaging	oxygen_barrier	79.0	%	Reduction in oxygen permeability with MXene
1978	868	recyclable_materials	recyclability	1.0	no_loss	Maintained mechanical and barrier properties after recycling
1979	869	energy_storage	gravimetric_capacity	450.0	C/g	Ti3C2Tx MXene electrodes demonstrated remarkable gravimetric capacitances in 1 M H2SO4 electrolyte
1980	869	energy_storage	capacitance_retention	114.0	%	Ti3C2Tx MXene electrodes showed outstanding capacitance retention after 8000 cycles
1981	870	energy_storage	Capacitance	62.98	F/g	asymmetrical FSC with graphene fiber
1982	870	energy_storage	Energy_Density	0.0	n/a	high energy density mentioned but no numeric value provided
1983	870	wearable_system	Deformation_Ability	0.0	n/a	favorable deformation ability mentioned
1984	870	wearable_system	Mechanical_Endurance	98.6	%	capacitance retention after 100 times bending
1985	872	energy_storage	specific_capacitance	481.0	F/g	TiC MXene composite
1986	872	energy_storage	specific_capacitance	478.0	F/g	WC MXene composite
1987	872	energy_storage	cycling_stability	95.5	%	TiC MXene composite after 5,000 cycles
1988	872	energy_storage	cycling_stability	96.3	%	WC MXene composite after 5,000 cycles
1989	872	energy_storage	energy_density	53.0	Wh/kg	WC MXene AC ASC device
1990	872	energy_storage	cycling_stability	97.7	%	WC MXene AC ASC device after 5,000 cycles
1991	873	energy_storage	specific_capacitance	1.6	F/cm²	asymmetric supercapacitor configuration
1992	873	energy_storage	energy_density	262.0	μWh/cm²	asymmetric supercapacitor configuration
1993	873	energy_storage	power_density	2.7	mW/cm²	asymmetric supercapacitor configuration
1994	873	energy_storage	cycle_life	1000.0	cycles	capacitance retention of 92.4%
1995	873	energy_storage	compression_cycle_life	200.0	cycles	capacitance retention of >90%
1996	874	energy_storage	energy_density	94.1	Wh/kg	for the symmetric supercapacitor
1997	874	energy_storage	power_density	7431.8	W/kg	for the symmetric supercapacitor
1998	875	energy_storage	capacity_retention	94.0	%	after 10,000 cycles at 20 A/g
1999	875	energy_storage	cyclic_stability	10000.0	cycles	maintains significant cyclic stability at 20 A/g
2000	876	energy_storage	current_density	520.0	mA/cm²	for anion exchange membrane water electrolysis
2001	877	energy_storage	specific_capacitance	105.0	F/g	asymmetric supercapacitor
2002	877	energy_storage	energy_density	12.81	Wh/kg	asymmetric supercapacitor
2003	877	energy_storage	power_density	985.8	W/kg	asymmetric supercapacitor
2004	878	energy_storage	energy_density	6.33	Wh/kg	Flexible symmetric supercapacitor
2005	878	energy_storage	power_density	600.0	W/kg	Flexible symmetric supercapacitor
2006	879	energy_storage	Energy_Density	70.11	Wh/kg	asymmetric supercapacitor (ASC) device with NiCo2O4 MXene LDH AC configuration
2007	879	energy_storage	Power_Density	850.22	W/kg	asymmetric supercapacitor (ASC) device with NiCo2O4 MXene LDH AC configuration
2008	879	energy_storage	Capacitance	5066.0	F/g	at 1 A/g
2009	879	energy_storage	Capacitance_Retention	97.82	%	after 10,000 charge cycles at 10 A/g
2010	880	energy_storage	specific capacitance	485.0	mF/cm²	demonstrates excellent cycling stability
2011	880	sensors	sensitivity	1.42	kPa⁻¹	high sensitivity and rapid response recovery times
2012	881	energy_storage	Capacitance	0.0		Enhanced pseudocapacitance due to thin layers and rapid ion diffusion
2013	881	energy_storage	Energy_Density	0.0		Enhanced energy storage due to unique structural and electronic attributes
2014	881	energy_storage	Cyclic_Stability	0.0		Robust cyclic stability due to structural stability and redox-active vanadium centres
2015	884	energy_storage	operating potential window	1.4	V	Solid-state asymmetric supercapacitors
2016	884	energy_conversion	current density	0.5	A/g	Electrolyzer in KOH + CH3CH2OH electrolyte at 1.33 V
2017	885	energy_storage	specific_capacity	1018.0	mAh/g	at a specific current of 2 A/g
2018	885	energy_storage	specific_capacity	105.67	mAh/g	in LFP CoZnOHF MXene full cell at 0.1C
2019	887	energy_storage	energy_density	19.7	mWh g-1	achieved with Ti3CNTx-1.5AA-20 rGO-2.0AA-30 ASC
2020	888	energy_storage	specific_capacitance	219.2	F/g	aged MXene
2021	888	energy_storage	specific_capacitance	280.3	F/g	serine-functionalized MXene
2022	889	energy_storage	specific_capacitance	383.0	F/g	enhanced by intercalation of carbon black nanosheets
2023	889	energy_storage	areal_capacitance	138.75	mF/cm²	for symmetric supercapacitor device
2024	889	energy_storage	energy_density	12.33	mWh/cm²	for symmetric supercapacitor device
2025	889	energy_storage	power_density	2212.0	mW/cm²	for symmetric supercapacitor device
2026	889	energy_storage	capacitance_retention	86.14	%	after 3000 cycles
2027	889	energy_storage	capacitance_retention	78.7	%	after 5000 cycles
2028	890	energy_storage	Capacitance Retention	90.1	%	after 5000 cycles
2029	890	energy_storage	Capacitance Retention	77.6	%	after 5000 cycles at 10 A/g
2030	890	energy_conversion	Overpotential	446.1	mV	for OER in 1 M KOH
2031	890	energy_conversion	Tafel Slope	88.31	mV/dec	for OER in 1 M KOH
2032	891	energy_storage	supercapacitance	197.0	F/g	initial supercapacitance in acidic conditions
2033	891	energy_storage	supercapacitance	284.0	F/g	supercapacitance in acidic conditions after modification with C6H4 COOH
2034	891	energy_storage	supercapacitance	86.0	F/g	initial supercapacitance in alkaline conditions
2035	891	energy_storage	supercapacitance	142.0	F/g	supercapacitance in alkaline conditions after modification with C6H4 COOH
2036	892	energy_storage	capacity_retention	92.2	%	after 12,000 cycles at 10 A g-1
2037	892	energy_storage	energy_density	241.9	Wh/kg	for asymmetric supercapacitors (ASCs)
2038	893	energy_storage	Capacitance	234.8	F/g	MnO2 MXene CC-8 positive electrode
2039	893	energy_storage	Capacitance	21.3	F/g	MMC-8 MC asymmetric flexible supercapacitor
2040	893	energy_storage	Energy_Density	9.6	Wh/kg	MMC-8 MC asymmetric flexible supercapacitor
2041	894	sensors	defect_detection	0.0		Detecting hole defects and strain conditions of Ti3C2T2 (T = F, O, OH) MXenes
2042	894	shielding		0.0		Potential applications for protecting surfaces of radioactive materials
2043	895	energy_storage	specific_capacitance	146.0	F/g	at 1 A/g in the fabricated SSC device
2044	895	energy_storage	energy_density	52.0	Wh/kg	in a symmetric supercapacitor (SSC)
2045	895	energy_storage	power_density	799.0	W/kg	in a symmetric supercapacitor (SSC)
2046	896	energy_storage	specific capacity	703.25	C/g	Achieved at a current density of 1 A/g
2047	896	energy_storage	capacity retention	75.2	%	After 1500 cycles at a high current density of 5 A/g
2048	896	energy_storage	capacity retention	67.0	%	After 5000 cycles at a high current density of 5 A/g
2049	896	energy_storage	energy density	49.7	Wh/kg	At a current density of 1 A/g
2050	896	energy_storage	power density	800.0	W/kg	At a current density of 1 A/g
2051	896	energy_storage	energy density	20.0	Wh/kg	At a current density of 10 A/g
2052	896	energy_storage	power density	8000.0	W/kg	At a current density of 10 A/g
2053	897	energy_storage	areal_capacitance	33.3	mF/cm²	for stretchable supercapacitors
2054	898	energy_storage	Discharge_Capacity	602.9	mAh/g	Demonstrated after 800 cycles
2055	898	energy_storage	Discharge_Capacity	1002.8	mAh/g	Demonstrated after 160 cycles at 1 C
2056	898	energy_storage	Coulombic_Efficiency	96.7	%	Demonstrated after 800 cycles
2057	899	energy_storage	specific_capacitance	957.36	F/g	CuS Ti3C2Tx MXene nanocomposites
2058	899	energy_storage	specific_capacitance	361.1	F/g	in asymmetric supercapacitor (ASC)
2059	899	energy_storage	energy_density	36.11	W/kg	in asymmetric supercapacitor (ASC)
2060	899	water_splitting	overpotential	89.7	mV	for hydrogen evolution reaction (HER)
2061	899	water_splitting	overpotential	171.0	mV	for oxygen evolution reaction (OER)
2062	900	energy_storage	specific capacitance	396.0	F/g	superior to or comparable with state-of-the-art MXene results
2063	901	energy_storage	specific_capacitance	155.0	Ah/kg	Achieved in an aqueous sodium hybrid supercapacitor
2064	901	energy_storage	energy_density	57.0	Wh/kg	Achieved in an aqueous sodium hybrid supercapacitor
2065	901	energy_storage	power_density	2110.0	W/kg	Achieved in an aqueous sodium hybrid supercapacitor
2066	901	energy_storage	cycle_life	5000.0	cycles	Stability and performance maintained over 5000 charge-discharge cycles
2067	902	energy_storage	specific_capacitance	81.0	F/g	Ti3C2Tx-NG-based supercapacitors
2068	902	energy_storage	specific_capacitance	62.0	F/g	Ti3C2Tx MXene-based supercapacitors
2069	903	energy_storage	energy_density	94.7	μWh/cm²	for MXene CNF PANI-based SSC
2070	903	energy_storage	capacitance	522.0	mF/cm²	for MXene CNF PANI-based SSC
2071	903	energy_storage	capacitance_retention	90.0	%	for gel composite electrodes after 10,000 cycles
2072	911	energy_storage	energy_density	104.9	μWh/cm²	Flexible zinc ion hybrid supercapacitors (ZIHSCs)
2073	911	energy_storage	capacitance	1613.0	mF/cm²	Symmetric supercapacitor electrode material
2074	911	energy_storage	capacitance	1180.0	mF/cm²	Zinc-ion hybrid supercapacitors (ZIHSCs)
2075	912	energy_storage	energy_density	51.1	Wh/kg	exceeds the energy density of MXene based electrodes reported in the current literature
2076	913	energy_storage	Capacitance	599.2	mF/cm²	Ti3C2 TiO2 CuTiO3 heterostructure
2077	913	energy_storage	Energy_Density	31.1	Wh/kg	asymmetric supercapacitor (ASC) device
2078	913	energy_storage	Power_Density	1041.7	W/kg	asymmetric supercapacitor (ASC) device
2079	913	energy_storage	Capacitance_Retention	83.7	%	after 5000 continuous charging discharging cycles
2080	914	energy_storage	specific capacitance retention	89.03	%	after 5000 GCD cycles
2081	914	energy_storage	specific energy	35.29	Wh/kg	P1M2-rGO ASC
2082	914	energy_storage	specific power	240.0	W/kg	P1M2-rGO ASC
2083	914	energy_storage	specific energy	26.22	Wh/kg	P1M2-rGO ASC
2084	914	energy_storage	specific power	1200.0	W/kg	P1M2-rGO ASC
2085	915	energy_storage	Energy_Density	0.97	mWh/cm²	achieved by the MNCS-1 AC HSC hybrid supercapacitor
2086	915	energy_storage	Power_Density	34.2	mW/cm²	achieved by the MNCS-1 AC HSC hybrid supercapacitor
2087	916	energy_storage	specific_capacitance	293.3	F/g	Achieved at current density of 1 A/g
2088	916	energy_storage	energy_density	5.8	Wh/kg	At power density of 1000 W/kg
2089	916	energy_storage	capacity_retention	91.0	%	After 8000 cycles
2090	917	energy_storage	Energy_Density	156.9	Wh/kg	AC-AAHSC device
2091	919	energy_storage	specific_capacitance	652.1	F/g	Achieved at 0.75 A/g
2092	919	energy_storage	energy_density	326.9	Wh/kg	At 2850 W/kg
2093	919	energy_storage	power_density	7600.0	W/kg	Maintained 183.7 Wh/kg
2094	919	energy_storage	capacitance_retention	91.0	%	After 6000 cycles
2095	920	energy_conversion	overpotential	131.0	mV	for hydrogen evolution reaction
2096	920	energy_conversion	stability	24.0	h	in 1 M KOH
2097	921	energy_storage	specific_capacity	174.0	mAh/g	initial capacity at 0.1 A/g
2098	921	energy_storage	coulombic_efficiency	100.0	%	over 500 cycles
2099	921	energy_storage	cycle_life	500.0	cycles	with 78% capacity retention
2100	922	energy_storage	energy_density	54.0	Wh/kg	Achieved at a power density of 800 W/kg
2101	922	energy_storage	capacitance_retention	85.4	%	After 14,000 cycles at 3 A/g
2102	923	energy_storage	energy_density	47.5	Wh/kg	for asymmetric supercapacitor
2103	923	energy_storage	power_density	500.0	W/kg	for asymmetric supercapacitor
2104	924	energy_storage	energy_density	5.0	Wh/kg	achieved in a symmetrical supercapacitor
2105	924	energy_storage	power_density	1000.0	W/kg	achieved in a symmetrical supercapacitor
2106	924	energy_storage	cycling_stability	82.03	%	retained after 10,000 cycles
2107	924	energy_storage	capacitance	467.7	F/g	specific capacitance at 5 mV/s scan rate
2108	925	energy_storage	specific_capacitance	483.1	F/g	M-PANI hydrogel electrodes
2109	925	energy_storage	specific_capacitance	128.2	F/g	MXene M-PANI supercapacitors
2110	925	energy_storage	energy_density	23.6	W h/kg	MXene M-PANI supercapacitors
2111	925	energy_storage	cycling_stability	80.0	%	after 6000 cycles
2112	925	energy_storage	cycling_stability	89.4	%	after 9000 cycles
2113	926	energy_storage	energy_density	6.2	Wh/kg	demonstrated in the ternary nanocomposite
2114	926	energy_storage	power_density	54.0	W/kg	demonstrated in the ternary nanocomposite
2115	926	energy_storage	cyclic_stability	91.0	%	after 2500 cycles
2116	927	energy_storage	Capacitance	353.77	F/g	Improvement in capacitance due to nitrogen doping
2117	928	energy_storage	specific capacitance	353.77	F/g	MXene-derived-TiO2 is suitable for supercapacitors
2118	929	energy_storage	specific_capacitance	272.5	F/g	High specific capacitance at 1 A/g
2119	929	energy_storage	energy_density	31.18	Wh/kg	At a power density of 1079.3 W/kg
2120	929	energy_storage	capacitance_retention	71.4	%	After 4000 cycles at 2 A/g
2121	930	energy_storage	specific capacitance	353.8	F/g	Achieved in IL-based electrolytes
2122	930	energy_storage	energy density	28.3	W h/kg	Achieved in IL-based electrolytes at 1193 W/kg power density
2123	931	energy_storage	specific capacity	353.77	F/g	Utilized TBAOH-treated MS-Ti3C2Tx as anode material in LIBs
2124	931	energy_storage	cycle stability	\N	cycles	Hexagonal Ti3C2 nanosheets showed excellent long-term cycle stability
2125	931	energy_storage	rate capability	\N	C-rate	TBAOH-treated MS-Ti3C2Tx showed outstanding rate capability
2126	931	energy_storage	capacitance retention	\N	%	N-N-Ti3C2Tx electrode showed excellent capacitance retention
2127	931	hydrogen_evolution_reaction	catalytic activity	\N	activity	Cl-terminated MXenes offer the best HER catalytic activity
2128	933	energy_storage	capacitance	175.6	F/g	symmetric solid-state F-SCs
2129	933	energy_storage	energy_density	6.1	Wh/kg	symmetric solid-state F-SCs
2130	933	energy_storage	capacitance_retention	98.5	%	after 2000 cycling
2131	933	wearable_system	capacitance_retention	\N	not specified	under deformation settings
2132	934	energy_storage	Capacitance	0.0		M2X MXenes are highlighted as promising for supercapacitors, but specific capacitance values are not provided.
2133	942	energy_storage	specific_capacitance	598.0	F/g	demonstrated in 1 M KOH at 1 A/g
2134	942	energy_storage	cycling_stability	92.4	%	after 10,000 cycles at 3 A/g
2135	943	energy_storage	Capacitance	1049.0	F/g	used for hybrid supercapacitors
2136	943	energy_storage	Capacitance	79.0	F/g	used for hybrid supercapacitors at 3 A/g
2137	943	energy_storage	Capacitance	61.0	F/g	used for hybrid supercapacitors at 5 A/g
2138	943	energy_storage	Power_Density	7020.0	W/kg	used for hybrid supercapacitors
2139	943	energy_storage	Energy_Density	11.7	Wh/kg	used for hybrid supercapacitors
2140	943	energy_storage	Rate_Capability	71.0	%	maintained at 10 A/g
2141	944	energy_storage	capacitance_retention	81.0	%	for 3000 cycles (VG-NCS TCX device)
2142	944	energy_storage	capacitance_retention	85.0	%	for 5000 cycles (VG-NCS TCX device)
2143	945	solar_energy_harvesting	absorption_efficiency	99.38	%	practical solar energy absorption efficiency
2144	945	thermal_photovoltaics	absorption_efficiency	99.0	%	maintains >99 absorption across wide range of incident angles
2145	945	thermal_imaging	absorption_efficiency	99.5	%	maintains over 99.5 absorption across wide range of incident angles
2146	946	energy_storage	specific_capacity	259.0	C/g	MoSe2 e-Ti3C2Tx hybrid nanostructured electrode
2147	946	energy_storage	energy_density	12.92	Wh/kg	supercapacitor device assembled with MoSe2 e-Ti3C2Tx hybrid nanostructure
2148	946	energy_storage	power_density	1001.02	W/kg	supercapacitor device assembled with MoSe2 e-Ti3C2Tx hybrid nanostructure
2149	946	energy_storage	cycle_life	5000.0	cycles	retained 96.6% of capacitance
2150	947	energy_storage	specific_capacitance	182.75	F/g	Achieved within the potential range of 0.6 to 0.2 V
2151	948	energy_storage	ions adsorption capacity	141.77	mg/g	at 1.2 V for 60 min
2152	948	energy_storage	cycling_stability	94.6	%	after 215 salt adsorption desorption cycles
2153	949	energy_storage	specific_capacitance	372.0	F/g	Exhibits excellent specific capacitance
2154	950	energy_storage	Energy_Density	15.4	Wh/kg	for asymmetric supercapacitor (ACS)
2155	950	energy_storage	Capacitance	72.0	mAh/g	at current density of 1 A/g
2156	951	energy_storage	specific_capacitance	1133.0	F/g	MXene-coated GC electrode
2157	951	photothermal_therapy	conversion_efficiency	59.0	%	excellent photothermal performance
2158	952	energy_storage	specific_capacitance	88.0	F/g	MoS2 MXene electrode annealed at 850 C
2159	953	energy_storage	Energy_Density	87.0	Wh/kg	assembled asymmetric supercapacitor
2160	953	energy_storage	Power_Density	750.0	W/kg	assembled asymmetric supercapacitor
2161	953	energy_storage	Coulombic_Efficiency	99.4	%	after 7,000 cycles
2162	953	energy_storage	Capacity_Retention	83.7	%	after 7,000 cycles at 3 A/g
2163	953	flexible_energy_storage	Mechanical_Stability	\N	none	minimal changes in specific capacitance at different bending angles
2164	954	energy_storage	Energy_Density	141.03	Wh/kg	Zn-ion hybrid supercapacitor (ZHSC) with K+-Ti3C2TX-RGO hydrogel cathode
2165	954	energy_storage	Capacitance	253.86	F/g	Zn-ion hybrid supercapacitor (ZHSC) with K+-Ti3C2TX-RGO hydrogel cathode
2166	955	energy_storage	specific_capacitance	1125.0	F/g	for supercapacitors
2167	955	energy_storage	energy_density	100.0	Wh/kg	for supercapacitors
2168	955	energy_storage	power_density	400.0	W/kg	for supercapacitors
2169	955	energy_storage	cyclic_stability	87.0	%	after 10,000 cycles for supercapacitors
2170	956	sensors	sensitivity	0.1	nA/mM	for glucose detection
2171	956	sensors	limit_of_detection	0.01	mM	for ascorbic acid detection
2172	956	sensors	selectivity	100.0	%	for dopamine detection
2173	956	energy_storage	specific_capacitance	353.77	F/g	for MXene-based supercapacitors
2174	956	energy_storage	energy_density	100.0	Wh/kg	for MXene-based supercapacitors
2175	957	energy_storage	specific_capacitance	211.57	F/g	MnOx Ti3C2Tx MXene CNFs composite fiber films have potential for flexible supercapacitors
2176	958	energy_storage	specific_capacitance	320.0	F/g	Excellent specific capacitance
2177	958	energy_storage	capacitance_retention	97.0	%	Long-term stability over 50 000 cycles
2178	959	energy_storage	specific_capacitance	254.28	F/g	BTO intercalated Ti3C2Tx MXene electrode
2179	959	energy_storage	cycle_stability	10000.0	cycles	retention ratio of 74%
2180	959	energy_storage	practical_applicability	1.0	LED	tested through LED glowing application
2181	960	energy_storage	Energy_Density	25.0	Wh/kg	for asymmetric supercapacitors (ASCs)
2182	960	energy_storage	Energy_Density	510.3	mWh/cm³	for flexible ASCs in PVA:Na2SO4 polymer gel electrolyte
2183	960	electrocatalysis	Overpotential	439.7	mV	for hydrogen evolution reaction (HER)
2184	960	electrocatalysis	Overpotential	381.2	mV	for oxygen evolution reaction (OER)
2185	961	energy_storage	specific_capacitance	570.0	F/g	MCuSe shows high specific capacitance for energy storage
2186	961	energy_storage	specific_capacitance	167.0	F/g	ASC using MCuSe shows high specific capacitance for energy storage
2187	961	energy_storage	energy_density	59.38	Wh/kg	ASC using MCuSe shows high energy density for energy storage
2188	961	energy_storage	power_density	2055.46	W/kg	ASC using MCuSe shows high power density for energy storage
2189	962	energy_storage	capacitance	306.0	C/g	O-Ti3C2Tx-0.05 film electrode
2190	963	energy_storage	capacitance	353.77	F/g	MXene-polymer composites show promise as improved electrode materials due to their superior mechanical characteristics, mass load, flexibility, specific surface area, and theoretical capacity
2191	963	energy_storage	energy_density	353.77	Wh/kg	MXene conducting polymer composites have great potential in high-performing supercapacitors due to their synergic properties
2192	964	energy_storage	areal capacitance	2497.8	mF/cm²	for supercapacitor at high and low temperatures
2193	964	energy_storage	energy density	222.02	μW h/cm²	for supercapacitor at high and low temperatures
2194	964	energy_storage	cycling_stability	84.0	%	over 7000 cycles
2195	964	sensors	temperature_range	100.0	°C	from -40°C to 60°C
2196	965	energy_storage	Capacitance	353.77	F/g	not explicitly mentioned
2197	965	shielding	Electromagnetic shielding effectiveness	0.0	dB	not explicitly quantified
2198	965	sensors	Sensitivity	0.0	unitless	not explicitly quantified
2199	965	desalination	Salt rejection	0.0	%	not explicitly quantified
2200	965	catalysis	Catalytic activity	0.0	unitless	not explicitly quantified
2201	966	energy_storage	energy_density	49.8	Wh/kg	All-solid-state supercapacitor
2202	966	energy_storage	capacitance	1090.6	F/g	FeCo2O4 FeCo2S4-MXene electrode
2203	966	energy_storage	cycle_stability	87.85	%	after 20,000 cycles at 1 A/g
2204	967	energy_storage	Capacitance	353.77	F/g	MXene-based composites show high capacitance for flexible supercapacitors
2205	967	wearable_electronics	flexibility	0.0	n/a	MXene-based FSCs are designed for flexibility and integration into wearable devices
2206	967	multifunctional_devices	self-healing	0.0	n/a	AgNP Ti3C2Tx PU composites demonstrate self-healing properties for wearable devices
2207	968	energy_storage	specific capacitance	2.0		Comparing a binary composite electrode to a ternary composite electrode, the latter provided almost twice as much specific capacitance
2208	968	energy_storage	energy density	1.0		A ternary composite of transition metal sulfide and oxide with MXene shows improved energy density than metal-oxide MXene binary composites and pure MXenes
2209	968	energy_storage	specific capacitance	1.0		The incorporation of metal oxide into the ternary composite resulted in an improvement in its specific capacitance and energy density
2210	968	energy_storage	Capacitance	1.0		The MXene-carbon conducting polymer ternary composites have demonstrated superior electrochemical performance when compared with that of the pristine MXene and carbon conducting polymer composite
2211	968	energy_storage	energy and power densities	1.0		The use of ternary composites in sophisticated microsupercapacitors with high energy and power densities has also demonstrated considerable promise
2212	973	energy_storage	specific_capacitance	90.0	F/g	at 300 mV/s scan rate
2213	973	energy_storage	specific_capacitance	120.0	F/g	at 2 mV/s scan rate
2214	973	flexible_electronics	flexibility	0.0	n/a	demonstrated outstanding flexibility in dynamic bend tests
2215	974	energy_storage	Capacitance	683.5	F/g	CuO SnO2 MXene nanohybrids showed high capacitance in 2 M H2SO4 electrolyte
2216	975	energy_storage	Capacitance	21.1	F/g	asymmetric supercapacitor based on CC PANI-MnO2 and CC MXene
2217	975	energy_storage	Energy_Density	47.25	μWh/cm²	at a power density of 2.40 mW/cm²
2218	975	energy_storage	Capacitance_Retention	83.0	%	after 4000 cycles at 1 A/g
2219	976	energy_storage	Capacitance	353.77	F/g	MXene-based supercapacitors
2220	976	energy_storage	Energy_Density	353.77	Wh/kg	MXene-based supercapacitors
2221	977	energy_storage	Energy_Density	53.3	Wh/kg	Achieved in an asymmetric supercapacitor (ASC) Zn-N-MX NCS AC
2222	977	energy_storage	Cycle_Stability	87.5	%	Retains 87.5% of initial capacitance after 5000 cycles
2223	978	energy_storage	areal_capacitance	131.46	mF/cm²	Maximum areal capacitance of the hybrid supercapacitor
2224	978	energy_storage	voltage_window	1.2	V	Voltage window of the hybrid supercapacitor
2225	979	energy_storage	energy_density	77.4	Wh/kg	Achieved in an asymmetric supercapacitor (ASC)
2226	979	energy_storage	specific_capacitance	1345.3	F/g	Delivered by Co1Ga1-LDH MXene
2227	980	EMI_shielding	Shielding_Efficiency	43.3	dB	More than 99.99% of incident waves could be shielded
2228	980	Heaters	Saturation_Temperature	76.2	C	At a low input voltage of 3 V
2229	980	Supercapacitors	Areal_Capacitance	139.6	mF/cm²	At a current density of 1 mA/cm²
2230	980	Temperature_Sensors	TCR	\N	N/A	Displayed stable resistance changes with excellent TCR values for accuracy
2231	981	energy_storage	specific_capacitance	254.0	F/g	MXene CNT10 (MX1) composite exhibited superior electrochemical performance
2232	981	energy_storage	energy_density	14.1	Wh/kg	MXene CNT composites demonstrate significant potential for advanced energy storage applications
2233	981	energy_storage	power_density	13.9	kW/kg	MXene CNT composites demonstrate significant potential for advanced energy storage applications
2234	982	energy_storage	Energy_Density	12.5	Wh/kg	Achieved by a quasi-solid-state flexible symmetric supercapacitor
2235	982	energy_storage	Cycling_Stability	98.5	%	Maintained after 10,000 cycles
2236	983	energy_storage	specific_capacitance	750.0	F/g	exhibited excellent electrochemical performance
2237	983	energy_storage	energy_density	52.08	Wh/kg	at a power density of 750 W/kg
2238	983	energy_storage	cycling_stability	93.0	%	retention after 10000 cycles
2239	984	energy_storage	Energy_Density	120.74	μWh/cm²	at a power density of 800 μW/cm²
2240	984	energy_storage	Energy_Density	90.21	μWh/cm²	at a power density of 79,992 μW/cm²
2241	984	energy_storage	Capacitance_Retention	93.37	%	after 10,000 cycles
2242	985	energy_storage	rate characteristics	45.5	F/g	Improvement in rate characteristics due to increased accessibility of active sites
2243	985	energy_storage	lifespan	24.8	%	Improvement in lifespan due to enhanced structural stability
2244	986	energy_storage	specific_capacitance	542.1	F/g	achieved with 0.06 M gallium source concentration
2245	986	energy_storage	cycling_stability	96.6	%	after 5000 cycles
2246	987	energy_storage	capacitance_retention	80.8	%	at 2 A/g
2247	987	energy_storage	capacitance_retention	80.49	%	over 10,000 cycles
2248	987	energy_storage	coulombic_efficiency	98.6	%	at 2 A/g
2249	988	energy_storage	Energy_Density	31.0	Wh/kg	assembled asymmetric supercapacitor (ASC) with activated carbon (AC) as a negative electrode
2250	989	energy_storage	Capacitance	1567.5	F/g	for positive electrode (ZCO PPy MXHCNF)
2251	989	energy_storage	Capacitance	477.2	F/g	for negative electrode (NPC MXHCNF)
2252	989	energy_storage	Energy_Density	61.3	Wh/kg	for flexible asymmetric supercapacitor device
2253	990	energy_storage	Capacitance	800.0	F/g	Ti3C2Tx synthesized with LiF alone achieved 800 F/g after 1800 cycles, surpassing typical values reported in the literature.
2254	991	energy_storage	specific_capacitance	669.0	F/g	delaminated MXene SnO2 electrode material
2255	991	energy_storage	cyclic_stability	90.0	%	retention after six thousand cycles
2256	991	sensors	capacitive_contribution	0.0	N/A	Trasatti method used to discover capacitive contribution
2257	992	energy_storage	capacitance_retention	105.1	%	After 9000 cycles
2258	993	optoelectronics	optical transparency	0.0		exceptional optical transparency
2259	993	optoelectronics	thermal conductivity	0.0		strong thermal conductivity
2260	993	optoelectronics	electrical conductivity	0.0		superior electrical conductivity
2261	993	optoelectronics	photothermal conversion	0.0		effective photothermal conversion
2262	993	energy_storage	reversible ion intercalation	0.0		addresses issues of low electrical conductivity and reversible ion intercalation in conventional electrochromic devices
2263	993	sensors	Surface-Enhanced Raman Scattering (SERS)	0.0		applicable in biological sensing, environmental pollution detection, and food safety
2264	993	biomedical	biocompatibility	0.0		biocompatibility
2265	993	biomedical	high absorption rate	0.0		high absorption rate
2266	994	energy_storage	specific capacity	31.11	mAh/g	P-doped Ti3C2Tx electrode delivered high specific capacity
2267	994	energy_storage	energy density	8.2	Wh/L	P-doped Ti3C2Tx based symmetric SC device displayed excellent energy density
2268	995	energy_storage	specific_capacitance	740.0	F/g	Measured at a scan rate of 2 mV/s
2269	995	energy_storage	specific_capacitance	895.0	F/g	Measured at a charge-discharge current density of 0.5 A/g
2270	996	energy_storage	specific_capacitance	353.77	F/g	Ti2N Ti3C2Tx as cathode material in aqueous NH4+-ion hybrid supercapacitors
2271	996	energy_storage	cycle_stability	1000.0	cycles	Ti2N Ti3C2Tx showed excellent cycle stability
2272	997	energy_storage	Capacitance	353.77	F/g	Ti3C2Tx MXene is used in supercapacitors for high-performance energy storage
2273	997	energy_storage	Energy_Density	32.84	million	Global market value of MXene is projected to reach 32.84 million in 2023
2274	997	energy_storage	CAGR	24.03	%	MXene industry is expected to grow with a CAGR of 24.03 by 2029
2275	997	energy_storage	Sales_Volume	415.57	Kg	Sales volume of MXene is expected to increase from 415.57 Kg in 2023 to 1522.80 Kg by 2029
2276	1001	energy_storage	specific capacitance	380.0	mF/cm²	exhibited in all-solid-state supercapacitor device
2277	1001	energy_storage	energy density	68.4	μWh/cm²	exhibited in all-solid-state supercapacitor device at 540 μW/cm²
2278	1002	sensors	response_time	3.0	s	Ultra-fast fire alarm response
2279	1002	sensors	reusability	0.0	n/a	MXene PVP films are reusable in fire response
2280	1002	sensors	stiffness	0.0	n/a	TPMS spacers with tunable stiffness
2281	1002	sensors	voltage_output	0.0	n/a	Thinner TPMS spacers (0.2 mm) provide higher voltage output
2282	1004	energy_storage	Capacitance	476.9	F/g	Ti3C2Tx-P as flexible electrode of supercapacitor
2283	1004	energy_storage	Capacitance	103.0	F/g	Quasi-solid flexible supercapacitor device
2284	1004	energy_storage	Energy_Density	15.8	Wh/kg	Quasi-solid flexible supercapacitor device at 250 W/kg
2285	1005	energy_storage	Capacitance	319.1	F/g	Ti3C2Tx V2O5 (MV2) film as electrode
2286	1005	energy_storage	Capacitance_Retention	72.1	%	SSC after 8000 charge discharge cycles
2287	1005	energy_storage	Energy_Density	18.43	Wh/kg	SSC at 603.2 W/kg
2288	1005	energy_storage	Capacitance_Retention	83.9	%	ASC after 8000 charge discharge cycles
2289	1005	energy_storage	Energy_Density	20.83	Wh/kg	ASC at 374.94 W/kg
2290	1006	energy_storage	Capacitance	815.0	F/g	obtained in three-electrode setup
2291	1006	energy_storage	Capacitance	227.0	F/g	obtained in ionic electrolyte
2292	1006	energy_storage	Energy_Density	102.0	Wh/kg	obtained in ionic electrolyte
2293	1006	energy_storage	Energy_Density	1.887	mW h/cm3	obtained in ionic electrolyte
2294	1007	energy_storage	specific_energy	18.61	Wh/kg	achieved in a symmetric MXenes supercapacitor
2295	1008	energy_storage	reversible_capacity	126.7	mAh/g	at 3000 mA/g
2296	1008	energy_storage	cycling_stability	1700.0	cycles	at 150 mA/g
2297	1008	energy_storage	specific_capacity	300.0	mAh/g	assembled lithium-ion batteries with LiFePO4 positive electrode
2298	1009	energy_storage	energy_density	19.0	Wh/kg	asymmetric supercapacitor device
2299	1010	energy_storage	Capacitance	337.0	F/g	for wire-shaped supercapacitors
2300	1010	energy_storage	Capacitance	259.0	F/g	for solid-state symmetric wire-shaped supercapacitors
2301	1010	energy_storage	Energy_Density	7.28	Wh/kg	for solid-state symmetric wire-shaped supercapacitors
2302	1011	energy_storage	specific_capacity	196.94	mAh/g	for ammonium-ion supercapacitors
2303	1011	energy_storage	energy_density	50.08	Wh/kg	for ammonium-ion supercapacitors
2304	1012	energy_storage	capacitance_retention	91.7	%	after 5000 cycles
2305	1013	energy_storage	Energy_Density	316.0	Wh/kg	button-type asymmetric SCs at 20 C
2306	1013	energy_storage	Energy_Density	230.0	Wh/kg	low temperature (20 C) asymmetric SC
2307	1013	energy_storage	Power_Density	1250.0	W/kg	button-type asymmetric SCs at 20 C
2308	1014	energy_storage	Capacitance	1633.0	F/g	High gravimetric capacitance for energy storage
2309	1014	energy_storage	Rate_Performance	1492.0	F/g	Excellent rate performance for energy storage
2310	1014	wearable_devices	Compressibility	60.0	%	Compression-tolerant electrode for wearable devices
2311	1015	energy_storage	operating_time	600.0	s	digital meters can operate for more than 600 s
2312	1015	energy_storage	flexibility	15000.0	bending_cycles	suffering from 15,000 bending cycles under 90°
2313	1017	energy_storage	specific capacitance	373.0	F/g	achieved at 0.4 A/g for MXene WS2 nanocomposite
2314	1017	energy_storage	specific capacitance	322.0	F/g	achieved at 5 mV/s for MXene WS2 nanocomposite
2315	1017	energy_storage	specific capacitance	71.0	F/g	achieved at 0.4 A/g for MXene
2316	1017	energy_storage	specific capacitance	98.0	F/g	achieved at 5 mV/s for MXene
2317	1017	energy_storage	specific capacitance	47.0	F/g	achieved at 0.4 A/g for WS2
2318	1017	energy_storage	specific capacitance	58.0	F/g	achieved at 5 mV/s for WS2
2319	1017	sensors	charge transfer resistance	2.29	Ω	for MXene WS2 nanocomposite
2320	1017	sensors	charge transfer resistance	3.41	Ω	for MXene
2321	1017	sensors	charge transfer resistance	5.25	Ω	for WS2
2322	1018	energy_storage	Cycle_stability	9000.0	cycles	Maintained 80% of initial specific capacitance
2323	1019	energy_storage	Capacitance	399.0	F/g	Al-Ti3C2Tx film electrode
2324	1019	energy_storage	Capacitance	342.0	F/g	Ti3C2Tx film electrode
2325	1019	energy_storage	Rate_Performance	63.6	%	Al-Ti3C2Tx film electrode
2326	1019	energy_storage	Rate_Performance	55.6	%	Ti3C2Tx film electrode
2327	1021	energy_storage	Energy_Density	45.7	Wh/kg	developed symmetric supercapacitor (SSC) delivers this energy density at a power density of 1.1 kW/kg
2328	1021	energy_storage	Cyclic_Stability	78.0	%	capacity retention after 10000 cycles for the symmetric supercapacitor
2329	1021	energy_storage	Open_Circuit_Voltage	1.34	V	stable open circuit voltage after 12 h for the symmetric supercapacitor
2330	1022	energy_storage	specific_capacitance	1308.3	mF/cm²	MXene ribbons exhibit high specific capacitance for supercapacitors
2331	1023	energy_storage	energy_density	\N	not specified	assembled symmetrical FSC based on BCT fiber presents favorable mass capacitance and excellent energy density
2332	1024	energy_storage	specific_capacitance	365.1	F/g	phosphate-doped Ti3C2Tx electrode
2333	1024	energy_storage	energy_density	10.76	Wh/kg	flexible supercapacitor device
2334	1024	energy_storage	capacitance_retention	84.51	%	after 5000 cycles at 1 A/g
2335	1024	energy_storage	capacitance_retention	90.09	%	after bending at different angles
2336	1025	energy_storage	energy_density	44.0	Wh/kg	achieved in an asymmetric supercapacitor
2337	1025	energy_storage	power_density	2640.0	W/kg	achieved in an asymmetric supercapacitor
2338	1025	energy_storage	operation_time	2.0	min	powering a multifunctional display
2339	1025	energy_storage	operating_voltage	1.7	V	extended by using an ionic liquid-based gel electrolyte
2340	1025	energy_storage	capacitance_retention	100.0	%	after 1000 charge-discharge cycles
2341	1025	energy_storage	coulombic_efficiency	75.0	%	after 1000 charge-discharge cycles
2342	1026	photocatalysis	degradation efficiency	96.05	%	for tetracycline (TC) degradation in 120 min
2343	1026	energy_storage	specific capacitance	522.0	F/g	at 0.5 A/g
2344	1026	energy_storage	capacitance retention	92.01	%	after 5000 cycles
2345	1027	energy_storage	Areal_Capacitance	522.0	mF/cm²	Used in quasi-solid-state supercapacitor
2346	1027	energy_storage	Energy_Density	94.7	μWh/cm²	Used in quasi-solid-state supercapacitor
2347	1027	energy_storage	Power_Density	573.0	μW/cm²	Used in quasi-solid-state supercapacitor
2348	1028	energy_storage	specific capacitance	576.7	F/g	Ti3C2Tx Co3O4 hybrid composite electrode
2349	1028	energy_storage	gravimetric capacity	128.0	F/g	Ti3C2Tx Co3O4 hybrid composite electrode
2350	1029	energy_storage	specific capacitance	985.0	F/g	achieved at a current density of 1 Ag-1 within the potential range from 0.5 V to 0.6 V
2351	1029	energy_storage	SC retention	96.53	%	after 104 cycles at a current density of 10 Ag-1
2352	1029	energy_storage	energy density	165.53	Wh/kg	at a power density of 1100 W/kg
2353	1030	energy_storage	capacitance	2080.1	mF/cm²	Area-specific capacitance of the composite electrode
2354	1030	energy_storage	cyclic_stability	91.0	%	Capacitance retention after 10,000 charge discharge cycles
2355	1031	energy_storage	specific_capacitance	72.0	%	Increase in specific capacitance for Ti3C2Tx PANI compared to pristine Ti3C2Tx
2356	1031	energy_storage	specific_capacitance	208.0	%	Increase in specific capacitance for Ti3C2Tx PPy compared to pristine Ti3C2Tx
2357	1032	energy_storage	specific_capacitance	660.0	F/g	asymmetric supercapacitor configuration
2358	1032	energy_storage	energy_density	33.3	Wh/kg	asymmetric supercapacitor configuration
2359	1032	energy_storage	power_density	1683.0	W/kg	asymmetric supercapacitor configuration
2360	1032	energy_storage	specific_capacitance	223.12	F/g	solid-state supercapacitor device
2361	1032	energy_storage	energy_density	7.74	Wh/kg	solid-state supercapacitor device
2362	1032	energy_storage	power_density	292.6	W/kg	solid-state supercapacitor device
2363	1032	energy_storage	capacity_retention	97.35	%	after 10,000 cycles at 10 A/g
2364	1032	energy_storage	capacity_retention	96.04	%	after 10,000 cycles
2365	1032	energy_storage	coulombic_efficiency	98.69	%	after 10,000 cycles
2366	1033	energy_storage	Cycle_Stability	89.5	%	Retention of initial capacitance after 20,000 cycles
2367	1033	energy_storage	Bending_Resistance	1000.0	cycles	Retention of capacitance after 1000 cycles of 180° bending
2368	1033	energy_storage	Operating_Temperature	100.0	°C	Operation at 100°C with high specific capacitance
2369	1034	energy_storage	Energy_Density	72.4	Wh/kg	Achieved at 800.12 W/kg
2370	1034	energy_storage	Capacitance	1896.8	F/g	For the positrode (V-CoP MX HCF)
2371	1034	energy_storage	Capacitance	405.5	F/g	For the negatrode (Co-CNT CNF)
2372	1034	energy_storage	Cycling_Stability	91.4	%	After 10,000 charge-discharge cycles
2373	1034	energy_storage	Flexibility	\N	performance	Maintained regardless of bending degree
2374	1036	energy_storage	capacitance	276.0	F/g	Stable electrochemical performance at different compressive strains
2375	1036	wearable_supercapacitors	deformation_capabilities	80.0	%	Can be compressed into flexible film at 80% compression
2376	1037	energy_storage	energy storage capacity	50.0		up to 50 enhancement in the initial energy storage capacity
2377	1038	energy_storage	Capacitance	321.0	F/g	SSA-protected MXene retains unchanged specific capacitance after long time
2378	1038	energy_storage	Capacitance	299.0	F/g	Fresh MXene specific capacitance at 1 A/g
2379	1039	energy_storage	energy_density	80.0	Wh/kg	exceeds most recently published works
2380	1039	energy_storage	cyclic_life	10000.0	cycles	retained 96% of initial capacity
2381	1039	energy_storage	cyclic_life	20000.0	cycles	retained 92% of initial capacity
2382	1039	energy_storage	operating_voltage	1.6	V	broad potential range
2383	1040	energy_storage	Capacitance	871.3	mF/cm²	Achieved at a current density of 5 mA/cm²
2384	1040	energy_storage	Capacitance	188.2	mF/cm²	Achieved at a current density of 5 mA/cm²
2385	1040	energy_storage	Energy_Density	106.7	μWh/cm²	At an areal power density of 420 μW/cm²
2386	1041	energy_storage	Cyclic_Stability	95.0	%	Symmetric SCs with 1 M H3PO4 after 25,000 cycles
2387	1041	energy_storage	Cyclic_Stability	94.0	%	Symmetric SCs with 1 M H2SO4 after 25,000 cycles
2388	1041	energy_storage	Power_Density	800.0	W/kg	SC device using H3PO4 gel electrolyte
2389	1041	energy_storage	Energy_Density	72.0	Wh/kg	SC device using H3PO4 gel electrolyte
2390	1042	energy_storage	Energy_Density	43.5	Wh/kg	for MnCo2O4-25 wt MXene activated carbon capacitor
2391	1043	energy_storage	specific capacitance	1531.2	F/g	for asymmetric supercapacitor
2392	1043	energy_storage	energy density	58.8	Wh/kg	for asymmetric supercapacitor
2393	1043	energy_storage	power density	800.3	W/kg	for asymmetric supercapacitor
2394	1043	electrocatalysis	Tafel slope	37.7	mV/dec	for hydrogen evolution reaction (HER)
2395	1044	energy_storage	Energy_Density	158.7	µW h/cm²	for asymmetric supercapacitors
2396	1044	energy_storage	Capacitance	1161.4	mF/cm²	for flexible electrode in supercapacitors
2397	1044	energy_storage	Cycle_Stability	89.6	%	after 15,000 charging discharging cycles
2398	1045	energy_storage	Capacitance	685.77	mF/cm²	At a scan rate of 10 mV/s
2399	1045	energy_storage	Capacitance	497.41	mF/cm²	At a scan rate of 1000 mV/s
2400	1045	energy_storage	Energy_Density	128.78	μWh/cm²	At a power density of 850 μW/cm²
2401	1045	energy_storage	Energy_Density	101.15	μWh/cm²	At a power density of 17,000 μW/cm²
2402	1045	energy_storage	Capacitance_Retention	115.0	%	After 10,000 cycles
2403	1046	energy_storage	specific_capacity	1541.6	C/g	MXene CuS electrode
2404	1046	energy_storage	specific_capacity	255.6	C/g	Fe2O3 rGO electrode
2405	1046	energy_storage	energy_density	74.1	Wh/kg	MXene CuS Fe2O3 rGO device
2406	1046	energy_storage	power_density	849.8	W/kg	MXene CuS Fe2O3 rGO device
2407	1048	energy_storage	Capacitance	498.3	F/g	h-Ti3C2Tx 150 C 12h film electrode
2408	1048	energy_storage	Capacitance	1911.0	F/cm3	h-Ti3C2Tx 150 C 12h film electrode
2409	1048	energy_storage	Rate_Performance	63.0	%	h-Ti3C2Tx 150 C 12h film electrode
2410	1048	energy_storage	Cycling_Stability	98.2	%	h-Ti3C2Tx 150 C 12h film electrode
2411	1048	energy_storage	Areal_Capacitance	3.23	F/cm2	thick h-Ti3C2Tx 150 C 12h film electrode
2412	1048	energy_storage	Capacitance	117.0	F/g	flexible supercapacitor device
2413	1048	energy_storage	Energy_Density	23.4	Wh/kg	flexible supercapacitor device
2414	1048	energy_storage	Cycling_Stability	84.0	%	flexible supercapacitor device
2415	1049	energy_storage	Capacitance	300.0	F/g	Ti3C2Tx MXene shows high capacitance for supercapacitor applications
2416	1049	energy_storage	Cycle_Life	10000.0	cycles	Ti3C2Tx MXene exhibits extended cycle life for supercapacitors
2417	1050	energy_storage	specific_capacitance	353.77	F/g	Enhanced charge storage capability and superior rate performance attributed to synergistic effects of MQDs
2418	1051	energy_storage	specific_capacitance	1126.0	F/g	MXene Mn0.8Ni0.2Se as supercapacitor electrode material
2419	1051	energy_storage	energy_density	46.18	Wh/kg	asymmetric supercapacitor with activated carbon cathode and Mn0.8Ni0.2Se anode
2420	1052	energy_storage	Energy_Density	24.6	Wh/kg	asymmetric supercapacitor with a-Ag Ti3C2Tx as negative electrode and RuO2 CC as positive electrode
2421	1053	energy_storage	specific capacitance	15.5	mF/cm²	R-GO-M-P-based supercapacitors
2422	1053	energy_storage	working potential	2.4	V	achieved by in-series R-GO-M-P supercapacitors
2423	1053	energy_storage	capacitance retention	93.35	%	after 1000 charge-discharge cycles
2424	1053	energy_storage	capacitance retention	142.0	%	after 1000 bending test cycles
2425	1054	energy_storage	discharge_time	500.0	s	NiWO4 MXene CNTs composite exhibits discharge time of 500 s as compared to NiWO4 (276 s) and NiWO4 MXene (390 s)
2426	1054	energy_storage	specific_capacitance	1250.0	F/g	NiWO4 MXene CNTs composite shows specific capacitance of 1250 F/g
2427	1054	water_splitting	Tafel_slope_HER	77.0	mV/dec	NiWO4 MXene CNTs shows Tafel slope of 77 mV/dec for HER
2428	1054	water_splitting	Tafel_slope_OER	91.0	mV/dec	NiWO4 MXene CNTs shows Tafel slope of 91 mV/dec for OER
2429	1055	energy_storage	Capacitance	112.0	F/g	Flexible solid-state biodegradable supercapacitor (FSBSC)
2430	1055	energy_storage	Energy_Density	62.3	Wh/kg	Flexible solid-state biodegradable supercapacitor (FSBSC)
2431	1055	biomedical	Biodegradability	30.0	hours	Ti3C2Tx film electrode and assembled solid-state biodegradable supercapacitor (SBSC) devices degraded in H2O2 solution
2432	1056	energy_storage	energy_density	36.67	Wh/kg	assembled in an asymmetric supercapacitor
2433	1056	energy_storage	capacity_retention	88.2	%	after 5000 cycles in an asymmetric supercapacitor
2434	1056	energy_storage	rate_performance	81.0	-	initial capacity at 10 A/g
2435	1057	energy_storage	specific_capacitance	631.0	F/g	at 2 A/g
2436	1057	energy_storage	capacitance_retention	82.0	%	after 150 days
2437	1057	energy_storage	capacitance_retention	90.0	%	after 10,000 cycles at 10 A/g
2438	1057	energy_storage	energy_density	59.1	Wh/kg	in a three-electrode system
2439	1057	energy_storage	power_density	1440.0	W/kg	in a three-electrode system
2440	1058	energy_storage	capacitance	353.77	F/g	Ti3C2Tx MXene is suitable for supercapacitor (SC) applications due to its high conductivity and active edge sites.
2441	1059	energy_storage	energy_density	20.1	Wh/kg	achieved by the assembled asymmetric supercapacitor
2442	1060	energy_storage	specific_capacitance	3.6	F/g	at 4 mA/g current density
2443	1060	energy_storage	cycling_stability	80.0	%	after 2000 cycles at 10 mA/g
2444	1060	energy_storage	self_healing_efficiency	66.88	%	after 48 h of healing at room temperature
2445	1061	energy_storage	specific_capacity	3500.0	mAh/g	in lithium-ion batteries
2446	1061	energy_storage	polysulfide_binding_energy	1.4	eV	in lithium-sulfur batteries
2447	1061	energy_storage	volumetric_capacitance	1000.0	F/cm³	in supercapacitors
2448	1061	energy_storage	capacity_retention	90.0	%	after 2000 cycles
2449	1061	energy_storage	rate_capability	100.0	C	in various energy storage applications
2450	1062	energy_storage	energy_density	5.0	Wh/kg	delivered by a supercapacitor device using Ti3C2Tx MXene and activated carbon
2451	1062	energy_storage	power_density	1000.0	W/kg	delivered by a supercapacitor device using Ti3C2Tx MXene and activated carbon
2452	1063	energy_storage	Cycle_Life	8000.0	cycles	94.9% of initial performance retained
2453	1063	energy_storage	Single_Turn_Decay_Rate	0.00019	per cycle	at 10 mA/cm²
2454	1064	energy_storage	capacity retention	93.1	%	after 5000 GCD cycles
2455	1064	energy_storage	capacity retention	90.3	%	after 5000 working cycles
2456	1065	energy_storage	specific_capacitance	2089.0	mF/cm²	achieved in CuMnHS MX
2457	1065	energy_storage	specific_capacitance	382.9	mF/cm²	achieved in symmetrical flexible all-solid-state supercapacitor
2458	1065	energy_storage	energy_density	53.18	μWh/cm²	achieved in symmetrical flexible all-solid-state supercapacitor at 277.8 μW/cm²
2459	1065	electromagnetic_shielding	reflection_loss	53.42	dB	achieved at 6.08 GHz, thickness 4 mm
2460	1065	electromagnetic_shielding	band_coverage	\N	bands	adjustable absorbing properties
2461	1066	energy_storage	Energy_Density	72.89	Wh/kg	in flexible quasi-solid-state supercapacitors (FSSCs)
2462	1066	energy_storage	Power_Density	16780.0	W/kg	in flexible quasi-solid-state supercapacitors (FSSCs)
2463	1067	energy_storage	specific_capacitance	348.14	F/g	MPA2.0 demonstrated high specific capacitance
2464	1067	energy_storage	energy_density	37.8	Wh/kg	MPA2.0-based supercapacitor showed high energy density
2465	1067	energy_storage	power_density	1800.0	W/kg	MPA2.0-based supercapacitor showed high power density
2466	1068	energy_storage	specific_capacitance	1460.0	F/g	at current density of 2 A/g
2467	1068	energy_storage	capacitance_retention	91.8	%	after 5000 cycles
2468	1068	energy_storage	coulombic_efficiency	92.0	%	after 5000 cycles
2469	1068	catalysis	overpotential	104.0	mV	at current density of 10 mA/cm² for hydrogen evolution reaction
2470	1068	catalysis	Tafel_slope	65.0	mV/dec	for hydrogen evolution reaction
2471	1069	energy_storage	specific_capacitance	357.0	F/g	achieved by (Ti3C2Tx)90(rGO)10 composition
2472	1070	energy_storage	energy_density	46.4	W h kg-1	asymmetric supercapacitor
2473	1070	energy_storage	power_density	4.0	kW kg-1	asymmetric supercapacitor
2474	1071	energy_storage	specific_capacitance	449.0	F/g	for N-Ti3C2Tx electrode
2475	1071	energy_storage	energy_density	9.57	Wh/kg	for quasi-solid-state flexible device
2476	1071	energy_storage	cyclic_stability	80.4	%	after 8000 cycles
2477	1072	energy_storage	specific_capacitance	870.7	C/g	at a current density of 1 A/g
2478	1072	energy_storage	specific_capacitance	148.0	F/g	at 0.5 A/g
2479	1072	energy_storage	energy_density	46.3	Wh/kg	for hybrid supercapacitor
2480	1072	energy_storage	power_density	370.0	W/kg	for hybrid supercapacitor
2481	1072	energy_storage	power_density	7500.0	W/kg	for hybrid supercapacitor
2482	1072	energy_storage	energy_density	25.6	Wh/kg	for hybrid supercapacitor
2483	1073	energy_storage	cycling_stability	81.6	%	initial capacitance maintained after 20,000 cycles
2484	1073	energy_storage	energy_density	35.5	Wh/kg	achieved in Ti3C2Tx NiCoCu-LDH activated carbon hybrid supercapacitor
2485	1074	energy_storage	Capacitance	358.5	F/g	Ti3C2Tx MXene for supercapacitor application
2486	1074	energy_storage	Capacitance	892.0	F/g	MX NiO composite for supercapacitor application
2487	1074	energy_storage	Capacitance	171.0	F/g	Ti3C2Tx-based symmetric supercapacitor in 6 M KOH electrolyte
2488	1074	energy_storage	Capacitance	461.0	F/g	MX NiO-based symmetric supercapacitor in 6 M KOH electrolyte
2489	1075	energy_storage	specific_energy	66.3	Wh/kg	for hybrid supercapacitors
2490	1075	energy_storage	specific_energy	49.8	Wh/kg	for hybrid supercapacitors
2491	1075	energy_storage	capacity	1341.4	C/g	for hybrid supercapacitors
2492	1075	energy_storage	cyclic_stability	90.9	%	for hybrid supercapacitors
2493	1075	energy_storage	cyclic_stability	97.3	%	for hybrid supercapacitors
2494	1076	energy_storage	Energy_Density	20.0	Wh/kg	in all-solid-state NiGa-LDH Ti3C2Tx MXene activated carbon (AC) asymmetric supercapacitor (AASCs)
2495	1076	energy_storage	Power_Density	400.0	W/kg	in all-solid-state NiGa-LDH Ti3C2Tx MXene activated carbon (AC) asymmetric supercapacitor (AASCs)
2496	1077	energy_storage		0.0		
2497	1077	wastewater_treatment		0.0		
2498	1078	energy_storage	Capacitance	603.12	mF/cm²	Mg-Ti3C2Tx MS aerogel shows high area capacitance at 100 mA/cm²
2499	1078	energy_storage	Energy_Density	93.87	μWh/cm²	Asymmetric supercapacitor achieves high energy density at high power density
2500	1078	energy_storage	Cycling_Stability	10000.0	cycles	Asymmetric supercapacitor shows high stability with 90.2% capacity retention after 10,000 cycles
2501	1079	energy_storage	specific_capacity	770.0	C/g	fabricated electrode material
2502	1079	energy_storage	capacity_retention	97.2	%	after 3500 cycles at 8 A/g
2503	1079	energy_storage	energy_density	73.0	Wh/kg	assembled supercapacitor device
2504	1079	energy_storage	power_density	900.0	W/kg	assembled supercapacitor device
2505	1080	energy_storage	energy_density	15.5	Wh/kg	asymmetric λ-MnO2 Ti3C2Tx MXene SC
2506	1080	energy_storage	areal_energy_density	39.9	μWh/cm²	flexible λ-MnO2 Ti3C2Tx asymmetric SC
2507	1081	energy_storage	Energy_Density	73.9	Wh/kg	Achieved in a solid-state asymmetric supercapacitor (ASC) device
2508	1082	energy_storage	voltage_window	1.7	V	asymmetric supercapacitor (ASC) assembled with MGC film as negative electrode and MnO2 as positive electrode
2509	1083	energy_storage	specific_capacitance	908.0	mF/g	structural supercapacitor device with epoxy-solvate ionic liquid bicontinuous solid electrolyte
2510	1083	energy_storage	specific_capacitance	157.0	F/g	MXene-coated carbon fibre electrode
2511	1084	energy_storage	specific_capacitance	430.0	F/g	MXene-PANI symmetric supercapacitor
2512	1084	energy_storage	energy_density	38.0	Wh/kg	at a power density of 808 W/kg
2513	1085	energy_storage	Energy_Density	35.3	Wh/kg	Demonstrated in all-solid asymmetric supercapacitors
2514	1085	energy_storage	Power_Density	486.1	W/kg	Demonstrated in all-solid asymmetric supercapacitors
2515	1085	wearable_devices	Voltage	1.8	V	LED lit up by connecting two ASCs in series
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materials (material_id, paper_id, mxene_composition, composite_material, synthesis_method, fabrication_method) FROM stdin;
759	620	Ti3C2Tx	MXene-BC composites	vacuum self-assembly technique	vacuum self-assembly technique
760	621		polyaniline nanowires modified MXene quantum dots graphene composite fibers (PANI MQDs GF)	microfluidic technique assisted wet spinning method	microfluidic technique combined with wet spinning strategy
761	622	CuCoTiO2	CuCoTiO2 MXene	hydrothermal method	cost-effective hydrothermal method
762	623	Ti3C2Tx	ppy MXene 4-O-TEMPO (pMT)	Not explicitly mentioned	Vacuum filtration
763	624				
764	625	Ti3C2Tx	MXene-templated zeolites (MTZ), h-BN MTZ, GQDs MTZ	Not explicitly mentioned	Not explicitly mentioned
765	626		hollow hierarchical Al-doped CoP nanocubes bridged by MXene sheets	room co-precipitation method of bimetallic AlCoPBA on the MXene surface	phosphorated in a tube furnace using NaH2PO2 as a phosphorus source
766	627	Ti3C2Tx	AQ-2-MX, AQ-2 3 min-MX, AQ-1-MX, MA-NTCDA-MX, MA-PTCDA-MX, MA-PMDA-MX	Ex-situ and in-situ methods	Grafting anthraquinone moieties and polyimide covalent organic frameworks (PI-COFs) onto carbon fiber (CF) surfaces
767	628		MXene rGO W18O49	hydrothermal and reduction methods	fabricated as supercapacitor electrode
768	629	Ti3C2Tx		etching of Ti3AlC2 MAX phase using tetramethylammonium tetrafluoroborate (TMATFB)	
769	630	Ti3C2Tx	MXene Metal LDHs, MXene Metal sulfides, MXene Metal oxides, MXene Conductive polymers, MXene Carbon nanomaterials	top-down and bottom-up methods	selectively etching the layered parent MAX precursors
770	631	Ti3C2Tx	quinone-functionalized viologen molecules with reduced graphene oxide (rGO) sheets	simple mixing at room temperature	coating on rGO sheets and pairing with Ti3C2Tx MXene as negative electrodes
771	632			fluorinated etchants (e.g., HF, LiF HCl)	
772	633	Ti3C2Tx		2-methylimidazole induced in-situ formation of MXene microgel	vacuum filtration
773	634	Ti3C2Tx	m-Ti3C2 MXene nanofibers	deep alkali treatment	assembled with modified electrodes
774	634	AlxV2O5	AlxV2O5-NMP	polar organic molecule intercalation (NMP)	assembled with modified electrodes
775	635	Ti3C2Tx	activated carbon (AC), graphene, carbon nanotubes (CNTs), transition metal oxides, conducting polymers (CPs), MOF	F-free, fluoride-based, and HF acid etching	integration of MXenes with other superior elements for generating MXene-based composite electrode materials
776	636	V4C3Tx	NiGa-layered double hydroxide (NiGa-LDH) on V4C3Tx MXene	hydrothermal procedure leveraging electrostatic interactions	in-situ growth of NiGa-LDH on V4C3Tx MXene
777	637		wood-derived carbon electrodes	fungal degradation and low concentration KOH solution treatment	MXene anchoring
778	638		MXene NiCo-LDH Co9S8	rational synthesized	fabricated supercapacitor device
779	639				hydrothermal synthesis, freeze drying, templating methods
780	640	Ti3C2Tx	MXene MoO3 hybrid aerogel	electrostatic self-assembly	freeze-drying
781	641		CMC carbonization	high-temperature pyrolysis of NaHCO3	annealing process and in situ bubbling
782	642		MXene Ni-Co phosphide (MX NCP) hybrid material	hydrothermal reaction followed by phosphorization	fabricated an asymmetric supercapacitor (ASC) with MX NCP and porous nanocarbon (PNC)
783	643	Ti3C2Tx	LDH Ti3C2Tx nanohybrids	synergistically coupling Ti3C2Tx MXene with ternary hydrotalcite (NiCoMn-LDH)	constructing a composite electrode and assembling the LDH Ti3C2Tx-2 AC hybrid supercapacitor (HSC)
784	644		MXene MnO2 Fe2O3 composite	coating the MnO2 Fe2O3 particles	fabrication of a novel MXene MnO2 Fe2O3 composite as a negative electrode material for supercapacitors
785	645	Ti3C2Tx	MnO2 Ti3C2Tx nanocomposite	synergistically coupling one-dimensional (1D) MnO2 nanoneedles with two-dimensional (2D) Ti3C2Tx MXene sheet	fabricating a symmetrical flexible supercapacitor device using MnO2 Ti3C2Tx nanocomposites as electrode materials
786	646	Ti3C2Tx	porous MXene- and graphene-based films with nitrogenous and phosphorous terminals	not explicitly mentioned	fabrication of AMF, P-MF, N-PMF, and N P-PMF hybrid films
787	647		MXene-transition metal chalcogenides (TMCs)		
788	648	Ti3C2Tx	3D-MX	biothermochemistry method	film-processed capability
789	649	Ti3C2Tx	CNFs MXene-Al (CM-Al)	Not explicitly mentioned	Electrostatic self-assembly and vacuum filtration
790	650	Ti3C2Tx	MgCr2O4	co-precipitation	nanocomposite synthesis
791	651	Ti3C2Tx		not explicitly mentioned	modified electrophoretic deposition (MEPD) method
792	652	Ti3C2TX	Ti3C2TX-reduced graphene oxide (RGO) hydrogel	low-temperature hydrothermal graphene oxide (GO)-gelation process	electrochemical intercalation technology
793	653	Ti3C2Tx		microwave-assisted hydrothermal heating with NaOH etchant	
794	654	Ti3C2Tx	polymeric composites	wet chemical etching	chemical vapour deposition (CVD)
795	655	Ta4C3Tx	NGQD Ta4C3Tx	facile synthesis routes	solvothermal synthesis approach
796	656	CeO2 MnO2 MXene	CeO2 MXene, MnO2 MXene	SILAR deposition process	Not explicitly mentioned
797	657		Co₂O₃ MXene nanocomposite		dip-coating technique
798	658	Ti3C2Tx	NiCo2O4 MXene composite (NCO MXene)	hydrothermal technique	combining NCO MXene as the positive electrode and activated carbon (AC) as the negative electrode, forming the NCO MXene AC-ASC configuration
799	659	Ti3C2Tx	CVT PEDOT	hydrothermal method	chemical oxidation
800	660	Ti3C2Tx	polymer coatings	spontaneous polymerization of acrylic acid using aryl diazonium coupling agent	coagulation strategy for spinning fibers from liquid crystal MXene dispersions
801	661	Ti3C2Tx	CoNi2Se4 MXene heterostructure	hydrothermal method	phosphating treatment
802	662	Ti3C2Tx	MnO2 Ti3C2Tx	solution immersion technique	self-assembled electrodes
803	663	Ti3C2Tx	biomass-derived activated carbon (AC)	two-stage activation process with KOH in different weight ratios	incorporating activated carbon as a spacer within Ti3C2Tx MXene layers
804	664		MoSSe CNT MXene electrode		incorporating MoSSe CNT into MXene films
805	665	Ti3C2Tx	Ti3C2Tx TiN	not explicitly mentioned	not explicitly mentioned
806	666	Ti3C2Tx	nanoflower-like hollow NiMnCo-OH MXene (NMCM) composites	multi-element doping and electrostatic self-assembly strategies	simple and controllable method
807	667	Ti3C2Tx	α-Fe2O3	self-assembly method via electrostatic attraction	self-assembly method via electrostatic attraction between negatively charged Ti3C2Tx MXenes and positively charged cocoa-like α-Fe2O3 nanoparticles at room temperature
808	668	Ti3C2Tx	BiOBr Ti3C2	in situ inserting BiOBr nanoparticles into Ti3C2Tx MXenes	in situ inserting BiOBr nanoparticles into Ti3C2Tx MXenes
809	669		MXene-CTAB	pre-intercalated strategies	combining with multi-walled carbon nanotubes-FeFe(CN)6 cathode
810	669		MWCNT-FeHCF		
811	670	Ti3C2		ultrafast microwave-assisted method	
812	671	Ti3C2Tx		facile HF etching wet chemical method	
813	672	Ti3C2Tx	PANI Ti3C2Tx Ni3S4, PPY Ti3C2Tx Ni3S4, PEDOT Ti3C2Tx Ni3S4	doping of Ti3C2Tx with Ni3S4 and conducting polymers	preparing porous Ti3C2Tx film
814	673	Ti3C2TX	CTAB-functionalized polypyrrole nanospheres (C-PPy NS) encapsulated by Ti3C2TX nanosheets	probe ultrasonication to modulate flake sizes of Ti3C2TX nanosheets	electrostatic self-assembly of CTAB-functionalized PPy NS with Ti3C2TX nanosheets
815	674	Ti3C2Tx		W O emulsion-assisted assembly	W O emulsion-assisted assembly
816	675	Ti3C2Tx	NiFe-LDH MnCO3 MXene (NFMM)	hydrothermal method	not explicitly mentioned
817	676		carbon-based materials, conducting polymers, metal oxides	etching techniques	
818	677	Ti3C2Tx	Mn2+-doped Co(OH)2 nanosheets	electrodeposition	impregnation with Ti3C2Tx nanosheets suspension
819	678	Ti3C2Tx		mild etching procedure	pressureless encapsulating sintering method
820	679	Ti3C2Tx	MnO2 nanoshells		direct use as pseudo-capacitive electrode
821	680	Ti3C2Tx	MXene Graphene Nanoplatelets (GNPs)	Not explicitly mentioned	Not explicitly mentioned
822	681	Ti3C2Tx	activated carbon-nafion (AC-N), activated carbon-polyvinylidene fluoride (AC-P)	not explicitly mentioned	not explicitly mentioned
823	682	Ti3C2Tx	NiMoO4-P	physical mixing of both the Ti3C2Tx and NiMoO4 solution	free-standing electrode
824	682	Ti3C2Tx	NiMoO4-H	hydrothermal and calcination treatment	free-standing electrode
825	683	Ti3C2	Co(BDC, TEDA) Ti3C2	one-step solvothermal approach	in situ growth of three-dimensional Co(BDC, TEDA) MOFs within Ti3C2 MXene interlayers
826	684	Ti3C2Tx		hydrofluoric acid (HF)	
827	685		CuO MoS2 MXene ternary heterostructure	not explicitly mentioned	not explicitly mentioned
828	686	Ti3C2Tx	Ceâ Co MOFs Ti3C2Tx		
829	687	Ti3C2Tx	Fe-MXene-500 AC	FeCl3 as inducer and etchant to induce Ti3C2Tx MXene nanosheets to form microgels while mildly oxidizing MXene to TiO2, followed by etching with hydrofluoric acid	Vacuum filtration
830	688	Mo2C		simple solid-state thermal reduction technique	
831	689		Cu2O NiCo-LDH MXene (Cu2O NCL M)	sacrificial template method and electrostatic self-assembly strategy	self-templating and electrostatic self-assembly methods
832	690	Ti3C2Tx			vacuum assisted filtration
833	691		TGO-3 FeNi-MnO2	hydrothermal approach	not explicitly mentioned
834	691	tungsten carbide (MXene)	TC-3 FeNi-MnO2	hydrothermal approach	not explicitly mentioned
835	692				
836	693	Ti3C2Tx			wafer-scale fabrication
837	694	Ti3C2Tx		LiF + HCl etching method	
838	695	Ti3C2Tx		etching	
839	696	Ti3C2Tx	Mn ion-intercalated Ti3C2Tx MXene		
840	697	Ti3C2	V3S4 coupled Ti3C2 MXene	hydrothermal method	assembled asymmetric supercapacitor
841	698	Ti3C2Tx	antimony-titanium carbide MXene composite	ball milling and ultra-probe sonication processes	thermal annealing method
842	699	Ti3C2Tx	ZnSe Ti3C2Tx	hydrothermal process	self-assembled ZnSe microspheres integrated into Ti3C2Tx MXene nanosheets
843	700	Ti3C2Tx	POMCPs Ti3C2Tx composite film	not explicitly mentioned	customizable proton channels through structural design
844	701	Mo2VC2Tz		in situ solid-solution sintering of Mo2VAlC2 and liquid phase etching of the Al layer	flexible, self-supported films
845	702	Ti3C2Tx	glass fiber-epoxy composite	dip-coating method	laminated composites
846	703	Ti3C2Tx	Ti3C2Tx-CNT	Not explicitly mentioned	Use of PMMA as a binder with high active mass loading (40 mg cm-2) and dispersion of multilayered Ti3C2Tx and CNT in PMMA solution
847	704		Co1-xNixFe2O4 MXene NCs	low-temperature co-precipitation approach	simple and cost-effective low-temperature co-precipitation approach
848	705	Mo1.33C i-MXene			Ionic liquid induced gelation
849	706	Ti3C2Tx	NiCo2S4	hydrothermal method	asymmetric flexible solid-state supercapacitors
850	707	Ti3C2Tx	Ti3C2Tx MXene Ni C composites	dehydration condensation reaction between xDA and NH2 functionalized Ti3C2Tx MXene layers	simple mechanical stirring and carbonization strategy
851	708	Ti3C2Tx		LiF HCl etching method	vacuum filtration process
852	709	Ti3C2Tx			blade coating
853	710	Ti3C2Tx	MXene-based composites	etching of MAX phase	encapsulation technology
854	711	Ti3C2Tx			
855	712	Ti3C2Tx	CA MIL-101 (Cr) Ti3C2Tx	hydrothermal method	fabricating carbon aerogel-induced chromium metal-organic framework (CA MIL-101) integrated with titanium carbide MXene (CA MIL-101-(Cr) Ti3C2Tx) nanocomposites
856	713	Ti3C2Tx	ZIF 8 GO, ZIF 8 MXene	solid-state strategy	not explicitly mentioned
857	714	Ti3C2Tx	CoOx-NiO Ti3C2Tx MXene nanocomposites	atomic layer deposition (ALD)	atomic layer deposition (ALD)
858	715	Ti3C2Tx	Ti3C2Tx and nanodiamonds		
859	716	Ti3C2Tx	MXene carbon nanotubes (CNT) composite film	KOH-assisted surface termination modification	Synergistic strategy of electrode structure engineering and surface terminations modification
860	717	Ti3C2Tx	Fe2O3 nanoparticles, S,N-rGO	Etching Ti3AlC2 with Lewis acid Fe(III)	Redox self-assembly reaction of MXene and graphene oxide in hydrothermal condition containing thiourea
861	718			chemical vapor deposition	
862	719		metal chalcogenide-MXene and MOF-derived composites	hydrothermal, chemical bath deposition, and in situ growth techniques	not explicitly mentioned
863	720	Ti3C2Tx	CoS2 CuCo2S4 nanohybrid	one-pot hydrothermal synthesis	hydrothermal synthesis
864	721	Ti3C2Tx	NiMn0.1HCF MXene	self-assembly of Ti3C2Tx MXene and ultrathin layered double hydroxide (LDH) nanosheets, followed by in-situ LDH conversion	ultrasonic spraying onto carbon cloth
865	722	Ti3C2Tx	Fe2O3 Ti3C2	hydrothermal method followed by annealing	ball-milling
866	723	Ti3C2Tx	Ti3C2Tx CNF CF composite film	Not explicitly mentioned	Vacuum filtration
867	724		MXene Cu2-xSe	in situ selenization strategy	assembling an asymmetric supercapacitor device using MXene Cu2-xSe as the positive electrode and activated carbon as the negative electrode
868	725	Ti3C2Tx	PVA starch Ti3C2Tx MXene nanocomposite films		simple casting method
869	726	Ti3C2Tx		hydrothermal acidic etching	
870	727	Ti3C2Tx	graphene fiber	microfluidic spinning method	microfluidic spinning method
871	728	Ti3C2Tx			
872	729	Ti3C2Tx (implied by the context of MXene and TiC intercalation)	TiC MXene and WC MXene hybrid composites	Not explicitly mentioned	Not explicitly mentioned
873	730	Ti3C2Tx	a-CF MWCNT PANI	acid-functionalized MWCNTs were loaded into activated carbon felt by dipping and drying, then coated by polyaniline via chemical oxidation polymerization	asymmetric supercapacitor configuration using a-CF MWCNT PANI as positive electrode and Ti3C2Tx-MXene as negative electrode
874	731	Ti3C2Tx	FeNi-LDH arrays	ionic hetero-assembly	electrostatic attraction connection
875	732	Ti3C2Tx	Fe-MOF, Cu-MOF, Co-MOF, Ni-MOF	in situ method	in situ synthesis
876	733	Ti3C2Tx	CoMnO3 CoMn2O4 Ti3C2Tx	electrostatic self-assembly method	electrostatic self-assembly method
877	734	Ti3C2Tx	Vanadium nitride Porous carbon	etching the Al layers by immersing them in aqueous HF solutions and further delaminating them with DMSO	asymmetric supercapacitor cell
878	735	d-Ti3C2Tx	ZnO hexagonal prism-decorated MXene	hydrothermal method	flexible symmetric supercapacitor fabrication
879	736		NiCo2O4 MXene LDH composite	not explicitly mentioned	not explicitly mentioned
880	737		MXene graphene aerogel	not explicitly mentioned	synergistic modification strategy using polydopamine (PDA) as a molecular bridge
881	738	V2CTx	various materials	HF, MILD, electrochemical, hydrothermal, and molten salts	MXene-based heterojunction heterostructures
882	738	V2NTx	various materials	HF, MILD, electrochemical, hydrothermal, and molten salts	MXene-based heterojunction heterostructures
883	738	V4C3Tx	various materials	HF, MILD, electrochemical, hydrothermal, and molten salts	MXene-based heterojunction heterostructures
884	739	Ti3C2Tx	Co3O4 Ti3C2Tx MXene nanocomposites	vacuum filtration and hydrothermal-annealing methods	vacuum filtration and hydrothermal-annealing methods
885	740	Ti3C2Tx	CoZnOHF MXene composite	LiF HCl etching	hydrothermal method
886	741				
887	742	Ti3CNTx	rGO	sonication and ascorbic acid (AA) surface engineering	ultrasound-driven strategy
888	743	Ti3C2Tx			
889	744	Ti3C2Tx	MXene CB composite	etching Al layers from MAX phase using LiF-HCl pair	intercalating carbon black nanosheets into MXene layers
890	745		LaMnO3 MXene NCs	simple hydrothermal technique	asymmetric supercapacitor (ACS) device built with MXene and LaMnO3 MXene electrodes
891	746	Ti3C2Tx		not explicitly mentioned	not explicitly mentioned
892	747	Ti3C2Tx	NiCo2S4 Co3S4 Ti3C2Tx	self-template sacrificial method	ion exchange and in situ nucleation reaction
893	748		MnO2 MXene CC composite	hydrothermal methods	composite fabrication strategy and mild solution immersion process
894	749	Ti3C2Tx			
895	750	V2C	NiMn-LDH V2C MXene	in-situ anchoring of NiMn-LDH nanoparticles onto V2C MXene sheets via chemical bonding	fabrication of a symmetric supercapacitor (SSC) with the NiMn-LDH V2C MXene composite
896	751	Ti3C2Tx	NiCoMn-OH Ti3C2Tx	hydrothermal strategy	using ZIF-67 as the template
897	752	Ti3C2Tx	stainless steel mesh	not explicitly mentioned	spraying-baking Ti3C2Tx MXene flakes on tailored stainless steel mesh
898	753	Ti3C2Tx	PDAAQ	Chemical oxidation of DAAQ using APS as the initiating agent and HClO4 as the acidic environment	Interfacial polymerization followed by vacuum-assisted filtration and electrostatic self-assembly
899	754	Ti3C2Tx	CuS Ti3C2Tx MXene nanocomposites	integrating copper sulfide (CuS) into Ti3C2Tx layers	not explicitly mentioned
900	755	Ti3C2Tx		BF3 Lewis acid etching in sulfuric acid (H2SO4) solution	
901	756	Ti3C2Tx	MXene Carbon composite	selective etching of the high-quality MAX phase	asymmetric electrode configuration with multilayered Ti3C2Tx MXene as the cathode and plant waste-derived activated carbon (AC) as the anode
902	757	Ti3C2Tx	TiO2 nanogrooves on Ti3C2Tx MXene surface	hydrothermal treatment	fabrication of symmetric supercapacitors
903	758	Ti3C2Tx	carbon nanotube (CNT) MXene	intercalation of MXene nanosheets to establish a three-dimensional structure	gelation, introduction of third conductive materials
904	758	Ti3C2Tx	nanocellulose MXene	intercalation of MXene nanosheets to establish a three-dimensional structure	introduction of third active substances, such as conducting polymers
905	758	Ti3C2Tx	reduced graphene oxide (rGO) MXene	intercalation of MXene nanosheets to establish a three-dimensional structure	preparation of gel composite electrodes
906	758	Ti3C2Tx	3D carbon materials	intercalation of MXene nanosheets to establish a three-dimensional structure	use of sacrificial metal templates (Zn, Fe, Al)
907	758	Ti3C2Tx	carbon nanomaterials MXene composites	intercalation of MXene nanosheets to establish a three-dimensional structure	heating-free method, in-situ sacrificial metal templates
908	758	Zr3C2Tx	carbon nanomaterials MXene composites	intercalation of MXene nanosheets to establish a three-dimensional structure	not explicitly mentioned
909	758	Nb2CTx	carbon nanomaterials MXene composites	intercalation of MXene nanosheets to establish a three-dimensional structure	not explicitly mentioned
910	758	Mo2CTx	carbon nanomaterials MXene composites	intercalation of MXene nanosheets to establish a three-dimensional structure	not explicitly mentioned
911	759		reduced graphene oxides MXene (rGO MXene)	microfluidic assisted wet spinning technology	microfluidic assisted wet spinning technology
912	760	Ti3C2Tx	Ti3C2Tx CA composite	introducing dicyandiamide (DCD) to tune the complex terminals, followed by catalyst-free trimerization to form melamine, then high-temperature sintering to form g-C3N4, and finally hydrothermal reaction to oxidize g-C3N4 to cyanuric acid (CA)	multi-step reaction by introducing small organic molecules, dicyandiamide, into the interlayer of Ti3C2Tx MXene
913	761	Ti3C2Tx	Ti3C2 TiO2 CuTiO3 heterostructure	two-step process for synthesizing oxidation-controlled MXene-derived 2D 3D heterostructures	fabrication of an asymmetric supercapacitor (ASC) device
914	762	Ti3C2Tx	PEDOT:PSS wrapped delaminated Ti3C2Tx	low-cost method, mixed acid etching method followed by DMSO intercalation	solvent mixing method and coated on flexible activated carbon cloth
915	763		MXene NiCo2S4	using MXene ZIF-67 as the precursor	assembling into a hybrid supercapacitor (MNCS-1 AC HSC)
916	764	Ti3C2Tx		in-situ etching and ultrasonic assistance	vacuum filtration
917	765		HS-1T-VS MXene	one-step hydrothermal method	in-situ growth of 1T-VS2 nanosheets on the surface of an MXene
918	766				
919	767		graphene amine (GA) MXene nanocomposite		
920	768	Ti3C2Tx	Ni nanorods	glancing angle deposition technique of physical vapor deposition	glancing angle deposition technique of physical vapor deposition
921	769	Ti3C2Tx	Poly(acrylamide-co-acrylic acid)	in-situ free radical polymerization	facile one-step chemical crosslinking method
922	770		MXene reduced graphene oxide (rGO) MoO3	hydrothermal and ascorbic acid reduction techniques	vacuum-assisted filtration
923	771	Nb2CTx	Ta-doped Nb2CTx	in-situ exfoliation approach	asymmetric supercapacitor
924	772	Ti3C2T_x	PPy MXene TiO2GC	green synthesis	coating on wearable flexible carbon felt
925	773	TiO2	MXene-modified PANI hydrogel (M-PANI)	hydrothermal assembly	direct hydrothermal assembly approach
926	774	Ti3C2Tx	CuCoTex Mn3O4 Ti3C2Tx nanocomposite	one-pot method	not explicitly mentioned
927	775	Ti3C2Tx			
928	776		MXene-derived-TiO2 and NiO	thermal annealing of MXene phase	
929	777	Ti3C2Tx	Ti3C2Tx MXene polyaniline (PANI) composite films	minimum strength stratification method for MXene nanosheets, redox method for PANI nanofibers	simple physical mixing and suction filtration
930	778	TiO2 C-graphene	Mo-MX-G (MoO3-x-assisted MXene-derived TiO2 C-graphene composite)	in-situ growing MoO3-x nanoparticles on the surface of MXene-derived TiO2 C-graphene composites in one-step hydrothermal process	assembled asymmetric SC device (UPGA Mo-MX-G)
931	779	Ti3C2Tx	transition metal compounds	molten salt (MS) Shielded Synthesis (MS3)	MS etching strategy utilizing Lewis acidic salts as etchants
932	779	Ti3C2Tx	hexagonal Ti3AlC2	one-pot melting and Lewis salt additive method	MS etching
933	780	Ti3C2Tx	polyaniline Ti3C2Tx modified cotton yarn	not explicitly mentioned	coating method
934	781	Ti2CTx		HF etching	
935	781	Nb2CTx		HF etching	
936	781	V2CTx		HF etching	
937	781	Ta2CTx		HF etching	
938	781	Cr2CTx		HF etching	
939	781	Mo2CTx		HF etching	
940	781	V2NTx		HF etching	
941	781	Mo2NTx		HF etching	
942	782	Ti3C2Tx	MnMoO4-Ti3C2Tx	one-pot facile hydrothermal method	not explicitly mentioned
943	783		MXene SnS2 CNT	one-step hydrothermal method	not explicitly mentioned
944	784	Ti3C2Tx	NiCo2S4	single step-controlled electrodeposition technique	electrodeposition
945	785	Ti3C2Tx	Ti3C2Tx MXene substrate		periodic array of Ti3C2Tx MXene-based CTC structures adhered to a Ti3C2Tx MXene substrate
946	786	Ti3C2Tx	MoSe2 e-Ti3C2Tx	hydrothermal method	assembled with the MoSe2 e-Ti3C2Tx hybrid nanostructure
947	787	Ti3C2Tx	Ti3C2Tx MnO2	High-concentration NaOH solution combined with KMnO4 as an etchant	In-situ preparation
948	788	Ti3C2Tx	N, S, V co-doped MHM	Not explicitly mentioned	Not explicitly mentioned
949	789	Ti3C2Tx	MXene nanoparticles (prepared by etching with HF) and Ti3C2Tx nanosheets (prepared by HCl + LiF method)	Etching with HF for nanoparticles and etching with HCl + LiF for nanosheets	Vacuum filtration of the mixture
950	790	Ti3C2Tx	NiS2 Ti3C2Tx	hydrothermal method	hydrothermal technique
951	791	Ti3C2Tx	MXene-coated GC electrode	diazonium salt-based ultrasonic method using 4-carboxy benzene diazonium tetrafluoroborate (4-CBDF)	sonochemical method
952	792		MoS2 MXene	hydrothermal synthesis	ultrasonic spray coating
953	793	Ti3C2Tx	CoNi-OH 3D Ti3C2Tx	polystyrene nanospheres as templates to convert Ti3C2Tx from a two-dimensional sheet to a three-dimensional spherical structure	introduction of bimetallic cobalt nickel hydroxide (CoNi-OH) and incorporation of sulfonated lignin (SL) into the hydrogel
954	794	Ti3C2TX	K+-Ti3C2TX-RGO hydrogel	K+ ion intercalation into Ti3C2TX nanosheets via KOH treatment	Interconnection of intercalated multilayer Ti3C2TX with GO as a conductive binder and reduction with ascorbic acid to form a hydrogel
955	795		ZIF-8 Co-C3N4-GNR MXene	simple method	not explicitly mentioned
956	796	Ti3C2Tx	MXenes carbonaceous nanocomposites, MXenes transition metal oxide composites, MXenes transition metal-dichalcogenides composites	HF-based etching	ultrasonication
957	797	Ti3C2Tx	MnOx Ti3C2Tx MXene CNFs (carbon nanofibers)	electrospinning technique	combining electrospinning technique with carbonization treatment
958	798	Ti3C2Tx		water-free etching in deep eutectic solvents at near-ambient temperature	
959	799	Ti3C2Tx	BaTiO3 (BTO) nanoparticles	intercalation	electrode material fabrication
960	800	Ti3C2Tx	Na-MnO2-x	electrodeposition	fabricated as film electrode and assembled into asymmetric supercapacitors
961	801		MXene-Copper selenide (MCuSe)	hydrothermal method	electrochemical analysis and device assembly
962	802	Ti3C2Tx		etching the oxygen doped Ti3AlC2 MAX phase with fluorinated acid salt	in situ oxygen doping
963	803	Ti3C2Tx	conducting polymers	etching with strong, corrosive acids such as concentrated HCl and HF	various preparation schemes for composite material manufacture
964	804	Ti3C2Tx		DMSO intercalation	3D printing with shear exfoliation
965	805	Ti3C2Tx	carbon-based materials, metal oxides, spinel, polymers, metal-based nanoparticles	not explicitly mentioned	template method, self-assembly method, 3D printing method
966	806	Ti3C2Tx	FeCo2O4 FeCo2S4-MXene hybrids	solvothermal combined with self-assembly	solvothermal combined with self-assembly
967	807	Ti3C2Tx	AgNP Ti3C2Tx PU composites	electrochemical etching method, Alkali etching method, Photo Fenton method, in-situ hydrothermal method	top-down etching approach
968	808		metal sulfides, metal oxides, conductive polymers, carbon-based compounds	vacuum infiltration, solvent-assisted self-assembly, hydrothermal, ultrasonication, electrospinning	
969	808		MXene-carbon conducting polymer		
970	808		transition metal sulfide and oxide with MXene		
971	808		ternary composite of transition metal sulfide and oxide with MXene		
972	808		ternary MXene and MOF composites		
973	809	Ti3C2Tx	PAN (polyacrylonitrile)	electrospinning	carbonization
974	810	Ti3C2Tx	CuO SnO2 MXene nanohybrids	ultrasonicated coprecipitation method	not explicitly mentioned
975	811	Ti3C2Tx	PANI-MnO2	electrochemical polymerization with the addition of LiClO4	assembling an asymmetric supercapacitor based on CC PANI-MnO2 as positive electrode and CC MXene as negative electrode
976	812	Ti3C2Tx	MXene-based composites	HF etching	environment friendly fluoride-free approaches
977	813	Ti-based MXene	Zn-N-MX NCS	Amino functionalization and Zn2+ intercalation	In-situ growth of NiCo2S4 on Zn-N-MX
978	814	Ti3C2Tx	covalent organic frameworks	not explicitly mentioned	CO2-laser-based technique
979	815	Ti3C2Tx	CoGa-LDH MXene heterostructure	Peltier effect-driven rotational hydrothermal synthesis	Interlayer-engineered
980	816	Ti3C2Tx	Hanji	Not explicitly mentioned	Spray-coating
981	817	Ti3C2Tx	carbon nanotube (CNT)		vacuum filtration
982	818	Ti3C2Tx	Ti3C2Tx microgels with N and P terminals	Interlayer domain-confined strategy involving ammonium polyphosphate (APP) crosslinking	Thermal treatment at 350°C for 3 hours
983	819	Ti3C2Tx	VS2 Ti3C2Tx-MX0.25	hydrothermal process	in-situ integration
984	820	Ti3C2Tx	melamine sponge	Zn2+ ions induced gelation	confinement of melamine sponge and electric field combined with freeze-drying
985	821	Ti3C2Tx	cellulose nanocrystals (CNC)	not explicitly mentioned	vacuum-filtration
986	822	Ti3C2Tx	GaOOH Ti3C2Tx	hydrothermal synthesis	simple one-step hydrothermal method
987	823	Ti3C2Tx	NiCo2S4 Ti3C2Tx MXene	direct growth onto a binder-free nickel foam (NF) electrode	asymmetric supercapacitor device (ASC) with NCSMX NF and activated carbon (AC) as positive and negative electrodes
988	824	Ti3C2Tx	MoS2 Ti3C2Tx GO	synergistic three-dimensional (3D) crosslinking and in-situ growth strategy	assembling an asymmetric supercapacitor (ASC) with activated carbon (AC) as a negative electrode
989	825	Ti3C2Tx	MXenes containing hollow carbon nanofibers (MXHCNF) decorated with polypyrrole layers (PPy MXHCNF)	co-axial electrospinning	controlled heat treatment process using a two from one strategy
990	826	Ti3C2Tx		MILD (in situ HF generation using HCl and LiF)	
991	827	Ti3C2Tx	SnO2	delamination using TMAOH	simple sonication
992	828	Ti3C2Tx	Ti3C2Tx TiO2 heterostructures	Not explicitly mentioned	Low-temperature heat treatment
993	829	Ti3C2Tx	MXene with other materials	electrochemical etching, chemical exfoliation, evaporated nitrogen minimally intensive layer delamination (EN-MILD)	painting, printing, spraying, or dipping techniques
994	830	Ti3C2Tx		annealing method	fabricated as the electrode material of SC
995	831	Ti3C2Tx	PANI PVDF	mixing Ti3C2Tx with PANI Emeraldine salt in NMP solution using magnetic stirring	electrospinning
996	832	Ti3C2Tx	Ti2N Ti3C2Tx	N-functionalized 2D MXene with Ti2N interface engineering	Assembled into an aqueous NH4+-ion hybrid supercapacitor (AHSC) with activated carbon as anode
997	833	Ti3C2Tx	carbon	top-down etching using HF or HCl LiF	not explicitly mentioned
998	833	Ti3C2Tx	metal oxides	top-down etching using HF or HCl LiF	not explicitly mentioned
999	833	Ti3C2Tx	polymers	top-down etching using HF or HCl LiF	not explicitly mentioned
1000	833	Ti3C2Tx	bimetallic oxide or metal oxide	top-down etching using HF or HCl LiF	not explicitly mentioned
1001	834	Ti3C2Tx	CuCP MX	in-situ hydrothermal method	assembling into an all-solid-state supercapacitor device
1002	835	Ti3C2Tx	MXene PVP	Thermal oxidation treatment	Near-Field Electrospinning (NFES) technology
1003	835	Ti3C2Tx	PVDF-TrFE nanofibers with FPCB and PDMS	Not explicitly mentioned	Encapsulation in PDMS and integration with MXene PVP
1004	836	Ti3C2Tx	Ti3C2Tx-P	Rapid in-situ phosphorus doping at low temperature using sodium hypophosphate as phosphorus source	Heat treatment
1005	837	Ti3C2Tx	V2O5 nanofibers	minimal delamination method, redox method	vacuum-assisted filtration
1006	838	Ti3C2Tx	APC Ti3C2Tx SnSe2	facile hydrothermal growth and intercalation	viscous ionic electrolyte
1007	839	Ti3C2Tx	NS-Ti3C2Tx-P	photothermal-assisted synthesis based on ultraviolet radiation	symmetric MXenes supercapacitor
1008	840	Ti3C2Tx	N,P-MXene composites	hydrothermal construction of N,P elemental functional groups	coupling the N,P-MXene negative electrode to the LiFePO4 positive electrode
1009	841	Ti3C2Tx	Co Ti3C2Tx MXene	alkalizing quasi-monolayer Ti3C2Tx MXene supernatant into -OH rich sample, followed by cobalt ion chelation	assembling Co Ti3C2Tx MXene active carbon (AC) asymmetric supercapacitor device
1010	842	Ti3C2Tx	polyaniline (PANI) bacterial cellulose (BC) Ti3C2Tx hybrid fiber	not explicitly mentioned	wet spinning method
1011	843	Ti3C2Tx	amorphous MoSx nanoparticles	in situ growth on Ti3C2Tx nanosheets	ethylene glycol solvent strategy
1012	844	Ti3C2Tx	cuttlefish ink-derived carbon nanospheres composite Ti3C2Tx MXene	electrostatic self-assembly method	electrostatic self-assembly method
1013	845	Ti3C2Tx	g-C3N4 MoO3 heterostructure	vacuum filtration method	vacuum filtration method
1014	846	Ti3C2Tx	NiCo2O4 Ti3C2Tx MXene reduced graphene oxide composite aerogel	Not explicitly mentioned	Not explicitly mentioned
1015	847	V2CTx		not explicitly mentioned	electrophoretic deposition
1016	847	Ti3C2Tx		not explicitly mentioned	electrophoretic deposition
1017	848	Ti3C2Tx	MXene WS2 nanocomposite	chemical and hydrothermal methods	modification process using polyvinylidene fluoride as a binder
1018	849	Ti3C2Tx	DAAQ-M G composite material	Not explicitly mentioned	Three-dimensional (3D) interconnected structure fabricated using graphene oxide (GO), MXene, and graphene
1019	850	Ti3C2Tx		HF:HCl etching and LiCl intercalation	vacuum filtration
1020	850	Al-Ti3C2Tx		HF:HCl etching and LiCl intercalation	vacuum filtration
1021	851	Ti3C2Tx	VOx anchored Ti3C2Tx MXene heterostructures	solvothermal method	annealing process
1022	852	Ti3C2Tx			femtosecond laser ablation
1023	853	Ti3C2Tx	bacterial cellulose (BC)	not explicitly mentioned	wet spinning method
1024	854	Ti3C2Tx	Ti3C2Tx-P-300 C-3h	heat treatment with KTPP (potassium tripolyphosphate) as phosphorus source	flexible supercapacitor device assembly
1025	855	Ti3C2Tx	Ni-Mn Prussian blue analogue (Ni-Mn PBA)	chemical etching	seamless anchoring onto the conductive Ti3C2Tx nanosheets
1026	856	Ti3C2Tx	CeO2 Ti3C2Tx-MXene heterostructure	solvothermal method	rational compounding via solvothermal method
1027	857	Ti3C2Tx	MXene (Ti3C2Tx) cellulose nanofiber polyaniline film	Not explicitly mentioned	Vacuum filtration
1028	858	Ti3C2Tx	N-Ti3C2Tx, Ti3C2Tx Co3O4 hybrid composite	microplasma discharge reactor	deposited on carbon cloth
1029	859	Ti3C2Tx	MoS2 quantum dot decorated Ti3C2Tx	chemical etching of the aluminum layer from the Ti3AlC2 MAX phase	synthesized three composite samples by varying S components
1030	860	Ti3C2Tx	N-doped superhydrophilic carbon cloth (ENCC)	N-doping of carbon cloth (CC)	Electrophoretic deposition
1031	861	Ti3C2Tx	PANI (doped with DBSA), PPy (doped with DBSA)	Not explicitly mentioned in the text	Drop casting
1032	862	Ti3C2Tx	MoSe2 Ti3C2Tx nanocomposite	hydrothermal method and hydrofluoric acid etching	coating onto carbon cloth as the working electrode in a solid-state supercapacitor device
1033	863	Ti3C2Tx	PVDF-HFP-EMIMBF4 gel polymer electrolyte	Not explicitly mentioned	Casting method
1034	864	Ti3C2Tx	V-doped CoP nanorod arrays	Not explicitly mentioned	Engineered and grown on Ti3C2Tx MXene-aligned hollow carbon fiber
1035	864	Ti3C2Tx	ZIF-67 grown on electrospun PAN fibers	Not explicitly mentioned	Converted to cobalt nanoparticle-encapsulated nitrogen-doped carbon nanotubes via heat treatment
1036	865	Ti3C2Tx	reduced graphene oxide (rGO) carbon	annealing process	template method
1037	866	Ti3C2Tx	reduced graphene oxide (rGO)		
1038	867	Ti3C2Tx	MXene-SSA		
1039	868	Ti3C2Tx	heterostructured (HS) composite of nickel cobalt sulfide (NCS) nanoflowers embedded in exfoliated Ti3C2Tx MXene layers	hydrothermal process	coupling the HS NCS MXene as a positive electrode and activated carbon as a negative electrode
1040	869	Ti3C2Tx	CNF MXene LM	Not explicitly mentioned	Ultrasonic and vacuum filtration
1041	870	Ti3C2Tx		HCl+LiF etching	
1042	871	Ti3C2Tx	MnCo2O4-Ti3C2Tx	hydrothermal method facilitated by oxalate assistance	heat treatment at 450 C for one hour in a nitrogen gas atmosphere
1043	872	Ti3C2Tx	MoSe2 Ti3C2Tx hybrid	hydrothermal approach	in-situ hydrothermal approach
1044	873	Ti3C2Tx	carboxymethylcellulose-polyaniline (CMC-PANI)	in-situ polymerization of aniline on the surface of CMC	self-assembly process and vacuum filtration
1045	874	Ti3C2Tx	MXene microfibrillated cellulose (MFC) composite aerogels	Induced gelation of MXene and MFC in the framework of melamine sponge with Mg2+ as a cross-linking agent	Using melamine sponge as a support and inducing gelation of MXene and MFC mixed solution
1046	875	Ti3C2Tx	MXene CuS	electrostatic attraction connection of negatively charged 2D few-layered Ti3C2Tx MXene sheets with positively charged CuS nanoparticles	cost-effective method
1047	875	Ti3C2Tx	Fe2O3 rGO	not explicitly mentioned	not explicitly mentioned
1048	876	Ti3C2Tx	PVA-H2SO4 gel electrolyte	protective hydrothermal treatment	film electrode fabrication
1049	877	Ti3C2Tx	polymer, carbon, transition metal oxide	HF acid etching, fluoride-based etching, LiF-HCl etching, high-temperature method	intercalation, delamination
1050	878	Ti3C2Tx	MQD nanosheet hybrid	acidic etching of precursor materials	combined hydrothermal (water-based) and solvothermal (ethanol-based) treatment at 150 C
1051	879	Ti3C2Tx	MXene Mn0.8Ni0.2Se	ultrasonic stirring and solvothermal synthesis	hydrothermal selenization method employing MOF as a sacrificial template
1052	880	Ti3C2Tx	a-Ag Ti3C2Tx	in-situ reduction method	annealing treatment
1053	881	Ti3C2Tx	graphene oxide-Ti3C2Tx MXene (GO-M) composites		direct laser writing (DLW)
1054	882	Ti3C2Tx	NiWO4 MXene CNTs	wet chemical approach	ultrasonication approach
1055	883	Ti3C2Tx	PVA	vacuum filtration	symmetrical FSBSC (Ti3C2Tx NaCl-PVA Ti3C2Tx-FSBSC)
1056	884	Ti3C2Tx	Ti3C2Tx MXene NiCo2O4 nanosphere composites	electrostatic self-assembly	electrostatic self-assembly method
1057	885	Ti3C2Tx	NH4OH-5-Az Ti3C2Tx	Ammonia-assisted heterocyclic amine exerts soft delamination and interlayer engineering	Film or electrode fabrication
1058	886	Ti3C2Tx	COFs, TMCs, LDHs, MOFs, MOF derivatives	not explicitly mentioned	nanoarchitectural engineering
1059	887	Ti3C2Tx	Fe2O3 MXene composite	filtration and annealing	filtration process and annealing treatment
1060	888	Ti3C2Tx	PCCT (PAA chitosan CoS Ti3C2Tx)	in-situ hydrothermal growth	two-step process with physical crosslinked networks
1061	889	Ti3C2Tx	Si composite	traditional HF etching, safer fluoride-free alternatives, and emerging green synthesis routes	composite formation techniques and interface engineering
1062	890	Ti3C2Tx	activated carbon	hydrofluoric (HF) acid etching	assembling a supercapacitor device
1063	891	Ti3C2Tx	MXene graphene CNTs	electrochemical exfoliation	vacuum assisted filtration
1064	892	Ti3C2Tx	CoVS2 NPs	hydrothermal technique	single-step hydrothermal process
1065	893	Ti3C2Tx	Cu1.5Mn1.5O4 hollow nanosphere	simple electrostatic self-assembly	vacuum-assisted filtration
1066	894	Ti3C2Tx	NiCoMoO4 MXene heterostructure	co-precipitation method	flexible quasi-solid-state supercapacitors (FSSCs)
1067	895	Ti3C2Tx	PVA-derived carbon composite aerogels	liquid nitrogen-assisted freeze-drying and subsequent annealing	hydrogen bonding between Ti3C2Tx nanosheets and PVA polymer chains
1068	896	Ti3C2Tx	FeNiS2-Decorated Ti3C2Tx nanocomposite	Not explicitly mentioned	Binder-free electrochemical deposition
1069	897	Ti3C2Tx	rGO	selective etching of aluminum from Ti3AlC2 MAX phase	mixing with rGO in ethanol at varying ratios
1070	898	Ti3C2Tx	MnO2 Ti3C2Tx CNFs	electrodeposition	electrospinning
1071	899	Ti3C2Tx	H2SO4-PVA gel electrolyte	thermal decomposition of ammonium salts	assembling a quasi-solid-state symmetric supercapacitor
1072	900	Ti3C2Tx	CoMoO4-Ti3C2Tx nanoarrays	hydrothermal process	cross-supported nanoarray structure
1073	901	Ti3C2Tx	NiCoCu-based layered double hydroxide	not explicitly mentioned	not explicitly mentioned
1074	902	Ti3C2Tx	MX NiO	optimized molar ratio of precursors (TiO2: Al: C), calcination process, and HCl washing	mild etching process, bath sonication
1075	903	Ti3C2Tx	CuCo2O4 hollow microspheres	electrostatic self-assembly	electrostatic self-assembly
1076	904	Ti3C2Tx	NiGa-LDH Ti3C2Tx MXene	hydrothermal method	hydrothermal method
1077	905	Ti3C2Tx			
1078	906	Ti3C2Tx	melamine sponge (MS)	not explicitly mentioned	absorbing cations (H+, K+, Mg2+, Fe2+, Co2+, Ni2+, Al3+) into melamine sponge, which acts as a carrier and crosslinker for loading MXene hydrogel
1079	907	Ti3C2Tx	NiO	passivating exposed edges with Tetramethyl Ammonium Hydroxide (TMAOH)	Bath Sonication assisted DLMX NiO
1080	908	Ti3C2Tx	λ-MnO2 Ti3C2Tx MXene	one step co-precipitation method	fabricated using PVA: Na2SO4 gel polymer electrolyte
1081	909	Ti3C2Tx	MXene VS2	hydrothermal method	assembled MXene VS2 Fe3O4 rGO ASC device
1082	910	Ti3C2Tx	reduced graphene oxide (rGO) carbon nanotubes (CNTs)	nitro-sulfur mixed acid method and ascorbic acid reduction method	vacuum-assisted filtration
1083	911	Ti3C2Tx	carbon fibre (CF) electrodes	not explicitly mentioned	functionalization with aryl diazonium salts and MXene coating
1084	912	Ti3C2Tx	MXene-PANI, MXene-PPy	exfoliation	one-step oxidative polymerization and surface modification
1085	913	Ti3C2Tx	MXene polypyrrole (M-PPy)	Not explicitly mentioned	Vacuum-assisted suction filtration of a mixture of MXene nanosheets and polypyrrole (PPy) nanofibers
\.


--
-- Data for Name: papers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.papers (paper_id, title, authors, journal, year, doi_url, sciencedirect_url, issn, abstract, keywords) FROM stdin;
629	In-situ electrochemical XRD and raman probing of ion transport dynamics in ionic liquid-etched Ti3C2Tx MXene for energy storage applications	Jeremiah Hao Ran Huang, Shih-Wen Tseng, I-Wen Peter Chen	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2024.158232	https://www.sciencedirect.com/science/article/pii/S1385894724097237	1385-8947	This study focuses on understanding the electrochemical behavior of Ti3C2Tx MXene synthesized using tetramethylammonium tetrafluoroborate (TMATFB) as an etching agent for the Ti3AlC2 MAX phase. Through in situ Raman spectroscopy and X-ray diffraction (XRD), we investigate the charge storage mechanisms and surface transformations of TMATFB-etched MXene. The results indicate that Ti3C2Tx MXene undergoes reversible H+ ion intercalation, achieving a specific capacitance of 417.4F g at 1 mV s in 1 M H2SO4. This reversible process is characterized by a transformation between Ti3C2O2 and Ti3C2(OH)2 on the MXene surface, highlighting the role of oxygen-rich functional groups in enhancing pseudocapacitive behavior. These insights contribute to the understanding of MXene s electrochemical potential in energy storage systems.	{MXene,"Ionic liquid","In situ Raman","In situ XRD"}
630	Synthesis and properties of 2D MXenes and their composite electrodes for supercapacitors	Mengbin Li, Lizhong He	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.114418	https://www.sciencedirect.com/science/article/pii/S2352152X24040040	2352-152X	MXenes, first discovered in 2011 by etching their parent MAX phase, represent a novel type of 2D materials with unique electrochemical and electronic characteristics, becoming the cutting-edge research materials in a wide variety of applications. Their unique merits, including metal-like conductivity, high density, abundant and tunable surface end-groups and unique two-dimensional planar structure, have positioned them as promising 2D material in the field of supercapacitors in recent years. Therefore, a timely overview of MXenes is essential to provide guidance for advanced research in energy storage materials. In this review, we aim to summarize the recent progress on MXene research on supercapacitors. This review begins with the intrinsic properties such as mechanical, electrical and stable properties, and then focuses on the multiple synthesis strategies of MXenes, including top-down and bottom-up methods. Most importantly, the application of MXenes and their composites (including MXene Metal LDHs, MXene Metal sulfides, MXene Metal oxides, MXene Conductive polymers and MXene Carbon nanomaterials) in supercapacitors as electrodes are mainly analyzed along with the detailed mechanism and electrochemical performance. Finally, an outlook on the current challenges and future opportunities of MXene-based supercapacitors is presented.	{MXene,Supercapacitor,"Energy storage","Electrochemical performance"}
631	Multi-electron redox asymmetric supercapacitors based on quinone-coupled viologen derivatives and Ti3C2Tx MXene	M. Boota, M. Rajesh, M. Bécuwe	Materials Today Energy	2020	https://doi.org/10.1016/j.mtener.2020.100532	https://www.sciencedirect.com/science/article/pii/S2468606920301519	2468-6069	Organic materials are emerging for the pseudocapacitors as they offer high theoretical redox capacitance and can be derived from the renewable sources. They are composed of non-metals, resulting in light weight, flexible, and potentially low-cost devices. While there are hundreds of commercial organic molecules available and nearly unlimited can be synthesized, only a handful of them are suitable for the pseudocapacitive applications. Therefore, the discovery of innovative organic materials beyond conventional pseudocapacitive organic materials (e.g. quinones, conducting polymers, etc.) is much needed for the sustainable pseudocapacitors. Here, for the first time, we report quinone-functionalized viologen molecules as a high capacitance rate pseudocapacitive organic electrode material on hybridization with reduced graphene oxide sheets. Given the reliable pseudocapacitance of quinone-functionalized viologen-based hybrids under positive potentials, optimized electrodes were paired with two-dimensional titanium carbide (Ti3C2Tx) MXene as negative electrodes to manufacture multi-electron redox asymmetric supercapacitors. The resulting full devices were capable to store charge within enlarged voltage window up to 1.5 V in 3 M H2SO4. In addition, these devices exhibited ultrahigh rate performance ( 77 capacitance retention from 10 to 1,000 mV s), energy density ( 20 Wh kg), and capacitance retention of 80 after 10,000 charge discharge cycles.	{MXene,Quinone,Viologen,Pseudocapacitor,Redox}
632	Multiscale porous structured MXene: Synthesis, design and applications in batteries and supercapacitors	Chen Chen, Xincao Tang, Mengjie Wang, Yanan Ma, Siliang Wang, Yang Yue	Materials Today	2025	https://doi.org/10.1016/j.mattod.2025.05.021	https://www.sciencedirect.com/science/article/pii/S1369702125002329	1369-7021	The porous structure of 2D MXene play a critical role in addressing ion transport and kinetic limitations of traditional electrodes, enabling significant improvements of electrochemical performance for energy storage applications. In contrast to previous reviews those have focused only on a specific type of pore structure, this review systematically summarizes the construction strategies and structural properties of micropores, mesopores, and macropores of MXene electrodes, and outlines their evolution from single-scale regulation to multiscale synergistic coupling enhancement. On the basis of a brief review of the synthesis methods and physicochemical properties of MXene, we detail the introduced key structural parameters (e.g. pore size, pore geometry), and elucidate their synergistic effect on ion electron transport pathways, active site exposure, and electrolyte wettability. Furthermore, this review analyzes the unique roles and synergies of different pore scales in energy storage mechanisms, and discusses the application progress of multiscale porous MXene in lithium-ion batteries, zinc-ion batteries, supercapacitors, and so on. This review aims to provide practical insights into the rational design and application of multiscale porous MXene, thereby promoting advancements in energy storage technologies and related fields.	{MXene,"Multiscale pores","Pore regulation",Macro/Meso/Micro-pores,"Energy storage"}
671	Capacitance performance of Ti3C2Tx MXene nanosheets on alkaline and neutral electrolytes	Ramesh Aravind Murugesan, Krishna Chandar Nagamuthu Raja	Materials Research Bulletin	2023	https://doi.org/10.1016/j.materresbull.2023.112217	https://www.sciencedirect.com/science/article/pii/S0025540823000727	0025-5408	The high electrical conductivity, good hydrophilicity, and various surface terminal configurations of MXenes have exposed extensive attention in the field of energy storage. Ti3C2Tx MXene was synthesised via a facile chemical process. A study of Ti3C2Tx MXene s structure, composition, and morphology was carried out using X-ray diffraction (XRD), Raman spectroscopy (RS), X-ray photoelectron spectroscopy (XPS), and Field emission scanning electron microscopy (FESEM). A detailed study of the influence of aqueous electrolytes on the charge storage performance of Ti3C2Tx MXene was conducted by cyclic voltammetry (CV), galvanostatic charge-discharge (GCD), cyclic stability (CS), and electrochemical impedance spectroscopy (EIS). In addition, it is proposed that Ti3C2Tx MXene s surface terminations affect its capacitance behaviour in aqueous electrolytes. Ti3C2Tx MXene in 3 M (KOH) alkaline electrolyte has good electrochemical performance, with a specific capacitance (Cs) of up to 92 F g at 2A g, making it a potential material for supercapacitors.	{"Ti3C2TX MXene","Aqueous electrolyte",Supercapacitor,"Electrolyte study","Energy storage material Shavita, Kamal Kishor Thakur, Amit L. Sharma, Suman Singh, Exploring MXene-MOF composite for supercapacitor application, Materials Chemistry and Physics, Volume 322, 2024, 129463, ISSN 0254-0584, https://doi.org/10.1016/j.matchemphys.2024.129463. (https://www.sciencedirect.com/science/article/pii/S0254058424005881) Abstract: In the present work, a composite (Ti3C2Tx/Ni-MOF) of titanium carbide MXene (Ti3C2Tx) and nickel-based metal-organic framework (Ni–NH2BDC MOF) has been studied for supercapacitor application. The idea behind using the mentioned composite lies in the fact that composite formation helped prevent the restacking and oxidation of MXene sheets, thus inducing stability in the overall system. The improvement in the stability of these Ti3C2Tx nanosheets intercalated with MOFs could be observed in their electrochemical properties in the form of significant enhancement of capacitance and power density before and after composite formation. The symmetric supercapacitor device was assembled using two electrodes of similar weight with polymer-based gel electrolyte (Polyvinyl alcohol in 1 M H2SO4). The device provided the potential window of 0–2.0 V with a specific capacitance of 139.4 F/g at a current density of 1 A/g with energy density and power density of 19.4 Wh/kg and 331.8 W/kg, respectively. Capacitive retention of 95 % was observed even after 5000 charging-discharging cycles. The observed response confirms that the synthesised composite can be a suitable electrode material for future energy storage applications. Keywords: MXene",Ni-MOF,Supercapacitor,"Gel electrolyte","Symmetric device"}
620	Dual-modal flexible sensors based on flexible Ti3C2Tx (MXene)-bacterial cellulose composites for neural network-assisted pronunciations, shapes, and materials perception	Yihan Qiu, Bingzheng Zhang, Nuozhou Yi, Zhen Wang, Minghua You, Peidi Zhou, Chan Zheng, Qiaohang Guo, Kaihuai Yang, Mingcen Weng	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.180095	https://www.sciencedirect.com/science/article/pii/S0925838825016536	0925-8388	In the contemporary digital era, where human-machine interaction and robotics are rapidly evolving, the application of bacterial cellulose (BC) in the field of sensors is gradually gaining attention but still faces many challenges in practical applications. Here, Ti3C2Tx (MXene) was combined with BC by vacuum self-assembly technique to prepare MXene-BC composites. MXene-BC composites effectively combine the excellent electrical conductivity of MXene with the robust mechanical properties of BC, which significantly extends its application in flexible electronic devices. The results showed that the MXene-BC composites had excellent mechanical properties (fracture stress up to 41.09 MPa and Young s modulus up to 7.34 GPa) and good electrical properties (conductivity up to 353.77 S m 1). The pressure sensors made with MXene-BC composites have fast response recovery times (10 ms 10 ms), low detection thresholds (1 Pa), and excellent stability. The proximity sensors have good hysteresis, reversibility, response and stability. Notably, sensors based on MXene-BC composites can function as both pressure and proximity sensors. Basing on these properties, our combine 3D printing technology to create a proximity sensor array with shape recognition function. At the same time, combined with a multilayer perceptron neural network model, the dual-mode sensors can recognize pronunciations, and materials. It provides new options for the field of robotics and human-machine interaction.	{"Flexible electronics","Pressure sensor","Proximity sensor","Neural network","Multifunctional perception"}
621	Polyaniline nanowires anchored on MXene quantum dots graphene composite fibers with 0D-1D-2D hierarchical structure for high-performance wearable supercapacitors	Xiaoyu Jia, Yuan Du, Fanyu Xie, Hongwei Li, Rui Zhang, Xinxu Niu, Mei Zhang	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117346	https://www.sciencedirect.com/science/article/pii/S2352152X25020596	2352-152X	Two-dimensional graphene and MXene are promising and attractive candidates as energy storage materials for wearable supercapacitors. However, low energy density derived from a serious restacking problem restricts their charge storage capacity and actual application for portable electronic devices. In this study, we report a microfluidic technique assisted wet spinning method for the fabrication of polyaniline nanowires modified MXene quantum dots graphene composite fibers (PANI MQDs GF) with 0 1-2 dimensional (0D-1D-2D) hierarchical structure. The effective combination of multicomponents, strong synergistic effect at the nanoscales and 0D-1D-2D hierarchical structure of PANI MQDs GFs not only alleviate the restacking of graphene nanosheets but also enhance interfacial charge transfer, more accessible sites and fast pathways for ion kinetic migration and accumulation, leading to excellent structural stability and electrochemical performance. Fiber-based flexible supercapacitors assembled by PANI MQDs GF exhibit a superior specific areal capacitance of 1691 mF cm 2 (for specific volumetric capacitance of 450 F cm 3), maintain a high capacitance retention of nearly 100 after 9500 cycles, and achieve an excellent energy density of 214.4 μWh cm 2. The designed 0D-1D-2D hierarchical structure of composite fibers can also be extended to other lamellar materials, and exploit more possibilities of fiber-typed supercapacitors for portable wearable electronics application.	{"MXene quantum dots","Polyaniline nanowires","Hierarchical structure","Graphene fibers",Supercapacitors,"Energy density"}
622	Construction of novel bifunctional electrocatalyst CuCoTiO2 Mxene for supercapacitor and sensor application	Ganesh Abinaya Meenakshi, Mahalingam Agalya, Rajendran Surya, Subramanian Sakthinathan, Shanmugam Kiruthika, Te-Wei Chiu, Sandhya Sukumaran	Ceramics International	2025	https://doi.org/10.1016/j.ceramint.2025.01.228	https://www.sciencedirect.com/science/article/pii/S027288422500255X	0272-8842	The dual challenges of reducing environmental pollution and meeting increasing energy demands necessitate innovative energy storage solutions. Supercapacitors, which bridge the gap between batteries and conventional capacitors, present a promising pathway. In this study, Cu-based delafossite-type materials (ABO₂) and MXenes are explored for their complementary properties. CuCoTiO₂ offers a layered structure with p-type conductivity, while MXenes, a class of 2D transition metal carbides, nitrides, or carbonitrides, exhibit atomic-layer thickness, high conductivity, tunable surface functional groups, superior hydrophilicity, and excellent electrochemical properties. A CuCoTiO₂ MXene composite was synthesized via a cost-effective hydrothermal method, optimized across different heating durations (2, 4, 6 h). Comprehensive characterization was performed using X-ray diffraction, field emission scanning electron microscopy, energy-dispersive X-ray microanalysis, Raman spectroscopy, and Fourier-transform infrared spectroscopy. The CuCoTiO2 Mxene - 6, 4 and 2 hr electrode material exhibited a capacitance of 500 F g 1 at 1 A g. The CuCoTiO₂ MXene-6h AC ASC composite demonstrated exceptional performance, achieving an energy density of 19.6 Wh kg 1 at a specific power of 742.7 W kg 1. Additionally, it exhibited remarkable electrochemical sensing capabilities, with a sensitivity of 2.66 μA μM 1 cm 2 and a low detection limit of 16.1 nM for furazolidone. These results highlight the potential of CuCoTiO₂ MXene composites as bifunctional materials for high-performance supercapacitors and electrochemical detection applications.	{"Delafossite complex",Mxene,Electrocatalyst,Supercapacitor,"Electrochemical sensor"}
623	Dual-molecule enhanced MXene films for high specific capacitance in supercapacitors	Shiben Jiang, Yijie Shi, Linghong Lu, Changrui Hua, Yan Song, Jun Li	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.236895	https://www.sciencedirect.com/science/article/pii/S0378775325007311	0378-7753	In order to solve the problem of restacking the two-dimensional layered structure of MXene without causing a decrease in its conductivity, electrochemical performance, and flexibility, this study innovatively proposes a dual-molecule synergistic strategy utilizing polypyrrole (ppy) and 4-O-TEMPO (TEMPO = 2,2,6,6-tetramethylpiperidinyl-1-oxyl) to achieve high-capacitance MXene films. In this strategy, 4-O-TEMPO anchors to the surface and edges of Ti3C2Tx nanosheets through hydrogen and covalent bonds, with its nitroxide radicals participating in redox reactions to contribute additional pseudocapacitance. Additionally, ppy enhances the conductivity of the composite film by shortening the electron transport path and prevents MXene from excessive oxidized by 4-O-TEMPO. This bimolecular strategy effectively alleviates interlayer stacking in MXene while maintaining its conductivity and flexibility. Density functional theory (DFT) calculations reveal that Ti3C2O2 has stable interactions with 4-O-TEMPO, and the ternary system demonstrates excellent electronic and ion transport properties. As a result, the ppy MXene 4-O-TEMPO (pMT) electrode achieves a specific capacitance of 530 F g 1 at 1 A g 1 and retains 300 F g 1 at 50 A g 1. Additionally, the asymmetric supercapacitor reaches 23.8 Wh kg 1 energy density at 300.2 W kg 1 power density.	{MXene,Supercapacitor,Dual-molecule,ppy,TEMPO}
624	Recent advances in supercapacitors based on MXene surface modification: A review of symmetric and asymmetric electrodes material	Ghobad Behzadi pour, Leila Fekri aval	Results in Engineering	2024	https://doi.org/10.1016/j.rineng.2024.103045	https://www.sciencedirect.com/science/article/pii/S2590123024013008	2590-1230	MXene-based supercapacitors utilize symmetric or asymmetric electrodes. Symmetric electrodes use the same MXene material for positive negative electrodes, providing balanced performance and stability. Asymmetric electrodes incorporate different MXene materials or combine MXene with other substances to enhance energy density (ED), stability, specific capacitance (SC), and power density (PD). The symmetric and asymmetric configurations make MXene-based supercapacitors versatile for various applications. In this review, we have summarized MXene-based supercapacitors using symmetric and asymmetric electrode materials. A comparative study has been done on the surface modification of the MXene-based supercapacitor electrodes using doping, polymer decorations, anchoring of nickel materials, and coupled carbon nanomaterials methods. The discoveries from this research serve as an invaluable reference for upcoming researchers, contributing to their comprehension of the performance and potential applications of MXene electrodes of supercapacitor technology.	{MXene,Supercapacitor,Symmetric,Asymmetric,Capacitance,Electrodes}
625	Optimizing electrochemical performance of binder-free MXene-Templated zeolite electrodes via graphene quantum dots and hexagonal boron nitride doping for asymmetric supercapacitors	Syed Kashif Ali, Sajid Hussain, Md Rezaul Karim, Haseebul Hassan, Ahmed Althobaiti, Alsharef Mohammad, Yazen M. Alawaideh, Hala Ghannam	Materials Chemistry and Physics	2026	https://doi.org/10.1016/j.matchemphys.2025.131456	https://www.sciencedirect.com/science/article/pii/S0254058425011022	0254-0584	Supercapacitors gain significant attraction in materials science and energy storage due to their exceptional thermal stability, quick charging and discharging capabilities, environmental sustainability, and long cycle life. This study presents unique titanium based MXene-templated zeolites (MTZ) as a novel electrode for energy storage devices. Two variations are developed, one modified with 5 hexagonal boron nitride (h-BN MTZ) and another doped with 5 graphene quantum dots (GQDs MTZ). The h-BN enhances structural integrity and prevents MXene restacking, thereby facilitating more efficient charge transport, while the GQDs improve charge retention and transfer capabilities. In a three-electrode setup, GQDs MTZ exhibits a remarkable specific capacity of 1873 C g, surpassing MTZ (948 C g) and h-BN MTZ (1425 C g). Furthermore, when combined with activated carbon, the GQDs MTZ AC asymmetric supercapacitor achieves an outstanding energy density of 93.17 Wh kg and a power density of 1240 W kg. The device shows 97 capacity retention after 10,000 cycles. The work opens the path for more investigation of MXene-based blended electrodes in energy storage devices.	{"Energy storage","Novel electrode","Specific capacity","Graphene quantum dots (GQDs)","Electrochemical performance","Energy density"}
626	Hierarchy hollow Al-doped CoP nanocubes interconnected MXene composite for solid-state asymmetrical supercapacitors	Emad S. Goda, Byung Gi Kim, Dong Hwan Wang	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117893	https://www.sciencedirect.com/science/article/pii/S2352152X25026064	2352-152X	Cobalt phosphide (CoP) offers promising electroactive properties for energy storage due to its considerable theoretical capacity. However, interfacial instability during cycling and poor interfacial charge transfer significantly limit its practical application. In this study, a straightforward approach was introduced to synthesize hollow hierarchical Al-doped CoP nanocubes bridged by MXene sheets. The new composite was prepared using the room co-precipitation method of bimetallic AlCoPBA on the MXene surface, which was further phosphorated in a tube furnace using NaH2PO2 as a phosphorus source. Conductive MXene sheets upgrade the supercapacitive properties of the CoP-based electrode by integrating the advantages of 3D porous morphology and Al doping. Further, the AlCoP MXene heterostructure can store a large amount of energy as indicated by the capacitance value of 2577 F g calculated at 1 A g as an adjusted current density (1.5 and 3.61 times that of pristine AlCoP and CoP, respectively) and the prolonged cycle life (90.1 after 7000 cycles). In addition, the device assembled using the anode from the ZnFeS NG core-shell hybrid achieves an ultrahigh energy of 85.6 Wh kg when the power density is altered at 678.5 W kg with a considerable cycle life of 88 after repetitive 10,000 galvanostatic charge discharge cycles.	{PBA,"Al-doped cobalt phosphide",MXene,"Solid-state supercapacitor device","Energy density"}
627	Utilization of Ti3C2Tx MXenes on carbonyl functionalized carbon fiber electrodes	Piers Coia, Bhagya Dharmasiri, David J. Hayne, Timothy Harte, Sabina Dann, Ben Newman, Elmer Austria, Behnam Akhavan, Mia Angela N. Judicpa, Kevinilo P. Marquez, Ken Aldren S. Usman, Jizhen Zhang, Joselito Razal, Luke C. Henderson	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.160502	https://www.sciencedirect.com/science/article/pii/S1385894725013075	1385-8947	MXenes possess unique properties such as their 2D structure which make them excellent for energy storage applications. However, the majority of benefits offered by the MXenes are diminished when transitioning to the macroscale. To overcome this, one effective method is to use MXenes as thin films or coatings. In this work, the surface of carbon fiber was modified to introduce carbonyl functional groups, facilitating a larger surface loading of MXenes. Anthraquinone (AQ) moieties were grafted via an ex-situ method and an in-situ method which was analogous to scale-up conditions. These modifications were then used to coordinate titanium carbide (Ti3C2Tx) MXenes to the CF surface. A maximum capacitance of 31.7 F g for AQ-2-MX was observed, which represents a 14.8 fold increase over the control, along with an interfacial shear strength (IFSS) of 45.4 4.5 MPa, an increase of 39 for AQ-1-MX. Polyimide covalent organic frameworks (PI-COFs) were attached to CF via a graft-from approach and used to coordinate MXenes for high value applications. Excellent increases in capacitance to a maximum of 29.4 F g for MA-NTCDA-MX were observed and cycling stability of 99.5 in aqueous electrolyte for MA-PTCDA-MX. Increases in IFSS were maintained when the MXene coating was applied with a value of 51.7 MPa 4.2 MPa for MA-PTCDA-MX, a 58 increase. This highlights the ability of MXenes to coordinate to carbonyl-modified CF, enabling both scalable applications via AQ and high value applications via COFs, while expanding the utility of CF beyond its structural applications.	{"Carbon fiber","Energy storage","Covalent organic frameworks","Surface modification",MXenes}
628	Fabrication of binder-free MXene reduced graphene oxide W18O49 film electrode for flexible supercapacitors	Ruidong Li, Baoquan Liang, Hong Gao, Jie Li, Qianwen Liu, Lihua Chen, Shuxin Song, Bingyue Zheng, Tingxi Li, Yong Ma	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2024.114741	https://www.sciencedirect.com/science/article/pii/S2352152X24043275	2352-152X	MXene nanosheets tend to aggregate during operation, significantly impeding their utility. Yet, the defect can be validly solved by incorporating intercalation substances. Herein, binder-free MXene reduced graphene oxide W18O49 (MXene rGO W18O49) film is fabricated as supercapacitor electrode. W18O49 and rGO can foster the formation of interlayer structure with MXene nanosheets. This enlarging of interlamellar spacing facilitates establishing multidirectional ion transport routes and exposing more active sites. MXene rGO W18O49 manifests 581.2 F g 1 specific capacitance at 1 A g 1. Moreover, the assembled asymmetric supercapacitor (ASC), comprising of MXene rGO W18O49 and activated carbon (AC) as positive and negative electrodes, exhibits 1.6 V voltage window, along with 43.2 Wh kg 1 energy density at 799.8 W kg 1 power density. Notably, it retains 87.1 capacitance after 10,000 cycles at 3 A g 1. Optimization strategy for MXene rGO W18O49 film as electrode not only illustrates the viability of MXene advancement, but also offers significant technical backing for its utilization in the next generation of flexible devices.	{"Film electrode",MXene,rGO,W18O49,Supercapacitor}
633	Self-standing porous MXene film via in situ formed microgel induced by 2- methylimidazole for high rate supercapacitor	Sai Yan, Chenjing Shi, Zhen Tian, Dan Li, Yanjun Chen, Li Guo, Yanzhong Wang	Chemical Engineering Journal	2023	https://doi.org/10.1016/j.cej.2023.147393	https://www.sciencedirect.com/science/article/pii/S1385894723061247	1385-8947	Ti3C2Tx MXene has been considered a potential supercapacitor electrode material on account of its fast electron transfer performance, large volume pseudocapacitance, excellent hydrophilicity and mechanical properties. However, the serious stacking of MXene nanosheets reduced the exposed active sites and hindered diffusion of ions, leading to bad electrochemical property. Here, we report a strategy to transform MXene nanosheets into 3D MXene microgels induced by 2-methylimidazole. Benefitting from the existence of microgels, it facilitates the rapid vacuum filtration to prepare the porous MXene film, thus enhancing the ion transfer efficiency. Furthermore, 2-methylimidazole can also act as an intercalated agent to increase the layer spacing of MXene nanosheets. Therefore, the as-prepared porous MXene film demonstrates a superior rate capacity, and its capacitance reaches 223.4 F g 1 at the scan rates of 1000 mV s 1. Moreover, the assembled MXene AC asymmetrical supercapacitor displays a 16.88 Wh kg 1 at a power density of 799 W kg 1, and maintains 13.11 Wh kg 1 at a power density of 8 kW kg 1. This work develops a simple way to prepare the porous MXene film for supercapacitors with excellent electrochemical performance.	{"Ti3C2Tx nanosheets","Vacuum-assisted filtration","Restacking MXene",2-Methylimidazole,"3D microgels"}
634	High-performance aqueous zinc-ion hybrid micro-supercapacitors enabled by surface-modified Ti3C2 MXene anode and polar organic molecule intercalated AlxV2O5 cathode	Weifeng Liu, Jixuan Zhang, Jitao Li, Zhuang Ma, Lingling Sun, Yamin Feng, Long Zhang	Energy	2025	https://doi.org/10.1016/j.energy.2025.137648	https://www.sciencedirect.com/science/article/pii/S0360544225032906	0360-5442	The Ti3C2Tx MXene has emerged as an ideal anode material for aqueous Zn-ion hybrid micro-supercapacitors (AZHMSCs) due to its high conductivity, excellent stretchability, and modifiable surface functional groups. However, the interlayer stacking effect and inert F functional groups limit its ion transport and charge storage capabilities. In this study, a deep alkali treatment strategy is proposed to convert Ti3C2Tx MXene nanosheets into m-Ti3C2 MXene nanofibers with oxygen-rich surface terminal functional groups. This structure not only alleviates interlayer stacking but also shows enhanced Zn2+ adsorption affinity via oxygen groups, resulting in a specific capacitance of 1231.8 mF cm 2 at 1 mA cm 2. Meanwhile, the cathode employs polar organic molecules, specifically NMP, intercalated into AlxV2O5. The strong electrostatic interaction between NMP and pre-embedded aluminum ions improves material structural stability (96.05 capacity retention after 5000 cycles) and enhances specific capacity (327.78 μAh cm 2 at 0.5 mA cm 2). AZHMSCs assembled with these modified electrodes exhibit excellent electrochemical performance: an energy density of 105.15 μWh cm 2 at a power density of 0.48 mW cm 2, capacity retention rate of 89.29 after 3000 cycles, and good bending stability. This study offers a novel approach for electrode design and the construction of high-performance micro-energy storage devices.	{"Micro-energy storage","Surface modification","m-Ti3C2 MXene",AlxV2O5-NMP,Nanofibers}
635	Advancements and approaches in developing MXene-based hybrid composites for improved supercapacitor electrodes	Thibeorchews Prasankumar, Kaaviah Manoharan, N.K. Farhana, Shahid Bashir, K. Ramesh, S. Ramesh, Vigna K. Ramachandaramurthy	Materials Today Sustainability	2024	https://doi.org/10.1016/j.mtsust.2024.100963	https://www.sciencedirect.com/science/article/pii/S2589234724002999	2589-2347	The rapid increase in population and widespread use of energy-consuming technologies are contributing to a substantial increase in the world s energy consumption. Supercapacitors have recently become a more desirable alternative due to their quick charging and discharging times, high power densities, and extended cycle lives. For many researchers, improving supercapacitor efficiency for multifunctional applications is a major area of study. Many elements have been employed as electrode materials to provide the best energy and power density while achieving the largest specific capacitance. Among these materials, 2D transition metal carbides and nitrides, commonly called MXenes, are emerging candidates, particularly in electrochemical energy storage applications. Because of their strength, flexibility, unique structure, increased electrical conductivity, large surface area, diversity of active sites, hydrophobicity, and hydrophilicity for cutting-edge energy storage technologies, MXenes are among the best active electrode materials. MXene, with its unique 2D layered structure, offers the infinite possibility of the intercalation of various capacitive materials. Also, MXenes have the properties of high hydrophilicity of metal oxides and high electrical conductivity of metals. Alongside, activated carbon (AC), graphene, carbon nanotubes (CNTs), transition metal oxides, and conducting polymers (CPs) act as excellent electrode materials owing to their outstanding thermal, mechanical, electrical, and morphological properties. According to recent studies, one of the perfect methods for energy storage applications is to integrate MXenes with other superior elements for generating MXene-based composite electrode materials. This review includes recent developments in the investigation of MXene-based hybrid composites for supercapacitors. It covers composite s synthesis strategies, electrode architecture, electrochemical performance, and their efficiency in supercapacitors.	{MXene,"Hybrid composites",Electrode,Supercapacitor}
636	Enhanced charge storage using in-situ grown NiGa-layered double hydroxide on V4C3Tx MXene for supercapacitor applications	Dana Susan Abraham, Mari Vinoba, Margandan Bhagiyalakshmi	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.236688	https://www.sciencedirect.com/science/article/pii/S0378775325005245	0378-7753	Developing remarkable hierarchical heterostructures in nanocomposites is crucial for enhancing electrochemical performance. Heterostructures combining layered double hydroxides (LDHs) and MXenes garner considerable attention as key candidates in energy conversion and storage. By fusing conductive 2D MXenes with LDHs, the advantages of both materials are effectively harnessed. Herein, nickel gallium layered double hydroxide (NiGa-LDH) is in situ grown on the V4C3Tx MXene surface to form NiGa-LDH V4C3Tx MXene (NGV) nanocomposite. The robust interfacial interaction and superior electronic connection between NiGa-LDH and V4C3Tx MXene nanosheet bolster structural stability, enhances electrolyte accessibility, and boost electrical conductivity, thus delivers a specific capacity of 268.85 mAh g 1 for NGV-11 at 1 A g 1. The fabricated NGV-11 AC device achieves an impressive energy density of 56.41 Wh kg 1 at a power density of 800 W kg 1 and exceptional cycling stability of 93.24 retention after 5000 cycles. The results show that the synergistic interaction between NiGa-LDH and V4C3Tx MXene significantly improves the charge storage capacity in the nanocomposite. This study presents a simple and effective approach for designing vanadium-based MXene with LDH for high-performance supercapacitors.	{MXene,Vanadium,"Layered double hydroxide",Gallium,Supercapacitor,Nanocomposite}
637	Fungus-modified wood anchor MXene constructs high-performance wood-based carbon electrodes for supercapacitor	Shengzhang Deng, Jian Zhang, Lin Lin, Ziqi Li, Qingping Wang, Peng Li	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237587	https://www.sciencedirect.com/science/article/pii/S0378775325014235	0378-7753	MXene, a novel two-dimensional material, has gained widespread use in advanced energy storage equipment. However, its propensity for forming stacked structures, coupled with insufficient mechanical strength and plasticity, hinders its large-scale application. To overcome these limitations, this study developed MXene Wood-derived carbon electrodes using a green approach. The synergistic effect of fungal degradation and low concentration KOH solution treatment disrupted the original pore structure of wood, leading to the formation of a hierarchical porous structure and exposing a large number of oxygen-containing functional groups. This not only mitigates the self-stacking issue of MXene in wood, but also enhances the affinity of electrode materials for electrolytes. The prepared electrode shows satisfactory capacitance of 10.5 F cm 2 (232.8 F g 1) at 1 mA cm 2. Moreover, the symmetric supercapacitor device prepared using the electrode exhibits a high energy density (0.705 mWh cm 2 3.53 mWh cm 3) and a comparatively excellent extended cycle life (93 capacitance retention rate 10,000 times, 50 mA cm 2). This work paths a novel way for the use of renewable energy in supercapacitors.	{Supercapacitor,MXene,"Pore structure",Fungus,"Wood-derived carbon"}
638	Sandwich-like MXene NiCo-LDH Co9S8 with rich pores and high charge transfer capability for boosted supercapacitor capability	Ye Qu, Yanzi Zhang, Yali Zhang, Jun Song, Zhaoen Liu, Weixing Rao, Yu Liu	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2024.114986	https://www.sciencedirect.com/science/article/pii/S2352152X24045729	2352-152X	The multi-component synergy of electrode materials and structural engineering are crucial for high-performance supercapacitors. Herein, a novel sandwich-like MXene NiCo-layered double hydroxides (LDHs) Co9S8 nanostructure is rational synthesized, which with rich pores can significantly facilitate the diffusion of electrolyte ions and boost high charge transfer capability. Besides, the interaction forces between components promote the integration of multidimensional materials, and the resulting hybrid structure significantly improves the electrochemical efficiency through synergistic effects. Remarkably, the obtained MXene NiCo-LDH Co9S8 composites exhibit a high specific capacitance of 808.0 F g 1 at a low current density of 1 A g 1, the value is nearly 1.4 times MXene NiCo-LDH (586.2 F g 1), as well as good rate capability (512.0 F g 1 at 10 A g 1). Besides, the fabricated supercapacitor device (MXene NiCo-LDH Co9S8 activated carbon) showed an outstanding energy density of 96.4 Wh kg 1 at 800 W kg 1), and good cyclic performance of 70.26 capacitance retention even over 9000 cycles. This research may provide a promising strategy for developing two-dimensional layered materials as an electrode material in energy storage applications.	{Supercapacitor,MXene,Heterojunction,"Porous structure","Energy density"}
639	Exploring the potential of MXene-based aerogels and hybrid nanocomposites for supercapacitor applications	Suresh Sagadevan, Is Fatimah, J. Anita Lett, Babak Kakavandi, Tetsuo Soga, Won-Chun Oh, Hyacinthe Randriamahazaka	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.113269	https://www.sciencedirect.com/science/article/pii/S2352152X2402855X	2352-152X	MXene-based aerogel nanocomposites have significant attention as the promising supercapacitor electrode materials. This review highlights their potential by exploring the synergy between MXenes and aerogels. MXenes have good electrical conductivity and a high specific surface area due to their inherent characteristics. When combined with the high porosity and tunable pore structure of aerogels, these nanocomposites exhibit enhanced performance in supercapacitors. This review delivers the complete outline on the current advancements in MXene-based aerogel nanocomposites for supercapacitor applications. We delved into MXenes and their advantages as electrode materials. Also, explored various fabrication strategies, including hydrothermal synthesis, freeze drying, and templating methods. The discussion emphasizes the key factors influencing the aerogel morphology and pore structure, highlighting their impact on electrolyte accessibility and charge storage performance. Furthermore, the review analyzes the synergistic effects of these composite structures on critical parameters like specific capacitance, rate capability, and cycling stability. The challenges and future directions for the field are also discussed. By optimizing MXene-based aerogel nanocomposites, researchers can improve the electrochemical performance of the supercapacitors.	{Mxene,Aerogel,Nanocomposites,Supercapacitor,"And functional materials"}
640	Electrostatic self-assembly assisted construction of MXene MoO3 hybrid aerogel for free-standing supercapacitor electrodes	Feitian Ran, Bowen Tan, Meijie Hu, Shulin Deng, Kai Wang, Wanjun Sun, Jifei Liu, Xiaobin Yang	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.161851	https://www.sciencedirect.com/science/article/pii/S1385894725026774	1385-8947	Designing multi-component coupled hybrid electrode materials serves as an effective strategy to enhance the energy density of supercapacitors, while simultaneously addressing the issues of insufficient interface activity and ion transport. Herein, we present a three-dimensional porous cross-linked MXene MoO3 hybrid aerogel (TM-50) synthesized through an electrostatic self-assembly strategy. The porous structure enhances ion transport efficiency, while the incorporation of MXene improves the conductivity of MoO3. Additionally, the randomly interconnected MoO3 effectively suppresses the self-stacking of MXene nanosheets. Benefiting from these synergistic effects, the TM-50 hybrid aerogel achieves a specific capacitance of 418.2 C g 1 at 0.5 A g 1 in 3 M H2SO4, with 92.7 retention after 10000 cycles. Additionally, the asymmetric supercapacitor assembled from TM-50 and activated carbon achieves an energy density of 20.9 Wh kg 1 at 491.5 W kg 1, retaining 90.3 capacitance after 5000 cycles. Density functional theory (DFT) calculations further confirm that the MXene MoO3 hybrid exhibits lower H+ adsorption energy and a higher electronic state density near the Fermi level, enhancing its interfacial activity. This controllable approach to developing hybrid aerogels is promising for other MXene-based functional materials in diverse applications.	{"Electrostatic Self-assembly",MoO3,MXene,"Free-standing electrodes"}
641	From 2D to 3D: Green synthesis of wrinkled MXene thin-film electrodes for ultra-high specific capacitance and structural resilience combination of supercapacitors	Lanyun Di, Xuehua Yan, Chu Chu, Feng Zhang, Jamile Mohammadi Moradian, Zohreh Shahnavaz	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.236215	https://www.sciencedirect.com/science/article/pii/S0378775325000515	0378-7753	MXene, a new type of electrode material, is widely used in supercapacitors. However, the inherent self-stacking of this two-dimensional (2D) material impedes transport of electrolyte ions, limiting ion diffusion and pseudocapacitive performance. This study introduces a novel wrinkled three-dimensional (3D) structure of MXene films to avoid restacking of MXene nanosheets. At a current density of 1 A g 1, the mass-specific capacitance achieved 565 F g 1, while the area-specific capacitance attained 1582 mF cm 2. The film exhibits excellent mechanical flexibility and a tensile strength of up to 34.2 MPa at high strain rates. The film served as both the positive and negative electrode to assemble symmetrical supercapacitors. At 1 A g 1, the mass-specific capacitance can achieve 71.25 F g 1. Additionally, at a power density of 400 W kg 1, the energy density can reach 6.3 Wh kg 1. Demonstrating ultrahigh cycle stability, the capacity retention rate was 99.6 after 20,000 cycles at 10 A g 1. This study suggests that optimizing the synthesis methods can enable 3D MXene thin-film electrodes with more tailorable properties, providing feasibility and reliability for engineering applications of supercapacitors.	{MXene,Supercapacitor,"Green synthesis","Thin-film electrode","CMC film"}
642	High-performance asymmetric supercapacitors based on 2D MXene NiCoP hybrid and ZIF derived porous nanocarbon	Erdenebayar Baasanjav, K.A. Sree Raj, Hafis Hakkeem, Chandra Sekhar Rout, Sang Mun Jeong	Journal of Materials Science Technology	2025	https://doi.org/10.1016/j.jmst.2024.12.032	https://www.sciencedirect.com/science/article/pii/S1005030225000672	1005-0302	The performance of supercapacitors can be improved by strategically designing 2D MXene-based electrodes with excellent electrochemical properties. However, several challenges remain in developing hybrid materials based on 2D MXenes due to restacking, which hinders energy storage performance. In this work, we successfully synthesized a 2D MXene Ni-Co phosphide (MX NCP) hybrid material for supercapacitors via a facile hydrothermal reaction followed by phosphorization. The optimized MX NCP positive electrode showed good energy storage performance with a specific capacitance of 1754.0 F g 1 at 3 mA cm 2 in a three-electrode configuration. The synergistic effect of MXene and Ni-Co phosphide has contributed towards the enhanced charge storage performance. Furthermore, an asymmetric supercapacitor (ASC) fabricated with MX NCP and porous nanocarbon (PNC) delivered a maximum energy density of 54.3 Wh kg 1 at a power density of 565.6 W kg 1 with a cycling stability of 93.8 after 10,000 cycles. To evaluate the practical versatility of the ASC, a planar device was successfully fabricated making MX NCP a promising electrode material in next-generation wearable and flexible supercapacitors.	{"2D MXene",Supercapacitor,"Metal phosphides","Porous nanocarbon","Energy density"}
643	Synergistically coupling of ternary hydrotalcite and Ti3C2Tx-MXene nanosheets boosting electronic transmission in energy storage	Lu Luo, Qiuyan Kong, Qianqian Zhang, Jing Zhang, Mizi Fan, Weigang Zhao	Journal of Power Sources	2024	https://doi.org/10.1016/j.jpowsour.2024.234940	https://www.sciencedirect.com/science/article/pii/S0378775324008929	0378-7753	Layered double hydroxides (LDH) and two-dimensional metal carbides (Ti3C2Tx) garner significant attention in recent years. LDH Ti3C2Tx nanohybrids combine the unique characteristics of individual component, making them a promising option for high-power energy storage applications. Here, we present a composite electrode constructed by synergistic coupling of Ti3C2Tx and ternary hydrotalcite (NiCoMn-LDH). Strong interfacial interactions between the NiCoMn-LDH array and Ti3C2Tx nanoflakes, along with effective electron coupling, contribute to enhanced structural stability, conductivity, and electrolyte accessibility, thereby significantly promoting the kinetics of redox reactions. The intriguing lace-like structure fully utilizes the high activity of NiCoMn-LDH and the excellent conductivity of Ti3C2Tx, allowing LDH Ti3C2Tx to exhibit an impressive output capacitance of 1102.9 F g 1 at 1 A g 1, coupled with notable rate capability (66.87 at 20 A g 1). The constructed LDH Ti3C2Tx AC hybrid supercapacitor (HSC) achieves a remarkable energy density of 47.3 Wh kg 1 at 800 W kg 1. Following 5000 cycles, the specific capacity of HSC decreases by merely 8.3 , while achieving a Coulombic efficiency of 99 , showcasing remarkable durability and reversible reaction characteristics. This study provides a streamlined and effective methodology for crafting LDH Ti3C2Tx nanohybrids, showcasing robust coupled interfaces and exceptional electrochemical energy storage application.	{NiCoMn-LDH,Ti3C2Tx,"Lace-like structure","Hybrid supercapacitors"}
644	Enhanced electron conductivity, stability, and electrochemical performance of MXene-coated manganese and iron oxides as negative electrode of supercapacitors	Moo Young Jung, Yongsuk Oh, Subin Eom, Jihye Park, Chanyong Lee, Sudeshana Pandey, Taemin Kim, Hae-Seok Lee, Ji-Won Son, Yong Ju Yun, Yongseok Jun	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.145879	https://www.sciencedirect.com/science/article/pii/S0013468625002427	0013-4686	The fabrication and characterization of a novel MXene MnO2 Fe2O3 composite as a negative electrode material for supercapacitors are reported in this study. The MXene is integrated by coating the MnO2 Fe2O3 particles, significantly enhancing the specific capacity. An optimal MXene ratio achieves a remarkable specific charging capacity of 1226.30 mAh g 1 at a current density of 1 A g 1. However, further increasing the MXene content does not result in proportional improvement of electrochemical performances, suggesting that an excessive amount negatively impacts the system. Additionally, an asymmetric supercapacitor (ASC) using nickel aluminum as the positive electrode and an optimized MXene MnO2 Fe2O3 composite as the negative electrode is developed. This ASC exhibits an impressive energy density of 61.70 Wh kg 1 and a power density of 426.21 W kg 1, with a capacitance retention of 92.92 after 25,000 cycles at 0.5 A g 1. These findings suggest that MXene MnO2 Fe2O3 composites are promising candidates for high-performance supercapacitor applications.	{"MXene composites",Supercapacitors,"MnO2/Fe2O3 electrode","Electrochemical performance","Energy storage"}
645	A novel MnO2 Ti3C2Tx MXene nanocomposite as high performance electrode materials for flexible supercapacitors	Hanmei Jiang, Zegao Wang, Qian Yang, Muhammad Hanif, Zhiming Wang, Lichun Dong, Mingdong Dong	Electrochimica Acta	2018	https://doi.org/10.1016/j.electacta.2018.08.096	https://www.sciencedirect.com/science/article/pii/S0013468618318589	0013-4686	MnO2 is considered as one of the most promising electrode materials for flexible supercapacitors but it often suffer in poor conductivity, which limits practical applications according to industry needs. To enhance the performance, forming MnO2-based hybrid structures with conductive materials is a promising implement approach. Ti3C2Tx MXene sheets, a new kind of 2D transition metal carbides with metallic conductivity and hydrophilic nature, are promising candidate to couple with MnO2. According to the complementary principle, we design a novel structure MnO2 Ti3C2Tx hybrid nanocomposite by synergistically coupling one-dimensional (1D) MnO2 nanoneedles with two-dimensional (2D) Ti3C2Tx MXene sheet for flexible supercapacitor. XPS investigations suggest the obvious charge transfer from Ti3C2Tx sheets to MnO2 nanoneedles, where Ti3C2Tx sheets serve as a remarkable 2D conductive substrate to facilitate the electrons transfer in the nanocomposites. This strong synergistic effect between Ti3C2Tx and MnO2 resulting from the chemical interaction greatly enhance the electrical conductivity, specific capacitance, rate stability and structural stability of the MnO2 Ti3C2Tx nanocomposite. To show the potential application in energy storage, a symmetrical flexible supercapacitor device with good electrochemical performance, high flexibility and super cycling ability is fabricated by utilizing MnO2 Ti3C2Tx nanocomposites as electrode materials. This work has proposed a new approach of developing advanced nanocomposites from a MnO2-based electrode for high performance flexible electronics.	{"MnO2 nanoneedle",MXene,Ti3C2Tx,"Flexible supercapacitor","Synergistic effect"}
646	Highly matched porous MXene anodes and graphene cathodes for high-performance aqueous asymmetric supercapacitors	Shuaikai Xu, Yubing Li, Tangming Mo, Guodong Wei, Ya Yang	Energy Storage Materials	2024	https://doi.org/10.1016/j.ensm.2024.103379	https://www.sciencedirect.com/science/article/pii/S240582972400206X	2405-8297	Aqueous asymmetric supercapacitors (ASCs) provide promising prospects for electronic systems in the future that require high energy density, power density and cycling life, due to their advantages such as low cost, safe operation and environmental friendliness. However, developing well-matched anodes and cathodes with complementary potential windows and coordinated charge storage kinetics remains a significant challenge. Here, we constructed porous MXene- and graphene-based films with nitrogenous and phosphorous terminals as anodes and cathodes, respectively, alleviating the restacking of nanosheets, generating more electrochemical active sites and improving the electrolyte penetration. The assembled aqueous ASCs based on the porous MXene and graphene films could achieve an excellent energy density of 26.8 Wh kg 1 at 425 W kg 1, high rate performance, and remarkable cycling stability with 97.3 retention after 20,000 cycles. This work demonstrates a novel concept to develop high-performance aqueous ASCs by surface engineering of two-dimensional porous electrodes with matched structural and electrochemical properties.	{MXene,Graphene,"Porous electrodes","Asymmetric supercapacitors"}
647	MXene-transition metal chalcogenide hybrid materials for supercapacitor applications	Gopinath Sahoo, Chandra Sekhar Rout	Chemical Communications	2025	https://doi.org/10.1039/d5cc00223k	https://www.sciencedirect.com/science/article/pii/S1359734525006718	1359-7345	The rapid growth of technologies and miniaturization of electronic devices demand advanced the use of high-powered energy storage devices. The energy storage device are utilized in modern wearable electronics, stretchable screens, and electric vehicles. Due to their favorable electrochemical properties, nanomaterials have been used as electrodes for supercapacitors (SCs) with high power density, but they generally suffer from lower energy density than batteries. Compared to various nanomaterials, MXenes and transition metal chalcogenides (TMCs) have shown great potential for energy storage applications such as SCs. TMCs are gaining attention due to their stable electrochemical nature, adjustable surface activity, high electric conductivity, abundant chemically active sites, and stable cycling performance. However, the interlayer restacking and agglomeration of 2D materials limit their cycling performance. To overcome this, TMCs MXene heterostructures have been developed, offering structurally stable electrodes with enhanced chemical active sites. In this review, we discuss recent advances in the development of different TMCs MXene-based hybrids for the design of high performance SCs with improved specific capacitance, cycling life, energy density, and power density. The recent developments of this research field focusing on MXene-transition metal sulfides, MXene-transition metal selenides, and MXene-transition metal tellurides are elaborately discussed. Theoretical calculations carried out to understand the charge-storage mechanisms in these composites are reviewed. The importance of bimetallic TMCs and MXene heterostructure for enhanced energy storage is also highlighted.	{}
648	Simultaneously addressing self-stacking and oxidative degradation issues of Ti3C2Tx MXene through biothermochemistry induced 3D crosslinking	Haitao Zhang, Hanyu He, Yongxiang Huang, Shi Pu, Yanting Xie, Junfeng Huang, Xinling Jiang, Yongbin Wang, Shenglong Wang, Hongzhi Peng, Yuanxiao Qu, Weiqing Yang	Applied Surface Science	2023	https://doi.org/10.1016/j.apsusc.2023.158183	https://www.sciencedirect.com/science/article/pii/S0169433223018639	0169-4332	As a recent rising star 2D material, MXenes have attracted great attention in many fields. However, the weak interaction induced self-stacking phenomenon and surface oxidation caused structure failure seriously hinder the practical application of MXenes. Herein we develop a biothermochemistry method to construct 3D crosslinked Ti3C2Tx (3D-MX). This novel structured 3D-MX can be prepared in five different kinds of biological reagents, showing good university. After crosslinking, 3D-MX not only resists layer stacking but also exhibits extreme on-shelf stability up to 550 days. We reveal that the formation mechanism originates from the electrostatic chemical interaction between surface functional groups and the crosslinking agents. Interestingly, the biothermochemical treated Ti3C2Tx MXenes exhibit an extremely-rapid film-processed capability (only 3 min), addressing the long-standing issue of low-efficient and tedious solution-vacuum filtrated 2D films. To further verify its practical application, we assemble 3D-MX based supercapacitors that show a high specific capacitance of 265 Fg 1 at 1 A g 1, and moreover, no supercapacitance attenuation within 720 h. This proposed biothermochemistry method to simply and rapidly build 3D Ti3C2Tx crosslinked network provides a new perspective to promote the practical application of MXenes through simultaneously addressing their self-stacking and oxidative degradation issues.	{"Ti3C2Tx MXenes",Biothermochemistry,"3D crosslinking",Self-stacking,"Oxidative degradation",Supercapacitors}
649	Biomimetic and electrostatic self-assembled nanocellulose MXene films constructed with sequential bridging strategy for flexible supercapacitor	Shaowei Wang, Yuanyuan Ma, Sailing Zhu, Haoyu Ma, Yiying Yue, Qinglin Wu, Huining Xiao, Jingquan Han	Chemical Engineering Journal	2024	https://doi.org/10.1016/j.cej.2024.153552	https://www.sciencedirect.com/science/article/pii/S1385894724050411	1385-8947	Despite the two-dimensional titanium carbide MXene (Ti3C2Tx) has shown promising applications in energy storage, the inherent self-stacking and weak connectivity among nanosheets present a challenge in manufacturing robust MXene films for emerging flexible supercapacitors. Herein, inspired by the robust soft-hard structured exoskeletons of crustaceans, the biomimetic cellulose nanofibers (CNFs) MXene-Al (CM-Al) film with integrated high mechanical toughness, electroconductivity and electrochemical behavior, sequential bridging with hydrogen and ionic bonds, is crafted via the facile electrostatic self-assembly strategy. The embedded CNFs guide the in-plane orientation of MXene through hydrogen bonding, forming a soft-hard microstructure and dramatically enhancing the mechanical toughness of CM-Al. The rigid ionic bonds established between the oxygen-containing groups on CNFs and MXene with Al3+ further elevate the mechanical strength (163.88 MPa) and act as additional electron transfer channels to impart the reinforced electroconductivity (82.63 S cm 1). Benefiting from the more active site exposure induced by the expanded MXene layer spacing after CNFs embedding and the weakened intrinsic resistance caused by the constructed ionic bonding, the assembled flexible quasi-solid-state symmetric supercapacitor with CM-Al as electrode delivers a high area capacitance (679 mF cm 2), energy density (16.2 μWh cm 2), cycling capability (85.3 capacitance retention after 10,000 cycles) and intrinsic tolerance to various non-stretching deformations. Moreover, the selective principles for metal ions are summarized that involved a comprehensive consideration of ionic radius, charge density and basic chemical properties. This work demonstrates an accessible and feasible construction strategy for flexible composite films and provides an alternative pathway for wearable energy storage devices.	{"Cellulose nanofibers","Ti3C2Tx MXene","Electrostatic self-assembly","Sequential bridging",Supercapacitor}
664	Cylindrical janus Mosse CNT intercalated into Mxene: A high-performance supercapacitor electrode with high volumetric capacity and flexibility	Nouf Alharbi	Journal of Alloys and Compounds	2024	https://doi.org/10.1016/j.jallcom.2024.176273	https://www.sciencedirect.com/science/article/pii/S0925838824028603	0925-8388	Restoring MXene s intrinsic capacitive function is essential for high-performance supercapacitors. This study presents a new approach to tackle the problem of restacking and improving energy storage. It involves incorporating MoSSe CNT (MoSSe nanosheets wrapped around carbon nanotubes) into MXene films, which are exceptionally electrochemically active. After optimisation, the MoSSe CNT MXene electrode demonstrates remarkable volumetric and gravimetric capacitance values of 1819 F cm ³ and 585 F g ¹, respectively. The exceptional performance of MoSSe CNT arises from the combined effects of MoSSe CNT acting as both spacers and active contributors to pseudocapacitance. The electrode obtained exhibits exceptional rate capability, flexibility, and a high energy density of 47.5 Wh L ¹, making it a highly promising contender for advanced energy storage systems.	{"Cylindrical Janus",Mxene,"MXene films",Supercapacitor,MoSSe@CNT/MXene}
650	Nanoengineering of novel MXene (Ti3C2Tx) based MgCr2O4 nanocomposite with detailed synthesis, morphology and characterization for enhanced energy storage application	Rubia Shafique, Malika Rani, Kiran Batool, Aqeel Ahmad Shah, Aboud Ahmed Awadh Bahajjaj, Mika Sillanpää, Hessa A. Alsalmah, Naveed Kausar Janjua, Maryam Arshad	Materials Science and Engineering: B	2024	https://doi.org/10.1016/j.mseb.2023.117036	https://www.sciencedirect.com/science/article/pii/S092151072300778X	0921-5107	In this study, we presented a novel approach involving the co-precipitation synthesis of a two-dimensional MXene nanocomposite with spinel magnesiochromite MgCr2O4. The resulting nanocomposite was comprehensively characterized. The synthesized nanomaterial exhibited an average crystallite size of approximately 6.85 nm, and its surface morphology confirmed the presence of agglomerated grains with the elemental composition being confirmed by EDS spectra. Raman spectra provided evidence of prominent molecular vibrations, while photoluminescence spectroscopy revealed significant electron-hole recombination within the nanocomposite, leading to a reduced bandgap as corroborated by UV Vis spectra. Zeta potential measurements shows minimum value of 19.9 mV comparable to MXene zeta potential value 23 mV indicating maximum stability. Electrochemical impedance spectroscopy (EIS) spectra highlighted a minimal charge-transfer resistance value of 64.99 Ω in a basic electrolyte, resulting electron transfer rate value about 4.097 10 9 (S cm) resulting maximum conduction. Electrode capacitive behavior in both acidic (0.1 M H2SO4) and basic media (1 M KOH) demonstrates the potential of this novel nanocomposite material with the maximum capacitance value of 542.6F g observed in basic media in comparison to the minimum capacitance value of 454.1F g in acidic media. From GCD analysis, maximum power density of 271.2 kW kg with an energy density value of 14.58 kWh kg is achieved. These findings underscore its applicability in energy storage applications partially in the context of supercapacitors.	{"MXene/MgCr2O4 nanocomposite","Electrode material",Energy-storage,Supercapacitors}
651	Binder-free Ti3C2Tx MXene electrode film for supercapacitor produced by electrophoretic deposition method	Shuaikai Xu, Guodong Wei, Junzhi Li, Yuan Ji, Nickolai Klyui, Vladimir Izotov, Wei Han	Chemical Engineering Journal	2017	https://doi.org/10.1016/j.cej.2017.02.144	https://www.sciencedirect.com/science/article/pii/S1385894717303248	1385-8947	Binder-free electrodes employed in supercapacitor devices can exhibit excellent electrochemical performances due to the improvement of electronic conductivity and the utilization rate of electrode materials. However, a simple, efficient and tunable strategy for preparation of binder-free MXene-based electrodes, especially for developing a general method for fabricating the MXene-based wearable flexible supercapacitors, still remains a challenge to meet the requirements of practical applications. In this study, we fabricated binder-free MXene-based films with adjustable mass loading and reduced agglomeration on the nickel foam and wearable flexible fabric substrates by the modified electrophoretic deposition method using organic colloid containing few-layers Ti3C2Tx nanoflakes. Their electrochemical performances are studied by cyclic voltammetry, galvanostatic charge-discharge and electrochemical impedance spectroscopy, respectively. The binder-free electrodes can deliver high capacitance ( 140Fg 1 in alkaline electrolyte), stable cycling performance with no capacitance loss after 10,000 cycles and good rate performance, which can be attributed to the reduced agglomeration of Ti3C2Tx films with a layer-by-layer self-assembled stackable structure, optimized pore-size distribution ( 4nm) and excellent electronic conductivity, enhancing the accessibility to electrolyte ions and enabling full utilization of the MXene nanoflake surfaces.	{MXene,Ti3C2Tx,"Electrophoretic deposition",Binder-free,Supercapacitors}
652	Achieving 3D Ti3C2TX hydrogel cathode by cation electrochemical intercalation and gelation for a zinc-ion hybrid supercapacitor with high energy density	Xingyu Wang, Haiping Wang, Jun Fan, Xinmiao Liu, Shuwei Zhang, Shutong Meng, Wenjie Yan, Jiaqi He, Zhansheng Lu, Zenghui Qiu, Haijun Xu, Xin Zhang	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.116375	https://www.sciencedirect.com/science/article/pii/S2352152X25010886	2352-152X	Zinc-ion hybrid supercapacitors (ZHSCs) combine the characteristics of the high power density of supercapacitors (SCs), the high energy density of batteries, and cost benefits of zinc-ion technology, which have broad prospects. At present, Ti3C2TX shows great application potential in the field of SCs, but the electrochemical performance is seriously affected by the tight accumulation between the layers. In this paper, Ti3C2TX was assembled into a 3D structure to form Ti3C2TX-reduced graphene oxide (RGO) hydrogel by a low-temperature hydrothermal graphene oxide (GO)-gelation process. Subsequently, Zn2+ ions were inserted into the van der Waals (vdW) gap of the layered Ti3C2TX of the Ti3C2TX-RGO hydrogel by an electrochemical intercalation technology. The formative Zn2+-Ti3C2TX-RGO hydrogel has good mechanical strength, fast ion transport rate, and abundant active sites. The material was then used as free-standing cathode and zinc foil as the anode to construct a ZHSC, which possessed a large operating voltage (2.0 V), a high energy density of 172.8 Wh kg 1, a high power density of 9625.5 Wh kg 1, and a good cycling stability (retention of 79.5 of the capacitance after 5000 cycles at 10 A g 1). This work highlights the unique potential of Ti3C2TX-based hydrogels as viable electrode materials for ZHSCs.	{"Ti3C2TX MXene","Cation electrochemical intercalation","3D hydrogel","High energy density","Zinc-ion hybrid supercapacitors"}
653	Microwave-assisted hydrothermal synthesis of Ti3C2Tx MXene: A sustainable and scalable approach using alkaline etchant	Farah Ezzah Ab Latif, Mohammad Khalid, Arshid Numan, Norhuda Abdul Manaf, Nabisab Mujawar Mubarak, Haizum Aimi Zaharin, Ezzat Chan Abdullah	Journal of Molecular Structure	2025	https://doi.org/10.1016/j.molstruc.2025.141407	https://www.sciencedirect.com/science/article/pii/S0022286025000961	0022-2860	The present work demonstrates an enhanced method for synthesising titanium carbide (Ti3C2TX) MXene using an alkaline etchant to remove aluminium (Al) element from the ternary titanium metal carbide (Ti3AlC2) MAX phase. The synthesis process employs a microwave-assisted hydrothermal heating route, offering a fluorine-free and safer alternative to conventional etching techniques. This method achieved rapid heating within just 45 min at 180 C, significantly reducing the etching time compared to traditional etching, which often requires 2-3 days. The effects of different sodium hydroxide (NaOH) concentrations (5 to 30 M) on the etching process were analysed. X-ray diffraction (XRD) and Fourier-transform infrared (FTIR) spectroscopy confirmed structural modifications, showing a reduction of peak intensities and the existence of functional groups on etched MXene s galleries, such as Ti-O, C=O, C-H, and O-H. These structural modifications indicated a successful Al removal. Raman s analysis further verified bond formation within the etched MXene, such as Ti-C and Ti-O Ti-OH bonds. Morphological analysis revealed a well-aligned, layered structure with substantial interlayer spacing at higher NaOH concentrations (27.5 and 30 M), indicating the formation of 2D MXene sheets. Elemental analysis showed significant Al reduction, especially at 27.5 and 30 M etched MXene, with remaining amounts of 21.9 and 0.46 , respectively. The UV-Vis spectroscopy identified etched MXene possessed magnetic properties at lower NaOH concentrations (5 and 10 M) with the band gap energy from 2 to 2.5 eV. Meanwhile, the etched MXene at higher NaOH concentrations (20 to 30 M) behave semiconductor-like with the band gap energy from 1.30 to 1.60 eV, corroborating the surface functionalisation of the MXene galleries. The findings suggest that NaOH concentrations of 27.5 M are ideal for potential applications, as higher concentrations improve functional groups and interlayer spacing. Future work will optimise this synthesis method, offering a fast and scalable approach to creating MXene for use in catalysis and electronic applications.	{"Microwave-assisted hydrothermal",Synthesis,MXene,"Two-dimensional material","Alkaline etchant"}
654	The Rise of Ti3C2Tx MXene synthesis strategies over the decades: A review	Mohammed Askkar Deen, Harish Kumar Rajendran, Ragavan Chandrasekar, Debanjana Ghosh, Selvaraju Narayanasamy	FlatChem	2024	https://doi.org/10.1016/j.flatc.2024.100734	https://www.sciencedirect.com/science/article/pii/S2452262724001284	2452-2627	The Ti3C2Tx MXene has ignited a wave of excitement in the world of materials science due to its immense potential for diverse applications. However, a deeper understanding of the synthesis processes involved is crucial to unlock their potential. Here we review the various techniques for producing Ti3C2Tx MXene, covering everything from precursor selection to etching-exfoliation and intercalation-delamination steps. Furthermore, we also explore the oxidation stability of Ti3C2Tx and propose a reaction mechanism to help shed light on this critical aspect of Ti3C2Tx MXene. This review begins with the bibliography studies on Ti3C2Tx and then delves into the principle behind the chemical etching process. Followed by various etching strategies used for Ti3C2Tx synthesis and the impact of individual etching parameters on successful synthesis protocols. Finally, we address the challenges that still need to be overcome to fully realize the potential of Ti3C2Tx and highlight the exciting possibilities for its future development. We aim to inspire further research into this cutting-edge material and encourage the synthesis of Ti3C2Tx MXene with even more outstanding performance and a more comprehensive range of applications.	{"Ti3C2Tx MXene","Bibliography study","Etching strategies","Oxidation stability"}
655	Nitrogen doped graphene quantum dots (NGQD) pillared Ta4C3Tx MXene as high-performance electrochemical supercapacitors	Sabeen Fatima, M. Waqas Hakim, Xiaoxiao Zheng, Yu Sun, Ziheng Li, Nan Han, Muyang Li, Zeyuan Wang, Lei Han, Liang Wang, Safia Khan, Jiangwei Liu, Hu Li	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237190	https://www.sciencedirect.com/science/article/pii/S0378775325010262	0378-7753	Two-dimensional (2D) materials are proved to possess outstanding energy storage capabilities for advanced supercapacitors, yet these materials require modification to overcome field obstacles and reach their full potential. Here, we prepared tantalum carbide MXene and nitrogen-doped graphene quantum dots (NGQD) by adopting facile synthesis routes. Surface engineering of 2D tantalum carbide sheets is carefully performed with zero-dimensional graphene to achieve NGQD Ta4C3Tx nanosheets. The compositional analysis demonstrated the attachment of quantum dots with MXene sheets. The modified 1.5 -NGQD Ta4C3Tx, 3 -NGQD Ta4C3Tx, 5 -NGQD Ta4C3Tx, 7 -NGQD Ta4C3Tx and 10 -NGQD Ta4C3Tx nanosheets presented enhanced energy storage capability than NGQD and plain MXene. Graphene quantum dots enable Ta4C3Tx to have faster more stable reaction kinetics and enhance the gravimetric capacitance 7 folds (701 F g) compared to plain MXene (100 F g). Due to the exceptional working electrode performances, an asymmetric supercapacitor is also fabricated with NGQD Ta4C3Tx nanosheets as working electrode. The device exhibited a pseudocapacitive battery-like storage mechanism with a specific capacity of 110 Cg-1, power and energy densities of 9000 W kg and 55 W-h Kg respectively. Due to the low corrosion rate exhibited by Tafel plots an excellent capacity retention is observed up to 20000 cycles. The study imparts valuable insights into engineering 0D 2D nanostructures for next-generation energy storage systems.	{"Nitrogen doped graphene Quantum Dots (NGQD)","Tantalum carbide (Ta4C3Tx) MXene",Supercapacitors,"Electrochemical energy storage","MXene electrodes"}
656	Improving the bimetallic interactions of CeO2 MnO2 MXenes for supercapacitor electrode applications	Faiz Imran, Azmat Hussain, Ibrahim Aladhyani, Fawad Ali, Shahbaz Afzal, Raphael M. Obodo	Materials Chemistry and Physics	2025	https://doi.org/10.1016/j.matchemphys.2025.130625	https://www.sciencedirect.com/science/article/pii/S0254058425002718	0254-0584	The characteristics of large surface area, high chemical firmness and virtuous electrical conductivity make MXene-based electrodes an emerging potential material for supercapacitor electrode applications. The qualities of invented electrodes were examined using X-ray diffraction (XRD), scanning electron microscopy (SEM), energy dispersive spectroscopy (EDS), UV visible spectroscopy, and electrochemical analysis. The estimated specific capacitance of 1370 F g-1 from cyclic voltammetry (CV) at a scan rate of 1.0 mVs 1 and 1520 F g-1 from galvanostatic charge-discharge (GCD) at 0.5 Ag-1 current density, respectively, were obtained from the CeO2 MnO2 MXene electrode. The study s findings suggest that the addition of MXene caused the manufactured electrodes electrochemical properties to improve. The electrodes CeO2 MXene, MnO2 MXene, and CeO2 MnO2 MXene have proven to be quite effective, which makes them a good option for supercapacitor electrode application. The CeO2 MnO2 MXene electrode was found to exhibit remarkable cyclic stability at 0.5 Ag-1 current density, maintaining 73.5 of its initial measurements after 10,000 full cycles.	{Supercapacitor,Electrode,MXene,"Synergistic collaboration","Specific capacitance"}
657	Interface engineering through embedding Co2O3 nanoparticles onto MXenes layered structure for boosting supercapacitor performance	Chou-Yi Hsu, Waqed H. Hassan, Tapankumar Trivedi, Anjan Kumar, B.R. Sampangi Rama Reddy, Rishabh Thakur, Shirin Shomurotova, Hadi Yasir Abbood Aljanabi, Ahmed Ahmed Abbas Sahib, Hamad M. Alkahtani	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.146121	https://www.sciencedirect.com/science/article/pii/S0013468625004839	0013-4686	MXene-based materials hold great promise as catalyst candidates for energy storage and conversion devices, owing to their unique attributes such as a large surface area, excellent metallic conductivity, and rapid redox activity. However, their potential for widespread industrial use has been substantially hindered by challenges such as surface aggregation and susceptibility to oxidation. In this work, we report the fabrication of a Co₂O₃ MXene nanocomposite supercapacitor material on a conductive nickel (Ni) sheet substrate using a convenient and flexible dip-coating technique. The integration of Co₂O₃ nanoparticles into the layered MXene structure not only exposes a significant number of active sites but also effectively preserves the phase stability and electronic characteristics of the material throughout extensive galvanostatic charge-discharge (GCD) cycling. The specific capacitance of our Co₂O₃ MXene nanocomposite reaches an impressive value of 448.8 F g ¹ at a current density of 0.5 A g ¹, reflecting its high efficiency in energy storage. Moreover, after 5000 charge-discharge cycles, the device retains 88 of its original capacitance, indicating excellent cycling stability. These results highlight the potential of Co₂O₃ MXene nanocomposites as advanced materials for supercapacitor applications, emphasizing their promising performance in energy storage systems.	{MXene,Supercapacitor,Co2O3,Nanocomposite,Dip-coating}
658	NiCo2O4 MXene composite electrodes: Unveiling high-performance asymmetric supercapacitor capabilities through enhanced redox activity	Abdul Jabbar Khan, Honggeng Ding, Yi Zhang, Daohong Zhang, Ling Gao, Guowei Zhao	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.160287	https://www.sciencedirect.com/science/article/pii/S1385894725010927	1385-8947	The deteriorated conductive nature and stacking of Ti3C2Tx MXene layers significantly restrict the electrochemical properties, which requires a proper spacer to avoid restacking and improve the conductive behavior. An asymmetric supercapacitor was designed by combining NiCo2O4 MXene composite (NCO MXene) as the positive electrode and activated carbon (AC) as the negative electrode, forming the NCO MXene AC-ASC configuration. The NCO MXene demonstrated outstanding pseudocapacitive performance in a three-electrode system, realizing an impressive capacitance of 777.7F g at a current density of 1 A g and an impressive 89.4 capacity retention over 10,000 cycles within a potential range of 1.7 V. Moreover, the NCO MXene AC ASC showcased remarkable energy performance, achieving an energy density of 73.3 Wh kg 1 and a power density of 849.9 W kg 1. Density functional theory (DFT) calculations demonstrated that the NCO MXene composite electrode possessed enhanced conductivity with metallic properties. The calculated partial density of states (PDOS) of NCO MXene HS was stronger than those of pure NCO and MXene. DFT results revealed that the NCO MXene composite system favored the experimental results for the prepared electrode material. The synergistic effects of NCO and MXene enabled the outstanding electrochemical performance of the NCO MXene AC-ASC composite, making it a highly favorable option for high-performance ASC electrodes.	{MXene,Bimetallic-Oxide,"Asymmetric Supercapacitor",DFT,"Energy density"}
665	Nitrogen functionalization modulates interlayer spacing and surface composition in 2D MXene Ti3C2Tx for enhanced ammonium ion (NH4+) storage	Ayesha Irfan, Nimra Irshad, Inaam Ullah, Samira Saddique, Chenxi Li, Muhammad Irfan, Mamoona Sattar, Salamat Ali, Haotian Hu, Waqar ul Hasan, Mai Li, Ping Zhong	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237775	https://www.sciencedirect.com/science/article/pii/S0378775325016118	0378-7753	Aqueous ammonium ions (NH4+) hybrid pseudocapacitors (AA-HPCs), utilizing NH4+ and SO42 as charge carriers, have garnered significant attention due to their higher sustainability and reduced fire risk compared to commercial lithium-ion batteries. NH4+, with their hydrogen bonding properties, form weaker bonds with nitrogen, oxygen, carbon, and fluorine atoms, enhancing ion diffusion and reaction kinetics. MXene Ti3C2Tx, a novel two-dimensional (2D) material, effectively enhances NH4+ charge storage and mechanical stability, but its ion diffusion is hindered by strong van der Waals interactions between adjacent sheets, which is mitigated through nitrogen functionalization (Ti3C2Tx TiN). In a three-electrode system, Ti3C2Tx TiN electrodes showed superior electrochemical performance over pure Ti3C2Tx, with a specific capacitance of 509.44 F g 1 at 1 A g 1 and 98.2 charge retention after 10,000 cycles. Density Functional Theory (DFT) calculations revealed increased adsorption energy and improved electronic properties in Ti3C2Tx TiN. Further, AA-HPCs with Ti3C2Tx TiN as the cathode and activated carbon as the anode achieved capacitance of 113.03 F g 1, 99.44 charge retention after 15,000 cycles, and an energy density of 40.19 Wh kg 1 at (800 W kg 1). These findings suggest that N-functionalized MXene-based AA-HPCs are promising for NH4+ storage.	{"Ammonium ion","Hybrid pseudocapacitors",MXene,"Two dimensional materials","Nitrogen functionalization","Density functional theory"}
659	Carbon nanotubes modified V-Ti3C2Tx poly(3,4-ethylenedioxythiophene) composite as a high-performance electrode for supercapacitor	Ze-Le Lei, Li Wan, Qiu-Feng Lü	Diamond and Related Materials	2024	https://doi.org/10.1016/j.diamond.2024.111696	https://www.sciencedirect.com/science/article/pii/S0925963524009099	0925-9635	Poly (3,4-ethylenedioxythiophene) (PEDOT) is an electrically conductive polymer that is highly conductive and oxidatively stable. However, its poor cycling stability and small specific capacitance limit its application as an electrode material for supercapacitors. In this work, carbon nanotubes (CNTs) modified V-Ti3C2Tx poly(3,4-ethylenedioxythiophene) composite (CVT PEDOT) was prepared by obtaining vanadium-doped Ti3C2Tx (V-Ti3C2Tx) using a simple hydrothermal method, and then polymerizing 3,4-ethylene-dioxythiophene monomers (EDOT) on the surface of carbon nanotubes modified V-Ti3C2Tx. The incorporation of CNTs with V-Ti3C2Tx results in better stability of CVT PEDOT. The synergistic effect of the three components make the CVT PEDOT composite have good electrochemical performance and excellent cycling stability as an electrode material for supercapacitor. The specific capacitance of CVT PEDOT at a current density of 1 A g 1 is up to 263 F g 1, and the capacitance retention is 86 after 5000 cycles at a current density of 10 A g 1, which is superior to that of the V-Ti3C2Tx PEDOT composite. The energy density of CVT PEDOT is 15.26 Wh kg 1 at a power density of 600 W kg 1, which is higher than those of previously reported PEDOTs and other PEDOT-based composites. So, the CVT PEDOT composite can be a potential candidate for electrode materials of supercapacitor.	{Ti3C2Tx,"Poly(3,4-ethylenedioxythiophene)","Vanadium doping",CNTs,Supercapacitor}
660	A one-pot strategy for modifying the surface of Ti3C2Tx MXene	Ken Aldren S. Usman, Mia Judicpa, Christine Jurene O. Bacal, Kevinilo P. Marquez, Jizhen Zhang, Bhagya Dharmasiri, James D. Randall, Luke C. Henderson, Joselito M. Razal	Surface and Coatings Technology	2024	https://doi.org/10.1016/j.surfcoat.2024.131522	https://www.sciencedirect.com/science/article/pii/S0257897224011538	0257-8972	Surface modification of MXenes significantly expands their potential for a wide range of applications. Here, we demonstrate a one-pot spontaneous polymerization of acrylic acid onto MXene sheet surfaces using an aryl diazonium coupling agent (nitrobenzene diazonium salt) as an approach to tune MXene interfacial properties. We use this formation of polymer coatings as a coagulation strategy for spinning fibers from liquid crystal MXene dispersions, obtaining densified free-standing fibers with tensile strength and breaking energy of 155 MPa and 4.5 MJ m 3. This simple method potentially offers a scalable approach for fabricating functional MXene macroarchitectures.	{MXenes,"Diazonium coupling",Polymerization,"Surface modification","fiber spinning"}
661	Boosting electrochemical activity via manipulating the d-band center of CoNi2Se4 MXene heterostructure for supercapacitor application	Minmin Hu, Lihong Chen, Yu Wang, Jun Dai, Yifan Bi, Yuanming Li, Jian Zhao, Guicun Li, Lei Wang, Alan Meng, Zhenjiang Li	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.162785	https://www.sciencedirect.com/science/article/pii/S1385894725036113	1385-8947	Heteroatom substitution stands as a promising strategy to boost the redox activity of transition metal selenides in supercapacitors; nonetheless, the underlying mechanisms that govern this enhanced activity have yet to be fully elucidated. It is presented that d-band center can be utilized as a descriptor to elucidate the redox activity. Within this context, we employ CoNi2Se4 MXene heterostructure as a paradigm, wherein CoNi2Se4 nanoplates are meticulously dispersed on MXene, thereby fostering a more efficient ion diffusion pathway to the redox reaction sites. Subsequently, phosphorus (P) heteroatoms, characterized by lower electronegativity and elevated ionization energy, are incorporated into CoNi2Se4 MXene architecture, which upshifts the d-band center of Ni Co active sites in CoNi2Se4 close to the Fermi level, resulting in a depletion in the occupancy of antibonding orbitals upon interaction with the O 2p orbital from electrolyte ion OH . This enhances the interfacial charge transfer and ensures robust OH adsorption, thereby boosting redox activity. Meanwhile, P doping also introduces Se vacancies, facilitating the ion adsorption and diffusion. Leveraging these advancements, the prepared cathode delivers a higher specific capacitance and retains a better cycling stability. This investigation not only delineates criteria for heteroatom selection but also sheds light on the intricate mechanisms of heteroatom substitution, offering a fresh perspective on the orbital-scale manipulation to augment the redox activity of supercapacitor electrodes.	{"Transition metal selenides",MXene,"D-band center","Electrochemical activity",Supercapacitor}
662	Facile synthesis of MnO2 Ti3C2Tx composite electrodes for superior performance supercapacitor	Yinghao Lv, Jiaqi He, Yajie Yang, Meilin Huang, Dawei He, Yongsheng Wang	Journal of Solid State Chemistry	2025	https://doi.org/10.1016/j.jssc.2025.125198	https://www.sciencedirect.com/science/article/pii/S0022459625000210	0022-4596	Supercapacitors are gaining traction in the energy storage sector due to their high power and energy density. MnO2 is identified as a promising supercapacitors electrode material due to its reversible Faraday reaction and great theoretical specific capacitance. However, its practical performance is hindered by poor electrical conductivity and structural instability. By incorporating Ti3C2Tx, a 2D MXene material known for its high conductivity and functional groups, the electrochemical behavior of the MnO2 composite is expected to be enhanced. This study introduces a novel method for synthesizing MnO2 Ti3C2Tx self-assembled electrodes (1, 3, 6, 9-MnO2 Ti3C2Tx composite electrodes) via a simple solution immersion technique at room temperature and ambient pressure. The state of manganese dioxide deposition can be influenced by varying the number of operations of the solution immersion technique. Among them, 6-MnO2 Ti3C2Tx has the largest specific surface area and achieves the best specific capacitance of 324.1 F g 1. When the current density is increased to 10 A g 1, the specific capacitance retention of 6-MnO2 Ti3C2Tx is 67.11 . Furthermore, the 6-MnO2 Ti3C2Tx Ti3C2Tx asymmetric capacitor demonstrated a maximum energy density of 30.8 W h kg 1 and a power density of 7493.3 W kg 1, maintaining a capacitance retention rate of 95.98 (from 74.6 to 71.6F g 1) after 2000 charge-discharge cycles. This study presents an effective and scalable synthesis strategy for MnO2 composite electrodes, highlighting their potential for future energy storage applications.	{"Self-assembled electrode","Solution immersion method",Supercapacitors,MXenes,"Manganese dioxide"}
663	MXene Biomass-derived activated carbon composite for supercapacitor applications	Rohit Sinha, P. Sai Kiran, K. Vijay Kumar, Niranjan Pandit, Chintham Satish, Saurav Keshri, Anup Kumar Keshri	Carbon	2025	https://doi.org/10.1016/j.carbon.2025.120101	https://www.sciencedirect.com/science/article/pii/S0008622325001174	0008-6223	Two-dimensional (2D) MXenes (e.g., Ti₃C₂Tₓ) have garnered significant interest in supercapacitor applications because of their outstanding conductivity, hydrophilicity, and charge storage capabilities. However, the inherent tendency of MXenes to restack and agglomerate severely limits electrolyte accessibility and reduces their electrochemical performance. To address this limitation, creating three-dimensional (3D) porous architectures by introducing interlayer spacers has emerged as an effective strategy. Conventionally, expensive spacers like graphene, carbon nanotubes, polypyrrole, reduced graphene oxide, etc., have been employed, which restricts scalability and cost-efficiency. Herein, we present a sustainable and cost-effective approach by synthesizing porous activated carbon (AC) derived from biomass waste (orange peels) and incorporating it as a spacer within Ti₃C₂Tₓ MXene layers. The resulting Ti₃C₂Tₓ AC composite demonstrates enhanced structural stability through increased open spaces and expanded interlayer spacing (d = 1.1 nm), improved hydrophilicity (contact angle (CA): 13.46 ), and superior electrolyte accessibility. Electrochemical evaluation in aqueous electrolyte shown a specific capacitance of 407 F g 1 at 5 mV s 1. Furthermore, the fabricated all solid-state supercapacitor (ASSC) showed the rate capability of up to 5000 cycles with an outstanding 96.36 coulombic efficiency and 92.98 capacitance retention, proving long-term stability in an aqueous environment. Our study underscores the dual advantage of valorizing biomass waste for creating porous carbon and achieving scalable, environmentally friendly MXene composites with optimized electrochemical properties for supercapacitor applications in aqueous electrolyte.	{"Biomass-derived activated carbon",MXene,"3D open porous structure",Supercapacitors,"Electrochemical performance"}
666	Nanoflower-like hollow NiMnCo-OH decorated with self-assembled 2D Ti3C2Tx for high-efficiency hybrid supercapacitors	Chenming Liang, Zikai Feng, Mingwu Chen, Xiaohui Xv, Min Lu, Weixue Wang	Journal of Alloys and Compounds	2024	https://doi.org/10.1016/j.jallcom.2023.172537	https://www.sciencedirect.com/science/article/pii/S0925838823038409	0925-8388	Layered double hydroxides (LDHs) have gained awareness as promising energy materials due to their high electrochemical activity and tunable interlayer characteristics. However, inherent drawbacks limit them to achieve high capacitance. Introducing complementors with high conductivity and stability is an effective strategy for addressing these challenging issues. Therefore, we employed a simple and controllable method to synthesize nanoflower-like hollow NiMnCo-OH MXene (NMCM) composites by multi-element doping and electrostatic self-assembly strategies. The MXene nanosheets formed a three-dimensional (3D) conductive network, which increased stability and promoted fast charge transport at interfaces. At the same time, the heterogeneous ternary hydroxides inhibited MXene aggregation and provided considerable capacitance. The NMCM showed ultra-long cycling stability of 91.7 after 5000 cycles at 5 A g 1 (compared to the initial specific capacitance) and achieved a capacitance capacity of 232.37 mAh g 1 at 1 A g 1 in a three-electrode device. Furthermore, under 800 W kg 1 power density, the NMCM Ti3C2 asymmetric device showed an impressive energy density of 54.1 Wh kg 1. This work demonstrates a simple and successful strategy for creating high-performance energy storage devices based on 3D hollow framework electrodes.	{"Layer Double Hydroxides",MXene,Self-assembled,Supercapacitors,"Hollow Structure"}
667	Self-assembled MXene(Ti3C2Tx) α-Fe2O3 nanocomposite as negative electrode material for supercapacitors	Ren Zou, Hongying Quan, Menghua Pan, Shuai Zhou, Dezhi Chen, Xubiao Luo	Electrochimica Acta	2018	https://doi.org/10.1016/j.electacta.2018.09.149	https://www.sciencedirect.com/science/article/pii/S0013468618321455	0013-4686	To further improve the electrochemical performance of MXene materials, MXene(Ti3C2Tx) α-Fe2O3 nanocomposites are fabricated by a self-assembly method via electrostatic attraction between negatively charged Ti3C2Tx MXenesand positively charged cocoa-like α-Fe2O3 nanoparticles at room temperature. As a negative electrode material, the resulting nanocomposites show excellent electrochemical performance, including a wide operating potential of 1.2 V ( 1.2 0 V), a high specific capacitance of 405.4 F g 1 at the current density of 2 A g 1 and a specific capacitance of 197.6 F g 1 even at the current density of 20 A g 1 in 5 M LiCl. In addition, the nanocomposites possess a high cycling stability with 97.7 capacitance retention of the initial capacitance after 2000 cycles. The impressive results indicate that the prepared MXene(Ti3C2Tx) α-Fe2O3 nanocomposites is a promising negative electrode material for supercapacitor. The self-assemble of MXenes and metal oxides will provide more opportunities for their application in energy storage.	{MXenes,"Metal oxides",Nanocomposites,"Negative electrodes",Supercapacitors}
668	BiOBr nanoparticle-modified Ti3C2Tx MXenes for photocatalytic degradation of organic arsenic in wastewater	Yaxin Guo, Ya-Nan Wang, Jinsong Peng, Haiyan Song, Chunxia Chen	RSC Advances	2025	https://doi.org/10.1039/d5ra02929e	https://www.sciencedirect.com/science/article/pii/S2046206925016213	2046-2069	Arsenic (As) contamination in water remains a serious concern due to its high toxicity and harmful effects on human health and the environment. Herein, we successfully synthesized a novel photocatalyst (BiOBr Ti3C2) by in situ inserting BiOBr nanoparticles into Ti3C2Tx MXenes for the photocatalytic degradation of organic arsenic roxarsone (3-nitro-4-hydroxyphenylarsonic acid) in wastewater. BiOBr Ti3C2 exhibited a unique morphology characterized by uniform BiOBr nanoparticles within more dispersed Ti3C2Tx layers. Heterojunctions were formed between Ti3C2Tx and BiOBr, which were conducive to photogenerated charge separation and electron transfer in Ti3C2Tx layers. An optimal BiOBr Ti3C2 photocatalyst achieved a removal efficiency of 1.27 mg gcat. 1 h 1 for 2 mg L 1 of roxarsone wastewater within 0.5 h and a higher removal rate (about 1.5 times at 3 h) than pure Ti3C2Tx. In addition, BiOBr Ti3C2 exhibited an apparent quantum yield (AQY) of 29.5 and good reusability for 4 cycles. The enhanced photocatalytic performance was mainly attributed to the intercalation of BiOBr nanoparticles within Ti3C2Tx layers, which increased reaction space and improved the separation and transport of photocarriers. Holes (h+) and OH in the valence band (VB) of BiOBr Ti3C2 were involved in the main route of roxarsone oxidative mineralization. The present BiOBr Ti3C2 system provides fundamentals for the sustainable photocatalytic treatment of wastewater containing organic arsenic.	{}
669	A capacitance-enhanced MXene anode for high-performance and dual-functional quasi-solid-state ammonium ion hybrid supercapacitor	Qiang Wang, Shenshen Guan, Ranyun Wu, Liangliang Su, Yalong Yang, Xulai Zhu, Yuxia Hu, Junpeng Zhang, Jia Si, Wei Zeng	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.179788	https://www.sciencedirect.com/science/article/pii/S0925838825013465	0925-8388	The aqueous ammonium ion hybrid supercapacitor (AIHSC) for dual-energy storage mechanisms of bulk intercalation and bulk adsorption has attracted extensive attention from researchers in the field of energy storage. However, AIHSC currently lacks sufficiently effective anode materials with high capacitance and stability. Pre-intercalated MXene electrodes have demonstrated high-capacity advantages in the fields of magnesium and zinc ion energy storage, but there have been no research reports in the field of AIHSC. Here, for the first time, pre-intercalated MXene was used as the anode material for AIHSC, and a high-performance multifunctional AIHSC was constructed by combining it with multi-walled carbon nanotubes-FeFe(CN)6 cathode. A series of characterizations and theoretical calculations show that pre-intercalated strategies can effectively enhance the electrochemical properties of MXene. As a result, the pre-intercalated MXene anode shows a superior ammonium storage capacitance of 252 F g 1 and a high stability of 6000 cycles. The quasi-solid-state AIHSC also displays the excellent electrochemical performance and can be directly used as a pressure sensor to monitor external pressure changes and human limb movements. This study provides a viable path to the effective development of high-performance multifunctional AIHSCs and their anodes.	{"Ammonium ion hybrid supercapacitor",Anode,MXene,Pre-intercalated,Multifunctional}
670	Microwave assisted synthesis of Ti3C2-MXene for supercapacitor application Electronic supplementary information (ESI) available. See DOI: https: doi.org 10.1039 d4cc04765f	Prasad Eknath Lokhande, Udayabhaskar Rednam, Vishal Kadam, Chaitali Jagtap, Deepak Kumar, Radhamanohar Aepuru	Chemical Communications	2025	https://doi.org/10.1039/d4cc04765f	https://www.sciencedirect.com/science/article/pii/S1359734525000175	1359-7345	Two-dimensional Ti3C2 MXene has been successfully synthesized using an ultrafast microwave-assisted method. Material characterization studies have confirmed the formation of a layered MXene structure. Additionally, the electrochemical performance observed for the synthesized material indicates its promising potential for use in supercapacitor applications.	{}
672	Unveiling the potential: Asymmetric supercapacitors with conductive polymers Ti3C2Tx Ni3S4 electrodes deliver high energy densities	Xuguang Wang, Kai Song, Hongtao Yang, Ruxangul Jamal, Tursun Abdiryim, Abdukeyum Abdurexit, Nana Fan, Yajun Liu, Jiabei Li, Jiachang Liu	Electrochimica Acta	2024	https://doi.org/10.1016/j.electacta.2024.145155	https://www.sciencedirect.com/science/article/pii/S0013468624013926	0013-4686	Ti3C2Tx is considered a promising electrode material for supercapacitors due to its fast electronic properties, excellent hydrophilicity and mechanical properties. However, severe Ti3C2Tx nanosheet stacking reduces the exposed active sites and hinders the ion diffusion of Ti3C2Tx, leading to poor electrochemical performance. Here, we report a strategy for doping of Ti3C2Tx, in which the Ni3S4 and conducting polymer (CP) were selected as doping agent for Ti3C2Tx, and it is expected that metal sulfide and CP can overcome the defects of Ti3C2Tx. In this work, the conducting polymers were as polyaniline (PANI), polypyrrole (PPY) and poly(3,4-ethylenedioxythiophene) (PEDOT). As a result, the prepared composites exhibit superior multiplicative capacity with a capacitance of 2502 F g-1 (PANI Ti3C2Tx Ni3S4), 2440 F g-1 (PPY Ti3C2Tx Ni3S4), and 2620 F g-1 (PEDOT Ti3C2Tx Ni3S4), respectively. In addition, CP Ti3C2Tx Ni3S4 AC asymmetric supercapacitors were assembled with energy densities of 60.2 (PANI Ti3C2Tx Ni3S4), 86.7 (PPY Ti3C2Tx Ni3S4), and 53.4 (PEDOT Ti3C2Tx Ni3S4) Wh kg-1 at 1,500 W kg-1, respectively. This work develops a simple way to prepare the porous Ti3C2Tx film for supercapacitors with excellent electrochemical performance.	{Ti3C2Tx,Ni3S4,"Poly(3,4-ethylenedioxythiophene)",Polyaniline,Polypyrrole,"Hybrid supercapacitors"}
673	Ti3C2TX encapsulation of CTAB-functionalized polypyrrole nanospheres towards pseudocapacitive intensification in supercapacitors	Wen Siong Poh, Do Yee Hoo, Sheng Qiang Zheng, Wee-Jun Ong, Poi Sim Khiew, Hong Ngee Lim, Chuan Yi Foo	Chemical Engineering Journal	2024	https://doi.org/10.1016/j.cej.2024.154440	https://www.sciencedirect.com/science/article/pii/S1385894724059291	1385-8947	The critical criteria for supercapacitor to power the increasingly prevalent portable electronic devices lies within its active material design that yields high specific capacitance without compromising rate performance. Herein, polypyrrole (PPy) was synthesized into nanospheres (PPy NS) to improve bulk ion transport kinetics. However, numerous interfaces generated by nanospherical structure induce high nanocontact resistance, resulting in low specific capacitance. Thus, PPy NS were surface-functionalized with cationic surfactant n-Cetyl-n,n,n-trimethylammonium bromide to facilitate enwrapping by highly electrically conductive Ti3C2TX nanosheets via electrostatic self-assembly, where the Ti3C2TX shells serves as effective conductive pathways. Flake sizes of Ti3C2TX nanosheets were modulated via probe ultrasonication to maximize conformability to PPy NS, minimizing tortuosity of ion diffusion pathways and establishing ubiquitous heterostructure contact. This resulted in enhanced rate performance of 74 capacitive retention during scan rate increase from 1 to 100 mV s 1 (pure PPy NS at 58 ). Furthermore, positively charged moieties imparted by surface-functionalization of PPy NS instigate electronic coupling with negatively charged surface terminations of Ti3C2TX nanosheets, facilitating rapid interfacial electron transfer. Through simultaneous dimensional and surface charge alignment, the nanocomposite achieved specific capacitance of 619.7 F g 1 at 5 A g 1 ( 37-fold enhancement over pure PPy NS), despite incorporation of low amounts of Ti3C2TX (9 wt ). This work highlights the potential of such material integration techniques in realizing capacitive intensification beyond incremental improvements as well as boosting rate performance, with methodical employment of minimal functional additive. It serves as a framework for future studies optimizing 2D-0D material nanocomposites for supercapacitor applications.	{Supercapacitor,Polypyrrole,MXene,"Surface functionalization","Structural modification","Electronic coupling"}
674	Preparation of 3D flower-like Ti3C2Tx microspheres by W O emulsion-assisted assembly and their application for supercapacitors	Jidong Bu, Wenqian Zhang, Yan Su, Lijian Xu, Shifeng Hou	Ceramics International	2022	https://doi.org/10.1016/j.ceramint.2021.12.300	https://www.sciencedirect.com/science/article/pii/S0272884221040955	0272-8842	In this study, we proposed in situ controlled preparation of 3D flower-like Ti3C2Tx microspheres (FMXMSs) by water-in-oil (W O) emulsion-assisted assembly. Polyethyleneimine (PEI), as a large molecule, can effectively stabilize the emulsion system. Ethylenediamine (EDA), as a weak cross-link agent, contains rich amino groups, which can effectively induce the assembly of Ti3C2Tx in spherical droplets and eventually form 3D flower-like Ti3C2Tx microspheres. By adjusting the water-oil volume ratio, the size of micro-emulsion droplets can be controlled, thus the structure and size of microspheres can finally be controlled. The structure has a large specific surface area (108.31 m2 g-1) which can provide an effective ion diffusion pathway. As the supercapacitors electrode, the specific capacitance of FMXMSs is up to 224.57 F g-1 at 5 mV s-1 and 193.67 F g-1 at 0.5 A g-1. Moreover, they also show good long-term cyclic stability. After 5000 cycles, the specific capacitance does not decay. The results indicate that W O emulsion-assisted assembly is feasible for preparing MXenes microspheres with high electrochemical performance.	{Ti3C2Tx,"W/O emulsion-assisted assembly","3D microspheres",Supercapacitors}
675	Sandwich-like NiFe-LDH MnCO3 MXene ternary nanocomposites serve as battery-type electrode for high-performance asymmetric supercapacitor	Liangchen He, Ping Cai, Huajun Lai, Kecheng Lu, Zebing Xu, Rui Zeng, Chenggang Hao, Zhongmin Wang, Weijiang Gan	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2024.159149	https://www.sciencedirect.com/science/article/pii/S1385894724106407	1385-8947	Ti3C2Tx MXene is a promising supercapacitor electrode material, characterized by excellent conductivity and outstanding cycle stability. However, its limited gravimetric capacitance constrains the further applications of MXene materials in supercapacitors. Herein, a ternary composite NiFe-LDH MnCO3 MXene (NFMM) composite with a three-dimensional layered structure was successfully synthesized using a straightforward hydrothermal method. MnCO3 nanoparticles were deposited onto the surface of Layered Double Hydroxide (LDH), providing significant capacitance. The collapse of LDH is largely mitigated, which may be due to the heterostructure effect. Additionally, the synergistic effect of NiFe-LDH MnCO3 and MXene effectively enhances the conductivity of the NiFe-LDH MnCO3 material. The results indicate that the NFMM composite exhibits a superior gravimetric capacity of 2079.6F g at 1 A g and retains 85 of its capacitance at 10 A g after 5000 cycles. An asymmetric supercapacitor was constructed using NFMM and activated carbon as the positive and negative electrodes, achieving an energy density of 67.3 W h kg 1 and at 750.9 W kg 1, with outstanding cyclic stability of 89 after 5000 cycles. These findings underscore the promising potential of ternary materials for energy storage applications.	{MXene,"Ternary composite","Layered double hydroxide",MnCO3,"Batter-type supercapacitor"}
676	MXenes from MAX phases: synthesis, hybridization, and advances in supercapacitor applications	Tamal K. Paul, Md. Abdul Khaleque, Md. Romzan Ali, Mohamed Aly Saad Aly, Md. Sadek Bacchu, Saidur Rahman, Md. Zaved H. Khan	RSC Advances	2025	https://doi.org/10.1039/d5ra00271k	https://www.sciencedirect.com/science/article/pii/S2046206925007107	2046-2069	MXenes, which are essentially 2D layered structures composed of transition metal carbides and nitrides obtained from MAX phases, have gained substantial interest in the field of energy storage, especially for their potential as electrodes in supercapacitors due to their unique properties such as high electrical conductivity, large surface area, and tunable surface chemistry that enable efficient charge storage. However, their practical implementation is hindered by challenges like self-restacking, oxidation, and restricted ion transport within the layered structure. This review focuses on the synthesis process of MXenes from MAX phases, highlighting the different etching techniques employed and how they significantly influence the resulting MXene structure and subsequent electrochemical performance. It further highlights the hybridization of MXenes with carbon-based materials, conducting polymers, and metal oxides to enhance charge storage capacity, cyclic stability, and ion diffusion. The influence of dimensional structuring (1D, 2D, and 3D architectures) on electrochemical performance is critically analyzed, showcasing their role in optimizing electrolyte accessibility and energy density. Additionally, the review highlights that while MXene-based supercapacitors have seen significant advancements in terms of energy storage efficiency through various material combinations and fabrication techniques, key challenges like large-scale production, long-term stability, and compatibility with electrolytes still need to be addressed. Future research should prioritize developing scalable synthesis methods, optimizing hybrid material interactions, and investigating new electrolyte systems to fully realize the potential of MXene-based supercapacitors for commercial applications. This comprehensive review provides a roadmap for researchers aiming to bridge the gap between laboratory research and commercial supercapacitor applications.	{}
677	A Ti3C2Tx-encapsulated Mn2+-doped Co(OH)2 nanosheets electrode grown on carbon cloth for low-temperature flexible supercapacitors	Wenfeng Zhang, Yan Shan, Xuegang Yu, Kezheng Chen	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2024.145606	https://www.sciencedirect.com/science/article/pii/S0013468624018425	0013-4686	In general, most flexible supercapacitors with excellent performance at room temperature cannot work properly at relatively low temperatures (such as 0 C), mainly due to the poor cold resistance of the electrodes and electrolytes. In this paper, the carbon cloth was coated with positively charged Mn2+-doped Co(OH)2 coating by electrodeposition and then impregnated with negatively charged Ti3C2Tx nanosheets suspension (This electrode is named CC Co(OH)2:Mn2+ Tx, Where x is the number of impregnation Ti3C2Tx.). The results show that the obtained electrode has a good supercapacitor performance with the specific capacitance of 22.13 F g 1 (the area specific capacitance of the sample is 202.5 mF cm 2), which is attributed to the synergistic effect of Ti3C2Tx and the flower microstructure of Mn2+-doped Co(OH)2 coating. Ti3C2Tx was introduced to polyvinyl alcohol sodium alginate hydrogel electrolyte to obtain a new antifreezing organohydrogel and then a flexible asymmetric supercapacitor was assembled with CC Co(OH)2:Mn2+ T3 as the positive electrode, CC T3 as negative electrode, and the performance of the supercapacitor at 25 C and at 0 C were investigated. It was found the supercapacitor exhibited better performance at 0 C instead of 25 C. When the current density is 5 mA cm 2, the area specific capacitance of the supercapacitor at 0 C reaches 52.02 mF cm 2. After 1000 cycles, the supercapacitor has a capacitance retention rate of 82.5 at 0 C, which is much higher than that of 55.15 at 25 C. The reason may be related to the Ti3C2Tx and the crosslinked networks structures of composite hydrogel. The results show that the supercapacitor has excellent working ability at 0 C, which provides the possibility for the device to work normally in low temperature.	{"Flexible supercapacitors",Hypothermia,MXene,"Neutral electrolyte"}
678	Porous structure evolution and phase purity control from Ti3AlC2 MAX to Ti3C2Tx MXene prepared by safe and scalable approaches	Yonghong Wang, Panyan Zhu, Weike Zhao, Qiuhua Zhang, Junwu Liu, Xuejiao Chen, Yuanhang Zhou, Yonglong Zhang, Xianjun Xing	Diamond and Related Materials	2025	https://doi.org/10.1016/j.diamond.2025.112026	https://www.sciencedirect.com/science/article/pii/S0925963525000834	0925-9635	Sustainable development technology related porous Ti3AlC2 (MAX) ceramics and Ti3C2Tx (MXenes) were prepared by pressureless encapsulating sintering method and mild etching procedure. The phase composition and porous structure evolution of MAX phase and the resulting MXenes were systematically investigated as function of the preparation conditions like encapsulating process, sintering temperatures and holding times. The results show that the volatilization of Al element from green-compacts encapsulated in graphite foil can effectively be alleviated ensuring sufficient Al source for the synthesis of high pure MAX phase. A 96.36 wt purity of Ti3AlC2 phase was obtained at 1350 C for 2 h. In addition, the formation mechanism viz. the dissolution-precipitation models for the development of Ti3AlC2 in the TiC-Al-Ti ternary system has been discussed. Furtherly, the open porosity of obtained Ti3AlC2 ceramics varies little in the scope of 53.5 55.0 and the centered pore size from 3.7 μm to tens micrometers changes apparently at different sintering temperature. After in situ selective chemical etching with mild methods, the accordion-like porous MXenes from the prepared MAX phase are successfully exfoliated in large scale.	{"Porous Ti3AlC2","Pressureless-encapsulating sintering","Mass transportation mechanism","2D MXenes","Nitrogen adsorption-desorption"}
679	MnO2 nanoshells Ti3C2Tx MXene hybrid film as supercapacitor electrode	Xiaobao Zhang, Baiyi Shao, Aoping Guo, Zemin Sun, Junkai Zhao, Fangming Cui, Xiaojing Yang	Applied Surface Science	2021	https://doi.org/10.1016/j.apsusc.2021.150040	https://www.sciencedirect.com/science/article/pii/S0169433221011168	0169-4332	A flexible MnO2 Ti3C2Tx hybrid film was prepared and used directly as pseudo-capacitive electrode for supercapacitors, composed of alternately arranged porous Ti3C2Tx nanosheets and MnO2 nanoshells. The unique porous structure of the film facilitated the ion transport both in the vertical and in-plane directions by the nanopores in the intra-layer and inter-layer of Ti3C2Tx nanosheets. And the specific surface area, specific capacitance and cycle stability of the hybrid film were dramatically improved compared with those of MnO2 nanoshells and porous Ti3C2Tx nanosheets.	{"Ti3C2Tx MXene","MnO2 nanoshells","Porous structure",Pseudo-capacitance,Supercapacitor}
685	Hollow CuO and MXene dual-reinforced MoS2 heterostructures for high energy density supercapacitor negative electrode	Ziyang Zhu, Nan He, Dong Wang, Qicheng Chen, Yingjin Zhang, Bingjian Nie	Energy	2025	https://doi.org/10.1016/j.energy.2025.137658	https://www.sciencedirect.com/science/article/pii/S0360544225033006	0360-5442	MoS2 is considered a highly promising anode material for supercapacitors owing to its distinctive two-dimensional structure. However, its relatively low electrical conductivity restricts its further development and practical application. For the purpose of addressing this issue, this study reports the first synthesis of a CuO MoS2 MXene ternary heterostructure based on hollow CuO. The formation of the built-in electric field, along with the redistribution of local charge, facilitates the transformation of 2H-MoS2 into highly conductive 1T-MoS2. In addition, the three-dimensional crosslinked network structure formed by the highly conductive MXene and MoS2 layers offers additional storage capacity for electrolyte ions, thereby further enhancing the energy storage density of the material. This negative material exhibits a maximum specific capacitance of 1435.2 F g 1, which is significantly higher than that of most reported MoS2-based negative materials. The synergistic support provided by the porous CuO substrate and the MXene layer effectively inhibits the lamellar aggregation of MoS2, thereby achieving a capacitor retention rate of 90.1 after 5000 charge-discharge cycles. The asymmetric supercapacitor constructed from the material achieves a maximum energy density of 91.4 Wh kg 1, demonstrating excellent application potential in various fields. This study addresses the research gap concerning negative electrode materials for high specific capacitance MoS2-based supercapacitors and offers a novel approach to further enhancing the energy density of supercapacitors.	{"Negative electrode material","Hollow structure",Heterojunction,"Network crosslinking structure","High energy density"}
680	Machine learning models for prediction of electrochemical properties in supercapacitor electrodes using MXene and graphene nanoplatelets	Mohammed Shariq, Sathish Marimuthu, Amit Rai Dixit, Somnath Chattopadhyaya, Saravanan Pandiaraj, Muthumareeswaran Muthuramamoorthy, Abdullah N. Alodhyab, Mohammad Khaja Nazeeruddin, Andrews Nirmala Grace	Chemical Engineering Journal	2024	https://doi.org/10.1016/j.cej.2024.149502	https://www.sciencedirect.com/science/article/pii/S1385894724009872	1385-8947	Herein, machine learning (ML) models using multiple linear regression (MLR), support vector regression (SVR), random forest (RF) and artificial neural network (ANN) are developed and compared to predict the output features viz. specific capacitance (Csp), electrical conductivity (σ) and sheet resistance (Rs) for MXene Graphene Nanoplatelets (GNPs) based energy storage devices. These output features are modeled as a function of wt. in different weight ratios of GNPs in MXene, optimum potential window and scan rates. The datasets are obtained by the real time output measurements through the experimental runs of these composites in different weight ratios. Among these models, ANN had achieved the highest performance followed by MLR, SVR and RF. From both the experimental and ANN results, the electrode with 20 wt of GNPs in MXene (MG-80) exhibited the highest Csp of 226.6F g at 5 mV s with a long cycle life having 84.2 retention even after 5000 cycles of charging-discharging. ANN model is further utilized to predict the cyclic stability of MG-80 electrode upto 10,000 cycles and the results show the accuracy of the ML model to fabricate storage devices. Furthermore, the structure of MXene GNPs composites are investigated by different characterization techniques. XRD spectra confirmed the successful synthesis of MXene and the successful intercalation of GNPs into MXene sheets. The morphology of the embedded GNPs in layered MXenes are determined through FE-SEM EDX and HR-TEM analysis. The increase in the surface area and pore volume in the MXene GNPs composite are revealed by BET measurements. XPS is utilized to find out the chemical element states of the bare MXene as well as its composite with GNPs.	{"Machine Learning",Regression,"Artificial neural network","MXene (Ti3C2Tx)","Graphene nanoplatelets",Supercapacitors}
681	Enhanced performance of MXene-based supercapacitor via new activated carbon-nafion composite cathode	Aleyna Akıllı, Bircan Haspulat Taymaz, Volkan Eskizeybek, Handan Kamış	Journal of Physics and Chemistry of Solids	2025	https://doi.org/10.1016/j.jpcs.2024.112523	https://www.sciencedirect.com/science/article/pii/S0022369724006589	0022-3697	Asymmetric supercapacitors leverage differences in the work functions of electrode materials to achieve an extended operating potential window and enhanced energy storage capacity. In this study, an asymmetric supercapacitor was developed using Ti₃C₂Tₓ MXene as the working electrode and a composite of activated carbon-nafion (AC-N) and activated carbon-polyvinylidene fluoride (AC-P) as the counter electrode. The work functions of MXene and AC-N were measured as 7.06 and 9.6 eV, respectively, enabling a potential window expansion to 2 V with the AC-N counter electrode. Electrochemical evaluations in H₂SO₄, MgSO₄, and KOH electrolytes revealed specific capacitance values of 555, 367.5, and 425 F g 1 in, respectively. Additionally, corresponding power densities reached 1023, 999.86, and 1980.25 W kg 1, while energy densities were determined to be 81.2, 40.55, and 26 Wh kg 1. These findings highlight a straightforward strategy to enhance energy storage performance by leveraging the distinctive properties of MXene.	{MXene,Supercapacitor,"Potential window","Work function","Counter electrode"}
682	Tailoring interlayer spacing in binder free Ti3C2Tx NiMoO4-P hybrid electrode for enhanced supercapacitor performance	Sadaf Siddique, Abdul Waheed, Mutawara Mahmood Baig, Muhammad Iftikhar, Jamil Ahmad, Attaullah Shah, Sajjad Hussain, Xiaolei Su, Faisal Shahzad	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.110704	https://www.sciencedirect.com/science/article/pii/S2352152X24002883	2352-152X	In this study, we present a novel electrode comprised of Ti3C2Tx MXene, which has been integrated with NiMoO4 nanoflakes (referred to as Ti3C2Tx NiMoO4-P), achieved through a straightforward mixing of their respective solutions. The NiMoO4 particles inhibited the restacking of MXene sheets, thus leading to the effective utilization of active surface area by facilitating the intercalation of electrolyte ions. The binder-free Ti3C2Tx NiMoO4-P electrode displayed a superior specific capacitance of 550 F g 1 (440 C g 1) as compared to an electrode developed through a hydrothermal and calcination treatment, referred to as Ti3C2Tx NiMoO4-H which displayed a specific capacitance of 472 F g 1 (377 C g 1) at 2 mV s 1 in 0.5 M H2SO4 solution. Moreover, the Ti3C2Tx NiMoO4-P electrode exhibited excellent cyclic stability with 81 capacitance retention after 5000 cycles at 50 mV s 1. A symmetric supercapacitor consisting of Ti3C2Tx NiMoO4-P electrode delivered a maximum capacitance of 71.5 F g 1 at 0.5 A g 1 with a high energy density (9.3 Wh kg 1 at a specific power density of 2.5 kW kg 1). The heterostructure of Ti3C2Tx NiMoO4-P provided significant insight into enhancing the energy storage performance by controlling the interlayer spacing to develop flexible energy storage devices.	{Supercapacitors,Ti3C2Tx,"NiMoO4 nanosheets","Free-standing hybrid electrode","Symmetrical device",Binder-free}
683	Construct interface pollared lared interaction in Co-MOF MXene as high flexibility electrode for solid-state hybrid supercapacitor	Bingzhe Jia, Xinrui Qiang, Lei Wang, Jiale Wang, Haibo Che, Jiarui Li, YiChi Liu, Zhiqiang Li, Yufei Wang, Xiaodie Huang, Xinming Wu	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.181953	https://www.sciencedirect.com/science/article/pii/S0925838825035145	0925-8388	Energy storage devices based on MXene flexible electrodes have advantages such as high electrochemical performance, but their flexible cycling stability limits their further commercial applications. Based on this, this work presents a high-performance Co(terephthalic acid, triethylenediamine) Ti3C2 MXene (Co(BDC, TEDA) Ti3C2) hybrid electrode fabricated through in situ growth of three-dimensional Co(BDC, TEDA) MOFs within Ti3C2 MXene interlayers via a one-step solvothermal approach. The rationally designed heterostructure achieves synergistic performance enhancement through three key interface engineering effects: interlayer expansion, complementary conductivity-redox, and covalent interface bonding. Electrochemical characterization demonstrates outstanding performance metrics, including a specific capacitance of 214.65 F g 1 at 100 mA g 1, an energy density of 10.73 Wh kg 1, and remarkable cycling stability with 93.1 capacitance retention after 10,000 cycles, significantly outperforming individual components. First-principles calculations reveal a 129 enhancement in Na adsorption energy ( 2.18 eV vs. 0.95 eV for pristine MXene), providing atomic-level insights into the improved energy storage mechanisms. Furthermore, asymmetric flexible devices show excellent mechanical flexibility and can withstand bending at 0 90 while keeping electrochemical performance constant. This work offers a promising strategy for designing flexible, high-performance electrodes with strong potential for practical applications.	{MXene,MOFs,Supercapacitor,"Flexible devices",Electrochemical}
684	Enhanced photoluminescence emission and pH sensitivity in oxygen-dominated functional group of highly stable Ti3C2Tx MXene	Sheetal Sharma, Manoj Kumar Gupta, Vinod Kumar Singh	Materials Chemistry and Physics	2025	https://doi.org/10.1016/j.matchemphys.2025.130874	https://www.sciencedirect.com/science/article/pii/S0254058425005206	0254-0584	Transition metal carbides, commonly known as MXenes, represent a promising family of two-dimensional nanomaterials characterized by diverse surface functional groups that vary with the synthesis method. This study investigates the enhanced luminescence of MXene nanosheets, increasing photoluminescence intensity due to improved charge transfer, and the influence of pH on the photoluminescence excitation spectrum of Ti3C2Tx MXene, which features oxygen-dominated functional groups. The Ti3C2Tx MXene was well-synthesized using hydrofluoric acid (HF), as confirmed with X-ray diffraction analysis, which revealed the hexagonal structure of Ti3C2Tx with a crystallite size of 3.8 nm, while electron microscopy images illustrated its distinct layered morphology with the inter-layer spacing of 1.13 nm which reveals good flexibility and tensile strength of the MXene. Photoluminescence studies demonstrated significant light emission with enhanced photoluminescence intensity with varying excitation wavelength in the blue green region, spanning from 400 nm to 690 nm. Notably, pH-dependent photoluminescence analysis indicated a decrease in excitation intensity at pH 2, suggesting a loss of the material s intrinsic properties under acidic conditions. Furthermore, cyclic voltammetry and zeta potential reveal outstanding stability of MXene over time. The electrical measurement reveals the semiconducting nature of Ti3C2Tx, which is evident from its band gap. This research highlights the critical role of pH in modulating the optical properties of Ti3C2Tx MXene, paving the way for potential applications in optoelectronic devices and sensors.	{"MAX phase precursor",MXene,Photoluminescence,"Excitation spectrum",Bandgap}
686	RETRACTED: Enhanced electrochemical performance with exceptional capacitive retention in Ce Co MOFs Ti3C2Tx nanocomposite for advanced supercapacitor applications	Rabia Siddiqui, Malika Rani, Aqeel Ahmed Shah, Sadaf Siddique, Akram Ibrahim	Heliyon	2024	https://doi.org/10.1016/j.heliyon.2024.e36540	https://www.sciencedirect.com/science/article/pii/S2405844024125716	2405-8440	This article has been retracted: please see Elsevier policy on article withdrawal (https: www.elsevier.com about policies-and-standards article-withdrawal). This article has been retracted at the request of the Editor-in-Chief. An investigation conducted by Elsevier s Research Integrity Publishing Ethics team on behalf of the journal identified references that are irrelevant to the article. The authors were asked to comment upon the presence of these references in their work but were unable to satisfactorily address the reason for the references. Consequently, the editor no longer has confidence in the integrity and the findings of the article and has decided to retract it. The scientific community takes a very strong view on this matter and apologies are offered to readers of the journal that this was not detected during the submission process. The authors disagree with the retraction and dispute the grounds for it.	{}
687	Synthesis of MXene films with horizontally and vertically hierarchical pores for high-performance supercapacitors	Wenlong Yan, Sai Yan, Debin Cai, Zhen Tian, Li Guo, Yanzhong Wang	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.146479	https://www.sciencedirect.com/science/article/pii/S0013468625008412	0013-4686	MXene has been considered a promising electrode material due to its excellent metal conductivity and high pseudocapacitance. However, the tightly packed MXene nanosheets reduce the specific surface area and extend the ion transport pathway, resulting in a decrease in electrochemical active sites and slow ion transport, leading to the unsatisfactory specific capacitance. Here, FeCl3 is used as an inducer and etchant to induce Ti3C2Tx MXene nanosheets to form microgels while mildly oxidizing MXene to TiO2, and then the formed TiO2 nanoparticles are removed by using hydrofluoric acid, which results in the forming the mesoporous Ti3C2Tx MXene microgels. The porous Ti3C2Tx MXene films with horizontal and vertical meso- and macro-pores are prepared via a vacuum filtration, which exposes abundant active sites and ion transport channels. Therefore, the prepared three-dimensional porous Ti3C2Tx MXene film shows high specific capacitance of 304 F g 1 at the scan rate of 10 mV s 1 and the excellent rate performance with the capacitance retention of 79 at the scan rate of 1000 mV s 1. In addition, the assembled Fe-MXene-500 AC asymmetric supercapacitor exhibits an energy density of 18.4 Wh kg 1 at a power density of 749.9 W kg 1.	{"MXene nanosheets","Ion transport","Three-dimensional structure","Excellent rate performance"}
688	Synthesis and electrochemical performance of 2D molybdenum carbide (MXene) for supercapacitor applications	Saira Anwar, Muhammad Rafique, Muneeb Irshad, M. Isa Khan, Syed Sajid Ali Gillani, Muhammad Shakil, Muhammad Asif Nawaz, Sarmad Masood Shaheen, Mohammed A. Assiri	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2024.145508	https://www.sciencedirect.com/science/article/pii/S0013468624017444	0013-4686	In the field of supercapacitors, carbide MXenes have recently received significant attention as pseudocapacitive electrode materials due to their unique multilayered structure, high metallic conductivity, pseudocapacitive charge storage mechanism and tunable surface terminations. Herein, synthesis and electrochemical performance of 2D molybdenum carbide (Mo2C) MXene-based electrode is presented for supercapacitor applications. Mo2C MXene was synthesized by using simple solid-state thermal reduction technique. The crystalline structure, surface morphologies, specific capacitance, electronic conductivity and reaction kinetics of as-synthesized Mo2C MXene were examined using XRD (X-ray diffraction) analysis, FESEM (field emission scanning electron microscopy), CV (cyclic voltammetry) and EIS (electrochemical impedance spectroscopy) measurements, respectively. The hexagonal phase (with P63 mmc symmetry) of Mo2C MXene was confirmed by XRD analysis. The 2D multilayered structure was displayed by FESEM results. The cyclic voltammograms revealed an efficient electrochemical performance of 2D Mo2C MXene. Due to its high current density, large surface area and abundance of redox acive sites, MXene-based electrode displayed high specific capacitance of 916 F g at 5 mV s. Further, excellent electronic conductivity and minimum charge transfer resistance was observed by EIS plots. The significant electrochemical performance of Mo2C MXene-based electrode governs its implementation for developing highly efficient supercapacitors with high energy and power densities.	{"Energy storage",MXene,"Molybdenum carbide","Thermal reduction","Solid-state reaction","Aqueous electrolyte",Supercapacitor}
689	Construction of Cu2O NiCo-LDH MXene with mulberry-layered cubic frameworks for enhancing the electrochemical performance of asymmetric supercapacitors	Min Lu, Yibo Wang, Xiaohui Xu, Yinglu Dong, Xuemei Chen, Xinyan Wang	Applied Surface Science	2025	https://doi.org/10.1016/j.apsusc.2025.163923	https://www.sciencedirect.com/science/article/pii/S0169433225016381	0169-4332	Supercapacitors, with remarkable advantages such as excellent power density, extremely short charging and discharging times, and an ultra-long cycle life, exhibit great application potential within the realm of energy storage. However, the bottleneck issue of their relatively low energy density has become a key factor restricting their in-depth application in a wider range of fields and further development, and effective solutions are urgently needed. In this paper, a sacrificial template method and an electrostatic self-assembly strategy were employed to controllably synthesize the mulberry-layered cubic composite electrode material Cu2O NiCo-LDH Mxene (Cu2O NCL M). In this material, a part of the residual Cu2O template exhibits certain redox activity and can undergo reversible redox reactions during the electrochemical process, thereby providing additional capacitance contributions. The cubic structure remaining after etching itself has a high degree of symmetry and stability, and the mulberry-like assembly method enables the nanosheets of the layered double hydroxide (LDH) to support each other. The introduction of a single layer of Mxene can not only promote the electron transfer between Cu2O and NiCo-LDH, but also the interfacial interaction among the three components is advantageous for improving the structural stability, enabling it to maintain good electrochemical performance during charge discharge processes. The specific capacitance of Cu2O NCL M is 1713F g 1 (at 1 A g 1). Cu2O NCL M exhibits remarkable rate performance, maintaining 82.3 of its capacitance as the current density increases to 10 A g 1. Moreover, after undergoing 5000 cycles, it demonstrates impressive long-term stability by retaining 80 of its initial specific capacitance. Interestingly, the energy density of the asymmetric supercapacitors (ASCs) Cu2O NCL M AC can be significantly increased to 49.5 Wh kg 1 (with a power density of 750 W kg 1) and 45.0 Wh kg 1 (with a power density of 700 W kg 1). Therefore, this work demonstrates a simple and successful synthetic approach for fabricating high-performance energy storage devices with special morphology.	{"Asymmetric supercapacitors","Electrochemical performance",Cu2O,NiCo-LDH,MXene}
690	Sandwich-type macroporous Ti3C2Tx MXene frameworks for supercapacitor electrode	Tiezhu Guo, Di Zhou, Lixia Pang, Moustafa Adel Darwish, Zhongqi Shi	Scripta Materialia	2022	https://doi.org/10.1016/j.scriptamat.2022.114590	https://www.sciencedirect.com/science/article/pii/S1359646222000902	1359-6462	Ti3C2Tx self-assembled film as a promising electrode material due to its high strength and ultra-high metal conductivity. However, it s challenging to solve the problem that the self-stacking phenomenon of nanosheets leads to the decrease of ion transport dynamics in the vertical direction. Here, we prepare sandwich-type macroporous Ti3C2Tx film, demonstrating appropriate mechanical properties as well as excellent capacitance and rate performance, compared with the compact MXene film by vacuum assisted filtration based on our previous work. The research provides perspectives for the development of MXenes-based supercapacitors with excellent electrochemical performance.	{Ti3C2Tx,"MXenes electrode",Supercapacitors,"Electrochemical performance"}
691	MXene tungsten-functionalized graphene oxide nanosheets as conductive platforms for FeNi-Co-doped MnO2 Nanocomposites: Toward high-performance supercapacitor electrodes	N.D. Raskar, D.V. Dake, V.A. Mane, R.B. Sonpir, V.D. Mote, M. Vasundhara, P.C. Zine, M.D. Shirsat, K.P. Gattu, B.N. Dole	Solid State Sciences	2025	https://doi.org/10.1016/j.solidstatesciences.2025.107974	https://www.sciencedirect.com/science/article/pii/S1293255825001529	1293-2558	The present manuscript has synthesized the innovative nanocomposite of tungsten decorated reduced graphene oxide (TGO) based FeNi codoped MnO2 (TGO-3 FeNi-MnO2) which has better supercapacitor performance than the tungsten carbide (TC) MXene-based nanocomposite sample (TC-3 FeNi-MnO2). The first motive of the manuscript is to manufacture lower-cost materials with better properties with higher stability. Nowadays, worldwide researchers are focusing on MXene materials and reporting the best smart material for multiple applications but the present manuscript has done an innovative study and found that the graphene-based materials have good properties with higher stability like MXene samples. The prepared nanocomposite samples have been characterized by XRD, FE-SEM, BET, XPS, Fluorescence spectroscopy, and cyclic voltammetry. X-ray diffraction (XRD) investigation demonstrated that mixed phases of tetragonal α-MnO2 and cubic α-Mn2O3 were observed. The nanocomposite of tungsten decorated reduced graphene oxide-based FeNi codoped MnO2 has a nanorod-like morphology which was better than all synthesized samples. The higher capacitance found for the tungsten decorated reduced graphene oxide-based Fe-Ni codoped MnO2 sample is 883 F g 1. The impact of the surface area (317.42 m2 g), defects, and structural parameters on capacitance enhancement was studied in detail. The TGO-3 FeNi-MnO2 sample has higher surface defects which was attributed by XPS and fluorescence spectroscopy.	{"W decorated graphene oxide",Mxene,Supercapacitor,"FeNi codoping","Hydrothermal synthesis"}
692	Effectiveness of Nitrogen-Doping in MXene-Based Composites for Supercapacitor Electrodes	Ghobad Behzadi pour, Leila Fekri aval, Hamed Nazarpour-Fard	Results in Chemistry	2025	https://doi.org/10.1016/j.rechem.2024.101965	https://www.sciencedirect.com/science/article/pii/S2211715624006611	2211-7156	The MXenes present a candidate for use as electrode material in the development of supercapacitors due to the presence of numerous interlayer ions, lightweight characteristics, and fast charge discharge ability. Although MXenes have gained significant attention as an electrode material for supercapacitors, the inherent challenge posed by the stacking of layers due to interlayer van der Waals forces remains unresolved. The incorporation of nitrogen (N) into MXene materials and their composites represents a significant approach to improving their electrochemical properties. N-doped exhibits considerable potential for enhanced electrochemical performance, primarily by facilitating effective interaction between electrolyte ions and carbon-based materials. The N-doping has emerged as an effective modification technique to improve the electrochemical characteristics of MXenes. This review presents a comparative study of the performance enhancement of MXene-based supercapacitor electrodes and their composites through the N-doping technique. Results indicated by N-doping the specific capacitance (SC) of the MXene-based supercapacitors was increased. The SC improvement can be attributed to the synergistic interaction of optimum N levels, augmented interlayer spacing, and improved surface redox activity, facilitating rapid ion intercalation and electron transfer. Levels of doping have been reviewed by various techniques such as photochemical N-doping, ammonium decomposition, thermal treatment, and N sources.	{MXene,Nitrogen-doping,"Composite materials",Supercapacitor,"Specific capacitance"}
693	High-performance fractal microsupercapacitors based on Ti3C2Tx MXene for kHz alternating current line-filtering applications	Dong Wang, Lei Qiao, Maoyang Xia, Jingjing Huang, Chi Zhang, Jing Ning, Xin Feng, Jincheng Zhang, Yue Hao	Chemical Engineering Journal	2023	https://doi.org/10.1016/j.cej.2023.146567	https://www.sciencedirect.com/science/article/pii/S1385894723052981	1385-8947	Microsupercapacitors (MSCs) are attracting attention as vital filter capacitors for microscale power conversion in alternating current (AC) line-filtering circuits due to their rapid frequency response characteristics. This study demonstrates the wafer-scale fabrication of Ti3C2Tx MXene-based MSCs with a high-potential device structure incorporating fractal microelectrodes. The experimental and simulation results show that the new structure enables increased ion-transport rates through increased absorption sites and a strong electric field, resulting in improved energy storage and frequency response performance. Therefore, by optimizing the size of the microelectrodes, the fractal MSCs (FMSCs) achieve a high specific capacitance of 615.3 μF cm 2 at 1 V s 1 and their highest frequency characteristic (f0) can reach kHz. Notably, the FMSCs exhibit excellent filtering performance in AC line-filtering circuits by successfully filtering different AC waveforms at a high frequency of 20 kHz into direct current.	{Microsupercapacitors,"Ti3C2Tx MXene","Fractal microelectrodes",Photolithography,"Alternating current line-filtering","Energy storage"}
694	Multilayered MXene electrodes in deep eutectic solvent ionic liquid electrolyte for supercapacitor applications	Derya Kapusuz Yavuz, Abdulcabbar Yavuz	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.179442	https://www.sciencedirect.com/science/article/pii/S092583882501000X	0925-8388	Numerous studies have shown that two-dimensional titanium carbide (Ti3C2Tx), a MXene family member, has promising electrochemical characteristics for energy storage. Ti3C2Tx, made by selective etching of A layers in MAX phases, is suitable to various applications owing to its high surface area, hydrophilic surfaces, variable interlayer spacing, and strong electrical conductivity. Its supercapacitor performance has received attention because it has the potential to bridge high-power capacitors with high-energy batteries. This work compares the potential window and capacitance performance of multilayered (ml-) Ti3C2Tx in non-aqueous ionic liquid electrolyte (Ethaline) to alkaline (KOH) and neutral (Na2SO4) electrolytes. LiF + HCl etching method was used to produce ml-Ti3C2Tx, which was tested in three potential windows: positive (0 to +0.6 V), negative (0 to 1.2 V), and combined positive-negative (+0.5 to 1.2 V). The areal capacitance of ml-Ti3C2Tx in Ethaline was determined as 40 mF cm2 within a narrow potential window (0.6 V) and increased to 356 mF cm2 within a wider potential window (1.7 V) at a scan rate of 5 mV s. Aqueous KOH and Na2SO4 electrolytes were unsuitable for MXene based energy storage with 1.7 V potential window due to degradation. SEM-EDS, XRD, TEM, FTIR and CV indicated effective synthesis, functionalization, and electrochemical activity of ml-Ti3C2Tx. Surface modifications, such as O-H and C-O vibrational bands, demonstrate the importance of electrolyte interactions in improving performance. It was shown that ionic liquid electrolytes like Ethaline can improve energy storage. This study advances high-performance supercapacitors by widening the potential window and enhancing charge storage processes, meeting the growing demand for efficient and sustainable energy.	{Supercapacitor,"Potential window","Ionic liquid",MXene}
700	Construction of proton channels in POMCPs MXene electrodes for flexible all-solid-state symmetrical supercapacitors	Xiaoyi Li, Yifu Wu, Tingting Chen, Qian wang, Cuiwen Lu, Hongru Hao, Bo Wei, Haolin wang, Chengbao Yao, Feng Zhang, Haijun Pang, Guangning Wang	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.164816	https://www.sciencedirect.com/science/article/pii/S1385894725056529	1385-8947	Flexible all-solid-state energy storage devices that can meet the needs of portable and wearable electronics are very promising owing to their high safety and high energy density. Here, we first report a novel flexible all-solid-state symmetric supercapacitor (FSS) based on a polyoxometalate-based coordination polymer (POMCPs) Ti3C2Tx composite film. Its key breakthrough lies in overcoming the limitations of traditional materials through an electrode design featuring customizable proton channels. By finely adjusting the arrangement of water molecules through structural design, we prepared a novel POMCP, Ni(itmb)4[H2SiW12O40] 5H2O (1), with water-assisted proton channels, thereby improving the ionic conduction efficiency. The ingenious structural design effectively facilitates charge transfer, endowing the POMCPs Ti3C2Tx composite with an ultrahigh proton conductivity of 0.16 S cm 1 at 70 C while achieving an exceptional specific capacitance of 892.3 F g 1 and maintaining the intrinsic flexibility of MXene materials. The surface wettability of 1 Ti3C2Tx showed that the film exhibits hydrophilic properties, as evidenced by 2 M H3PO4 contact angle of 83.4 . The assembled symmetric supercapacitor showed excellent electrochemical performance, maintaining 84.9 of its capacitance after 10,000 charge-discharge cycles and 90 specific capacitance when bent at 90 . In addition, the device successfully powered the red LED. These findings highlight the practical application potential of POMCPs Ti3C2Tx composites for high-performance, flexible portable energy storage systems.	{"Proton conduction","Flexible device","Symmetric supercapacitor",MXene,"Polyoxometalates (POMs)",Wettability}
701	Revealing the ionic storage mechanisms of Mo2VC2Tz (MXene) in multiple aqueous electrolytes for high-performance supercapacitors	Xiaodie Xuan, Yangyang Xie, Yi Tang, Jianghong Zhou, Zhao Bi, Junhui Zou, Yu-ang Lei, Jiahang Gao, Lu Li, Aibo Zhang, Chenhui Yang	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.165537	https://www.sciencedirect.com/science/article/pii/S1385894725063739	1385-8947	It is evident that 2D MXene nanomaterials have considerable potential in the domain of electrochemical energy storage. However, the majority of extant studies concentrate on monometallic MXene, and the structural evolution and energy storage mechanisms of bimetallic solid-solution MXene (e.g. Mo2VC2Tz) remain to be elucidated. In this work, flexible, self-supported Mo2VC2Tz films have been fabricated by in situ solid-solution sintering of Mo2VAlC2 and liquid phase etching of the Al layer. The as-prepared Mo2VC2Tz features a unique bimetallic solid-solution structure with expanded interlayer spacing (15.0 Å vs. 9.2 Å in precursor), oxygen-dominated surface termination groups, and enhanced electronic conductivity (258.4 S cm 1) owing to strong Mo-V d-orbital hybridization. The electrochemical properties in hybrid supercapacitors (HSCs) were systematically evaluated in acidic (H2SO4), neutral (Na2SO4, Li2SO4, ZnSO4, Al2(SO4)3, Zn(CF3SO3)2), and alkaline (KOH) electrolytes. The results demonstrate that the Mo2VC2Tz film electrode in 1M H2SO4 exhibits superior pseudocapacitance performance, achieving a gravimetric capacitance of 257.6 F g 1 at 0.1 A g 1, which is nearly four times higher than in neutral electrolytes (e.g., 65.8 F g 1 in 1M Li2SO4). Furthermore, the Mo2VC2Tz exhibited exceptional cycling stability in 1M H2SO4, retaining 95.71 of its initial capacity after 20,000 cycles. Density functional theory calculations revealed the evolution of the electron state distribution before and after V doping in Mo2VC2Tz. Additionally, the interfacial interaction mechanisms between V atoms and cations (H+, Li+, Na+, Zn2+, Al3+ and K+) were elucidated. Therefore, this study provides a theoretical basis for the design of bimetallic MXene in various electrolyte systems, and promotes the development of high-performance HSCs.	{"Bimetallic MXene",Solid-solution,Supercapacitors,"Ionic storage mechanisms","Density functional theory"}
695	MXene mastery: Transforming supercapacitors through solid-solution innovations	Yedluri Anil Kumar, Reddi Mohan Naidu Kalla, Tholkappiyan Ramachandran, Ahmed M. Fouda, H.H. Hegazy, Md Moniruzzaman, Jaewoong Lee	Journal of Industrial and Engineering Chemistry	2025	https://doi.org/10.1016/j.jiec.2024.11.049	https://www.sciencedirect.com/science/article/pii/S1226086X24007883	1226-086X	Exploring innovative materials for supercapacitors has been a focus to broaden energy storage alternatives. The distinctive properties and applications of solid-solution MXenes have garnered significant attention in this regard. This research delves into the application of solid-solution MXene materials in supercapacitor energy storage, examining aspects such as manufacturing, electrochemical behaviour, and structural characteristics. The article begins with an overview of the MXene family, highlighting its potential for energy storage, a highly sought-after quality. The solid-solution approach is particularly favoured for its ability to enhance MXenes electrochemical properties by introducing additional components. This study explores how etching, and intercalation impact the material s structure and energy storage capabilities. Detailed analyses of the crystallographic, surface chemical, and morphological properties of solid-solution MXenes are conducted. The study emphasizes the influence of these factors on the electrochemical performance of MXene supercapacitors, stressing the importance of tailored design. The research extensively investigates the durability, electrical storage capacity, and charge retention mechanisms of these materials. Understanding the effects of dopants and intercalants on charge storage dynamics could lead to improvements in MXene electrode energy storage. The paper reviews the current advancements, challenges, and the potential of solid-solution MXenes in supercapacitors. With a careful examination of existing research and strategic selection of constituents, solid-solution MXene materials could play a crucial role in future energy storage systems, providing a valuable tool for engineers and scientists exploring renewable energy storage technologies.	{MXene,"Two-dimensional materials","Solid solution",Electrocatalysis,Supercapacitor,"Energy storage",Nanocomposites}
696	Functional integrated electromagnetic interference shielding in flexible micro-supercapacitors by cation-intercalation typed Ti3C2Tx MXene	Xin Feng, Jing Ning, Boyu Wang, Haibin Guo, Maoyang Xia, Dong Wang, Jincheng Zhang, Zhong-Shuai Wu, Yue Hao	Nano Energy	2020	https://doi.org/10.1016/j.nanoen.2020.104741	https://www.sciencedirect.com/science/article/pii/S2211285520302986	2211-2855	Multifunctional and flexible micro-supercapacitors (MSCs) have attractive prospects in integrated micro electronic systems fields owing to its high power density, fast charge discharge rates and small volume feature. Here, a flexible MSC functional electromagnetic interference (EMI) shielding is designed based on Mn ion-intercalated Ti3C2Tx MXene, presenting a high areal capacitance of 87 mF cm 2 at 2 mV s 1, remarkable energy density of 11.8 mWh cm 3 and outstanding shielding effectiveness of 44 dB. By density functional theory (DFT) calculation, the interaction between Mn ions and surface terminal (-F, O, and OH) of Ti3C2Tx is emphatically discussed, finding that the intercalated Mn ions are inclined to be bonding with O-contained groups with the orbital hybridization of Mn 3d and O 2p. It is intriguing to provide enhanced electrochemical performance in energy storage and additive interlayer EM waves absorption in EMI shielding. The present work can offer new insights about underlying mechanism of cation intercalation in Ti3C2Tx MXene and multiple functional devices application in integrated micro electronics systems field.	{"Ti3C2Tx MXene","Cation intercalation","Density functional theory calculation",Micro-supercapacitors,"Electromagnetic interference shielding"}
697	Insights into the synergistic effect of V3S4 decorated Ti3C2 MXene as an electrode for asymmetric supercapacitor	Sandra Mathew, Kalathiparambil Rajendra Pai Sunajadevi, Arun Varghese, Dephan Pinheiro, B. Saravanakumar	Journal of Physics and Chemistry of Solids	2025	https://doi.org/10.1016/j.jpcs.2025.112958	https://www.sciencedirect.com/science/article/pii/S002236972500410X	0022-3697	As the globe moves toward sustainable energy options, effectively storing and managing energy becomes increasingly crucial. Advanced energy storage technologies can bridge the gap between energy generation and consumption, ensuring a reliable and stable supply even when renewable sources are intermittent. In this context, the rise of two-dimensional layered Ti3C2 MXene as a promising electrode for supercapacitors is particularly noteworthy, owing to its unique physical, chemical, and electrocatalytic attributes. Despite its potential, the immediate collapse and aggregation of MXene layers pose significant obstacles to their widespread usage in energy storage applications. This study explores advanced energy storage technologies using V3S4 coupled Ti3C2 MXene as electrodes in asymmetric supercapacitors. By combining the unique properties of V3S4 and Ti3C2 MXene, new avenues for improving the performance of supercapacitors are being unlocked. The experimental results indicate that the Ti3C2 V3S4 electrode exhibits an enhanced specific capacitance (Csp) of 1323.7 Fg-1 at a current density of 1 Ag-1, with an outstanding capacitance retention of 90.5 after 2000 cycles. An assembled asymmetric supercapacitor, Ti3C2 V3S4 activated carbon shows superior energy storage efficiency, achieving a Csp of 258.4 Fg-1 at 2 Ag-1. The device exhibits a high energy density of 60.6 Whkg 1 at a power density of 649.2 Wkg-1, while holding onto a capacitance retention rate of 91.1 over 10,000 cycles.	{"Ti3C2 MXene",V3S4,"Asymmetric supercapacitor",Electrocatalyst,"Energy storage"}
698	Performance of asymmetric hybrid supercapacitor device based on antimony-titanium carbide MXene composite	Vediyappan Thirumal, Planisamy Rajkumar, Bathula Babu, Jin-Ho Kim, Kisoo Yoo	Journal of Alloys and Compounds	2024	https://doi.org/10.1016/j.jallcom.2024.173598	https://www.sciencedirect.com/science/article/pii/S0925838824001841	0925-8388	We present a successful synthesis of a composite material comprising antimony (Sb) and MXene (MX), demonstrating its potential as a high-performance material for future energy storage devices. A facile thermal annealing method is employed to produce Sb MX hybrid materials, exhibiting enhanced electrochemical performance in asymmetric devices for electrical energy storage. Detailed materials characterization, particularly through field emission transmission electron microscopy (FE-TEM), reveals de-laminated two-dimensional layers of MXene decorated with ball-milled antimony nanoparticles. Electrochemical characterizations confirm the optimal electrochemical window range (0 0.6 V vs. Ag AgCl) in a three-electrode system. In the two-electrode system, configured as an aqueous asymmetric supercapacitor in pouch cell form, the Sb MX AC device outperforms Sb-ball mill and MXene AC devices, showcasing maximum specific capacitances of 184.72 F g, 65.10 F g, and 36.61 F g, respectively, at a fixed current density of 1 A g within the voltage range of 0.00 - 1.44 V. The Sb MX AC device exhibits superior cyclic voltammetry electrochemical behavior, charge-discharge curves, pseudo-capacitance energy storage performance, and exceptional capacity retention (53.10 ) over 10,000 cycles. This remarkable stability positions it as a promising candidate for future supercapacitor devices, highlighting its potential for long-lasting and efficient energy storage applications.	{Antimony,MXene,Composite,"Asymmetric device",Supercapacitor}
699	Optimizing ZnSe microspheres through 2D MXene for asymmetric pseudocapacitive supercapacitors and efficient hydrogen production via water splitting	Inaam Ullah, Ayesha Irfan, Mai Li, Samira Saddique, Tiantian Yang, Hanxue Zhao, Nimra Irshad, Kaishuai Yang, Chunrui Wang, Paul K. Chu	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237046	https://www.sciencedirect.com/science/article/pii/S0378775325008821	0378-7753	In response to the increasing demand for sustainable energy, recent efforts have focused on developing novel composites with improved crystalline structures, chemical stability, and conductivity for electrochemical applications. Self-assembled zinc selenide (ZnSe) microspheres are synthesized by a simple hydrothermal process, and their electrochemical applications as a positive electrode electrocatalyst in asymmetric pseudocapacitive supercapacitor (APSC) and water splitting are investigated. ZnSe is integrated into the two-dimensional (2D) Ti3C2Tx MXene nanosheets that serve as a physical barrier to mitigate agglomeration, prevent side reactions of Zn, provide ZnSe with more sites and a steady Zn2+ supply, ultimately enhancing the electrochemical performance. Composite electrode demonstrates superior specific capacitance of 1673.8 F g 1 at 1 A g 1, remarkable cyclic stability (98.81 capacity retention over 10,000 cycles), and excellent pseudocapacitive performance of 88 at 60 mV s 1. Density functional theory (DFT) simulations displayed highest adsorption energy for ZnSe Ti3C2Tx, showcasing stable structure and strong electron interaction. To demonstrate the commercial viability, active carbon (AC) is employed as the cathode to fabricate the AC ZnSe Ti3C2Tx-APSC device. In the water splitting assessment, ZnSe Ti3C2Tx shows the lowest Tafel slopes ( 51.3 mV dec 1 for oxygen evolution reaction (OER) and 36.9 mV dec 1 for hydrogen evolution reaction (HER)). This novel approach significantly advances the overall performance of APSC and water-splitting.	{"Electrochemical properties","Pseudocapacitive supercapacitor","Ti3C2Tx/MXene nanosheets","Composite electrode","Density-function theory (DFT)","Water splitting"}
702	Electromagnetic interference shielding, mechanical, and flame retardant behaviors of Ti3C2Tx-MXene glass fabric epoxy hybrid composites	Ayten Nur Yuksel Yilmaz, Ayse Celik Bedeloglu, Doruk Erdem Yunus	Journal of Alloys and Compounds	2024	https://doi.org/10.1016/j.jallcom.2024.176877	https://www.sciencedirect.com/science/article/pii/S0925838824034649	0925-8388	This study investigates the manufacturability and electromagnetic shielding effectiveness (EMI-SE) of Ti3C2Tx MXene-coated glass fabric laminated composites for aerospace applications. MXene-coated fabrics were produced using a dip-coating method. The effects of varying dipping counts (5 and 10) and different configurations of fabric arrangements on the EMI-SE of the composites in the X-band range (8.2 12.4 GHz) were investigated. Glass fabrics with 5 and 10 dips showed average surface resistances of 38.56 Ω sq and 23.17 Ω sq, respectively. In both the 5- and 10-dip composite sets, the total EMI-SE increased with the number of MXene-coated glass fabric layers in the composite. The 5MXC5 and 10MXC5 specimens, with conductive fabric in all layers, had average total shielding effectiveness (SET) of 18.75 dB and 23.21 dB, respectively. These values are 147.05 and 205.80 higher than the neat glass fiber-epoxy composite (C1). Flammability, bending, ILSS, and hardness tests were conducted on these composites. Increasing the MXene content reduced the burning rate, with 10MXC5 exhibiting a 26.31 lower burning rate compared to C1. However, higher MXene content slightly decreased bending and ILSS values. Optical microscope examination of the fracture surfaces revealed that this decrease was due to delamination damage.	{Ti3C2Tx-MXene,"Glass fabric","Polymer-matrix composites (PMCs)","EMI Shielding","Mechanical properties"}
703	MXene (Ti3C2Tx) anodes for asymmetric supercapacitors with high active mass loading	Xuelin Li, Jianfeng Zhu, Wenyu Liang, Igor Zhitomirsky	Materials Chemistry and Physics	2021	https://doi.org/10.1016/j.matchemphys.2021.124748	https://www.sciencedirect.com/science/article/pii/S0254058421005319	0254-0584	MXene (Ti3C2Tx) is an emerging material choice for advanced energy storage. However, the relatively low areal capacitance is a bottleneck in developing asymmetric supercapacitors with enhanced energy-power characteristics in large voltage windows. A simple and straightforward approach is proposed to design and fabricate Ti3C2Tx-multiwalled carbon nanotube (Ti3C2Tx-CNT) composite electrodes. Polymethylmethacrylate (PMMA) is used as a binder for electrodes with 40 mg cm 2 high active mass loadings (AML); meanwhile, both multilayered Ti3C2Tx and CNT are efficiently dispersed in PMMA solution. The fabricated Ti3C2Tx-CNT electrodes with different CNT contents are tested in a 1.1 -0.3 V negative potential window and analyzed by different electrochemical techniques. The optimization of Ti3C2Tx-CNT-PMMA composition facilitates the design of anodes with capacitance of 2.26 F cm 2 in Na2SO4 electrolyte, which is essentially higher than literature results for Ti3C2Tx. The ability to obtain high capacitance in the Na2SO4 electrolyte is a crucial result, which facilitates the fabrication of asymmetric aqueous devices operating at 1.6 V. The Ti3C2Tx-CNT anode is combined with a MnO2-CNT cathode in an asymmetric cell, which shows a 1.24 F cm 2 capacitance at 3 mA cm 2.	{Electrode,"Carbon nanotube",MXene,Polymethylmethacrylate,"Manganese dioxide",Supercapacitor}
704	Nickel-infused cobalt ferrite MXene nanocomposites: Structural insights and electrochemical properties for high performance supercapacitors	W. Trinisha Infancy, T. Jaqulin Jenila, R. Rathikha, S. Maruthasalamoorthy, Belina Xavier, R. Navamathavan, Manikandan Ayyar, V. Mohanavel, M. Santhamoorthy, S. Santhoshkumar, Saravanan Rajendran	Inorganic Chemistry Communications	2025	https://doi.org/10.1016/j.inoche.2025.115156	https://www.sciencedirect.com/science/article/pii/S1387700325012730	1387-7003	In view of the unique magnetic characteristics of the ferrites, inverse spinel cobalt ferrite MXene nanocomposites (Co1-xNixFe2O4 MXene NCs) have garnered significant attention. These vital characteristics make Co1-xNixFe2O4 MXene NCs an ideal material for supercapacitor application. To synthesize Co1-xNixFe2O4 MXene NCs, a simple and cost-effective low-temperature co-precipitation approach was used, and samples were synthesized at different nickel concentrations (x = 0.03, 0.05, 0.07, 0.10) further integrated with MXene. Several characterization studies were used to investigate their crystallinity, morphology, and electrochemistry using different techniques such as X-ray powder diffraction (XRD), Fourier transform infrared spectrum (FT-IR), elemental composition analysis (X-ray photoelectron spectra - XPS), field emission scanning electron microscopy (FESEM), and transmission electron microscopy (TEM). Co1-xNixFe2O4 (x = 0.10) with MXene exhibited smaller crystallite size compared to other produced samples. The results showed that increase in nickel concentration decreases the crystallite size and lattice constant. The FT-IR spectra showed two strong absorption bands near 560 cm 1 (v1) and 400 cm 1 (ν2). SEM was used to corroborate the shape of the cubically spherical structure. The electrochemical behaviour for the produced samples were investigated using cyclic voltammetry (CV) with a electrolyte solution of 1 M KOH. The voltage has been constrained to 0.0 volts to 0.5 volts, with potential scan speeds ranging 5, 10, 20, 25, 50, and 75 mV s. A cyclic voltametric investigation found that the nickel doped cobalt ferrite with MXene incorporation enhanced the specific capacitance over Co1-xNixFe2O4 (x = 0.10). The specific capacitance of nickel-doped cobalt ferrite (x = 0.10) and (x = 0.10 MXene) samples were 361C g 1 and 367C g 1 respectively.	{Co1-xNixFe2O4,MXene,Co-precipitation,"Electrochemical properties","Specific capacitance"}
705	Ionic liquid induced gelation of Mo1.33C i-MXene for enhanced supercapacitor and Li-Ion storage performance	Zhaohui Chen, He Chong, Peng Hei, Hongyun Guo, Zhen Ma, Qiang Wang, Yu Song, Weibin Cui	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.163826	https://www.sciencedirect.com/science/article/pii/S1385894725046613	1385-8947	Two-dimensional Mo1.33C i-MXene is highly promising for electrochemical energy storage applications. We present a novel and facile approach to induce rapid gelation of Mo1.33C suspensions by ionic liquids (ILs), thereby significantly improving the supercapacitance and Li-ion storage performance of Mo1.33C i-MXene. The introduction of ILs weakens the electrostatic repulsion between nanosheets, triggering their interconnection and the formation of a three-dimensional network. Cation exchange with TBA+ cations in the interlayer alters the spacing, with larger cations leading to increased interlayer distances. Additionally, a notable increase in surfacial O functional groups has been observed and leads into the enhanced electrochemical energy storage. First-principles calculations indicate that the adsorption of Li-ion is significantly enhanced for the Mo1.33C i-MXene after treatment with ILs. Mo1.33C [Omim] + exhibits outstanding supercapacitor performance (552.6 F g 1 at 1 A g 1) and Li-ion storage capacity (1056 mAh g 1 at 50 mA g 1). This work presents a simple yet effective strategy for improving the electrochemical performance of Mo1.33C i-MXene, offering significant potential for practical applications in energy storage.	{"Mo1.33C i-MXene","Ionic liquids",Gelation,Supercapacitor,"Li-Ion Storage",DFT}
706	Synergistic MXene NiCo2S4 composite for high-performance flexible all-solid-state supercapacitors	Wei Li, Yuxin Li, Liaoyuan An, Zhuojun Zou, Ziyang Cong, Miaomiao Liu, Junyu Yang, Shangru Zhai, Qingda An, Kai Wang, Yao Tong	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.112398	https://www.sciencedirect.com/science/article/pii/S2352152X24019844	2352-152X	The scientific community has been captivated by flexible all-solid-state supercapacitors, which can meet the growing demand for portable electronic devices. In this study, a novel MXene NiCo2S4 (MNCS) composite material was synthesized via the hydrothermal method, with NiCo2S4 uniformly distributed on the surface or within the interlayers of MXene. The aim of this study was to enhance energy storage applications by developing a positive electrode material using a composite of MNCS. The architecture of the composite was carefully designed to prevent the stacking of MXene and the accumulation of NiCo2S4 nanoparticles, effectively suppressing these issues. It is worth noting that when utilized in a three-electrode system, the MNCS electrode demonstrates outstanding electrochemical performance. Specifically, at a current density of 1 A g 1, the electrode exhibits a specific capacity of 2675 F g 1 (equivalent to 1070 C g 1). Furthermore, even after undergoing 10,000 cycles of charging and discharging, the electrode retains an impressive 96.51 of its initial capacity. These results clearly indicate that the exceptional performance observed in this supercapacitor can be attributed to the synergistic collaboration between NiCo2S4 nanoparticles and MXene nanosheets which significantly enhances charge transfer during both charging and discharging processes. Moreover, we synthesized MNCS composites for use as positive electrodes in asymmetric flexible solid-state supercapacitors while employing activated carbon (AC) as negative electrodes. The resulting device exhibits high specific capacitance (256 F g 1) and impressive energy density (61 Wh kg 1) at a power density of 763 W kg 1 under a large voltage window (1.7 V) and current density (1 A g 1). Additionally, favorable cycling stability is observed with minimal capacitance variation even under various bending deformations. This study presents an innovative approach for developing composite materials with superior electrochemical properties and flexible devices with high energy density and power density.	{Ti3C2Tx-MXene,NiCo2S4,"All-solid-state flexible asymmetric supercapacitor devices","High energy density","Cycling stability"}
707	Tunable interlayer spacings Ti3C2Tx MXene Ni C for enhanced electromagnetic microwave absorption	Jingyu Song, Yongqian Shen, Guibin Zhang, Mingxuan Sun, Mengyao Han, Xueyan Du	Ceramics International	2024	https://doi.org/10.1016/j.ceramint.2024.07.459	https://www.sciencedirect.com/science/article/pii/S0272884224034035	0272-8842	While two-dimensional lamellar materials, specifically Ti3C2Tx MXenes, have shown great promise as wave-absorbing materials, the precise design of interlayer spacing poses a persistent challenge. In this study, Ti3C2Tx MXene layers with adjustable interlayer spacings were crafted using a straightforward molecular welding technique. Through the incorporation of Ni nanoparticles onto the Ti3C2Tx MXene layers using a combination of simple mechanical stirring and carbonation reactions, we successfully developed Ti3C2Tx MXene Ni C composites featuring a distinct lamellar structure. A uniform dispersion of Ni nanoparticles on the surface of the Ti3C2Tx MXene nanosheets was found with some of the nanoparticles intercalated into the layers. The Ti3C2Tx MXene Ni C composites exhibited a maximum reflection loss (RL) value of 42.3 dB at 12.3 GHz, accompanied by an impressive effective absorption bandwidth (EAB) of 5.6 GHz. This outstanding absorption performance could be attributed to various factors, including the dielectric loss of the Ti3C2Tx MXene lamellae, reflections and scattering of multiphase heterostructures, the magnetic loss of the Ni nanoparticles, and their synergistic attenuation. Furthermore, Ni nanoparticles with high electrical conductivity induced vortex currents under the alternating influence of electromagnetic waves (EMWs), resulting in a substantial depletion. This study introduces an innovative approach for synthesizing Ti3C2Tx MXene Ni C composites with tunable interlayer spacing, showing their potential for applications in microwave absorption (MA).	{"Ti3C2Tx MXene","Ni nanoparticles","Molecular welding","Tunable interlayer spacing","Microwave absorption"}
708	Enhanced electrochemical performance of Ti3C2Tx MXene film based supercapacitors in H2SO4 KI redox additive electrolyte	Jianjian Fu, Lei Li, Damin Lee, Je Moon Yun, Bong Ki Ryu, Kwang Ho Kim	Applied Surface Science	2020	https://doi.org/10.1016/j.apsusc.2019.144250	https://www.sciencedirect.com/science/article/pii/S0169433219330661	0169-4332	The introduction of redox additives into the electrolyte is considered to be an effective and facile approach to increase the specific capacitance of supercapacitors (SCs), as these additives facilitate redox reactions at the electrode electrolyte interfaces. Herein, a freestanding titanium carbide Ti3C2Tx (MXene) film was prepared through lithium fluoride hydrochloric acid (LiF HCl) etching method and subsequent vacuum filtration process. Subsequently, the electrochemical behavior of freestanding Ti3C2Tx film based symmetric SCs was improved via the addition of potassium iodide (KI), as a redox additive. The optimized Ti3C2Tx H2SO4 KI Ti3C2Tx redox additive electrolyte SCs (RAESs) assembled using Ti3C2Tx film as both positive and negative electrodes and H2SO4 KI as electrolyte show a volumetric capacitance of 601 F cm 3 and a volumetric energy density of 83.5 Wh L 1 at a power density of 1800 W L 1. These results suggest the importance of KI redox additive electrolyte in developing Ti3C2Tx based SCs.	{"MXene Ti3C2Tx film","KI redox additive electrolyte","High volumetric capacitance supercapacitor"}
709	Blade-coated Ti3C2Tx MXene films for pseudocapacitive energy storage and infrared stealth	Haoxiang Ma, Junqi Wang, Jingfeng Wang, Kun Shang, Yang Yang, Zhimin Fan	Diamond and Related Materials	2023	https://doi.org/10.1016/j.diamond.2022.109587	https://www.sciencedirect.com/science/article/pii/S0925963522007695	0925-9635	As a significant macrostructure of 2D MXene nanosheets, MXene (Ti3C2Tx) films made by vacuum-assisted filtration have considerable application prospects in the field of energy storage and infrared stealth. However, using vacuum-assisted filtration to assemble 2D MXene nanosheets into films is energy-intensive, inefficient, and thereby detrimental to the further development of MXene films. This work involves the first investigation into the electrochemical capacitive and infrared stealth behavior of MXene films prepared by the blade coating method. Blade-coated MXene films have a more regular and dense structure than traditional films prepared vacuum-assisted filtration. Thus, the electrical conductivity can reach as high as 8000 S cm 1 and the film exhibits good mechanical properties. When the blade-coated MXene film is used for supercapacitors, it has a specific capacitance of 347 F g 1 at 5 mV s 1, which is similar to that of the filtered MXene film. Additionally, the blade-coated MXene film demonstrates excellent infrared stealth performance, benefitting from its low mid-infrared emissivity. As a result, this form of MXene film assembly has broad application prospects in the field of military infrared camouflage. This work lays an important foundation for the further application of MXene films in practice.	{"MXene film","Blade coating","Electrical conductivity",Supercapacitors,"Infrared stealth"}
710	A review of how to improve Ti3C2Tx MXene stability	Wei Cao, Junli Nie, Ye Cao, Chengjie Gao, Mingsheng Wang, Weiwei Wang, Xiaoli Lu, Xiaohua Ma, Peng Zhong	Chemical Engineering Journal	2024	https://doi.org/10.1016/j.cej.2024.154097	https://www.sciencedirect.com/science/article/pii/S1385894724055864	1385-8947	Recently, the two-dimensional (2D) Ti3C2Tx (MXene) has attracted more and more attentions in energy, electronics, environment, biomedicine, etc., due to its unique features such as high conductivity, unusual layered structures, adjustable surface chemistry, and outstanding mechanical properties. However, the easy degradation of MXene in the presence of oxygen and moisture would induce the destruction of its microstructures and thus affect the physical and chemical properties of MXene, resulting in minimal practical applications of MXene-based functional devices. To this end, increasing efforts have been made in the MXene community to improve the environmental stability of MXene, from theories to experiments. It is important to timely summarize the recent progress on the stability of MXene. In this review, firstly, the structures and synthesis of MXenes are briefly introduced. Secondly, the mechanisms of Ti3C2Tx MXene degradation are analyzed from the angles of oxidation and hydrolysis. Thirdly, the effects of MXene degradation on its physical and chemical properties (i.e., electronic, optical, mechanical, and catalytic properties) are carefully discussed, which are often missed in other review articles on MXene stability. Lastly and most importantly, recently reported strategies for effectively inhibiting or slowing down the degradation of MXene are systematically summarized from four aspects of optimizing the MXene preparation process, performing post-treatments on MXene, promoting the storage conditions of MXene, and encapsulation of MXene. This timely review is helpful for preparations, storage, and applications of MXenes in widespread fields.	{MXene,Degradation,Stability,Ti3C2Tx,Post-treatment,"Storage condition"}
711	Ti3C2Tx MXene-based multifunctional wearable integrated sensor for simultaneous detection of humidity and pressure stimuli	Kai Wang, Jia-Nan Ma, Qian Zhao, Jia-Hui Zhang, Kang-Dong Zhang, Yu Zhang, Ling Wang, Sheng-Bo Sang	Sensors and Actuators B: Chemical	2025	https://doi.org/10.1016/j.snb.2025.138147	https://www.sciencedirect.com/science/article/pii/S0925400525009232	0925-4005	Although wearable electronic sensors have demonstrated promising applications in the fields of health monitoring, human-machine interaction, and soft robotics, they still face challenges in multifunctionality, integration, facile production and low cost using conventional materials. MXene, as an emerging two-dimensional material, integrated with favorable physical chemical properties is expected to solve these problems. Herein, we propose an integrated pressure-humidity sensor using Ti3C2Tx MXene as the sole sensitive material, which can precisely detect and distinguish pressure and humidity signals without cross-talk. Notably, the integrated pressure-humidity sensor exhibits not only a wide response range (8 125 kPa) with high sensitivity (1878.05 kPa 1) for pressure detection, but also wide response range (11.5 -98.1 RH), high sensitivity (0.67 ( RH) 1) and rapid response (response 3.46 s, recovery 1.50 s) for humidity detection. Based on the above outstanding dual-mode sensing performances, the sensor is applied in monitoring diverse physiological parameters of human such as respiratory patterns, sweat levels, and joint movements, revealing great potential for health monitoring and human-machine interaction.	{MXene,"Integrated multifunctional sensors","Pressure-humidity sensing",Microstructure,"Physiological signal monitoring"}
712	Advanced MOF MXene heterostructure with carbon aerogel to boosts the ions movement in asymmetric supercapacitors and hydrogen production	Haseebul Hassan, Khakemin Khan, Sidra Mumtaz, Arslan Ahmed Rafi, Ahmed Mahmoud Idris, Ahmed Althobaiti, Alsharef Mohammad	Journal of Power Sources	2024	https://doi.org/10.1016/j.jpowsour.2024.235486	https://www.sciencedirect.com/science/article/pii/S0378775324014381	0378-7753	Supercapacitors represent a promising avenue for advanced energy storage solutions. However, achieving devices that simultaneously possess all the ideal properties, such as high capacitance, fast charge-discharge rates, and excellent cyclability, remains a significant challenge. Herein, a facile approach for fabricating carbon aerogel-induced chromium metal-organic framework (CA MIL-101) integrated with titanium carbide MXene (CA MIL-101-(Cr) Ti3C2Tx) nanocomposites was demonstrated via hydrothermal method. The CA MIL-101-(Cr) Ti3C2Tx nanocomposites offer numerous divalent ion active sites and significantly improve charge transfer kinetics, attributed to their interconnected porous structure. This novel anode exhibits an outstanding specific capacity of 1632 Cg-1 with a PVDF binder-based electrode and a high rate of performance. Moreover, a full-cell supercapacitor was developed with carbon aerogel as the cathode and CA MIL-101 (Cr) Ti3C2Tx as the anode. With its hierarchical pore structure and functional groups, the CA MIL-101 (Cr) Ti3C2Tx anode achieves an energy density of 38 Wh-kg 1, a high-power density of 1280 W-kg 1, and robust anti-self-discharge behavior. The CA MIL-101 (Cr) Ti3C2Tx CA supercapattery uses both adsorption desorption processes and faradaic reactions for charge storage. The synthesized materials also perform exceptionally well electro-catalytically. This research advances high-performance CA MIL-101 (Cr) Ti3C2Tx electrodes, enhances understanding of supercapacitor charge storage, and paves the way for next-generation energy storage technologies.	{"Energy storage devices","Metal-organic framework","Carbon-based electrodes",Supercapacitors,Electrocatalysis}
713	The role of GO and MXenes in enhancement of electrochemical performance of ZIF 8 for supercapacitor applications	Sundus Naz, Syeda Anber Urooj Wasti, Fawad Ali, Shahbaz Afzal, Thamer Alomayri, Miletus O. Duru, Kingsley C. Iwu, Raphael M. Obodo	Chemistry of Inorganic Materials	2025	https://doi.org/10.1016/j.cinorg.2025.100094	https://www.sciencedirect.com/science/article/pii/S2949746925000084	2949-7469	In this study, a solid-state strategy was carried out using graphene oxide (GO) and MXenes (Ti3C2Tx) where x is a functional group such as Hydrogen (H), hydroxyl (OH), Chlorine (Cl), Fluorine (F), etc. to enhance the performance of the synthesized zeolitic imidazolate frameworks 8 (ZIF 8) for supercapacitor application. The major challenge facing ZIF hybrids-based materials is low conductivities and we incorporated GO and MXene to enhance the conductivity to deliver a better specific capacitance. The qualities of designed electrodes were examined using X-ray diffraction (XRD), scanning electron microscopy (SEM), energy dispersive spectroscopy (EDS), UV visible spectroscopy, and electrochemical analysis. The estimated specific capacitance of 1270 Fg-1 and 1150 Fg-1 from cyclic voltammetry (CV) at a scan rate of 10.0 mVs 1 for ZIF 8 GO and ZIF 8 MXene electrodes correspondingly. However, using galvanostatic charge-discharge (GCD) at 10.0 Ag-1 current density, various electrodes delivered maximum specific capacitance of 1428 Fg-1 and 1314 Fg-1 respectively at 1.0 Ag-1 current density from ZIF 8 GO and ZIF 8 MXene electrodes. The study s findings suggest that adding GO and MXene caused the manufactured electrodes electrochemical properties to improve indicating that GO enhancement is better than MXenes. Moreover, the capacitance retention of ZIF 8 GO and ZIF 8 MXene composites could be maintained at 92.82 and 88.25 after 10000 cycles at 1.0 Ag 1 current density.	{"ZIF 8",Supercapacitor,"Specific capacitances","Graphene oxide",MXenes}
714	Improved electrochemical performance of CoOx-NiO Ti3C2Tx MXene nanocomposites by atomic layer deposition towards high capacitance supercapacitors	Xiaobao Zhang, Baiyi Shao, Aoping Guo, Zhe Gao, Yong Qin, Ce Zhang, Fangming Cui, Xiaojing Yang	Journal of Alloys and Compounds	2021	https://doi.org/10.1016/j.jallcom.2020.158546	https://www.sciencedirect.com/science/article/pii/S0925838820349094	0925-8388	Co-Ni bimetallic oxides were successfully deposited on Ti3C2Tx MXene nanosheets by atomic layer deposition technology and used as pseudocapacitive materials for supercapacitors. The uniform distribution of metal oxide nanoparticles on MXene nanosheets endows the pseudocapacitive materials more active sites and the synergistic effect between CoOx and NiO greatly improves the electrochemical performance. Specifically, as the deposited cycle increased to 90, the sample showed the optimal electrochemical performance with specific capacitance up to 1960 F g 1 (1 A g 1), 20.3 times higher by than that of Ti3C2Tx MXene, excellent rate capability (87.3 capacitance retention, 1 18 A g 1) and 90.2 capacitance retention after 8000 cycles.	{"Ti3C2Tx MXene",CoOx-NiO,ALD,"Pseudo capacitance",Supercapacitor}
715	Pillaring effect of nanodiamonds and expanded voltage window of Ti3C2Tx supercapacitors in AlCl3 electrolyte	Murilo H.M. Facure, Kyle Matthews, Ruocun Wang, Robert W. Lord, Daniel S. Correa, Yury Gogotsi	Energy Storage Materials	2023	https://doi.org/10.1016/j.ensm.2023.102919	https://www.sciencedirect.com/science/article/pii/S2405829723002970	2405-8297	MXenes have demonstrated excellent performance as constituent materials for supercapacitor electrodes. One of the most outstanding achievements is the capacitance obtained with 2D Ti3C2Tx in H2SO4 electrolyte, which is related to the O OH titanium surface termination redox process. However, the narrow (under 1 V) potential window of highly acidic electrolytes is a limiting feature for many applications. In this scenario, materials and electrolytes that produce high capacitance and large potential windows are highly sought after. Herein, we used nanodiamonds (NDs) to pillar the Ti3C2Tx structure and obtain superior capacitive storage in AlCl3 electrolytes. The pillaring effect prevents the restacking of MXene layers, reducing diffusion limitations and resulting in a high-rate performance with a capacitance of 235 F g (561 F cm3). The use of 3 M AlCl3 provided protons that contributed to the capacitance obtained and allowed an expansion of the potential window to 1.2 V, due to the lowered activity of water in the electrolyte. The results reflect the need for a proper combination of electrode architecture and electrolyte formulation while providing a direction for the exploration of more efficient, safe, and inexpensive supercapacitor devices.	{MXene,Nanodiamond,"Aluminum-ion electrolyte",Supercapacitors,Pseudocapacitor,"Proton intercalation","Energy storage"}
716	High pseudocapacitive and self-supporting three-dimensional porous MXene integrated carbon nanotubes composite film featuring oxygen-rich for flexible supercapacitors	Ji Zhou, Xiaoran Gong, Jiahong Kang, Shuning Chen, Zhenqing Hu, Meng Nie, Litao Sun	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.236637	https://www.sciencedirect.com/science/article/pii/S0378775325004732	0378-7753	MXenes exhibit extensive application prospects in energy storage due to high conductivity, yet their restacking and confined active sites limit their electrochemical performance. Here, a synergistic strategy of electrode structure engineering and surface terminations modification is proposed to design self-supporting porous MXene carbon nanotubes (P-MXene CNT-KOH) composite film. The interaction between sacrifice templates and CNT propel 2D MXene nanosheets to spontaneously evolve into 3D nanostructure with interlayer nanopores and expanded interlayer spaces, which can help restrain self-stacking of MXene and promote ions electrons accessibility, meanwhile CNT significantly improve the conductivity. Moreover, the KOH assisted replacement of F by O terminations on the surface of MXene layers engenders affluent electroactive sites for redox reactions. As a result, the obtained P-MXene CNT-KOH film exhibits preeminent specific capacity (708.7 F g 1 at 1 A g 1, twice that of pure MXene), high rate performance (87.5 capacity retention after 20-times current increasing), and great cycling stability (93.2 85.5 capacity retention after 5000 10000 cycles). The constructed interdigital supercapacitor shows high energy and power density, and superior mechanical flexibility. This work provides a broad avenue for tailoring MXene-based electrodes for high-performance supercapacitors.	{MXene,Nanoporous,"Surface modification","Supercapacitor electrodes","High pseudocapacitance"}
717	S, N co-doped rGO fluorine-free Ti3C2Tx aerogels for high performance all-solid-state supercapacitors	Xiaolong Yang, Mingya Zhang, Chenhao Wang, Min Bi, Junlong Xie, Wuxin Bai, Ying Zhang, Shencheng Pan, Mingliang Liu, Xinchen Pan, Zhenjie Lu, Zhiwei Han, Yongsheng Fu	Journal of Energy Storage	2023	https://doi.org/10.1016/j.est.2023.108140	https://www.sciencedirect.com/science/article/pii/S2352152X23015372	2352-152X	The development of fluorine-free MXene based composites for electrochemical energy storage and conversion devices is considered to be a promising approach. Herein, we used Lewis acid Fe (III) to etch Ti3AlC2 successfully to prepare MXene with in-situ loaded Fe2O3 nanoparticles. The three-dimensional porous aerogels co-doped with S and N were synthesized by the redox self-assembly reaction of MXene and graphene oxide in the hydrothermal condition containing thiourea. XPS results show that S and N heteroatoms can enhance the hydrophilicity and pseudo-capacitance of the composites by changing the electronic structure of adjacent C atoms and forming S-C N-C bonds. The specific capacitance of the optimized Fe3+-Ti3C2Tx S,N-rGO-2 is 220.7 F g 1 at 1 A g 1, and the capacitance retention rate is above 80 after 5000 cycles at a current density of 6 A g 1. The all-solid-state symmetric supercapacitor with Fe3+-Ti3C2Tx S,N-rGO-2 as electrode materials, and PVA-KOH as electrolyte can work normally in extreme environments of 60 and 20 C, respectively. This work provides a viable route for the fluorine-free preparation of MXene and its electrochemical application.	{"Lewis acid","Fluorine-free preparation of MXene","S,N codoped three-dimensional aerogels","All-solid-state supercapacitor","Extreme environments"}
718	High-performance supercapacitors based on nonfunctionalized MXenes	Ibrahim W. Lisheshar, Sina Rouhi, Feridun Ay, Nihan Kosku Perkgöz	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2024.235894	https://www.sciencedirect.com/science/article/pii/S0378775324018469	0378-7753	MXenes are a group of two-dimensional materials that have attracted significant research interest worldwide due to their intriguing electrochemical characteristics for use in energy storage applications. However, the conductivity of MXenes and their performance as supercapacitor electrodes can be hindered by surface terminations. This study investigates the capability of non-functionalized MXenes, synthesized via chemical vapor deposition for use as supercapacitor electrodes, presenting a novel approach that explores the potential of these materials in energy storage applications. The synthesized MXenes are used to create supercapacitor electrodes, which are subjected to detailed analysis. The specific areal capacitance (SAC) of these electrodes (48.6 nm thick) is found to be 39.5 mFcm 2 at a scan rate of 2 mVs 1, equivalent to 928.4 Fg-1. Further investigation using galvanostatic charge-discharge (GCD) analysis reveals an initial specific gravimetric capacitance (SGC) of 442.6 Fg-1 at a current density of 0.5 Ag-1, which progressively decreases to 13.4 Fg-1 at 10 Ag-1. Remarkably, the MXene supercapacitors exhibit excellent stability over 10,000 charge-discharge cycles, retaining 85 of their initial capacitance. These findings contribute to our understanding of MXene-based energy storage devices and pave the way for practical applications in high-performance supercapacitors.	{"Pristine MXene",CVD,Supercapacitor,"Specific gravimetric capacitance"}
719	Recent progress in metal chalcogenide-MXene and MOF-derived composites for supercapacitors: synthesis, challenges, and future solutions	Avinash C. Mendhe, Swathi Lekshmi, Neha S. Barse, Iftikhar Hussain, Minjae Kim, Satish B. Jadhav, Haigun Lee	Progress in Materials Science	2026	https://doi.org/10.1016/j.pmatsci.2025.101558	https://www.sciencedirect.com/science/article/pii/S0079642525001367	0079-6425	Metal chalcogenide-based electrode materials have gained a substantial attention as high-performance electrode alternative for supercapacitors owing to their tunable redox characteristics, high electrical conductivity, and enrich electrochemical activity. Recent advancements in composite materials, especially the integration of metal chalcogenides with MXenes and metal organic framework (MOF)-derived structures have unlocked innovative paths for surpassing inherent challenges such as poor cycling stability, accumulation, and low surface area. This review article delivers an inclusive summary of the synthesis strategies employed for evolving these hybrid composites electrodes, including hydrothermal, chemical bath deposition, and in situ growth techniques. The synergistic integration of MXenes, recognized for their excellent electrical conductivity and mechanical strength, with metal chalcogenides improves electron transport and structural stability. Correspondingly, the MOF-derived porous frameworks begin with a high surface area and controlled structure, further enhancing capacitance and ion diffusion. Despite these developments some key challenges remain, such as structural degradation, complex synthesis processes, and meager long-term electrochemical stability. This review also focusses on emerging approaches to resolve these challenges, such as defect engineering, heteroatom doping, and surface functionalization. Conclusively, the future perspectives are anticipated for scalable fabrication, flexible device integration, and performance optimization, pointing toward the next generation of high-energy density supercapacitor systems.	{"Metal chalcogenides","MXene composites","MOFs-derived composites",Supercapacitors,"Surface engineering"}
720	MXene (Ti3C2Tx) supported CoS2 CuCo2S4 nanohybrid for highly stable asymmetric supercapacitor device	Shrabani De, Chandan Kumar Maity, Sourav Acharya, Sumanta Sahoo, Jae-Jin Shim, G.C. Nayak	Journal of Energy Storage	2022	https://doi.org/10.1016/j.est.2022.104617	https://www.sciencedirect.com/science/article/pii/S2352152X22006338	2352-152X	A novel, one-pot hydrothermal synthesis of Ti3C2Tx (MXene) CoS2 CuCo2S4 nanohybrid with multiple reactive equivalents has been demonstrated for designing of supercapacitor devices in both symmetric and asymmetric mode. Morphological study established successful coating with intercalation of sheet-like CoS2 and particle-like CuCo2S4 on Ti3C2Tx nanosheets. The ratio of MXene to CoS2 CuCo2S4 was varied to optimize the electrochemical efficiency. Three-electrode set up of electrochemical analysis revealed that the 5:1 ratio of MXene to CoS2 CuCo2S4, delivered the highest specific capacitance of 706.5 F g 1 at 1 A g 1 current density. The corresponding fabricated asymmetric device provided utmost specific capacitance (93.7 F g 1) and energy density (42.2 Wh kg 1) along with excellent cyclic life of 96 capacitance retention after 10,000 cycles. Additionally, the device was successful in glowing LEDs and operating a 2 V fan. This proposed MXene based hybrid nanocomposite electrode with supreme electrochemical energy storage efficiency and excellent cyclic life holds immense potential for future energy technologies.	{MXene,CoS2,CuCo2S4,Pseudocapacitor,"Asymmetric supercapacitor"}
721	High-capacity Zn-ion storage in NiMnHCF Ti3C2Tx MXene composite cathode boosted by Mn-containing electrolyte for aqueous Zn-ion hybrid capacitors	Kun Fang, Jingyuan Zhang, Jianing Yu, Yuting Hu, Jiawei Wang, Zhuo Wang, Bin Zhao	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.162824	https://www.sciencedirect.com/science/article/pii/S1385894725036502	1385-8947	Zinc-ion hybrid supercapacitors (Zn-ion HSCs), combining battery-type cathodes and capacitor-type anodes, present a promising solution for large-scale energy storage. Nonetheless, the rational design of cathode materials with high capacity and long cycle life remains a significant challenge. In this work, binder-free NiMn0.1-hexacyanoferrate MXene (NiMn0.1HCF MXene) composite electrodes, characterized by ultrasmall HCF nanoparticles, were fabricated via the self-assembly of Ti3C2Tx MXene (MX) and ultrathin layered double hydroxide (LDH) nanosheets, followed by in-situ LDH conversion and ultrasonic spraying onto on carbon cloth (CC). By leveraging the nanoscale NiMn0.1HCF, the seamless integration with conductive MX, and the electrolyte-driven conversion reaction of Zn4SO4 (OH)6 xH2O (ZSH) with Mn2+, the composite achieves a specific capacitance of 1548.7 F g 1 (387.1 mA h g 1) at 1 A g 1 in a 1 M ZnSO4 and 0.1 M MnSO4 electrolyte, with 77.82 capacity retention over 15,000 cycles at 5 A g 1. Moreover, when assembled into a Zn-ion HSC, the NiMn0.1HCF MX delivers an impressive energy density of 62.8 Wh kg 1 and a high power density of 10.1 kW kg 1 at 1.8 V, retaining 95.6 of its initial capacitance after 25,000 cycles at 1 A g 1. In-situ and ex-situ characterization reveal the reversible insertion extraction of H+ Zn2+ in the cathode and the reversible conversion between ZSH and ZnxMnO(OH)2 (ZMO), which jointly contribute to the exceptional capacity and decent cycling stability. This work lays a foundation for designing high-performance HCF cathode materials and advancing high-capacity aqueous Zn-ion HSCs.	{NiMnHCF,MXene,"Zn-ion storage","Hybrid supercapacitor","Conversion reaction"}
722	Sea urchin-like Fe2O3 anchored on Ti3C2Tx MXene for improving the electrochemical hydrogen storage performance of Co9S8 material	Yugang Su, Yuanlong E, Siqi Li, Hongsheng Jia, Jin Wang	Journal of Physics and Chemistry of Solids	2026	https://doi.org/10.1016/j.jpcs.2025.113118	https://www.sciencedirect.com/science/article/pii/S0022369725005700	0022-3697	Sea urchin-like Fe2O3 particles are prepared using hydrothermal method followed by annealing. The composite of Fe2O3 coupled with Ti3C2Tx MXene nanosheets (Fe2O3 Ti3C2) is synthesized by self-assembly route. The Co9S8 hydrogen storage material is manufactured by mechanical alloying. To improve performance, composites of Co9S8 mixed with Fe2O3 Ti3C2 are obtained via ball-milling. The electrochemical hydrogen storage and kinetics properties of these electrodes are studied in detail. Eventually, Co9S8 modified with Fe2O3 Ti3C2 composite demonstrates significantly enhanced discharge capacity of 628.7 mAh g compared with Fe2O3 or Ti3C2Tx solely modified Co9S8 and original Co9S8 electrodes. Notably, Co9S8 + Fe2O3 Ti3C2 electrode reveals improved HRD, corrosion resistance, and superior kinetic performance. The enhanced electrochemical activities and kinetics behaviors can be attributed to the synergistic interaction between Fe2O3 and Ti3C2. The integration of high conductivity, large specific surface area of Ti3C2Tx with high catalytic active of sea urchin-like Fe2O3 can offer sufficient active sites for hydrogen adsorption, facilitate more efficient hydrogen diffusion and charge transport throughout charge discharge cycles, thereby optimizing the electrochemical performance of Co9S8 electrode.	{Fe2O3,Ti3C2Tx,Co9S8,Electrochemistry,"Hydrogen storage"}
723	Flexible composite films constructed of MXene cellulose nanofibers natural fiber-based activated carbon fibers for high-performance flexible supercapacitors	Chaofan Song, YinYing Long, Maohua Wan, Yingchao Wang, Bin Lu, Zhengbai Cheng, Xiaofeng Lyu, Haibing Cao, Hongbin Liu, Xingye An	International Journal of Biological Macromolecules	2025	https://doi.org/10.1016/j.ijbiomac.2025.142838	https://www.sciencedirect.com/science/article/pii/S0141813025033902	0141-8130	Traditional activated carbon fibers (CF) based supercapacitors suffer from low mechanical strength, inherent brittleness that induces stress concentrations, and bulky architectures from binder conductive additive requirements. To overcome these limitations, cellulose nanofibers (CNF) are synergistically integrated with Ti₃C₂Tₓ MXene and CF, forming a mechanically reinforced composite film via hydrogen bonding and van der Waals interactions. The CNF CF network expands the interlayer spacing of MXene, which enhances the ion-accessible surface area and enables rapid ion transport. The resulting Ti₃C₂Tₓ CNF CF composite film demonstrates exceptional electrochemical performance, achieving a specific capacitance of 420.99 F g 1 at 0.5 A g 1, with 84.56 retention at 10 A g 1. As a self-supporting flexible electrode (0.49 mm thickness), it delivers an areal capacitance of 214 mF cm 2 at 0.3 mA cm 2 and an energy density of 14.5 μWh cm 2 at 30.2 μW cm 2. The hierarchical CNF CF network simultaneously suppresses MXene restacking through spatial confinement while optimizing mechanical flexibility and stress distribution via interfacial bonding. This assembly strategy enables scalable fabrication of ultrathin MXene-based supercapacitors suitable for flexible electronics and grid-scale storage systems.	{Ti3C2Tx,"Activated carbon fiber","Cellulose nanofibers"}
724	MXene Cu2-xSe heteroarchitectures with synergistic redox-active sites for advanced asymmetric supercapacitors	Xuan Wei, Linlin Li, Feng Chen, Wanzhong Feng, Hongyue Wu	Applied Surface Science	2025	https://doi.org/10.1016/j.apsusc.2025.164132	https://www.sciencedirect.com/science/article/pii/S0169433225018471	0169-4332	A novel MXene Cu2-xSe hybrid electrode has been successfully synthesized through a facile in situ selenization strategy. The two-dimensional layered architecture and abundant surface terminations of MXene provide favorable pathways for efficient ion diffusion and charge storage, while the incorporation of Cu2-xSe nanoparticles significantly enhances the composite s electroactive surface area and pseudocapacitive contributions. Systematic electrochemical characterization reveals that the MXene Cu2-xSe composite demonstrates a high specific capacitance of 384.0 F g 1 at 1 A g 1 in a three-electrode configuration. An asymmetric supercapacitor device was assembled using MXene Cu2-xSe as the positive electrode and activated carbon as the negative electrode, achieving a remarkable energy density of 71.1 Wh kg 1 at a power density of 800 W kg 1. Furthermore, the device exhibits outstanding cycling stability with 76.2 capacitance retention after 8,000 charge discharge cycles, demonstrating its potential for practical energy storage applications.	{Supercapacitor,MXene,Cu2-xSe,"Energy density","Composite material"}
725	Recyclable PVA starch Ti3C2Tx MXene nanocomposite films with superior mechanical and barrier properties	Ming Dong, Emiliano Bilotti, Han Zhang, Dimitrios G. Papageorgiou	International Journal of Biological Macromolecules	2025	https://doi.org/10.1016/j.ijbiomac.2025.139545	https://www.sciencedirect.com/science/article/pii/S0141813025000947	0141-8130	The fabrication of eco-friendly and high-performance composite materials has gained significant attention for multifunctional applications. Polyvinyl alcohol (PVA) starch composite films containing varying amounts of Ti3C2Tx MXene (2.5 10 wt ) were produced using a simple casting method. The impact of MXene nanoplatelets on the films chemical structure and physical properties were thoroughly analysed. It was revealed that MXene formed hydrogen bonding with the polymer matrix and tended to align in the plane of the films. The mechanical properties of the PVA starch blend were significantly improved with increasing MXene loading. With 10 wt MXene, the Young s modulus (YM) and tensile strength (TS) increased by 669 (from 255.7 to 1965.3 MPa) and 292 (from 9.2 to 36.1 MPa), respectively. Additionally, the presence of MXene greatly improved the films water and oxygen barrier properties, reducing water vapor permeability (WVP) by 91 and oxygen permeability (OP) by 79 . These improvements are attributed to the homogeneous dispersion of MXene within the blend and the interfacial interactions between the components. Furthermore, the PVA starch MXene composite films exhibited excellent recyclability, maintaining their mechanical and barrier properties even after recycling, demonstrating their potential for repeated use without performance loss. Overall, the developed composite films present a promising sustainable solution for applications in materials requiring advanced mechanical and barrier performance.	{"MXene (Ti3C2Tx)","Polyvinyl alcohol",Starch,"Mechanical properties","Barrier films"}
726	Synthesis of fluorine-free Ti3C2Tx MXenes via acidic activation for enhanced electrochemical applications	Ubaid Khan, Atifa Irshad, Ling Bing Kong, Wenxiu Que	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2024.177097	https://www.sciencedirect.com/science/article/pii/S0925838824036843	0925-8388	MXenes are a class of two-dimensional materials composed of carbides and nitrides, which possess tunable properties and thus suitable for electrochemical applications. The etching method of MXene plays an important role in defining the electrochemical properties. Here, a novel hydrothermal acidic etching process was introduced to synthesize fluorine free MXenes by varying etching time and temperature. As a result, highly effective fluorine free Ti3C2Tx MXenes with enhanced electrochemical properties were obtained. It is also noted that the synthesized Ti3C2Tx MXenes exhibit distinct charge-discharge performance and impressive battery-like characteristics when tested in a 1 M H2SO4 electrolyte. Especially, the 6D-160 C sample shows relatively superior gravimetric capacity of 450 C g 1 with a retention rate of 114 after 8000 cycles, compared to the HF-etched sample (only 75 lower capacitance). This novel approach demonstrates a significant improvement in the electrochemical performance of Ti3C2Tx MXenes and suggests a highly effective technique for surface modification of MXenes.	{"Fluorine-free Ti3C2Tx MXene","Acidic etching","Hydrothermal process",HCl,Supercapacitor}
727	Assembly of flexible Ti3C2Tx fiber with promoted ionic transport by constructing hierarchical flakes size for high-performance fiber shaped supercapacitors	Yang Zhang, Xiangxiang Pi, Jian Xu, Kangxin Qi, Shenao Zhang, Yusen Wang, Qingqing Tang, Diwei Gu, Bin Sun, Xianan Qin, Wangyang Lu	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.178613	https://www.sciencedirect.com/science/article/pii/S0925838825001719	0925-8388	With the booming development of wearable system, the flexible fiber-shaped supercapacitor (FSC) has received sufficient attention. However, impeding by the sinuous electrolyte diffusion pathway and limited surface area, the fiber electrode usually causes low energy density and mediocre rate capability. Here, small-sized Ti3C2Tx MXene (s-M) intercalated Ti3C2Tx flakes (s-M M) fiber is constructed by microfluidic spinning method. Encouragingly, the existence of s-M flakes can prevent the layer restacking of adjacent Ti3C2Tx sheets significantly, constructing porous architectures for fast ion diffusion and exposing abundant active sites for ion adsorption. Moreover, due to homogeneous crosslink via hydrogen bond, s-M M fiber appears stable interface coupling, which imparts fast electron migration and excellent deformation endurance. As a result, the s-M M fiber displays huge mass-capacitance (271.35 F g 1 at 1 A g 1), good rate performance (197.92 F g 1 at 10 A g 1) and outstanding long-term cycling properties (80.7 capacitance retention after 10000 cycling). More importantly, matching with the graphene fiber, the asymmetrical FSC shows large capacitance of 62.98 F g 1 at 0.1 A g 1, high energy density and favorable deformation ability. This work raises an effective strategy for the design of high-performance FSC and the application in wearable system.	{Ti3C2Tx,Supercapacitor,"Hierarchical structure",Flexible,"Fiber shaped device"}
728	Influence of natural organic matter on ecotoxicity, ingestion and depuration of MXenes (Ti3C2Tx) in D. magna and R. subcapitata	M. Ahl, M.B. Nielsen, A. Baun, L.M. Skjolding	NanoImpact	2025	https://doi.org/10.1016/j.impact.2025.100579	https://www.sciencedirect.com/science/article/pii/S2452074825000394	2452-0748	The two-dimensional inorganic advanced materials MXenes (Mn+1XnTx) have been gaining traction due to their unique characteristics making them chemically and mechanically stable with diverse applications for, e.g., energy storage, water purification, and photocatalysis. Although the properties and potential applications of MXenes have been widely researched, a need for more information regarding the potential ecotoxicological effects of the materials remains due to their possible widespread use. The purpose of this study was to assess the short-term toxicity of Ti3C2Tx-MXenes towards the freshwater algae (Raphidocelis subcapitata) and the crustacean (Daphnia magna), as well as their bioaccumulation behaviour in ingestion and depuration studies with D. magna. The ecotoxicity of MXenes was investigated in different test setups, including a 24 h aging experiment of MXenes following exposure to the water accommodated fraction with and without the presence of the chemical pentachlorophenol (PCP) and natural organic matter (NOM). Generally, it was found that MXenes (aged and not aged) did not affect the mobility of D. magna in the concentration range tested (highest test concentration: 100 mg L) while algal growth was affected (EC50-values of 81 mg L and 41 mg L, with and without aging, respectively). Furthermore, the results indicated that the presence of MXenes did not affect the toxicity of PCP towards algae. Contrastingly, daphnia tests of PCP solutions with MXenes present showed lower toxicity than solutions without MXenes, suggesting a decrease in bioavailability of PCP in the presence of MXenes. Addition of NOM to algal tests resulted in decreased toxicity of MXenes. Additionally, the ingestion and depuration tests with D. magna indicated that the presence of NOM lowered the organisms ingestion of MXenes. In the presence of a food source (algae) D. magna depurated the residual MXenes faster than in experiments where no food was present.	{"Advanced materials",Uptake,Feeding,PCP,"Mixture toxicity"}
729	Improving the electrochemical properties of MXene through intercalation of WC and TiC nanoparticles for supercapacitors application	Sayed Zafar Abbas, Dhanasekaran Vikraman, Zulfqar Ali Sheikh, Shahzaib Ali, Iftikhar Hussain, Jeung Choon Goak, Hyun-Seok Kim, Doyoung Byun, Jongwan Jung, Sajjad Hussain, Naesung Lee	Journal of Colloid and Interface Science	2025	https://doi.org/10.1016/j.jcis.2025.137845	https://www.sciencedirect.com/science/article/pii/S0021979725012366	0021-9797	Increasing environmental concerns and the global energy crisis have driven the search for clean and renewable energy sources. Electrochemical supercapacitors have emerged as efficient, cost-effective, and sustainable energy-storage solutions because of their extended cycle life and safety. MXenes, a class of two-dimensional metal carbides, show great promise as supercapacitor electrodes due to their excellent conductivity, hydrophilicity, and high theoretical capacity. However, challenges such as restacking, aggregation, and surface termination impede their electrochemical performance. TiC and WC nanoparticles were intercalated into MXene sheets to form TiC MXene and WC MXene hybrid composites to address these issues. This approach mitigates interlayer restacking, increases the number of active sites, and enhances structural stability. The TiC MXene and WC MXene composites achieved specific capacitance of 481 and 478 F g 1 at a current of 1 A g 1. They demonstrated excellent cycling stability, retaining 95.5 and 96.3 of their initial capacitance after 5,000 cycles at 10 A g 1, respectively. Furthermore, the WC MXene AC ASC device exhibited an energy density of 53 Wh kg 1 at 2.25 kW kg 1, with remarkable cycling stability, retaining 97.7 after 5,000 cycles. These results indicate that the TiC MXene and WC MXene hybrid composites are promising candidates for high-performance supercapacitors, providing enhanced energy storage and stability for practical applications.	{MXene,Supercapacitors,Asymmetric,TiC,WC}
730	A compressible asymmetric supercapacitor based on carbon Felt MWCNT PANI and MXene	Elif Vargun, Haojie Fei, Ulku Anik, Qilin Cheng, Petr Saha	Materials Chemistry and Physics	2025	https://doi.org/10.1016/j.matchemphys.2025.131120	https://www.sciencedirect.com/science/article/pii/S0254058425007667	0254-0584	Compressible supercapacitors are novel energy storage devices for commercial portable and flexible electronics. Substantial efforts have been made to develop compressible supercapacitors with high voltage output, good mechanical stability, and electrochemical performance. This study investigates the performance of a compressible asymmetric supercapacitor configuration based on a polyaniline-modified carbon felt multi-walled carbon nanotube composite (a-CF MWCNT PANI) as the positive electrode and a titanium carbide-MXene (Ti3C2Tx) as the negative electrode. The acid-functionalized MWCNTs were loaded into activated carbon felt by dipping and drying and subsequently were coated by polyaniline via the chemical oxidation polymerization method. Fourier transform infrared spectroscopy (FTIR), scanning electron microscopy (SEM), and X-ray photoelectron spectroscopy (XPS) confirmed the formation of the dendritic structure of PANI on the surface of 3D porous composite (a-CF MWCNT PANI) positive electrode. X-ray diffraction (XRD), SEM, and cyclic voltammetry (CV) measurements revealed 2D layered morphology and pseudocapacitive behavior of Ti3C2Tx-MXene. The specific capacitance of the assembled asymmetric supercapacitor was found as 1.6 F cm 2 at 5 mA cm 2, the corresponding energy density and power density were 262 μWh cm 2 and 2.7 mW cm 2, respectively. The asymmetric cell exhibited a retention rate of 92.4 after 1000 cycles. Above 50 strain, the supercapacitor showed a favorable CV profile, which is owing to the enhanced electrical conductivity of the CF composite electrode caused by compression. The capacitance retention retained more than 90 over 200 compression-recovery cycles.	{Compression,"Asymmetric supercapacitor",MXene,polyaniline}
731	Synergistically coupling of 3D FeNi-LDH arrays with Ti3C2Tx-MXene nanosheets toward superior symmetric supercapacitor	Renjie Zhang, Jidong Dong, Wei Zhang, Lina Ma, Zaixing Jiang, Jiajun Wang, Yudong Huang	Nano Energy	2022	https://doi.org/10.1016/j.nanoen.2021.106633	https://www.sciencedirect.com/science/article/pii/S2211285521008843	2211-2855	Layered double hydroxides (LDHs) are promising energy materials for their considerable theoretical capacities and adjustable compositions, however, also subjected to the intrinsic poor conductivity and agglomeration property, hence, the precise hybridization with high conductivity and active surface matrix is an effective strategy to solve these intractable problems. Herein, we exploit hierarchical nanohybrids via ionic hetero-assembly of 3D FeNi-LDH arrays on 2D Ti3C2Tx-based MXene nanosheets through mutual coupling synergy. The strong interfacial interaction and good electronic coupling between the FeNi-LDH arrays and Ti3C2Tx MXene nanosheets not only improve the structural stability, electrical conductivity, and electrolyte-accessibility but also greatly boost the redox reaction kinetics. The obtained Fe1Ni3-LDH Ti3C2Tx-MXene energy materials reveal prominent conductivity, superior capacitance behavior, and the constructed symmetric supercapacitor demonstrates outstanding energy densities of 94.1 Wh Kg-1 and power density of 7431.8 W Kg-1. This study offers a facile and efficient strategy for developing 2D MXene-based energy storage devices with a stable interface and favorable electrochemical performance.	{"MXene nanosheets","Layered double hydroxides",Nanohybrid,"Symmetric supercapacitor","Coupling synergy"}
732	In situ synthesis of M (Fe, Cu, Co and Ni)-MOF MXene composites for enhanced specific capacitance and cyclic stability in supercapacitor electrodes	Yaxiong Ji, Weibin Li, Yang You, Guihong Xu	Chemical Engineering Journal	2024	https://doi.org/10.1016/j.cej.2024.154009	https://www.sciencedirect.com/science/article/pii/S1385894724054986	1385-8947	In this study, an in situ method was developed to synthesize a series of uniform 3D MOFs (Fe-, Cu-, Co-, Ni)-BTC 2D MXene (Ti3C2Tx) composites, and the experimental results show that a typical sample of Ni-MOF MX 2 exhibits the highest specific capacitance of 1160.5 F g 1 and 736 F g 1 at a current density of 1 A g 1 and 20 A g 1, respectively, which is 2.3 times higher than the value of 320 F g 1 at a current density of 20 A g 1 on the bare Ni-MOF, and particularly maintains significant cyclic stability after 10,000 cycles at a high current density of 20 A g 1. The improved electrochemical performance is ascribed to the synergistic interaction between layered MXene and MOFs, which were evidenced by experiments and theoretical calculations. The Ni-MOF MX 2 AC asymmetric supercapacitor (ASC) device demonstrates a maximum energy density of 48.2 Wh kg 1 at 750 W kg 1. It retains 94 capacity after 10,000 cycles. Moreover, the value still maintained at 23.3 Wh kg 1 when elevating power density to 15000 W kg 1. This indicates that the obtained MOF MXene composites are probably alternative materials for supercapacitor electrodes in energy storage.	{MOFs,MXene,"Synergistic interaction","Theoretical calculations",Supercapacitor}
733	Ti3C2Tx MXene decorated with CoMnO3 CoMn2O4 nanoparticles as electrocatalysts for anion exchange membrane water electrolysis	C. Kalaiselvi, Karthik Kannan, Muthu Senthil Pandian, Nitika Devi, Amornchai Arpornwichanop, N. Krishna Chandar, Yong-Song Chen	International Journal of Hydrogen Energy	2025	https://doi.org/10.1016/j.ijhydene.2025.04.402	https://www.sciencedirect.com/science/article/pii/S0360319925021032	0360-3199	The progress of effective electrocatalysts for hydrogen-oxygen evolution reaction (HER-OER). Water electrolysis using an anion exchange membrane (AEM) is a promising low-cost method of producing green hydrogen. In the present study, CoMnO3 CoMn2O4 Ti3C2Tx nanocomposites were developed with various loadings of Ti3C2Tx using the electrostatic self-assembly method. XRD, SEM, and TEM with EDAX were utilized to analyze the physicochemical properties of the nanocomposites. The cubic spinel rhombohedral structure of CoMnO3 CoMn2O4 was established by the XRD. The SEM and TEM morphology reveals that the Ti3C2Tx MXene sheets have been decorated with spherical CoMnO3 CoMn2O4 nanoparticles. The interlayer spacing of Ti3C2Tx MXene sheets (56 nm) and the average diameter of CoMnO3 CoMn2O4 nanoparticles (46 nm) were measured via TEM examination. The CoMn2O4 Ti3C2Tx MXene (20 wt ) enabled a high-performance AEM electrolyzer, attaining an extraordinary current density of 520 mA cm 2 at 1.8 V.	{"Ti3C2Tx MXene",CoMnO3,CoMn2O4,Electrocatalyst,Nanoparticles,"Anion exchange membrane water electrolysis"}
734	Ti3C2Tx MXene and Vanadium nitride Porous carbon as electrodes for asymmetric supercapacitors	Sandhya Venkateshalu, Andrews Nirmala Grace	Electrochimica Acta	2020	https://doi.org/10.1016/j.electacta.2020.136035	https://www.sciencedirect.com/science/article/pii/S0013468620304278	0013-4686	MXenes are the emerging class of 2D materials, widely explored as supercapacitor electrodes with their explicit properties. Using the pseudocapacitive nature of the widely reported MXene - Ti3C2Tx, an asymmetric cell is designed with Ti3C2Tx as the negative electrode and Vanadium nitride Porous carbon as the positive electrode. The asymmetric cell provides a high cell voltage of 1.8 V with a specific capacitance of 105 F g at 1 A g in 6 M KOH. It also presents a capacitance retention of 73 even after 10,000 charge-discharge cycles. The asymmetric cell exhibits a high potential window, which is about 3 times higher when compared to symmetric supercapacitors. The asymmetric electrode system exhibits an energy density of 12.81 Wh kg and a corresponding power density of 985.8 W kg at 1 A g. This value of energy density is greater when compared to various symmetric supercapacitors. Thus Ti3C2Tx MXene electrodes can effectively replace the conventional carbon electrodes used in asymmetric supercapacitors.	{MXene,Ti3C2Tx,"Asymmetric supercapacitors","Vanadium nitride","Aqueous electrolyte"}
735	3D ZnO hexagonal prism-decorated 2D MXene-based high-performance flexible symmetric supercapacitor	Sahil Jangra, Shilpi Sengupta, Azam Raza, Aadil Rashid Lone, Bhushan Kumar, Manab Kundu, Iftikhar Hussain, Kavita Pandey, Subhankar Das, M.S. Goyat	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.116366	https://www.sciencedirect.com/science/article/pii/S2352152X25010795	2352-152X	Flexible, high-performance supercapacitors are critical for the future generation of portable and wearable electronics. In this research, we present, for the first time, the synthesis and design of a flexible supercapacitor device using ZnO hexagonal prism-decorated MXene synthesized via a hydrothermal method, serving as a highly efficient electrode material. Pristine MXene suffers from restacking, limiting its electrochemical performance; however, decorating it with ZnO hexagonal prism mitigates this issue by enhancing interlayer spacing and improving ion transport. The unique hexagonal prism morphology of ZnO, combined with the layered MXene structure, significantly enhances electrical conductivity while preventing restacking. The resulting material achieved an impressive specific capacitance of 140 F g 1 at 0.5 A g 1, greatly surpassing pristine MXene (73 F g 1). Furthermore, it exhibited outstanding cycling stability, with 97.2 capacitance retention after 12,000 cycles at 3 A g 1. A flexible symmetric supercapacitor fabricated using this material demonstrated excellent mechanical flexibility, maintaining reliable electrochemical performance under bending angles of 0 , 60 , 90 , and 180 . The device also delivered a high energy density of 6.33 Wh kg 1 and a power density of 600 W kg 1, showcasing the potential of ZnO hexagonal prism decorated MXene as a promising material for advanced energy storage applications.	{MXene,"ZnO hexagonal prism","Decorated MXene","Flexible supercapacitor","Energy density"}
736	Optimizing the electron spin state of hierarchical NiCo2O4 MXene LDH 3D composite electrode by heterointerface engineering to enhance energy density and excellent cyclic stability of supercapacitor	Jianghong You, Yiming Yuan, Chen Zhang, Haoming Xu, Mingyao Chen, Ying Wang, Dongsheng Chen	Journal of Colloid and Interface Science	2025	https://doi.org/10.1016/j.jcis.2025.138011	https://www.sciencedirect.com/science/article/pii/S002197972501402X	0021-9797	The transition metal oxide of nickel cobaltite (NiCo2O4) has gained more and more attention from battery industry for its excellent properties of high capacitance and cycling stability. However, its performance when used in supercapacitors is compromised due to its limited active sites and poor conductivity. Herein, a 3D (three-dimensional) hierarchical and high-performance material of NiCo2O4 MXene LDH (LDH: layered double hydroxide) composite was designed and synthesized. In the material, NiCo2O4 nanorods form a skeleton of nanosheet arrays on layered MXene; and on the nanosheet arrays, NiCo-LDH nanoparticles are attached to form a 3D hierarchical structure, extending the electrochemically active sites, suppressing the agglomeration of NiCo-LDH and producing hierarchical channels that promote electron and ion transport. Density functional theory (DFT) calculations and the results of Ultraviolet visible (UV Vis) spectrophotometry indicated that the introduction of MXene and NiCo-LDH induces a redistribution of the electronic states of NiCo2O4 due to the formation of a heterointerface, thereby decreasing its bandgap by about 1.42 eV. The X-ray photoelectron spectroscopy (XPS) analysis further demonstrated the negative shift in the initial binding energies of nickel (Ni) and cobalt (Co) atoms, which is due to their transition of spin states; and this is in agreement with the high intensity of electron paramagnetic resonance (EPR) peak in the NiCo2O4 MXene LDH composite. The in situ Raman analysis reveals that the enhanced energy storage performance originates from the accelerated formation and increased exposure of NiCoOOH active species during electrochemical cycling. The synergistic effect of MXene and NiCo-LDH introduced into NiCo2O4 enhanced the supercapacitor in terms of power and energy densities. It was indicated that the supercapacitor fabricated from NiCo2O4 MXene LDH supercapacitor exhibited a specific capacitance of 5066 F g 1 at 1 A g 1, and a capacitance retention of 97.82 after 10,000 charge cycles at 10 A g 1. Moreover, an asymmetric supercapacitor (ASC) device with a NiCo2O4 MXene LDH AC configuration was developed. The supercapacitor presented an energy density and power density of 70.11 Wh kg 1 and 850.22 W kg 1, respectively. The redistribution of electronic states and decreased bandgap could facilitate the creation of NiCo2O4-based materials with customized features for supercapacitors.	{NiCo2O4,MXene,Hierarchical,"Spin states","Electrochemical performance"}
737	Polydopamine-bridged MXene graphene composite aerogel for bifunctional applications in supercapacitors and piezoresistive sensors	Yunfeng Wang, Zejiang Deng, Haiyun Ou, Shi Feng, Xu Xiang	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.167528	https://www.sciencedirect.com/science/article/pii/S1385894725083676	1385-8947	Graphene aerogels, with their three-dimensional (3D) porous structure enabling high surface area and conductivity, are promising electrode materials for supercapacitors and flexible sensors for wearables. In this work, a synergistic modification strategy is proposed, utilizing polydopamine (PDA) as a molecular bridge to introduce two-dimensional transition metal carbide MXene into graphene aerogels, thereby constructing a three-dimensional network composite structure. PDA enhances the interaction between MXene and graphene oxide (GO) nanosheets, significantly improving the mechanical stability of the composite framework. The abundant functional groups of MXene compensate for the loss of active adsorption sites due to reduced PDA dosage, ensuring the aerogel s excellent electrode performance. Experimental results indicate that the polydopamine-bridged MXene graphene aerogel (MXene PDGA) prepared using this synergistic modification strategy exhibits outstanding performance in electrochemical energy storage. At a current density of 0.5 mA cm2, MXene PDGA-3 achieves an area-specific capacitance of 485 mF cm2 and demonstrates excellent cycling stability. Meanwhile, as a flexible strain sensor, the aerogel also exhibits high sensitivity (GF = 1.42 kPa 1) and rapid response recovery times. In summary, this study successfully fabricated the polydopamine-bridged MXene graphene composite aerogel with superior energy storage and sensing performance, providing valuable references for related research.	{Polydopamine,MXene,"Graphene aerogel",Supercapacitor,"Piezoresistive sensor"}
738	Unleashing the potential of vanadium based MXenes for supercapacitors	Onkar Jaywant Kewate, Jeng-Yu Lin, Sathyanarayanan Punniyakoti	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237518	https://www.sciencedirect.com/science/article/pii/S0378775325013540	0378-7753	The evolving 2D MXenes are gaining immense recognition due to their superior physicochemical properties. Among them, titanium-based are studied more due to their exceptional properties and simple preparation approach. However, Vanadium (V)-based MXenes are receiving tremendous focus due to their interesting properties including surface chemistry, enhanced electrical conductivity, lightweight nature, hydrophilicity, and structural stability. Additionally, vanadium-based MXenes have thin layers which offer rapid ion diffusion and provide enhanced pseudocapacitance. These vanadium (V2CTx, V2NTx, and V4C3Tx) 2D structures are classified into two distinctive categories: carbides and nitrides. This review gives an overview of the current state of vanadium-based, its diverse properties, various synthesis approaches, and applications towards supercapacitors. Furthermore, challenges, possible solutions, and future perspectives are discussed.	{MXenes,"Vanadium MXenes",Synthesis,Properties,Supercapacitors}
739	Multifunctional Co3O4 Ti3C2Tx MXene nanocomposites for integrated all solid-state asymmetric supercapacitors and energy-saving electrochemical systems of H2 production by urea and alcohols electrolysis	Shidong Li, Jincheng Fan, Guocai Xiao, Shanqiang Gao, Kexin Cui, Zisheng Chao	International Journal of Hydrogen Energy	2022	https://doi.org/10.1016/j.ijhydene.2022.05.101	https://www.sciencedirect.com/science/article/pii/S0360319922021395	0360-3199	Co3O4 Ti3C2Tx MXene nanocomposites have been fabricated by vacuum filtration and hydrothermal-annealing methods, and their electrochemical performance were investigated for energy storage and conversion, systematically. As electrode materials, Co3O4 Ti3C2Tx MXene nanocomposites in 6 M KOH solution demonstrated the specific capacitance of 240.1 F g 1 at 0.1 A g 1 and the long-term cycle stability. The solid-state asymmetric supercapacitors exhibited an operating potential window of 1.4 V, a specific capacitance of 97.9 F g 1at 0.25 A g 1, an energy density of 95.9 Wh kg 1 at a power density of 630.4 W kg 1, and excellent long-term durability. Furthermore, the connected solid-state asymmetric supercapacitors inseries and parallels presented the promising practical applications. Besides, Co3O4 Ti3C2Tx nanocomposites displayed outstanding catalytic behaviors for energy-saving H2 generation by urea and alcohols electrolysis. The electrolyzer in KOH + CH3CH2OH electrolyte required only 1.33 V potential to deliver the current density of 0.5 A g 1. Especially, the elctrochemical system of H2 production by The electrolyzer and the powered solid-state asymmetric supercapacitors based on Co3O4 Ti3C2Tx nanocomposites was constructed, demonstrating outstanding properties of H2 production. Therefore, this study not only shows enormous potential of Co3O4 Ti3C2Tx nanocomposites as a portable power supply but also indicates its great opportunities in energy-saving H2 production in practical applications.	{"Co3O4/Ti3C2Tx MXene nanocomposites","Specific capacitance","Solid-state asymmetric supercapacitors",Energy-storage,"H2 production"}
740	Bimetallic synergy in CoZnOHF Ti3C2Tx MXene composites enables enhanced high-rate lithium-ion storage	Yicen Liu, Zekun Wang, Bing Zhu, Yan-gai Liu, Xiaowen Wu	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117714	https://www.sciencedirect.com/science/article/pii/S2352152X25024272	2352-152X	The advancement of high-performance lithium-ion battery electrode materials is a central objective in current energy materials research. MXene, an emerging two-dimensional layered material, has found broad application in energy storage owing to its excellent electrochemical activity. However, its relatively low specific capacity frequently requires compositing with other high-capacity materials to enhance electrochemical performance. This study synthesized a CoZnOHF MXene composite material using a facile hydrothermal method by combining Ti₃C₂Tₓ MXene with CoZnOHF, significantly improving the composite s electrochemical properties. The CoZn bimetallic system creates a built-in electric field, exerting synergistic effects that provide higher specific capacity, while MXene contributes exceptional cycling stability. The CoZnOHF MXene composite delivers a high specific capacity of 1018 mAh g 1 at a specific current of 2 A g 1, maintaining stable performance over 1000 cycles. Ex situ XRD, XPS, and TEM analyses confirmed the synergistic interaction between the Co and Zn bimetal during cycling, elucidated the capacity enhancement mechanism, and revealed the composite s reversible lithium storage behavior. This work offers new strategies for developing MXene-based composites and applying bimetallic hydroxyfluorides in energy storage.	{"Hydroxy fluoride","Ti3C2Tx MXenes","Lithium-ion battery","Bimetallic synergic"}
741	Engineering MXene nickel silver sulfide composites for high-performance hybrid supercapacitors: Synthesis and electrochemical insights	Luxmi Rani, Jeong In Han	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.167423	https://www.sciencedirect.com/science/article/pii/S1385894725082622	1385-8947	Two-dimensional (2D) layered MXene (Ti3C2) has emerged as a promising electrode material for hybrid supercapacitors owing to its unique structure, high surface area, metallic conductivity, thermal and chemical stability, rapid surface redox kinetics, and excellent electrochemical properties. However, issues like spontaneous layer collapse and the limitations of single-component materials hinder its broader application in energy storage field. In this work, Ag2S microcorals and NiAg2S hexagonal microstructures are synthesized using one-step hydrothermal method and characterized using various techniques. The bimetallic NiAg2S exhibited higher specific capacitance of 837 F g 1 compared to Ag2S (383 F g 1) at 1 A g 1. Further, MXene is synthesized by selective etching Al-layer from Ti3AlC2 MAX phase using HF solution. To improve the performance of bimetallic sulfide (NiAg2S) and mitigate the restacking tendency of MXene (Ti3C2) sheets, MXene NiAg2S hybrid composite is engineered by incorporating a small amount of MXene into NiAg2S. The specific capacitance of 1255 F g 1 at 1 A g 1 is delivered by MXene NiAg2S hybrid electrode which is found to be higher than pristine MXene (245 F g 1) and NiAg2S (837 F g 1). Furthermore, a hybrid supercapacitor (HSC) device is assembled using MXene NiAg2S as positive electrode and activated carbon (AC) as negative electrode, delivering high energy density of 50.38 Wh kg 1 with power density of 775 W kg 1 at 1 A g 1. Moreover, two series-connected MXene NiAg2S AC HSCs are successfully employed to power the practical electronic components including LEDs, a toy motor fan, digital humidity meter and a kitchen timer, showcasing the real-world application potential. This work provides a promising strategy to overcome the MXene restacking and bimetallic sulfide limitations for next-generation energy storage devices.	{"Silver sulfide",MXene/NiAg2S,"Hydrothermal process","Hybrid supercapacitor","Specific energy and power density"}
742	Ultrasound-driven fibrous MXene and graphene formation via molecular interactions for asymmetric supercapacitors with enhanced charge storage	Jiamin Li, Shuaikai Xu, Yubing Li, Haifu Huang, Xianqing Liang, Ya Yang	Energy Storage Materials	2025	https://doi.org/10.1016/j.ensm.2025.104433	https://www.sciencedirect.com/science/article/pii/S2405829725004301	2405-8297	Asymmetric supercapacitors (ASCs) based on 2D nanomaterials hold great promise for high-performance energy storage, yet challenges remain in ion transport and self-discharge. This work presents a facile and scalable ultrasound-driven strategy, utilizing ascorbic acid (AA), to fabricate fibrous architectures of Ti3CNTx MXene and reduced graphene oxide (rGO) for ASC electrodes. Molecular interactions, induced by AA and sonication, facilitate the self-assembly of nanosheets into interconnected fibrous networks with large pores, enhancing ion diffusion. Crucially, AA surface engineering reduces surface hydroxyl groups on MXene, increasing its potential of zero charge (PZC) and effectively suppressing self-discharge. The resulting Ti3CNTx-1.5AA-20 rGO-2.0AA-30 ASC exhibits significantly enhanced charge storage, achieving a high capacitance and excellent rate capability. Remarkably, it demonstrates a low self-discharge rate (15.53 voltage drop after 5000 s), attributed to the mitigated diffusion and Faradaic processes. This strategy proves versatile across various aqueous electrolytes (H2SO4, LiCl, KOH) and yields ASCs with excellent cycling stability and a high energy density of 19.7 mWh g-1. This approach offers a promising route for next-generation supercapacitors with improved energy storage and charge retention.	{"Fibrous MXene","Asymmetric supercapacitor","Ultrasound-driven assembly","Molecular interactions","Self-Discharge suppression"}
743	Probing the synergistic effects of amino compounds in mitigating oxidation in 2D Ti3C2Tx MXene nanosheets in aqueous environments Electronic supplementary information (ESI) available. See DOI: https: doi.org 10.1039 d4sc05097e	Jai Kumar, Jiayi Tan, Razium Ali Soomro, Ning Sun, Bin Xu	Chemical Science	2024	https://doi.org/10.1039/d4sc05097e	https://www.sciencedirect.com/science/article/pii/S2041652024020005	2041-6520	The shelf life of 2D MXenes in functional devices and colloidal dispersions is compromised due to oxidation in the aqueous system. Herein, a systematic investigation was carried out to explore the potential of various amino compounds as antioxidants for Ti3C2Tx MXenes. A range of basic, acidic, and neutral amino acids were examined for their effectiveness, where certain antioxidants failed to protect MXenes from oxidation, while others accelerated their decomposition. Serine, threonine, and asparagine demonstrated excellent antioxidant activity, likely due to their evenly distributed molecular charges. These neutral amino acids outperformed glutamic acid, which possesses an electron-withdrawing COOH group, and lysine, with an electron-donating NH2 group. Serine-functionalized MXene realized a stabilization time constant reaching 128 days, as determined by first-order reaction kinetics. Additionally, when employed as supercapacitor electrodes, aged MXene and serine-functionalized MXene exhibited specific capacitance values of 219.2 and 280.3 F g 1 at 5 A g 1 after 6 weeks, respectively. This work addresses the gap in the practical work on ionic stabilization of 2D MXenes and has significant implications for the long-term colloidal storage of MXenes using greener chemicals.	{}
744	Fabrication of flexible and bendable solid state symmetric supercapacitor based on carbon black intercalated MXene	Ali Shan, Habibulla Imran, Kinza Batool, Sooman Lim	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117019	https://www.sciencedirect.com/science/article/pii/S2352152X25017323	2352-152X	Although Ti3C2Tx MXene has emerged as a promising electrode material for electrochemical supercapacitors, it suffers from limited pseudocapacitance caused by the aggregation of MXene layers, which reduces the number of available active sites. Resolving the restacking issue by increasing the number of accessible adsorption sites for electrolyte ions can help to improve charge storage. Therefore, this study focuses on avoiding the re-stacking of MXene layers by intercalating carbon black (CB) nanosheets, which avoids restacking and raises the conductivity and number of accessible adsorption sites. Physicochemical characterizations of MXene and MXene CB composites are performed to synthesize the MXene CB composite. Successful improvement in the charge storage capability of the fabricated composite, attributable to the inclined interlayer spacing of MXene with the intercalation of highly conductive CB nanosheets is studied using cyclic voltammetry, galvanostatic charge discharge, and electrochemical impedance spectroscopy. The synergy between 2D-MXene and conductive CB is responsible for the fabricated material s enhanced specific capacitance (383 F g 1). In addition, MXene CB is used to fabricate a symmetric supercapacitor device. The symmetric supercapacitors device exhibits high areal capacitance (138.75 mF cm2), energy density (12.33 mWh cm2), power density (2212 mW cm2), and 86.14 and 78.7 capacitance retentions after 3000 and 5000 cycles, respectively, which can be attributed to the maintained interlayer spacing between the MXene sheets using CB. The developed device has highly flexible (60 N) and bendable (up to 90 ) properties. This study introduces a sustainable and effective strategy to overcome MXene restacking challenges, which offers new avenues for environmentally friendly and scalable energy storage solutions.	{MXene,"Carbon black",Flexible,Bendable,"Symmetric supercapacitor"}
745	Perovskite structured LaMnO3 nanoparticles adorned on the MXene 2D sheets: An innovative crossbreed electrode material for robust supercapacitor application and oxygen evolution reactions	M. Murugesan, K.R. Nagavenkatesh, P. Devendran, N. Nallamuthu, Y.C. Sunilkumar	Fuel	2026	https://doi.org/10.1016/j.fuel.2025.136594	https://www.sciencedirect.com/science/article/pii/S0016236125023191	0016-2361	This study aimed to address energy demand constraints by developing a novel hybrid electrode material for energy storage and conversion, perovskite structured lanthanum manganite (LaMnO3) with MXene composites. The LaMnO3 NPs decorated on the MXene nanosheets were synthesized by simple hydrothermal technique. The synthesized lanthanum-based MXene nanocomposite (NCs) was examined by Structural, morphological and spectroscopic analysis using XRD, HR-TEM, SEM with EDX, FTIR and XPS tools. Through the electrochemical analysis, the perovskite structured LaMnO3 NPs and LaMnO3 MXene NCs were achieved remarkable specific capacitance (Csp) of 782.70 and 1216.36F gat 5 mV s respectively. The prepared LaMnO3 MXene NCs proved outstanding capacitance retaining 90.1 after 5000 cycles. Besides, a Asymmetric supercapacitor (ACS) device was built with MXene and LaMnO3 MXene electrodes, which is shows a remarkable power density (PD) 1350 W kg with corresponding energy density (ED) 150.6 Wh kg and it displays the remarkable cycling stability up to 77.6 was retained after 5000 cycles at 10 A g. In addition from Oxygen evaluation reaction analysis the LaMnO3 MXene composite exhibits overpotential of 446.10 mV corresponding to the 10 mA cm2 current density, along with the lesser Tafel slope of 88.31 mV dec for OER in 1 M KOH. As a result, the prepared LaMnO3 MXene electrode having exceptional qualities might prove towards the trustable electrode for the advance supercapacitors and water splitting applications.	{Hydrothermal,Perovskite,LaMnO3/MXene,Supercapacitor,"Dunn method and OER"}
746	Covalent surface grafting of Ti3C2Tx flakes for enhancement of symmetric supercapacitor performance	Vasilii Burtsev, Elena Miliutina, Vera Shilenko, Karolina Kukrálová, Andrei Chumakov, Matthias Schwartzkopf, Václav Švorčík, Jan Lancok, Sergii Chertopalov, Oleksiy Lyutakov	Journal of Power Sources	2024	https://doi.org/10.1016/j.jpowsour.2024.234710	https://www.sciencedirect.com/science/article/pii/S0378775324006621	0378-7753	In this work the covalent surface modification of MXene flakes (Ti3C2Tx) was proposed for the increasing of the performance of subsequently created symmetric supercapacitor. Covalent surface modification was performed with utilization of diazonium salts (hydrophobic or hydrophilic) and plasmon-assisted photochemistry. Applied procedure allows to block the reactive (weak and or catalytically active) sites on flakes surface and increase the flakes interplanar spacing, both enhancing the functionality of an MXene-based supercapacitor. Especially pronounced positive effect gives the surface modification with hydrophilic chemical moieties. In particular, we observed increase of supercapacitance from 197 to 284 F g 1 in acidic and from 86 to 142 F g 1 in alkaline conditions for flakes grafted with C6H4 COOH chemical moieties at scan rate 20 mV s. The flakes grafted with hydrophobic chemical moieties allow to achieve almost constant value of supercapacitance for different speed of charge discharge. In addition, the surface grafting prevents the supercapacitor degradation and decelerates the spontaneous discharge in open circuit mode. These results suggest strategy for further improvement of MXene-based supercapacitors as energy storage device.	{Ti3C2Tx,"Surface termination","Covalent grafting","Plasmon assisted chemistry",Supercapacitor}
747	Metal-organic framework derived NiCo2S4 Co3S4 yolk-shell nanocages Ti3C2Tx MXene for high-performance asymmetric supercapacitors	Wenling Wu, Tiantian Liu, Jiahao Diwu, Chenguang Li, Jianfeng Zhu	Journal of Alloys and Compounds	2023	https://doi.org/10.1016/j.jallcom.2023.170213	https://www.sciencedirect.com/science/article/pii/S0925838823015165	0925-8388	Ti3C2Tx MXene has become an excellent two-dimensional conductive substrate for electrode materials of supercapacitors (SCs) with prominent physicochemical properties. Whereas, due to the lower theoretical specific capacitance and its interlayer agglomerate, the practical application and electrochemical property of Ti3C2Tx have imposed serious restrictions. Herein, metal-organic framework (MOF) derived NiCo2S4 Co3S4 nanocages with superior yolk-shell structure are introduced to anchor on the surface of Ti3C2Tx via ion exchange reaction and electrostatic attraction, forming the distinctive hierarchical structure of NiCo2S4 Co3S4 Ti3C2Tx composed of NiCo2S4 Co3S4 yolk-shell nanocages (NiCo2S4 Co3S4 YSNs) adsorbed on 2D Ti3C2Tx nanosheets. The NiCo2S4 Co3S4 YSNs with a large void space, serving as a confined reactor, not only offer a buffer against the volume variation, but also supply abundant active sites and restrain the agglomeration of Ti3C2Tx nanosheets. Furthermore, the novel structure of NiCo2S4 Co3S4 Ti3C2Tx composite as electrode material could accelerate the thermodynamic stability, suppress the textural instability, and moderate the unavoidable volume change of active substance. Benefited from the above merits, the NiCo2S4 Co3S4 Ti3C2Tx electrode demonstrates a significant specific capacitance (1872 F g 1 at 2 mV s 1), remarkable rate capability in the high current density (such as, 1121.6 F g 1 at 20 A g 1, 1533 F g 1 at 0.5 A g 1) and displays an excellent life span with 92.2 of the capacity retention after 12,000 cycles at 10 A g 1. More particularly, the asymmetric supercapacitors (ASCs) fabricated with NiCo2S4 Co3S4 Ti3C2Tx represent a fascinating energy density of 241.9 Wh kg 1 at a power density of 1125 W kg 1, which can light up 10 LEDs simultaneously. The results further prove that this rational design method could provide a meaningful prospect for MXenes and MOF derivatives composites for high-performance ASCs.	{MXenes,"Yolk-shell nanocages",MOF,"Asymmetric supercapacitors"}
748	Fabrication of flexible MnO2 MXene CC composite electrodes for supercapacitor applications	Meilin Huang, Jiaqi He, Yajie Yang, Xiaoxian Zhang, Chunjun Liang, Yinghao Lv, Dawei He, Yongsheng Wang	Journal of Physics and Chemistry of Solids	2026	https://doi.org/10.1016/j.jpcs.2025.113031	https://www.sciencedirect.com/science/article/pii/S0022369725004834	0022-3697	Flexible supercapacitors have garnered significant attention in the research of flexible energy storage devices in recent years due to their advantages of rapid charging and discharging capabilities, long cycle life, high power density, and outstanding mechanical flexibility. Manganese dioxide (MnO2) has a high theoretical specific capacitance (1370 F g 1) and high crystal phase and morphology tunability, but low conductivity limits performance. Hydrothermal methods can customize nanostructures, but require harsh conditions and a high percentage of conductive agent and binder in the powder electrode, reducing energy density. In this study, MXene nanosheets with excellent conductivity were deposited onto flexible carbon cloth (CC, collector) via a composite fabrication strategy to fabricate MXene CC. The MXene CC served as a substrate for further in-situ MnO2 loading through a mild solution immersion process under ambient conditions. After optimization, the MnO2 microspheres formed after 8 immersions exhibited the superlative performance. Notably, this method is environmentally benign, easy to operate, and free of conductive agents or binders. The MnO2 MXene CC-8 (MMC-8, obtained by 8 immersion cycles) positive electrode exhibited a specific capacitance of 234.8 F g 1 at 1 A g 1 in a neutral electrolyte (0.5 M Na2SO4), while the MMC-8 MC asymmetric flexible supercapacitor, employing MXene CC (MC) as the negative electrode, achieved a capacitance of 21.3 F g 1 at 1 A g 1 with 75 capacitance retention after 10000 cycles. The device demonstrated an energy density of 9.6 Wh kg 1 at a power density of 902.3 W kg 1. This strategy provides new insights into the scalable fabrication of flexible supercapacitors.	{"Manganese dioxide",MXene,"Immersion method",Supercapacitor}
749	Modulation of biaxial strains on the optical responses of defective Ti3C2 Tx (T = F, O, OH) MXenes	Yulong Zhang, Zhongwei Zhao, Jieyun Yan, Huajie Song, Wenting Lv, Yu Yang	Solid State Communications	2025	https://doi.org/10.1016/j.ssc.2025.115970	https://www.sciencedirect.com/science/article/pii/S0038109825001450	0038-1098	MXenes have potential applications for adsorbing radioactive elements and protecting surfaces of radioactive materials. Keeping integrity is important for practical applications. Thus, an efficient way for detecting hole defects as well as strain conditions becomes required. Here based on first-principles calculations on the electronic structures and optical properties, we present a systematic result for optical detections on hole defects as well as strain conditions of Ti3C2T2 (T = F, O, OH) MXenes. Introduction of hole defects affects the chemical bondings of surrounding functional groups, and biaxial strains from 4 to 4 causes negligible bonding distortions. The change in bonding lengths under different strains is below 0.05 Å. Since the electronic states of functional groups distribute deeply away from the Fermi level, the absorption spectra in the ultraviolet frequency range show obvious modulation effects for hole defects and strain conditions. A quantitative relationship has been established. Our results can be used for detecting both the defect structures and strain conditions of Ti3C2T2 (T = F, O, OH) MXenes.	{"Ti3C2Tx (T = F, O, OH) MXenes","2D materials",Strain,"Optical properties","Density functional theory Nidhi, Nahid Tyagi, Gaurav Sharma, Manika Khanuja, Manoj Kumar Singh, Enhanced supercapacitor performance of Ti3C2Tx/MoS2 heterostructure, Materials Science and Engineering: B, Volume 321, 2025, 118464, ISSN 0921-5107, https://doi.org/10.1016/j.mseb.2025.118464. (https://www.sciencedirect.com/science/article/pii/S092151072500488X) Abstract: In this study, hybrid nanocomposite of Ti3C2Tx/MoS2 (MXMS) was synthesized via hydrothermal method and evaluated for its enhanced electrochemical performance as a supercapacitor electrode material. This strategy offers a promising pathway to enhance capacitive performance and increase surface area, thereby improving the efficiency of electrode materials for energy storage applications. The incorporation of MoS2 into Ti3C2TX MXene sheets effectively inhibits layer restacking and facilitates improved charge transfer kinetics. Consequently, Ti3C2Tx/MoS2 nanocomposite delivers a high specific capacitance of 595 F/g at a current density of 1 A/g in 1 M H2SO4 electrolyte. Furthermore, the composite retains 82 % of its initial capacitance after 2000 charging-discharging cycles at 5 A/g, demonstrating excellent electrochemical stability. Additionally, X-ray diffractogram (XRD), Field Emission Scanning Electron Microscopy (FESEM), Brunauer-Emmett-Teller (BET) and X-ray Photoelectron Spectroscopy (XPS) were utilized to investigate crystallinity, morphology, surface area, and composition analysis of as-synthesized materials. Keywords: Ti3C2Tx/MoS2 nanocomposite","Mild-etching and hydrothermal method","Electrochemical performance",Charging-discharging,"Supercapacitor application"}
750	Advancing supercapacitors with NiMn-LDH V2C MXene: A synergistic pathway to enhanced energy storage	A. Saranraj, S. Abinaya, U.S. Lakshmi, Mani Govindasamy, Sujin P. Jose	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117284	https://www.sciencedirect.com/science/article/pii/S2352152X25019978	2352-152X	Layered double hydroxides (LDHs) exhibit limitations in supercapacitor applications due to poor conductivity, insufficient stability, and severe nanosheet aggregation. This study addresses these challenges by constructing a novel composite material. The design involves in-situ anchoring of highly dispersed Nickel-Manganese Layered Double Hydroxide (NiMn-LDH) nanoparticles ( 10 nm) onto V2C MXene sheets via chemical bonding. The negatively charged MXene surface provides abundant nucleation sites for NiMn-LDH during crystallization, while surface functional groups further strengthen the material connection. This enhanced interface facilitates superior charge transfer and ion diffusion between MXene and NiMn-LDH. Compared to pristine materials, the NiMn-LDH V2C MXene composite demonstrates a significantly higher specific capacitance (1393 F g 1 at 1 A g 1). Additionally, it exhibits excellent cycling stability (99 coulombic efficiency after 10,000 cycles at 5 A g 1) and good rate capability (80 capacitance retention at 20 A g 1). Furthermore, a symmetric supercapacitor (SSC) was fabricated with the NiMn-LDH V2C MXene composite. The device also achieves a high energy density of 52 Wh kg 1 and a power density of 799 W kg 1. These results highlight the potential of NiMn-LDH V2C MXene composite as a promising approach for designing next-generation supercapacitor electrodes with exceptional performance and durability.	{"Affordable And Clean Energy","Layered Double Hydroxide","V2C MXene",Electrochemical,"Energy storage",Symmetric}
751	Design of NiCoMn-OH Ti3C2Tx composite electrode with hollow rhombic dodecahedral structure for efficient supercapacitor	Peiyun Shu, Xiang Luo, Runsheng Jiang, Gentian Yue, Yueyue Gao, Jinghao Huo, Chen Dong, Furui Tan	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2024.114949	https://www.sciencedirect.com/science/article/pii/S2352152X24045353	2352-152X	Layered double hydroxides (LDHs) hold great promise as electrode materials for supercapacitor (SC), but their practical application has been limited by unsatisfactory conductivity and low energy density. To address these challenges, doping LDHs with conductive materials is essential for achieving high-performance SCs. In this work, a composite of nickel cobalt manganese hydroxide (NiCoMn-OH) and Ti3C2Tx MXene was successfully prepared by using a hydrothermal strategy, preserving the hollow polyhedral structure of the zeolitic imidazolate frameworks (ZIFs) template. The NiCoMn-OH Ti3C2Tx electrode demonstrates impressive electrochemical performance, achieving a good specific capacity of 703.25C g 1 at a current density of 1 A g 1. Furthermore, it retains 75.2 and 67 of its initial capacity after 1500 and 5000 cycles at a high current density of 5 A g 1, exhibiting improved pseudocapacitive behavior and chemical stability compared to the pure NiCoMn-OH electrode. This enhanced electrochemical performance mainly thanks to the interaction between the hydroxide polyhedron and Ti3C2Tx, which forms a polyhedral nanosheet structure. This structure helps to increase the specific surface area and active sites, thereby facilitating rapid ion transport. The asymmetric SC NiCoMn-OH Ti3C2Tx AC achieves a maximum energy density of 49.7 Wh kg 1 and a power density of 800 W kg 1 at a current density of 1 A g 1. At a higher current density of 10 A g 1, it maintains an energy density of 20 Wh kg 1 and an impressive power density of 8000 W kg 1.	{Supercapacitor,"Metal-organic frameworks",ZIF,Ti3C2Tx}
752	The Ti3C2Tx MXene coated metal mesh electrodes for stretchable supercapacitors	Li Weng, Fangya Qi, Yonggang Min	Materials Letters	2020	https://doi.org/10.1016/j.matlet.2020.128235	https://www.sciencedirect.com/science/article/pii/S0167577X2030940X	0167-577X	Stretchable supercapacitors are promising energy storage devices for fabricating integrated wearable electronics. MXenes had shown great potential in electrochemical energy storage applications. However, it was still a big challenge to realize the performance of stretchable energy devices due to the mechanical stiffness of their 2D layered structures. Here, MXene based electrodes with structural stretchability were fabricated by spraying-baking Ti3C2Tx MXene flakes on tailored stainless steel mesh. With poly vinyl alcohol-sulfuric acid gel as electrolyte and separator, the performance of stretchable supercapacitor exhibited an areal capacitance of 33.3 mF cm 2 at scan rate of 10 mV s 1, and can be stretched up to 30 with 2.4 capacitance decay over 500 stretching cycles.	{"Electrical properties","Multilayer structure","Stretchable electrodes",Supercapacitor,MXene}
753	Experimental and DFT investigations on multifunctional Ti3C2Tx MXenes PDAAQ free standing interlayer for enhancing the cycle life and high-rate performance of Na S batteries	Maryam Sadat Kiai, Navid Aslfattahi, Deniz Karatas, Nilgun Baydogan, Lingenthiran Samylingam, Kumaran Kadirgama, Chee Kuang Kok	Journal of Physics and Chemistry of Solids	2026	https://doi.org/10.1016/j.jpcs.2025.113083	https://www.sciencedirect.com/science/article/pii/S0022369725005359	0022-3697	Sodium sulfur (Na S) batteries have attracted considerable attention owing to their remarkable theoretical specific capacity and elevated energy density. However, the practical application of Na S batteries is impeded by swift capacity degradation and the insulating characteristics of the sulfur cathode. In this study, PDAAQ was produced through the chemical oxidation of DAAQ, utilizing APS as the initiating agent and HClO4 as the acidic environment. This process is facilitated by the creation of poly(1,5-diaminoanthraquinone) through interfacial polymerization, followed by the integration of MXene through vacuum-assisted filtration and electrostatic self-assembly. The addition of PDAAQ significantly improved electrical conductivity and reduced the diffusion distance for Na+ ions, thereby enhancing material efficiency and reaction kinetics. Furthermore, this method effectively inhibited the re-stacking of MXene layers. As a result, the cell equipped with an MXene PDAAQ interlayer, a sodium metal anode, and a S Carbon black (CB) composite cathode exhibited a discharge capacity of 602.9 mAh g 1 after 800 cycles, demonstrating an impressive Coulombic efficiency of 96.7 . These results highlight the promise of MXene PDAAQ as a sophisticated MXene-based separator for the improvement of high-capacity Na S batteries. Our DFT calculations reveal that the MXene PDAAQ layer facilitates the dissociation of sodium polysulfides into adsorbed sulfur and mobile sodium ions, thereby elucidating the experimental observations.	{Na–S,MXene,PDAAQ,Stability,"Capacity retention",Polysulfides,DFT}
754	Synergistic effects of hybrid CuS Ti3C2Tx MXene material for enhanced super capacitive energy storage and efficient water splitting	Ayesha Irfan, Inaam Ullah, Mai Li, Wendong Xu, Zibo Dong, Hanxue Zhao, Haotian Hu, Nimra Irshad, Kaishuai Yang, Ping Zhong, Paul K. Chu	Surfaces and Interfaces	2025	https://doi.org/10.1016/j.surfin.2024.105536	https://www.sciencedirect.com/science/article/pii/S2468023024016912	2468-0230	Two-dimensional (2D) materials, such as MXene with its 2D structure and excellent conductivity, have emerged as crucial components in electrochemistry for energy storage and water electrolysis. However, the limited capacitance exhibited by 2D MXene as a cathode material hinders widespread practical applications. In this study, CuS Ti3C2Tx MXene nanocomposites are synthesized by integrating copper sulfide (CuS) into Ti3C2Tx layers to enhance energy storage characteristics alongside water-splitting properties, including the hydrogen evolution reaction (HER) and oxygen evolution reaction (OER). This remarkable progress is attributed to the synergistic effect of Ti3C2Tx nanosheets and CuS nanoparticles (NPs), which reduce agglomeration, modulate side reactions and enhance the electron transfer rate. Cyclic voltammetry (CV) and galvanostatic charging and discharging (GCD) confirm the superior electrochemical properties of CuS Ti3C2Tx compared to CuS and Ti3C2Tx alone. CuS Ti3C2Tx demonstrates a specific capacitance of 957.36 F g-1 at 1 A g-1, with 99.1 capacity retention after 10,000 cycles and a pseudo-capacitance ratio of 90.3 at 50 mV s-1. The asymmetric supercapacitor (ASC) comprising CuS Ti3C2Tx as the positive electrode and activated carbon (AC) as the negative electrode exhibits a specific capacitance of 361.1 F g-1, 98.84 capacity retention after 10,000 cycles and an energy density of 36.11 W kg-1. CuS Ti3C2Tx shows a minimum overpotential of 89.7 mV in HER and 171 mV in OER. These results suggest that 2D MXene-based CuS NPs are promising for energy storage and water splitting.	{"2D materials","Energy storage","Synergistic effects","Copper sulfide","Asymmetric supercapacitor","Water splitting"}
755	Novel synthesis of B-doped Ti3C2Tx thin sheets via BF3 Lewis acid etching: Structural insights and Supercapacitor applications	Jeremiah Hao Ran Huang, Anil A. Kashale, Shih-Wen Tseng, Jui-Chin Lee, I-Wen Peter Chen	Journal of Power Sources	2024	https://doi.org/10.1016/j.jpowsour.2024.235044	https://www.sciencedirect.com/science/article/pii/S0378775324009960	0378-7753	The rising demand for energy storage spurs research on supercapacitor materials, valued for high-power density and long-term cycling, vital in industries. Among two-dimensional materials, MXene, with a general formula of Mn+1XnTx, where M represents early transition metals, X indicates C and or N, Tx represents functionalized surface groups, and n = 1, 2, or 3, stands out as an ideal candidate for energy storage applications. Here, for the first time, we report the use of a Lewis acid, boron trifluoride (BF3), as an electron-deficient etchant in a sulfuric acid (H2SO4) solution for etching aluminum from the model system Ti3AlC2 MAX (M: transition metals, A: Al, X: carbon.), resulting in the formation of B-doped Ti3C2Tx MXene. Ex-Situ electrochemical X-ray diffraction (XRD) analysis showed reversible (002) plane changes in B-doped Ti3C2Tx MXene, from 5.72 to 7.0 , indicating ions intercalation and deintercalation, a first-time demonstration of significant ion transportation. Such fundamental insight determines that the specific capacitance of B-doped Ti3C2Tx MXene has found to be 396 F g at current density of 1 A g. This research introduces a novel synthesis approach aimed at understanding microstructural transformations of B-doped Ti3C2Tx MXene during electrochemical processes. This contributes to the advancement of MXene-based materials for future electrochemical applications.	{"Lewis acid","Electron Deficiency Molecule",MXene,Ti3C2Tx,Supercapacitors}
756	Advanced aqueous sodium hybrid supercapacitors based on plant waste-derived activated carbon anode and multilayered Ti3C2 MXene cathode	Tetiana Boichuk, Andrii Boichuk, Mahesh Eledath Changarath, Marie Krečmarová, Rafael Abargues, Vitalii Vashchynskyi, Saïd Agouram, Juan F. Sánchez-Royo	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237935	https://www.sciencedirect.com/science/article/pii/S0378775325017719	0378-7753	Hybrid sodium supercapacitors are emerging as highly promising energy storage devices for current and future applications in high-power electronics and the automotive industry. However, pushing their performance to competitive levels requires the development of innovative electrode material combinations to simultaneously enhance specific energy and power while significantly reducing energy production costs. Here, we report the first demonstration of an aqueous sodium supercapacitor employing an asymmetric electrode configuration with multilayered Ti3C2Tx MXene as the cathode and plant waste-derived activated carbon (AC) as the anode. In contrast to MXene Carbon composite electrodes, already described in the literature, our system relies on asymmetric pairing of different electrode materials, exploiting their respective pseudocapacitive (MXene) and electric double-layer (AC) charge accumulation mechanisms. The device achieves a specific capacitance of 155 Ah kg, a high energy density of 57 Wh kg, and a power density of 2110 W kg. These metrics are maintained over 5000 charge-discharge cycles, demonstrating excellent stability, rate performance, and Coulombic efficiency. The use of eco-friendly and low-cost AC from plant waste as an anode, in synergy with pseudocapacitive multilayered Ti3C2Tx as cathode material, offers a sustainable route toward efficient energy storage systems, demonstrating the potential of this electrode combination in practical supercapacitor applications.	{"Sodium aqueous supercapacitors",MXene,"Activated carbon","Enhanced power","High cycleability"}
757	Charge storage improvement in uniformly grown TiO2 on Ti3C2Tx MXene surface	Sunil Kumar, Sikandar Aftab, Tej Singh, Manjeet Kumar, Sanjeev Kumar, Yongho Seo	Journal of Alloys and Compounds	2023	https://doi.org/10.1016/j.jallcom.2023.172181	https://www.sciencedirect.com/science/article/pii/S0925838823034849	0925-8388	The energy storage capacity of MXenes can be significantly augmented by increasing their specific surface area, which can additionally amplify the number of active sites available for electrochemical reactions. Herein, we have presented a method to enhance the energy storage capacity of Ti3C2Tx MXenes by growing the TiO2 nanogrooves on the surface of Ti3C2Tx (termed as Ti3C2Tx-NG) without drying the exfoliated MXene layers using hydrothermal treatment. The Ti3C2Tx MXene flakes dimensions ranged from 500 to 1000 nm, whereas the decorated TiO2 nanogrooves have a size of 10 nm. The Ti3C2Tx MXene demonstrates a specific surface area (SSA) of 11 m2 g, while the Ti3C2Tx-NG exhibits an enhanced SSA of 40 m2 g. The Ti3C2Tx-NG utilized in the fabrication of symmetric supercapacitors exhibited a significantly higher specific capacitance ( 81 F g) compared to Ti3C2Tx MXene ( 62 F s) at a scan rate of 100 mV s. Reversible oxidation and reduction reactions between TiO2 and Ti3C2Tx, accompanied by the adsorption or release of hydroxide ions (OH-) contribute to charge transport in the supercapacitors. Additionally, due to the layered structure of Ti3C2Tx MXene, a smaller number of ions can exist between two adjacent MXene layers due to the small spacing, whereas more ions can exist between two adjacent Ti3C2Tx-NG layers as interlayer spacing between adjacent layers is relatively broader due to the nanosized TiO2 nanogrooves, facilitating in the higher charge storage.	{"2D materials",MXenes,"TiO2 nanogrooves","Surface area","Charge-storage mechanism"}
758	Recent advances in supercapacitors based on carbon nanomaterials MXene: Material design and functional integration	Jinyuan Cao, Zhe Liu, Xuanxuan Wu, Jin Duan, Gege Hang, Yuxin Fu	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.118120	https://www.sciencedirect.com/science/article/pii/S2352152X25028336	2352-152X	Supercapacitors are a major research topic in energy storage with interesting properties. The discovery of the new two-dimensional material MXene opens up new horizons in studying high-performance electrode materials for supercapacitors. However, the excellent electrochemical performance of MXene is limited by its self-stacking and oxidation problems. Currently, the intercalation of MXene nanosheets to establish a three-dimensional structure is the most effective solution, Carbon-based nanomaterials have emerged as a favored option due to their abundance, cost-effectiveness, and superior electrochemical properties. Based on the above background, this paper presents a comprehensive review of the current research status of different dimensions carbon nanomaterials MXene composites in terms of preparation methods and material design. The functional design of supercapacitors based on carbon nanomaterials MXene composites is further discussed. Additionally, problems and challenges are described and future research directions for supercapacitors are proposed in light of current developments.	{Supercapacitors,Electrodes,"Energy storage","Carbon nanomaterials","MXene-based composites"}
759	Microfluidic-oriented assembly of MXene composite fibers for flexible zinc ion supercapacitors with high energy density	Fanyu Xie, Yuan Du, Menghan Chu, Xiaoyu Jia, Hui Cao, Rui Zhang, Hongwei Li, Mei Zhang	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.162864	https://www.sciencedirect.com/science/article/pii/S1385894725036903	1385-8947	Fiber-typed zinc ion hybrid supercapacitors (ZIHSCs) have become the potential electrode materials for new generation of energy storage devices due to its low cost, abundant source and its low redox potential can expand the operating voltage window and increase energy and power density. But, the development of ZIHSCs is still in its infancy, and it is necessary to optimize the structure of electrode materials and design fibrous devices. Two-dimensional MXene materials are widely used in electrode manufacturing, which is of great significance to the development of fiber-typed supercapacitors and is expected to become excellent cathode materials for zinc ion supercapacitors. However, assembling them into regularly arranged macrofibers is challenging. Here, we precisely regulated and constructed the ordered and porous reduced graphene oxides MXene fibers (rGO MXene) by microfluidic assisted wet spinning technology. Graphene oxide (GO) was used as a spinnable material and lamellar spacer to achieve 10 rGO MXene fiber with high MXene loading. Among them, 10 rGO MXene was used as a symmetric supercapacitor electrode material, and the specific capacitance in PVA H2SO4 electrolyte was as high as 1613 mF cm 2. The 10 rGO MXene fiber and 70 rGO MXene Zn fiber were used as cathode and anode materials, and assembled into a zinc-ion hybrid supercapacitors (ZIHSCs) under PVA Zn(CF3SO3)2 gel electrolyte, and an outstanding specific areal capacitance of 1180 mF cm 2, wide voltage window of 0 1.6 V, high energy density of 104.9 μWh cm 2 and good practical applications can be realized. In addition, the capacitor has good stability at different bending angles. The expansion of energy and power output can be achieved by series or parallel configuration. This study provides a new way for the design of the high-performance flexible zinc ion supercapacitors.	{"MXene fibers",Graphene,"Zinc-ion supercapacitors","Energy density","Microfluidic spinning"}
760	A novel strategy for high energy density supercapacitors: Formation of cyanuric acid between Ti3C2Tx (MXene) interlayer hybrid electrodes	Chao Feng, Bingzhe Jia, Han Wang, Yan Wang, Xinming Wu	Chemical Engineering Journal	2023	https://doi.org/10.1016/j.cej.2023.142935	https://www.sciencedirect.com/science/article/pii/S1385894723016662	1385-8947	Ti3C2Tx (MXene) are attractive for electrode materials because of their high electrical conductivity, abundant interlayer ions and low density. However, the low energy density hinders its commercial application. Herein, a novel N-doped Ti3C2Tx MXene is synthesized by introducing a small organic molecule dicyandiamide (DCD) to tune the complex terminals. DCD can be inserted into the layers of Ti3C2Tx nanosheets while forming melamine by catalyst-free trimerization reaction. Then, melamine is converted into gt-C3N4 through high-temperature sintering. Finally, gt-C3N4 is oxidized to cyanuric acid (CA) through simple hydrothermal reaction. The prepared Ti3C2Tx CA composite electrode exhibits up to 4.8 at. nitrogen doping and has a stable triazine ring structure. It is also shown that the Ti3C2Tx CA composite electrode has high specific capacitance and excellent cycling stability. More notably, it achieves an energy density of 51.1 Wh kg 1 at a power density of 2000 W kg 1, which exceeds the energy density of MXene based electrodes reported in the current literature. This excellent performance is attributed to the unique hydroxyl structure of the CA terminal and the excellent symmetry of CA in the composite electrode. In aqueous electrolytes, CA can form short chains during charging and the formation of short chains enables the storage of electrons and further provides a large number of new pseudocapacitive reaction sites for MXene. At the same time, the high electronegativity of the N and O atoms in CA also increases the electric double layer capacitor of the composite electrode to a certain extent, thus resulting in a high energy density of the composite electrode.	{MXene,"Nitrogen doping","Triazine polymerization","High energy density"}
761	Ti3C2Tx-MXene based 2D 3D Ti3C2 TiO2 CuTiO3 heterostructure for enhanced pseudocapacitive performance	Muhammad Noman, Mirza Mahmood Baig, Qazi Muhammad Saqib, Swapnil R. Patil, Chandrashekhar S. Patil, Jungmin Kim, Youngbin Ko, Eunho Lee, Jinwoo Hwang, Seung Goo Lee, Jinho Bae	Chemical Engineering Journal	2024	https://doi.org/10.1016/j.cej.2024.156697	https://www.sciencedirect.com/science/article/pii/S1385894724081889	1385-8947	Ti3C2Tx MXene family is a promising electrode material for electrochemical energy storage, but it suffers from insufficient pseudocapacitive charge storage because of self-aggregation and oxidation degradation. To resolve the issue, this paper proposes a two-step process for synthesizing oxidation-controlled MXene-derived 2D 3D heterostructures that beneficially utilize oxidation and simultaneously improve conductivity. The first step generates in-situ 3D floral Ti3C2 TiO2 nanoribbons under partial oxidation of MXene. As the second step, further controlled oxidation with Cu ions transforms the 3D floral Ti3C2 TiO2 nanoribbons into 2D 3D Ti3C2 TiO2 CuTiO3 heterostructure. Leveraging the synergistic effects of MXene, TiO2, and CuTiO3, this 2D 3D heterostructure enhances the interlayered spacing, redox-active site concentration and alleviates low conductivity issue associated with TiO2 nanoribbons. At 2 mA cm2, the proposed 2D 3D Ti3C2 TiO2 CuTiO3 heterostructure achieved a significantly higher capacitance of 599.2 mF cm2, compared to MXene with a capacitance of 249.16 mF cm2 and 3D floral Ti3C2 TiO2 nanoribbons with 498.5 mF cm2. For practical evaluation, an asymmetric supercapacitor (ASC) device (Ti3C2 TiO2 CuTiO3 AC) was fabricated, which exhibited an energy density of 31.1 Wh kg, power density of 1041.7 W kg and capacitance retention of 83.7 after 5000 continuous charging discharging cycles. It opens new avenues for utilizing controlled oxidation to enhance pseudocapacitive properties.	{"MXene modification",Pseudocapacitance,Heterostructures,CuTiO3,"Layered structure"}
762	High-performance flexible supercapacitor based on PEDOT:PSS wrapped delaminated Ti3C2Tx composite: Experimental and DFT validation	Gourab Nandy, Swati Shaw, Subhradip Ghosh, Ashok Kumar Dasmahapatra	Polymer	2025	https://doi.org/10.1016/j.polymer.2025.128185	https://www.sciencedirect.com/science/article/pii/S0032386125001715	0032-3861	Exploring new electrode materials with cyclic stability and energy storage capacity is crucial for high-performance energy storage in portable electronics. Herein, we present PEDOT:PSS (PP) delaminated MXene (d-Ti3C2Tx) binary nanocomposites for electrode material for flexible supercapacitor (FSC). PP d-Ti3C2Tx (1:2 wt ratio, P1M2) on activated carbon cloth results in an excellent specific capacitance of 718.67 F g 1 at a current density of 3.5 A g 1 in 1 M H2SO4. PEDOT chains wrap the d-Ti3C2Tx nanosheets by an opposite electrostatic interaction, while PSS chains act as web-like carrier pathways between two adjacent nanosheets. First principle DFT simulations demonstrate that charge storage in PEDOT:PSS Ti3C2Tx is enhanced compared to PEDOT Ti3C2Tx, which describes the effect of PSS chains in the composite. Computationally obtained absorption spectra align well with experimental results, validating the proposed morphology. To employ the P1M2 electrode for FSC, P1M2-P1M2 symmetric solid-state supercapacitor (SSC) and P1M2-rGO asymmetric solid-state supercapacitor (ASC) have been fabricated using 1 M PVA-H2SO4 gel electrolyte. P1M2-P1M2 SSC and P1M2-rGO ASC exhibit a high specific capacitance of 260.23 F g 1 (0.5 A g 1) and 176.46 F g 1 (0.1 A g 1) receptively. Larger potential window, excellent specific capacitance retention of 89 for 5000 GCD cycles, and great performance retention over the bending and twisting conditions make the ASC device a marvelous candidate for the portable energy storage device. The ASC device shows change in specific energy (specific power) from 35.29 W h kg 1 (240 W kg 1) to 26.22 W h kg 1 (1200 W kg 1). An assembly of three such ASC devices glows a red LED for 2 min.	{Ti3C2Tx-MXene,PEDOT:PSS,"Flexible supercapacitor",DFT,"Charge transfer"}
763	Hierarchical MXene NiCo2S4 electrodes derived from MXene ZIF-67 composites for high-performance supercapacitors	Jiawei Wu, Yuanqing Chen, Xujiang Liang, Haolin Dong, Ying Zhang, Huan Cao, Weibai Bian	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.146774	https://www.sciencedirect.com/science/article/pii/S0013468625011351	0013-4686	MXene-based electrode materials are highly desirable for their remarkable combination of high specific surface area, excellent chemical stability, and superior electrical conductivity. However, these materials face a significant challenge during the charge-discharge process. Specifically, the intercalation and deintercalation of ions can induce changes in the interlayer spacing, thereby compromising the structural integrity and adversely affecting the cycling stability of the electrodes. In this study, we have developed a layered MXene NiCo2S4 composite electrode material using MXene ZIF-67 as the precursor. By leveraging the synergistic interaction between 3D nanospheres and 2D MXene nanosheets, the MXene NiCo2S4 composite demonstrates exceptional electrochemical performance. When assembled into a hybrid supercapacitor (MNCS-1 AC HSC), the device exhibits an impressive areal specific capacity of 2.73 mAh cm2 at a current density of 20 mA cm2. Moreover, it delivers an energy density of 0.97 mWh cm2 at a power density of 34.20 mW cm2. After 10,000 cycles, the capacity retention rate remains at a commendable 86.19 . These experimental results clearly indicate that the electrochemical performance of the MXene NiCo2S4 composite electrode material has been significantly enhanced. This work not only highlights the potential of MXene-based composites but also opens up new avenues for the design and preparation of advanced supercapacitor electrode materials.	{Supercapacitors,MXene,"Electrochemical properties",ZIF-67}
764	Flexible, self-supporting Ti3C2Tx thin film electrodes prepared through vacuum filtration and applied for supercapacitors	Runchen Shi, Mengyang Zhang, Xuehua Yan, Jianmei Pan, Jamile Mohammadi Moradian, Zohreh Shahnavaz	Vacuum	2024	https://doi.org/10.1016/j.vacuum.2024.113326	https://www.sciencedirect.com/science/article/pii/S0042207X24003725	0042-207X	The remarkable characteristics of 2D MXene enable its use in energy storage. However, challenges associated with their oxidation and aggregation can limit their performance in energy storage devices. This study systematically explores the unique low-layer Ti3C2Tx nanosheet microstructure with various thicknesses to analyze their potential as electrode materials in supercapacitors. The morphology analysis revealed the excellent lamellar structure and flexibility of prepared MXene thin film electrodes. The cross-section SEM shows the thin film s orderly, parallel, and compact stacked nanosheets, leading to the excellent flexibility of thin films. The thin film electrode with 17.3 μm thickness exhibited the best electrochemical performance among other samples to achieve a specific capacitance of 293.3 F g 1 at the current density of 1 A g 1. After 8000 cycles, the capacity retention rate is as high as 91 , indicating the high stability of the layered structure of the MXene film. The energy density of the device assembled with MXene thin film electrode can still reach 5.8 Wh kg 1 at 1000 W kg 1 power density. The diffusion control process dominates the electrochemical energy storage behaviour. The assembled symmetric supercapacitor presents a specific capacitance of 54.3 F g 1 at a current density of 1 A g 1.	{"Ti3C2Tx MXene","Layer thickness","2D materials","Thin film",Supercapacitors}
765	1T-VS2 MXene network-like heterostructure realizes ultra-high energy density aqueous ammonium ion hybrid supercapacitors and their charge storage mechanism	Xiaofeng Zhang, Salamat Ali, Peiao Lu, Qian Zhang, Wei Xu, Jiakun Luo, Dan Zhao, Bing Bai, Kui-Qing Peng	Materials Today Energy	2025	https://doi.org/10.1016/j.mtener.2025.101918	https://www.sciencedirect.com/science/article/pii/S2468606925001261	2468-6069	Aqueous ammonium ion-based (NH4+) hybrid supercapacitors (AAHSCs) are attracting great attention because of their environmental friendliness and excellent electrochemical performance. MXenes are highly considered as cathode materials for AAHSCs due to their exceptional electrochemical properties, which include high electrical conductivity, large surface area, tunable surface chemistry, good mechanical stability, and hydrophilicity for aqueous electrolytes. However, the self-stacking effect of 2D materials limits their wide application. In this work, a network-like heterostructure was constructed via in-situ growth of 1T-VS2 nanosheets on the surface of an MXene via a one-step hydrothermal method. The results show that HS-1T-VS MXene has a high capacitance of 570 F g at 1 A g and cycling stability of 96.3 . In addition, the HS-1T-VS MXene AC-AAHSC provides an ultrahigh energy density of 156.9 Wh kg at a power density of 3,240 W kg and still has a capacitance retention of 96.2 after 10,000 cycles. The superior performance is attributed to the heterostructure, which effectively prevents the recombination of carriers and promotes redox reactions. The 1T-VS2 nanosheets are evenly distributed and perpendicular to the MXene surface, reducing charge transfer resistance. This structure increases the specific surface area of the material and provides abundant active sites for the attachment of NH4+. Additionally, the versatile multi-valent redox chemistry and redox activity of Vanadium substantially promote the kinetics of surface redox reactions.	{Supercapacitors,NH4+,"Network-like heterostructure","High energy density",Ti3C2Tx}
766	Practicality of MXenes: Recent trends, considerations, and future aspects in supercapacitors	Iftikhar Hussain, Abdullah Al Mahmud, Sabarison Pandiyarajan, Karanpal Singh, Essam H. Ibrahim, Pritam J. Morankar, Sajjad Hussain, P. Rosaiah, Muhammad Zubair Khan, Zeeshan Ajmal, Bhargav Akkinepally, Ho-Chiao Chuang, Kaili Zhang	Materials Today Physics	2025	https://doi.org/10.1016/j.mtphys.2025.101745	https://www.sciencedirect.com/science/article/pii/S2542529325001014	2542-5293	MXenes, a family of two-dimensional (2D) transition metal carbides and nitrides have garnered significant interest owing to their unique properties, making them suitable for electrode materials in flexible and wearable supercapacitors (SCs). A significant portion of MXenes has predominantly been utilized in a three-electrode configuration, lacking practical applications. Herein, we have conducted a comprehensive review of recent advancements concerning the practical application of MXenes in two-electrode SCs. Critical considerations such as expanding the potential voltage window, optimizing electrolytes, electrode selection, limitations of both electrodes and electrolytes, and exploration of electrode hybridization have been thoroughly investigated. Moreover, we have discussed the latest progress in MXenes and their prospective contributions to advancing SC applications. The future aspects of MXene-based SCs have been proposed, thereby facilitating advancements in energy storage technologies and their tangible integration into real-world electronic applications.	{MXenes,Supercapacitor,"Flexible and wearable electronics",Practicality,"Enhancing voltage"}
767	Enhanced electrochemical energy storage via MXene-doped graphene amine nanohybrids for high-performance supercapacitors	Muskan M. Momin, Bipin S. Chikkatti, Ashok M. Sajjan, T.M. Yunus Khan, Abdul Saddique Shaik, Nagaraj R. Banapurmath, Narasimha H. Ayachit, Shivashankar A. Huddar	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.182767	https://www.sciencedirect.com/science/article/pii/S0925838825043282	0925-8388	This work presents the electrochemical performance of graphene amine (GA) and GA MXene nanocomposite electrodes for supercapacitor applications. Structural and morphological characterization using Fourier-transform infrared spectroscopy (FTIR), X-ray diffraction (XRD), Raman spectroscopy, scanning electron microscopy (SEM), and energy-dispersive X-ray spectroscopy (EDS) confirmed the successful integration of MXene within the porous GA matrix, forming a well-interconnected structure that mitigates the restacking tendency of MXene and enhances ion accessibility and charge transport. Electrochemical measurements including cyclic voltammetry (CV), electrochemical impedance spectroscopy (EIS), potentiodynamic polarization (PDP), and galvanostatic charge discharge (GCD), demonstrated that GA MXene achieved a high specific capacitance of 652.1 F g 1 at 0.75 A g 1, significantly outperforming pristine GA (105.8 F g 1). The GA MXene composite also delivered an impressive energy density of 326.9 Wh kg 1 at 2850 W kg 1, maintaining 183.7 Wh kg 1 at a high power density of 7600 W kg 1. Compared to other MXene-based hybrids, GA MXene offers superior electrochemical stability, rate capability, and structural integrity, retaining 91 capacitance over 6000 cycles. These findings underscore the potential of GA MXene as a stable, high-performance electrode material for next-generation energy storage devices.	{"Graphene amine",MXene,Composite,Supercapacitors,"Specific capacitance"}
768	Ni nanorods with various morphologies on the surface of Ti3C2Tx MXene nanosheets accelerate alkaline hydrogen evolution reaction	Zengkun You, Kai Ou, Tian Tang, Yajing Cui, Wenting Zhang, Yuxiang Ni, Yudong Xia, Hongyan Wang	Applied Surface Science	2025	https://doi.org/10.1016/j.apsusc.2025.163886	https://www.sciencedirect.com/science/article/pii/S0169433225016010	0169-4332	Under the background of sustainable energy development, the development of efficient, stable and low-cost electrocatalysts to improve electrochemical performance has become a research hotspot in the field of energy conversion. In this work, upright, one-fold and oblique Ni nanorods were designed and grown on Ti3C2Tx MXene nanosheets via glancing angle deposition technique of physical vapor deposition. For the hydrogen evolution reaction, the composite Ti3C2Tx upright exhibited a low overpotential of only 131 mV 10 mA cm2, along with excellent 24 h stability in 1 M KOH. Its excellent performance is mainly attributed to the high porosity of the upright nanorods, the fast electron transport channels provided by Ti3C2Tx MXene, and the stable interface structure. This research provides new ideas for constructing high-performance electrocatalytic catalysts and achieving efficient electrocatalytic conversion in sustainable energy systems.	{HER,GLAD,"Ni nanorods","Ti3C2Tx MXene"}
769	Mechanically endurable Ti3C2Tx MXene incorporated P(AM-AA) hybrid hydrogel electrolyte with enhanced Zn2+ conductivity for flexible zinc-ion batteries	Aakash Carthick Radjendirane, Senthilkumar Ramasamy, Saradh Prasad Rajendra, G. Murali, Insik In, Seung Jun Lee, Subramania Angaiah	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.146368	https://www.sciencedirect.com/science/article/pii/S0013468625007297	0013-4686	Zinc-ion batteries (ZIBs) are severely affected by poor Zn stripping platting behaviour that causing dendrite growth, hydrogen evolution and uncontrollable passivation reaction at the Zn metal anode. To overcome the aforementioned concern and also to construct flexible batteries, high ionic conductivity and mechanically robust hybrid hydrogel electrolytes (HHGE) are used as the best alternatives. Herein, a highly stable 2D-Ti-MXene incorporated Poly(acrylamide-co-acrylic acid) based HHGE is developed by a facile one-step chemical crosslinking method. Among three different concentrations of Ti-MXene (0.1, 0.2 and 0.3 wt. ) incorporated Poly(acrylamide-co-acrylic acid), 0.2 wt. of Ti-MXene incorporated P(AM-AA) exhibited excellent ionic conductivity of 20.52 10 3 S cm 1 with a wider 2.4 V electrochemical stability window. The as-prepared hybrid hydrogel displays an outstanding tensile strength of 1.6 MPa than pristine (0.4 MPa). Furthermore, the electrochemical performances of stripping platting clearly demonstrate the dendrite-free behaviour of the Zn-metal anode over the prolonged life span of 1000 h without any short circuits. For the ZIB (Zn V2O5), it achieved an initial capacity of 174 mAh g 1 at a current density of 0.1 Ag 1 with a remarkable long-term stability over 500 cycles with 100 coulombic efficiency. It also remains stable under different bending conditions, indicating its potential candidate for high-performance flexible ZIB.	{"Ti3C2Tx MXene","Hydrogel electrolyte","Dendrite-free anode",V2O5,"Flexible zinc-ion battery"}
770	Fabrication of MXene reduced graphene oxide MoO3 film electrode for flexible supercapacitors	Ruidong Li, Lihua Chen, Shuxin Song, Bingyue Zheng, Tingxi Li, Wenhui Zheng, Yong Ma	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117669	https://www.sciencedirect.com/science/article/pii/S2352152X25023825	2352-152X	MXene nanosheets exhibit a tendency to agglomerate in electrochemical processes, significantly impairing the electrochemical performance and diminishes their practical applicability. However, this problem can be effectively suppressed by introducing functional intercalation materials. Herein, MXene reduced graphene oxide (rGO) MoO3 films synthesized utilizing a vacuum-assisted filtration technique. MoO3 nanofibers and rGO nanosheets serve as essential intercalation materials, establishing a highly stable interlayer configuration within MXene nanosheets. This arrangement significantly increases the spacing between the MXene layers, thereby facilitating the development of a multidimensional and efficient ion transport pathway and exposing more active sites. Under the synergistic effect of this composite structure, the film exhibited a specific capacitance of 854.2 F g 1 at 1 A g 1. In addition, an asymmetric supercapacitor (ASC) assembled with MXene rGO MoO3 film as the positive electrode and activated carbon (AC) as the negative electrode shows a wide voltage window of 1.6 V and achieves a high energy density of 54 Wh kg 1 at a power density of 800 W kg 1. More importantly, at 3 A g 1, this ASC maintained 85.4 capacitance retention after 14,000 cycles, demonstrating excellent cycling stability. The optimization strategy for the MXene rGO MoO3 electrode not only illustrates the technological progress of MXene within the domain of energy storage but also establishes a robust technological framework and theoretical underpinning for its utilization in flexible energy storage devices.	{MXene,"Reduced graphene oxide",MoO3,"Film electrode",Supercapacitor}
771	Nonhazardous in-situ exfoliation approach for Ta-Nb2CTx MXenes as sustainable supercapacitor electrode applications	Uzair Ahmed, Ghulam Nabi	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237745	https://www.sciencedirect.com/science/article/pii/S0378775325015812	0378-7753	Utilization of hydrofluoric acid (HF) for exfoliation of MXenes by etching is common but it is extremely hazardous due to its toxic and corrosive nature. Here, direct use of HF is avoided and an in-situ exfoliation approach has been developed which successfully exfoliates the MAX phase of Nb2AlC into multilayered Nb2CTx and Ta-doped Nb2CTx MXenes. Being MXene family, the Nb2CTx owing a set of characteristics with tunability by ions doping based material defects making it a promising contestant for supercapacitor electrodes applications. It has been observed that 6 wt Ta-Nb2CTx exhibited enhanced specific capacity of 454.4 Cg-1 and highly sustainable cyclic stability of 88 retention after 12000 CV cycles, attributed to additional active sites by Ta doping, intercalation, increased exfoliation and optimal surface terminations. The power law displays a pseudocapacitive nature (b = 0.61) and the Dunn method shows increasing trend of capacitive contribution with scan rate. The fabricated asymmetric 6 wt Ta-Nb2CTx AC (Activated Carbon) based supercapacitor showed energy density (ED) of 47.5 Whkg 1 and a power density (PD) of 500 Wkg-1. These findings open up a perspective way of environment friendly and nonhazardous exfoliation, incorporation of metallic ions into Nb2CTx MXene, and their application in energy storage devices.	{"Nonhazardous exfoliation","Ta-Nb2CTx MXenes","Power law","Pseudocapacitive nature","Asymmetric supercapacitor"}
772	Green synthesis of MXene TiO₂ nanocomposites for high-performance flexible supercapacitors: Synergistic enhancement via polypyrrole polymerization and dopant engineering	Hatice Yasemin Ulgunar Iskender, Osman Eksik, Melih Besir Arvas, Sibel Yazar	Synthetic Metals	2025	https://doi.org/10.1016/j.synthmet.2025.117915	https://www.sciencedirect.com/science/article/pii/S0379677925000918	0379-6779	Titanium dioxide (TiO2) is a material with high chemical stability and safety characteristics, offering a large energy storage capacity. MXene (Ti₃C₂Tₓ transition metal carbides), on the other hand, is notable for its high electrical conductivity and excellent ion transport properties. These materials serve as ideal electrode materials for high-capacity, fast-charging, and long-cycle-life batteries and supercapacitors. In this study, nanoparticles with dimensions of 13 60 nm were successfully synthesized using the green synthesis method. The interface size that enhances electrode electrolyte interaction in supercapacitor electrode materials and the presence of materials exhibiting redox behavior increased the supercapacitor performance of polypyrrole (PPy) by 16 times. The charge storage properties of PPy MXene, PPy MXene TiO2GC, and PPy MXene TiO2GC electrode materials at different concentrations and through different synthesis methods were compared. The electrode material manufactured at PPy(10 mg) MXene TiO2GC(20 mg) weights exhibited a specific capacitance value of 467.7 F g 1, determined at a scan rate of 5 mV s 1 in the 3-electrode system. A symmetrical device was created from the electrodes formed by coating this electrode material on wearable flexible carbon felt. According to the results obtained, the highest energy density achieved was 5.0 Wh kg at 0.1 mA cm 2, and the highest power density value achieved was 1000 W kg at 1.0 mA cm 2. It was observed that the symmetrical supercapacitor with 10,000 cycles retained 82.03 of its capacitance.	{"Energy storage",Supercapacitor,MXene,"Green synthesis",Polypyrrole}
773	MXene-modified and electrochemically enhanced polyaniline hydrogels for flexible asymmetric supercapacitors	Yubo Zou, Huili Liu, Guocong Liu, Binyi Yang, Jiajia Li, Shanxing Wang, Kaiping Xie, Chunhua Wang, Shahid Iqbal	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.116373	https://www.sciencedirect.com/science/article/pii/S2352152X25010862	2352-152X	Efficiently preparing polyaniline (PANI) supercapacitor electrode materials with exceptional electrochemical performance is vital for their utilization in energy storage devices, notwithstanding the difficulties involved. We developed a direct hydrothermal assembly approach to construct MXene-modified PANI hydrogel (M-PANI) using PANI dispersion modified by highly conductive MXene. The findings suggest that the breakdown of MXene nanosheets and the conversion into TiO2 from part of MXene by hydrothermal treatment may notably boost the electrochemical performances of M-PANI hydrogels. The prepared M-PANI hydrogel electrodes exhibit high specific capacitance (483.1 F g 1 at 1 A g 1), superior rate capability (79.8 from 1 to 20 A g 1), and valuable cycling durability (80 of initial capacitance after 6000 cycles). The flexible asymmetric supercapacitors (MXene M-PANI) were further assembled using MXene as anode and M-PANI as cathode materials, which achieve high specific capacitance (128.2 F g 1 at 1 A g 1), satisfying energy density (23.6 W h kg 1 at 575 W kg 1), and favorable cycling durability (89.4 retention of the initial capacitance after 9000 cycles). The generated M-PANI hydrogels with remarkable electrochemical performances as supercapacitor electrodes suggest their enormous potential in the field of cutting-edge energy storage technology.	{Hydrogels,Modified,"Asymmetric supercapacitors",MXene,Polyaniline}
774	Synthesis and electrochemical performance of a novel CuCoTex Mn3O4 MXene ternary nanocomposite electrode for hybrid-supercapacitor	Padmanaban Annamalai, Kanimozhi Selvadhas Nirmala, Sivaraj Durairaj, Hector Valdes, Anandan Sambandam, Arunachalam Arulraj, Manoj Devaraj, Chandra Kumar	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.182401	https://www.sciencedirect.com/science/article/pii/S0925838825039623	0925-8388	The increasing global shift towards renewable energy emphasizes the urgent need for improved energy storage technologies, particularly in supercapacitors, where the advanced electrode materials can significantly enhance the performance. The rise of metal chalcogenides as electrode material in supercapacitors offers promising electrochemical conductivity with abundant electroactive sites. However, the traditional metal chalcogenides cannot meet the requirements for high energy density due to their inherent low conductivity and slower ionic diffusion channels which is necessary for commercial viability due to their inherent low conductivity and slower ionic diffusion channels. Among the different metal chalcogenide materials being studied, bimetallic copper-cobalt telluride (CuCoTex) is gaining attention due to its high specific capacitance, excellent conductivity, and strong electrochemical stability. Despite these promising properties, the application of CuCoTex as an electrode material in supercapacitors remains relatively underexplored. In this study, a novel ternary nanocomposite consisting of copper cobalt telluride (CuCoTex), manganese oxide (Mn3O4), and titanium carbide (Ti3C2Tx) MXene was synthesized via a one-pot method for the first time as an electrode material for supercapacitors. This new nanocomposite leverages the strengths of each constituent: CuCoTex provides superior conductivity and electrochemical reactivity, Mn3O4 offers rich redox chemistry and high theoretical capacitance, and Ti3C2Tx MXene delivers exceptional conductivity and mechanical stability. The ternary nanocomposite achieved a specific capacitance of 127 F g at 1 mA cm2, surpassing the 100 F g of CuCoTex alone, and demonstrated an energy density of 6.2 Wh kg and power density of 54 W kg. It also exhibited excellent cyclic stability with 91 retention after 2500 cycles. The incorporation of MXene further optimizes charge transport and enhances the structural integrity of the nanocomposite, addressing the conductivity limitations of Mn3O4. These findings represent the first successful integration of CuCoTex, Mn3O4, and MXene in a single hybrid electrode and offer a scalable pathway towards high-performance, durable energy storage systems for renewable energy applications.	{CuCoTex/Mn3O4/MXene,"Ternary electrode materials","MXene-based nanocomposite","Hybrid supercapacitor","Binary metal telluride"}
775	Nitrogen-doped MXene for supercapacitor: A review	Ahmed Jalal Salih Salih, Ahmad Huseyin	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117521	https://www.sciencedirect.com/science/article/pii/S2352152X25022340	2352-152X	Efforts to enhance the properties of MXene have been ongoing since its discovery in 2011. Various strategies have been explored to improve its performance for many applications. One such strategy is doping MXene with heteroatoms. Doping has been studied for several applications, including supercapacitors, with particular attention given to nitrogen doping. This review focuses on doping MXene with nitrogen for supercapacitor applications. It discusses the effects of doping on the chemical, physical, and structural properties of MXene, the doping mechanisms (lattice substitution, functional substitution, and surface adsorption), and the contributions of each mechanism to the enhancement of electrochemical performance. Additionally, the review discusses doping methods and their impact on the performance of MXene as supercapacitor electrodes. It presents results from experimental studies and discusses several of these findings. Finally, it provides recommendations to guide future research and optimize outcomes in this field.	{N-MXene,Supercapacitor,"Doping mechanisms",Nitrogen}
776	Defect enriched luminescent MXene-derived TiO2 for supercapacitors	Ghrutanjali Sahu, Annu Balhara, Laxmidhar Besra, Divya Nechiyil, K. Sudarshan, Jyoti Prakash, Santosh K. Gupta, Sriparna Chatterjee	Inorganic Chemistry Communications	2024	https://doi.org/10.1016/j.inoche.2024.113462	https://www.sciencedirect.com/science/article/pii/S1387700324014527	1387-7003	To utilize the intriguing properties of MXene and titania, here in this work, we have synthesized defect-enriched TiO2 by thermal annealing of MXene phase (Mxene-derived-TiO2) and characterized using X-ray diffraction, Raman spectroscopy, Field emission, and transmission electron microscopy. Such uniquely derived MXene-derived-TiO2 displayed bright blue light photoluminescence (PL) under near UV excitation. The electrochemical analysis underscores the superior electrochemical performance of MXene-derived-TiO2, particularly in terms of specific capacitance and pseudocapacitive behavior, making them highly suitable for supercapacitors. The oxygen and titanium vacancies present in MXene-derived-TiO2 are responsible for its excellent PL and supercapacitor action. Such defect-induced origin of PL and supercapacitive action is further validated by the addition of NiO. Electron paramagnetic resonance (EPR) and positron annihilation lifetime spectroscopy (PALS) suggested addition of NiO to Mxene-derived-TiO2 leads to a reduction in defect density of titanium vacancies and is reflected in the lowering of PL intensity and resulted in inferior supercapacitive properties.	{"Ti3C2Tx MXene",Nanocomposites,"MXene-derived TiO2",Luminescence,Supercapacitor}
777	Fabrication of Ti3C2Tx MXene polyaniline composite films with adjustable thickness for high-performance flexible all-solid-state symmetric supercapacitors	Wenlong Luo, Yudi Wei, Zhao Zhuang, Zhongtai Lin, Xue Li, Chunping Hou, Tingxi Li, Yong Ma	Electrochimica Acta	2022	https://doi.org/10.1016/j.electacta.2022.139871	https://www.sciencedirect.com/science/article/pii/S0013468622000433	0013-4686	In here, we successfully fabricated flexible Ti3C2Tx (MXene) polyaniline (PANI) films with adjustable thickness by changing the amount of PANI nanofibers utilized as high-performance supercapacitor electrode materials. Firstly, MXene nanosheets and PANI nanofibers were prepared by the minimum strength stratification method and the redox method, respectively. And then the MXene PANI films were synthesized by simple physical mixing and suction filtration of these two components. The electrochemical performances of the composite films show that the introduction of PANI nanofibers increases the specific capacitance of the MXene film. The reason is that conductive PANI nanofibers can not only provide a path for charge carriers, but also increases MXene layer spacing beneficial to electrolyte ion infiltration. However, with increasing amount of PANI nanofibers, the specific capacitance of the composite film shows a trend of first increase and then decrease. This fact is a result of that excess PANI nanofibers lead to an increase in the thickness of the composite film, which increases the ion and electron transport paths. The assembled device based on the optimal composite film exhibits a high specific capacitance of 272.5 F g 1 at 1 A g 1 and a capacitance retention rate of about 71.4 after 4000 cycles at 2 A g 1. The devices exhibited a high energy density of 31.18 Wh kg 1 at a power density of 1079.3 W kg 1, indicating that it has excellent energy storage performance.	{MXene,"PANI nanofibers","Composite film",Flexibility,"Electrochemical properties"}
778	MoO3-x-assisted MXene-derived TiO2 C-graphene composite structure for high-capacitance electrode materials of ionic liquid-based supercapacitors	Liangqi Jing, Yujuan Chen, Li Sun, Kelei Zhuo, Dong Sun, Xiao Su, Mengya Yang, Jianji Wang	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.118034	https://www.sciencedirect.com/science/article/pii/S2352152X25027471	2352-152X	Supercapacitors (SCs) are considered among the most promising energy storage solutions for future application. Ionic liquid (IL)-based electrolytes, characterized by their wide electrochemical stability windows, noninflammability, and low toxicity, are considered one of the most ideal electrolyte types for use in SCs. However, because of the substantial ion size for ionic liquids, the advancement of energy density in IL-based supercapacitors is hampered by diminished charge storage capacities of electrode materials within IL electrolytes. Herein, we demonstrate a MoO3-x-assisted MXene-derived TiO2 C-graphene composite material (Mo-MX-G) synthesized by in-situ growing MoO3-x nanoparticles on the surface of MXene-derived TiO2 C-graphene composites in one-step hydrothermal process. In the hybrid material, TiO2 nanoparticles and α-MoO3-x nanoparticles form heterostructures which are beneficial to charge transport and storage. Anatase TiO2 and α-MoO3-x nanoparticles exhibit advantageous crystal structures for Li-ion storage and transfer, evidenced by their remarkable capacity. These nanoparticles are anchored on an amorphous carbon substrate to boost the composite s electrical conductivity. Owing to synergistical effects of its constituent components, the composite material exhibits significantly enhanced charge storage performance in IL-based electrolytes, achieving a specific capacitance of 353.8 F g 1. An assembled asymmetric SC device (UPGA Mo-MX-G, UPGA refers to urea phosphate-derived graphene aerogel) exhibits an energy density of 28.3 W h kg 1 at a power density of 1193 W kg 1. This work provides an advanced strategy for designing high-performance hybrid materials utilized in IL-based SCs.	{Supercapacitor,"MXene-derived TiO2","High specific capacitance","Ionic liquid-based electrolyte","Energy storage ability"}
779	A review of recent progress in the synthesis of 2D Ti3C2Tx MXenes and their multifunctional applications	Mojtaba Rostami, Alireza Badiei, Ghodsi Mohammadi Ziarani	Inorganic Chemistry Communications	2024	https://doi.org/10.1016/j.inoche.2024.112362	https://www.sciencedirect.com/science/article/pii/S1387700324003459	1387-7003	In the last decade, two-dimensional (2D) transition-metal carbides and or nitrides identified as MXenes (Mn+1XnTx) have shown great potential owing to their unique electronic and chemical properties such as high metallic conductivity, hydrophilicity, various surface termination functional groups (Tx), and sheet-like 2D structures. Most recent years, molten salt (MS) Shielded Synthesis (MS3) has been prepared 2D Ti3C2Tx MXenes with controllable morphology and surface termination functional groups, eco-friendly, low-cost, fast and large production for versatile applications. Furthermore, a MS etching strategy utilizing Lewis acidic salts as etchants has been proposed to prepare 2D Ti3C2Tx MXenes from MAX phase. This review highlights the recent advances in synthesizing Ti3C2Tx nanosheets using the MS etching method in various fields, including hydrogen evolution reaction (HER), rechargeable batteries (RBs), and supercapacitors (SCs). Utilizing the MS method in the production of Ti3C2Tx nanosheets has demonstrated increased efficiency and has been implemented to increase the density and availability of active chemical and electronic sites for improved performance. Additionally, various nanostructures and hybridizations of low-cost transition metals have been fabricated. The suitability of these materials for multifarious applications has been thoroughly discussed.	{MXenes,"Molten salt‐shielded","Hydrogen evolution reaction","Rechargeable batteries","And supercapacitors"}
780	Scalable assembly of polyaniline Ti3C2Tx MXene modified cotton yarn flexible electrode for high-performance wearable energy storage	Yang Zhang, Shenao Zhang, Kangxin Qi, Yazi Wang, Wei Chen, Jian Xu, Yusen Wang, Diwei Gu, Xiangxiang Pi, Bin Sun, Wangyang Lu	Chemical Engineering Science	2025	https://doi.org/10.1016/j.ces.2025.121206	https://www.sciencedirect.com/science/article/pii/S0009250925000296	0009-2509	Developing miniaturization, adaptability and weavability fiber-shaped supercapacitors (F-SCs), presenting adequate active sites, interconnected electrolyte diffusion channels and good mechanical endurance, has been pivotal issues for controlled, reliable and stable power source in intelligent wearable system. Here, the flexible PANI Ti3C2Tx modified cotton (PTC) yarn electrode was fabricated via coating method on a large scale. Ti3C2Tx flakes regard as a binder and anchor on the cotton yarn along with PANI nanoparticles to construct a conductive framework. Besides, embedding PANI nanoparticles obtaining favorable synergistic effect can not only provide large pseudo-capacitance, but also impede the self-restacking of Ti3C2Tx flakes, causing penetrative ions channels, abundant redox active sites and large surface area. What s more, the tough skeleton of cotton yarn endows remarkable mechanical endurance for electrode and device. As a result, the PTC yarn shows large mass capacitance (417.6F g 1 at 1 A g) and superior rate performance (225.7F g 1 at 10 A g) in three-electrode system. Moreover, the symmetric solid-state F-SCs deliver high capacitance of 175.6F g 1 at 0.5 A g, incredible energy density (6.1Wh kg 1) and stable charge discharge performance (98.5 capacitance retention after 2000 cycling). More importantly, the F-SCs exhibit impressive capacitance retention under deformation settings and ever integrated into the textile, which proves the bright future in the smart garment application.	{Ti3C2Tx,PANI,"Yarn based electrode","Flexible supercapacitors","Favorable mechanical endurance"}
781	Unveiling the potential of M2X MXenes: Structure, properties, synthesis strategies, and supercapacitor applications	Onkar Jaywant Kewate, Iftikhar Hussain, Megha Prajapati, Rita Kumari, Yosephine Intan Ayuningtyas, Dattakumar S. Mhamane, Mukund G. Mali, Mohan V. Jacob, Jeng-Yu Lin, Chhaya Ravi Kant, Sathyanarayanan Punniyakoti	Composites Part B: Engineering	2025	https://doi.org/10.1016/j.compositesb.2025.112237	https://www.sciencedirect.com/science/article/pii/S1359836825001271	1359-8368	2D MXenes have received significant attention due to their remarkable properties, including superior electrical conductivity, chemical stability, tunable surface chemistry, structural flexibility, and excellent thermal and magnetic characteristics, making them highly suitable for supercapacitors. Since their discovery in 2011, M3X2 MXenes have been widely studied, while M2X MXenes, despite their equally impressive properties, have been comparatively less explored. M2X MXenes offer promising potential for a wide range of applications, particularly in energy storage systems like supercapacitors. This review provides a comprehensive overview of the current energy storage crisis and the increasing demand for advanced materials. It introduces the fundamentals of MXenes, with a detailed focus on M2X MXenes, and explains their structure, properties, and various synthesis methods. The review also highlights the application of M2X MXenes in supercapacitors and also provided a detailed discussion of their advantages and challenges. In conclusion, the article outlines the key challenges and future directions in the field, aiming to serve as a valuable guide for MXene research and supercapacitor development.	{MXenes,"M2X MXenes",Structure,Properties,Synthesis,Supercapacitors}
782	Electrochemical investigation of MnMoO4 incorporated MXene Ti3C2Tx for energy storage applications	P. Sivaharini, J. Vigneshwaran, Sujin P. Jose, C. Gopinathan	Materials Letters	2024	https://doi.org/10.1016/j.matlet.2024.136097	https://www.sciencedirect.com/science/article/pii/S0167577X24002350	0167-577X	The storage of massive amounts of energy is a major obstacle to the production of electricity and scientists have been searching for ways to store energy and boost the efficiency. A Manganese molybdenum oxide Titanium Carbide (MnMoO4-Ti3C2TX) composite was successfully synthesized using a one-pot facile hydrothermal method. The structural, morphological, and textural properties of the as-synthesized composite were analyzed through X-ray diffraction (XRD), Scanning Electron Microscopy (SEM), Fourier Transform infrared (FTIR), Energy Dispersive X-Ray Analysis (EDX), and Brunauer Emmett Teller (BET) studies. The phase purity of MnMoO4-Ti3C2TX was confirmed through XRD analysis and the formation of exfoliated Ti3C2TX in the composite is evident from the accordion-like structure observed in SEM images. The capacitance behavior of the MnMoO4-Ti3C2TX composite was demonstrated through cyclic voltammetry (CV), electrochemical impedance spectroscopy (EIS), and galvanostatic charge discharge (GCD) studies. Significantly, the specific capacitance of the composite was determined to be 598 F g 1 at 1 A g 1 in 1 M KOH and a cycling stability of 92.4 even after 10,000 cycles at a constant current density of 3 A g 1. This work highlights the supercapacitive behavior of the MXene-metal oxide composite, suggesting its potential use as electrode material for supercapacitors.	{Supercapacitors,MnMoO4,MXene,Ti3C2TX,Nanosheets,Composites}
783	High-performance hybrid supercapacitors based on MXene SnS2 CNT composites on nickel foam electrodes	Chii-Rong Yang, Yang-Yi Lin, Ching-Tang Lin, Shih-Feng Tseng	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.165826	https://www.sciencedirect.com/science/article/pii/S1385894725066641	1385-8947	This research proposed the synthesized MXene SnS2 CNT composites using a one-step hydrothermal method as the positive electrode for the hybrid supercapacitor (HSC). The MXene SnS2 CNT composites provided high active sites and had the lowest charge transfer resistance of 2.2 Ω and charge transfer resistance of 4.48 Ω. Hence, a high specific capacitance (Cs) of 1049 F g could be obtained at a current density of 1 A g. The Cs of MXene SnS2 CNT at a current density of 1 A g was 10.27, 2.6, and 1.36 times higher than that of MXene (105.37 F g), SnS2 (410.53 F g), and MXene SnS2 (771.03 F g), respectively. This indicated that MXene SnS2 CNT had excellent capacitance performance. When the current density was increased to 10 A g, MXene SnS2 CNT could still maintain a rate capability of 71 . The Cs values of HSC at current densities of 3 and 5 A g were 79 and 61 F g, respectively, which were a good rate capability of 69 and 53 compared to the Cs value of 114 F g at a current density of 1 A g. Furthermore, the HSC exhibited a high power density of 7020 W kg at a low energy density of 11.7 Wh kg. In this study, the developed HSCs were used for LEDs lighting and computer driving.	{"MXene/SnS2/CNT composites","Hydrothermal method","Hybrid supercapacitor","High specific capacitance","High power density"}
784	High performance asymmetric supercapacitors based on Ti3C2Tx MXene and electrodeposited spinel NiCo2S4 nanostructures Electronic supplementary information (ESI) available. See DOI: 10.1039 d2ra00991a	Mansi Pathak, S. R. Polaki, Chandra Sekhar Rout	RSC Advances	2022	https://doi.org/10.1039/d2ra00991a	https://www.sciencedirect.com/science/article/pii/S2046206922010932	2046-2069	ABSTRACT Spinel metal sulfides have been investigated for a wide range of applications mostly in electrochemical energy storage owing to their better electronic conductivity and high reversible redox activity. Herein, we report a facile fabrication approach for the binder-free supercapacitor electrodes based on spinel NiCo2S4 (NCS) on various substrates such as Cu-foil (CF), Ni-foam (NF), and vertical graphene nanosheets grown on carbon tape (VG) via a single step-controlled electrodeposition technique. The obtained electrodeposited NiCo2S4 grown on Cu-foil (denoted as CF-NCS) in symmetric assembly shows a high specific capacitance of 167.28 F g 1 compared to NCS grown on Ni-foam and VG substrates, whereas, symmetric NiCo2S4 grown on a VG substrate device exhibits better cycling performance (81 for 3000 cycles) compared to CF-NCS and NF-NCS. Furthermore, an asymmetric supercapacitor was assembled in combination with MXene (Ti3C2Tx) as a negative electrode (denoted as TCX). As a result, the CF-NCS TCX device exhibits a high areal capacitance of 48.6 mF cm 2 at 2 mA cm 2 of current density. We also report good specific capacitance of 54.57 F g 1 at 2 A g 1; in addition, the CF-NCS TCX assembly delivers maximum areal and gravimetric energy density of 14.86 mWh cm 2 and 14.86 Wh kg 1 respectively. In contrast, the VG-NCS TCX device showed improved cycling stability with 85 of capacitance retention over 5000 cycles owing to its highly porous structure and multiple conductive networks in the VG substrate and provides structural stability to NCS with fast ion diffusion. This experiment favors 2D MXene as a capacitive electrode that provides a replacement for carbon-based electrodes in asymmetric assembly with superior electrochemical performance. Hence, the hierarchical NCS structure grown on the various substrates in combination with MXene serve as a promising material for energy storage application.	{}
785	Ultra-broadband perfect light absorber based on circular truncated cone structure Ti3C2Tx MXene across the visible to near-infrared region	Bingzhen Li, Qingqing Wu, Fangyuan Li, Yan Li, Xiao Zhou, Songlin Yu, Wangjun Ren, Jijun Wang	Physics Letters A	2025	https://doi.org/10.1016/j.physleta.2025.130742	https://www.sciencedirect.com/science/article/pii/S0375960125005225	0375-9601	Broadband perfect light absorbers (PLAs) are critical for advancing technologies such as stealth systems, thermal photovoltaics, and optical imaging, where efficient, spectrum-wide light absorption is essential. Here, we propose a novel, low-cost PLA design featuring a circular truncated cone (CTC) nanostructure composed of Ti₃C₂Tx MXene. Finite element method (FEM) simulations reveal exceptional performance, with over 99.5 average absorbance across 280 1623 nm and a 141.1 relative bandwidth, validated by equivalent circuit modeling (ECM). This efficiency stems from synergistic interactions between guided mode excitation, localized surface plasmon resonances (LSPRs), and intrinsic losses within the CTC geometry. The design maintains >99 absorption, exhibiting polarization- and angle-insensitivity for transverse electric magnetic modes, while geometric tunability enables customization for diverse applications, including solar harvesting, thermoelectrics, and thermal imaging. This work advances PLA technology by delivering ultra-broadband, robust, and adaptable absorption, addressing key limitations in existing designs.	{Visible,Near-infrared,"Light absorber","Ti3C2Tx MXene","Truncated cone structure"}
786	MoSe2 nanosheets anchored on Ti3C2 MXene hybrid nanostructure for boosting electrochemical performance of supercapacitor	Nagaraju Macherla, Manjula Nerella, Ravindranadh Koutavarapu, Jaesool Shim	Materials Chemistry and Physics	2025	https://doi.org/10.1016/j.matchemphys.2025.130765	https://www.sciencedirect.com/science/article/pii/S0254058425004110	0254-0584	The significant advancements in supercapacitor technology promote the hunt for developing innovative electrode materials with enhanced electrochemical properties. This study delves into the comprehensive study of expanded MXene layers (e-Ti3C2Tx) decorated with flower-like MoSe2 nanosheets (MoSe2 e-Ti3C2Tx) with a straightforward hydrothermal method by optimizing synthesis parameters (HF , hydrothermal reaction time). XRD, FESEM, and XPS results revealed that MoSe2 nanosheets are successfully anchored on MXene layers and developed strong interstitial contact. The electrochemical analysis demonstrated significant enhanced energy storage capacity along with promising cycle life for heterojunction MoSe2 e-Ti3C2Tx hybrid nanostructured electrode. The MoSe2 e-Ti3C2Tx hybrid nanostructured electrode delivered a specific capacity of 259 C g 1 at a current density of 0.5 A g 1, whereas MoSe2 delivered only 184 C g 1. In particular, hybrid nanostructure electrodes exhibited excellent cycle life (96.6 after 5000 cycles). Moreover, the supercapacitor device assembled with the MoSe2 e-Ti3C2Tx hybrid nanostructure delivered a maximum energy density of 12.92 Wh kg 1 with power density of 1001.02 W kg 1,and retained 80 of it s capacity after 5000 cycles at 8 A g 1. The enhanced properties of MoSe2 e-Ti3C2Tx hybrid nanostructure clearly reveals its promising application for the advanced supercapacitor.	{Supercapacitor,"MoSe2 microflowers","Ti3C2Tx MXene","Hybrid nanostructure","Electrode material"}
787	In-situ preparation of a fluorine-free MXene MnO2 composite for enhancing performance of supercapacitor	Huifang Zhang, Jie Wang, Xiaohong Song, Mingqiang Liu, Kefeng Xie	Journal of Molecular Structure	2025	https://doi.org/10.1016/j.molstruc.2025.143135	https://www.sciencedirect.com/science/article/pii/S002228602501806X	0022-2860	MXene (Ti3C2Tx) is a promising electrode material for supercapacitors due to its excellent conductivity, high specific surface area, and strong hydrophilicity. However, traditional MXene preparation methods often rely on hazardous hydrofluoric (HF) acid, posing safety risks and environmental concerns. In this study, a fluorine-free MXene synthesis method was developed using a high-concentration NaOH solution combined with KMnO4 as an etchant. MnO2 was incorporated into Ti3C2Tx layers via redox reactions, forming an interlayer structure that effectively inhibits restacking of the in-situ generated Ti3C2Tx nanosheets. Acting as a conductive substrate, Ti3C2Tx facilitates rapid electron transfer and mitigates MnO2 vol expansion during charge-discharge cycles. The resulting Ti3C2Tx MnO2-based supercapacitor demonstrated a high specific capacitance of 182.75 F g and maintained 85.65 capacitance retention after 10,000 cycles. Density functional theory (DFT) simulations further revealed that the Ti3C2Tx MnO2 heterojunction enhances electron transport efficiency. The synergistic interaction between MnO2 and Ti3C2Tx not only improves the overall conductivity but also significantly boosts energy storage capacity. This work presents an environmentally sustainable approach for fabricating high-performance supercapacitors.	{MXene,MnO2,"In-situ synthesis",Supercapacitor}
788	Defect passivation and transformation of Ti3C2Tx MXene hollow microsphere for superior electrochemical performance and sodium-ions storage	Ningning Liu, Xiaochen Zhang, Jinfeng Chen, Fei Yu, Jie Ma	Journal of Advanced Research	2025	https://doi.org/10.1016/j.jare.2025.06.003	https://www.sciencedirect.com/science/article/pii/S2090123225003893	2090-1232	The commercialization of MXene-based electrodes for sodium ion capture in aqueous solutions is limited by poor stability, which is attributed to edge and surface defects. In this study, 3D Ti3C2Tx MXene hollow microsphere (MHM) is constructed, and a systematic defect passivation and transformation approach is presented to achieve the high stability of MHM when employed as electrode material in capacitive desalination (CDI). Metal atom vanadium (V) and non-metal atoms nitrogen (N) and sulfur (S) are meticulously selected to modulate the defect environment of Ti3C2Tx MXene. The doping mechanism is thoroughly investigated using X-ray photoelectron spectroscopy (XPS) and density functional theory (DFT) analysis for the first time: N and S atoms substitute the carbon and replace oxidizable surface groups, V atom bonds with carbon and oxygen and is trapped by Ti vacancy defects. This approach effectively passivates the oxidizable defects and transforms them into new heteroatomic doping defects, leading to the regulation of electronic structure and creation of additional active sites, which enhances stability and sodium capture efficiency for CDI. The optimized N, S, and V co-doped MHM (N, S, V-MHM) electrode shows high electrosorption capacity and rate (141.77 mg g 1 and 2.36 mg g 1 min 1 at 1.2 V) with outstanding cycling stability. In situ EQCM-D measurement underscores the critical role of hydrated sodium ions de adsorption during charging discharging processes. This work elucidates a pathway for constructing high-performance and ultra-stable MXene-based electrodes through defect passivation and transformation.	{"Ti3C2Tx MXene",Stability,"Defect passivation","Capacitive desalination"}
789	Flexible electrode based on multi-scaled MXene (Ti3C2Tx) for supercapacitors	Xuefeng Zhang, Yong Liu, Shangli Dong, Jianqun Yang, Xudong Liu	Journal of Alloys and Compounds	2019	https://doi.org/10.1016/j.jallcom.2019.03.219	https://www.sciencedirect.com/science/article/pii/S092583881931045X	0925-8388	MXenes is one of the most promising flexible electrode materials for supercapacitor. However, the nanosheets in the MXenes electrode by vacuum filtration are prone to restack during preparation, which largely hinders the full utilization of their surfaces and active sites. In this contribution, the self-restacking of MXene nanosheets (prepared by etching with HCl + LiF) could be prevented effectively by introducing MXene nanoparticles (prepared by etching with HF) as interlayer spacers. The Ti3C2Tx-10 flexible (the electrode with 10 mass fraction nanoparticles) exhibits an excellent specific capacitance of 372 F g 1 at 1 A g 1 which is much higher than that of Ti3C2Tx film, and an impressive cycling stability up to 95 capacitance retention after 5000 cycles. The significant improvement in electrochemical performance is mainly due to that the open sandwich-like structure of the flexible electrode based on multi-scaled Ti3C2Tx provides huge surface area and more active sites.	{MXene,"Flexible electrode",Supercapacitors,Ti3C2Tx,Nanosheets,Nanoparticles}
790	Hydrothermal synthesis of layered NiS2 Ti3C2Tx composite electrode for supercapacitors	Lijun Si, Qixun Xia, Keke Liu, Wen Guo, Nanasaheb Shinde, Libo Wang, Qianku Hu, Aiguo Zhou	Materials Chemistry and Physics	2022	https://doi.org/10.1016/j.matchemphys.2022.126733	https://www.sciencedirect.com/science/article/pii/S0254058422010392	0254-0584	MXene shows potential to be used as electrodes in energy storage devices due to its unusual layered structure. MXene-based electrodes can store high rate faradaic pseudocapacitive energy because of their high surface area, metallic conductivity, thermal chemical stability, and quick surface redox reactions. We present a hierarchy of NiS2 MXene nanohybrids made using a simple and low cost hydrothermal method. The strong interfacial connection and good electronic coupling between the NiS2 nanocube and MXene nanoplates improve structural stability and electrical conductivity as well as the electrolyte ion diffusion kinetics. Therefore, the obtained battery-type NiS2 MXene composite electrodes delivered 72.0 mAh g 1 at a current density of 1 A g 1 with high cycle stability in 1 M KOH electrolyte, and the fabricated asymmetric supercapacitor (ACS) demonstrates energy densities of 15.4 Wh kg 1 at power density of 351.6 W kg 1. It elucidates the mechanism and strategy for the development of MXene-based nanohybrid materials for electrochemical energy storage devices.	{MXene,"Nickel sulfide","Two-dimensional materials",Supercapacitor}
791	Facile synthesis of Ti3C2Tx MXene nanosheets using aryl diazonium tetrafluoroborate for multiple applications	Bibek Chaw pattnayak, Niranjan Panda, Sasmita Mohapatra	Carbon	2024	https://doi.org/10.1016/j.carbon.2024.119609	https://www.sciencedirect.com/science/article/pii/S0008622324008285	0008-6223	The development of an HF-free and environmentally benign method for etching the middle aluminum layer (Al) from the Ti3AlC2-MAX phase is a challenging task in titanium carbide (Ti3C2Tx) MXene synthesis. Herein, we designed a diazonium salt-based ultrasonic method to prepare MXene. We have explored 4-carboxy benzene diazonium tetrafluoroborate (4-CBDF) as a delaminating agent, which can dissolve the Al layer directly from the MAX phase. 4-carboxy benzene diazonium (4-CBD+) ion promotes the intercalation as well as exfoliation simultaneously during the etching of the MAX phase and directly results in Ti3C2Txnanosheets without undergoing any additional delamination process. Synthesized MXene nanosheets show excellent photothermal performance with a conversion efficiency of 59 . This MXene-coated GC electrode exhibits the highest capacitance of 1133 F g at a current density 1 A g, which maintains a retention capacitance of 91 even after 10,000 GCD cycles. The present method provides a fundamental insight into the development of MXene-based next-generation photothermal materials and supercapacitors.	{HF-Free,MXene,Supercapacitor,Photothermal}
792	Hydrothermal synthesis of MoS2 MXene composites for high-performance supercapacitors	Jung-Jie Huang, Yu-Wu Wang, Yu-Jie Lin, Yu-Xuan Zhang	Materials Today Communications	2025	https://doi.org/10.1016/j.mtcomm.2025.111864	https://www.sciencedirect.com/science/article/pii/S2352492825003769	2352-4928	This study explores the use of an MXene framework as a substrate for MoS2 nanomaterials in supercapacitor thin-film electrodes, tackling the issues of reduced specific capacitance and poor energy storage performance caused by MoS2 agglomeration. The results show that integrating MoS2 with the MXene base effectively reduces agglomeration, enhancing structural stability and conductivity. After annealing, the MoS2 phase shifted from a mixed 1 T 2H to a more stable 2H phase, optimizing the composition and increasing crystallinity. Consequently, the specific capacitance of the MoS2 MXene electrode rose from 60.41 to 88.00 F g, representing a 1.46-fold improvement in electrochemical performance. Notably, after 15,000 charge discharge cycles, the electrode retained 100 of its capacitance, demonstrating outstanding cycling stability. Overall, the findings confirm the high electrochemical reversibility and long-term stability of MoS2 MXene composites, positioning them as promising candidates for advanced energy storage applications.	{Supercapacitor,MoS2,Ti3C2Tx,"Hydrothermal process","Capacitive retention"}
793	High-performance supercapacitor based on 3D Ti3C2Tx electrodes and sulfonated lignin gel electrolyte	Jiabei Li, Tursun Abdiryim, Ruxangul Jamal, Kai Song, Hongtao Yang, Jiachang Liu, Yanqiang Zhou, Guoliang Zhang, Wenjing Zhang, Jinglei Chen	Journal of Colloid and Interface Science	2025	https://doi.org/10.1016/j.jcis.2025.137948	https://www.sciencedirect.com/science/article/pii/S0021979725013396	0021-9797	Supercapacitors are highly efficient energy storage systems. The electrode substances and electrolytes, which form their primary components, are key areas of research for scientists. In this study, the transition metal material Ti3C2Tx and Poly(3,4-ethylenedioxythiophene) (PEDOT)-based polyacrylamide dual-crosslinked network polymers with good conductivity are selected as the cathode material and gel electrolyte, respectively. To address issues such as self-aggregation of Ti3C2Tx during use, insufficient energy density, and poor dispersibility of 3,4-Ethylenedioxythiophene (EDOT) during the preparation of the hydrogel, polystyrene nanospheres are first used as templates to convert Ti3C2Tx from a two-dimensional sheet to a three-dimensional spherical structure, followed by the introduction of bimetallic cobalt nickel hydroxide (CoNi-OH) to effectively enhance its performance. In addition, sulfonated lignin (SL) is incorporated into the hydrogel to improve the dispersibility of PEDOT in water-based solvents, promoting the development of a uniform hydrogel. The results show that the fabricated composite CoNi-OH 3D Ti3C2Tx exhibits a specific capacitance of up to 2020 50F g 1 at a current density of 1 A g 1. The assembled asymmetric supercapacitor demonstrates a specific capacitance of 278.3 30F g 1. At a power density of 750 W kg 1, it exhibits an energy density of 87 Wh kg 1. After 7,000 cycles of testing, the device shows a Coulombic efficiency of 99.4 0.1 and maintains 83.7 0.2 of its initial capacitance at a current density of 3 A g 1. These findings indicate that the CoNi-OH 3D Ti3C2Tx electrodes and PEDOT SL gel electrolytes have significant potential for development in the energy storage field.	{"3D Ti3C2Tx",CoNi-OH,"Acrylamide hydrogel",Supercapacitor}
794	High-performance Zn-ion hybrid supercapacitor based on 3D K+-intercalated Ti3C2TX hydrogel cathode	Haiping Wang, Xingyu Wang, Xinmiao Liu, Shuwei Zhang, Shutong Meng, Wenjie Yan, Xin Zhang, Zhansheng Lu, Zenghui Qiu, Haijun Xu, Jiaqi He	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.179588	https://www.sciencedirect.com/science/article/pii/S0925838825011466	0925-8388	Aqueous zinc-ion hybrid supercapacitors (ZHSCs) exhibit great potential for energy storage and conversion devices, owing to their inherent safety and cost-effectiveness. Nevertheless, the structure of traditional porous carbon cathodes hinders the zinc-ion diffusion kinetics, rendering the energy densities of conventional ZHSCs uncompetitive and severely impeding their practical applications. 2D transition metal carbides nitrides, known as MXenes, exhibit excellent conductivity and abundant surface functional groups, qualifying them as ideal candidates for constructing high-capacity cathodes in high-performance ZHSCs. This study presents the fabrication of a ZHSC utilizing 3D porous K+-intercalated Ti3C2TX-reduced graphene oxide (K+-Ti3C2TX-RGO) hydrogel as cathode, paired with a zinc foil as anode. Upon treatment with KOH solution, Ti3C2TX undergoes K+ ion intercalation into its nanosheets, resulting in partial elimination of terminal -F groups and expansion of the MXene interlayer spacing. Subsequently, large-scale graphene oxide (GO) was employed as a conductive binder to interconnect the intercalated multilayer Ti3C2TX, and a reducing agent was incorporated to facilitate self-assembly into a hydrogel. This approach augmented the accessibility of ions and facilitated their transport within the resultant structure. The ZHSC, fabricated with this composite cathode, synergistically integrates the supercapacitor s high-power density and the battery s high energy density. The results indicate that the ZHSC exhibited excellent electrochemical performance, featuring a high specific capacitance of 253.86 F g 1 at 1 A g 1 and an impressive energy density of 141.03 Wh kg 1 at 999.99 W kg 1. Notably, after 5000 charge-discharge cycles at 10 A g 1, the ZHSC maintained a capacitance retention rate above 87.96 , highlighting its exceptional cycling stability.	{"Ti3C2TX MXene","K+ intercalation","Graphene oxide","3D porous hydrogel","High energy density","Zinc-ion hybrid supercapacitors"}
795	ZIF-8 Co-C3N4-GNR MXene nanocomposites: A novel electrode material with excellent electrochemical properties for supercapacitors	Rozhin Darabi, Mehdi Shabani-Nooshabadi	Alexandria Engineering Journal	2025	https://doi.org/10.1016/j.aej.2025.07.045	https://www.sciencedirect.com/science/article/pii/S1110016825008683	1110-0168	The combination of MXenes with metal-organic frameworks (MOFs), along with the incorporation of graphene nanoribbons (GNRs), results in highly promising materials for energy storage applications. Owing to their unique structure, high porosity, and strong interfacial connectivity, these composites exhibit excellent mechanical stability and enable rapid ion and electron transport. The synergistic integration of MXenes, MOFs, and GNRs with the excellent electrical conductivity and 2D structure of MXenes, high porosity and tunable surface area of MOFs, and the mechanical strength and flexibility of GNRs, provides the composite with a high surface area, excellent electrical conductivity, and robust structural stability. In this study, we report a multi-component nanocomposite, ZIF-8 Co-C₃N₄-GNR MXene, synthesized using a simple method. Key factors influencing capacitance, power density, and energy density were optimized to achieve superior electrochemical performance. According to our knowledge, this is the first synthesis of this specific composite structure, offering strong potential for advanced supercapacitor design. Electrochemical performance was evaluated using cyclic voltammetry (CV), galvanostatic charge discharge (GCD), and electrochemical impedance spectroscopy (EIS). The ZIF-8 Co-C₃N₄-GNR MXene composite demonstrated a high specific capacitance of 1125 F g ¹ at a current density of 1 A g ¹ , with an energy density of 100 Wh kg ¹ and a power density of 400 W kg ¹ . Furthermore, it maintained approximately 87 of its initial capacitance after 10,000 cycles, highlighting the nanocomposite s strong potential as an electrode material for high-performance asymmetric supercapacitors and its suitability for next-generation electronic devices.	{MXenes,MOF,Supercapacitor,"Specific capacitance",Asymmetric}
796	Review: 2D MXenes based electrochemical sensors and supercapacitors for biomedical and energy storage applications	Sourav Karmakar, Anuprava Mandal, Naresh Kumar Mani, Rinky Sha	Materials Chemistry and Physics	2025	https://doi.org/10.1016/j.matchemphys.2025.130974	https://www.sciencedirect.com/science/article/pii/S0254058425006200	0254-0584	MXenes, composed of early transition metal carbides and or nitrides, have become one of the most versatile two-dimensional materials. High metallic conductivity, tunable surface chemistry, rich surface functional groups, large specific surface area, good redox capabilities, hydrophilicity, high energy storage ability, layered structure for ion intercalations, and other remarkable properties have made MXenes increasingly popular in a range of scientific applications, including sensors and energy storage. A thorough analysis of the characteristics and synthesis routes of MXenes is presented, highlighting the importance of these approaches in tailoring MXene nanostructures for use in supercapacitors and sensing. The recent advancements in MXene-based electrochemical sensors for the detection of several vital biomolecules, such as glucose, ascorbic acid, uric acid, dopamine, microRNAs, l-methionine, melatonin, cortisol, etc., are fully inspected in this review paper with a focus on sensing performances, including sensitivity, limit of detection, selectivity, dynamic range, stability, linearity, and their viability in real samples. Further, this review highlights various MXenes based electrodes, including pristine MXenes, doped MXene, MXenes carbonaceous nanocomposites, MXenes transition metal oxide composites, MXenes transition metal-dichalcogenides composites for the application of supercapacitors, emphasizing their usefulness in practical applications as well as their capacitive characteristics, including specific capacitance, cyclic stability, energy and power densities, and others. A deeper understanding of how MXenes is attributed to each supercapacitor is provided by discussing basic charge-storage mechanisms. The limitations of the current methods and the future outlooks of MXenes based electrochemical biosensors and MXenes based supercapacitors are also discussed where appropriate.	{MXenes,Synthesis,Biomarkers,Point-of-care,Supercapacitors,Energy-storage}
797	MnOx Ti3C2Tx MXene Carbon Nanofibers composite fiber film electrode with good flexibility derived by combining electrospinning technique with carbonization treatment	Bingshan Kong, Chenji Xia, Xiaoqing Bin, Bowen Gao, Wenxiu Que	Materials Letters	2024	https://doi.org/10.1016/j.matlet.2024.136160	https://www.sciencedirect.com/science/article/pii/S0167577X24002982	0167-577X	The restack of MXene nanosheets greatly affects its electrochemical performance and application, while electrospinning technique can spin two-dimensional MXene nanosheets into one-dimensional nanofibers, which can prevent the self-stacking of MXene nanosheets. Herein, MnOx Ti3C2Tx MXene CNFs (carbon nanofibers) composite fiber films with good flexibility were prepared by combining an electrospinning technique and a carbonization treatment, in which the pseudo capacitive material MnO2 mixed with carbon nanotube (CNT) was introduced into Ti3C2Tx MXene. The synergistic effect of MnOx, Ti3C2Tx MXene and CNFs improves the capacitance and flexibility of the composite fiber film, and the specific capacitance of the MnOx Ti3C2Tx MXene CNFs fiber film electrode delivers 211.57 F g 1 at a scanning rate of 2 mV s 1. After 3000 cycles at a current density of 5 A g 1, it can still maintain 95 of the initial capacitance. The results indicate that the MnOx Ti3C2Tx MXene CNFs composite fiber films have great potential for flexible supercapacitors.	{"Ti3C2Tx MXene",Electrospinning,"Carbonized fiber film","Carbon nanotubes",Composite}
798	Few-layered Ti3C2Tx MXene synthesized via water-free etching toward high-performance supercapacitors	Siqi Gong, Fan Zhao, Yaning Zhang, Huiting Xu, Meng Li, Junjie Qi, Honghai Wang, Zhiying Wang, Yuqi Hu, Xiaobin Fan, Wenchao Peng, Chunli Li, Jiapeng Liu	Journal of Colloid and Interface Science	2023	https://doi.org/10.1016/j.jcis.2022.11.063	https://www.sciencedirect.com/science/article/pii/S0021979722020215	0021-9797	MXene has drawn considerable attention in energy storage due to particular physicochemical properties. At present, among most near-ambient temperature preparation methods, water is usually served as the main solvent. However, MXene is usually subjected to fast structural degradation on account of water molecules attacking in aqueous solution. Herein, we report a novel water-free etching strategy for synthesizing few-layered Ti3C2Tx MXenes in deep eutectic solvents at near-ambient temperature. Benefitting from the absence of water and macromolecular structure of deep eutectic solvents, the as-synthesized few-layered Ti3C2Tx (DES-Ti3C2Tx) MXene presents abundant O terminations and low oxidation degree. As a consequence, the DES-Ti3C2Tx MXene displays excellent specific capacitance of 320 F g at 2 mV s. Impressively, the DES-Ti3C2Tx MXene exhibits splendid long-term stability that 97 specific capacitance retention can be acquired over 50 000 cycles at high current density of 50 A g. Therefore, this study offers a new thought for preparing high performance MXene-based materials by water-free etching method.	{MXene,"Water-free etching","Deep eutectic solvents",Terminations,Pseudocapacitance}
799	Enhanced electrochemical energy storage performance by mediating BaTiO3 nanoparticles into the multilayers of Ti3C2Tx MXene	Jitesh Pani, Hitesh Borkar	Journal of Electroanalytical Chemistry	2024	https://doi.org/10.1016/j.jelechem.2024.118092	https://www.sciencedirect.com/science/article/pii/S1572665724000687	1572-6657	MXenes belong to the family of two-dimensional (2D) transition metal carbides, have been identified as advanced energy materials with exceptional performance. In this paper, we employed a strategy to intercalate BaTiO3 (BTO) nanoparticles into the two-dimensional (2D) Ti3C2Tx MXene sheets and use as electrode materials for electrochemical performances. BTO intercalated MXenes prove more active areas for improved electrochemical performance. As a result, the BTO intercalated Ti3C2Tx MXene electrode exhibits a high specific capacitance of 254.28F g at 1 A g and a retention ratio 74 after 10,000 cycles. The electrochemical stability study confirms that restacking issues were resolved. Thus, the intercalation of BTO enhanced the reaction kinetics of the MXenes and facilitate the charge storage valuable mechanism for next-generation smart energy storage devices.	{"Ti3C2Tx MXene",Supercapacitors,Intercalation,"Restacking Nidhi, Nahid Tyagi, Gaurav Sharma, Manoj Kumar Singh, Synergistic effect of PANI nanofibers on MXene sheets for high performance electrodes in supercapacitor applications, Polymer, Volume 326, 2025, 128328, ISSN 0032-3861, https://doi.org/10.1016/j.polymer.2025.128328. (https://www.sciencedirect.com/science/article/pii/S0032386125003143) Abstract: Development of advanced composite materials for supercapacitor electrodes is crucial for achieving high performance energy storage devices. This research presents the electrochemical properties of 2D MXene (Ti3C2Tx) sheets by integrating them with polyaniline (PANI) nanofiber using polymerization method. The electrochemical measurements were finding by utilizing of graphite sheet as a current collector. The results demonstrate that the Ti3C2Tx/PANI nanocomposite has a remarkable capacitance of 854 F/g at a current density of 1A/g with 1 M H2SO4 electrolyte. Moreover, it demonstrates at an immersive retention capacity of 88 % after 2000 cycles of charging and discharging, even at 5 A/g current density. Ti3C2Tx/PANI has 48.6 μS/cm ionic conductivity and a diffusion coefficient of 196.1 × 10−12 cm2/s as calculated by EIS measurements. Therefore, Ti3C2Tx/PANI nanocomposite can be regarded a promising electrode material for supercapacitor applications. Keywords: Ti3C2Tx/PANI synthesis","Mild etching","In situ-polymerization","Nanofibers and supercapacitor applications"}
800	Oxygen vacancy enriched Na+ intercalated MnO2 for high-performance MXene (Ti3C2Tx)-based flexible supercapacitor and electrocatalysis	B. Thanigai Vetrikarasan, Abhijith R. Nair, Surendra K. Shinde, Dae-Young Kim, Ji Man Kim, Ravindra N. Bulakhe, Shilpa N. Sawant, Ajay D. Jagadale	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.112457	https://www.sciencedirect.com/science/article/pii/S2352152X24020437	2352-152X	The increased interest in smart and portable electronic gadgets has led to the development of flexible and wearable energy storage systems. Herein, the oxygen vacancy-enriched Na-MnO2-x is synthesized using a simple, scalable, and inexpensive electrodeposition method. The oxygen vacancy enrichment effectively enhances the conductivity and reaction kinetics of the Na-MnO2 electrode. The Na-MnO2-x film electrode reveals an excellent specific capacitance of 395 F g 1 at the scan rate of 5 mV s 1 with high capacitance retention of 85.9 after 10,000 cycles at a current density of 5 A g 1. To verify the practicability, three asymmetric supercapacitors (ASCs) (Mn3O4 Ti3C2Tx, Na-MnO2 Ti3C2Tx, and Na-MnO2-x Ti3C2Tx) are fabricated and their respective performances are contrasted. The Na-MnO2-x Ti3C2Tx ASC reveals a maximum energy density of 25 Wh kg 1 at the power density of 1000 W kg 1, along with excellent capacitance retention of 98.8 after 10,000 cycles. In addition, to validate the suitability of Na-MnO2-x electrode for flexible energy storage, the flexible Na-MnO2-x Ti3C2Tx ASC is fabricated that operates in the potential window of 2 V in PVA: Na2SO4 polymer gel electrolyte and delivers a high volumetric energy density of 510.3 mWh cm 3 at a power density of 40,483 mW cm 3. Moreover, the electrocatalytic activity of Na-MnO2-x thin films reveals an overpotential of 439.7 and 381.2 mV to drive a current density of 10 mA cm 2 corresponding to HER and OER, respectively. Therefore, the electrodeposited, oxygen vacancy-enriched Na-MnO2-x film electrode has great potential to be used for both flexible energy storage and electrocatalysis.	{"Manganese oxide","Thin film",Intercalation,"Oxygen vacancy",Supercapacitor,Electrocatalysis,"Oxygen evolution reaction","Hydrogen evolution reaction"}
801	Synthesis and fabrication of MXene copper selenide composite for high-performance asymmetric supercapacitor	M. Manikandan, M. Muthulakshmi, Seyadu Abuthahir, E. Papanasam, Dr Deepak Dubal, Sajid Ali Ansari, E. Manikandan	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117038	https://www.sciencedirect.com/science/article/pii/S2352152X25017517	2352-152X	MXene-Copper selenide (MCuSe) composite is prepared using the hydrothermal method for high-performance asymmetric supercapacitor. The synthesized materials were characterized using basic characterization such as XRD, BET, FESEM, TEM with EDS and XPS to confirm the phase formation, surface area and morphology. A composite material with improved ion transport, increased conductivity, superior cyclic stability and specific capacitance is produced when MXene is incorporated into a CuSe matrix. These improvements are explained by the complementary interaction of the highly conductive, layered MXene nanosheets and CuSe nanoparticles. The electrode setup of the electrochemical analysis reveals the specific capacity (Csp) for CuSe and MCuSe are 380 F g and 570 F g at 1 A g current density. An Asymmetric Supercapacitor (ASC) is developed using MCuSe and an activated carbon electrode, the device delivered a Csp of 167 F g at 1 A g and a high energy density and power density of 59.38 Wh Kg 1, 2055.46 W Kg 1, respectively with cyclic stability of 93 after 5000 cycles. For next-generation supercapacitors, the MXene-CuSe composite offers an electrode material that is more robust and efficient.	{"Copper selenide",MXene,"Asymmetric supercapacitor","Energy density","Power density"}
802	In situ oxygen doped Ti3C2Tx MXene flexible film as supercapacitor electrode	Yapeng Tian, Maomao Ju, Yijia Luo, Xiaoqing Bin, Xiaojie Lou, Wenxiu Que	Chemical Engineering Journal	2022	https://doi.org/10.1016/j.cej.2022.137451	https://www.sciencedirect.com/science/article/pii/S1385894722029394	1385-8947	Heteroatom doping has been proven to be an effective strategy to improve the electrochemical energy storage capacity of two-dimensional MXenes. However, the heteroatom for MXenes is mainly focused on the N atoms, while the effects and underlying mechanisms of O substituted partial C atoms of MXene have not been explored so far. Herein, comprehensive research is firstly performed to reveal the oxygen doping mechanism in Ti3C2Tx MXene by the experimental characterization and the density functional theory simulation. The in situ oxygen doped Ti3C2Tx nanosheets, in which oxygen atoms substitute partial carbon atoms in the titanium octahedron, are synthesized by etching the oxygen doped Ti3AlC2 MAX phase, which is more facile than the complex post-doped process. The introduction of appropriate oxygen atoms can effectively improve the interlayer space, electronic conductivity, and interface charge transfer of the Ti3C2Tx MXene as a supercapacitor electrode. Further, the electrochemical performances demonstrate that the oxygen doped MXene (O-Ti3C2Tx-0.05) film electrode can deliver a higher capacity of 306.0 C g 1 compared to the pristine Ti3C2Tx electrode (216.8 C g 1). Besides, the quantitative analysis results imply that the enhanced capacitance is mainly attributed to the diffusion-controlled capacitance and interface capacitance, which result from the higher Ti metal active center, the enhanced quantum capacitance, and the higher adsorption energy.	{MXene,"In situ oxygen doping","Density functional theory",Supercapacitors,"Superior capacity"}
803	Recent advances in MXene-polymer composites for high performance supercapacitor applications	Sanam Bashir, Lala Gurbanova, Ibrahim A. Shaaban, Muhammad Sufyan Javed, Md Rezaul Karim, Syed Shoaib Ahmad Shah, Muhammad Altaf Nazir	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117588	https://www.sciencedirect.com/science/article/pii/S2352152X25023011	2352-152X	MXene conducting polymers are excellent electrode materials that have drawn a great deal of scientific focus for energy storage applications. When these two distinct material types, MXene and polymers are combined, the flaws that arise from their use as electrode materials alone can be resolved. MXene conducting polymer composites show promise as improved electrode materials because of their superior mechanical characteristics, mass load, flexibility, specific surface area, and theoretical capacity. Numerous instances of employing conducting polymers with MXene as electrodes are detailed in order to further highlight the modifications caused by these composites. The latest developments in the study of conducting polymer composites and MXene-based supercapacitors (SC) are generally covered in this review, covering various properties of MXene and MXene-polymers composites, electrode materials, materials preparation, and the two types of supercapacitors: symmetrical (SSC) and asymmetrical (ASC). Understanding the utilizing of composites of MXene and conducting polymers in SC research is the purpose of this work, which also offers recommendations for additional study of these intriguing materials.	{"MXene-polymer composites",Supercapacitors,"Energy storage","Electrode materials","Conducting polymers"}
804	Shear exfoliation of DMSO intercalated Ti3C2Tx during 3D printing process and its performance as a supercapacitor at high and low temperatures	Mengmeng Yuan, Jingdi Shang, Libo Wang, Qixun Xia, Qianku Hu, Yukai Chang, Aiguo Zhou	Ceramics International	2024	https://doi.org/10.1016/j.ceramint.2024.01.098	https://www.sciencedirect.com/science/article/pii/S0272884224001019	0272-8842	Extraordinary electrical conductivity, hydrophilic nature and excellent mechanical flexibility of two-dimensional transition metal carbides and nitrides (MXene) enable it to be intriguing contender for MSCs applications. However, the preparation process of MXene ink used in 3D printing is relatively complicated, and the ink is generally obtained by concentrating low concentration single-layer MXene. In this study, DMSO intercalated MXene precipitation was directly used for 3D printing, and MXene with increased interlayer spacing and reduced interlayer force was peeled off using shear force during the extrusion process of 3D printing. Finally, an interdigital electrode for MSC was successfully manufactured. The obtained 3D printed MSC demonstrated ultra-high areal capacitance of 2497.8 mF cm 2 at scan rate of 2 mV s 1, energy density of 222.02 μW h cm 2 and sustaining 84 capacitance over 7000 long cycles. In addition, the prepared MSCs have good specific capacity over a wide temperature range ( 40 C 60 C), and the capacity is positively correlated with temperature. However, the long cycle stability of MSCs at high and low temperatures is poor, and the performance needs further improvement. This work provides a reference for the next generation of scalable printed electronic products.	{Micro-supercapacitors,"Ti3C2Tx MXene","3D printing",Temperature}
805	Recent advance in the construction of 3D porous structure Ti3C2Tx MXene and their multi-functional applications	Wenke Hao, Sijia Ren, Xiaodong Wu, Xiaodong Shen, Sheng Cui	Journal of Alloys and Compounds	2023	https://doi.org/10.1016/j.jallcom.2023.172219	https://www.sciencedirect.com/science/article/pii/S0925838823035223	0925-8388	MXene, a new two-dimensional nanomaterial, has attracted much attention due to its hydrophilicity, excellent electrical conductivity, stability, electrochemical property, etc. We have given a brief introduction to the preparation of MXene nanosheets, as well as the 1D and 2D MXene-based materials with their applications. However, the spontaneous aggregation and re-stacking of nanosheets in 1D and 2D MXene due to hydrogen bonding and van der Waals forces are not beneficial to the industrialization applications, and therefore, the construction of 3D porous structures is an effective way to solve this issue. However, the small transverse dimensions and weak mechanical properties of MXene itself do not allow for the spontaneous formation of strong, stable, and self-supportable 3D porous structure. Therefore, combining MXene with other materials, such as carbon-based materials, metal oxides, spinel, polymers, metal-based nanoparticles, have been considered as the most effective method for the preparation of 3D MXene-based porous structure. Thus, in this review, we have illustrated the current construction techniques of 3D porous Ti3C2Tx MXene including template method, self-assembly method and 3D printing method, etc. The wide applications of 3D MXene in supercapacitors, electromagnetic shielding, seawater desalination, piezoresistive sensors and catalysis via microstructures structures regulation, are also summarized in this work. Finally, the prospects regarding the 3D MXene-based composites with strong mechanical property, pore structures regulation, cost-effective synthesis route and the new applications fields are proposed. This work will help to develop a more exquisite design of 3D MXene-based materials for their future commercial applications.	{"3D porous structures","Ti3C2Tx MXene","Assembly methods"}
806	FeCo2O4 FeCo2S4 core-shell nanospheres intercalating into Ti3C2Tx for high-performance all-solid-state supercapacitors	Na Chen, Guo-Tao Xiang, Qi Sun, Jia-Lei Xu, Bin Lu, Wen-Cheng Hu, Yong-Da Hu, Jin-Ju Chen	Ceramics International	2024	https://doi.org/10.1016/j.ceramint.2023.11.131	https://www.sciencedirect.com/science/article/pii/S0272884223035897	0272-8842	Electrode materials with high electrochemical activity and outstanding stability is of great significance to improve the performance of supercapacitors. A composite material comprised of core-shell FeCo2O4 FeCo2S4 nanospheres and MXene nanosheets was synthesized through solvothermal combined with self-assembly. The FeCo2O4 FeCo2S4-MXene hybrids as electrode materials exhibit a high specific capacitance of 1090.6 F g 1 at 1 A g 1. All-solid-state supercapacitor using FeCo2O4 FeCo2S4-MXene as the positive electrode possesses a high energy density of 49.8 Wh kg 1 at 800 W kg 1and great cycle life with 87.85 retention over 20,000 cycles at 1 A g 1. The synergistic effect of FeCo2O4 FeCo2S4 and MXene is the main reason for the exceptional electrochemical performance. FeCo2O4 FeCo2S4 anchored to MXene prevents the restacking of MXene, while MXene provides a conductive network for accelerating carrier transfer and a skeleton for preventing FeCo2O4 FeCo2S4 from collapsing during long-term cycling. In view of the above excellent performance, this study provides a feasible idea for future research on high-performance supercapacitors.	{"Core-shell structure",MXene,"Electrochemical performance",Supercapacitor}
807	Advances in MXene-based composites for next-generation flexible supercapacitors: From design and development to applications	Priya Siwach, Latisha Gaba, Sajjan Dahiya, Rajesh Punia, A.S. Maan, Kuldeep Singh, Mohd. Shkir, Anil Ohlan	Advances in Colloid and Interface Science	2025	https://doi.org/10.1016/j.cis.2025.103526	https://www.sciencedirect.com/science/article/pii/S000186862500137X	0001-8686	Flexible supercapacitors (FSCs) are ubiquitously integrated into advancing miniaturized gadgets, wearables and portable electronic technologies. The allure of FSCs lies in their flexibility, compact size, and lightweight, which has compelled extensive investigation in the domain of FSCs. The performance of supercapacitor devices is largely determined by the choice of electrode material and the interaction at the electrode-electrolyte interface. In this context, MXene, an expeditiously expanding class of 2D materials, have garnered significant attention in the exciting field of flexible devices, owing to their high electrical conductivity, distinctive layered structure, substantial surface area, excellent hydrophilicity, and abundant surface terminal groups. These interesting attributes of MXene critically influence interfacial charge storage and transport mechanisms. This review strives to discuss the latest developments in MXene and MXene-based electrode materials for flexible supercapacitors. The review thoughtfully presents the aspects of flexibility, followed by discussions on device designing and fabrication. The role of substrate in fostering flexibility, requisite for solid-state electrolyte, and the influence of diverse device architecture on interfacial stability are closely scrutinized. The review incorporates a comprehensive discussion of the factors impacting the performance of MXene materials, with a particular focus on the features including composition, structure, electrode-electrolyte interaction, electrode morphology and device architecture. Besides, this review extensively investigates fabrication routes, electrochemical performance and mechanical resilience of MXene and MXene-based composites for FSCs. Armed with these insights, the review proposes a prospective roadmap delineating the challenges and opportunities in the advancement of MXene-based electrode materials for flexible supercapacitors.	{MXene,"2D materials","Interfacial phenomenon","Flexible supercapacitors"}
808	MXene-based ternary composites for supercapacitors: Advancements and challenges	Kabir O. Otun, Azfarizal Mukhtar, Ismail Hossain, Jibril Abdulsalam	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.114127	https://www.sciencedirect.com/science/article/pii/S2352152X24037137	2352-152X	The acceleration of the global energy transition and the achievement of Sustainable Development Goals (SDGs) depend on promoting innovation in energy storage technologies. MXenes and their composites have emerged as novel electrodes for electrochemical energy storage. Numerous investigations into MXene binary nanocomposites have shown that they can deliver enhanced electrochemical performance when compared to their pristine forms. However, strong van der Waals forces between layers in MXene nanosheets can result in restacking, which lowers capacitance and slows kinetics, thereby limiting their practical applications. To achieve an enhanced electrochemical performance, attention has been shifted to MXene-based ternary nanocomposites for supercapacitors. In comparison to the previous binary system, these unique ternary MXenes display newly produced features and high-performance activity. This promotes synergism and results in superior capacitance, charge transfer kinetics, high specific energy and power, and enhanced stability. Nevertheless, based on the review of the literature, not much work has been done to prepare and investigate this novel ternary nanostructure for supercapacitors. Therefore, this review provides insights into recent advances in MXene-based ternary composites with a view to establishing the connection between their properties and supercapacitor performance. The performance of MXene-based ternary composites in supercapacitors and micro-supercapacitors are enumerated, including their practical applications. Finally, challenges and outlooks for further improving the performance of ternary composites in energy storage are highlighted.	{MXene,Supercapacitors,"Ternary composite",SDGs,"Energy transition"}
814	Hybrid microsupercapacitors based on Ti3C2Tx MXene and covalent organic frameworks	Yusuf Khan, Vinayak S. Kale, Jehad K. El-Demellawi, Yongjiu Lei, Wenli Zhao, Sharath Kandambeth, Prakash T. Parvatkar, Osama Shekhah, Mohamed Eddaoudi, Husam N. Alshareef	Materials Today Energy	2024	https://doi.org/10.1016/j.mtener.2024.101636	https://www.sciencedirect.com/science/article/pii/S2468606924001485	2468-6069	The growing demand for emerging electronic applications, including energy storage, sensors, and portable devices, has created a pressing need to develop miniaturized flexible energy storage components with convenient device architecture. Here, we report an in-plane hybrid micro-supercapacitor made of covalent organic frameworks and Ti3C2Tx MXene as positive and negative electrodes, respectively. The devices utilize three-dimensional laser-scribed graphene (LSG) as a current collector for both electrodes using a CO2-laser-based technique due to its good resolution for in-plane device fabrication, and high porosity of LSG that can facilitate better rate performance. The constructed hybrid supercapacitor has a maximum areal capacitance of 131.46 mF cm2 and a voltage window of 1.2 V. The findings provide a new strategy to fabricate a hybrid supercapacitor for self-powered device applications at the microscale.	{"Laser-scribed graphene","In-plance devices","In-situ growth",Spray-coating}
809	High-rate electrospun Ti3C2Tx MXene carbon nanofiber electrodes for flexible supercapacitors	Hyewon Hwang, Segi Byun, Seoyeon Yuk, Seulgi Kim, Sung Ho Song, Dongju Lee	Applied Surface Science	2021	https://doi.org/10.1016/j.apsusc.2021.149710	https://www.sciencedirect.com/science/article/pii/S0169433221007868	0169-4332	Increasing the capacitance and rate performance of the carbon-based electrodes used in flexible supercapacitors remains a key challenge for commercial viability. To meet these requirements, free-standing Ti3C2Tx MXene carbon nanofiber (CNF) electrodes were prepared by electrospinning of polyacrylonitrile (PAN) and carbonization for application as flexible supercapacitor electrodes. The effects of Ti3C2Tx MXene size on fiber formation and electrochemical performance were investigated. Ti3C2Tx MXene CNF electrodes exhibited a specific capacitance of 90 F g at a fast scan rate of 300 mV s, which is almost 2.3 times higher than that of a pure PAN-derived CNF (38 F g at 300 mV s), while showing similar capacitance values of around 120 F g at the slow scan rate of 2 mV s. Due to the high degree of mechanical flexibility of CNFs, MXene CNF based flexible supercapacitors also demonstrate long-term cycling stability (98 retention after 10 K charge-discharge cycles), and outstanding flexibility in dynamic bend tests. These results suggest that the MXene CNFs have great potential for applications in flexible and versatile electronic devices.	{Electrospinning,MXene,Supercapacitors,"Flexible electrode","Carbon nanofibers"}
810	Synergistic effects in CuO SnO2 Ti3C2Tx nanohybrids: Unveiling their potential as supercapacitor cathode material	Tholkappiyan Ramachandran, M.P. Pachamuthu, G. Karthikeyan, Fathalla Hamed, Moh d Rezeq	Materials Science in Semiconductor Processing	2024	https://doi.org/10.1016/j.mssp.2024.108486	https://www.sciencedirect.com/science/article/pii/S1369800124003822	1369-8001	In the field of materials science, a synergistic effect occurs when the combined physical and chemical properties of a composite material show significant improvement compared to the properties of its individual components. In this study, we synthesized a novel nanosheet-like structure composed of copper oxide (CuO) and tin oxide (SnO2) dispersed on MXene (Ti3C2Tx) sheets using an ultrasonicated coprecipitation method, and then we explored its synergistic effects. The CuO SnO2 MXene nanohybrids were characterized through SEM, HRTEM, XRD, XPS, and BET analysis, confirming successful synthesis and evident synergy between MXene and CuO SnO2. The electrochemical behaviour of the nanohybrid structure was investigated using different electrochemical techniques. CuO SnO2 MXene revealed a high capacitance of 683.5 Fg-1 at 1 Ag-1 in a 2 M H2SO4 electrolyte, with 85 cycling performance after 10,000 cycles. Notably, this performance surpassed that of MXene-Ti3C2Tx and CuO SnO2 separately, which achieved only 102.8 and 378.2 Fg-1 capacitance with 60 and 76 cycling stability, respectively. These incredible results are attributed to CuO SnO2 MXene nanohybrids synergistic effects, whereby enhance the surface area, electrical conductivity, and availability of active sites and enhanced electrochemical performance. This research offers a promising solution for advancing supercapacitor electrode materials through the creation of a novel nanosheet structure that leverages synergistic effects.	{"CuO/SnO2/MXene nanohybrids","Energy storage",Supercapacitors,"Synergistic effects","Capacitive and diffusion distribution"}
811	PANI-MnO2 and Ti3C2Tx (MXene) as electrodes for high-performance flexible asymmetric supercapacitors	Yudi Wei, Wenlong Luo, Xue Li, Zhongtai Lin, Chunping Hou, Mingliang Ma, Jianxu Ding, Tingxi Li, Yong Ma	Electrochimica Acta	2022	https://doi.org/10.1016/j.electacta.2022.139874	https://www.sciencedirect.com/science/article/pii/S0013468622000469	0013-4686	Polyaniline (PANI) and manganese dioxide (MnO2) are forward-looking electrode materials due to their high specific capacitance. But poor cyclic stability of PANI and low power density of MnO2 limit their development. In this paper, PANI and MnO2 were synthesized on carbon cloth (CC) by electrochemical polymerization with the addition of LiClO4. The capacitance of CC PANI-MnO2 increases to 634.0 F g 1 (380.4 C g 1) at 1 A g 1. And its decent electrochemical performances can be ascribed to the synergistic effect of PANI and MnO2. Moreover, an asymmetric supercapacitor based on CC PANI-MnO2 as positive electrode and CC MXene as negative electrode were assembled to broaden the potential range. The device has capacitance of 21.1 F g 1 at 0.5 A g 1 and the capacitance retention of 83 after 4000 cycles. The device shows an energy density of 47.25 μWh cm 2 at a power density of 2.40 mW cm 2. Furthermore, the ductility of the device was explored to resist the bending and stretching from external forces. The research of flexible asymmetric supercapacitors herein further improves the practical application of energy storage devices.	{CC/PANI-MnO2,CC/MXene,"Asymmetric supercapacitor",Flexibility,"Electrochemical performances"}
812	MXene material for supercapacitor applications: A comprehensive review on properties, synthesis and machine learning for supercapacitance performance prediction	Daisy Maria Saju, R. Sapna, Utpal Deka, K. Hareesh	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237302	https://www.sciencedirect.com/science/article/pii/S0378775325011383	0378-7753	Rapidly increasing population has raised demand for energy thus elevating the research on energy storage devices. Supercapacitors, with its wide range of features including high capacitance, high power density, and high cyclic stability has proved itself to be a remedy to the energy crisis faced globally. The advent of MXenes, a class of two-dimensional transition metal carbides or nitrides (TMCN) having excellent features including good electrical conductivity, pseudocapacitive nature and hydrophilic nature makes it as a potential material for the efficient electrode for supercapacitor application. This material offers a blend of metallic conductivity and abundant redox-active sites, therefore enabling charge storage mechanisms like electric double-layer capacitance and pseudocapacitance mechanisms contributing to clean and affordable energy. In this paper, we review the advancements in research on MXene material for supercapacitor application, including the properties, synthesis techniques of MXene ranging from HF etching to environment friendly fluoride-free approaches, MXene-based materials for supercapacitor application, and much more. Additionally, ML approaches for predicting supercapacitor performance are also discussed. This review provides a holistic and forward-thinking perspective of MXenes in supercapacitor applications, addressing critical challenges and outlining future research directions that are indispensable to bridge the gap that exists between academic advancement and industrial implementation.	{MXene,Composites,Supercapacitor,"Clean and affordable energy","Machine learning"}
813	Synergistically boosting the performance of asymmetric supercapacitors: in-situ construction of NiCo2S4 on amino-functionalized and Zn2+-predoped multilayer MXene	Min Lu, Mingwu Chen, Xiaohui Xu, Xinyan Wang, Wenxiao Zhang, Xinyu Li	Applied Surface Science	2025	https://doi.org/10.1016/j.apsusc.2025.163475	https://www.sciencedirect.com/science/article/pii/S0169433225011900	0169-4332	MXene s inherent tendency to aggregate and agglomerate poses critical challenges for its application in energy storage. This phenomenon results in reduced interlayer spacing, a decline in the number of active sites, diminished ion adsorption capacity, and obstructed ion transport pathways, all of which severely limit its practical utility. To address these limitations, this study presents a novel multi-dimensional performance optimization strategy for supercapacitor composite electrode materials. Amino functional groups were first adsorbed onto the surface of multilayer Ti-based MXene as a means of modification, giving rise to amino-MXene (N-MX). Subsequently, Zn2+ ions were intercalated into N-MX to fabricate Zn-amino-MXene (Zn-N-MX), which served as a substrate. Upon this, transition metal nickel cobalt based sulfides were grown in situ and progressively nucleated, culminating in the synthesis of Zn-N-MX NiCo2S4 composites (Zn-N-MX NCS). The introduction of amino functional groups effectively reshapes the chemical surroundings on the surface of MXene and reduces the steric hindrance of Zn2+ insertion. At the same time, the coordination bond formed by the amino group and the metal ion further promotes the stable anchoring and embedding of Zn2+ ions in the interlayer, as if opening up a fast lane for their embedding. In addition, the homogeneous dispersion of NiCo2S4 nanoparticles in the MXene layer provides a complementary quick channel for ion migration, thus boosting the comprehensive electrochemical properties of Zn-N-MX NCS. The composite manifests a conspicuously enhanced electrochemical performance of 1546.76 F g 1 at 1 A g 1. After Zn-N-MX NCS was integrated into an asymmetric supercapacitor (ASC) Zn-N-MX NCS AC, it exhibits a high energy density of 53.3 Wh kg 1 at 800 W kg 1.	{Supercapacitor,MXene,"Amino functionalization","Zn2+ doping",NiCo2S4}
815	Interlayer-engineered MXene Nanosheets confining CoGa-LDH enable ultrafast charge transfer kinetics for high-energy potassium-ion supercapacitors	Chenxi Li, Mai Li, Xiang Peng, Inaam Ullah, Haotian Hu, Jiayi Shen, Ayesha Irfan, Wendong Xu, Paul K. Chu	Journal of Colloid and Interface Science	2025	https://doi.org/10.1016/j.jcis.2025.138240	https://www.sciencedirect.com/science/article/pii/S0021979725016315	0021-9797	Two-dimensional MXenes, with their accordion-like morphology and facile exfoliation into monolayers, offer an ideal platform for immobilizing electroactive materials. However, composites fabricated from MXenes through conventional methods exhibit inhomogeneous dispersion, sluggish charge redistribution, and poor interfacial coupling, limiting their potassium-ion storage performance. Herein, an interlayer-engineered CoGa-LDH MXene heterostructure is fabricated via Peltier effect-driven rotational hydrothermal synthesis with tunable Co Ga ratios. This approach ensures atomic-level confinement of layered double hydroxide (LDH) within MXene interlayers while strengthening interfacial coupling and ion transport kinetics. The resulting heteroarchitecture synergizes the high pseudocapacitance of CoGa-LDH and the metallic conductivity of MXene, enabling ultrafast ion electron transport and suppressing self-aggregation. Optimized Co1Ga1-LDH MXene delivers a remarkable specific capacitance of 1345.3 F g and exceptional cyclability (85.13 retention after 6000 cycles), surpassing most reported LDH-based supercapacitors. Density functional theory (DFT) calculations reveal that the heterointerface enhances K+-ion adsorption energy and modulates charge distribution, accelerating redox kinetics. When the Co1Ga1-LDH MXene composite is assembled into an asymmetric supercapacitor (ASC), the device achieves an energy density of 77.4 Wh kg at 1125 W kg, with sustained performance under rigorous cycling. This work elucidates the confinement engineering of MXene-based compounds and their potassium storage mechanisms, providing critical references for high-energy-density supercapacitors in alkaline systems.	{MXene,"Layered double hydroxides","Hydrothermal synthesis","Potassium storage","Density functional theory"}
816	Highly durable and conductive Korea traditional paper (Hanji) embedded with Ti3C2Tx MXene for Hanji-based paper electronics	Jaehoon Jeong, Hae-Jun Seok, Hak Shin, Su Bin Choi, Jong-Woong Kim, Han-Ki Kim	Nano Energy	2024	https://doi.org/10.1016/j.nanoen.2024.110325	https://www.sciencedirect.com/science/article/pii/S2211285524010772	2211-2855	Lightweight, low-cost, eco-friendly, and mechanically flexible Ti3C2Tx (MXene) electrodes require for paper electronics. We develop a highly durable and conductive traditional Korean paper (Hanji) covered with MXene for Hanji-based paper electronics. The effective networking of MXene on the cellulose structure of Hanji leads to a highly conductive and flexible Hanji which acts as a multi-functional paper for Hanji-based paper electronics. Owing to the synergetic combination of Hanji and MXene, the as-prepared Hanji MXene exhibits a low sheet resistance of 0.62 Ohm square 1, and outstanding mechanical stability without breaking the Hanji fibers. To further evaluate the potential of our Hanji MXene composite, its performance in electromagnetic interference (EMI) shielding, interconnectors, heaters, supercapacitors, and temperature sensor applications is investigated. Shielding and heater paper samples employing Hanji MXene-based electrodes show an EMI shielding efficiency (EMI SE) of 43.3 dB and saturation temperature of 76 C at a low voltage of 3 V. Moreover, the Hanji MXene-based supercapacitors exhibit a capacitance of 139.6 mF cm 2 at a current density of 1 mA cm 2. Furthermore, the Hanji MXene-based temperature sensors exhibit an effective sensing performance over a wide temperature range. Overall, the successful operation of Hanji-based EMI shielding devices, interconnectors, heaters, supercapacitors, and temperature sensors indicates that Hanji MXene serves as a promising conductive paper substrate for multi-functional paper electronics.	{"Korean traditional paper",Hanji,"Ti3C2TX MXene","Paper electronics"}
817	Optimization of MXene CNT free-standing composite electrodes for enhanced electrochemical performance in symmetric supercapacitors	Yasar Ozkan Yesilbag, Ahmed Jalal Salih Salih	Materials Research Bulletin	2026	https://doi.org/10.1016/j.materresbull.2025.113703	https://www.sciencedirect.com/science/article/pii/S0025540825004106	0025-5408	The integration of one-dimensional (1D) and two-dimensional (2D) materials into three-dimensional (3D) structures shows great potential for improving energy storage. This study investigates the optimization of interlayer spacing in MXene structures by incorporating conductive materials. Free-standing Ti3C2Tx MXene and carbon nanotube (CNT) composite electrodes were fabricated via vacuum filtration, with CNT weight ratios of 10 , 20 , and 30 . The MXene CNT10 (MX1) composite exhibited superior electrochemical performance, with a specific capacitance of 254 F g 1 and remarkable durability, retaining 101.2 of its initial capacitance after 10,000 cycles. A symmetric supercapacitor (SSC) using the MX1 electrode achieved a stable voltage window of 0 1.2 V, a specific capacitance of 70.1 F g ¹, and retained 85 of its capacitance after 5000 cycles. With an energy density of 14.1 Wh kg 1 and a power density of 13.9 kW kg 1, MXene CNT composites demonstrate significant potential for advanced energy storage applications.	{"Ti3C2Tx MXene",CNTs,"Composite electrodes","Symmetric supercapacitor","Energy storage"}
818	Tailoring surface terminals of Ti3C2Tx MXene microgels via interlayer domain-confined polyphosphate ammonium for flexible supercapacitor applications	Yongfang Liang, Hailong Shen, Jianghai Li, Hongying Zhao, Jiaheng Xu, Haifu Huang, Shuaikai Xu, Xianqing Liang, Wenzheng Zhou, Jin Guo	Chemical Engineering Journal	2024	https://doi.org/10.1016/j.cej.2024.154775	https://www.sciencedirect.com/science/article/pii/S1385894724062661	1385-8947	The MXene material shows potential for flexible energy storage devices due to its high pseudocapacitance and mechanical flexibility. However, MXene nanosheet self-stacking and F terminal functional groups can hinder active site and ion dynamics, thus affecting the energy storage performance. Herein, we present an interlayer domain-confined strategy that involves the introduction and crosslinking of ammonium polyphosphate (APP) confined to the interlayer of Ti3C2Tx MXene sheets, which induces gelation of the MXene to form a 3D network structure and enlarge their interlayer spacing. And then the cross-linked APP is converted into nitrogen and phosphorus terminals on Ti3C2Tx MXene via thermal treatment. The nitrogen terminals in the form of the pyrrole nitrogen and pyridine nitrogen, and phosphorus terminals of P O bonds enhance the activity of the redox reaction and the dynamics of the ions, resulting in the boosted energy storage capacity of MXene. The density functional theory (DFT) calculations reveal that nitrogen-phosphorus co-doping modulates the surface electronic states of MXene and contributes to the increase of the electrical conductivity of Ti3C2Tx MXene. As a supercapacitor electrode, Ti3C2Tx MXene with N P terminals exhibits a higher specific capacitance of 597.8 F g (1777F cm 3) than the raw Ti3C2Tx MXene (384 F g). In addition, the quasi-solid state flexible symmetric supercapacitor assembled by Ti3C2Tx MXene with N P terminals can achieve an energy density of 12.5 Wh kg 1 at a power density of 250 W kg 1. Therefore, this work provides a new strategy for terminal modification of MXene and high-performance MXene supercapacitors.	{"Flexible supercapacitor",Ti3C2Tx,MXene,"Ammonium polyphosphate",Pseudocapacitance}
819	Unlocking highly stable and reversible in-situ integration of defect-rich 2D vanadium sulfide with Ti3C2Tx MXene heterostructures: Boosting asymmetric supercapacitor performance	Rohan B. Ambade, Swapnil B. Ambade, Ganesh Kumar Veerasubramani, Ki Hyun Lee, Yarjan Abdul Samad, Tae Hee Han	Journal of Power Sources	2024	https://doi.org/10.1016/j.jpowsour.2024.234615	https://www.sciencedirect.com/science/article/pii/S0378775324005676	0378-7753	To broaden the functionalities of transition metal dichalcogenides and two-dimensional transition metal carbides such as MXenes (Ti3C2Tx-MX), it is necessary to appropriately integrate them with each other to form heterostructures. The integrated heterostructures should maintain functionality through strong covalent interaction and offer excellent electrochemical properties. The requirement for developing appropriately integrated heterostructures is the control of nucleation and growth by governing the reaction kinetics. However, developing heterostructures over MXenes on a large scale is extremely challenging. Herein, we propose an investigation to elucidate the formation of defect-rich conductive heterostructures by in-situ integration of vanadium sulfide (VS2) on the surface of Ti3C2Tx-MX (VS2 Ti3C2Tx-MX) via controlled nucleation and growth in a facile hydrothermal process. The scrutinized binder-free flexible fabric-based VS2 Ti3C2Tx-MX0.25 electrode exhibits an excellent specific capacitance of 750 F g 1 and long-term stability ( 93 retention after 10000 cycles). Moreover, these defect-rich and interlayer-expanded integrated heterostructures showed exceptional cycling stability and an impressive energy density of 52.08 Wh kg 1 at a power density of 750 W kg 1 when employed as fabric-based asymmetric supercapacitor (ASC) devices with VS2 Ti3C2Tx-MX0.25 Ti3C2Tx-MX configuration. We anticipate that the approach presented in this work will promote the development of various MXene-based heterostructures for manipulating the versatile properties of MXenes and VS2 in energy storage applications.	{"Two-dimensional (2D)",VS2,Ti3C2Tx-MXenes,Heterostructures,Defect-rich,"Asymmetric supercapacitors"}
855	2D 3D Ti3C2Tx HCl etched Ni-Mn Prussian blue analogue nanocomposite as advanced electrode material for flexible solid-state supercapacitors	Selvadhas Nirmala Kanimozhi, Abdullah Mohammed Alswieleh, Andrea Sorrentino, Jegadesan Subbiah, Anandan Sambandam	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.238029	https://www.sciencedirect.com/science/article/pii/S0378775325018658	0378-7753	Since their discovery in 2011, MXenes, derived from their parent MAX phases, have garnered immense attention in the domain of energy storage due to their exceptional attributes. However, their performance is often hindered by nanosheet restacking, which limits stability and ion diffusion. To address this challenge, we propose a novel 2D 3D nanocomposite comprising Ti3C2Tx MXene and a 3D Prussian blue analogue (Ni-Mn PBA). The integration of Ni-Mn PBA mitigates the restacking of MXene nanosheets, enhancing electrode stability, while Ti3C2Tx serves as a highly conductive substrate, facilitating efficient ion transport. This synergistic interaction results in superior electrochemical performance. Herein, we report the synthesis of Ti3C2Tx Ni-Mn PBA via chemical etching, which partially modifies the PBA structure to expose internal surfaces and promote ion diffusion through its open framework. The 2D 3D nanocomposite exhibits a specific capacitance of 316 F g at a current density of 5 mA cm2, surpassing the performance of pristine Ti3C2Tx and Ni-Mn PBA. When assembled into an asymmetric supercapacitor, the device achieves an energy density of 44 Wh kg and a power density of 2640 W kg, demonstrating its practical application by powering a multifunctional display for nearly 2 min. Additionally, a solid-state supercapacitor employing an ionic liquid-based gel electrolyte (PVA KOH EMP-TFSI) was developed, extending the operating voltage to 1.7 V and further enhancing the energy density of the device. This study highlights the potential of Ti3C2 Ni-Mn PBA nanocomposites as advanced materials for next-generation flexible energy storage systems.	{Ti3C2,"Prussian Blue Analogues (PBA)","2D/3D nanocomposites","Flexible supercapacitors"}
856	Rationally constructed CeO2 Ti3C2Tx-MXene heterostructure for rapid and efficient visible light photocatalytic activity and enhanced supercapacitor performance	Nagaraju Macherla, Govinda Dharmana, Manjula Nerella, Thirumala Rao Gurugubelli, Ravindranadh Koutavarapu, Jaesool Shim	Colloids and Surfaces A: Physicochemical and Engineering Aspects	2025	https://doi.org/10.1016/j.colsurfa.2025.137907	https://www.sciencedirect.com/science/article/pii/S0927775725018102	0927-7757	Two-dimensional (2D) Ti3C2Tx MXene (MX) benefits from substantial surface area, higher electric conductivity, and abundant surface terminations that can be tightly coupled with other materials, and has found broad application prospects in energy storage and photocatalysis. By this, CeO2 nanospheres were rationally compounded with MX to obtain nanocomposites (NCs) (CeO2 MX1, CeO2 MX3, CeO2 MX5, and CeO2 MX7) via a facile one-step solvothermal method. X-ray diffraction examination discloses the cubic structure of CeO2, and shrinkage in average crystallite size is noticed up to 5 of MX. Field emission scanning electron microscopy images show uniform CeO2 nanospheres decorated on MX 2D matrix, and particle size distribution results are well aligned with crystallite size trends. Optical absorption divulges a progressive red shift in the absorption edge with increasing MX content, demonstrating enhanced light harvesting and effective charge migration through the heterojunction formed at the CeO2 MX interface. Electrochemical impedance spectroscopy studies indicate a smaller charge transfer resistance for CeO2 MX5, highlighting interfacial conductivity and rapid charge transfer characteristics. Consequently, CeO2 MX5 attains a robust photocatalytic tetracycline (TC) degradation surpassing pristine CeO2 and other CeO2 MX NCs. As a supercapacitor electrode, CeO2 MX5 delivers a specific capacitance of 522 F g 1 at 0.5 A g 1 and retains 92 of its initial capacitance after 10000 GCD cycles. This work underscores the effective integration of CeO2 with 2D MX to achieve a versatile platform for environmental remediation and energy storage applications.	{MXene,CeO2/Ti3C2,Solvothermal,Tetracycline,Photocatalysis,Supercapacitor}
820	Zn2+ ions induced gelation of low concentration Ti3C2Tx MXene under the confinement of melamine sponge and electric field as self-supporting electrode for high-performance supercapacitors	Debin Cai, Shuai Wu, Wenlong Yan, Li Guo, Yanzhong Wang	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.146566	https://www.sciencedirect.com/science/article/pii/S0013468625009272	0013-4686	The self-assembly of Ti3C2Tx MXene nanosheets into three-dimensional aerogels has been considered to be an effective method to impede their restacking and expose more active sites. However, the gelation of Ti3C2Tx MXene nanosheets requires a high concentration of suspension and cannot form a self-supporting electrode with high mechanical strength due to its weak gelation ability, which is still limited in practical applications. Here, the released Zn2+ induced Ti3C2Tx MXene to form a gel under the constraint of the melamine sponge (MS) three-dimensional framework and the electric field, and combined with the freeze-drying process to prepare Ti3C2Tx MXene aerogels with high mechanical strength and high loading. The electric field achieves efficient gelation through a dual regulation mechanism: (i) The charge enrichment effect significantly reduces the critical gelation concentration of Ti3C2Tx; (ii) The electric field-driven Zn2+ intercalation expands the interlayer spacing of Ti3C2Tx nanosheets, constructing a three-dimensional network with a hierarchical pore structure, showing good structural stability. Benefiting from the excellent three-dimensional structure, the prepared MXene MS-3V-6 M aerogel exhibits superior rate performance. The area capacitance is 610.77 mF cm-2 at a high scan rate of 1000 mV s-1, and the capacitance retention rate is as high as 78.57 . More importantly, the constructed Ti3C2Tx MXene AC asymmetric supercapacitor achieves high energy densities of 120.74 and 90.21 μWh cm-2 at power densities of 800 and 79,992 μW cm-2, respectively. It is worth noting that the asymmetric supercapacitor has a capacity retention rate of 93.37 after 10,000 cycles, and has a high cycle stability. This work proposes an effective strategy for the preparation of Ti3C2Tx MXene aerogels with high mechanical strength and rate performance by using low concentration Ti3C2Tx MXene.	{"Melamine sponge","Ti3C2Tx MXene aerogel","Electric field","Self-supported electrode",Supercapacitors}
821	Dimensionally integrated hybrid films of Ti3C2Tx MXene and cellulose nanocrystals for high-performance supercapacitors	Seulgi Kim, Segi Byun, Seoyeon Yuk, Sunghee Choi, Sung Ho Song, Dongju Lee	Journal of Materials Research and Technology	2024	https://doi.org/10.1016/j.jmrt.2024.11.262	https://www.sciencedirect.com/science/article/pii/S223878542402790X	2238-7854	The use of low-dimensional materials in electrode fabrication is gaining popularity due to their distinctive properties. This study introduces a straightforward method for creating a dimensionally integrated hybrid film that combines Ti3C2Tx MXene (2D) with cellulose nanocrystals (1D). The resulting freestanding hybrid film exhibits a lamellar structure, held together by weak intermolecular forces between the components. This structure leads to marked improvements in both structural and electrochemical properties. These enhancements are primarily due to the incorporation of 1D materials, which act as spacers to prevent the self-restacking typical of 2D materials and aid in the formation of electrochemically active sites and channels. This improvement stems from the synergistic effects of the combined materials, optimized at the ideal concentration ratio. This study may guide the development of electrodes integrated with redox-active materials, potentially advancing ideal energy storage systems.	{MXene,"Cellulose nanocrystal","1D/2D hybird film","Freestanding electrode",Supercapacitors}
822	Gallium hydroxide coated Ti3C2Tx MXene for high-performance asymmetric supercapacitor	Zhi Wan, Peilin Zuo, Zhiyuan Chen, Jizhou Yang, Mingxin Ren, Zhenghang Tian, Gangfeng Li, Peng Hu, Feng Teng, Haibo Fan	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2024.114686	https://www.sciencedirect.com/science/article/pii/S2352152X24042725	2352-152X	Ti3C2Tx MXenes have emerged as promising candidates for energy storage applications due to their two-dimensional structure, metallic conductivity, tunable surface functionalities, and intrinsic pseudocapacitive charge storage. This study explores the hydrothermal synthesis of GaOOH Ti3C2Tx composites using gallium nitrate as the gallium precursor. The incorporation of GaOOH not only expands the interlayer spacing of Ti3C2Tx, facilitating more efficient electrolyte ion migration, but also enhances the material s energy storage capacity by introducing additional active sites and augmenting pseudocapacitance. As an electrode material in supercapacitors, GaOOH Ti3C2Tx composites, prepared with a 0.06 M gallium source concentration, achieve a remarkable specific capacitance of 542.1 F g 1, surpassing that of pristine Ti3C2Tx (305 F g 1), with a minimal degradation of only 3.4 after 5000 charge-discharge cycles. This research offers valuable insights into the electrochemical behavior of GaOOH Ti3C2Tx composites and highlights the role of GaOOH in enhancing the performance of these materials. The results underscore the potential of combining metal hydroxides with MXenes for advanced supercapacitor applications.	{GaOOH,MXene,Supercapacitor,Hydrothermal,"Metal hydroxides"}
823	Development of micro flower petal-structured NiCo2S4 Ti3C2Tx MXene nanosheets on nickel foam for superior supercapacitor applications	Moo Young Jung, Hyobeen Cho, Ji-Won Son, Sankaiya Asaithambi, Yongseok Jun	Journal of Industrial and Engineering Chemistry	2025	https://doi.org/10.1016/j.jiec.2025.03.033	https://www.sciencedirect.com/science/article/pii/S1226086X25001935	1226-086X	Transition metal sulfides have recently emerged as promising materials for supercapacitors owing to their high energy density, abundant resources, electrical conductivity, and environmental benignity. However, the challenges associated with increased internal resistance and volume fluctuations during prolonged charge and discharge cycles have raised concerns regarding their long-term stability in energy storage devices. In this study, micro flower petal-architectures NiCo2S4 and Ti3C2Tx MXene nanosheets were prepared by direct growth onto a binder-free nickel foam (NF) electrode. The resulting NiCo2S4 Ti3C2Tx MXene NF (NCSMX NF) electrode revealed an unparalleled capacitance of 2169.9 F g 1 at 0.5 A g 1, including lower charge transfer resistance of 0.13 Ω. Furthermore, the asymmetric supercapacitor device (ASC) was configured with NCSMX NF and activated carbon (AC) as positive and negative electrodes, respectively. The as-fabricated NCSMX NF AC NF ASC device achieved an extensive energy and power densities of 19.2 Wh kg 1 and 7500 W kg 1, with an impressive capacitance retention of 80.8 and a coulombic efficiency of 98.6 at 2 A g 1. Therefore, the NiCo2S4 Ti3C2Tx MXene binder-free electrode demonstrated exceptional electrochemical performance. This study holds significant potential for the development of advanced energy storage devices, offering insights into the design and fabrication of high-performance electrodes.	{"Nickel cobalt sulfide","Ti3C2Tx MXene sheet",Binder-free,"Asymmetric supercapacitor device"}
824	MoS2 Ti3C2Tx GO heterostructure gelatin: Harnessing synergy for high-performance supercapacitor electrodes	Yanan Liu, Luyao Wang, Wenhui Li, Junwei Huang, Hongna Xing, Juan Feng, Yan Zong, Xiuhong Zhu, Xinghua Li, Xinliang Zheng	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.146978	https://www.sciencedirect.com/science/article/pii/S0013468625013386	0013-4686	MXene (Ti3C2Tx)-based supercapacitor electrode materials suffer from issues like easy stacking, poor oxidation resistance and limited energy density. To address these challenges, a novel molybdenum disulfide MXene graphene oxide (MoS2 Ti3C2Tx GO) heterostructure gelatin (gel) is proposed through a synergistic three-dimensional (3D) crosslinking and in-situ growth strategy. By utilizing GO as a bridging agent to construct a hierarchical porous network, embedding MoS2 nanoflowers as both oxidation barriers and pseudocapacitive contributors, and further combining them to form a heterojunction interface, the MoS2 Ti3C2Tx GO composite achieves synergistically enhanced ion transport kinetics, structural stability and energy storage performance. Such optimization enables this composite to exhibit a high specific capacitance of 579 F g-1 (1 A g-1) and excellent cycling stability (81.7 retention after 10,000 cycles). The assembled asymmetric supercapacitor (ASC) with activated carbon (AC) as a negative electrode (MoS2 Ti3C2Tx GO AC, ASC) demonstrates outstanding performances, with an energy density of 31 Wh kg-1 at 746 W kg-1 and a capacity retention of 89.2 after 10,000 cycles. This research provides an effective solution for improving the performance of MXene-based supercapacitor electrode materials, advancing their application in high-performance energy storage systems.	{MXene,"Heterostructure gelatin",Supercapacitor,"Cycling stability","Energy density"}
825	Ti3C2Tx MXene integrated hollow carbon nanofibers with polypyrrole layers for MOF-derived freestanding electrodes of flexible asymmetric supercapacitors	Ishwor Pathak, Debendra Acharya, Kisan Chhetri, Prakash Chandra Lohani, Tae Hoon Ko, Alagan Muthurasu, Subhangi Subedi, Taewoo Kim, Syafiqah Saidin, Bipeen Dahal, Hak Yong Kim	Chemical Engineering Journal	2023	https://doi.org/10.1016/j.cej.2023.143388	https://www.sciencedirect.com/science/article/pii/S1385894723021198	1385-8947	Effective customization of Ti3C2Tx MXenes by electrospinning technique is crucial for the preparation of freestanding flexible electrodes exhibiting enhanced performance in supercapacitors. Herein, we prepared MXenes containing hollow carbon nanofibers (MXHCNF) by co-axial electrospinning, and the inside-out of MXHCNF is decorated with polypyrrole layers (PPy MXHCNF), which is sufficiently flexible, conductive, and highly functionalized with a unique trilayer morphology. Using the self-designed electroactive PPy MXHCNF, a ZnCoMOF is homogeneously grown. The as-prepared bimetallic MOF on PPy MXHCNF is used as a common precursor with which to fabricate the positive (ZCO PPy MXHCNF) and negative (NPC MXHCNF) electrodes by a controlled heat treatment process using a two from one strategy. The freestanding positive and negative electrodes provide specific capacitances of 1567.5 F g 1 and 477.2 F g 1 at 1 A g 1, respectively, with high capacitance retention, cyclic stability, and coulombic efficiency. A flexible asymmetric device (ZCO PPy MXHCNF NPC MXHCNF) is assembled, and it exhibits an energy density of 61.3 Wh kg 1 at a power density of 796.8 W kg 1 and 92.8 capacitance retention after 10,000 GCD cycles. This work provides a unique approach involving MXene modification, polypyrrole decorated electrospun MXHCNFs as efficient substrates for freestanding electrodes, and the use of bimetallic MOF as a common strategic route for both positive and negative electrodes in flexible asymmetric supercapacitors.	{MXene,"Hollow carbon nanofibers",Polypyrrole,"Metal–organic frameworks","Asymmetric supercapacitor"}
826	Influence of the synthesis protocol on the electrochemical properties of Ti3C2Tx MXene supercapacitor electrodes	Vinícius dos Passos de Souza, Luís Marcelo Garcia da Silva, Rafael Kenji Nishihora, Sydney Ferreira Santos	Surface and Coatings Technology	2025	https://doi.org/10.1016/j.surfcoat.2025.132583	https://www.sciencedirect.com/science/article/pii/S0257897225008576	0257-8972	Understanding and tuning the exfoliation process and surface terminations is essential for enhancing the electrochemical performance of MXenes in energy storage devices. While traditional synthesis methods rely on hazardous hydrofluoric acid (HF) etching, safer alternatives have emerged through in situ HF generation using HCl and LiF, a method known as MILD. Despite this method is safer and produce significantly lower quantity of hazardous wastes, some concerns remain due to the Li wastes. Moreover, LiF is an expensive chemical and its replacement by other fluorides. In this work, we systematically investigated how different fluoride mixtures influence the structural, surface, and electrochemical properties of Ti₃C₂Tₓ MXenes. By comparing the effects of LiF, NaF + LiF, and KF + NaF systems, we discovered that the NaF + LiF combination significantly enhanced delamination, producing well-separated layers observable in XRD patterns. However, despite the improved exfoliation, the resulting MXene exhibited low capacitance ( 60 F g), which we attribute to reduced concentrations of electrochemically active surface terminations (F and Cl), as confirmed by XPS. Conversely, MXenes synthesized with LiF alone not only retained higher levels of these terminations but also achieved remarkable electrochemical performance, reaching 800 F g after 1800 cycles, far surpassing typical values reported in the literature. The KF + NaF system produced the least favorable outcomes, both structurally and electrochemically ( 47 F g). These findings highlight the critical importance of fluoride chemistry in tuning both the delamination process and the surface composition of MXenes, and they demonstrate that a LiF-based synthesis route offers a highly promising pathway for producing high-performance electrodes with exceptional cycling-enhanced capacitance.	{}
827	Influence on effective and ineffective delamination of MXene (Ti3C2Tx) by tightly anchoring tin oxide nanocomposite for boosting the specific capacitance of supercapacitor	N. Prabhakar, A. Rajapriya, N. Ponpandian, C. Viswanathan	Journal of Alloys and Compounds	2022	https://doi.org/10.1016/j.jallcom.2022.166092	https://www.sciencedirect.com/science/article/pii/S0925838822024835	0925-8388	Rich surface functionalization properties and ion diffusion behavior make MXene a promising material for better self-discharge properties for Supercapacitor application. Utilizing a new electrode material for the renewable energy storage device is a very important factor for the environmental safety from the threatening fossil fuels. Herein, we report a highly capacitive and fast charge-discharge electrode material assembled by tightly anchoring SnO2 over Ti3C2Tx flakes (graphite sheet as a current collector) and the electrolyte Potassium Hydroxide (KOH) as a new promising material for supercapacitor electrode. XRD analysis with FESEM imaging showed that the tetragonal rutile structure of SnO2 nanoparticles was uniformly grown on the surface of sheet-like Ti3C2Tx. By optimizing Ti3C2Tx through delamination using TMAOH (Tetramethylammonium Hydroxide) and introducing SnO2 nanoparticles onto it by simple sonication, the developed electrode material delivered a maximum of specific capacitance (669 Fg 1 in the alkaline electrolyte) with stable cyclic performances (90 of retainability over Six thousand cycles) and shows a good rate performance. The comparison of delaminated and without delaminated samples reveals that the delaminated electrode can avoid the restacking of 2D MXene sheets and hence improve ion migration and electron transport in energy storage devices. This predominant performance demonstrated that Delaminated MXene SnO2 can effectively advance the future of electrode material for next-level supercapacitor applications.	{MXene,"Tin oxide",Nanocomposite,"Effective delamination",Pseudocapacitor,Supercapacitor}
828	The effect of mild oxidation induced by heat treatment on the pseudocapacitance performance of Ti3C2Tx MXene	Jiaheng Xu, Yiwei Lu, Hongying Zhao, Lin Li, Hailong Shen, Yi Fan, Xianqing Liang, Wenzheng Zhou, Zhiqiang Lan, Haifu Huang	Materials Science and Engineering: B	2025	https://doi.org/10.1016/j.mseb.2025.118403	https://www.sciencedirect.com/science/article/pii/S0921510725004271	0921-5107	MXene, as an emerging two-dimensional material, holds great potential in the field of supercapacitors due to its graphene-like layered structure and high conductivity. However, MXene also faces a series of challenges; including oxidation, self-aggregation, and re-stacking issues caused by van der Waals and hydrogen bond interactions within its two-dimensional layers. These challenges limit the exposure of surface-active sites, slow down electron transfer rates, and subsequently affect its electrochemical performance as an electrode material for supercapacitors. To overcome these issues and further optimize the electrochemical performance of MXene, this study focuses on exploring the effects of the low-temperature heat treatment process on the interlayer spacing, surface functional groups and electrochemical energy storage performance of Ti3C2Tx MXene. The results reveal that Ti3C2Tx MXene annealed at 300 C for 3 h exhibits excellent pseudocapacitance performance. At a scan rate of 2 mV s 1, its specific capacitance reaches up to 394.1 F g 1, and the capacitance retention rate remains at a high level of 105.1 after 9000 cycles. This work shows that the heat treatment and appropriate oxidation of MXene at low temperatures can promote the charge storage capacity of MXene, thereby fully unlocking their potential in supercapacitors.	{MXene,"Heat treatment",Pseudocapacitance,Supercapacitor}
829	Recent advances in optoelectronic properties and applications of Ti3C2Tx MXene	Stanly Zachariah, Ravanan Indirajith, M. Rajalakshmi	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2024.178296	https://www.sciencedirect.com/science/article/pii/S0925838824048849	0925-8388	Introducing MXenes in terms of a category of two-dimensional layered materials specifically focusing on Ti3C2Tx MXene and its distinctive features that establish it as a prominent potential employee in the field of optoelectronics. Ti₃C₂Tx MXene is unique among these due to its remarkable qualities, ease of manufacturing, and adaptability. Scalable and economical techniques like electrochemical etching, chemical exfoliation, and evaporated nitrogen minimally intensive layer delamination (EN-MILD) can be used to create this material. Under ideal acid and lithium-ion concentrations, the EN-MILD synthesis showed improved stability and conductivity, providing information on scalable fabrication methods. Electrochemical etching and chemical exfoliation also guarantee environmental friendliness, homogeneity, and the creation of high-quality sheets. The structural integrity, surface morphology, and existence of functional groups of Ti₃C₂Tx MXene are confirmed by characterisation techniques such as X-ray Diffraction (XRD), Scanning Electron Microscopy (SEM), Atomic Force Microscopy (AFM), Raman Spectroscopy, and X-ray Photoelectron Spectroscopy (XPS). According to the results, Ti₃C₂Tx is perfect for cutting-edge applications in optoelectronics, energy storage, and thermal management systems because of its exceptional optical transparency, strong thermal conductivity, superior electrical conductivity, and effective photothermal conversion. One notable aspect that makes it extremely versatile for device integration is its solution-processability, which enables application through painting, printing, spraying, or dipping techniques. The tunable optical and electronic characteristics of Ti₃C₂Tx MXene allow for user-defined functionality in contrast to conventional 2D materials, facilitating sophisticated optoelectronic applications such as plasmonic devices, transparent electrodes, and photodetectors. Even though there has been a lot of improvement, there are still issues with integration into complex systems, consistency in large-scale production, and long-term stability. By overcoming these obstacles, MXenes full potential will be realised. This study identifies future research opportunities to improve the performance of Ti₃C₂Tx MXene and broaden its use in next-generation technologies while also highlighting recent developments in its synthesis, characterisation, and optoelectronic applications.	{Ti3C2Tx,MXenes,Nanomaterial,"Two-dimentional material",Optoelectronics}
830	Defect engineered Ti3C2Tx MXene electrodes by phosphorus doping with enhanced kinetics for supercapacitors	Keke Liu, Qixun Xia, Lijun Si, Ying Kong, Nanasaheb Shinde, Libo Wang, Junkai Wang, Qianku Hu, Aiguo Zhou	Electrochimica Acta	2022	https://doi.org/10.1016/j.electacta.2022.141372	https://www.sciencedirect.com/science/article/pii/S0013468622015298	0013-4686	Supercapacitors (SCs) have attracted increasing attention due to high power density, rapid charge discharge, excellent cyclic stability, and withstands adverse environments. Two-dimensional (2D) Ti3C2Tx MXene is considered as a promising electrode material for electrochemical energy storage. However, undesirable low specific capacitance issues limit its practical applications. Herein, a facile heteroatom doping strategy is proposed to construct defect-rich Ti3C2Tx MXene with abundant active cites. Hence, P-doped Ti3C2Tx MXene was synthesized by a simple annealing method. The prepared P-doped Ti3C2Tx was used as the electrode material of SC, and it was found that the P-doped Ti3C2Tx exhibits enhanced electrochemical performance compare to the pristine Ti3C2Tx MXene, the P-doped Ti3C2Tx electrode could deliver a high specific capacity of 31.11 mA h g 1 at 1 A g 1 in 1 M KOH electrolyte. Furthermore, a P-doped Ti3C2Tx based symmetric SC device is fabricated and displays excellent energy density of 8.2 Wh L 1 at a power density of 303.4 W L 1. This study provides a straightforward strategy to design and construct MXene-based electrode materials with enlarged layer spacing structure for high-performance K+ storage and even in other metal ion storages.	{MXene,"Two dimensional materials","Phosphorus doping",Supercapacitors}
831	High-capacity freestanding supercapacitor electrode based on electrospun Ti3C2Tx MXene PANI PVDF composite	Somayeh Mohammadi, Shayan Ahmadi, Hamid Navid, Reza Azadvari, Mahmoud Ghafari, Zeinab Sanaee, Mohammadreza Moeini	Heliyon	2024	https://doi.org/10.1016/j.heliyon.2024.e40482	https://www.sciencedirect.com/science/article/pii/S2405844024165139	2405-8440	In this study, a high-capacity freestanding supercapacitor electrode was developed through electrospinning of a Ti3C2Tx MXene Polyaniline (PANI) Polyvinylidene fluoride (PVDF) composite. MXene PANI composite was achieved through a facile synthesis in which Ti3C2Tx was mixed with PANI Emeraldine salt in N-Methyl-2-Pyrrolidone (NMP) solution using magnetic stirring. PVDF was added to the composite as a flexible binder to facilitate the electrospinning and produce a freestanding electrode. The specific capacitance of the freestanding MXene PANI PVDF electrode is 740 Fg-1 at a scan rate of 2 mVs 1, and 895 Fg-1 at a charge-discharge current density of 0.5 Ag-1, which was significantly higher than the specific capacitance of MXene (67 Fg-1) and PANI (54 Fg-1) electrospun electrodes.	{Supercapacitor,Freestanding,Electrospun,"Ti3C2Tx MXene",PANI}
832	Band engineering in Ti2N Ti3C2Tx-MXene interface to enhance the performance of aqueous NH4+-ion hybrid supercapacitors	Xiaofeng Zhang, Muhammad Sufyan Javed, Salamat Ali, Awais Ahmad, Syed Shoaib Ahmad Shah, Iftikhar Hussain, Dongwhi Choi, Ammar M. Tighezza, Elsayed Tag-Eldin, Changlei Xia, Shafaqat Ali, Weihua Han	Nano Energy	2024	https://doi.org/10.1016/j.nanoen.2023.109108	https://www.sciencedirect.com/science/article/pii/S221128552300945X	2211-2855	The aqueous hybrid supercapacitor (AHSC) based on ammonium ion (NH4+) is an interesting energy storage device with excellent properties. However, the scarcity of appropriate and effective cathode materials limited its practicality. Two-dimensional (2D) transition metal nitrides, carbides, or carbonitrides (MXenes) show potential as cathode materials, but their low capacitance limits their applicability. Here, we synthesized N-functionalized 2D MXene (Ti3C2Tx) with Ti2N interface engineering (Ti2N Ti3C2Tx), which displayed not only superior capacitance and rate capability but also a cycling stability than pristine Ti3C2Tx. Ex-situ XRD and XPS were used to study the charge storage mechanism at the interface of Ti2N Ti3C2Tx. Furthermore, density functional theory (DFT) calculations were employed to validate the superior conductivity at the interface of the Ti2N Ti3C2Tx (Tx = OH) electrode. Moreover, AHSC was assembled with the Ti2N Ti3C2Tx as cathode, and activated carbon as anode possesses outstanding energy storage performance. This study not only elucidates the charge storage process of Ti2N Ti3C2Tx but also provides new insights for designing novel cathode materials for energy storage devices.	{"Aqueous hybrid supercapacitor","Interface engineering",Ti2N/Ti3C2Tx,Ti3C2Tx,"Density functional theory (DFT)"}
833	2D (Ti3C2Tx) MXene: A comprehensive review of advancements in synthesis protocols, applications in supercapacitors, sustainability targets and future prospects	Suresh Jayakumar, P. Chinnappan Santhosh, S. Ramakrishna, A.V. Radhamani	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.112741	https://www.sciencedirect.com/science/article/pii/S2352152X24023272	2352-152X	In recent years, the demand for energy storage devices that are efficient, cost-effective, and adaptable has been steadily increasing, driven by the rapid evolution of technology. Extensive research is underway on materials utilized in energy storage devices, with increasing attention being directed towards 2D materials. MXene stands out among 2D materials due to its rising popularity, attributed to its strong conductivity, hydrophilic properties, thin structure, improved mechanical characteristics, and adjustable electrochemical properties. Furthermore, the global market value of MXene is anticipated to experience substantial growth, projecting a revenue increase to 32.84 million in 2023. The unique properties of MXene make them an ideal solution for high-performance energy storage applications, specifically supercapacitors. This review focuses on the top-down synthesis of Ti3AlC2 to Ti3C2Tx and Ti3C2Tx-MXene, specifically in the context of their use in supercapacitor applications. The review begins with an overview of supercapacitors, exploring different types and examining various MXene synthesis methods, including traditional techniques like HF treatment, novel methods like LiF + HCl, molten salt synthesis, and cutting-edge electrochemical etching processes. Moreover, this review discusses how the incorporation of Ti3C2Tx MXene with various composite materials like carbon, metal oxides, and polymers enhances performance in supercapacitors. Furthermore, this review article explores the performance of Ti3C2Tx MXene in various supercapacitors, including flexible, electrochromic, and lastly photo-rechargeable ones. Finally, sustainable goals achieved through Ti3C2Tx supercapacitors are discussed; in conclusion, this article highlights the challenges and prospects of advancing MXenes in supercapacitors, aiming to stimulate further development in this area.	{MXene,Ti3C2Tx,Etching,"Sustainable goals",Supercapacitor}
834	In situ growth of oxometallate-based coordination polymer decorated Ti3C2Tx MXene with enhanced water-assisted proton channels for flexible all-solid-state supercapacitor	Ying Huang, Shuai Zhang, Jiaming Wang, Xiaopeng Han, Xu Sun	Materials Letters	2023	https://doi.org/10.1016/j.matlet.2023.134965	https://www.sciencedirect.com/science/article/pii/S0167577X23011503	0167-577X	As promising electrode material contender for supercapacitors, MXene has high conductivity, abundant surface functional groups, and large surface area. However, the self-restacking of MXene leads to poor ion-accessible surface area and restricted ion transport routes. Water-assisted proton channels contained by Polyoxometallate-based coordination polymer (POMCP) can improve the efficiency of ion transport between MXene layers, which is conducive to enhancing the storage capacity and rate performance. Herein, [PW12O40] [Cu6O(TZI)3(H2O)6]4 OH 31H2O (CuCP) decorated Ti3C2Tx (CuCP MX) was synthesized by in-situ hydrothermal method. Attribute to the extended interlayer space and enhanced ion transport efficiency, CuCP MX exhibits excellent electrochemical energy storage properties. It is worth revealing that when assembling into an all-solid-state supercapacitor device (SC), excellent specific capacitance (380 mF cm2) and energy density (68.4 μWh cm2 at 540 μW cm2) were exhibited. CuCP MX is a considerable electrode material for supercapacitors for flexible electronic devices.	{"Energy storage and conversion",Nanocomposites,"Thin films"}
835	Self-powered fire alarm system based on Ti3C2Tx MXene PVP Piezoelectric fibers multilayers embedded with additively manufactured TPMS spacers with tunable stiffness	Zhong Wei Guo, Chih Chia Chen, Yi Ting Huang, Yiin Kuen Fuh	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2024.158423	https://www.sciencedirect.com/science/article/pii/S1385894724099145	1385-8947	This study proposes an innovative concept of using Near-Field Electrospinning (NFES) technology to create an MXene polyvinylpyrrolidone (PVP) paper and piezoelectric nanogenerator (PENG) combination self-powered fire sensor (MPSFS). This technology combines polyvinylidene fluoride-trifluoroethylene (PVDF-TrFE) nanofibers with flexible printed circuit boards (FPCBs), encapsulating them in polydimethylsiloxane (PDMS) to form a PENG system. This system is then integrated with Ti3C2Tx MXene PVP, and TPMS structure spacers are added to enhance the output efficiency of the nanogenerator, creating a fire alarm sensor. The MXene-based film, owing to covalent bonds between PVP molecules and MXene sheets, exhibits high flame retardancy, making it suitable for sensitive and reusable fire alarms. Through thermal oxidation treatment, the MXene film transforms into a fish-scale-like C N mixed titanium dioxide network, enabling it to quickly excite electrons under continuous flame exposure, achieving ultra-fast fire alarm response (about 3.0 s) and cyclic fire alarm function. The MXene PVP films provide excellent flame retardancy and reusability in fire response, while the introduction of triply periodic minimal surface (TPMS) structures not only enhances the mechanical strength of the system but also improves the charging efficiency of the nanogenerator due to their inherent stiffness. This innovative system significantly reduces fire risk and demonstrates great potential and application prospects in advancing fire safety technology.	{"Ti3C2Tx MXene","Near-field electrospinning (NFES)","Fire cyclic warning sensor","Piezoelectric nanogenerator (PENG)","Resistance transition","Triply periodic minimal surface (TPMS)"}
836	The surface functional modification of Ti3C2Tx MXene by phosphorus doping and its application in quasi-solid state flexible supercapacitor	Xiaochun Wei, Man Cai, Fulin Yuan, Dan Lu, Cong Li, Haifu Huang, Shuaikai Xu, Xianqing Liang, Wenzheng Zhou, Jin Guo	Applied Surface Science	2022	https://doi.org/10.1016/j.apsusc.2022.154817	https://www.sciencedirect.com/science/article/pii/S0169433222023455	0169-4332	The surface modification of MXene by heterogeneous atoms shows great potential in improving the charge storage capacity of MXene. Herein, a strategy of rapid in-situ phosphorus doping at low temperature is demonstrated for preparing functionalized Ti3C2Tx MXene (Ti3C2Tx-P) using sodium hypophosphate as phosphorus source. The phosphorus doping can increase the layer spacing of Ti3C2Tx and yield PO and PC bonds in Ti3C2Tx, resulting in more rapid paths for the migration of electrolyte ions into electrode and more active sites for pseudocapacitance effects. As flexible electrode of supercapacitor, the specific capacitance of Ti3C2Tx-P reaches as high as 476.9F g 1 (745.4F cm 3), which is far larger than that of the raw Ti3C2Tx (344.4F g 1, 438.5F cm 3). In addition, a flexible quasi-solid supercapacitor device assembled by Ti3C2Tx-P film shows high specific capacitance of 103F g 1 at 5 mV s 1. When the power density is 250 W kg 1 and 10000 W kg 1, the corresponding energy density reaches 15.8 Wh kg 1 and 6.1 Wh kg 1, respectively. Therefore, our work not only reveals the role of P atom doping in improving the structure, composition and electrochemical performance of Ti3C2Tx, but provides a method for surface modification and functionalization of MXene materials.	{MXene,"Flexible supercapacitor","Quasi-solid state device",Pseudocapacitance}
837	Flexible Ti3C2Tx MXene V2O5 composite films for high-performance all-solid supercapacitors	Wenlong Luo, Yue Sun, Zhongtai Lin, Xue Li, Yongqin Han, Jianxu Ding, Tingxi Li, Chunping Hou, Yong Ma	Journal of Energy Storage	2023	https://doi.org/10.1016/j.est.2023.106807	https://www.sciencedirect.com/science/article/pii/S2352152X23002049	2352-152X	Designing and synthesizing flexible self-supporting materials with high electrical conductivity and flexibility are the key to the development of wearable energy storage devices. Herein, a strategy to prepare Ti3C2Tx MXene V2O5 (MV) films as flexible electrode materials for supercapacitors by vacuum-assisted filtration of a mixture of MXene nanosheets and V2O5 nanofibers is reported. The introduction of V2O5 nanofibers effectively suppresses the self-stacking phenomenon of MXene nanosheets, and simultaneously regulates the thickness of the MV films by controlling the amount of V2O5 nanofibers. Benefiting from the efficient intercalation of V2O5 nanofibers, the Ti3C2Tx MXene V2O5 (20 mg) (MV2) film as electrode shows good capacitive performance (319.1 F g 1, 0.5 A g 1) and cycling stability (70.4 , 5000 cycles, 3 A g 1). Furthermore, the MV2 MV2 symmetric supercapacitor (SSC) and the MV2 MnO2 asymmetric supercapacitor (ASC) are assembled, which separately have 72.1 and 83.9 capacitance retention after 8000 charge discharge cycles at 2 A g 1. The SSC exhibits an energy density of 18.43 Wh kg 1 at 603.2 W kg 1 power density, and the ASC provides an energy density of 20.83 Wh kg 1 at 374.94 W kg 1 power density, indicating their good energy storage capacity. This study provides a new strategy to improve the electrochemical properties and flexibility of Ti3C2Tx and a reliable method for its application in flexible wearable devices.	{"Ti3C2Tx MXene","V2O5 nanofibers","Composite film",Flexibility,Supercapacitor}
838	Tin(IV) selenide anchored-biowaste derived porous carbon-Ti3C2Tx (MXene) nanohybrid: An ionic electrolyte enhanced high performing flexible supercapacitor electrode	Shrabani De, Chandan Kumar Maity, Myung Jong Kim, Ganesh Chandra Nayak	Electrochimica Acta	2023	https://doi.org/10.1016/j.electacta.2023.142811	https://www.sciencedirect.com/science/article/pii/S0013468623009878	0013-4686	A facile hydrothermal growth and intercalation of tin(IV) selenide (SnSe2) over the interface of activated porous carbon (APC) Ti3C2Tx (MXene) were studied as a positive electrode for asymmetric flexible supercapacitor. The porous carbon was derived from the walnut shell biowaste and activated with KOH to obtain a highly porous uniform structure (APC), which gets encapsulated by Ti3C2Tx sheets and restricted the restacking tendency of Ti3C2Tx leading to the increment in electrochemical activity. Additionally, SnSe2 plays a crucial role by incorporating reactive centers over the APC Ti3C2Tx binary composites, which greatly enhanced the electrode capacitance. Due to the excellent morphological feature, the best electrochemical performance was obtained from APC Ti3C2Tx SnSe2 with an outstanding specific capacitance of 815 F g 1 in a three-electrode setup. Device performances of APC Ti3C2Tx SnSe2 as cathode were tested using both organic and ionic [(NEt3H)+(HSO4) ] electrolytes. However, the supercapacitor device revealed superior supercapacitive performances in ionic electrolyte having an outstanding energy density (102 Wh kg 1), specific capacitance (227 F g 1), and decent rate capability. The estimated volumetric energy density in the ionic electrolyte for the device was 1.887 mW h cm 3. Furthermore, a flexible asymmetric supercapacitor device was fabricated using viscous ionic electrolyte and it was capable to glow a red LED while it was bent in different angles. The methods described here will enhance the study of MXene-based nanohybrid as well as waste material management and cover the usage of biowaste in next-generation supercapacitor electrode materials.	{"Activated porous carbon",Ti3C2Tx,SnSe2,"Ionic electrolyte","Flexible supercapacitor"}
839	Photothermal processing of crumpled Ti3C2Tx MXenes with nitrogen sulfur co-modification for boosting capacitance performance	Hailong Shen, Hongying Zhao, Liqing Yan, Jiaheng Xu, Lin Li, Shuaikai Xu, Xianqing Liang, Wenzheng Zhou, Haifu Huang	Carbon	2025	https://doi.org/10.1016/j.carbon.2025.120021	https://www.sciencedirect.com/science/article/pii/S0008622325000375	0008-6223	MXenes has high appeal in the field of energy storage due to its unique structure and electrochemical activity. However, the self-stacking of nanolayers in MXenes structures hinders ion transport between the electrode and electrolyte. To address this issue, we employed photothermal-assisted synthesis based on ultraviolet radiation to introduce nitrogen and sulfur into the lattice structure of Ti3C2Tx MXenes. This approach effectively regulates the surface groups of MXenes and increases the interlayer spacing. Density functional theory calculations have revealed that the introduction of nitrogen sulfur atoms increases the electron density of states near the Fermi level of Ti3C2Tx and opens up new electron transfer pathways, allowing more electrolyte ions to penetrate two-dimensional nanochannels and enhance ion diffusion kinetics. As expected, nitrogen sulfur co-modified Ti3C2Tx has a higher specific capacitance value (424 F g 1) compared to the original Ti3C2Tx (330 F g 1). Furthermore, symmetric MXenes supercapacitor delivers an energy density of 18.61 Wh kg 1 at a power density of 500 W kg 1. Therefore, our work not only clarifies the role of nitrogen and sulfur atom co-doping in enhancing the structure and electrochemical performance of Ti3C2Tx, but provides a theoretical understanding of the synergistic mechanism of diatomic co-doping on the electrochemical properties of MXenes.	{"Nitrogen-sulfur doping","Photothermal-assisted synthesis","Capacitance performance","Flexible supercapacitor"}
840	Unlocking the key roles of N,P co-doping in Ti3C2Tx MXene for lithium-ion storage: lower lithium ion diffusion resistance and more lithium active sites	Yunhao Wu, Zhen Wang, Zijun Du, Di Zhang, Jiaxuan Li, Juan Zhang, Jianling Li	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117671	https://www.sciencedirect.com/science/article/pii/S2352152X25023849	2352-152X	2D layered Ti3C2Tx materials attract great attention in lithium-ion energy storage field due to their unique surface chemistry properties. However, the low capacity accompanied by sluggish lithiation kinetics of electrodes made from multi-layer MXene has limited their further application for lithium ion storage. The key challenge to overcome the abovementioned issue is to increase the concentration of active sites in the MXene electrode for lithium storage and to reduce the lithium ion diffusion resistance. In this study, N,P-MXene composites were prepared by hydrothermal construction of N,P elemental functional groups in multilayer MXene. The uniformly distributed N,P elemental functional groups effectively enhance the interlayer spacing of the material and expand the specific surface area. The in situ EIS test shows that the N,P doping effectively reduces the SEI film formation resistance and improves the lithium ion diffusion coefficient. Meanwhile, DFT calculations demonstrate that P-doped functional groups can effectively improve MXene conductivity, reduce lithium adsorption energy, and provide more active sites for lithium storage. The electrochemical activity of P-containing functional groups provides additional lithium ion active sites for lithium storage. After N,P doping, the MXene material with increased layer spacing (N,P-MXene) exhibits a high reversible capacity of 126.7 mAh g at 3000 mA g ( 232 of the original value) and an excellent outstanding cycling stability for 1700 cycles at 150 mA g for lithium ion storage. By coupling the N,P-MXene negative electrode to the LiFePO4 positive electrode, the assembled lithium-ion batteries can provide a high specific capacity of over 300 mAh g.	{"Ti3C2Tx materials","N, P co-doping","Hydrothermal synthesis","Lithium-ion batteries","In situ characterization"}
841	Rational design of cobalt ion chelated quasi-monolayer Ti3C2Tx MXene with abundant surface loading for high-performance asymmetric supercapacitor	Guandan Lu, Xuteng Xing, Jia Zhang, Xiaoyang Xu, Xiangjing Zhang, Haining Liu, Jiye Fan, Bingzhu Zhang	Colloids and Surfaces A: Physicochemical and Engineering Aspects	2023	https://doi.org/10.1016/j.colsurfa.2023.131694	https://www.sciencedirect.com/science/article/pii/S0927775723007781	0927-7757	The cobalt ion chelated Ti3C2Tx MXene (Co Ti3C2Tx MXene) composite is designed prepared by alkalizing quasi-monolayer Ti3C2Tx MXene supernatant into -OH rich sample, followed by cobalt ion chelation, to achieve the high loading amount of Co element. The optimized Co Ti3C2Tx MXene can display the high specific capacity of 48 mAh g at the current density of 1 A g, much higher than Ti3C2Tx MXene, which is attributed to the highly dispersed quasi-monolayer structure, additional Faradaic redox reaction of Co (Ⅱ Ш), and enhanced conductivity from Co element. In terms of practical application, the assembled Co Ti3C2Tx MXene active carbon (AC) asymmetric supercapacitor device also exhibits the high energy density of 19 Wh kg, and good cycle stability. The alkali modification metal ion chelation is a simple and effective strategy to inhibit the stack and enhance electrochemical performances for Ti3C2Tx MXene.	{"Quasi-monolayer Ti3C2Tx MXene","Cobalt ion chelation","Asymmetric supercapacitor"}
842	Bacterial cellulose modified polyaniline Ti3C2Tx MXene fiber to enhance robust and electrochemical activity for wire-shaped supercapacitors	Yang Zhang, Kangxin Qi, Xiangxiang Pi, Qingqing Tang, Qingquan Xue, Wei Chen, Diwei Gu, Jian Xu, Shenao Zhang, Yusen Wang, Yunxia Liang, Bin Sun, Wangyang Lu	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2025.180667	https://www.sciencedirect.com/science/article/pii/S0925838825022285	0925-8388	Developing miniaturization, adaptability and weavability wire-shaped supercapacitor (F-SC) with admirable electrochemical performance and exceptional mechanical properties, has been a pivotal issue for wearable system. Here, we fabricated flexible F-SCs assembled by heterogeneous polyaniline (PANI) bacterial cellulose (BC) Ti3C2Tx (PBT) hybrid fiber. BC nanofibers, as both reinforcement and spacer, can link with the adjacent Ti3C2Tx flakes together to enhance the mechanical properties and prevent the restacking of Ti3C2Tx flakes to accelerate the ion diffusion. And the PANI nanoparticle plays a crucial role in providing more active sites to improve the electrochemical performance. Besides, the continuous Ti3C2Tx sheet arrangement in hybrid fiber guarantees favorable conductivity and forms a smooth pathway for electron migration. Thus, the PBT fiber shows high mechanical property (123.42 MPa), mass capacitance of 337 F g 1 in 1 A g 1, superior rate performance (129 F g 1 at 10 A g 1) and exceptional cycling stability (84.1 capacitance retention after 10,000 cycling). Moreover, the solid-state symmetric F-SC displays capacitance of 259 F g 1, 86 capacitance retention after 10,000 cycles, maximum energy density of 7.28 Wh kg 1 and favorable mechanical endurance, which displays a promising future in smart wearable system.	{Ti3C2Tx,"Bacterial cellulose",Polyaniline,"Fiber-shaped supercapacitor",Robust}
843	Synergistic integration of amorphous MoSx nanoparticles with Ti3C2Tx MXene layers for high-performance ammonium-ion supercapacitors	Jinhe Wei, Fei Hu, Chenglong Lv, Xinyu Quan, Qiuyun Ouyang	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237747	https://www.sciencedirect.com/science/article/pii/S0378775325015836	0378-7753	The introduction of non-metallic charge carriers in electrochemical energy storage devices offers a significant advantage in compatibility with aqueous electrolytes. However, the development of suitable electrode materials for these carriers remains comparatively slower than other energy storage technologies. Here, the amorphous MoSx nanoparticles grow in situ on the surface of Ti3C2Tx nanosheets as host material for ammonium-ion supercapacitors. The Ti3C2Tx nanosheets provide a growth environment with large specific surface area for MoSx. The synergistic effect of heterojunction enhances the specific capacity of the composite. Amorphous MoSx nanoparticles form via an ethylene glycol solvent strategy. Compared with MoS2, the amorphous MoSx exhibits abundant defects and sulfur vacancies, which facilitate rapid NH4+ insertion de-insertion and promote hydrogen bond formation. Specifically, the Ti3C2Tx MoSx delivers a high specific capacity of 196.94 mAh g 1 at 1 A g 1 and retains 91.01 of its initial specific capacity after 10000 cycles. Moreover, the assembled symmetric supercapacitor achieves energy density of 50.08 Wh kg 1 at 500.81 W kg 1 and satisfactory cyclic stability. This work highlights the broad potential of composite engineering in optimizing the performance of ammonium-ion supercapacitor and reveals its important role in improving energy storage efficiency and performance stability.	{"Ti3C2Tx MXene","Molybdenum sulfide",Defects,"Ammonium-ion supercapacitor"}
844	An intercalated structure MXene CCNS: cuttlefish ink-derived carbon nanospheres composite Ti3C2Tx MXene for supercapacitors	Dawei Wang, Yue Lian, Qiuping Zhou, Hongliang Fu, Yongfeng Hu, Jing Zhao, Huaihao Zhang	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2025.167612	https://www.sciencedirect.com/science/article/pii/S1385894725084517	1385-8947	The Ti3C2Tx MXene with unique two-dimensional layered structure is a promising material for energy storage. However, the self-stacking behavior of MXene nanosheets limits its electrochemical performance. In this study, a heterostructured composite has been developed by intercalating cuttlefish ink-derived carbon nanospheres into layers of Ti3C2Tx MXene nanosheet through an electrostatic self-assembly method. This design effectively increases the interlayer spacing of MXene, and prevents it from tightly stacking. The heterostructure enlarges the specific surface area and exposes more active sites, thus improving the charge storage capacity and ion electron transport. In Addition, the heterostructure buffers the volume changes of electrode material during charge-discharge processes, resulting in enhanced cycling stability. Density functional theory (DFT) calculations confirmed that the heterostructure effectively modulates the electronic structure of MXene. Compared to pure MXene, the composite exhibits significantly improved specific capacitance (264 F g 1 at 0.5 A g 1), better rate capability (76.9 capacitance retention from 0.5 A g 1 to 10 A g 1) and greater cycling stability (93.4 capacitance retention after 5000 cycles). Based on this electrode material, the assembled symmetric supercapacitor achieves 12.8 Wh kg 1 of energy density at 0.2 kW kg 1 of power density and a capacitance retention of 91.7 after 5000 cycles.	{MXene,"Carbon nanospheres",Heterostructure,"Electrode materials",Supercapacitors}
845	g-C3N4 MoO3 heterostructure decorated Ti3C2Tx MXene film as a flexible electrode for supercapacitors with high energy density and low temperature tolerance	Qing Xu, Yuqing Chen, Yongjie Huang, Chunyan Xu, Chun Hu, Ningyi Jiang, Liying Yang, Shougen Yin	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.113968	https://www.sciencedirect.com/science/article/pii/S2352152X24035540	2352-152X	The stackable and collapsible nature of MXene films results in a low volumetric energy density for supercapacitors (SCs) used in mini-portable electronic devices. Herein, a self-supporting carbon nitride (g-C3N4) molybdenum trioxide (MoO3) titanium carbide (Ti3C2Tx) MXene (CMM) hybrid film was prepared by vacuum filtration method. The electrochemical properties of the CMM hybrid electrode indicates that the incorporation of g-C3N4 MoO3 heterostructure can effectively enhance the specific capacitance of CMM, which exhibits good electrochemical performance in a wide temperature range from 20 to 40 C. As expected, compared with the g-C3N4 Ti3C2Tx (402 F g 1), MoO3 Ti3C2Tx (625 F g 1), Ti3C2Tx (509 F g 1) electrodes, the optimal CMM electrode with 40 wt g-C3N4 MoO3 exhibited a specific capacity of up to 1168 F g 1 in 1 M H2SO4 electrolyte at 20 C with a current density of 1 A g 1. Moreover, it also shows satisfactory cyclic stability with capacitance retention of 96.8 after 5000 cycles at 10 A g 1. In addition, it demonstrates an energy density of 316 Wh kg 1 and a power density of 1250 W kg 1 at 20 C when used as the electrode for button-type asymmetric SCs. Even at 20 C, the CMM asymmetric SC presents an energy density of 230 Wh kg 1, a capacitance retention of 81 and coulombic efficiency of 92 after 5000 cycles. Our work proposes a simple and effective method of incorporation g-C3N4 MoO3 heterostructure on MXene nanosheets to improve the stability of MXene in application of energy storage.	{MXene,"Molybdenum trioxide","Graphitic carbon nitride",Heterostructure,Supercapacitor,Self-supporting}
846	Compression-tolerant supercapacitor based on NiCo2O4 Ti3C2Tx MXene reduced graphene oxide composite aerogel with insights from density functional theory simulations	Maozhuang Zhang, Degang Jiang, Fuhao Jin, Yuesheng Sun, Jianhua Wang, Mingyuan Jiang, Jiangyong Cao, Bo Zhang, Jingquan Liu	Journal of Colloid and Interface Science	2023	https://doi.org/10.1016/j.jcis.2022.12.159	https://www.sciencedirect.com/science/article/pii/S0021979722023128	0021-9797	Compression-tolerant electrodes are critical for developing next-generation wearable energy storage devices. However, most of previous studies on compressible electrodes focus on carbon-based materials, whereas metal-based materials such as spinel metal oxide with faradaic nature have been rarely studied due to their lack of compressibility. Herein, NiCo2O4 (NCO) microtubes assembled by ultrathin and mesoporous nanosheets, are deposited on into Ti3C2Tx MXene reduced graphene oxide aerogel (MGA), an intrinsically compressible host template with high conductivity and specific surface areas. The optimized NCO MGA-300 sample shows a reversible compressive strain of 60 and a superior durability. Density functional theory (DFT) calculations reveal that the NCO MGA-300 heterojunction has high electronic conductivity, fast electron transfer ability, and low adsorption energy for OH ions. As a result, the NCO MGA-300 electrode exhibits superb electrochemical performance in terms of its high gravimetric capacitance (1633F g 1 at 1 A g 1), rate performance (1492F g 1 at 10 A g 1), and remarkable cycling stability of 86.6 after 10,000 charge-discharging cycles. Moreover, an assembled asymmetric supercapacitor based on compressible NCO MGA-300 shows stable electrochemical performances under different compressive strains (20 . 40 and 60 ), or after 100 compression-release cycles. This research finding demonstrates the possibility of metal-based electrode for wearable devices with high energy storage capability and good compressibility.	{"Ti3C2Tx MXene",rGO,"Elastic aerogel","DFT calculation","Compressible supercapacitors"}
847	All-MXenes zinc ion hybrid micro-supercapacitor with wide voltage window based on V2CTx cathode and Ti3C2Tx anode	Tao Huang, Bowen Gao, Sairao Zhao, Haizhou Zhang, Xingxing Li, Xiao Luo, Minglei Cao, Chuankun Zhang, Shijun Luo, Yang Yue, Yanan Ma, Yihua Gao	Nano Energy	2023	https://doi.org/10.1016/j.nanoen.2023.108383	https://www.sciencedirect.com/science/article/pii/S2211285523002203	2211-2855	To further improve the electrochemical performance for the wearable and microelectronic devices, we reported an all-MXenes zinc ion hybrid micro-supercapacitor (ZIHMSC) with a wide voltage window (1.60 V) based on V2CTx as the cathode and Ti3C2Tx as the anode. The flexible V2CTx and Ti3C2Tx electrodes are fabricated by the electrophoretic deposition method, which is simple and conducive to the realization of positive and negative electrodes matching. Benefiting from the synergistic effect of the two MXenes and the unique configuration, our ZIHMSCs also achieve fast ion and electron transfer kinetics, showing better rate capability than the MXene Zn system. And the ZIHMSCs achieve excellent electrochemical performance, with high area capacitance of 200.1 mF cm 2, well stability over 5,000 charge discharge cycles, and high energy density of 71.6 μWh cm 2 at 400.7 μW cm 2. The reason for the wide voltage window of the ZIHMSC was well revealed by the large work function difference between the two electrode materials of V2CTx and Ti3C2Tx and the redox potential of the electrolyte. And the electrochemical energy storage mechanisms are well investigated by ex-situ XPS and XRD. In addition, the ZIHMSC displays well flexibility and mechanical property, suffering from 15,000 bending cycles under 90 . The ZIHMSCs can successfully drive digital tubes and meters and enable digital meters to operate for more than 600 s, proving their practical application potential.	{V2CTx,Ti3C2Tx,"Wide voltage","Work function",Flexibility}
848	Synthesis and characterization of a nanocomposite consisting of Ti3C2Tx (MXene) and WS2 nanosheets for potential use in supercapacitors	Pınar Talay Pınar, Mehmet Gülcan, Yavuz Yardım	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2024.177656	https://www.sciencedirect.com/science/article/pii/S0925838824042440	0925-8388	With the growing demand for high-performance supercapacitor materials, this study explores the synthesis and electrochemical evaluation of Ti3C2Tx (MXene), WS2 nanosheets, and MXene WS2 nanocomposites. The aim is to develop materials with enhanced energy storage capabilities. To this end, the performance of MXene WS2 nanocomposites was compared to that of the individual materials. MXene, WS2 nanosheets, and MXene WS2 nanocomposites were synthesized through chemical and hydrothermal methods, and their morphology was characterized using scanning electron microscopy and energy-dispersive X-ray spectroscopy, while Fourier transform infrared spectroscopy confirmed the presence of functional groups. Electrochemical analysis of WS2, MXene, and MXene WS2 was conducted in a 1 M H2SO4 electrolyte using cyclic voltammetry (CV), galvanostatic charge-discharge (GCD), and electrochemical impedance spectroscopy (EIS). The specific capacitance (Cs) values for WS2 were 58 F g (at 5 mV s) and 47 F g (at 0.4 A g); for MXene, the Cs values were 98 F g (at 5 mV s) and 71 F g (at 0.4 A g), while MXene WS2 exhibited much higher Cs values of 322 F g (at 5 mV s) and 373 F g (at 0.4 A g). EIS results indicated a lower charge transfer resistance (Rct) for MXene WS2 (2.29 Ω) compared to WS2 (5.25 Ω) and MXene (3.41 Ω). These findings demonstrate that MXene WS2 nanocomposites have superior electrochemical properties, making them promising candidates for high-energy supercapacitor applications.	{Characterization,"Cyclic voltammetry",Charge/discharge,Nanocomposite,"Ti3C2Tx (MXene)",Supercapacitor}
849	2,6-Diaminoanthraquinone modified MXene (Ti3C2Tx) graphene as the negative electrode materials for ionic liquid-based asymmetric supercapacitors	Li Sun, Lujia Chai, Liangqi Jing, Yujuan Chen, Kelei Zhuo, Jianji Wang	Green Energy Environment	2025	https://doi.org/10.1016/j.gee.2024.08.004	https://www.sciencedirect.com/science/article/pii/S2468025724002401	2468-0257	Due to insufficient energy density, supercapacitors (SCs) with preeminent-power and long cycle stability cannot be implemented in some practical applications. Exploring hybrid materials with redox activity to emerge high specific capacitance in ionic liquid (IL) electrolytes can solve this problem. Herein, we report a redox-organic molecule 2,6-diaminoanthraquinone (DAAQ) modified MXene (Ti3C2Tx) Graphene (DAAQ-M G) composite material. With the assist of graphene oxide (GO), MXene and graphene fabricate a three-dimensional (3D) interconnected structure as a conductive framework, which inhibits self-stacking of MXene monolayers and ensures high electronic conductivity. Meanwhile, DAAQ is loaded onto the M G framework through covalent non-covalent functionalization. The DAAQ as a spacer effectively enlarges the interlayer spacing of MXene nanosheets, and meanwhile produces reversible redox reactions during charge discharge processes to provide additional Faradaic contribution to capacity. Therefore, the specific capacitance (capacity) of the DAAQ-M G as the negative electrode material reaches to 226 F g 1 (306 C g 1) at 1 A g 1 in 1-ethyl-3-methylimidazolium tetrafluoroborate (EmimBF4) electrolyte. Furthermore, an asymmetric supercapacitor (ASC) is assembled using DAAQ-M G as the negative electrode and self-prepared organic molecule hydroquinone modified reduced graphene oxide (HQ-RGO) material as the positive electrode, with a high energy density of 43 Wh kg 1 at high power density of 1669 W kg 1. The ASC can maintain 80 of initial specific capacitance after 9000 cycles. This research can provide better support to develop advanced organic molecules-modified MXene composite materials for ionic liquid-based SCs.	{MXene,"2,6-diaminoanthraquinone","Conductive framework","Ionic liquid","Asymmetric supercapacitor"}
850	Significantly enhanced electrochemical performance of Al-Ti3C2Tx MXene synthesized from Al-Ti3AlC2 MAX phase	Haiyan Chen, Kefan Chen, Mingqing Lai, Ping Cai, Lixian Sun, Ruixiang Gao, Yaoben Xu, Siyuan Li, Tangyou Sun, Fen Xu, Hongliang Peng	Ceramics International	2024	https://doi.org/10.1016/j.ceramint.2024.10.256	https://www.sciencedirect.com/science/article/pii/S0272884224047771	0272-8842	MXenes, a type of two-dimensional nanomaterials consisting of transition metal carbides nitrides, have emerged as promising electrode materials for supercapacitors. Especially, Ti3C2Tx MXene prepared from Ti3AlC2 MAX phase shows great application potential in flexible supercapacitors due to its facile synthesis, excellent conductivity and film-forming property. In contrast to conventional Ti3AlC2, excessive aluminum is incorporated in the synthesis process to produce Al-Ti3AlC2. In this study, Ti3AlC2 and Al-Ti3AlC2 MAX phases are used to synthesize Ti3C2Tx and Al-Ti3C2Tx MXenes, respectively, by the same method of HF:HCl etching and LiCl intercalation. The freestanding Ti3C2Tx and Al-Ti3C2Tx film electrode is separately prepared through simple vacuum filtration. The presence of excess aluminum during the Al-Ti3AlC2 synthesis facilitates to form more homogeneous grains structure with relatively larger particle sizes and an improved stoichiometric MAX phase with a Ti:C ratio closer to 3:2. The resulting Al-Ti3C2Tx nanosheets show improved oxidation resistance with relatively uniform and larger dimensions, which facilitate the higher conductivity with slightly increased interlayer spacing for the Al-Ti3C2Tx film. Therefore, the Al-Ti3C2Tx film electrode shows more efficient ions transport and charge transfer, and thus achieves significantly enhanced capacitance (399 F g 1 at 1 A g 1) and rate performance (63.6 retention from 1 to 10 A g 1) compared to the Ti3C2Tx film electrode (342 F g 1 at 1 A g 1, 55.6 retention from 1 to 10 A g 1). Moreover, the Al-Ti3C2Tx-based flexible sandwiched supercapacitor also exhibits superior energy storage performance. The impressive results indicate that Al-Ti3C2Tx MXene synthesized from Al-Ti3AlC2 MAX phase possesses the great application potential in flexible supercapacitors.	{"Al-Ti3AlC2 MAX phase","Al-Ti3C2Tx MXene","Film electrode","Flexible supercapacitor","Electrochemical performance"}
851	VOx anchored Ti3C2Tx MXene heterostructures for high-performance 2.2 V supercapacitors	Kiran Kumar Garlapati, Surendra K. Martha, Bharat B. Panigrahi	Journal of Power Sources	2024	https://doi.org/10.1016/j.jpowsour.2024.234503	https://www.sciencedirect.com/science/article/pii/S0378775324004555	0378-7753	Pseudocapacitive materials with superior electrochemical properties have attracted significant interest in developing high-performance supercapacitors. Herein, VOx anchored Ti3C2Tx MXene pseudocapacitive materials are synthesized via a solvothermal method to synergize metallic electrical conductivity and redox activity. Pure vanadium oxide synthesis results in VO2 formation, while in the presence of Ti3C2Tx, quasi-metallic V2O3 and VO2 (VOx) are observed due to the decomposition of surface functionalities of Ti3C2Tx. The growth of the V2O3 phase increases with an increase in the weight concentration of Ti3C2Tx. The optimal composition of heterostructure delivers a specific capacitance of 364 F g 1 in a stable potential window of 0.9 V 1 V, surpassing the specific capacitance of pure VO2 (245 F g 1) and Ti3C2Tx (140 F g 1) in 0.5 M K2SO4 electrolyte. Furthermore, the developed symmetric supercapacitor (SSC) delivers an energy density of 45.7 Wh kg 1 at a power density of 1.1 kW kg 1 with cyclic stability of 78 for 10000 cycles with a self-discharge open circuit potential of 1.34 V. This work highlights a strategy to develop anodic and cathodic active pseudocapacitive material based SSC to improve energy density and mitigate self-discharge.	{Supercapacitors,MXenes,"Vanadium oxide",Pseudocapacitance}
852	Enhancing the ion accessibility of Ti3C2Tx MXene films by femtosecond laser ablation towards high-rate supercapacitors	Xianhong Zheng	Journal of Alloys and Compounds	2022	https://doi.org/10.1016/j.jallcom.2021.163275	https://www.sciencedirect.com/science/article/pii/S0925838821046855	0925-8388	MXenes have attracted tremendous attention in the area of electrochemical energy-storage devices owing to their high electrical conductivity, pseudocapacitance and two-dimensional lamellar structure. Nevertheless, MXene flakes intrinsically tend to lie flat and restack, resulting in highly tortuous ion transport pathways and inferior ion accessibility. Herein, we develop a femtosecond laser ablation strategy to fabricate flexible and high-performance MXene ribbon supercapacitor electrodes. The fabricated MXene ribbons have porous edges with exposed continuous lamellar channels, which shortens the H+ transport pathways, impregnates with sufficient electrolyte, benefits for H+ intercalation and ion storage. The resultant MXene ribbons exhibit high specific capacitance (1308.3 mF cm2), good rate capability and long cycling life (95 capacitance retention and 92 coulombic efficiency after 30,000 cycles). This work provides a new strategy for the rational structure design of high-rate MXene-based supercapacitor electrodes and lays the foundation for the next generation high-performance energy storage devices.	{"Femtosecond laser","MXene ribbon",Supercapacitor,"Specific capacitance"}
853	Bacterial cellulose Ti3C2Tx MXene hybrid fiber for high-performance flexible fiber-shaped supercapacitors	Yang Zhang, Shaoyi Wu, Yusen Wang, Xiangxiang Pi, Diwei Gu, Shenao Zhang, Jian Xu, Kangxin Qi, Wangyang Lu	Materials Letters	2025	https://doi.org/10.1016/j.matlet.2025.138627	https://www.sciencedirect.com/science/article/pii/S0167577X25006561	0167-577X	Effective design and construction of robust, flexible and highly electrochemical fiber shaped electrode with hierarchical nanostructures are critical for wearable energy storage device. Here, bacterial cellulose (BC) intercalated Ti3C2Tx (BCT) fiber was fabricated by wet spinning method for fiber shaped supercapacitors (FSC). BC can significantly impede the self-restacking of Ti3C2Tx flakes causing a porous structure and connect the adjacent Ti3C2Tx sheets constructing high mechanical strength. As a result, the BCT fiber provides high capacitance and good rate performance in three-electrode system. Moreover, the assembled symmetrical FSC based on BCT fiber presents favorable mass capacitance and excellent energy density, demonstrating a bright future in smart wearable system.	{"Bacterial cellulose",Ti3C2Tx,Fiber,"Flexible supercapacitor"}
854	The phosphorus doping modification of Ti3C2Tx MXene films assisted by tripolyphosphate-crosslinking for flexible supercapacitors	Dan Lu, Yiwei Lu, Yongfang Liang, Jianghai Li, Jiaheng Xu, Jinyu Wu, Haifu Huang, Shuaikai Xu, Xianqing Liang, Wenzheng Zhou	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.113524	https://www.sciencedirect.com/science/article/pii/S2352152X24031104	2352-152X	MXenes is a new two-dimensional material with good electrical conductivity and high theoretical pseudocapacitance, which is widely used in various energy storage devices. Heterogeneous atom doping is one of the effective strategies to adjust the properties of MXenes and improve its electrochemical performance. In this work, a facile and cost-effective KTPP (potassium tripolyphosphate, phosphorus source) assistance strategy is demonstrated to dope Ti3C2Tx MXene with phosphorus atoms by heat treatment. The results show that the phosphorus doping level reached 1.25 at. . As expected, the specific capacitance of the phosphate-doped Ti3C2Tx electrode is 365.1 F g 1 at the scanning rate of 10 mV s 1, which is twice that of the pristine Ti3C2Tx (183.1 F g 1). Besides, the flexible supercapacitor device assembled with Ti3C2Tx-P-300 C-3h sample has a high energy density of 10.76 Wh kg 1 at 483.03 W kg 1 power density and the capacitance retention rate is 84.51 after 5000 cycles at the current density of 1 A g 1. With bent at different angles (0 , 60 , 90 , 120 ), the specific capacitance values of flexible supercapacitor devices have not changed significantly, and the capacitance retention rate reached 90.09 . The reason for the enhanced electrochemical performance is that the phosphorus doping can increase the active sites of Ti3C2Tx, bring PO bonds that enhance activity, optimize the redox reaction process, and accelerate the ion transport rate. Therefore, a simple and effective method to improve the electrochemical performance of Ti3C2Tx MXene is proposed in this work.	{MXene,Ti3C2Tx,"Phosphorus doping",Supercapacitor,Pseudocapacitance}
857	MXene (Ti3C2Tx) cellulose nanofiber polyaniline film as a highly conductive and flexible electrode material for supercapacitors	Tao Yuan, Zhen Zhang, Qian Liu, Xiu-Tong Liu, Ya-Ning Miao, Chun-li Yao	Carbohydrate Polymers	2023	https://doi.org/10.1016/j.carbpol.2022.120519	https://www.sciencedirect.com/science/article/pii/S0144861722014242	0144-8617	In recent years, supercapacitors based on cellulose nanofiber (CNF) films have received considerable attention for their excellent flexibility, lightweight, and unique structure. In this study, MXene (Ti3C2Tx) CNF polyaniline (PANI) hybrid films with good conductivity and flexibility were prepared by a convenient vacuum filtration method. Combined with PANI, MXene creates an open structure with high conductivity, which facilitates ion and electron transport among the materials and provides the composite with high electrochemical activity. The MXene CNF PANI electrode presents a high areal specific capacitance of 2935 mF cm 2 at the current density of 1 mA cm 2, excellent cycling stability with high capacitance retention of 94 after 2000 cycles at 10 mA cm 2 and high electrical conductivity (634.4 S cm 1). As a further application of this film, it is used as a free-standing electrode to fabricate a quasi-solid-state supercapacitor with high performance, which has an ultra-thin thickness of 0.344 mm, a significantly high areal specific capacitance (522 mF cm 2) at 5 mA cm 2, a high areal energy density of 94.7 μWh cm 2 and a high areal power density of 573 μW cm 2. This work shows the great potential of the developed high-performance and flexible cellulose-based composites for fabricating electrodes as well as supercapacitors.	{MXene,"Cellulose nanofiber",Polyaniline,"Composite film",Supercapacitor}
858	Electrochemical investigation of Ti3C2Tx (MXene), N-Ti3C2Tx, and the Ti3C2Tx Co3O4 hybrid composite deposited on carbon cloth for use as anode materials in flexible supercapacitors Electronic supplementary information (ESI) available. See DOI: https: doi.org 10.1039 d4na01024h	Lan Nguyen, Adnan Ali, Brahim Aissa, Sosiawati Teke, Roshan Mangal Bhattarai, Avik Denra, Oai Quoc Vu, Young Sun Mok	Nanoscale Advances	2025	https://doi.org/10.1039/d4na01024h	https://www.sciencedirect.com/science/article/pii/S2516023025003223	2516-0230	Supercapacitors have been studied as a potential complementary technology for rechargeable batteries, fuel cells, and dielectric capacitors. Wearable energy storage systems need freestanding, flexible electrodes for maximum functioning. Optimal energy storage system performance demands an optimal balance between mechanical component flexibility and electrode energy storage and release efficiency. This work specifically focuses on investigation and comparison of the electrochemical performance of the synthesized Ti3C2Tx, N-Ti3C2Tx, and the Ti3C2Tx Co3O4 hybrid composite. Co3O4 NPs have been synthesized using an innovative and cost-effective novel synthesis route employing a microplasma discharge reactor . This offers significant benefits, including the effective prevention of hazardous reducing agent generation in comparison to other routes. Upon exposure to 1 A g 1 current density, the Ti3C2Tx Co3O4 hybrid composite electrode demonstrates a maximum gravimetric capacity of 128 F g 1 and a specific capacitance of 576.7 F g 1, exhibiting a significant 95.06 increase in specific capacitance compared to Ti3C2Tx. Furthermore, from the kinetic analysis of the CV curves, it has been noticed that the contributions of the diffusion-controlled and pseudocapacitive-controlled processes are 60 and 40 , respectively, in the charge storage for the applied Ti3C2Tx Co3O4 hybrid composite electrode.	{}
859	Sulfur-tuned MoS2 quantum dot decorated Ti3C2Tx (MXene) electrode materials for high performance supercapacitor applications	Sumanta Bera, Tapas Kumar Mondal, Yan-Kuin Su, Shyamal Kumar Saha	Journal of Alloys and Compounds	2024	https://doi.org/10.1016/j.jallcom.2024.174010	https://www.sciencedirect.com/science/article/pii/S0925838824005978	0925-8388	Recently, two dimensional materials have been considered as the exciting and most promising materials in the field of energy storage applications. Literature results show that the non-bridging S in MoS2 quantum dot act as efficient active sites for catalytic activity. But, the MoS2 quantum dots with sufficient non-bridging sulfur do not possess high electronic conductivity which is required for supercapacitor electrode applications. Therefore, exploiting large number of active sites and superior electronic conductivity in the present work we have decorated Ti3C2Tx sheets by MoS2 quantum dots with a large number of non-bridging S . We have synthesized three composite samples by varying S components and seen that the sulfur rich samples show the highest value of specific capacitance (SC) of about 985 Fg 1 because of the presence of unsaturated sulfur S22 ligands. The unique combination of MoS2 quantum dot and Ti3C2Tx shows excellent performance over a wide range of potential windows (-0.3 0.4 V to 0.7 0.8 V) with a high energy density 165.53 WhKg 1 at a power density 1100 WKg 1. Also, the SC retention values after 104 cycles are obtained over 96.53 at a current density (CD) 10 Ag 1.	{"Ti3C2Tx (Mxene)","MoS2 quantum dots","S-rich MSM","S-deficient MSM",MSM,"Unsaturated Sulfur S22-"}
860	Electrophoretic deposition of Ti3C2Tx MXene nanosheet N-carbon cloth as binder-free supercapacitor electrode material	Zhichao Li, Xinyu Liu, Xuyun Wang, Hui Wang, Jianwei Ren, Rongfang Wang	Journal of Alloys and Compounds	2022	https://doi.org/10.1016/j.jallcom.2022.166934	https://www.sciencedirect.com/science/article/pii/S0925838822033254	0925-8388	Despite the existing advances of Ti3C2Tx MXene as supercapacitor electrode material, its capacitance can be further enhanced through the composite strategy. In this work, the nitrogen-doped superhydrophilic carbon cloth (ENCC) was firstly prepared by N-doping of carbon cloth (CC), and then Ti3C2Tx MXene nanosheets were electrophoretically deposited to yield the binder-free Ti3C2Tx(EPD) ENCC as supercapacitor electrode material. As a result, the composite electrode exhibited an area-specific capacitance of 2080.1 mF cm 2 at 1 mA cm 2 current density. The analysis implied that the varying Ti valence states provided certain psedocapacitance to the capacitance of the as-prepared electrode, though the main contribution was still dominantly from the electric double layer capacitance (EDLC). Further, the assembled symmetric supercapacitor yielded a wide voltage window of 1.8 V, and a good cyclic stability with 91 capacitance retention after 10,000 charge discharge cycles at 20 mA cm 2. Overall, the employed composite strategy enabled the good dispersion of the MXene flakes on the surface of the flexible substrate. Meanwhile, the large number of functional groups (-OH, -F, etc.) on the surface of Ti3C2Tx MXene interacted with the carbon layer through hydrogen bonding effects, which endows it as an ideal electrode for electrochemical capacitors.	{"Ti3C2Tx MXene","N-carbon cloth","Hydrogen bonding","Binder-free material","Electrophoretic deposition"}
861	Tailoring interlayer spacing of Ti3C2Tx MXene with organic acid doped polyaniline and polypyrrole for more stable supercapacitors	João V.M. Lima, Hugo G. Lemos, Rafael A. Silva, Jéssica H.H. Rossato, Miguel H. Boratto, Carlos F.O. Graeff	Journal of Alloys and Compounds Communications	2024	https://doi.org/10.1016/j.jacomc.2024.100007	https://www.sciencedirect.com/science/article/pii/S2950284524000079	2950-2845	Polyaniline (PANI) and polypyrrole (PPy) are promising for use as spacers materials to prevent re-stacking of MXene layers and to increase their electrochemical properties. However, these conducting polymers (CPs) may undergo hydrolysis during long charge-discharge cycles. The use of organic acids to dope CPs may lead to better polymer cyclic stability. However, PANI and PPy used as spacers in MXene are mainly doped with inorganic acids. Herein, we applied dodecylbenzenesulfonic acid (DBSA) doped PANI and PPy as effective spacers and additional pseudocapacitance agents for Ti3C2Tx MXene. Taking advantage of the favored dispersibility of the functional inks in water, we easily prepared the electrodes by drop casting. X-ray diffractograms confirmed that the CPs are effectively allocated among MXenes sheets. Spectroscopic analyses showed that the functional groups of Ti3C2Tx may work as effective dopants for PANI and PPy. The enhanced interlayer spacing of MXenes and increased high conductivity of CPs boosted capacitance from 175 F g 1 (Ti3C2Tx) to 255 F g 1 and 270 F g 1 at 1 A g 1 after addition of 10 wt of PANI and PPy, respectively, at a three-electrode setup. The Dunn s and Trasatti s methods showed greater pseudocapacitive contribution after addition of PPy and greater double layer capacitance contribution after addition of PANI. Similarly, symmetric solid-state SCs exhibited enhancement of 72 in specific capacitance for Ti3C2Tx PANI and 208 for Ti3C2Tx PPy, when compared to pristine Ti3C2Tx. SCs based on Ti3C2Tx CPs also yielded outstanding capacitance retentions (>98 ) after 5000 cycles against only 88 of the Ti3C2Tx pristine device. These results indicate that the organic doped-CPs modulated interlayer spacing of MXene sheets, preventing their re-stacking during the charge and discharge cycles. Finally, the aqueous Ti3C2Tx CPs based inks is an eco-friendly and low-cost alternative to fabricate SCs with enhanced capacitance and stability.	{Supercapacitors,"Ti3C2Tx MXene","Conducting polymers",Polyaniline,Polypyrrole,"Organic acids"}
862	Fabrication of a flexible asymmetric supercapacitor using molybdenum selenide and titanium carbide mxene (MoSe2 Ti3C2Tx) nanocomposite on carbon cloth	Kuppu Sakthi Velu, Sonaimuthu Mohandoss, Yong Rok Lee, Jeong Hyun Seo	Ceramics International	2025	https://doi.org/10.1016/j.ceramint.2025.01.213	https://www.sciencedirect.com/science/article/pii/S0272884225002408	0272-8842	Herein, we developed 1T-phase flower-like molybdenum selenide (MoSe2) decorated on titanium carbide MXene (Ti3C2Tx) nanocomposites using a simple hydrothermal method and hydrofluoric acid etching. The as-prepared MoSe2 nanoflower, Ti3C2Tx sheet, and MoSe2 Ti3C2Tx nanocomposite were comprehensively characterized using various techniques, including FE-SEM with EDS mapping, TEM, XPS, and XRD analysis. FE-SEM images revealed a captivating flower-like nanocomposite structure, where the hexagonal lattice of the MoSe2 monolayer is skillfully enveloped within the Ti3C2Tx sheet, forming an esthetically complex architecture. EDS mapping confirmed the presence of Mo, Se, Ti, C, O, and F in the MoSe2 Ti3C2Tx nanocomposite. TEM images displayed the nanoflower structure enveloped in the sheet-like MoSe2 Ti3C2Tx nanocomposite. XRD patterns confirmed the hexagonal crystalline structure of MoSe2 Ti3C2Tx. The electrochemical performance of MoSe2 Ti3C2Tx as a symmetric supercapacitor surpassed that of the pristine MoSe2 nanoflower and Ti3C2Tx sheet. Moreover, the asymmetric supercapacitor configuration, comprising CC MoSe2 Ti3C2Tx activated carbon CC electrodes, demonstrated exceptional electrochemical performance, delivering a specific capacitance of 660 F g 1 at a current density of 1 A g 1, alongside an energy density of 33.3 Wh kg 1 and a power density of 1683 W kg 1. The MoSe2 Ti3C2Tx nanocomposite, coated onto carbon cloth as the working electrode in a solid-state supercapacitor device, achieved a specific capacitance of 223.12 F g 1, an energy density of 7.74 Wh kg 1, and a power density of 292.60 W kg 1.	{MoSe2,Ti3C2Tx,Nanoflower,"Cyclic voltammetry","Asymmetric supercapacitor","Carbon cloth"}
863	Flexible, temperature-tolerant supercapacitor based on Ti3C2Tx MXene in ionic liquid gel electrolyte	Jingdi Shang, Libo Wang, Ying Gao, Ji a Yang, Qixun Xia, Qianku Hu, Aiguo Zhou, Bo Wang	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.116488	https://www.sciencedirect.com/science/article/pii/S2352152X25012010	2352-152X	Due to its unique structure and performance, Ti3C2Tx has been widely investigated as an electrode material for flexible energy storage devices using hydrogel as a solid electrolyte. The composition and structure of hydrogels determine their poor performance at high temperatures and there is little research on MXene flexible devices at high temperature. In this work, we designed a method for preparing capacitors with Ti3C2Tx as the electrode material and ionic liquid as the electrolyte. By leveraging the high permeability of ionic polymer solution, a seamless electrode-electrolyte interface is constructed. The device can achieve a maximum capacitance of 173.8 mF cm 2 at a 5 mV s 1 scan rate, with a maximum specific energy density and power density of 96.57 μWh cm 2 and 1.74 mW cm 2, respectively. The capacitor retains 89.5 of its initial capacitance after 20,000 cycles, demonstrating excellent cycle stability. Importantly, the supercapacitor can operate at 100 C with a specific capacitance of 278.66 mF cm 2. In addition, the designed device can retains 100 or more of its capacitance even after 1000 cycles of 180 bending demonstrating robust mechanical performance. This work provides a reference for studying the application of MXene in high-temperature flexible supercapacitor.	{Ti3C2Tx,Supercapacitor,"Ionic liquid gel electrolytes",Flexible}
864	Integrating V-doped CoP on Ti3C2Tx MXene-incorporated hollow carbon nanofibers as a freestanding positrode and MOF-derived carbon nanotube negatrode for flexible supercapacitors	Ishwor Pathak, Bipeen Dahal, Debendra Acharya, Kisan Chhetri, Alagan Muthurasu, Yagya Raj Rosyara, Taewoo Kim, Syafiqah Saidin, Tae Hoon Ko, Hak Yong Kim	Chemical Engineering Journal	2023	https://doi.org/10.1016/j.cej.2023.146351	https://www.sciencedirect.com/science/article/pii/S1385894723050829	1385-8947	Novel architectural electrode materials that are freestanding and exhibit improved electrochemical performances in flexible asymmetric supercapacitors are urgently needed; however, designing these materials is challenging. Herein, a Ti3C2TX MXene-aligned hollow carbon fiber (MX HCF) is engineered and vanadium-doped cobalt phosphide nanorod arrays are grown on it (V-CoP MX HCF) and applied for supercapacitor positrode. V doping modulates the surface structure and electronic environment of CoP nanorods grown over conductive and flexible MX HCFs. As expected, the optimized V-CoP MX HCF exhibits a better electrochemical performance (1896.8Fg 1) than that of CoP MX HCF and CoP HCF. For the negative electrode, zeolitic imidazolate framework-67 (ZIF-67) grown on electrospun polyacrylonitrile (PAN) fibers is converted to cobalt nanoparticle-encapsulated nitrogen-doped carbon nanotubes at carbon nanofibers (Co-CNT CNF) by a simple heat treatment without the burden of external catalysts and reducing gases. The as-designed freestanding Co-CNT CNF delivers a specific capacitance of 405.5Fg 1 with superior cycling stability. A flexible asymmetric supercapacitor (V-CoP MX HCF Co-CNT CNF) is designed that unveil remarkable electrochemical properties, such as a high energy density of 72.4 Wh kg 1 at 800.12 W kg 1 and good capacitance retention (91.4 ) after 10,000 charge discharge cycles. Furthermore, the device can maintain a consistent performance regardless of the bending degree. More importantly, this work provides new opportunities to rationally design novel freestanding cathodes and anodes for high-performance flexible asymmetric supercapacitors.	{"Ti3C2Tx MXene","hollow CNF","Vanadium doping","Carbon nanotube",Freestanding,"Flexible supercapacitor"}
865	Ti3C2Tx MXene based hybrid electrodes for wearable supercapacitors with varied deformation capabilities	Jingmin Zhang, Degang Jiang, Leiping Liao, Liang Cui, Rongkun Zheng, Jingquan Liu	Chemical Engineering Journal	2022	https://doi.org/10.1016/j.cej.2021.132232	https://www.sciencedirect.com/science/article/pii/S1385894721038110	1385-8947	Free-standing electrodes with high electrical conductivity, good deformability and durability are critical for flexible electronics, especially in field of wearable energy storage devices. Here, three dimensional (3D) Ti3C2Tx MXene reduced graphene oxide (rGO) carbon (MGC-500) hybrid electrode fabricated by the simple template method is presented. Commercial melamine foam (MF) worked as template not only enables the Ti3C2Tx rGO nanosheets to form a porous architecture, but also introduces the heteroatom nitrogen into the Ti3C2Tx rGO nanosheets during the annealing process. The as-prepared MGC-500 electrode shows a gravimetric capacitance of 276F g 1 at a current density of 0.5 A g 1. When the MGC-500 hybrid electrodes are assembled into an all solid-state supercapacitor, it shows a stable electrochemical performance at different compressive strains. Notably, we find that the MGC-500 foam electrode coated with PVA-H2SO4 gel electrolyte can be compressed into flexible film at 80 of compression. And the supercapacitor devices assembled by the film also exhibit stable capacitance under different modes of deformations such as bending and twist. The developed template approach offers a simple strategy to fabricate free-standing Ti3C2Tx MXene electrode for energy storage devices that can withstand varied deformations, and also can be extended to other members of the large MXene family.	{"Ti3C2Tx MXene",Graphene,"Foam electrode","Wearable supercapacitor","Varied deformation"}
866	Designing an electrochemical energy storage device using recycled Ti3C2Tx MXene and reduced graphene oxide spent wastewater adsorbents	Marcelo A. Andrade, Olivier Crosnier, Patrik Johansson, Thierry Brousse	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.147176	https://www.sciencedirect.com/science/article/pii/S001346862501535X	0013-4686	This study presents an end-to-end approach for recycling hazardous waste heavy-metal-loaded adsorbents into electrode materials for electrochemical energy storage. Using reduced graphene oxide (rGO) and Ti₃C₂Tₓ MXene as adsorbents for Hg² , Cu² , and Pb² from model wastewater solutions, we demonstrate their successful transformation into redox-active electrodes without any additional treatment. The recycled electrodes present superior capacity as compared to their pristine counterparts, while introducing distinct reversible redox features. Ultimately, the different recycled materials were assembled in full cell configurations, combining different metal-loaded adsorbents, yielding synergistic redox plateaus and an up to 50 enhancement in the initial energy storage capacity, depending on the metal pair and electrolyte used. The versatility of this recycling strategy was demonstrated across three aqueous electrolytes, including a water-in-salt electrolyte, revealing tunable redox behavior dependent on both metal and electrolyte characteristics. Furthermore, using a more complex model wastewater solution, containing two different metal cations, leads to a multi-contaminant adsorbent that exhibits additive electrochemical responses, thereby establishing proof-of-concept for the reuse of real-world wastewater adsorbents into energy storage devices.	{"Reduced graphene oxide",MXene,"Wastewater adsorbents","Heavy metals",Supercapacitor}
867	Butanedioic acid unlock shelf-stable Ti3C2Tx (MXene) dispersions and their electrochemical performance in supercapacitor	Jai Kumar, Razium Ali Soomro, Baomin Fan, Jiayi Tan, Ning Sun, Bin Xu	Journal of Alloys and Compounds	2024	https://doi.org/10.1016/j.jallcom.2024.176749	https://www.sciencedirect.com/science/article/pii/S092583882403336X	0925-8388	MXene experiences significant oxidation and gradual deterioration in aqueous media due to its inadequate chemical stability, which hinders its further advancement. This study presents a simple and effective approach to prevent the degradation of Ti3C2Tx MXene nanosheets in aqueous media by chemically encapsulating with butanedioic acid (succinic acid (SSA)). Specifically, the impact of pH and antioxidant content on the rate of oxidation of Ti3C2Tx is investigated together with their electrochemical behavior at different intervals. The research demonstrates that the oxidation rate of MXene must be prevented at a suitable concentration of antioxidants; higher doses of antioxidants cause aggregation, while lower concentrations accelerate the oxidation process. Furthermore, fluctuations in pH levels within the dispersion indicate that under acidic conditions, MXene experiences a greater level of oxidation as a result of elevated proton reactivity, which ultimately leads to material degradation. On the other hand, alkaline environments tend to reduce oxidative reactions, leading to increased stability of MXene. Consequently, MXene-SSA can demonstrate long-term stability in water for up to 35 weeks. The electrochemical properties of SSA-encapsulated MXene sheets are assessed as a supercapacitor electrode throughout a time gradient. In comparison to fresh MXene (299 F g 1 at 1 A g 1), the specific capacitances of SSA-protected MXene (321 F g 1 at 1 A g 1) remain unchanged after a long time. Based on DFT calculations, it has been observed that succinic acid creates beneficial hydrogen bonding interactions with Ti sites that possess a lower coordination number, hence improving the stability of Ti3C2Tx.	{Ti3C2Tx,Antioxidation,"Oxidation kinetics",Supercapacitor,DFT}
868	Heterostructured bimetallic sulfide layered Ti3C2Tx MXene as a synergistic electrode to realize high-energy-density aqueous hybrid-supercapacitor	Muhammad Sufyan Javed, Xiaofeng Zhang, Salamat Ali, Abdul Mateen, Muhammad Idrees, Muhammad Sajjad, Saima Batool, Awais Ahmad, Muhammad Imran, Tayyaba Najam, Weihua Han	Nano Energy	2022	https://doi.org/10.1016/j.nanoen.2022.107624	https://www.sciencedirect.com/science/article/pii/S2211285522007029	2211-2855	Aqueous hybrid supercapacitors (AHSCs) exhibit promising electrochemical performance with long cyclic stability and high power density. However, the low-energy density restricted their development to commercialization. To improve the energy density, we proposed a heterostructured (HS) composite of nickel cobalt sulfide (NCS) nanoflowers embedded in exfoliated Ti3C2Tx MXene layers (HS NCS MXene). The NCS nanoflowers were uniformly dispersed inside the MXene layers and formed a sandwich-like structure. The HS NCS MXene exhibited remarkable pseudocapacitive performance in a three-electrode system. The capacitance can reach 2637 F g 1 (1582 C g 1) at 2.5 A g 1 with stable cycling life over 10,000 cycles and retained 96 capacity of the initial value. Post mortem investigations confirmed that the charge storage mechanism in HS NCS MXene composite is a combination of Faradic and electrochemical double-layer storage. An AHSC was assembled by coupling the HS NCS MXene as a positive electrode and activated carbon as a negative electrode (HS NCS MXene AC AHSC). The HS NCS MXene AC AHSC can operate in a potential range up to 1.6 V and deliver a high capacitance of 226 F g 1 at 1.5 A g 1 with stable cyclic life (92 ) up to 20,000 cycles. Moreover, the HS NCS MXene AC AHSC also possessed a high energy density of 80 Wh kg 1 at a power density of 1196 W kg 1, which exceeds most recently published works. The synergistic effect of NCS and MXene enables the HS NCS MXene composite to deliver outstanding electrochemical performance for AHSCs.	{MXene,Bimetallic–sulfide,Heterostructure,"Hybrid supercapacitor",High–energy–density}
869	Cellulose nanofiber MXene (Ti3C2Tx) liquid metal film as a highly performance and flexible electrode material for supercapacitors	Tao Yuan, Zhen Zhang, Qian Liu, Xiu-Tong Liu, Shao-Qu Tao, Chun-li Yao	International Journal of Biological Macromolecules	2024	https://doi.org/10.1016/j.ijbiomac.2024.130119	https://www.sciencedirect.com/science/article/pii/S014181302400922X	0141-8130	In recent times, there has been significant interest in the utilization of cellulose nanofiber (CNF) films as the foundation for supercapacitors due to their three-dimensional structure, flexibility and eco-friendliness. An ultrasonic and vacuum filtration method was used to prepare a hybrid film consisting of MXene (Ti3C2Tx), CNF and liquid metal (LM). The combination of CNF and LM with MXene produces a porous structure with higher electrical conductivity, which facilitates the transportation of ions and electrons within the composition and confers the material with heightened electrochemical properties. The CNF MXene LM electrode has a significant area capacitance of 871.3 mF cm 2 at a current density of 5 mA cm 2. The hybrid film demonstrates excellent stability, maintaining a high conductivity of 546.4 S cm 1 and retaining 96.9 capacitance after 2000 cycles at a current density of 10 mA cm 2. By utilizing the thin film as an electrode, a high-performance quasi-solid supercapacitor was fabricated, with a remarkably thin thickness of only 0.319 mm. Supercapacitors show exceptional electrical properties, including a surface-specific capacitance of 188.2 mF cm 2 at a current density of 5 mA cm 2. This study indicates that flexible electrodes made from cellulose nanofiber have extensive potential in the realm of supercapacitors.	{"Cellulose nanofiber","Liquid metal",Supercapacitor}
870	Supercapacitor featuring Ti3C2Tx MXene electrode: Nanoarchitectonics and electrochemical performances in aqueous and non-aqueous electrolytes	Anu M A, Merin Tomy, Manimehala U, Xavier T S	Materials Research Bulletin	2025	https://doi.org/10.1016/j.materresbull.2025.113315	https://www.sciencedirect.com/science/article/pii/S0025540825000236	0025-5408	Ti₃C₂Tx MXenes, synthesized via HCl+LiF etching, show promise as pseudocapacitive electrodes for electrochemical energy storage, addressing the low voltage limitation of aqueous supercapacitors (SCs). This study explores Ti₃C₂Tx MXene electrodes in aqueous and gel electrolytes, specifically H₂SO₄ and H₃PO₄. Electrochemical testing, based on Dunn s approach, confirms supercapacitor-like performance, with specific capacitances of 299 F g in 1 M aqueous H₃PO₄ and 212 F g in H₂SO₄ at a 5 mV s scan rate. Remarkably, in symmetric SCs with 1 M H₃PO₄, Ti₃C₂Tx MXene retains 95 capacitance at 1 V after 25,000 cycles, demonstrating excellent stability. Additionally, Ti₃C₂Tx in a 1 M gel H₃PO₄ electrolyte achieves a higher energy density of 72 Wh kg within a 1.6 V window than with gel H₂SO₄, highlighting the impact of electrolyte choice. These findings underscore MXenes potential as stable, high-rate electrodes for sustainable supercapacitors.	{MXene,"Pseudo capacitor","Aqueous electrolyte","Gel electrolytes","Dunn's method","High power density"}
871	Oxalate-assisted synthesis of MnCo2O4 nanoparticles on layered MXene (Ti3C2Tx) for supercapacitor application	S. Emami, M. Hasheminiasari, S.M. Masoudpanah, R. Omrani, S.P. Ghaemi	Electrochemistry Communications	2025	https://doi.org/10.1016/j.elecom.2025.107995	https://www.sciencedirect.com/science/article/pii/S1388248125001341	1388-2481	The synthesis of MnCo2O4 Ti3C2Tx composite powders was achieved through a hydrothermal method facilitated by oxalate assistance. To assess the influence of MXene levels (0, 25, and 50 wt ) on microstructure, structure, and electrochemical performance, modern characterization methods were applied in this study. The mixed manganese cobalt oxalates were precipitated on the layered MXene by adding a proper amount of oxalic acid to the Nitride solution. The MnCo2O4 nanoparticles were then crystallized by heat treatment at 450 C for one hour in a nitrogen gas atmosphere. The pristine MnCo2O4 had a columnar-like morphology, which was transformed into a fine particulate microstructure by combining with MXene. These pristine MnCo2O4 powders indicated a higher specific capacitance of 1116 F g 1, significantly exceeding the 640.5 Fg 1 recorded for the pristine layered MXene. The Incorporation of 25 wt layered MXene enhanced the specific capacitance to a remarkable 1500 Fg 1, attributed to its finer microstructure. Under a current rate of 1 Ag 1, the capacitor composed of MnCo₂O₄-25 wt MXene activated carbon achieved an energy density of 43.5 Wh kg 1 at a power density of 1411 W kg 1.	{MnCo2O4,"Layered MXene (Ti3C2Tx)","Oxalate-assisted hydrothermal synthesis",Supercapacitor}
872	Ultra-thin nanosheets of Ti3C2Tx MXene MoSe2 nanocomposite electrode for asymmetric supercapacitor and electrocatalytic water splitting	C. Arulkumar, R. Gandhi, S. Vadivel	Electrochimica Acta	2023	https://doi.org/10.1016/j.electacta.2023.142742	https://www.sciencedirect.com/science/article/pii/S0013468623009209	0013-4686	Nanohybrid anode materials for highly efficient asymmetric supercapacitors are developed with a hydrothermal approach using organ-like (Ti3C2Tx) MXene as a main basis. The MoSe2 Ti3C2Tx hybrid supercapacitor has a high specific capacitance of 1531.2 Fg 1 at 1 Ag 1 and a low potential of 200 mV at 10 mAg 1. Additionally, the Tafel slope of 37.7 mV dec 1 for the hydrogen evolution reaction (HER) makes this supercapacitor an excellent electrochemical performer. The supercapacitor with Ti3C2Tx MoSe2nanohybrid as the positive electrode shows excellent performance. Even after 10,000 cycles, it retains a capacitance of 94.1 with a high current density of 5 Ag 1, a high specific energy of 58.8 Whkg 1 and a high specific power of 800.3 Wkg 1. In comparison with unmodified MoSe2, it increases conductivity, speed of charge transfer, and active sites which is explained by the strong interfacial connection between MXene and Ti3C2Tx crystals.	{MXene,MoSe2,Supercapacitor,"Water splitting","Energy storage devices"}
873	MXene carboxymethylcellulose-polyaniline (Ti3C2Tx CMC-PANI) film as flexible electrode for high-performance asymmetric supercapacitors	Hanping Xu, Linlin Cui, Zijie Lei, Mincai Xu, Xiaojuan Jin	Electrochimica Acta	2022	https://doi.org/10.1016/j.electacta.2022.141408	https://www.sciencedirect.com/science/article/pii/S0013468622015651	0013-4686	Two-dimensional (2D) MXene (Ti3C2Tx) materials have received widespread attention as potential electrodes for supercapacitors due to their solution processability, metallic conductivity and excellent energy storage properties. Unfortunately, the self-stacking and interlayer interactions of Ti3C2Tx flakes cause them to acquire poor electrochemical characteristics. Herein, the interwoven carboxymethylcellulose-polyaniline (CMC-PANI) composites were prepared by in-situ polymerization of aniline on the surface of CMC, which was subsequently used as the intercalators to expand the layer spacing of Ti3C2Tx nanosheets via a facile self-assembly process. The interwoven CMC-PANI bridges horizontal Ti3C2Tx nanosheets to construct interconnected conductive and ion channels, making the internal structure of the Ti3C2Tx CMC-PANI (TCP) film more uniformly and orderly, thereby achieving a high mechanical strength ( 35.6 MPa). Meanwhile, the TCP film exhibits a maximum area specific capacitance of 1161.4 mF cm 2 (812.9 mC cm 2) at 1 mA cm 2, and a superior rate performance (maintains 58.4 of the initial value at 50 mA cm 2). Moreover, the fabricated asymmetric supercapacitor (ASC) device presents a high area energy density of 158.7 µW h cm 2 at a power density of 700.1 µW cm 2 and good cycle stability (retention of 89.6 after 15,000 charging discharging cycles). This rational design balancing flexibility and electrochemical performance provides a broadened idea to solve the inherent defects of MXene and further develop high performance energy storage devices.	{MXene,Carboxymethylcellulose,Polyaniline,Supercapacitor}
874	Mg2+ induced Ti3C2Tx MXene microfibrillated cellulose into composite aerogels in a framework of melamine sponge for high-rate performance supercapacitors	Debin Cai, Shuai Wu, Li Guo, Yanzhong Wang	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.114039	https://www.sciencedirect.com/science/article/pii/S2352152X24036259	2352-152X	Inducing Ti3C2Tx MXene nanosheets to self-assemble into three-dimensional aerogels is an effective strategy to solve their accumulation and improve the performance of supercapacitors. However, MXene aerogels are prone to collapse in practical applications due to their low mechanical strength. Here, the low-cost melamine sponge (MS), which adsorbs Mg2+ ions on the skeleton surface serves as a support and induces the gelation of MXene nanosheets and microfibrillated cellulose (MFC) mixed solution to form composite hydrogels, and thereby obtaining MXene composite aerogels with high loading mass and mechanical strength. The experimental results show that the Mg-10 MFMX MS aerogel has the largest area capacitance of 685.77 mF cm 2 at a scan rate of 10 mV s 1. Thanks to its excellent three-dimensional structure, even at a high scan rate of 1000 mV s 1, the area capacitance is still 497.41 mF cm 2, and the capacity retention rate is 72.53 , showing high-rate performance. It is worth noting that the constructed asymmetric activated carbon supercapacitors achieved high energy densities of 128.78 μWh cm 2 and 101.15 μWh cm 2 at 850 μW cm 2 and 17,000 μW cm 2, respectively. In addition, the asymmetric supercapacitor has high cycling stability and a capacity retention rate of 115 after 10,000 cycles. This work provides a feasible strategy for fabricating Ti3C2Tx MXene aerogels with high-rate performance and high strength.	{"Melamine sponge","Ti3C2Tx MXene aerogel","Microfibrillated cellulose","High rate performance",Supercapacitors}
875	Construction of high-performance solid-state asymmetric supercapacitor based on Ti3C2Tx MXene CuS positive electrode and Fe2O3 rGO negative electrode	Xiaobo Chen, Huiran Ge, Wen Yang, Jianli Liu, Peizhi Yang	Journal of Energy Storage	2023	https://doi.org/10.1016/j.est.2023.107700	https://www.sciencedirect.com/science/article/pii/S2352152X23010976	2352-152X	The reasonable and logical construction of electrode materials along with greater electrochemical features and solid architectural design is an effective strategy for boosting the electrochemical performance of supercapacitors. In this paper, Ti3C2Tx MXene CuS composites have been synthesized using an electrostatic attraction connection of negatively charged 2D few-layered Ti3C2Tx MXene sheets with positively charged CuS nanoparticles and are investigated as an asymmetric supercapacitor active material. The addition of MXene enhances the conductivity and specific surface area of the MXene CuS electrode compared to their individual components. The as-prepared MXene CuS electrode exhibits a high specific capacity (1541.6C g 1 (2569.3 F g 1)) at 1 A g 1 and an excellent cycle performance with 93.5 capacity retention after 10,000 cycles. Furthermore, Fe2O3 nanoparticles reduced graphene oxide (rGO) nanosheets (Fe2O3 rGO) composite electrode is also produced. The designed Fe2O3 rGO negative electrode with a wide operation voltage window of 1.1 V can deliver a capacity of 255.6C g 1 at 1 A g 1. Ultimately, the MXene CuS Fe2O3 rGO device displays energy density of 74.1 Wh kg 1 and power density of 849.8 W kg 1. In addition, the ASC shows excellent cycling stability of 91.3 capacity retention after 10,000 cycles.	{"CuS nanoparticles",MXene,Composite,"Asymmetric supercapacitors (ASCs)"}
876	Protective hydrothermal treatment to improve ion pathway in Ti3C2Tx MXene for high-performance flexible supercapacitors	M. Lai, K. Chen, D. Wang, P. Cai, L. Sun, K. Zhang, B. Li, C. Yuan, Y. Zou, Z. Wang, H. Peng	Materials Today Nano	2024	https://doi.org/10.1016/j.mtnano.2023.100450	https://www.sciencedirect.com/science/article/pii/S2588842023001499	2588-8420	The strong re-stacking of Ti3C2Tx MXene nanosheets severely blocks ion transport pathway and sacrifices electrochemical performance. Here, a protective hydrothermal treatment is used to improve ion pathway in Ti3C2Tx MXene. The protective hydrothermal treatment is simply conducted in the hydrothermal kettle (filled with N2 atmosphere) placed in vacuum oven. The optimal Ti3C2Tx is achieved by the hydrothermal treatment of 150 C for 12h, and recorded as h-Ti3C2Tx 150 C 12h. The h-Ti3C2Tx 150 C 12h film electrode achieves significantly improved ion transport pathways and enhanced ion accessibility with more pseudocapacitive active sites due to the increased interlayer spacing and pores as well as decreased flake size. According to DFT calculations, a small number of oxides (TiO2 nanoparticles) produced during the hydrothermal treatment also facilitate to increase the capacitive performance of h-Ti3C2Tx 150 C 12h. Therefore, the h-Ti3C2Tx 150 C 12h film electrode achieves significantly increased capacitance and rate performance. The h-Ti3C2Tx 150 C 12h film electrode exhibits excellent capacitance (498.3 F g 1 and 1911 F cm 3 at 1 A g 1) and rate performance (63 retention from 1 to 20 A g 1) with high cycling stability (98.2 retention after 20 000 cycles), which are among the best electrochemical performances of undoped Ti3C2Tx based film electrodes reported so far. Thick h-Ti3C2Tx 150 C 12h film electrode of 33.1 μm thickness exhibits an ultra-high areal capacitance of 3.23 F cm 2 at 1 A g 1. Moreover, the h-Ti3C2Tx 150 C 12h-based flexible symmetric supercapacitor device exhibits excellent energy storage performance (117 F g 1 at 0.5 A g 1 and 23.4 Wh kg 1 at 299.8 W kg 1) with high cycling stability (84 retention after 3000 cycles) and bending stability, outperforming most of previously reported Ti3C2Tx-based flexible supercapacitors. The impressive results indicate the great application potential of the h-Ti3C2Tx 150 C 12h film in flexible energy storage devices.	{"Flexible supercapacitor","Ti3C2Tx MXene","Hydrothermal treatment","Ion pathway","Energy storage"}
877	Ti3AlC2 MAX phase and Ti3C2TX MXene-based composites towards supercapacitor applications: A comprehensive review of synthesis, recent progress, and challenges	Onkar Jaywant Kewate, Sathyanarayanan Punniyakoti	Journal of Energy Storage	2023	https://doi.org/10.1016/j.est.2023.108501	https://www.sciencedirect.com/science/article/pii/S2352152X23018984	2352-152X	The global need for energy is increasing due to the growth in population and the widespread use of energy-consuming devices. In recent times, supercapacitors have emerged as a better option owing to their high-power density, quick charging discharging, and extended cycle life. A burgeoning 2D material that consists of carbides, nitrides, and carbonitrides called MXenes, has emerged as a superior active electrode material for supercapacitors owing to its novel structure, stability, enhanced electrical conductivity, large surface area, hydrophilicity, hydrophobicity and availability of abundant active sites. In addition to their favorable attributes, MXenes exhibit certain limitations that have to be addressed like sheet restacking and aggregation, which impede the progress of research on various applications, especially supercapacitors. The major focus of this article pertains to the synthesis techniques employed for the Ti3AlC2 MAX phase, as well as the diverse methods of etching, intercalation, and delamination utilized for the preparation of Ti3C2TX MXenes. In addition, investigations conducted on the efficacy of utilizing Ti3C2TX MXene in combination with polymer, carbon, and transition metal oxide based materials to enhance supercapacitor performance are reviewed. This review includes important challenges and up-to-date studies along with an analysis of research gaps and future directions in supercapacitor applications.	{"Ti3AlC2 MAX phase","Ti3C2TX MXene","Synthesis methods",Composites,Supercapacitor}
878	Synergistic Ti3C2Tx MXene quantum dot nanosheet Hybrid: Elevating supercapacitor performance	Bheem Kumar, Avinash Rundla, Priyanka, Mahaveer Singh, Divya Rani, Pushpendra Kumar, Kedar Singh	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237603	https://www.sciencedirect.com/science/article/pii/S0378775325014399	0378-7753	Supercapacitors are promising energy storage devices, offering a unique combination of high energy and power densities. This study systematically investigated the synergistic effect of a Ti3C2Tx-MXene quantum dot (MQD) nanosheet hybrid on supercapacitor performance. Ti3C2Tx MQDs are synthesized through a two-step process: first, Ti3C2Tx MXene 2D sheets are prepared via acidic etching of precursor materials. A combined hydrothermal (water-based) and solvothermal (ethanol-based) treatment at 150 C reduces the sheet size, producing MQDs. The electrochemical performance of the MQD nanosheet hybrid was evaluated via a three-electrode configuration with 1 M H2SO4 as the electrolyte. Galvanostatic charge-discharge (GCD) tests at current densities ranging from 1 to 5 Ag-1 revealed a significant improvement in the specific capacitance under all tested conditions. Similarly, CV at scan rates of 10 200 mVs 1 demonstrated an enhanced charge storage capability and superior rate performance, which was attributed to the synergistic effects of the MQDs. EIS confirmed the reduced charge-transfer resistance and excellent capacitive behavior across a wide frequency range. The enhancement in the results is due to the high surface area, remarkable electrical conductivity, and abundant electrochemically active sites of the MQDs. This study highlights the potential of Ti3C2Tx MQD nanosheet hybrids as high-performance materials for next-generation supercapacitors, paving the way for their integration into advanced energy storage systems.	{MXene,"Ti3C2Tx QDs",Supercapacitors,"Electrochemical properties","Energy storage"}
879	Hierarchical MOF-derived Selenide Ti3C2Tx hybrids for high-performance supercapacitors	Yuhan Cui, Jing Sun, Yining Wang, Lijie Zhao, Jiawei Wang, Yunpeng Wu, Wenxi Zhang, Zengyuan Fan, Yuzhe Tang, Yue Song, Zhongmin Su	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237482	https://www.sciencedirect.com/science/article/pii/S0378775325013187	0378-7753	The slow kinetics and poor structural stability prevent 2D transition metal selenides from wide application in supercapacitors. However, as a representative of new two-dimensional materials, Ti3C2TX (MXene) has excellent transport properties and rich surface functional groups, which can well make up for the shortcomings of metal selenides. The optimized morphology engineering from a combination of MXene and 2D bimetallic selenide will bring the performance of supercapacitor electrode material to a new level. In this paper, MXene Mn0.8Ni0.2Se composites are creatively prepared by ultrasonic stirring and solvothermal synthesis. The hierarchically layered composite electrode material composed of MXene nanosheets and selenide nanosheets is successfully synthesized and its electrochemical performance as electrode material for supercapacitors is studied. The results show water not only promotes the deprotonation of triethylamine to participate in coordination but also causes triethylamine to generate OH , which makes it easier to form layered products and restrict the growth of NiMn-Metal Organic Framework (MOF) into a three-dimensional structure. Subsequently, during the selenization process, a small amount of water and disodium ethylenediaminetetraacetic acid are added to further promote the stability of the 2D 2D structure. The wavy hierarchically layered structure can shorten the diffusion path of metal ions and enhance electronic conductivity. As a supercapacitor material, under the current density of 1 A g 1, the specific capacitance of MXene Mn0.8Ni0.2Se is 1126 F g 1. This capacity is higher than most selenide capacities reported to date. In addition, the energy density of the asymmetric supercapacitor constructed with activated carbon as cathode and Mn0.8Ni0.2Se as anode can reach 46.18 Wh kg 1 when the power density is 750 W kg 1. The outstanding specific capacitance and high energy density endow it with great potential for practical application.	{Supercapacitor,MXene,"2D bimetallic MOF",Selenide,"Layered materials"}
880	Synergistic in-situ intercalation and surface modification strategy for Ti3C2Tx MXene-based supercapacitors with enhanced electrochemical energy storage	Zhiyu Li, Mingyue Jiang, Fangfei Wu, Lili Wu, Xitian Zhang, Lu Li	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.110772	https://www.sciencedirect.com/science/article/pii/S2352152X24003566	2352-152X	Ti3C2Tx MXene with unique physicochemical properties is a promising negative electrode for high performance supercapacitors, but its full potential for energy storage is limited by inherent restacking and unfavorable F surface termination. Here, a synergistic in-situ intercalation and surface modification strategy for enhancing the electrochemical performance of Ti3C2Tx is demonstrated. Ag nanoparticles were intercalated into the interplanar s of Ti3C2Tx using an in-situ reduction method to open ion diffusion channels and expose active sites, followed by annealing treatment to remove the deleterious termination. Benefitting from the structural modification, the obtained a-Ag Ti3C2Tx film electrode possess an enhanced specific capacitance of 471 F g 1 at 1 A g 1 with a 2-fold increase in intercalation pseudocapacitance compared to the pristine Ti3C2Tx, accompanied by improved rate performance and cyclic stability. Furthermore, the asymmetric supercapacitor with a negative electrode of a-Ag Ti3C2Tx and a positive electrode of RuO2 CC delivers a high energy density of 24.6 Wh kg 1. The present study demonstrates an effective strategy to improve the electrochemical energy storage of the Ti3C2Tx negative electrode by designing the intercalation and termination.	{Supercapacitors,"Negative electrode",Ti3C2Tx,Intercalation,"Surface modification"}
881	Tag paper substrate enhanced self-assembled graphene oxide-Ti3C2Tx MXene composites for supercapacitors applications via laser processing	Xiu-Yan Fu, Hua-Rui Li, Ruo-Yu Shu, Hao-Bo Jiang, Meng-Nan Yao, Jia-Nan Ma	Journal of Alloys and Compounds	2025	https://doi.org/10.1016/j.jallcom.2024.178071	https://www.sciencedirect.com/science/article/pii/S0925838824046590	0925-8388	Laser-induced reduced graphene oxide (LIRGO) has exhibited great potential for energy storage device applications. However, challenges remain in regard to solving the restacking of graphene oxide (GO) sheets and conductivity differences after laser processing. In this study, we used direct laser writing (DLW) to fabricate self-assembled graphene oxide-Ti3C2Tx MXene (GO-M) composites on tag paper for planar supercapacitors. Due to the cooperation of interaction between electronegative GO and Ti3C2Tx MXene and introduction of paper substrate with cellulose network structure, the as-prepared composite (R-GO-M-P) based supercapacitor exhibits much higher specific capacitance (15.5 mF cm2) than that of LIRGO on glass substrate (4.05 mF cm2). We observed a good stability of 93.35 specific capacitance retention scores after 1000 charge-discharge cycles. Moreover, the R-GO-M-P-based supercapacitor also displayed excellent flexibility due to the existence of paper substrate, with a 142 specific capacitance retention after 1000 bending test cycles. The integrated R-GO-M-P-based supercapacitors were fabricated according to a programmable DLW pattern, that achieved an extended working potential of 2.4 V and could power an LED. We hope that this study offers a new strategy for the development of high-performance LIRGO-based supercapacitors.	{"Paper assisted","Substrate effect",Self-assembled,"Graphene oxide- Ti3C2Tx MXene composite","Supercapacitor applications"}
882	Probing the synergistic effect of MXene (Ti3C2Tx) and MWCNTs on NiWO4 for superior water-splitting and supercapacitor studies	Amna Irshad, Mirza Mahmood Baig, Seung Goo Lee, Imran Shakir, Zeid A. ALOthman, Muhammad Farooq Warsi, Muhammad Shahid	Fuel	2025	https://doi.org/10.1016/j.fuel.2025.134811	https://www.sciencedirect.com/science/article/pii/S0016236125005356	0016-2361	The main focus of the ongoing worldwide research is the production and storage of green energy via electrochemical study. MXene (2D) and multi-walled carbon nanotubes (MWCNTs (1D)) play enormous roles in enhancing the efficiency of nanomaterials for electrochemical measurements. A wet chemical approach is employed to synthesize NiWO4. The nanocomposite of NiWO4 with MXene and MWCNTs is prepared via ultrasonication approach. Structural, morphological and elemental aspects of the prepared samples are investigated via different characterization techniques. Hydrogen and oxygen evolution reactions are performed in an alkaline solution. NiWO4 MXene CNTs shows Tafel slope of 77 and 91 mV dec for HER and OER, respectively. Supercapacitor performance is evaluated via cyclic voltammetry (CV) and galvanostatic charge discharge (GCD) experiments. The current response shown by the materials is best analyzed through CV measurements. NiWO4 MXene CNTs composite exhibits discharge time of 500 s as compared to NiWO4 (276 s) and NiWO4 MXene (390 s). NiWO4 MXene CNTs composite shows specific capacitance and retention of 1250 F g and 80 , respectively. The resistance faced by the materials during electrochemical measurements is analyzed using electrochemical impedance spectroscopy. MXene and MWCNTs boost the efficiency of NiWO4 via synergistic effect and make it a potential material for water splitting and supercapacitor study.	{NiWO4,MXene,"Hydrogen energy","Tafel slope","Charge transfer resistance","Specific capacitance"}
883	Human-friendly flexible solid-state biodegradable supercapacitor based on Ti3C2Tx MXene film without adhesive structure	Xiaofeng Zhang, Muhammad Sufyan Javed, Hongjia Ren, Xinze Zhang, Salamat Ali, Kaiming Han, Awais Ahmad, Ammar M. Tighezza, Weihua Han, Kui-Qing Peng	Materials Today Energy	2024	https://doi.org/10.1016/j.mtener.2024.101496	https://www.sciencedirect.com/science/article/pii/S246860692400008X	2468-6069	With the rapid development of biomedical technology, biodegradable and implantable energy storage devices for biosensor and bioelectronics applications have attracted the great attention of scientists. However, the limited energy density, poor biocompatibility, and excessive space occupation of existing biodegradable energy storage devices pose major challenges to their application in the biomedical field. To address these challenges, in this work, flexible Ti3C2Tx film with an adhesive-free structure construction is proposed as electrode material for the flexible solid-state biodegradable supercapacitor (FSBSC). The morphology and structure of MXene films were characterized by X-ray diffraction (XRD), X-ray photoelectron spectroscopy (XPS), Raman, scanning electron microscopy (SEM), and transmission electron microscopy (TEM). A 0.9 NaCl saline, similar human body fluids was used as the electrolyte solution to construct symmetrical FSBSC (Ti3C2Tx NaCl-PVA Ti3C2Tx-FSBSC) Poly(vinyl alcohol) (PVA). The Ti3C2Tx NaCl-PVA Ti3C2Tx-FSBSC exhibits a high capacitance of 112 F g at 1 A g, excellent rate capability (73.2 at 20 A g), long lifetime (81.6 after 10,000 cycles), and high specific energy power (62.3 Wh kg at 1000.8 W kg). The charge storage mechanism was analyzed using ex situ XRD, TEM, and density function theory (DFT). DFT results show that the Ti3C2Tx (Tx = O)) electrode possesses metallic properties. The calculated adsorption energies (Eads) and smaller diffusion barriers of Na+ ions further proved the outstanding performance of the Ti3C2Tx electrode. Moreover, the apparatus is entirely biodegradable, thereby paving a promising path for the progression of bioelectronics and biomedical energy storage technologies.	{Biodegradable,Supercapacitor,Solid-state,"Ti3C2Tx film",DFT}
884	Sandwich-like high-performance Ti3C2Tx MXene NiCo2O4 nanosphere composites for asymmetric supercapacitor application	Wei Wang, Guohui Chen, Weiqi Kong, Junshu Chen, Linyu Pu, Jiaxu Gong, Huan Zhang, Yatang Dai	Journal of Energy Storage	2024	https://doi.org/10.1016/j.est.2024.111097	https://www.sciencedirect.com/science/article/pii/S2352152X24006819	2352-152X	NiCo2O4 is a promising electrode material for supercapacitors due to its low cost, high theoretical specific capacitance and good cycling stability. However, NiCo2O4 has the disadvantages of poor electronic and ionic conductivities and easy agglomeration. Moreover, the irreversible structural damage caused by the NiCo2O4 volume expansions during charging and discharging limits its use in supercapacitors. Herein, we fabricated sandwich Ti3C2Tx MXene NiCo2O4 composites via an electrostatic self-assembly method. The problem of easy agglomeration of the NiCo2O4 nanospheres was solved by intercalating Ti3C2Tx MXene layers with the NiCo2O4 nanospheres. Furthermore, the Ti3C2Tx MXene layer was also utilized as a protective layer to limit serious volume expansion and protect the structure of NiCo2O4 nanospheres from destruction. The results showed that the prepared Ti3C2Tx MXene NiCo2O4 composite exhibited a high specific capacitance of 1025 F g 1 at a current density of 1 A g 1 and had an initial capacity of 81 when the current density was increased to 10 A g 1. The Ti3C2Tx MXene NiCo2O4 composite cathode and activated carbon anode were assembled in an asymmetric supercapacitor, which showed an energy density of 36.67 Wh kg 1 at 800 W kg 1 and a capacity retention of 88.2 after 5000 cycles.	{Supercapacitors,NiCo2O4,MXene,Nanospheres}
885	Ammonia-assisted heterocyclic amine exerts soft delamination and interlayer engineering of Ti3C2Tx MXene for fabricating stable supercapacitors	Arumugam Sangili, Binesh Unnikrishnan, Shun Ruei Hu, Han-Wei Chu, Hung-Lung Chou, Ren-Siang Wu, Chih-Ching Huang, Huan-Tsung Chang	Energy Storage Materials	2024	https://doi.org/10.1016/j.ensm.2024.103809	https://www.sciencedirect.com/science/article/pii/S2405829724006354	2405-8297	The application of two-dimensional titanium carbide MXenes (Ti3C2Tx) for electrochemical energy storage and conversion has garnered considerable attention in recent years. For practical applications, gradual delamination, phase shift, and or structural disintegration of MXene flakes in aqueous conditions are the challenges needed to be addressed. Herein, a unique and effective approach for in situ manipulation of MXene edge and surface by gentle delamination using 5-azaindole (5-Az; a heterocyclic amine) and ammonium hydroxide (NH4OH) has been developed. In the presence of NH4OH, 5-Az enables soft delamination of multilayer MXene without sonication, and more importantly, allows in situ functionalization of its surface and edges via a nucleophilic substitution reaction at the Ti-atom sites at room temperature. In addition, the easy intercalation of 5-Az in the multilayer MXene allows for an increase in its interlayer spacing when it is made into a film or electrode, which is beneficial for various electrochemical applications. The 5-Az functionalization provides exceptional stability of MXenes for up to 500 days in water at room temperature. The NH4OH-treated- and 5-Az-functionalized MXene (NH4OH-5-Az Ti3C2Tx) shows increased interlayer spacing (1.67 nm) when compared to the MXene treated with NH4OH (NH4OH-Ti3C2Tx) (1.25 nm), enhanced ion- and charge-transport properties resulting in a remarkable specific capacitance of 631 F g 1 at 2 A g 1 with capacitance retention of 82 after 150 days. Having high specific capacitance and excellent stability, the NH4OH-5-Az Ti3C2Tx prepared through the proposed simple and effective approach holds great potential as high-performance electrodes for supercapacitors.	{"Soft-delaminated MXene",Azaindole,"Interlayer expansion","Oxidation resistance",Supercapacitors}
886	Hybrid nano-architectural engineering of Ti3C2Tx MXene heterostructures for supercapacitor applications: A review	Mojtaba Rostami, Parisa Rezvaninia, Ahmad Amiri, Ghodsi Mohammadi Ziarani, Mohammad Reza Ganjali, Alireza Badiei	Results in Engineering	2024	https://doi.org/10.1016/j.rineng.2024.102227	https://www.sciencedirect.com/science/article/pii/S2590123024004821	2590-1230	The rising need for cost-effective, versatile, and durable energy storage devices has propelled progress in electronics and associated fields in the present era of industrialization. Due to their tactile, structural, and aesthetic qualities, two-dimensional (2D) stratified nanomaterials have developed as attractive rivals for high-efficiency energy retention devices. 2D MXenes, a type of transition metal carbides nitrides via thin thickness, adjustable electrochemical characteristics, high conductivity, and a plentiful supply of active edge sites, have drawn much attention in the area of material science. For advanced electrochemical energy storage technologies like supercapacitors (SCs), Ti3C2Tx MXenes are particularly well-suited as electrode materials. The utilization of MXenes has faced inhibitions due to the aggregation, oxidation, and restacking phenomena occurring within their layers. To overcome these obstacles, this investigation delves into various categories of 2D nanomaterials exhibiting notable electrochemical activity. These encompass covalent organic frameworks (COFs), transition metal chalcogenides (TMCs), layered double hydroxides (LDHs), metal-organic frameworks (MOFs), and their derivatives, which hold promise for synergistic coupling with Ti3C2Tx MXenes. Nanoarchitectural engineering structures are employed to enhance the performance of these 2D nanomaterials, both individually and in composites with the metallic conductive 2D Ti3C2Tx MXenes, within SCs. The review summarizes the present developments, challenges, and future perspectives associated with applying Ti3C2Tx MXenes nanomaterial and their hybrid composite nanoarchitectures (NAs) for SC. This review endeavors to advance high-performance energy storage innovations that meet the demands of the contemporary industrial revolution. It achieves this by exploring the potential of diverse 2D nanomaterials and their composite nanoarchitectures (NAs).	{Two-dimensional,MXenes,Supercapacitors,TMCs,LDHs,COFs}
887	Enhanced performance of Fe2O3 MXene based supercapacitors with redox-electrolyte strategy	Jing Xu, Xinye Xu, Xiaoqing Bin, Yingyi Liao, Xuedong He, Wenxiu Que	Journal of Electroanalytical Chemistry	2025	https://doi.org/10.1016/j.jelechem.2025.119278	https://www.sciencedirect.com/science/article/pii/S1572665725003522	1572-6657	MXene-based supercapacitors are regarded as advanced energy storage devices owing to their high power density and extended cycle life. However, re-stacking of MXene significantly restricts its electrochemical performance while limited capacitance degrades the energy density. To address these limitations, we propose a dual-optimization strategy which integrates Fe2O3 MXene composite electrode design with redox-active electrolyte engineering, and thus achieves a high-performance Fe2O3 MXene-based asymmetric supercapacitor. Fe2O3 nanoparticles anchored on MXene nanosheets via filtration and annealing mitigate re-stacking and provide redox-active sites, while their interfacial charge synergy with a Cu2+-rich electrolyte accelerates Cu2+ Cu+ redox kinetics. The optimized composite electrode achieves a specific capacitance of 643.8 F g 1 at 2 A g 1 in 3 M H₂SO₄ + 30 mM CuSO₄ redox electrolyte. Moreover, the assembled asymmetric supercapacitor exhibits a high energy density of 20.1 Wh kg 1 at a power density of 1292.5 W kg 1, outperforming most reported MXene-based devices. This work demonstrates a feasible strategy for designing high-performance supercapacitors with hybrid redox electrolytes.	{Supercapacitor,"Ti3C2Tx MXene","Fe2O3 nanoparticles",Redox-electrolyte}
888	A novel CoS Ti3C2Tx MXene conductive filler effectively improves the pseudocapacitive performance of conductive hydrogel electrode materials for all-solid-state supercapacitors	Ting Yu, Siyu Ge, Mingmao Hu, Haoran Wu, Shenghua Yao	European Polymer Journal	2024	https://doi.org/10.1016/j.eurpolymj.2024.112904	https://www.sciencedirect.com/science/article/pii/S0014305724001654	0014-3057	It is currently an essential research direction to develop a low-cost, cost-effective, and environmentally friendly high-performance flexible electrode material. The electrode materials prepared from Ti3C2Tx MXene based hydrogels showed favorable physical and chemical properties (e.g., extreme flexibility, excellent mechanical strength, and electrical conductivity), and CoS (cobaltous sulfide) nanoparticles were grown by in-situ hydrothermal growth on the accordion-like Ti3C2Tx MXene surfaces, which were then synthesised into PCCT (PAA chitosan CoS Ti3C2Tx) conductive hydrogels with physical crosslinked networks in a two-step process. This 3D porous structure containing highly conductive materials can provide suitable geometrical space and electronic structure, which can help to suppress the accumulation of active material at high mass loading and improve the specific capacitance of the electrode material. With a current density of 4 mA g, the specific capacitance of the PCCT conductive hydrogel electrode was 3.6F g. At a current density of 10 mA g, the cycling stability was still 80 after 2000 cycles. The elongation at break of PCCT conductive hydrogel wass about 349 . After 48 h of healing at room temperature, the self-healing efficiency can reach 66.88 . A foundation has been laid for obtaining flexible all-solid-state supercapacitors with stable structures and excellent electrochemical properties.	{"Ti3C2Tx MXene",CoS,Hydrogel,Self-healing,Supercapacitors}
889	Applications and perspectives of Ti3C2Tx MXene in electrochemical energy storage systems	Ying Jiang	International Journal of Electrochemical Science	2025	https://doi.org/10.1016/j.ijoes.2025.100948	https://www.sciencedirect.com/science/article/pii/S1452398125000239	1452-3981	The rapid evolution of electrochemical energy storage systems demands advanced materials that combine high electrical conductivity, controlled surface chemistry, and structural stability. This review examines the recent developments in Ti3C2Tx MXene synthesis, structural properties, and applications in energy storage devices. We analyze various preparation methods, including traditional HF etching, safer fluoride-free alternatives, and emerging green synthesis routes, highlighting their impact on material quality and scalability. The review explores the critical role of surface termination groups and interlayer spacing in determining electrochemical performance, with particular emphasis on the material s exceptional electrical conductivity (up to 20,000 S cm) and tunable work function (1.6 6.25 eV). Detailed examination of composite formation techniques and interface engineering reveals significant improvements in device performance across multiple applications, including lithium-ion batteries achieving specific capacities of 3500 mAh g with Si composite, lithium-sulfur batteries demonstrating strong polysulfide binding energies (>1.4 eV), and supercapacitors exhibiting volumetric capacitances exceeding 1000 F cm³ . Recent breakthroughs in electrode design and material optimization have led to enhanced stability with some composite maintaining 90 capacity retention over 2000 cycles and demonstrating rate capabilities up to 100 C in various energy storage applications. The integration of novel fabrication approaches and strategic material combinations continues to expand the potential applications of this versatile material in next-generation energy storage technologies.	{"Two-dimensional materials","Electrochemical performance","Surface modification","Charge transport","Composite engineering"}
890	Etching duration as a key parameter for tailoring Ti3C2Tx MXene electrochemical properties	P.E. Lokhande, Udayabhaskar Rednam, Syed Khasim, Taymour A. Hamdalla, Amol Vedpathak, Deepak Kumar, Kulwinder Singh	Journal of Physics and Chemistry of Solids	2025	https://doi.org/10.1016/j.jpcs.2025.112902	https://www.sciencedirect.com/science/article/pii/S0022369725003543	0022-3697	Since the groundbreaking discovery of 2D MXenes in 2011, these materials have garnered immense interest for their exceptional properties in energy storage applications. The performance of MXenes in this domain is highly dependent on synthesis parameters, with the synthesis kinetics playing a pivotal role. In this work, Ti3C2Tx MXene was produced through hydrofluoric (HF) acid etching, conducted over durations of 48, 72, and 96 h. The resulting MXene was comprehensively characterized to examine its structural and morphological attributes. It was observed that the interlayer spacing of Ti3C2Tx MXene was influenced by the etching time, led to the formation of defects in the material s layers. Among the samples, the one obtained by etching for 72 h exhibited the optimal specific capacitance, achieving 488 Fg-1 at a current density of 0.25 Ag-1, along with excellent rate performance. A supercapacitor device assembled using this MXene and activated carbon delivered an energy density of 5 Whkg 1 and a power density of 1000 Wkg-1, accompanied by outstanding cyclic stability. These findings underscore the critical importance of etching duration in enhancing the electrochemical performance of MXene materials.	{MXene,Ti3C2Tx,Supercapacitor,"2D materials"}
891	Flexible all-solid-state asymmetric supercapacitor based on Ti3C2Tx MXene graphene carbon nanotubes	Yanling Jin, Jiahui Geng, Yilan Wang, Zirui Zhao, Zhengyan Chen, Zhengzheng Guo, Lu Pei, Fang Ren, Zhenfeng Sun, Peng-Gang Ren	Surfaces and Interfaces	2024	https://doi.org/10.1016/j.surfin.2024.104999	https://www.sciencedirect.com/science/article/pii/S2468023024011556	2468-0230	As the emerging 2D materials, MXenes have been regarded as promising electrode materials in supercapacitor as power supply for wearable and portable electronic devices due to their metallic conductivity, hydrophilic feature, abundant functional groups, and large theoretical specific surface area etc. The capacity and rate capability of MXene-based electrodes is limited by the sheet restacking, hindering their further development. Herein, Ti3C2Tx MXene graphene carbon nanotubes (MXene graphene CNTs) flexible film was successfully fabricated by vacuum assisted filtration. Intercalation and confinement of graphene and carbon nanotubes between the Ti3C2Tx MXene nanosheets could increase the spacing and specific surface area, alleviate the stacking of MXene nanosheets, thus enhancing the electrochemical properties. The prepared MXene graphene CNTs film possesses increased specific surface area, average pore size, pore volume (112.259 m2 g 1, 9.982 nm, 0.276 cm3 g 1), compared to MXene (93.088 m2 g 1, 3.786 nm, 0.088 cm3 g 1). Consequently, MXene graphene CNTs delivers high area specific capacitance of 1862.5 mF cm 2 at 1 mA cm 2 and excellent rate capability (1525 mF cm 2, 81.88 at 20 mA cm 2). Flexible asymmetric supercapacitor constructed with MXene graphene CNTs film and active carbon as positive and negative electrodes, and PVA H2SO4 gel as solid electrolyte, achieves an energy density of 133.75 μWh cm 2 at the power density of 750 μW cm 2. In addition, there is still 94.9 of the initial performance after cycling 8000 charge discharge cycles at 10 mA cm 2, corresponding to a single-turn decay rate down to 0.00019 . Besides, this flexible supercapacitor manifests outstanding electrochemical stability at different bending times. These advantages make the flexible supercapacitor device very promising for wearable electronics applications.	{Supercapacitors,"Ti3C2Tx MXene",Graphene,"Carbon nanotubes"}
892	Ti3C2Tx MXene-based (Cobalt Vanadium) bimetallic sulfides 0D 2D heterostructure composite for asymmetric supercapacitor application	Mahmoud Dardeer, Kisan Chhetri, Devendra Shrestha, Rupesh Kandel, Chan Hee Park	Journal of Electroanalytical Chemistry	2025	https://doi.org/10.1016/j.jelechem.2025.119002	https://www.sciencedirect.com/science/article/pii/S157266572500075X	1572-6657	2D MXenes are receiving a significant attention in the energy-storage sector, owing to their high surface redox reactivity, hydrophilicity, multi-layered sheet structure, and high conductivity. However, MXenes are subjected to sheets restacking which decrease the number of surface-active sites, and thus limits their capacity value. In this work, CoVS2 NPs are in-situ grown over the Ti3C2T nanosheets using a facile hydrothermal technique. The insertion of the nanoparticles can reduce the restacking of the sheets and creating abundant active sites. As a cathode material for the (ASCs) application, the CoVS2 MXene hybrid electrode achieves a high specific capacity value of 423 mAh g 1 at 1 A g 1, with an outstanding cycling stability of more than 93 capacity retention after 5000 working cycles. Moreover, the obtained CoVS2 MXene VS2 MXene ASC device provides a significant energy density of 57.78 W h kg 1 at 832 W kg 1 power density, and 90.3 capacity retention. Such results indicate that the CoVS2 MXene hybrid material offers excellent potential for future development of a new MXene-based supercapacitor devices.	{MXene,Metal-Sulfides,Nanocomposite,"Asymmetric supercapacitors (ASCs)","Energy density"}
893	Cu1.5Mn1.5O4 hollow sphere decorated Ti3C2Tx MXene for flexible all-solid-state supercapacitor and electromagnetic wave absorber	Shuai Zhang, Ying Huang, Jiaming Wang, Xiaopeng Han, Guozheng Zhang, Xu Sun	Carbon	2023	https://doi.org/10.1016/j.carbon.2023.118006	https://www.sciencedirect.com/science/article/pii/S0008622323002415	0008-6223	Flexible energy storage systems and electromagnetic pollution have become issues that need to be resolved in equipment research and development due to the widespread use of portable electronic devices and 5G networks. MXene is competent for supercapacitors and electromagnetic wave absorbers through sensible composite and microstructure design. Herein, Cu1.5Mn1.5O4 Hollow Nanosphere Decorated Ti3C2Tx MXene (CuMnHS MX) was prepared by simple electrostatic self-assembly. Hybrid membranes can be quickly prepared by vacuum-assisted filtration. CuMnHS MX exhibits excellent electromagnetic wave absorption performance and electrochemical energy storage properties. High specific capacitance (2089 mF cm2 at 2.5 mA cm2) and excellent cycle stability (99.89 after 8000 cycles) are achieved, which are attributed to the increased interlayer spacing and improved interlayer ion transport efficiency. When assembled into symmetrical flexible all-solid-state supercapacitor (SC), the device has a specific capacitance of 382.9 mF cm2 and an energy density of 53.18 μWh cm2 at a power density of 277.8 μW cm2. Meanwhile, CuMnHS MX has advantageous absorbing properties. When the thickness is 4 mm, the minimum reflection loss (RLmin) is 53.42 dB at 6.08 GHz. Adjustable absorbing property is achieved, and the absorbing energy efficiency can cover X and most C, Ku bands. These excellent EMA properties are derived from the 3D structure and rich dipole interface polarization. CuMnHS MX is a promising bifunctional material for electrochemical energy storage and electromagnetic wave absorption.	{Ti3C2Tx,"Bimetallic oxide","Hollow sphere",Flexible,Supercapacitor,"EMA İnal Kaan Duygun, Burak Küçükelyas, Ayşe Bedeloğlu, Structurally integrated Ti3C2Tx MXene/cotton fabric electrodes for supercapacitor applications, Materials Research Bulletin, Volume 180, 2024, 113042, ISSN 0025-5408, https://doi.org/10.1016/j.materresbull.2024.113042. (https://www.sciencedirect.com/science/article/pii/S0025540824003738) Abstract: This study investigates the electrochemical performance of Ti3C2Tx MXene-coated cotton fabric electrodes for supercapacitor applications. The sediment and supernatant parts of synthesized Ti3C2Tx MXene were applied onto cotton substrates through a drop-casting technique at various concentrations to explore the influence of MXene dispersion density on the structural, morphological, and electrochemical properties of the fabric electrodes. Findings indicate that the lower-concentration dispersions not only improve the structural integrity of the coatings but also enhance their electrochemical functionality. The fabric electrodes fabricated from MXene supernatant exhibited significantly lower electrical resistance (7.3 Ω sq−1) and higher specific capacitance, reaching 488 F g−1 at a current density of 0.5 A g−1. The study demonstrates the potential of MXene-coated fabrics as adaptable and efficient energy solutions for wearable technologies, highlighting that tuning the concentration and post-synthesis parameters of MXene dispersions can effectively alter their electrochemical properties. Keywords: Ti3C2Tx MXene","Textile electrodes","Flexible electrodes","Wearable supercapacitors","Wearable electronics"}
894	Interface engineering based NiCoMoO4 Ti3C2Tx MXene heterostructure for high-performance flexible supercapacitors	Wei Li, Bita Farhadi, Miaomiao Liu, Peiru Wang, Jiayi Wang, Yaoyao Zhang, Guoxiang Ma, Runnan Huang, Jiayi Zhao, Kai Wang, Yao Tong	Journal of Colloid and Interface Science	2025	https://doi.org/10.1016/j.jcis.2024.08.093	https://www.sciencedirect.com/science/article/pii/S0021979724018757	0021-9797	The advancement of interface engineering has demonstrated remarkable efficacy in overcoming the primary impediment associated with sluggish reaction kinetics in supercapacitor electrodes. In this investigation, we employed a facile co-precipitation method to synthesize NiCoMoO4 MXene heterostructures utilizing Ti3C2Tx MXene nanosheets as carriers. This heterostructure inhibits the restacking of MXene nanosheets and simultaneously enhances the exposure of electrochemically active sites in NiCoMoO4 nanorods, thereby mitigating the reduction in specific capacitance resulting from volumetric fluctuations. The NiCoMoO4 MXene electrode, possessing pseudo-capacitance properties, demonstrates an impressive level of specific capacitance, exceptional performance across various charging rates, and consistent behavior throughout repeated cycles. By optimizing the mass ratio, this electrode achieves a specific capacity of 1900 F g under a current density of 1 A g. Even after enduring 10,000 cycles at a significantly higher current density of 5 A g, it still maintains an impressive retention rate of 94.73 . Our density functional theory (DFT) calculations indicate that the enhanced electrochemical performance can be attributed to the improved electronic coupling within the NiCoMoO4 MXene heterostructure. The integration of NiCoMoO4 MXene cathode and activated carbon (AC) anode with an alkaline gel electrolyte containing potassium ferricyanide in flexible quasi-solid-state supercapacitors (FSSCs) results in exceptional electrochemical performance and flexibility. These FSSCs demonstrate a maximum energy density of 72.89 Wh kg 1 at a power density of 850 W kg 1, while maintaining an impressive power output of 16,780 W kg 1 with an energy density of 37.28 Wh kg 1. Based on these outstanding properties, it is evident that the NiCoMoO4 MXene heterojunction possesses significant advantages as electrode material for supercapacitors, and the fabricated FSSCs devices pave a new pathway for flexible electronic devices.	{Ti3C2Tx-MXene,NiCoMoO4,"Flexible quasi-solid-state supercapacitors",Heterostructure,"Cycling stability"}
895	Enhancing the capacitive energy storage ability of Ti3C2Tx MXene and PVA-derived carbon composite aerogels through structural disorder	Yuelin Lu, Jie Bai, Binbin Sun, Nannan Li, Zhenhuai Yang, Hailing Yu, Cong Wang, Cong Gu, Huan Liu, Peng Tang, Qiang Wang	Electrochimica Acta	2025	https://doi.org/10.1016/j.electacta.2025.145910	https://www.sciencedirect.com/science/article/pii/S0013468625002737	0013-4686	MXene materials exhibit substantial energy storage capabilities owing to their high specific surface areas, tunable interlayer spacings, and excellent electrical conductivities. However, these layers are prone to re-stacking, negatively affecting the energy storage capacity of the material. Herein, through a process involving liquid nitrogen-assisted freeze-drying and subsequent annealing, Ti3C2Tx nanosheets were combined with polyvinyl alcohol (PVA) polymer chains via hydrogen bonding to produce MXene and PVA-derived carbon composite aerogels (MPAs) with microstructures ranging from ordered to disordered arrangements. The incorporation of PVA inhibited nanosheet stacking, and PVA carbonization enhanced the electrical conductivity of the aerogel. The carbonized aerogel (MPA2.0) exhibited a larger specific capacitance along with a more disordered and denser microstructure, thereby accounting for the increased capacitance due to enhanced ion storage in the more structurally disordered carbon nanopores. The optimized MPA aerogel demonstrated a high power density, along with an excellent specific capacitance (MPA2.0 = 348.14 F g 1, 2 mV s 1 scan rate), and a cycling stability of 92.52 after 10,000 charge discharge cycles. Furthermore, the MPA2.0-based supercapacitor obtained an impressive energy density (37.8 Wh kg 1) and an exceptionally high power density (1800 W kg 1) at a current density of 1 A g 1. By adjusting the PVA loading, the shrinkage and stress strain characteristics of the microstructure during freeze-drying and carbonization were altered, and the microstructural orientation of the resulting aerogels was controlled. The increased disorder in the aerogel enhanced its capacitor energy storage ability, providing a new approach for the design of multi-component high-performance hybrid supercapacitor electrodes.	{"Structural disorder","PVA-derived carbon","MXene aerogel","High power density",Supercapacitor}
896	A dual-purpose binder-free FeNiS2-Decorated Ti3C2Tx nanocomposite for supercapacitor and catalytic hydrogen evolution reaction	Brindha Devi Sankar, Sankar Sekar, Veeramuthu Vignesh, Jrjeng Ruan, Rajkumar Nirmala, Youngmin Lee, Sejoon Lee, Pei-Chien Tsai, Shang-Cyuan Chen, Yuan-Chung Lin, Vinoth Kumar Ponnusamy, Rangaswamy Navamathavan	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.237412	https://www.sciencedirect.com/science/article/pii/S0378775325012480	0378-7753	This study is focused on developing novel electrode material, FeNi-based sulfide nanoparticles (FNS) incorporated onto titanium carbide (Ti3C2Tx, TC, MXene) deposited on Ni foam (NF), termed as FNS NF TC, for energy conversion and storage application. This nanocomposite offers an improved conductivity, and stability for electrocatalytic hydrogen evolution reaction (HER) and electrochemical capacitor applications. This FNS NF TC nanostructured electrode is fabricated by using a binder-free technique, which is simple electrochemical deposition. The fabricated electrode shows a higher specific capacitance of 1460 F g at the current density of 2 A g with capacitance retention of 91.8 and coulombic efficiency of 92 after 5000 cycles. In the case of electrocatalytic water splitting HER, the lower overpotential is calculated at around 104 mV at the current density of 10 mA cm2 and decreased Tafel slope of around 65 mV dec for the FNS NF TC nanostructured electrode with good stability after 12 h in chronopotentiometry technique. Overall, the deposition of FeNiS2 on the Ti3C2Tx NF composite enhances ion transport and storage capacity, positioning it as an up-and-coming candidate for efficient and sustainable energy conversion and storage solutions in the energy sector.	{"MXene (Ti3C2Tx)","Bimetal sulfide",Electrodeposition,"Electrocatalytic water splitting",Supercapacitor}
897	Ti3C2Tx MXene rGO composite electrodes for high-performance supercapacitor applications	Avinash Rundla, Priyanka, Bheem Kumar, Prashant Tripathi, Pushpendra Kumar, Kedar Singh	Journal of Power Sources	2025	https://doi.org/10.1016/j.jpowsour.2025.236408	https://www.sciencedirect.com/science/article/pii/S0378775325002447	0378-7753	The depletion of fossil fuels and the growing demand for sustainable energy solutions necessitate advanced materials for energy storage. This study addresses the challenge of improving supercapacitor performance by developing a hybrid composite of Ti3C2Tx MXene and reduced graphene oxide (rGO). The integrating rGO as a conductive bridge impacts the structural stability and electrochemical properties of Ti3C2Tx. Ti3C2Tx MXene was synthesized from Ti3AlC2 MAX phase via selective etching of aluminum, followed by mixing with rGO in ethanol at varying ratios to prepare Ti3C2Tx rGO composites. The incorporation of rGO minimizes volumetric strain during charge-discharge cycles and enhances conductivity by serving as a nanoscale current collector. Characterization using SEM, TEM, Raman spectroscopy, BET, and XRD confirmed the successful formation of the composite with improved structural integrity. Electrochemical tests, including cyclic voltammetry, galvanostatic charge-discharge, and electrochemical impedance spectroscopy, demonstrated a substantial enhancement in specific capacitance. Notably, the (Ti3C2Tx)90(rGO)10 composition achieved a capacitance of 357 Fg-1 at 1 Ag-1, compared to 220 Fg-1 for pristine Ti3C2Tx. This study highlights the uniqueness of leveraging rGO as a conductive bridge to improve MXene-based supercapacitors, providing a promising pathway for next-generation energy storage solutions with enhanced performance and durability.	{Ti3C2Tx,"Ti3C2Tx@rGO nanocomposites","High-performance supercapacitor","Chemical etching",Charge-discharge,"BET analysis"}
898	Ti3C2Tx MXene-embedded MnO2-based hydrophilic electrospun carbon nanofibers as a freestanding electrode for supercapacitors Electronic supplementary information (ESI) available. See DOI: https: doi.org 10.1039 d3cc03925k	Zhaorui Wang, Deyang Zhang, Ying Guo, Hao Jiang, Di Wang, Jinbing Cheng, Paul K. Chu, Hailong Yan, Yongsong Luo	Chemical Communications	2023	https://doi.org/10.1039/d3cc03925k	https://www.sciencedirect.com/science/article/pii/S1359734523033207	1359-7345	ABSTRACT Herein, MnO2 nanoflowers are electrodeposited on a self-supported and electroconductive electrode in which 2D Ti3C2Tx nanosheets are encased in carbon nanofibers (MnO2 Ti3C2Tx CNFs). This improves the conductivity and hydrophilicity of the MnO2 composite electrode. The asymmetric supercapacitor shows a high energy density of 46.4 W h kg 1 and a power density of 4 kW kg 1.	{}
899	Nitrogen-doped Ti3C2Tx MXene prepared by thermal decomposition of ammonium salts and its application in flexible quasi-solid-state supercapacitor	Man Cai, Xiaochun Wei, Haifu Huang, Fulin Yuan, Cong Li, Shuaikai Xu, Xianqing Liang, Wenzheng Zhou, Jin Guo	Chemical Engineering Journal	2023	https://doi.org/10.1016/j.cej.2023.141338	https://www.sciencedirect.com/science/article/pii/S1385894723000694	1385-8947	Two-dimensional (2D) Ti3C2Tx MXenes show great potential for application in flexible supercapacitors, due to their good hydrophilicity, metallic conductivity and excellent flexibility. Surface modification of the MXenes by heteroatom doping is a good strategy for adjusting the layer spacing and alleviateing various shortcomings. Herein, the ammonium salt decomposition method is shown to allow rapid nitrogen doping into Ti3C2Tx nanosheets at a low temperature of 350 C. Compared to the raw Ti3C2Tx, the nitrogen-doped Ti3C2Tx (designated N-Ti3C2Tx) shows an increased layer spacing of 1.451 nm, nitrogen doping levels of 1.42 at and a low number of residual fluorine functional groups. For the application as an electrode of supercapacitors, the N-Ti3C2Tx electrode shows an outstanding pseudocapacitance performance and mechanical flexibility, with a high specific capacitance of up to 449 F g 1 at 2 mV s 1, which is 1.4 times that of the raw Ti3C2Tx MXene (i.e., 321 F g 1). Furthermore, a quasi-solid-state symmetric supercapacitor assembled with a H2SO4-PVA gel electrolyte is shown to deliver an energy density of 9.57 Wh kg 1 at 250 W kg 1. The outstanding pseudocapacitance of the N-Ti3C2Tx is attributed to the positive effect of nitrogen doping on MXene, such as larger layer spacing and the increased number of surface active sites. The strategy presented herein also opens up a convenient and versatile approach for preparing high performance MXene Materials for energy conversion and storage.	{MXene,Supercapacitors,"Nitrogen doping",Pseudocapacitance}
900	Construction of CoMoO4 nanosheets arrays modified by Ti3C2Tx MXene and their enhanced charge storage performance for hybrid supercapacitor	Xiaochun Wei, Man Cai, Fulin Yuan, Cong Li, Haifu Huang, Shuaikai Xu, Xianqing Liang, Wenzheng Zhou, Jin Guo	Colloids and Surfaces A: Physicochemical and Engineering Aspects	2023	https://doi.org/10.1016/j.colsurfa.2022.130637	https://www.sciencedirect.com/science/article/pii/S0927775722023925	0927-7757	MXenes are considered to be a new two-dimensional material with excellent conductivity, large specific surface area, and fast transfer channels for electrons, thereby provides efficient bridge to improve conductivity and structural stability of battery-type electrode materials. In this work, Ti3C2Tx MXene is integrated into CoMoO4 nanoarrays by a simple hydrothermal process to form a cross-supported nanoarray structure of CoMoO4-Ti3C2Tx with three-dimensional heterogeneous interface. It is worth noting that CoMoO4 thinner nanosheets expose more electrochemical active sites under synergistic effect of Ti3C2Tx MXene, thereby greatly increases the specific capacity of CoMoO4 nanoarrays. At the same time, it can alleviate the volume expansion and contraction of CoMoO4 materials during the charge-discharge process, and thus improves their cycle life performance. The CoMoO4-Ti3C2Tx nanoarrays show a high specific capacity value of 870.7 C g 1 at a current density of 1 A g 1,and capacity retention rate of 68.2 after 6000 cycles, which is better than the unmodified CoMoO4 electrode (specific capacity: 737.0 C g 1, retention rate: 54 after 5000 cycles). Furthermore, a hybrid supercapacitor fabricated by CoMoO4-Ti3C2Tx and N-doped graphene electrode delivers high capacitance value of 148 F g 1 and energy density of 46.3 Wh kg 1. This work demonstrates great potential of the CoMoO4-Ti3C2Tx nanoarrays for high-performance supercapacitors.	{Supercapacitors,CoMoO4,"Ti3C2Tx MXene",Nanoarrays}
901	Heterostructured Ti3C2Tx loaded NiCoCu-based layered double hydroxide as a high-performance cathode for hybrid supercapacitors	Disong Wang, Xiaohui Guan, Liu Yang, Baoyang Tian, Jiqing Zhang, Ruotong Li, Tao Zou, Penggang Yin, Guangsheng Wang	Journal of Energy Storage	2025	https://doi.org/10.1016/j.est.2025.117581	https://www.sciencedirect.com/science/article/pii/S2352152X25022947	2352-152X	Layered double hydroxides (LDHs) are regarded as a promising electrode material for supercapacitors. Nevertheless, their large-scale application is impeded by several drawbacks, such as low electronic conductivity, limited electroactive sites, and poor cycling stability. Two-dimensional titanium-based carbide (Ti3C2Tx) loading NiCoCu-based layered double hydroxide heterostructures (Ti3C2Tx NiCoCu-LDH), which feature a layered and cross-linked network, were prepared to improve the electrochemical performance of NiCoCu-LDH. The layered network structure of Ti3C2Tx NiCoCu-LDH enhances active site exposure and accommodates volume changes during cycling. Both the specific capacitance and structural stability of the electrode are improved. Additionally, Ti3C2Tx boosts the electronic conductivity of LDHs and accelerates the kinetics of electrochemical reactions. Ti3C2Tx NiCoCu-LDH exhibits a high specific capacity of 1891.4 F g 1 (262.2 mAh g 1) at 1 A g 1 and exceptional cycling stability. When assembled into Ti3C2Tx NiCoCu-LDH activated carbon (AC) hybrid supercapacitor, it demonstrates a high energy density of 35.5 Wh kg 1 at 826.8 W kg 1. In addition, the supercapacitor maintains 81.6 of initial capacitance after 20,000 cycles. This work has proposed a promissing MXene-based composite cathode for high-performance hybrid supercapacitors.	{Ti3C2Tx,"Layered double hydroxide","Ti3C2Tx@NiCoCu-LDH heterostructures","Hybrid supercapacitors"}
902	Cost-effective synthesis route for ultra-high purity of Ti3AlC2 MAX phase with enhanced performance of Ti3C2Tx MXene and MXene NiO composite for supercapacitor application	Kapil Dev Verma, Kamal K. Kar	Chemical Engineering Journal	2025	https://doi.org/10.1016/j.cej.2024.158938	https://www.sciencedirect.com/science/article/pii/S1385894724104299	1385-8947	MXene, an emerging material with versatile properties, holds immense promise for supercapacitor applications. However, transitioning from laboratory-scale synthesis to commercial viability faces significant challenges, primarily due to the prohibitively high cost, small lifespan, and self-stacking nature. Prior attempts to lower the cost burden by employing TiO2 as impurities such as TiC, TiAl, and Ti2AlC have hindered a precursor rather than Ti TiC expensive materials. Herein, a synthesis method was presented to prepare an ultra-high pure Ti3AlC2 MAX phase using an optimized molar ratio of precursors (TiO2: Al: C), calcination process, and HCl washing. The obtained material was subsequently transformed into pure Ti3C2Tx MXene by a mild etching process that helps to sustain a long lifespan. Further, to address the restacking issue and low performance of Ti3C2Tx for supercapacitor applications, a composite of MXene NiO (MX NiO) was synthesized through bath sonication. MXene exhibits a specific capacitance of 358.5 F g 1, while MX NiO composite achieves 892 F g 1 at 1 A g 1 current density within a potential window of 0.6 0.4 V with 2 M H2SO4 electrolyte. Further, in 6 M KOH electrolyte, Ti3C2Tx and MX NiO-based symmetric supercapacitors show 171 and 461 F g 1 specific capacitance at 1 A g 1 current density. The DFT-based theoretical capacitance analysis of MAX phase, MXene, and MX NiO composite supports electrochemical results. By addressing the limitations of previous approaches, this methodology can bridge the gap between laboratory research and large-scale commercial production of MXene, thus unlocking its full potential for supercapacitor applications.	{"Ti3AlC2 MAX phase","Ti3C2Tx MXene","Titanium oxide","Nickel oxide",Supercapacitor}
903	Construction of CuCo2O4 hollow microspheres Ti3C2Tx MXene composite for electrode material of hybrid supercapacitors	Xiaobo Chen, Mengwen Zhou, Yi Min	Colloids and Surfaces A: Physicochemical and Engineering Aspects	2024	https://doi.org/10.1016/j.colsurfa.2024.134315	https://www.sciencedirect.com/science/article/pii/S0927775724011762	0927-7757	CuCo2O4 is a promising active electrode material for its considerable theoretical capacities and natural abundance, however, also is plagued by the disadvantages of the intrinsic low electrical conductivity, slow reaction kinetics and relatively low specific capacity in the practical applications, hence, the precise hybridization with high conductivity and active surface matrix is a promising strategy to overcome these limitations. Herein, porous CuCo2O4 hollow microspheres (CuCo2O4-HS) with the diameter of about 500 nm are hybridized with Ti3C2Tx MXene nanosheets (CuCo2O4-HS MXene) by electrostatic self-assembly. The crystal structure, morphology and elemental composition of prepared CuCo2O4-HS MXene are confirmed by X-ray diffraction (XRD), scanning electron microscopy (SEM), transmission electron microscopy (TEM) and X-ray photoelectron spectroscopy (XPS). Electrochemical test results show that the CuCo2O4-HS MXene-3 electrode delivers an outstanding specific capacity of 1341.4 C g 1 at 1 A g 1 and retained excellent cyclic stability of 90.9 retention during 10000 cycles of charge discharge at 5 A g 1. Additionally, the hybrid supercapacitors (HSC) device from CuCo2O4-HS MXene-3 demonstrated excellent specific energy of 66.3 Wh kg 1 and 49.8 W h kg 1 at specific power of 724.3 W kg 1 and 7229.8 W kg 1 respectively. Significantly, two HSCs connected in series can light a commercial blue LED (3 V) for about 10 mins, demonstrating promising prospect for practical applications.	{CuCo2O4,"Hollow microspheres",MXene,Composite,"Hybrid supercapacitors"}
904	Hierarchical NiGa-LDH Ti3C2Tx MXene composites for enhanced capacitance in alkaline all-solid-state energy storage	Wendong Xu, Mai Li, Haotian Hu, Waqar ul Hasan, Chenxi Li, Qinglin Deng, Zheyi Meng, Xiang Peng	Journal of Colloid and Interface Science	2025	https://doi.org/10.1016/j.jcis.2025.137341	https://www.sciencedirect.com/science/article/pii/S0021979725007325	0021-9797	In recent years, the rapid advancement of safe energy storage devices with high energy and power densities has generated significant interest in all-solid-state supercapacitors (SCs). MXene-based nanomaterials have emerged as promising candidates for energy storage owing to their exceptional redox properties, extensive surface area, and high metallic conductivity. Additionally, layered double hydroxides (LDHs), distinguished by their distinct nanostructures, and efficient ion channels, with elevated specific capacitance, have attracted interest. Consequently, a novel all-solid-state supercapacitor(AASCs) was fabricated by employing a hydrothermal method to integrate NiGa-LDH nanosheets with Ti3C2Tx MXene, resulting in enhanced energy storage properties. The NiGa-LDH Ti3C2Tx MXene exhibits excellent properties, including a specific capacitance of 618.66 F g 1 at 1 mA cm 2 and 93.75 capacitance retention after 5,000 cycles at 1 mA cm 2. The all-solid-state NiGa-LDH Ti3C2Tx MXene activated carbon(AC) asymmetric supercapacitor (AASCs) demonstrates an impressive energy density of 20 Wh kg 1 and a high power density of 400 W kg 1. Density-functional theory (DFT) studies show that NiGa-LDH Ti3C2Tx MXene has a high density of states (DOS) around the Fermi level and possesses a potassium ion adsorption energy of 2.36 eV. This study provides technical and theoretical insights into the design of intricate nanostructures utilizing MXene-based nanomaterials for all-solid-state energy storage device.	{Supercapacitor,"Layered double hydroxides","Gel electrolyte","Ti3C2Tx MXene","All-solid-state device"}
905	Recent progress in the synthesis of nanostructured Ti3C2Tx MXene for energy storage and wastewater treatment: a review	Qui Thanh Hoai Ta, Jianbin Mao, Ngo Thi Chau, Ngoc Hoi Nguyen, Dieu Linh Tran, Thi My Huyen Nguyen, Manh Hoang Tran, Hoang Van Quy, Soonmin Seo, Dai Hai Nguyen	Nanoscale Advances	2025	https://doi.org/10.1039/d5na00021a	https://www.sciencedirect.com/science/article/pii/S2516023025002333	2516-0230	MXene-based functional 2D materials hold significant potential for addressing global challenges related to energy and water crises. Since their discovery in 2011, Ti3C2Tx MXenes have demonstrated promising applications due to their unique physicochemical properties and distinctive morphology. Recent advancements have explored innovative strategies to enhance Ti3C2Tx into multifunctional materials, enabling applications in gas sensing, electromagnetic interference shielding, supercapacitors, batteries, water purification, and membrane technologies. Unlike previous reviews that primarily focused on the synthesis, properties, and individual applications of MXenes, this work provides a fundamental discussion of their role in wastewater treatment, recent advancements in energy harvesting, and their broader implications. Additionally, this review offers a comparative analysis of MXene-based systems with other state-of-the-art materials, providing new insights into their future development and potential applications.	{}
906	Cation-induced Ti3C2Tx MXene melamine sponge aerogels with large layer spacing and high strength for high-performance supercapacitors	Debin Cai, Shuai Wu, Zhen Tian, Li Guo, Yanzhong Wang	Journal of Colloid and Interface Science	2024	https://doi.org/10.1016/j.jcis.2024.03.135	https://www.sciencedirect.com/science/article/pii/S0021979724006374	0021-9797	The self-assembled aerogels are considered as an efficient strategy to address the aggregation and restacking of Ti3C2Tx MXene nanosheets for high-performance supercapacitors. However, the low mechanical strength of the MXene aerogel results in the structural collapse of the self-standing supercapacitor electrode materials. Herein, a low-cost melamine sponge (MS) absorbed different cations (H+, K+, Mg2+, Fe2+, Co2+, Ni2+ and Al3+), serves as a carrier and crosslinker for loading MXene hydrogel induced by the absorbed cations on the skeleton surface and the pores of MS, resulting in the high loading mass MXene aerogels with high mechanical strength. The experimental results show that the Mg-Ti3C2Tx MS aerogel exhibits the maximum area capacitance of 702.22 mF cm 2 at 3 mA cm 2, and the area capacitance is still 603.12 mF cm 2 even at 100 mA cm 2, indicating the high rate capability with a capacitance retention of 85.89 . It is worth noting that the constructed asymmetric supercapacitor with activated carbon achieves high energy densities of 104.53 μWh cm 2 and 93.87 μWh cm 2 at 800 μW cm 2 and 7999 μW cm 2, respectively. Furthermore, the asymmetric supercapacitor shows the high cycling stability with 90.2 capacity retention after 10,000 cycles. This work provides a feasible strategy to prepare Ti3C2Tx MXene aerogels with large layer spacing and high strength for high-performance supercapacitors.	{"MXene aerogel","Melamine sponge","High area performance","Asymmetric supercapacitors"}
907	Synthesis effect on surface functionalized Ti3C2Tx MXene supported nickel oxide nanocomposites with enhanced specific capacity for supercapacitor application	Prabhakar Nikhil, S. Vasanth, N. Ponpandian, C. Viswanathan	Journal of Energy Storage	2023	https://doi.org/10.1016/j.est.2023.108414	https://www.sciencedirect.com/science/article/pii/S2352152X2301811X	2352-152X	Rich surface functionalization and active electrolyte-accessible supercapacitors are considered promising tools for enhanced energy storage capacity due to their high specific capacity and simple construction. One of the challenges in technical applications of recently developed MXene is that it causes phase transition and structural decomposition over time without delamination. Thus, a simple but effective method for increasing the stability of exfoliated MXene (Ti3C2Tx) by passivating exposed edges with Tetramethyl Ammonium Hydroxide (TMAOH) has been adopted here. In this work, we performed this delaminated MXene (DLMX) supported Nickel oxide (NiO) by three different synthesizing routes for composite preparation which have been thoroughly discussed. Bath Sonication assisted DLMX NiO was found to increase oxygen-containing surface functionalities, surface area, and uniform delivery of partner composite, enhancing the electrochemical properties compared to Solvothermal and in situ-delamination synthesis. At a current density of 1 A g, the fabricated electrode material exhibited a maximum capacity of 770C g. After 3500 cycles a remarkable cycling performance of 97.2 capacity retention and reached 88.1 after 5000 cycles at 8 A g current density. The as-assembled supercapacitor device has an energy density of up to 73 Wh kg 1 and a power density of 900 W kg 1 signifying an excellent device prospect, making them more practicable for marketable devices for advanced energy storage applications.	{MXene,"Symmetric supercapacitor",Delamination,Intercalation,Supercapacitor,"Nickel oxide"}
908	Co-precipitation synthesis of pseudocapacitive λ-MnO2 for 2D MXene (Ti3C2Tx) based asymmetric flexible supercapacitor	B. Thanigai Vetrikarasan, Abhijith R. Nair, T. Karthick, Surendra K. Shinde, Dae-Young Kim, Shilpa N. Sawant, Ajay D. Jagadale	Journal of Energy Storage	2023	https://doi.org/10.1016/j.est.2023.108403	https://www.sciencedirect.com/science/article/pii/S2352152X23018005	2352-152X	The rapid growth of wearable portable electronics imposes a development of flexible, lightweight and highly efficient energy storage devices. In this work, we have synthesized λ-MnO2 nanoplates through one step co-precipitation method and used for flexible asymmetric supercapacitor (SC). The structural, morphological and electrochemical properties of synthesized λ-MnO2 were systematically investigated. The optical and electronic properties of λ-MnO2 were studied using UV vis spectroscopy and density functional theory (DFT) calculations. The pseudocapacitive λ-MnO2 nanoplates-like electrode showed a maximum specific capacitance of 288.5 F g 1 at the scan rate of 5 mV s 1. To check the practicability, symmetric (λ-MnO2 λ-MnO2) as well as asymmetric (λ-MnO2 AC and λ-MnO2 Ti3C2Tx MXene) SCs were fabricated and their performances were compared. The asymmetric λ-MnO2 Ti3C2Tx MXene SC demonstrated a maximum energy density of 15.5 Wh kg 1 at the power density 1100 W kg 1 along with 86.3 of capacitive retention after 5000 cycles. Besides, to confirm the suitability of these electrodes for flexible energy storage, a flexible λ-MnO2 Ti3C2Tx asymmetric SC was fabricated using PVA: Na2SO4 gel polymer electrolyte that operated in the potential window of 2 V and supplies high areal energy density of 39.9 μWh cm 2 at a power density of 8586 μW cm 2. Therefore, the λ-MnO2 prepared with a simple and scalable co-precipitation method may play a promising role in flexible energy storage.	{λ-MnO2,Nanoplate,"Ti3C2Tx MXene","Flexible hybrid supercapacitor"}
909	High-performance solid-state asymmetric supercapacitor based on Ti3C2Tx MXene VS2 cathode and Fe3O4 rGO hydrogel anode	Xiaobo Chen, Jianghao Cai, Chengqun Qiu, Weiwei Liu, Yiqi Xia	Electrochimica Acta	2023	https://doi.org/10.1016/j.electacta.2022.141572	https://www.sciencedirect.com/science/article/pii/S0013468622017297	0013-4686	Herein, we report the synthesis of MXene VS2 composites for asymmetric supercapacitors using a hydrothermal method. Impressively, the resulting MXene VS2 electrode shows an outstanding specific capacity of 895.7 C g 1 (1791.4 F g 1) at 1 A g 1, rate capability (587.5 C g 1 (1175.0 F g 1) at 20 A g 1), and cycle performance (90.6 capacity retention after 10,000 cycles), owing to its specific microstructures with connected nanosheets and enhanced electrochemical conductivity arising from the synergistic effect of VS2 and conductive MXene. To achieve higher energy density in the solid-state asymmetric supercapacitor (ASC) device, Fe3O4 nanoparticles uniformly dispersed and encapsulated into the rGO sheets (Fe3O4 rGO) as a negative electrode is also designed. The obtained MXene VS2 was used as a cathode and Fe3O4 rGO acted as a anode. Further, an assembled MXene VS2 Fe3O4 rGO ASC device delivered an impressive specific capacitance of 365.4 C g 1 (228.4 F g 1) at 1 A g 1, in addition, the device yielded the specific energy of up to 73.9 Wh kg 1 at the corresponding specific power of 728.2 W kg 1 with superior cycling performance (90.7 capacity retention after 10,000 cycles at 8 A g 1), demonstrating its high potential for applications in high-porformance energy storage devices.	{"Vanadium disulfide (VS2)",MXene,Graphene,Fe3O4,"Asymmetric supercapacitors"}
910	Binder-free flexible Ti3C2Tx MXene reduced graphene oxide carbon nanotubes film as electrode for asymmetric supercapacitor	Wenlong Luo, Qianwen Liu, Baozhong Zhang, Jie Li, Ruidong Li, Tingxi Li, Zhiqiang Sun, Yong Ma	Chemical Engineering Journal	2023	https://doi.org/10.1016/j.cej.2023.145553	https://www.sciencedirect.com/science/article/pii/S1385894723042845	1385-8947	MXene nanosheets are susceptible to self-accumulation during operation, which significantly hampers their application. However, this issue can be effectively addressed through the introduction of intercalation materials. In this study, an MXene reduced graphene oxide (rGO) carbon nanotubes (CNTs) (MGC) film is prepared using vacuum-assisted filtration. CNTs and rGO nanosheets, as intercalation materials, play a crucial role in forming a stable interlayer structure with MXene nanosheets, resulting in an expansion of the MXene layer spacing and the creation of multi-directional stable ion transport channels. Consequently, a larger number of ion-accessible active sites are exposed. The prepared MGC film exhibits an impressive specific capacitance of 463.5F g 1 at a current density of 1 A g 1. Furthermore, it is noteworthy that the asymmetric supercapacitor (ASC) assembled with the MGC film as the negative electrode and MnO2 as the positive electrode demonstrates a large voltage window of 1.7 V, a high energy density of 33.95 Wh kg 1 at a power density of 814.8 W kg 1, and an outstanding capacitance retention rate of 92.9 after 8000 cycles at 3 A g 1. The optimization strategy for MGC electrodes not only showcases the feasibility of MXene development but also provides crucial technical support for the application of MXene in the emerging generation of portable and flexible wearable energy storage devices.	{"Ti3C2Tx MXene","Carbon nanotubes","Reduced graphene oxide",Flexibility,Supercapacitor}
911	Ti3C2Tx MXene coated carbon fibre electrodes for high performance structural supercapacitors	Bhagya Dharmasiri, Ken Aldren S. Usman, Si Alex Qin, Joselito M. Razal, Ngon T. Tran, Piers Coia, Timothy Harte, Luke C. Henderson	Chemical Engineering Journal	2023	https://doi.org/10.1016/j.cej.2023.146739	https://www.sciencedirect.com/science/article/pii/S1385894723054700	1385-8947	MXenes, while excellent for electrical energy storage, face challenges in translating their nanoscale properties to macroscale structures. To address this, MXene-coated carbon fibers (CF) were developed as electrode materials for structural supercapacitor composites. CF surface chemistry was tailored using aryl diazonium salts ( NO2, NH2, -SH, COOH) to optimize MXene adhesion. Electrodes were characterized for surface chemistry, morphology, and properties including electrochemical, mechanical, and interfacial aspects. Electrodes developed from MXene coated on CF functionalized with a poly(o-phenyelenediamine) coating exhibited a specific capacitance of 157 F g 1 at 5 mV s 1, a 725-fold improvement in capacitance compared to pristine unfunctionalized CF, with minimal to no compromise in the underlying strength and stiffness of the CF. The MXene coating also improved the interfacial adhesion of the electrode to an epoxy-based resin by 54 . The process was scaled up to functionalize and coat woven CF mats and were used to fabricate a structural supercapacitor device. The device exhibited a specific capacitance of 908 mF g 1 at 0.5 mA g 1, representing a remarkable 42-fold improvement compared to the control. This lightweight multifunctional supercapacitor composite holds great potential in aerospace, automotive, and renewable energy storage sectors, addressing global challenges tied to fossil fuel combustion and associated environmental and socio-economic issues.	{MXene,"Carbon fibre","Electrochemical surface functionalization","Structural supercapacitors","Multifunctional composites"}
912	Synergistically modified Ti3C2Tx MXene conducting polymer nanocomposites as efficient electrode materials for supercapacitors	Sophy Mariam Varghese, Visakh V. Mohan, Sruthi Suresh, E. Bhoje Gowd, R.B. Rakhi	Journal of Alloys and Compounds	2024	https://doi.org/10.1016/j.jallcom.2023.172923	https://www.sciencedirect.com/science/article/pii/S0925838823042263	0925-8388	MXene-conducting polymers have attracted significant research attention as exceptional electrode materials for energy storage applications. Herein, we report the synthesis of titanium carbide MXene via exfoliation, succeeded by one-step oxidative polymerization and surface modification with polypyrrole (PPy) and polyaniline (PANI). Electrochemical characterizations conducted in a symmetric two-electrode assembly reveal that the MXene-PANI electrode supercapacitor demonstrates a specific capacitance of 430 F g 1, surpassing both MXene-PPy (305 F g 1) and pure MXene (105 F g 1) supercapacitors. Furthermore, the MXene-PANI symmetric supercapacitor demonstrates a specific energy of 38 Wh kg 1 at a specific power of 808 W kg 1. The MXene-PANI and MXene-PPy electrode materials exhibited a capacitance retention of 84 and 85 respectively, after 10,000 continuous GCD cycles. The study highlights the application of MXene-polymer nanocomposites as efficient electrode materials for supercapacitors.	{MXene,Polyaniline,Polypyrrole,Supercapacitors,"Electrochemical performance"}
913	Flexible Ti3C2Tx MXene polypyrrole composite films for high-performance all-solid asymmetric supercapacitors	Wenlong Luo, Yue Sun, Yongqin Han, Jianxu Ding, Tingxi Li, Chunping Hou, Yong Ma	Electrochimica Acta	2023	https://doi.org/10.1016/j.electacta.2023.141818	https://www.sciencedirect.com/science/article/pii/S0013468623000051	0013-4686	Ti3C2Tx MXene has shown great potential as supercapacitor electrode due to its unique high conductivity and specific surface area, but achieving high capacitance, high energy density, good mechanical flexibility and cycling stability simultaneously is challenging. Herein, MXene polypyrrole (M-PPy) composite films are fabricated by vacuum-assisted suction filtration of a mixture of MXene nanosheets and polypyrrole (PPy) nanofibers. MXene nanosheet layers are optimally arranged by the intercalation of PPy nanofiber to reduce MXene self-stacking while reducing PPy swelling. The optimal M-PPy3 (3 mL PPy) possesses high capacitance (563.8 F g 1, 0.5 A g 1) and excellent cycling performance (79.5 , 6000 times, 5 A g 1). Next, the flexible M-PPy3 MnO2 asymmetric supercapacitor (ASC) are assembled with MnO2 as the positive electrode and M-PPy3 as the negative electrode. The ASC exhibits 86.8 capacitance retention even after 6000 charge discharge tests at 2 A g 1, and provides an energy density of 35.3 Wh kg 1 at 486.1 W kg 1, demonstrating remarkable energy storage capacity. Furthermore, a 1.8 V LED is successfully lit up by connecting two ASCs in series. This study provides a better electrode structure for the study of the electrochemical performances of MXene, and the M-PPy3 displays its application in flexible wearable devices.	{"Ti3C2Tx MXene nanosheets","Polypyrrole nanofibers","Composite films",Flexibility,Supercapacitor}
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.properties (property_id, material_id, property_type, value, unit, test_conditions) FROM stdin;
2208	759	Conductivity	353.77	S/m	
2209	759	Fracture_Stress	41.09	MPa	
2210	759	Young_Modulus	7.34	GPa	
2211	760	Capacitance	1691.0	mF/cm²	
2212	760	Energy_Density	214.4	μWh/cm²	
2213	761	Capacitance	500.0	F/g	at 1 A/g
2214	761	Energy_Density	19.6	Wh/kg	at a specific power of 742.7 W/kg
2215	761	Capacitance	472.0	F/g	at 5 mV/s in aqueous 2 M KOH by CV analysis
2216	761	Capacitance	400.0	F/g	at 5 mV/s in aqueous 2 M KOH by CV analysis
2217	761	Capacitance	91.0	%	after 4000 GCD cycles
2218	762	Capacitance	530.0	F/g	at 1 A/g
2219	762	Capacitance	300.0	F/g	at 50 A/g
2220	762	Energy_Density	23.8	Wh/kg	at 300.2 W/kg
2221	763	Energy_Density	70.0	Wh/kg	for symmetric MXene-based supercapacitors
2222	763	Power_Density	5000.0	W/kg	for symmetric MXene-based supercapacitors
2223	763	Energy_Density	100.0	Wh/kg	for asymmetric MXene-based supercapacitors
2224	763	Power_Density	8000.0	W/kg	for asymmetric MXene-based supercapacitors
2225	763	Cycling_Stability	25000.0	cycles	for symmetric MXene-based supercapacitors
2226	763	Cycling_Stability	10000.0	cycles	for asymmetric MXene-based supercapacitors
2227	764	Capacitance	1873.0	C/g	In a three-electrode setup
2228	764	Capacitance	948.0	C/g	In a three-electrode setup
2229	764	Capacitance	1425.0	C/g	In a three-electrode setup
2230	764	Energy_Density	93.17	Wh/kg	GQDs MTZ AC asymmetric supercapacitor
2231	764	Power_Density	1240.0	W/kg	GQDs MTZ AC asymmetric supercapacitor
2232	764	Capacity_Retention	97.0	%	After 10,000 cycles
2233	764	Coulombic_Efficiency	95.0	%	After 10,000 cycles
2234	765	Capacitance	2577.0	F/g	at 1 A/g as an adjusted current density
2235	765	Cycle_Life	7000.0	cycles	90.1% retention after 7000 cycles
2236	765	Energy_Density	85.6	Wh/kg	when power density is altered at 678.5 W/kg
2237	765	Cycle_Life	10000.0	cycles	88% retention after 10,000 GCD cycles
2238	766	Capacitance	31.7	F/g	AQ-2-MX
2239	766	Capacitance	29.4	F/g	MA-NTCDA-MX
2240	766	Interfacial_Shear_Strength	45.4	MPa	AQ-1-MX
2241	766	Interfacial_Shear_Strength	51.7	MPa	MA-PTCDA-MX
2242	767	Capacitance	581.2	F/g	at 1 A/g
2243	767	Energy_Density	43.2	Wh/kg	at 799.8 W/kg
2244	767	Capacitance	87.1	%	after 10,000 cycles at 3 A/g
2245	768	Capacitance	417.4	F/g	1 mV s in 1 M H2SO4
2246	769	Conductivity	353.77	S/m	not explicitly mentioned
2247	770	Capacitance	77.0	%	10 to 1,000 mV s
2248	770	Energy_Density	20.0	Wh/kg	in 3 M H2SO4
2249	770	Capacitance	64.0	F/g	10 mV s
2250	770	Capacitance	16.0	F/g	5000 mV s
2251	770	Capacitance	80.0	%	after 10,000 charge discharge cycles
2252	771	Conductivity	353.77	S/m	not explicitly mentioned
2253	772	Capacitance	223.4	F/g	scan rate of 1000 mV/s
2254	772	Energy_Density	16.88	Wh/kg	power density of 799 W/kg
2255	772	Energy_Density	13.11	Wh/kg	power density of 8 kW/kg
2256	773	Capacitance	1231.8	mF/cm²	at 1 mA/cm²
2257	773	Capacitance	327.78	μAh/cm²	at 0.5 mA/cm²
2258	773	Energy_Density	105.15	μWh/cm²	at 0.48 mW/cm²
2259	773	Capacity_Retention	96.05	%	after 5000 cycles
2260	773	Capacity_Retention	89.29	%	after 3000 cycles
2261	775	Conductivity	353.77	S/m	not explicitly mentioned
2262	776	Capacitance	268.85	mAh/g	at 1 A/g
2263	776	Energy_Density	56.41	Wh/kg	at 800 W/kg
2264	776	Cycling_Stability	93.24	%	after 5000 cycles
2265	776	Coulombic_Efficiency	96.96	%	after 5000 cycles
2266	777	Capacitance	10.5	F/cm²	1 mA/cm²
2267	777	Capacitance	232.8	F/g	1 mA/cm²
2268	777	Energy_Density	0.705	mWh/cm²	symmetric supercapacitor
2269	777	Energy_Density	3.53	mWh/cm³	symmetric supercapacitor
2270	777	Power_Density	54200.0	mW/cm²	symmetric supercapacitor
2271	777	Power_Density	271000.0	mW/cm³	symmetric supercapacitor
2272	777	Capacitance	93.0	%	10,000 cycles at 50 mA/cm²
2273	778	Capacitance	808.0	F/g	at a low current density of 1 A/g
2274	778	Capacitance	586.2	F/g	for MXene NiCo-LDH
2275	778	Capacitance	512.0	F/g	at 10 A/g
2276	778	Energy_Density	96.4	Wh/kg	at 800 W/kg
2277	779	Conductivity	353.77	S/m	not explicitly mentioned
2278	780	Capacitance	418.2	C/g	0.5 A/g in 3 M H2SO4
2279	780	Energy_Density	20.9	Wh/kg	491.5 W/kg
2280	781	Capacitance	565.0	F/g	at 1 A/g
2281	781	Capacitance	1582.0	mF/cm²	at 1 A/g
2282	781	Fracture_Stress	34.2	MPa	high strain rates
2283	781	Capacitance	71.25	F/g	at 1 A/g
2284	781	Energy_Density	6.3	Wh/kg	at 400 W/kg
2285	781	Cycle_Stability	99.6	%	after 20,000 cycles at 10 A/g
2286	782	Capacitance	1754.0	F/g	at 3 mA cm-2 in a three-electrode configuration
2287	782	Energy_Density	54.3	Wh/kg	at a power density of 565.6 W/kg
2288	782	Energy_Density	32.6	Wh/kg	at a high-power density of 6270 W/kg
2289	782	Cycling_Stability	93.8	%	after 10,000 cycles
2290	783	Capacitance	1102.9	F/g	at 1 A/g
2291	783	Rate_Capability	66.87	at 20 A/g	at 20 A/g
2292	783	Energy_Density	47.3	Wh/kg	at 800 W/kg
2293	783	Energy_Density	35.7	Wh/kg	at 8000 W/kg
2294	783	Coulombic_Efficiency	99.0	%	after 5000 cycles
2295	783	Durability	91.7	%	after 5000 cycles
2296	784	Capacitance	1226.3	mAh/g	at a current density of 1 A/g
2297	784	Capacitance	595.74	mAh/g	at 1 A/g
2298	784	Capacitance	78.0	%	after 4000 cycles at 4 A/g
2299	784	Energy_Density	61.7	Wh/kg	
2300	784	Power_Density	426.21	W/kg	
2301	784	Capacitance	92.92	%	after 25,000 cycles at 0.5 A/g
2302	785	Capacitance	0.7	μWh/cm²	at the power density of 80.0 μW/cm²
2303	785	Energy_Density	80.0	μW/cm²	at the energy density of 0.7 μWh/cm²
2304	785	Capacitance	100.0	%	after 1000 cycles at 0.2 mA/cm²
2305	786	Energy_Density	26.8	Wh/kg	at 425 W/kg
2306	786	Cycling_Stability	97.3	%	after 20,000 cycles
2307	787	Capacitance	353.77	F/g	not explicitly mentioned
2308	788	Capacitance	265.0	F/g	at 1 A/g
2309	788	Stability	720.0	h	no supercapacitance attenuation
2310	788	Stability	550.0	days	on-shelf stability
2311	789	Fracture_Stress	163.88	MPa	Not explicitly mentioned
2312	789	Young_Modulus	2.18	GPa	Not explicitly mentioned
2313	789	Conductivity	82.63	S/cm	Not explicitly mentioned
2314	789	Capacitance	679.0	mF/cm²	At 0.8 mA/cm² current density
2315	789	Energy_Density	16.2	μWh/cm²	Not explicitly mentioned
2316	790	Capacitance	542.6	F/g	in basic media (1 M KOH)
2317	790	Capacitance	454.1	F/g	in acidic media (0.1 M H2SO4)
2318	790	Energy_Density	14.58	kWh/kg	in basic media (1 M KOH)
2319	790	Power_Density	271.2	kW/kg	in basic media (1 M KOH)
2320	790	Charge_Transfer_Resistance	64.99	Ω	in basic electrolyte
2321	790	Electron_Transfer_Rate	4.097	10^9 S/cm	in 1 M KOH
2322	790	Zeta_Potential	19.9	mV	colloidal solution
2323	790	Bandgap	1.8	eV	from UV spectra
2324	791	Capacitance	140.0	F/g	in alkaline electrolyte
2325	791	Conductivity	0.0		not explicitly mentioned
2326	792	Energy_Density	172.8	Wh/kg	at 10 A/g
2327	792	Power_Density	9625.5	Wh/kg	at 10 A/g
2328	792	Capacitance	312.5	F/g	at 1 A/g
2329	792	Capacitance	125.5	F/g	at 10 A/g
2330	792	Cycling_Stability	79.5	%	after 5000 cycles at 10 A/g
2331	792	Cycling_Stability	20.6	%	capacitance decrease after 5000 cycles
2332	793	Band_Gap_Energy	2.0	eV	lower NaOH concentrations (5 and 10 M)
2333	793	Band_Gap_Energy	2.5	eV	lower NaOH concentrations (5 and 10 M)
2334	793	Band_Gap_Energy	1.3	eV	higher NaOH concentrations (20 M and above)
2335	793	Band_Gap_Energy	1.6	eV	higher NaOH concentrations (20 M and above)
2336	794	Conductivity	353.77	S/m	not explicitly mentioned
2337	795	Capacitance	701.0	F/g	1 M KOH electrolyte
2338	795	Capacitance	100.0	F/g	1 M KOH electrolyte
2339	795	Energy_Density	55.0	W-h/kg	asymmetric supercapacitor
2340	795	Power_Density	9000.0	W/kg	asymmetric supercapacitor
2341	796	Capacitance	1370.0	F/g	Cyclic voltammetry (CV) at a scan rate of 1.0 mV/s
2342	796	Capacitance	1520.0	F/g	Galvanostatic charge-discharge (GCD) at 0.5 A/g current density
2343	796	Capacitance	1123.0	F/g	Galvanostatic charge-discharge (GCD) at 0.5 A/g current density
2344	796	Capacitance	1270.0	F/g	Galvanostatic charge-discharge (GCD) at 0.5 A/g current density
2345	796	Capacitance	873.0	F/g	Galvanostatic charge-discharge (GCD) at 1.0 A/g current density
2346	796	Capacitance	1020.0	F/g	Galvanostatic charge-discharge (GCD) at 1.0 A/g current density
2347	796	Capacitance	972.0	F/g	Cyclic voltammetry (CV) at a scan rate of 1.0 mV/s
2348	796	Capacitance	1125.0	F/g	Cyclic voltammetry (CV) at a scan rate of 1.0 mV/s
2349	796	Cyclic_Stability	73.5	%	After 10,000 full cycles at 0.5 A/g current density
2350	796	Cyclic_Stability	73.4	%	After 10,000 full cycles at 0.5 A/g current density
2351	797	Capacitance	448.8	F/g	at a current density of 0.5 A/g
2352	797	Cycling_Stability	88.0	%	after 5000 charge-discharge cycles
2353	798	Capacitance	777.7	F/g	at a current density of 1 A/g
2354	798	Capacitance	89.4	%	over 10,000 cycles within a potential range of 1.7 V
2355	798	Energy_Density	73.3	Wh/kg	
2356	798	Power_Density	849.9	W/kg	
2357	798	Conductivity	0.0	N/A	DFT calculations demonstrated that the NCO MXene composite electrode possessed enhanced conductivity with metallic properties
2358	799	Capacitance	263.0	F/g	current density of 1 A/g
2359	799	Capacitance	86.0	%	after 5000 cycles at a current density of 10 A/g
2360	799	Energy_Density	15.26	Wh/kg	at a power density of 600 W/kg
2361	800	Fracture_Stress	155.0	MPa	tensile strength
2362	800	Energy_Density	4.5	MJ/m3	breaking energy
2363	801	Capacitance	1520.0	F/g	at 1 A/g
2364	801	Energy_Density	37.4	Wh/kg	at power density of 0.8 kW/kg
2365	802	Capacitance	324.1	F/g	at current density of 1 A/g
2366	802	Capacitance	67.11	%	at current density of 10 A/g
2367	802	Energy_Density	30.8	Wh/kg	for 6-MnO2 Ti3C2Tx asymmetric capacitor
2368	802	Power_Density	7493.3	W/kg	for 6-MnO2 Ti3C2Tx asymmetric capacitor
2369	803	Capacitance	407.0	F/g	at 5 mV/s
2370	803	Interlayer_Spacing	1.1	nm	
2371	803	Hydrophilicity	13.46	degrees	contact angle (CA)
2372	804	Capacitance	1819.0	F/cm³	
2373	804	Capacitance	585.0	F/g	
2374	804	Energy_Density	47.5	Wh/L	
2375	805	Capacitance	509.44	F/g	at 1 A/g
2376	805	Charge_Retention	98.2	%	after 10,000 cycles
2377	805	Capacitance	113.03	F/g	with Ti3C2Tx TiN as cathode and activated carbon as anode
2378	805	Charge_Retention	99.44	%	after 15,000 cycles
2379	805	Energy_Density	40.19	Wh/kg	at 800 W/kg
2380	806	Capacitance	232.37	mAh/g	at 1 A/g in a three-electrode device
2381	806	Energy_Density	54.1	Wh/kg	under 800 W/kg power density
2382	806	Cycling_Stability	91.7	%	after 5000 cycles at 5 A/g
2383	807	Capacitance	405.4	F/g	current density of 2 A/g in 5 M LiCl
2384	807	Capacitance	197.6	F/g	current density of 20 A/g in 5 M LiCl
2385	807	Cycling_Stability	97.7	%	after 2000 cycles
2386	808	Conductivity	29.5	AQY	photocatalytic degradation of roxarsone
2387	809	Capacitance	252.0	F/g	ammonium storage
2388	809	Capacitance	122.0	F/g	quasi-solid-state AIHSC
2389	809	Energy_Density	43.0	Wh/kg	quasi-solid-state AIHSC
2390	809	Power_Density	800.0	W/kg	quasi-solid-state AIHSC
2391	809	Capacitance	197.0	F/g	MXene electrode
2392	812	Capacitance	92.0	F/g	2 A/g in 3 M KOH
2393	812	Capacitance	75.0	F/g	2 A/g in 3 M Na2SO4
2394	812	Capacitance	73.0	%	after 10,000 cycles in 3 M KOH
2395	812	Capacitance	51.0	%	after 10,000 cycles in 3 M Na2SO4
2396	813	Capacitance	2502.0	F/g	PANI Ti3C2Tx Ni3S4
2397	813	Capacitance	2440.0	F/g	PPY Ti3C2Tx Ni3S4
2398	813	Capacitance	2620.0	F/g	PEDOT Ti3C2Tx Ni3S4
2399	813	Energy_Density	60.2	Wh/kg	PANI Ti3C2Tx Ni3S4 AC at 1500 W/kg
2400	813	Energy_Density	86.7	Wh/kg	PPY Ti3C2Tx Ni3S4 AC at 1500 W/kg
2401	813	Energy_Density	53.4	Wh/kg	PEDOT Ti3C2Tx Ni3S4 AC at 1500 W/kg
2402	813	Capacitance	93.42	%	PANI Ti3C2Tx Ni3S4 AC after 20,000 cycles
2403	813	Capacitance	93.28	%	PPY Ti3C2Tx Ni3S4 AC after 20,000 cycles
2404	813	Capacitance	96.16	%	PEDOT Ti3C2Tx Ni3S4 AC after 20,000 cycles
2405	814	Capacitance	619.7	F/g	at 5 A/g
2406	814	Capacitance	74.2	%	from 1 to 100 mV/s scan rate
2407	814	Capacitance	81.6	%	after 10,000 cycles
2408	815	Capacitance	224.57	F/g	at 5 mV s-1
2409	815	Capacitance	193.67	F/g	at 0.5 A g-1
2410	816	Capacitance	2079.6	F/g	at 1 A/g
2411	816	Capacitance	85.0	%	at 10 A/g after 5000 cycles
2412	816	Energy_Density	67.3	W h/kg	at 750.9 W/kg
2413	816	Cyclic_Stability	89.0	%	after 5000 cycles
2414	817	Conductivity	353.77	S/m	not explicitly mentioned
2415	818	Capacitance	22.13	F/g	specific capacitance
2416	818	Capacitance	202.5	mF/cm²	area specific capacitance
2417	818	Capacitance	52.02	mF/cm²	at 0°C
2418	818	Capacitance	2.36	mF/cm²	at 25°C
2419	818	Capacitance	82.5	%	after 1000 cycles at 0°C
2420	818	Capacitance	55.15	%	after 1000 cycles at 25°C
2421	819	Purity	96.36	wt%	sintered at 1350 C for 2 h
2422	819	Specific_Surface_Area	18.23	m2/g	
2423	820	Capacitance	30.0	wt%	with the increase of MnO2 content
2424	821	Capacitance	226.6	F/g	at 5 mV/s
2425	821	Conductivity	0.0	S/m	Not explicitly mentioned
2426	821	Resistivity	0.0	Ohm*cm	Not explicitly mentioned
2427	821	Capacitance	84.2	%	after 5000 cycles
2428	821	Capacitance	63.58	%	after 10,000 cycles
2429	822	Work_Function	7.06	eV	not specified
2430	822	Work_Function	9.6	eV	not specified
2431	822	Capacitance	555.0	F/g	H2SO4 electrolyte
2432	822	Capacitance	367.5	F/g	MgSO4 electrolyte
2433	822	Capacitance	425.0	F/g	KOH electrolyte
2434	822	Power_Density	1023.0	W/kg	H2SO4 electrolyte
2435	822	Power_Density	999.86	W/kg	MgSO4 electrolyte
2436	822	Power_Density	1980.25	W/kg	KOH electrolyte
2437	822	Energy_Density	81.2	Wh/kg	H2SO4 electrolyte
2438	822	Energy_Density	40.55	Wh/kg	MgSO4 electrolyte
2439	822	Energy_Density	26.0	Wh/kg	KOH electrolyte
2440	823	Capacitance	550.0	F/g	at 2 mV s-1 in 0.5 M H2SO4
2441	823	Capacitance	472.0	F/g	at 2 mV s-1 in 0.5 M H2SO4
2442	823	Energy_Density	9.3	Wh/kg	at a specific power density of 2.5 kW/kg
2443	825	Capacitance	214.65	F/g	at 100 mA/g
2444	825	Energy_Density	10.73	Wh/kg	
2445	825	Cycling_Stability	93.1	%	after 10,000 cycles
2446	825	Na_Adsorption_Energy	2.18	eV	
2447	825	Na_Adsorption_Energy	0.95	eV	for pristine MXene
2448	825	Interlayer_Spacing	9.13	Å	
2449	825	Interlayer_Spacing	10.9	Å	
2450	826	Band_Gap	2.4	eV	
2451	826	Crystallite_Size	3.8	nm	X-ray diffraction analysis
2452	826	Interlayer_Spacing	1.13	nm	Electron microscopy images
2453	827	Capacitance	1435.2	F/g	at a current density of 0.5 F/g
2454	827	Energy_Density	91.4	Wh/kg	maximum energy density
2455	827	Energy_Density	56.6	Wh/kg	at a high power density of 8000 W/kg
2456	827	Capacitance	90.1	%	after 5000 charge-discharge cycles
2457	828	Capacitance	353.77	F/g	Cyclic voltammetry (CV) and galvanostatic charge-discharge (GCD) measurements
2458	828	Resistivity	0.5	ohm cm	Electrochemical impedance spectroscopy (EIS) results
2459	829	Capacitance	304.0	F/g	scan rate of 10 mV/s
2460	829	Capacitance	242.0	F/g	scan rate of 1000 mV/s
2461	829	Capacitance	79.0	%	scan rate of 1000 mV/s
2462	829	Energy_Density	18.4	Wh/kg	power density of 749.9 W/kg
2463	830	Capacitance	916.0	F/g	at 5 mV s
2464	830	Conductivity	0.0	S/m	excellent electronic conductivity
2465	830	Charge_Transfer_Resistance	0.0	Ohm	minimum charge transfer resistance
2466	831	Capacitance	1713.0	F/g	at 1 A/g
2467	831	Capacitance	82.3	%	at 10 A/g
2468	831	Capacitance	80.0	%	after 5000 cycles
2469	831	Energy_Density	49.5	Wh/kg	with power density of 750 W/kg
2470	831	Energy_Density	45.0	Wh/kg	with power density of 700 W/kg
2471	832	Conductivity	353.77	S/m	not explicitly mentioned
2472	833	Capacitance	883.0	F/g	not explicitly mentioned
2473	833	Surface_Area	317.42	m2/g	not explicitly mentioned
2474	835	Capacitance	1.3	times	typical comparative framework
2475	835	Capacitance	8.0	times	typical comparative framework
2476	836	Capacitance	615.3	μF/cm²	at 1 V s⁻¹
2477	836	Cutoff_Frequency	1.21	kHz	
2478	836	Scan_Rate	2000.0	V/s	ultrahigh scan rate
2479	837	Capacitance	40.0	mF/cm²	narrow potential window (0.6 V)
2480	837	Capacitance	356.0	mF/cm²	wider potential window (1.7 V) at scan rate of 5 mV/s
2481	837	Capacitance	640.0	mF/cm²	wider potential window (1.7 V) at scan rate of 1 mV/s
2482	838	Capacitance	1500.0	F/g	
2483	839	Capacitance	87.0	mF/cm²	at 2 mV/s
2484	839	Energy_Density	11.8	mWh/cm³	
2485	839	Shielding_Effectiveness	44.0	dB	
2486	840	Capacitance	1323.7	F/g	at 1 Ag-1
2487	840	Capacitance	90.5	%	after 2000 cycles
2488	840	Capacitance	258.4	F/g	at 2 Ag-1
2489	840	Energy_Density	60.6	Wh/kg	at 649.2 W/kg
2490	840	Capacitance	91.1	%	over 10,000 cycles
2491	840	Resistivity	4.6	Ω	lower R ct value
2492	841	Capacitance	184.72	F/g	at a fixed current density of 1 A/g within the voltage range of 0.00 - 1.44 V
2493	841	Capacitance	65.1	F/g	at a fixed current density of 1 A/g within the voltage range of 0.00 - 1.44 V
2494	841	Capacitance	36.61	F/g	at a fixed current density of 1 A/g within the voltage range of 0.00 - 1.44 V
2495	841	Capacity_Retention	53.1	%	over 10,000 cycles
2496	842	Capacitance	1673.8	F/g	at 1 A/g
2497	842	Cyclic_Stability	98.81	%	over 10,000 cycles
2498	842	Capacitance	88.0		at 60 mV/s
2499	842	Tafel_Slope	51.3	mV/dec	for oxygen evolution reaction (OER)
2500	842	Tafel_Slope	36.9	mV/dec	for hydrogen evolution reaction (HER)
2501	843	Conductivity	0.16	S/cm	at 70 C
2502	843	Capacitance	892.3	F/g	at 5 A/g
2503	843	Contact_Angle	83.4	degrees	with 2 M H3PO4
2504	844	Conductivity	258.4	S/cm	
2505	844	Capacitance	257.6	F/g	at 0.1 A/g in 1M H2SO4
2506	844	Capacitance	143.4	F/g	at 0.1 A/g in 1M Al2(SO4)3
2507	844	Capacitance	134.4	F/g	at 0.1 A/g in 1M KOH
2508	844	Capacitance	65.8	F/g	at 0.1 A/g in 1M Li2SO4
2509	844	Cycling_Stability	95.71	%	after 20,000 cycles in 1M H2SO4
2510	845	Resistivity	38.56	Ohm/sq	5 dips
2511	845	Resistivity	23.17	Ohm/sq	10 dips
2512	845	Shielding_Effectiveness	18.75	dB	5MXC5 specimen, X-band range
2513	845	Shielding_Effectiveness	23.21	dB	10MXC5 specimen, X-band range
2514	845	Burning_Rate	15.25	unitless	5MXC5 specimen
2515	845	Burning_Rate	26.31	unitless	10MXC5 specimen
2516	845	Hardness	133.29	HV	5MXC5 specimen
2517	845	Hardness	145.05	HV	10MXC5 specimen
2518	845	Flexural_Strength	23.88	unitless	10MXC5 specimen
2519	845	Ilss	24.37	unitless	10MXC5 specimen
2520	846	Capacitance	2.26	F/cm²	In Na2SO4 electrolyte
2521	846	Capacitance	1.24	F/cm²	At 3 mA/cm² in an asymmetric cell
2522	846	Energy_Density	0.44	mWh/cm²	In an asymmetric device operating at 1.6 V
2523	847	Capacitance	361.0	C/g	1 M KOH electrolyte, voltage 0.0 to 0.5 volts, scan rate 10 mV/s
2524	847	Capacitance	367.0	C/g	1 M KOH electrolyte, voltage 0.0 to 0.5 volts, scan rate 10 mV/s
2525	848	Capacitance	552.6	F/g	at 1 A/g
2526	848	Energy_Density	1056.0	mAh/g	at 50 mA/g
2527	849	Capacitance	2675.0	F/g	current density of 1 A/g
2528	849	Capacitance	1070.0	C/g	current density of 1 A/g
2529	849	Capacitance	256.0	F/g	power density of 763 W/kg, voltage window of 1.7 V
2530	849	Energy_Density	61.0	Wh/kg	power density of 763 W/kg, voltage window of 1.7 V
2531	850	Conductivity	42.3	dB	at 12.3 GHz
2532	850	Effective_Absorption_Bandwidth	5.6	GHz	at 12.3 GHz
2533	851	Capacitance	601.0	F/cm³	
2534	851	Energy_Density	83.5	Wh/L	at a power density of 1800 W/L
2535	852	Conductivity	8000.0	S/cm	
2536	852	Capacitance	347.0	F/g	5 mV/s
2537	852	Capacitance	1353.0	F/cm³	5 mV/s
2538	853	Conductivity	353.77	S/m	not explicitly mentioned
2539	853	Young_Modulus	0.3	GPa	not explicitly mentioned
2540	854	Resistivity	1878.05	kPa-1	
2541	854	Resistivity	0.67	(RH)-1	
2542	855	Energy_Density	38.0	Wh/kg	with hierarchical pore structure and functional groups
2543	855	Power_Density	1280.0	W/kg	with hierarchical pore structure and functional groups
2544	855	Capacitance	1632.0	C/g	with PVDF binder-based electrode
2545	855	Capacity_Retention	84.0	%	after 10,000 galvanostatic charge-discharge cycles
2546	855	Overpotential	158.0	mV	in HER
2547	856	Capacitance	1270.0	F/g	cyclic voltammetry (CV) at a scan rate of 10.0 mV/s
2548	856	Capacitance	1150.0	F/g	cyclic voltammetry (CV) at a scan rate of 10.0 mV/s
2549	856	Capacitance	1428.0	F/g	galvanostatic charge-discharge (GCD) at 10.0 A/g current density
2550	856	Capacitance	1314.0	F/g	galvanostatic charge-discharge (GCD) at 10.0 A/g current density
2551	856	Capacitance	1390.0	F/g	galvanostatic charge-discharge (GCD) at 2.0 A/g current density
2552	856	Capacitance	1284.0	F/g	galvanostatic charge-discharge (GCD) at 2.0 A/g current density
2553	856	Capacitance	1182.0	F/g	galvanostatic charge-discharge (GCD) at 1.0 A/g current density
2554	856	Capacitance	1060.0	F/g	galvanostatic charge-discharge (GCD) at 3.0 A/g current density
2555	856	Capacitance	92.82	%	after 10000 cycles at 1.0 A/g current density
2556	856	Capacitance	88.25	%	after 10000 cycles at 1.0 A/g current density
2557	857	Capacitance	1960.0	F/g	1 A/g
2558	857	Capacitance	87.3	%	118 A/g
2559	857	Capacitance	90.2	%	5 A/g, 8000 cycles
2560	858	Capacitance	235.0	F/g	in AlCl3 electrolyte
2561	858	Capacitance	561.0	F/cm3	in AlCl3 electrolyte
2562	858	Potential_Window	1.2	V	using 3 M AlCl3 electrolyte
2563	859	Capacitance	708.7	F/g	at 1 A/g
2564	859	Capacitance	87.5	%	at 20 A/g
2565	859	Capacitance	85.5	%	after 10000 cycles
2566	860	Capacitance	220.7	F/g	1 A/g
2567	860	Capacitance	80.0	%	5000 cycles at 6 A/g
2568	860	Energy_Density	1.4	V	All-solid-state symmetrical supercapacitor with PVA-KOH electrolyte
2569	861	Capacitance	39.5	mF/cm²	scan rate of 2 mV/s
2570	861	Capacitance	928.4	F/g	
2571	861	Capacitance	442.6	F/g	current density of 0.5 A/g
2572	861	Capacitance	13.4	F/g	current density of 10 A/g
2573	862	Conductivity	353.77	S/m	not explicitly mentioned
2574	863	Capacitance	706.5	F/g	1 A/g current density
2575	863	Capacitance	93.7	F/g	1 A/g current density
2576	863	Energy_Density	42.2	Wh/kg	1 A/g current density
2577	863	Power_Density	1801.5	W/kg	1 A/g current density
2578	863	Cyclic_Life	96.0	%	after 10,000 cycles
2579	864	Capacitance	1548.7	F/g	1 A/g in 1 M ZnSO4 and 0.1 M MnSO4 electrolyte
2580	864	Capacitance	387.1	mA h/g	1 A/g in 1 M ZnSO4 and 0.1 M MnSO4 electrolyte
2581	864	Capacity_Retention	77.82	%	15,000 cycles at 5 A/g
2582	864	Energy_Density	62.8	Wh/kg	at 1.8 V
2583	864	Power_Density	10.1	kW/kg	at 1.8 V
2584	864	Capacitance	95.6	%	25,000 cycles at 1 A/g
2585	865	Conductivity	628.7	mAh/g	electrochemical hydrogen storage performance
2586	866	Capacitance	420.99	F/g	0.5 A/g
2587	866	Capacitance	84.56	%	10 A/g
2588	866	Capacitance	214.0	mF/cm²	0.3 mA/cm²
2589	866	Energy_Density	14.5	μWh/cm²	30.2 μW/cm²
2590	866	Capacitance	87.2	%	10,000 cycles
2591	867	Capacitance	384.0	F/g	at 1 A/g in a three-electrode configuration
2592	867	Energy_Density	71.1	Wh/kg	at a power density of 800 W/kg
2593	867	Cycling_Stability	76.2	%	after 8,000 charge discharge cycles
2594	868	Young_Modulus	1965.3	MPa	
2595	868	Young_Modulus	255.7	MPa	
2596	868	Fracture_Stress	36.1	MPa	
2597	868	Fracture_Stress	9.2	MPa	
2598	868	Water_Vapor_Permeability	91.0	%	
2599	868	Oxygen_Permeability	79.0	%	
2600	869	Capacitance	450.0	C/g	1 M H2SO4 electrolyte
2601	869	Capacitance	75.0	C/g	1 M H2SO4 electrolyte
2602	869	Capacitance	114.0	%	after 8000 cycles
2603	870	Capacitance	271.35	F/g	at 1 A/g
2604	870	Capacitance	197.92	F/g	at 10 A/g
2605	870	Capacitance	80.7	%	after 10000 cycling
2606	870	Capacitance	62.98	F/g	at 0.1 A/g
2607	870	Capacitance	98.6	%	after 100 times bending
2608	872	Capacitance	481.0	F/g	at 1 A/g
2609	872	Capacitance	478.0	F/g	at 1 A/g
2610	872	Capacitance	95.5	%	after 5,000 cycles at 10 A/g
2611	872	Capacitance	96.3	%	after 5,000 cycles at 10 A/g
2612	872	Energy_Density	53.0	Wh/kg	at 2.25 kW/kg
2613	872	Capacitance	97.7	%	after 5,000 cycles
2614	873	Capacitance	1.6	F/cm²	at 5 mA/cm²
2615	873	Energy_Density	262.0	μWh/cm²	
2616	873	Power_Density	2.7	mW/cm²	
2617	873	Capacitance	92.4	%	after 1000 cycles
2618	873	Capacitance	90.0	%	over 200 compression-recovery cycles
2619	874	Capacitance	922.6	F/g	at 10,000 cycles
2620	874	Energy_Density	94.1	Wh/kg	at a power density of 802.4 W/kg
2621	874	Power_Density	7431.8	W/kg	for the symmetric supercapacitor
2622	875	Capacitance	1160.5	F/g	current density of 1 A/g
2623	875	Capacitance	736.0	F/g	current density of 20 A/g
2624	875	Capacitance	320.0	F/g	current density of 20 A/g on bare Ni-MOF
2625	875	Energy_Density	48.2	Wh/kg	power density of 750 W/kg
2626	875	Energy_Density	23.3	Wh/kg	power density of 15000 W/kg
2627	876	Conductivity	520.0	mA/cm²	at 1.8 V
2628	877	Capacitance	105.0	F/g	1 A/g in 6 M KOH
2629	877	Energy_Density	12.81	Wh/kg	1 A/g
2630	877	Power_Density	985.8	W/kg	1 A/g
2631	877	Capacitance	73.0	%	after 10,000 charge-discharge cycles
2632	878	Capacitance	140.0	F/g	at 0.5 A/g
2633	878	Capacitance	73.0	F/g	at 0.5 A/g (pristine MXene)
2634	878	Cycling_Stability	97.2	%	after 12,000 cycles at 3 A/g
2635	878	Energy_Density	6.33	Wh/kg	
2636	878	Power_Density	600.0	W/kg	
2637	879	Energy_Density	70.11	Wh/kg	asymmetric supercapacitor (ASC) device with NiCo2O4 MXene LDH AC configuration
2638	879	Power_Density	850.22	W/kg	asymmetric supercapacitor (ASC) device with NiCo2O4 MXene LDH AC configuration
2639	879	Capacitance	5066.0	F/g	at 1 A/g
2640	879	Capacitance	97.82	%	after 10,000 charge cycles at 10 A/g
2641	879	Bandgap	2.58	eV	NiCo2O4 MXene LDH composite
2642	879	Bandgap	4.0	eV	pristine NiCo2O4
2643	880	Capacitance	485.0	mF/cm²	at a current density of 0.5 mA cm²
2644	881	Conductivity	353.77	S/m	not explicitly mentioned
2645	884	Capacitance	240.1	F/g	0.1 A/g in 6 M KOH
2646	884	Capacitance	97.9	F/g	0.25 A/g
2647	884	Energy_Density	95.9	Wh/kg	630.4 W/kg
2648	885	Capacitance	1018.0	mAh/g	specific current of 2 A/g
2649	885	Cycling_Stability	1000.0	cycles	stable performance over 1000 cycles
2650	887	Capacitance	19.7	mWh g-1	aqueous electrolytes (H2SO4, LiCl, KOH)
2651	887	Self_Discharge_Rate	15.53	voltage drop after 5000 s	not specified
2652	888	Capacitance	219.2	F/g	after 6 weeks
2653	888	Capacitance	280.3	F/g	after 6 weeks
2654	889	Capacitance	383.0	F/g	cyclic voltammetry, galvanostatic charge discharge, electrochemical impedance spectroscopy
2655	889	Capacitance	138.75	mF/cm²	symmetric supercapacitor device
2656	889	Energy_Density	12.33	mWh/cm²	symmetric supercapacitor device
2657	889	Power_Density	2212.0	mW/cm²	symmetric supercapacitor device
2658	889	Capacitance	86.14	%	after 3000 cycles
2659	889	Capacitance	78.7	%	after 5000 cycles
2660	890	Capacitance	782.7	F/g	5 mV/s
2661	890	Capacitance	1216.36	F/g	5 mV/s
2662	890	Capacitance	136.13	F/g	5 mV/s
2663	890	Energy_Density	150.6	Wh/kg	
2664	890	Power_Density	1350.0	W/kg	
2665	890	Overpotential	446.1	mV	10 mA/cm²
2666	890	Tafel_Slope	88.31	mV/dec	1 M KOH
2667	891	Capacitance	197.0	F/g	acidic conditions
2668	891	Capacitance	284.0	F/g	acidic conditions
2669	891	Capacitance	86.0	F/g	alkaline conditions
2670	891	Capacitance	142.0	F/g	alkaline conditions
2671	892	Capacitance	1872.0	F/g	at 2 mV s-1
2672	892	Capacitance	1121.6	F/g	at 20 A g-1
2673	892	Capacitance	1533.0	F/g	at 0.5 A g-1
2674	892	Energy_Density	241.9	Wh/kg	at a power density of 1125 W kg-1
2675	893	Capacitance	234.8	F/g	at 1 A/g in a neutral electrolyte (0.5 M Na2SO4)
2676	893	Capacitance	21.3	F/g	at 1 A/g with 75% capacitance retention after 10000 cycles
2677	893	Energy_Density	9.6	Wh/kg	at a power density of 902.3 W/kg
2678	894	Strain	4.0	%	biaxial strains from 4 to 4
2679	894	Bonding_Distortion	0.05	Å	under different strains
2680	895	Capacitance	1393.0	F/g	at 1 A/g
2681	895	Coulombic_Efficiency	99.0	%	after 10,000 cycles at 5 A/g
2682	895	Capacitance	80.0	%	at 20 A/g
2683	895	Energy_Density	52.0	Wh/kg	in a symmetric supercapacitor (SSC)
2684	895	Power_Density	799.0	W/kg	in a symmetric supercapacitor (SSC)
2685	896	Capacitance	703.25	C/g	current density of 1 A/g
2686	896	Energy_Density	49.7	Wh/kg	current density of 1 A/g
2687	896	Power_Density	800.0	W/kg	current density of 1 A/g
2688	896	Energy_Density	20.0	Wh/kg	current density of 10 A/g
2689	896	Power_Density	8000.0	W/kg	current density of 10 A/g
2690	897	Capacitance	33.3	mF/cm²	scan rate of 10 mV/s
2691	897	Strain	30.0	%	can be stretched up to 30%
2692	897	Capacitance	2.4	%	over 500 stretching cycles
2693	897	Capacitance	90.0	%	after 3000 stretching cycles to a maximum strain of 30%
2694	898	Conductivity	602.9	mAh/g	After 800 cycles
2695	898	Coulombic_Efficiency	96.7	%	After 800 cycles
2696	898	Discharge_Capacity	1002.8	mAh/g	After 160 cycles at 1 C
2697	898	Discharge_Capacity	848.9	mAh/g	After 160 cycles
2698	898	Discharge_Capacity	651.3	mAh/g	After 160 cycles
2699	899	Capacitance	957.36	F/g	at 1 A/g
2700	899	Capacitance	361.1	F/g	in asymmetric supercapacitor (ASC)
2701	899	Energy_Density	36.11	W/kg	in asymmetric supercapacitor (ASC)
2702	899	Overpotential	89.7	mV	for hydrogen evolution reaction (HER)
2703	899	Overpotential	171.0	mV	for oxygen evolution reaction (OER)
2704	899	Tafel_Slope	39.3	mV/dec	for oxygen evolution reaction (OER)
2705	899	Tafel_Slope	54.0	mV/dec	for hydrogen evolution reaction (HER)
2706	900	Capacitance	396.0	F/g	current density of 1 A/g
2707	900	Resistivity	0.0	ohm-cm	low charge transfer resistance in a two-electrode symmetric capacitor
2708	901	Capacitance	155.0	Ah/kg	aqueous sodium electrolyte
2709	901	Energy_Density	57.0	Wh/kg	high current conditions
2710	901	Power_Density	2110.0	W/kg	high current conditions
2711	902	Capacitance	81.0	F/g	scan rate of 100 mV/s
2712	902	Capacitance	62.0	F/g	scan rate of 100 mV/s
2713	902	Specific_Surface_Area	11.0	m2/g	
2714	902	Specific_Surface_Area	40.0	m2/g	
2715	903	Young_Modulus	340.0	MPa	for films (cellulose nanofibers MXene films)
2716	903	Young_Modulus	74.0	MPa	for fibers (cellulose nanocrystals MXene fibers)
2717	903	Capacitance	522.0	mF/cm²	at 5 mA/cm²
2718	903	Energy_Density	94.7	μWh/cm²	at power density of 573 μW/cm²
2719	911	Capacitance	1613.0	mF/cm²	PVA H2SO4 electrolyte
2720	911	Capacitance	1180.0	mF/cm²	PVA Zn(CF3SO3)2 gel electrolyte
2721	911	Energy_Density	104.9	μWh/cm²	
2722	912	Energy_Density	51.1	Wh/kg	at a power density of 2000 W/kg
2723	912	Energy_Density	29.7	Wh/kg	for Ti3C2Tx electrode
2724	913	Capacitance	599.2	mF/cm²	2 mA/cm²
2725	913	Capacitance	249.16	mF/cm²	2 mA/cm²
2726	913	Capacitance	498.5	mF/cm²	2 mA/cm²
2727	913	Energy_Density	31.1	Wh/kg	asymmetric supercapacitor (ASC) device
2728	913	Power_Density	1041.7	W/kg	asymmetric supercapacitor (ASC) device
2729	913	Capacitance	83.7	%	after 5000 continuous charging discharging cycles
2730	914	Capacitance	718.67	F/g	1 M H2SO4, 3.5 A/g
2731	914	Capacitance	260.23	F/g	0.5 A/g, P1M2-P1M2 SSC
2732	914	Capacitance	176.46	F/g	0.1 A/g, P1M2-rGO ASC
2733	914	Energy_Density	35.29	Wh/kg	P1M2-rGO ASC
2734	914	Power_Density	1200.0	W/kg	P1M2-rGO ASC
2735	914	Energy_Density	26.22	Wh/kg	P1M2-rGO ASC
2736	915	Capacitance	2.73	mAh/cm²	at a current density of 20 mA/cm²
2737	915	Energy_Density	0.97	mWh/cm²	at a power density of 34.20 mW/cm²
2738	915	Capacitance	1.99	mAh/cm²	at a current density of 3 mA/cm²
2739	915	Capacitance	86.19	%	after 10,000 cycles
2740	915	Capacitance	86.17	%	after 10,000 cycles
2741	916	Capacitance	293.3	F/g	current density of 1 A/g
2742	916	Energy_Density	5.8	Wh/kg	power density of 1000 W/kg
2743	916	Capacity_Retention	91.0	%	after 8000 cycles
2744	917	Capacitance	570.0	F/g	1 A/g
2745	917	Energy_Density	156.9	Wh/kg	power density of 3,240 W/kg
2746	917	Capacitance	96.2	%	after 10,000 cycles
2747	917	Cycling_Stability	96.3	%	
2748	919	Capacitance	652.1	F/g	0.75 A/g
2749	919	Energy_Density	326.9	Wh/kg	2850 W/kg
2750	919	Energy_Density	183.7	Wh/kg	7600 W/kg
2751	919	Capacitance	91.0	%	6000 cycles
2752	920	Resistivity	131.0	mV	10 mA cm2
2753	921	Conductivity	20.52	S/cm	10^3 S cm^-1
2754	921	Fracture_Stress	1.6	MPa	tensile strength
2755	921	Electrochemical_Stability_Window	2.4	V	
2756	921	Thermal_Stability	400.0	C	>400 C
2757	922	Capacitance	854.2	F/g	at 1 A/g
2758	922	Energy_Density	54.0	Wh/kg	at a power density of 800 W/kg
2759	922	Capacitance	85.4	%	after 14,000 cycles at 3 A/g
2760	923	Capacitance	454.4	C/g	at 5 mV/s scan rate
2761	923	Capacitance	477.87	C/g	at 1 A/g current density
2762	923	Energy_Density	47.5	Wh/kg	with 89 retention over 12000 cycles
2763	923	Power_Density	500.0	W/kg	at 1 A/g current density
2764	924	Capacitance	467.7	F/g	scan rate of 5 mV/s in 3-electrode system
2765	924	Energy_Density	5.0	Wh/kg	at 0.1 mA/cm²
2766	924	Power_Density	1000.0	W/kg	at 1.0 mA/cm²
2767	924	Cycling_Stability	82.03	%	after 10,000 cycles
2768	925	Capacitance	483.1	F/g	at 1 A/g
2769	925	Capacitance	128.2	F/g	at 1 A/g
2770	925	Energy_Density	23.6	W h/kg	at 575 W/kg
2771	925	Rate_Capability	79.8	%	from 1 to 20 A/g
2772	925	Cycling_Durability	80.0	%	after 6000 cycles
2773	925	Cycling_Durability	89.4	%	after 9000 cycles
2774	926	Capacitance	127.0	F/g	at 1 mA cm2
2775	926	Energy_Density	6.2	Wh/kg	not explicitly mentioned
2776	926	Power_Density	54.0	W/kg	not explicitly mentioned
2777	926	Cyclic_Stability	91.0	%	after 2500 cycles
2778	927	Conductivity	353.77	S/m	not specified
2779	928	Capacitance	353.77	F/g	specific capacitance and pseudocapacitive behavior
2780	929	Capacitance	272.5	F/g	at 1 A/g
2781	929	Capacitance	71.4	%	after 4000 cycles at 2 A/g
2782	929	Energy_Density	31.18	Wh/kg	at a power density of 1079.3 W/kg
2783	930	Capacitance	353.8	F/g	at 1 A/g
2784	930	Energy_Density	28.3	W h/kg	at a power density of 1193 W/kg
2785	931	Conductivity	353.77	S/m	not explicitly mentioned
2786	931	Capacitance	353.77	F/g	not explicitly mentioned
2787	933	Capacitance	417.6	F/g	at 1 A/g
2788	933	Capacitance	225.7	F/g	at 10 A/g
2789	933	Capacitance	175.6	F/g	at 0.5 A/g
2790	933	Energy_Density	6.1	Wh/kg	not specified
2791	933	Capacitance	98.5	%	after 2000 cycling
2792	934	Conductivity	353.77	S/m	not specified
2793	942	Capacitance	598.0	F/g	1 A/g in 1 M KOH
2794	942	Capacitance	92.4	%	after 10,000 cycles at 3 A/g
2795	942	Surface_Area	198.0	m2/g	not explicitly mentioned
2796	943	Capacitance	1049.0	F/g	current density of 1 A/g
2797	943	Capacitance	105.37	F/g	current density of 1 A/g
2798	943	Capacitance	410.53	F/g	current density of 1 A/g
2799	943	Capacitance	771.03	F/g	current density of 1 A/g
2800	943	Capacitance	79.0	F/g	current density of 3 A/g
2801	943	Capacitance	61.0	F/g	current density of 5 A/g
2802	943	Capacitance	114.0	F/g	current density of 1 A/g
2803	943	Resistivity	2.2	Ω	charge transfer resistance
2804	943	Resistivity	4.48	Ω	charge transfer resistance
2805	943	Power_Density	7020.0	W/kg	low energy density
2806	943	Energy_Density	11.7	Wh/kg	low energy density
2807	944	Capacitance	167.28	F/g	symmetric assembly
2808	944	Capacitance	54.57	F/g	at 2 A/g
2809	944	Energy_Density	14.86	Wh/kg	CF-NCS TCX device
2810	944	Energy_Density	14.86	mWh/cm²	CF-NCS TCX device
2811	945	Absorbance	99.5	%	across 280-1623 nm
2812	945	Relative_Bandwidth	141.1	%	
2813	946	Capacitance	259.0	C/g	current density of 0.5 A/g
2814	946	Capacitance	184.0	C/g	current density of 0.5 A/g
2815	946	Cycle_Life	5000.0	cycles	retained 96.6% of capacitance
2816	946	Energy_Density	12.92	Wh/kg	maximum energy density
2817	946	Power_Density	1001.02	W/kg	maximum power density
2818	946	Capacitance	80.0	%	retained capacity after 5000 cycles at 8 A/g
2819	947	Capacitance	182.75	F/g	After 10,000 cycles
2820	947	Capacitance	85.65	%	After 10,000 cycles
2821	948	Capacitance	141.77	mg/g	at 1.2 V for 60 min
2822	948	Capacitance	2.36	mg/g/min	at 1.2 V
2823	948	Capacitance	94.6	%	after 215 salt adsorption desorption cycles
2824	949	Capacitance	372.0	F/g	at 1 A/g
2825	949	Capacitance	95.0	%	after 5000 cycles
2826	950	Energy_Density	15.4	Wh/kg	at power density of 351.6 W/kg
2827	950	Capacitance	72.0	mAh/g	at current density of 1 A/g
2828	950	Power_Density	351.6	W/kg	with energy density of 15.4 Wh/kg
2829	951	Capacitance	1133.0	F/g	current density 1 A/g
2830	951	Capacitance	91.0	%	after 10,000 GCD cycles
2831	951	Photothermal_Conversion_Efficiency	59.0	%	
2832	952	Capacitance	60.41	F/g	unannealed
2833	952	Capacitance	88.0	F/g	annealed at 850 C
2834	952	Cycling_Stability	100.0	%	after 15,000 charge discharge cycles
2835	953	Capacitance	2020.5	F/g	at a current density of 1 A/g
2836	953	Capacitance	278.3	F/g	asymmetric supercapacitor
2837	953	Energy_Density	87.0	Wh/kg	at a power density of 750 W/kg
2838	953	Conductivity	2.83	S/m	SL-doped PEDOT SL PAM KOH gel electrolyte
2839	953	Elongation_At_Break	995.0	%	mechanical flexibility of SL-doped PEDOT SL PAM KOH gel electrolyte
2840	954	Capacitance	253.86	F/g	at 1 A/g
2841	954	Energy_Density	141.03	Wh/kg	at 999.99 W/kg
2842	954	Capacitance	87.96	%	after 5000 charge-discharge cycles at 10 A/g
2843	955	Capacitance	1125.0	F/g	at a current density of 1 A/g
2844	955	Energy_Density	100.0	Wh/kg	
2845	955	Power_Density	400.0	W/kg	
2846	955	Cyclic_Stability	87.0	%	after 10,000 cycles
2847	956	Conductivity	353.77	S/m	not explicitly mentioned
2848	956	Capacitance	353.77	F/g	not explicitly mentioned
2849	957	Capacitance	211.57	F/g	at a scanning rate of 2 mV s−1
2850	957	Capacitance	95.0	%	after 3000 cycles at a current density of 5 A g−1
2851	958	Capacitance	320.0	F/g	2 mV s
2852	958	Capacitance	97.0	%	50 000 cycles at 50 A/g
2853	959	Capacitance	254.28	F/g	at 1 A/g
2854	959	Retention_Ratio	74.0	%	after 10,000 cycles
2855	960	Capacitance	395.0	F/g	scan rate of 5 mV/s
2856	960	Capacitance	85.9	%	after 10,000 cycles at a current density of 5 A/g
2857	960	Energy_Density	25.0	Wh/kg	at a power density of 1000 W/kg
2858	960	Capacitance	98.8	%	after 10,000 cycles at a current density of 5 A/g
2859	960	Energy_Density	510.3	mWh/cm³	at a power density of 40,483 mW/cm³
2860	960	Overpotential	439.7	mV	to drive a current density of 10 mA/cm² for HER
2861	960	Overpotential	381.2	mV	to drive a current density of 10 mA/cm² for OER
2862	961	Capacitance	380.0	F/g	at 1 A/g
2863	961	Capacitance	570.0	F/g	at 1 A/g
2864	961	Capacitance	167.0	F/g	at 1 A/g
2865	961	Energy_Density	59.38	Wh/kg	
2866	961	Power_Density	2055.46	W/kg	
2867	961	Capacitance	98.0	%	after 1000 cycles
2868	961	Capacitance	93.0	%	after 5000 cycles
2869	961	Coulombic_Efficiency	98.0	%	after 5000 cycles
2870	962	Capacitance	306.0	C/g	for O-Ti3C2Tx-0.05 film electrode
2871	962	Capacitance	216.8	C/g	for pristine Ti3C2Tx electrode
2872	963	Conductivity	353.77	S/m	not explicitly mentioned
2873	964	Capacitance	2497.8	mF/cm²	scan rate of 2 mV/s
2874	964	Energy_Density	222.02	μW h/cm²	
2875	964	Capacitance	84.0	%	over 7000 cycles
2876	965	Conductivity	353.77	S/m	not explicitly mentioned
2877	966	Capacitance	1090.6	F/g	at 1 A/g
2878	966	Energy_Density	49.8	Wh/kg	at 800 W/kg
2879	966	Cycle_Life	20000.0	cycles	at 1 A/g
2880	966	Retention	87.85	%	after 20,000 cycles at 1 A/g
2881	967	Conductivity	353.77	S/m	not explicitly mentioned
2882	968	Capacitance	2.0		Comparing a binary composite electrode to a ternary composite electrode
2883	968	Energy_Density	1.0		A ternary composite of transition metal sulfide and oxide with MXene shows improved energy density than metal-oxide MXene binary composites and pure MXenes
2884	973	Capacitance	90.0	F/g	scan rate of 300 mV/s
2885	973	Capacitance	120.0	F/g	scan rate of 2 mV/s
2886	973	Cycling_Stability	98.0	%	after 10 K charge-discharge cycles
2887	974	Capacitance	683.5	F/g	1 A/g in 2 M H2SO4 electrolyte
2888	974	Cycling_Performance	85.0	%	after 10,000 cycles
2889	974	Capacitance	102.8	F/g	MXene-Ti3C2Tx, 1 A/g in 2 M H2SO4 electrolyte
2890	974	Capacitance	378.2	F/g	CuO SnO2, 1 A/g in 2 M H2SO4 electrolyte
2891	974	Cycling_Performance	60.0	%	MXene-Ti3C2Tx, after 10,000 cycles
2892	974	Cycling_Performance	76.0	%	CuO SnO2, after 10,000 cycles
2893	975	Capacitance	634.0	F/g	at 1 A/g
2894	975	Capacitance	380.4	C/g	at 1 A/g
2895	975	Capacitance	21.1	F/g	at 0.5 A/g
2896	975	Capacitance	83.0	%	after 4000 cycles at 1 A/g
2897	975	Energy_Density	47.25	μWh/cm²	at a power density of 2.40 mW/cm²
2898	976	Conductivity	353.77	S/m	not explicitly mentioned
2899	976	Capacitance	353.77	F/g	not explicitly mentioned
2900	976	Energy_Density	353.77	Wh/kg	not explicitly mentioned
2901	977	Capacitance	1546.76	F/g	at 1 A/g
2902	977	Energy_Density	53.3	Wh/kg	at 800 W/kg
2903	977	Capacitance	150.0	F/g	at 1 A/g
2904	977	Capacitance	1311.11	F/g	at 1 A/g
2905	978	Capacitance	131.46	mF/cm²	not explicitly mentioned
2906	978	Voltage_Window	1.2	V	not explicitly mentioned
2907	979	Capacitance	1345.3	F/g	at 1 A/g
2908	979	Energy_Density	77.4	Wh/kg	at 1125 W/kg
2909	979	Cyclability	85.13	%	after 6000 cycles
2910	980	Resistivity	0.62	Ohm square-1	After 5 spray-coating cycles
2911	980	Conductivity	1.33	W/m/K	For EMI shielding heat release
2912	980	Capacitance	139.6	mF/cm²	At a current density of 1 mA/cm²
2913	980	Capacitance	79.3	%	After 1000 charge-discharge cycles
2914	981	Capacitance	254.0	F/g	at 0.5 A/g
2915	981	Capacitance	70.1	F/g	after 5000 cycles
2916	981	Energy_Density	14.1	Wh/kg	
2917	981	Power_Density	13.9	kW/kg	
2918	982	Capacitance	597.8	F/g	As a supercapacitor electrode
2919	982	Capacitance	384.0	F/g	Raw Ti3C2Tx MXene
2920	982	Energy_Density	12.5	Wh/kg	At a power density of 250 W/kg
2921	983	Capacitance	750.0	F/g	three-electrode system
2922	983	Energy_Density	52.08	Wh/kg	power density of 750 W/kg
2923	983	Retention	93.0	%	after 10000 cycles
2924	984	Capacitance	610.77	mF/cm²	at a high scan rate of 1000 mV s⁻¹
2925	984	Capacitance	78.57	%	at a high scan rate of 1000 mV s⁻¹
2926	984	Energy_Density	120.74	μWh/cm²	at a power density of 800 μW/cm²
2927	984	Energy_Density	90.21	μWh/cm²	at a power density of 79,992 μW/cm²
2928	984	Capacitance	93.37	%	after 10,000 cycles
2929	985	Capacitance	45.5	F/g	not explicitly mentioned
2930	985	Lifespan	24.8	%	not explicitly mentioned
2931	986	Capacitance	542.1	F/g	at a current density of 0.5 A/g
2932	986	Capacitance	305.0	F/g	pristine Ti3C2Tx
2933	986	Cycling_Stability	96.6	%	after 5000 cycles
2934	986	Capacitance	542.0	F/g	at a current density of 0.5 A/g
2935	987	Capacitance	2169.9	F/g	at 0.5 A/g
2936	987	Resistivity	0.13	Ω	charge transfer resistance
2937	987	Energy_Density	19.2	Wh/kg	asymmetric supercapacitor device (ASC)
2938	987	Power_Density	7500.0	W/kg	asymmetric supercapacitor device (ASC)
2939	987	Capacitance	61.6	F/g	at 0.5 A/g
2940	988	Capacitance	579.0	F/g	1 A/g
2941	988	Capacitance	81.7	%	after 10,000 cycles
2942	988	Energy_Density	31.0	Wh/kg	at 746 W/kg
2943	988	Capacitance	89.2	%	after 10,000 cycles
2944	989	Capacitance	1567.5	F/g	at 1 A/g
2945	989	Capacitance	477.2	F/g	at 1 A/g
2946	989	Capacitance	91.2	%	after 10,000 cycles
2947	989	Capacitance	95.6	%	after 10,000 GCD cycles
2948	989	Capacitance	92.8	%	after 10,000 cycles
2949	989	Energy_Density	61.3	Wh/kg	at a power density of 796.8 W/kg
2950	990	Capacitance	800.0	F/g	after 1800 cycles
2951	990	Capacitance	60.0	F/g	
2952	990	Capacitance	47.0	F/g	
2953	991	Capacitance	669.0	F/g	alkaline electrolyte
2954	991	Retention	90.0	%	over six thousand cycles
2955	992	Capacitance	394.1	F/g	Scan rate of 2 mV s-1
2956	992	Capacitance	358.29	F/g	At 1 A g-1
2957	993	Conductivity	353.77	S/m	under ideal acid and lithium-ion concentrations
2958	994	Capacitance	31.11	mAh/g	at 1 A/g in 1 M KOH electrolyte
2959	994	Energy_Density	8.2	Wh/L	at a power density of 303.4 W/L
2960	995	Capacitance	740.0	F/g	scan rate of 2 mV/s
2961	995	Capacitance	895.0	F/g	charge-discharge current density of 0.5 A/g
2962	996	Capacitance	353.77	F/g	1 M (NH4)2SO4 aqueous electrolyte
2963	996	Conductivity	353.77	S/m	Density functional theory (DFT) calculations
2964	997	Conductivity	353.77	S/m	not explicitly mentioned
2965	997	Capacitance	353.77	F/g	not explicitly mentioned
2966	1001	Capacitance	380.0	mF/cm²	specific capacitance
2967	1001	Energy_Density	68.4	μWh/cm²	at 540 μW/cm²
2968	1002	Conductivity	5.97	V	Maximum Voc
2969	1002	Current	58.5	nA	Maximum Isc
2970	1002	Resistance	14.8	MΩ	Optimal resistance value matching
2971	1002	Power_Density	97.9	nW	Peak power output
2972	1004	Capacitance	476.9	F/g	Not specified
2973	1004	Capacitance	745.4	F/cm³	Not specified
2974	1004	Capacitance	344.4	F/g	Not specified
2975	1004	Capacitance	438.5	F/cm³	Not specified
2976	1004	Capacitance	103.0	F/g	5 mV/s
2977	1004	Energy_Density	15.8	Wh/kg	250 W/kg
2978	1004	Energy_Density	6.1	Wh/kg	10000 W/kg
2979	1005	Capacitance	319.1	F/g	0.5 A/g
2980	1005	Cycling_Stability	70.4	%	5000 cycles, 3 A/g
2981	1005	Capacitance	92.1	F/g	1 A/g
2982	1005	Capacitance	72.1	%	8000 charge discharge cycles, 2 A/g
2983	1005	Energy_Density	18.43	Wh/kg	603.2 W/kg
2984	1005	Capacitance	66.67	F/g	0.5 A/g
2985	1005	Capacitance	83.9	%	8000 charge discharge cycles, 2 A/g
2986	1005	Energy_Density	20.83	Wh/kg	374.94 W/kg
2987	1006	Capacitance	815.0	F/g	three-electrode setup
2988	1006	Capacitance	227.0	F/g	ionic electrolyte
2989	1006	Energy_Density	102.0	Wh/kg	ionic electrolyte
2990	1006	Energy_Density	1.887	mW h/cm3	ionic electrolyte
2991	1007	Capacitance	424.0	F/g	at a scan rate of 2 mV s-1
2992	1007	Capacitance	365.0	F/g	at a scan rate of 100 mV s-1
2993	1007	Energy_Density	18.61	Wh/kg	at a power density of 500 W kg-1
2994	1008	Conductivity	353.77	S/m	DFT calculations
2995	1008	Lithium_Ion_Diffusion_Coefficient	1.2	cm²/s	in situ EIS test
2996	1008	Specific_Surface_Area	232.0	m²/g	uniformly distributed N,P elemental functional groups
2997	1009	Capacitance	48.0	mAh/g	current density of 1 A/g
2998	1009	Energy_Density	19.0	Wh/kg	asymmetric supercapacitor device
2999	1010	Fracture_Stress	123.42	MPa	not explicitly mentioned
3000	1010	Capacitance	337.0	F/g	1 A/g
3001	1010	Capacitance	129.0	F/g	10 A/g
3002	1010	Capacitance	259.0	F/g	1 A/g
3003	1010	Energy_Density	7.28	Wh/kg	not explicitly mentioned
3004	1011	Capacitance	196.94	mAh/g	at 1 A/g
3005	1011	Capacitance	91.01	%	after 10000 cycles
3006	1011	Energy_Density	50.08	Wh/kg	at 500.81 W/kg
3007	1011	Capacitance	85.98	%	after 10000 cycles
3008	1012	Capacitance	264.0	F/g	at 0.5 A/g
3009	1012	Capacitance	76.9	%	capacitance retention from 0.5 A/g to 10 A/g
3010	1012	Capacitance	93.4	%	after 5000 cycles
3011	1012	Energy_Density	12.8	Wh/kg	at 0.2 kW/kg
3012	1013	Capacitance	1168.0	F/g	1 M H2SO4 electrolyte at 20 C with a current density of 1 A/g
3013	1013	Capacitance	509.0	F/g	Ti3C2Tx electrode
3014	1013	Capacitance	402.0	F/g	g-C3N4 Ti3C2Tx electrode
3015	1013	Capacitance	625.0	F/g	MoO3 Ti3C2Tx electrode
3016	1013	Energy_Density	316.0	Wh/kg	button-type asymmetric SCs at 20 C
3017	1013	Energy_Density	230.0	Wh/kg	low temperature (20 C) asymmetric SC
3018	1013	Power_Density	1250.0	W/kg	button-type asymmetric SCs at 20 C
3019	1013	Capacitance	96.8	%	after 5000 cycles at 10 A/g
3020	1013	Capacitance	81.0	%	after 5000 cycles at 20 C
3021	1013	Coulombic_Efficiency	92.0	%	after 5000 cycles at 20 C
3022	1014	Capacitance	1633.0	F/g	at 1 A/g
3023	1014	Capacitance	1492.0	F/g	at 10 A/g
3024	1014	Cycling_Stability	86.6	%	after 10,000 charge-discharging cycles
3025	1014	Compressive_Strain	60.0	%	reversible compressive strain
3026	1015	Capacitance	200.1	mF/cm²	
3027	1015	Energy_Density	71.6	μWh/cm²	at 400.7 μW/cm²
3028	1015	Stability	5000.0	cycles	
3029	1017	Capacitance	58.0	F/g	at 5 mV s
3030	1017	Capacitance	47.0	F/g	at 0.4 A/g
3031	1017	Capacitance	98.0	F/g	at 5 mV s
3032	1017	Capacitance	71.0	F/g	at 0.4 A/g
3033	1017	Capacitance	322.0	F/g	at 5 mV s
3034	1017	Capacitance	373.0	F/g	at 0.4 A/g
3035	1017	Resistivity	2.29	Ω	for MXene WS2
3036	1017	Resistivity	5.25	Ω	for WS2
3037	1017	Resistivity	3.41	Ω	for MXene
3038	1018	Capacitance	226.0	F/g	At 1 A/g in 1-ethyl-3-methylimidazolium tetrafluoroborate (EmimBF4) electrolyte
3039	1018	Capacitance	306.0	C/g	At 1 A/g in 1-ethyl-3-methylimidazolium tetrafluoroborate (EmimBF4) electrolyte
3040	1018	Energy_Density	43.0	Wh/kg	At high power density of 1669 W/kg
3041	1019	Capacitance	399.0	F/g	at 1 A/g
3042	1019	Capacitance	342.0	F/g	at 1 A/g
3043	1019	Rate_Performance	63.6	%	from 1 to 10 A/g
3044	1019	Rate_Performance	55.6	%	from 1 to 10 A/g
3045	1021	Capacitance	364.0	F/g	in 0.5 M K2SO4 electrolyte, stable potential window of 0.9 V-1 V
3046	1021	Energy_Density	45.7	Wh/kg	at a power density of 1.1 kW/kg
3047	1021	Capacitance	245.0	F/g	for pure VO2 in 0.5 M K2SO4 electrolyte
3048	1021	Capacitance	140.0	F/g	for Ti3C2Tx in 0.5 M K2SO4 electrolyte
3049	1021	Cyclic_Stability	78.0	%	after 10000 cycles
3050	1021	Leakage_Current	0.09	mA/cm²	after 12 h
3051	1022	Capacitance	1308.3	mF/cm²	
3052	1022	Capacitance	95.0	%	after 30,000 cycles
3053	1022	Coulombic_Efficiency	92.0	%	after 30,000 cycles
3054	1023	Capacitance	201.94	F/g	at 1 A/g
3055	1023	Capacitance	65.63	F/g	at 10 A/g
3056	1024	Capacitance	365.1	F/g	scanning rate of 10 mV/s
3057	1024	Capacitance	183.1	F/g	scanning rate of 10 mV/s
3058	1024	Energy_Density	10.76	Wh/kg	power density of 483.03 W/kg
3059	1024	Phosphorus_Doping_Ratio	1.25	at.%	heat treatment
3060	1025	Capacitance	316.0	F/g	at a current density of 5 mA cm2
3061	1025	Energy_Density	44.0	Wh/kg	in an asymmetric supercapacitor
3062	1025	Power_Density	2640.0	W/kg	in an asymmetric supercapacitor
3063	1025	Capacitance	900.0	F/g	in a two-electrode asymmetric supercapacitor
3064	1026	Capacitance	522.0	F/g	at 0.5 A/g
3065	1026	Resistivity	0.01	ohm-cm	not explicitly mentioned
3066	1026	Bandgap	0.0	eV	red-shift observed with increasing MX content
3067	1027	Conductivity	634.4	S/cm	Not explicitly mentioned
3068	1027	Capacitance	2935.0	mF/cm²	At current density of 1 mA/cm²
3069	1027	Capacitance	522.0	mF/cm²	At 5 mA/cm²
3070	1027	Energy_Density	94.7	μWh/cm²	At 573 μW/cm² power density
3071	1028	Capacitance	128.0	F/g	1 A g-1 current density
3072	1028	Capacitance	576.7	F/g	1 A g-1 current density
3073	1029	Capacitance	985.0	F/g	at a current density of 1 Ag-1 within the potential range from 0.5 V to 0.6 V
3074	1029	Energy_Density	165.53	Wh/kg	at a power density of 1100 W/kg
3075	1029	Conductivity	0.0		not explicitly mentioned
3076	1030	Capacitance	2080.1	mF/cm²	at 1 mA/cm² current density
3077	1030	Capacitance	91.0	%	after 10,000 charge discharge cycles at 20 mA/cm²
3078	1031	Capacitance	175.0	F/g	At 1 A/g, for Ti3C2Tx
3079	1031	Capacitance	255.0	F/g	At 1 A/g, for Ti3C2Tx PANI
3080	1031	Capacitance	270.0	F/g	At 1 A/g, for Ti3C2Tx PPy
3081	1031	Capacitance	98.0	%	After 5000 cycles, for Ti3C2Tx PPy
3082	1031	Capacitance	88.0	%	After 5000 cycles, for Ti3C2Tx pristine
3083	1032	Capacitance	660.0	F/g	current density of 1 A/g
3084	1032	Energy_Density	33.3	Wh/kg	
3085	1032	Power_Density	1683.0	W/kg	
3086	1032	Capacitance	223.12	F/g	
3087	1032	Energy_Density	7.74	Wh/kg	
3088	1032	Power_Density	292.6	W/kg	
3089	1033	Capacitance	173.8	mF/cm²	5 mV/s scan rate
3090	1033	Energy_Density	96.57	μWh/cm²	Not specified
3091	1033	Power_Density	1.74	mW/cm²	Not specified
3092	1033	Capacitance	278.66	mF/cm²	100°C
3093	1034	Capacitance	1896.8	F/g	at 1 A/g
3094	1034	Capacitance	405.5	F/g	at 1 A/g
3095	1034	Energy_Density	72.4	Wh/kg	at 800.12 W/kg
3096	1034	Cycling_Stability	91.4	%	after 10,000 charge-discharge cycles
3097	1036	Capacitance	276.0	F/g	current density of 0.5 A/g
3098	1037	Capacitance	50.0		depending on the metal pair and electrolyte used
3099	1038	Capacitance	299.0	F/g	at 1 A/g
3100	1038	Capacitance	321.0	F/g	at 1 A/g
3101	1039	Capacitance	2637.0	F/g	at 2.5 A/g
3102	1039	Capacitance	1582.0	C/g	at 2.5 A/g
3103	1039	Capacitance	226.0	F/g	at 1.5 A/g
3104	1039	Energy_Density	80.0	Wh/kg	at a power density of 1196 W/kg
3105	1039	Conductivity	353.77	S/m	verified by DFT calculations
3106	1040	Capacitance	871.3	mF/cm²	at a current density of 5 mA/cm²
3107	1040	Capacitance	188.2	mF/cm²	at a current density of 5 mA/cm²
3108	1040	Conductivity	546.4	S/cm	after 2000 cycles at a current density of 10 mA/cm²
3109	1040	Energy_Density	106.7	μWh/cm²	at an areal power density of 420 μW/cm²
3110	1041	Capacitance	299.0	F/g	1 M aqueous H3PO4, 5 mV/s scan rate
3111	1041	Capacitance	212.0	F/g	1 M aqueous H2SO4, 5 mV/s scan rate
3112	1041	Capacitance	151.0	F/g	1 M H3PO4, current density 0.8 A/g
3113	1041	Capacitance	81.0	F/g	1 M H2SO4, current density 0.8 A/g
3114	1041	Capacitance	203.0	F/g	1 M H3PO4 gel electrolyte, current density 1 A/g
3115	1041	Capacitance	141.0	F/g	1 M H2SO4 gel electrolyte, current density 1 A/g
3116	1041	Energy_Density	72.0	Wh/kg	1.6 V window, H3PO4 gel electrolyte
3117	1041	Surface_Area	42.53	m2/g	BET method
3118	1041	Pore_Size	37.37	nm	BET method
3119	1042	Capacitance	1116.0	F/g	pristine MnCo2O4
3120	1042	Capacitance	640.5	F/g	pristine layered MXene
3121	1042	Capacitance	1500.0	F/g	MnCo2O4-25 wt MXene
3122	1042	Energy_Density	43.5	Wh/kg	at a power density of 1411 W/kg
3123	1043	Capacitance	1531.2	F/g	1 A/g
3124	1043	Capacitance	94.1	%	after 10,000 cycles
3125	1043	Energy_Density	58.8	Wh/kg	at 5 A/g
3126	1043	Power_Density	800.3	W/kg	at 5 A/g
3127	1043	Tafel_Slope	37.7	mV/dec	for hydrogen evolution reaction (HER)
3128	1044	Capacitance	1161.4	mF/cm²	at 1 mA/cm²
3129	1044	Capacitance	812.9	mC/cm²	at 1 mA/cm²
3130	1044	Rate_Performance	58.4	%	at 50 mA/cm²
3131	1044	Energy_Density	158.7	µW h/cm²	at a power density of 700.1 µW/cm²
3132	1044	Fracture_Stress	35.6	MPa	
3133	1045	Capacitance	685.77	mF/cm²	Scan rate of 10 mV/s
3134	1045	Capacitance	497.41	mF/cm²	Scan rate of 1000 mV/s
3135	1045	Capacitance	72.53	%	At a scan rate of 1000 mV/s
3136	1045	Energy_Density	128.78	μWh/cm²	At a power density of 850 μW/cm²
3228	1067	Capacitance	348.14	F/g	2 mV s−1 scan rate
3137	1045	Energy_Density	101.15	μWh/cm²	At a power density of 17,000 μW/cm²
3138	1045	Capacitance	115.0	%	After 10,000 cycles
3139	1046	Capacitance	1541.6	C/g	at 1 A/g
3140	1046	Capacitance	2569.3	F/g	at 1 A/g
3141	1046	Capacitance	255.6	C/g	at 1 A/g
3142	1046	Energy_Density	74.1	Wh/kg	at power density of 849.8 W/kg
3143	1046	Power_Density	849.8	W/kg	at energy density of 74.1 Wh/kg
3144	1046	Cycle_Performance	93.5	%	after 10,000 cycles
3145	1046	Cycle_Performance	92.8	%	after 10,000 cycles
3146	1046	Cycle_Performance	91.3	%	after 10,000 cycles
3147	1048	Capacitance	498.3	F/g	at 1 A/g
3148	1048	Capacitance	1911.0	F/cm3	at 1 A/g
3149	1048	Rate_Performance	63.0	%	from 1 to 20 A/g
3150	1048	Cycling_Stability	98.2	%	after 20,000 cycles
3151	1048	Capacitance	3.23	F/cm2	at 1 A/g
3152	1048	Capacitance	117.0	F/g	at 0.5 A/g
3153	1048	Energy_Density	23.4	Wh/kg	at 299.8 W/kg
3154	1048	Cycling_Stability	84.0	%	after 3000 cycles
3155	1049	Conductivity	353.77	S/m	not explicitly mentioned
3156	1049	Young_Modulus	200.0	GPa	not explicitly mentioned
3157	1050	Capacitance	353.77	F/g	Galvanostatic charge-discharge (GCD) tests at current densities ranging from 1 to 5 Ag-1
3158	1050	Conductivity	353.77	S/m	Electrochemical performance evaluated via a three-electrode configuration with 1 M H2SO4 as the electrolyte
3159	1051	Capacitance	1126.0	F/g	current density of 1 A/g
3160	1051	Energy_Density	46.18	Wh/kg	power density of 750 W/kg
3161	1051	Capacitance	70.98	%	after 10,000 charge-discharge cycles at 10 A/g
3162	1051	Capacitance	79.06	%	after 10,000 charge-discharge cycles
3163	1052	Capacitance	471.0	F/g	at 1 A/g
3164	1052	Energy_Density	24.6	Wh/kg	in asymmetric supercapacitor with RuO2 CC as positive electrode
3165	1052	Capacitance	88.3	%	as current density increases to 15 A/g
3166	1052	Cyclic_Stability	100.0	%	after 20,000 cycles
3167	1053	Capacitance	15.5	mF/cm²	
3168	1053	Capacitance	4.05	mF/cm²	on glass substrate
3169	1053	Capacitance	93.35	%	after 1000 charge-discharge cycles
3170	1053	Capacitance	142.0	%	after 1000 bending test cycles
3171	1054	Capacitance	1250.0	F/g	supercapacitor performance evaluated via cyclic voltammetry (CV) and galvanostatic charge discharge (GCD) experiments
3172	1054	Discharge_Time	500.0	s	supercapacitor performance evaluated via cyclic voltammetry (CV) and galvanostatic charge discharge (GCD) experiments
3173	1054	Tafel_Slope	77.0	mV/dec	hydrogen evolution reaction (HER) in alkaline solution
3174	1054	Tafel_Slope	91.0	mV/dec	oxygen evolution reaction (OER) in alkaline solution
3175	1055	Capacitance	112.0	F/g	at 1 A/g
3176	1055	Rate_Capability	73.2	%	at 20 A/g
3177	1055	Cycle_Lifetime	10000.0	cycles	81.6% retention
3178	1055	Energy_Density	62.3	Wh/kg	at 1000.8 W/kg
3179	1055	Capacitance	768.0	F/g	at 1 A/g
3180	1055	Rate_Capability	65.1	%	at 20 A/g
3181	1055	Capacitance	98.9	%	after 10,000 charge discharge cycles at 10 A/g
3182	1056	Capacitance	1025.0	F/g	at a current density of 1 A/g
3183	1056	Capacitance	81.0	-	when the current density was increased to 10 A/g
3184	1056	Energy_Density	36.67	Wh/kg	at 800 W/kg
3185	1056	Capacitance	88.2	%	after 5000 cycles
3186	1056	Capacitance	82.2	%	after 5000 cycles
3187	1057	Capacitance	631.0	F/g	at 2 A/g
3188	1057	Capacitance	82.0	%	after 150 days
3189	1057	Interlayer_Spacing	1.67	nm	NH4OH-5-Az Ti3C2Tx
3190	1057	Interlayer_Spacing	1.25	nm	NH4OH-Ti3C2Tx
3191	1057	Energy_Density	59.1	Wh/kg	in a three-electrode system
3192	1057	Power_Density	1440.0	W/kg	in a three-electrode system
3193	1058	Conductivity	353.77	S/m	not explicitly mentioned
3194	1059	Capacitance	643.8	F/g	at 2 A/g in 3 M H2SO4 + 30 mM CuSO4 redox electrolyte
3195	1059	Energy_Density	20.1	Wh/kg	at a power density of 1292.5 W/kg
3196	1060	Capacitance	3.6	F/g	current density of 4 mA/g
3197	1060	Capacitance	80.0	%	after 2000 cycles at 10 mA/g
3198	1060	Conductivity	0.029	S/cm	PCCT conductive hydrogel
3199	1060	Conductivity	0.021	S/cm	PCT (without CoS)
3200	1060	Elongation_At_Break	349.0	%	PCCT conductive hydrogel
3201	1060	Self_Healing_Efficiency	66.88	%	after 48 h of healing at room temperature
3202	1061	Conductivity	20000.0	S/cm	
3203	1061	Work_Function	1.6	eV	
3204	1061	Work_Function	6.25	eV	
3205	1062	Capacitance	488.0	F/g	current density of 0.25 A/g
3206	1062	Energy_Density	5.0	Wh/kg	
3207	1062	Power_Density	1000.0	W/kg	
3208	1063	Capacitance	1862.5	mF/cm²	at 1 mA/cm²
3209	1063	Capacitance	1525.0	mF/cm²	at 20 mA/cm²
3210	1063	Energy_Density	133.75	μWh/cm²	at power density of 750 μW/cm²
3211	1063	Specific_Surface_Area	112.259	m²/g	MXene graphene CNTs
3212	1063	Average_Pore_Size	9.982	nm	MXene graphene CNTs
3213	1063	Pore_Volume	0.276	cm³/g	MXene graphene CNTs
3214	1063	Specific_Surface_Area	93.088	m²/g	MXene
3215	1063	Average_Pore_Size	3.786	nm	MXene
3216	1063	Pore_Volume	0.088	cm³/g	MXene
3217	1064	Capacitance	423.0	mAh/g	at 1 A/g
3218	1064	Energy_Density	57.78	Wh/kg	at 832 W/kg
3219	1065	Capacitance	2089.0	mF/cm²	at 2.5 mA/cm²
3220	1065	Capacitance	382.9	mF/cm²	in symmetrical flexible all-solid-state supercapacitor
3221	1065	Energy_Density	53.18	μWh/cm²	at 277.8 μW/cm² power density
3222	1065	Reflection_Loss	53.42	dB	at 6.08 GHz, thickness 4 mm
3223	1066	Capacitance	1900.0	F/g	current density of 1 A/g
3224	1066	Capacitance	1290.0	F/g	current density of 20 A/g
3225	1066	Capacitance	94.73	%	after 10,000 cycles at 5 A/g
3226	1066	Energy_Density	72.89	Wh/kg	at power density of 850 W/kg
3227	1066	Power_Density	16780.0	W/kg	with energy density of 37.28 Wh/kg
3229	1067	Energy_Density	37.8	Wh/kg	current density of 1 A g−1
3230	1067	Power_Density	1800.0	W/kg	current density of 1 A g−1
3231	1068	Capacitance	1460.0	F/g	at current density of 2 A/g
3232	1068	Capacitance	1465.0	F/g	after 5000 cycles
3233	1068	Overpotential	104.0	mV	at current density of 10 mA/cm²
3234	1068	Tafel_Slope	65.0	mV/dec	for electrocatalytic hydrogen evolution reaction
3235	1069	Capacitance	357.0	F/g	at 1 A/g
3236	1069	Capacitance	220.0	F/g	at 1 A/g
3237	1070	Energy_Density	46.4	W h kg-1	asymmetric supercapacitor
3238	1070	Power_Density	4.0	kW kg-1	asymmetric supercapacitor
3239	1071	Capacitance	449.0	F/g	at 2 mV s-1
3240	1071	Capacitance	321.0	F/g	for raw Ti3C2Tx
3241	1071	Energy_Density	9.57	Wh/kg	at 250 W/kg
3242	1071	Layer_Spacing	1.451	nm	
3243	1071	Nitrogen_Doping_Level	1.42	at%	
3244	1072	Capacitance	870.7	C/g	current density of 1 A/g
3245	1072	Capacitance	148.0	F/g	0.5 A/g
3246	1072	Energy_Density	46.3	Wh/kg	
3247	1072	Power_Density	370.0	W/kg	
3248	1072	Power_Density	7500.0	W/kg	
3249	1072	Energy_Density	25.6	Wh/kg	
3250	1072	Capacitance	68.2	%	after 6000 cycles
3251	1072	Capacitance	90.3	%	after 6000 cycles
3252	1073	Capacitance	1891.4	F/g	at 1 A/g
3253	1073	Energy_Density	35.5	Wh/kg	at 826.8 W/kg
3254	1073	Conductivity	353.77	S/m	not explicitly mentioned
3255	1074	Capacitance	358.5	F/g	1 A/g current density, 0.6-0.4 V potential window, 2 M H2SO4 electrolyte
3256	1074	Capacitance	892.0	F/g	1 A/g current density, 0.6-0.4 V potential window, 2 M H2SO4 electrolyte
3257	1074	Capacitance	171.0	F/g	1 A/g current density, 6 M KOH electrolyte
3258	1074	Capacitance	461.0	F/g	1 A/g current density, 6 M KOH electrolyte
3259	1075	Capacitance	1341.4	C/g	at 1 A/g
3260	1075	Cyclic_Stability	90.9	%	during 10000 cycles at 5 A/g
3261	1075	Energy_Density	66.3	Wh/kg	at specific power of 724.3 W/kg
3262	1075	Energy_Density	49.8	Wh/kg	at specific power of 7229.8 W/kg
3263	1075	Cyclic_Stability	97.3	%	after 10,000 cycles at 8 A/g
3264	1076	Capacitance	618.66	F/g	at 1 mA cm-2
3265	1076	Capacitance	93.75	%	after 5,000 cycles at 1 mA cm-2
3266	1076	Energy_Density	20.0	Wh/kg	in all-solid-state NiGa-LDH Ti3C2Tx MXene activated carbon (AC) asymmetric supercapacitor (AASCs)
3267	1076	Power_Density	400.0	W/kg	in all-solid-state NiGa-LDH Ti3C2Tx MXene activated carbon (AC) asymmetric supercapacitor (AASCs)
3268	1076	Capacitance	86.2	%	after 5,000 cycles
3269	1076	Coulombic_Efficiency	98.33	%	over 5,000 cycles
3270	1078	Capacitance	702.22	mF/cm²	at 3 mA/cm²
3271	1078	Capacitance	603.12	mF/cm²	at 100 mA/cm²
3272	1078	Energy_Density	104.53	μWh/cm²	at 800 μW/cm²
3273	1078	Energy_Density	93.87	μWh/cm²	at 7999 μW/cm²
3274	1078	Capacitance	85.89	%	at 100 mA/cm²
3275	1078	Capacity_Retention	90.2	%	after 10,000 cycles
3276	1079	Capacitance	770.0	C/g	at a current density of 1 A/g
3277	1079	Capacitance	97.2	%	after 3500 cycles at 8 A/g
3278	1079	Capacitance	88.1	%	after 5000 cycles at 8 A/g
3279	1079	Energy_Density	73.0	Wh/kg	
3280	1079	Power_Density	900.0	W/kg	
3281	1080	Capacitance	288.5	F/g	scan rate of 5 mV/s
3282	1080	Energy_Density	15.5	Wh/kg	power density 1100 W/kg
3283	1080	Energy_Density	39.9	μWh/cm²	power density 8586.4 μW/cm²
3284	1080	Cyclic_Stability	86.3	%	after 5000 cycles
3285	1080	Capacitance	98.8	%	after 5000 cycles
3286	1081	Capacitance	895.7	C/g	1 A/g
3287	1081	Capacitance	1791.4	F/g	1 A/g
3288	1081	Capacitance	587.5	C/g	20 A/g
3289	1081	Capacitance	1175.0	F/g	20 A/g
3290	1081	Energy_Density	73.9	Wh/kg	specific power of 728.2 W/kg
3291	1081	Energy_Density	52.9	Wh/kg	specific power of 7273.7 W/kg
3292	1081	Cycle_Performance	90.6	%	10,000 cycles
3293	1081	Cycle_Performance	90.7	%	10,000 cycles at 8 A/g
3294	1082	Capacitance	463.5	F/g	at a current density of 1 A/g
3295	1082	Energy_Density	33.95	Wh/kg	at a power density of 814.8 W/kg
3296	1082	Energy_Density	20.45	Wh/kg	at a high power density of 2352.1 W/kg
3297	1082	Capacitance	92.9	%	after 8000 cycles at 3 A/g
3298	1083	Capacitance	157.0	F/g	5 mV s-1
3299	1083	Capacitance	908.0	mF/g	0.5 mA g-1
3300	1083	Interfacial_Adhesion	54.0	%	to an epoxy-based resin
3301	1084	Capacitance	430.0	F/g	symmetric two-electrode assembly
3302	1084	Capacitance	305.0	F/g	symmetric two-electrode assembly
3303	1084	Capacitance	105.0	F/g	symmetric two-electrode assembly
3304	1084	Energy_Density	38.0	Wh/kg	at a specific power of 808 W/kg
3305	1084	Capacitance	84.0	%	after 10,000 continuous GCD cycles
3306	1084	Capacitance	85.0	%	after 10,000 continuous GCD cycles
3307	1085	Capacitance	563.8	F/g	0.5 A/g
3308	1085	Capacitance	130.8	F/g	0.5 A/g
3309	1085	Energy_Density	35.3	Wh/kg	486.1 W/kg
3310	1085	Energy_Density	20.1	Wh/kg	973.3 W/kg
3311	1085	Cycling_Performance	79.5	%	6000 times, 5 A/g
3312	1085	Capacitance	86.8	%	6000 charge discharge tests at 2 A/g
\.


--
-- Data for Name: messages_2025_10_05; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_10_05 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_10_06; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_10_06 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_10_07; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_10_07 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_10_08; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_10_08 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_10_09; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_10_09 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_10_10; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_10_10 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_10_11; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_10_11 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-09-11 15:17:30
20211116045059	2025-09-11 15:17:30
20211116050929	2025-09-11 15:17:30
20211116051442	2025-09-11 15:17:30
20211116212300	2025-09-11 15:17:30
20211116213355	2025-09-11 15:17:30
20211116213934	2025-09-11 15:17:30
20211116214523	2025-09-11 15:17:30
20211122062447	2025-09-11 15:17:30
20211124070109	2025-09-11 15:17:30
20211202204204	2025-09-11 15:17:30
20211202204605	2025-09-11 15:17:30
20211210212804	2025-09-11 15:17:30
20211228014915	2025-09-11 15:17:30
20220107221237	2025-09-11 15:17:30
20220228202821	2025-09-11 15:17:30
20220312004840	2025-09-11 15:17:30
20220603231003	2025-09-11 15:17:30
20220603232444	2025-09-11 15:17:30
20220615214548	2025-09-11 15:17:30
20220712093339	2025-09-11 15:17:30
20220908172859	2025-09-11 15:17:30
20220916233421	2025-09-11 15:17:30
20230119133233	2025-09-11 15:17:30
20230128025114	2025-09-11 15:17:30
20230128025212	2025-09-11 15:17:30
20230227211149	2025-09-11 15:17:30
20230228184745	2025-09-11 15:17:30
20230308225145	2025-09-11 15:17:30
20230328144023	2025-09-11 15:17:30
20231018144023	2025-09-11 15:17:30
20231204144023	2025-09-11 15:17:30
20231204144024	2025-09-11 15:17:30
20231204144025	2025-09-11 15:17:30
20240108234812	2025-09-11 15:17:30
20240109165339	2025-09-11 15:17:30
20240227174441	2025-09-11 15:17:30
20240311171622	2025-09-11 15:17:30
20240321100241	2025-09-11 15:17:30
20240401105812	2025-09-11 15:17:30
20240418121054	2025-09-11 15:17:30
20240523004032	2025-09-11 15:17:30
20240618124746	2025-09-11 15:17:30
20240801235015	2025-09-11 15:17:30
20240805133720	2025-09-11 15:17:30
20240827160934	2025-09-11 15:17:30
20240919163303	2025-09-11 15:17:30
20240919163305	2025-09-11 15:17:30
20241019105805	2025-09-11 15:17:30
20241030150047	2025-09-11 15:17:30
20241108114728	2025-09-11 15:17:30
20241121104152	2025-09-11 15:17:30
20241130184212	2025-09-11 15:17:30
20241220035512	2025-09-11 15:17:30
20241220123912	2025-09-11 15:17:30
20241224161212	2025-09-11 15:17:30
20250107150512	2025-09-11 15:17:30
20250110162412	2025-09-11 15:17:30
20250123174212	2025-09-11 15:17:30
20250128220012	2025-09-11 15:17:30
20250506224012	2025-09-11 15:17:30
20250523164012	2025-09-11 15:17:30
20250714121412	2025-09-11 15:17:30
20250905041441	2025-09-26 16:26:13
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (id, type, format, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_namespaces (id, bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_tables (id, namespace_id, bucket_id, name, location, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-09-11 15:21:48.224071
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-09-11 15:21:48.227033
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-09-11 15:21:48.229093
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-09-11 15:21:48.237349
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-09-11 15:21:48.242059
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-09-11 15:21:48.243852
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-09-11 15:21:48.246106
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-09-11 15:21:48.2482
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-09-11 15:21:48.249933
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-09-11 15:21:48.251384
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-09-11 15:21:48.253278
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-09-11 15:21:48.255499
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-09-11 15:21:48.257781
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-09-11 15:21:48.259584
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-09-11 15:21:48.26143
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-09-11 15:21:48.269942
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-09-11 15:21:48.272375
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-09-11 15:21:48.273893
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-09-11 15:21:48.275559
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-09-11 15:21:48.277561
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-09-11 15:21:48.279105
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-09-11 15:21:48.280886
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-09-11 15:21:48.2858
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-09-11 15:21:48.289573
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-09-11 15:21:48.29138
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-09-11 15:21:48.293065
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2025-09-11 15:21:48.294681
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2025-09-11 15:21:48.300029
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2025-09-11 15:21:48.305026
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2025-09-11 15:21:48.307154
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2025-09-11 15:21:48.309097
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2025-09-11 15:21:48.314764
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2025-09-11 15:21:48.319002
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2025-09-11 15:21:48.323653
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2025-09-11 15:21:48.324896
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2025-09-11 15:21:48.327648
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2025-09-11 15:21:48.329136
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-09-11 15:21:48.332536
38	iceberg-catalog-flag-on-buckets	19a8bd89d5dfa69af7f222a46c726b7c41e462c5	2025-09-11 15:21:48.334142
39	add-search-v2-sort-support	39cf7d1e6bf515f4b02e41237aba845a7b492853	2025-09-26 16:27:24.979247
40	fix-prefix-race-conditions-optimized	fd02297e1c67df25a9fc110bf8c8a9af7fb06d1f	2025-09-26 16:27:24.986711
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
\.


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2025-09-11 15:14:41.258294+00
20210809183423_update_grants	2025-09-11 15:14:41.258294+00
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: applications_app_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applications_app_id_seq', 2515, true);


--
-- Name: materials_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materials_material_id_seq', 1085, true);


--
-- Name: papers_paper_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.papers_paper_id_seq', 913, true);


--
-- Name: properties_property_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.properties_property_id_seq', 3312, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_client_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_client_id_key UNIQUE (client_id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (app_id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (material_id);


--
-- Name: papers papers_doi_url_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.papers
    ADD CONSTRAINT papers_doi_url_key UNIQUE (doi_url);


--
-- Name: papers papers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.papers
    ADD CONSTRAINT papers_pkey PRIMARY KEY (paper_id);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (property_id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_10_05 messages_2025_10_05_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_10_05
    ADD CONSTRAINT messages_2025_10_05_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_10_06 messages_2025_10_06_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_10_06
    ADD CONSTRAINT messages_2025_10_06_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_10_07 messages_2025_10_07_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_10_07
    ADD CONSTRAINT messages_2025_10_07_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_10_08 messages_2025_10_08_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_10_08
    ADD CONSTRAINT messages_2025_10_08_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_10_09 messages_2025_10_09_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_10_09
    ADD CONSTRAINT messages_2025_10_09_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_10_10 messages_2025_10_10_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_10_10
    ADD CONSTRAINT messages_2025_10_10_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_10_11 messages_2025_10_11_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_10_11
    ADD CONSTRAINT messages_2025_10_11_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: iceberg_namespaces iceberg_namespaces_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_pkey PRIMARY KEY (id);


--
-- Name: iceberg_tables iceberg_tables_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_clients_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_client_id_idx ON auth.oauth_clients USING btree (client_id);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_10_05_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_10_05_inserted_at_topic_idx ON realtime.messages_2025_10_05 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_10_06_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_10_06_inserted_at_topic_idx ON realtime.messages_2025_10_06 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_10_07_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_10_07_inserted_at_topic_idx ON realtime.messages_2025_10_07 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_10_08_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_10_08_inserted_at_topic_idx ON realtime.messages_2025_10_08 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_10_09_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_10_09_inserted_at_topic_idx ON realtime.messages_2025_10_09 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_10_10_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_10_10_inserted_at_topic_idx ON realtime.messages_2025_10_10 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_10_11_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_10_11_inserted_at_topic_idx ON realtime.messages_2025_10_11 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_iceberg_namespaces_bucket_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_namespaces_bucket_id ON storage.iceberg_namespaces USING btree (bucket_id, name);


--
-- Name: idx_iceberg_tables_namespace_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_tables_namespace_id ON storage.iceberg_tables USING btree (namespace_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2025_10_05_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_10_05_inserted_at_topic_idx;


--
-- Name: messages_2025_10_05_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_10_05_pkey;


--
-- Name: messages_2025_10_06_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_10_06_inserted_at_topic_idx;


--
-- Name: messages_2025_10_06_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_10_06_pkey;


--
-- Name: messages_2025_10_07_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_10_07_inserted_at_topic_idx;


--
-- Name: messages_2025_10_07_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_10_07_pkey;


--
-- Name: messages_2025_10_08_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_10_08_inserted_at_topic_idx;


--
-- Name: messages_2025_10_08_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_10_08_pkey;


--
-- Name: messages_2025_10_09_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_10_09_inserted_at_topic_idx;


--
-- Name: messages_2025_10_09_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_10_09_pkey;


--
-- Name: messages_2025_10_10_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_10_10_inserted_at_topic_idx;


--
-- Name: messages_2025_10_10_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_10_10_pkey;


--
-- Name: messages_2025_10_11_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_10_11_inserted_at_topic_idx;


--
-- Name: messages_2025_10_11_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_10_11_pkey;


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_cleanup; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_delete_cleanup AFTER DELETE ON storage.objects REFERENCING OLD TABLE AS deleted FOR EACH STATEMENT EXECUTE FUNCTION storage.objects_delete_cleanup();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_cleanup; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_update_cleanup AFTER UPDATE ON storage.objects REFERENCING OLD TABLE AS old_rows NEW TABLE AS new_rows FOR EACH STATEMENT EXECUTE FUNCTION storage.objects_update_cleanup();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_cleanup; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_delete_cleanup AFTER DELETE ON storage.prefixes REFERENCING OLD TABLE AS deleted FOR EACH STATEMENT EXECUTE FUNCTION storage.prefixes_delete_cleanup();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: applications applications_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(material_id) ON DELETE CASCADE;


--
-- Name: materials materials_paper_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_paper_id_fkey FOREIGN KEY (paper_id) REFERENCES public.papers(paper_id) ON DELETE CASCADE;


--
-- Name: properties properties_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(material_id) ON DELETE CASCADE;


--
-- Name: iceberg_namespaces iceberg_namespaces_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_namespace_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES storage.iceberg_namespaces(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_namespaces; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_namespaces ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_tables; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_tables ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;


--
-- Name: TABLE applications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.applications TO anon;
GRANT ALL ON TABLE public.applications TO authenticated;
GRANT ALL ON TABLE public.applications TO service_role;


--
-- Name: SEQUENCE applications_app_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.applications_app_id_seq TO anon;
GRANT ALL ON SEQUENCE public.applications_app_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.applications_app_id_seq TO service_role;


--
-- Name: TABLE materials; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.materials TO anon;
GRANT ALL ON TABLE public.materials TO authenticated;
GRANT ALL ON TABLE public.materials TO service_role;


--
-- Name: SEQUENCE materials_material_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.materials_material_id_seq TO anon;
GRANT ALL ON SEQUENCE public.materials_material_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.materials_material_id_seq TO service_role;


--
-- Name: TABLE papers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.papers TO anon;
GRANT ALL ON TABLE public.papers TO authenticated;
GRANT ALL ON TABLE public.papers TO service_role;


--
-- Name: SEQUENCE papers_paper_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.papers_paper_id_seq TO anon;
GRANT ALL ON SEQUENCE public.papers_paper_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.papers_paper_id_seq TO service_role;


--
-- Name: TABLE properties; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.properties TO anon;
GRANT ALL ON TABLE public.properties TO authenticated;
GRANT ALL ON TABLE public.properties TO service_role;


--
-- Name: SEQUENCE properties_property_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.properties_property_id_seq TO anon;
GRANT ALL ON SEQUENCE public.properties_property_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.properties_property_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2025_10_05; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_10_05 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_10_05 TO dashboard_user;


--
-- Name: TABLE messages_2025_10_06; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_10_06 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_10_06 TO dashboard_user;


--
-- Name: TABLE messages_2025_10_07; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_10_07 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_10_07 TO dashboard_user;


--
-- Name: TABLE messages_2025_10_08; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_10_08 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_10_08 TO dashboard_user;


--
-- Name: TABLE messages_2025_10_09; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_10_09 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_10_09 TO dashboard_user;


--
-- Name: TABLE messages_2025_10_10; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_10_10 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_10_10 TO dashboard_user;


--
-- Name: TABLE messages_2025_10_11; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_10_11 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_10_11 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE iceberg_namespaces; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_namespaces TO service_role;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO anon;


--
-- Name: TABLE iceberg_tables; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_tables TO service_role;
GRANT SELECT ON TABLE storage.iceberg_tables TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_tables TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE prefixes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.prefixes TO service_role;
GRANT ALL ON TABLE storage.prefixes TO authenticated;
GRANT ALL ON TABLE storage.prefixes TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;
GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;
GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict Hnd1UczLtaGdqkvR1PqehDgXi059KxSaTIOxIufjA79Xgkjc9IrkrhESQh9CWHc

