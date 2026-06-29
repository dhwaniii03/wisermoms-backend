--
-- PostgreSQL database dump
--

\restrict O2yCeQHamzi5FLNTl3sld35RN1EzqvGamWgfFkPRLX7Jaz0AR1RjaaOVSxoMQm4

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.4

-- Started on 2026-06-12 16:09:15 IST

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
-- TOC entry 24 (class 2615 OID 16498)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- TOC entry 16 (class 2615 OID 16392)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- TOC entry 23 (class 2615 OID 16578)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- TOC entry 22 (class 2615 OID 16567)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- TOC entry 12 (class 2615 OID 16390)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- TOC entry 129 (class 2615 OID 26788)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 129
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 14 (class 2615 OID 16559)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- TOC entry 25 (class 2615 OID 16546)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- TOC entry 15 (class 2615 OID 17540)
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- TOC entry 21 (class 2615 OID 16607)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- TOC entry 6 (class 3079 OID 16643)
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- TOC entry 2 (class 3079 OID 16393)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 4 (class 3079 OID 16447)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 5 (class 3079 OID 16608)
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- TOC entry 3 (class 3079 OID 16436)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1193 (class 1247 OID 16742)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- TOC entry 1217 (class 1247 OID 16883)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- TOC entry 1190 (class 1247 OID 16736)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- TOC entry 1187 (class 1247 OID 16730)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- TOC entry 1235 (class 1247 OID 16986)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- TOC entry 1247 (class 1247 OID 17059)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- TOC entry 1229 (class 1247 OID 16964)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- TOC entry 1238 (class 1247 OID 16996)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- TOC entry 1223 (class 1247 OID 16925)
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- TOC entry 1358 (class 1247 OID 26842)
-- Name: ApplicationPriority; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ApplicationPriority" AS ENUM (
    'normal',
    'high',
    'urgent'
);


--
-- TOC entry 1355 (class 1247 OID 26824)
-- Name: ApplicationStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ApplicationStatus" AS ENUM (
    'draft',
    'submitted',
    'under_review',
    'action_required',
    'approved',
    'rejected',
    'withdrawn',
    'not_started'
);


--
-- TOC entry 1352 (class 1247 OID 26814)
-- Name: EligibilityStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."EligibilityStatus" AS ENUM (
    'qualified',
    'likely_qualified',
    'check_required',
    'not_qualified'
);


--
-- TOC entry 1427 (class 1247 OID 27706)
-- Name: PaymentStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PaymentStatus" AS ENUM (
    'succeeded',
    'failed',
    'pending'
);


--
-- TOC entry 1313 (class 1247 OID 27541)
-- Name: QuarterDueDateSource; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."QuarterDueDateSource" AS ENUM (
    'GOVT',
    'CALCULATED'
);


--
-- TOC entry 1424 (class 1247 OID 27693)
-- Name: SubscriptionStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."SubscriptionStatus" AS ENUM (
    'active',
    'past_due',
    'canceled',
    'incomplete',
    'trialing',
    'unpaid'
);


--
-- TOC entry 1346 (class 1247 OID 26798)
-- Name: UserPlan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserPlan" AS ENUM (
    'community',
    'partner',
    'network'
);


--
-- TOC entry 1343 (class 1247 OID 26790)
-- Name: UserRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserRole" AS ENUM (
    'user',
    'admin',
    'counselor'
);


--
-- TOC entry 1349 (class 1247 OID 26806)
-- Name: UserStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserStatus" AS ENUM (
    'active',
    'inactive',
    'flagged'
);


--
-- TOC entry 1277 (class 1247 OID 17210)
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- TOC entry 1265 (class 1247 OID 17170)
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
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


--
-- TOC entry 1268 (class 1247 OID 17185)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- TOC entry 1310 (class 1247 OID 17443)
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- TOC entry 1280 (class 1247 OID 17223)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- TOC entry 1298 (class 1247 OID 17349)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- TOC entry 535 (class 1255 OID 16544)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
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


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 535
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 526 (class 1255 OID 16712)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
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


--
-- TOC entry 534 (class 1255 OID 16543)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
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


--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 534
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 539 (class 1255 OID 16542)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
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


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 539
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 532 (class 1255 OID 16551)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 532
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 485 (class 1255 OID 16572)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 485
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 459 (class 1255 OID 16553)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
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
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 459
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 434 (class 1255 OID 16563)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- TOC entry 443 (class 1255 OID 16564)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- TOC entry 477 (class 1255 OID 16574)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 477
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 445 (class 1255 OID 16391)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- TOC entry 505 (class 1255 OID 17436)
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
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
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
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

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

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

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
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
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

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
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

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
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
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
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
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
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
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
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


--
-- TOC entry 430 (class 1255 OID 17516)
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- TOC entry 512 (class 1255 OID 17448)
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- TOC entry 515 (class 1255 OID 17207)
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- TOC entry 483 (class 1255 OID 17202)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- TOC entry 460 (class 1255 OID 17444)
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- TOC entry 514 (class 1255 OID 27475)
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
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
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


--
-- TOC entry 431 (class 1255 OID 17201)
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


--
-- TOC entry 440 (class 1255 OID 17515)
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- TOC entry 495 (class 1255 OID 27476)
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- TOC entry 481 (class 1255 OID 17199)
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
    table_col_names text[] = coalesce(
            array_agg(pa.attname),
            '{}'::text[]
        )
        from
            pg_attribute pa
        where
            pa.attrelid = new.entity
            and pa.attnum > 0;
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
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

    -- Validate that selected_columns reference columns the role can SELECT
    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint on
    -- (subscription_id, entity, filters) can't be tricked by a different filter order
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value),
        '{}'
    ) from unnest(new.filters) f;

    -- Normalize selected_columns order so ARRAY['a','b'] and ARRAY['b','a'] are
    -- treated as the same subscription group in apply_rls
    new.selected_columns = (
        select array_agg(c order by c)
        from unnest(new.selected_columns) c
    );

    return new;
end;
$$;


--
-- TOC entry 509 (class 1255 OID 17425)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- TOC entry 511 (class 1255 OID 17509)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- TOC entry 442 (class 1255 OID 27474)
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


--
-- TOC entry 470 (class 1255 OID 17414)
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


--
-- TOC entry 449 (class 1255 OID 17413)
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


--
-- TOC entry 482 (class 1255 OID 17290)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- TOC entry 484 (class 1255 OID 17346)
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- TOC entry 520 (class 1255 OID 17265)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- TOC entry 497 (class 1255 OID 17264)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- TOC entry 458 (class 1255 OID 17263)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- TOC entry 461 (class 1255 OID 17402)
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- TOC entry 474 (class 1255 OID 17277)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- TOC entry 530 (class 1255 OID 17329)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- TOC entry 475 (class 1255 OID 17403)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- TOC entry 438 (class 1255 OID 17345)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- TOC entry 476 (class 1255 OID 17409)
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- TOC entry 491 (class 1255 OID 17279)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- TOC entry 537 (class 1255 OID 17407)
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- TOC entry 488 (class 1255 OID 17406)
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- TOC entry 468 (class 1255 OID 17280)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 355 (class 1259 OID 16529)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 4743 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 375 (class 1259 OID 17082)
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- TOC entry 369 (class 1259 OID 16887)
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 360 (class 1259 OID 16684)
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
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


--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 360
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 354 (class 1259 OID 16522)
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 364 (class 1259 OID 16774)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 363 (class 1259 OID 16762)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
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


--
-- TOC entry 4749 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 362 (class 1259 OID 16749)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
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
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 4751 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 372 (class 1259 OID 16999)
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- TOC entry 374 (class 1259 OID 17072)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- TOC entry 4752 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 371 (class 1259 OID 16969)
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- TOC entry 373 (class 1259 OID 17032)
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- TOC entry 370 (class 1259 OID 16937)
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
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


--
-- TOC entry 353 (class 1259 OID 16511)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
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


--
-- TOC entry 4753 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 352 (class 1259 OID 16510)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 352
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 367 (class 1259 OID 16816)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
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


--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 368 (class 1259 OID 16834)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
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


--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 356 (class 1259 OID 16537)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 361 (class 1259 OID 16714)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
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
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 361
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 361
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 361
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 366 (class 1259 OID 16801)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 365 (class 1259 OID 16792)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 365
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 351 (class 1259 OID 16499)
-- Name: users; Type: TABLE; Schema: auth; Owner: -
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


--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 377 (class 1259 OID 17147)
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


--
-- TOC entry 376 (class 1259 OID 17124)
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


--
-- TOC entry 422 (class 1259 OID 27567)
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 410 (class 1259 OID 26992)
-- Name: account_deletion_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_deletion_requests (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    requested_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    completed_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    error_message text
);


--
-- TOC entry 411 (class 1259 OID 27001)
-- Name: application_guides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_guides (
    id uuid NOT NULL,
    program_id text,
    guide_name text NOT NULL,
    overview text,
    apply_url text,
    phone text,
    last_verified date,
    source_url text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    state text DEFAULT 'GA'::text NOT NULL
);


--
-- TOC entry 403 (class 1259 OID 26926)
-- Name: applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.applications (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    program_id text,
    status text DEFAULT 'draft'::text NOT NULL,
    submitted_at timestamp(3) without time zone,
    last_updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    notes text,
    assigned_admin_id uuid,
    priority text DEFAULT 'normal'::text NOT NULL,
    pdf_generated boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 413 (class 1259 OID 27018)
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    org_id uuid,
    agency_name text,
    appointment_date timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 408 (class 1259 OID 26974)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id uuid NOT NULL,
    admin_id uuid NOT NULL,
    action text NOT NULL,
    target_type text NOT NULL,
    target_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 425 (class 1259 OID 27754)
-- Name: billing_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.billing_events (
    id uuid NOT NULL,
    user_id uuid,
    event_type text NOT NULL,
    stripe_event_id text NOT NULL,
    payload jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 407 (class 1259 OID 26966)
-- Name: counselor_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.counselor_sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    counselor_id uuid NOT NULL,
    scheduled_at timestamp(3) without time zone NOT NULL,
    duration_minutes integer DEFAULT 30 NOT NULL,
    status text NOT NULL,
    notes text,
    meeting_url text
);


--
-- TOC entry 406 (class 1259 OID 26958)
-- Name: deadlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deadlines (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    application_id uuid NOT NULL,
    deadline_type text NOT NULL,
    due_date timestamp(3) without time zone NOT NULL,
    reminder_sent_at timestamp(3) without time zone,
    is_completed boolean DEFAULT false NOT NULL
);


--
-- TOC entry 404 (class 1259 OID 26939)
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    application_id uuid,
    document_type text NOT NULL,
    file_name text DEFAULT 'unnamed_file'::text NOT NULL,
    display_name text DEFAULT 'Unnamed Document'::text NOT NULL,
    storage_path text NOT NULL,
    file_size integer,
    mime_type text,
    uploaded_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 414 (class 1259 OID 27026)
-- Name: documents_required; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents_required (
    id uuid NOT NULL,
    program_id text NOT NULL,
    document_name text NOT NULL,
    description text,
    required boolean DEFAULT true NOT NULL,
    conditional_on text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 409 (class 1259 OID 26982)
-- Name: generated_pdfs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generated_pdfs (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    application_id uuid,
    program_id text NOT NULL,
    file_url text NOT NULL,
    file_size integer NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    status text DEFAULT 'generated'::text NOT NULL,
    validation_report jsonb,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    quarter text,
    year integer
);


--
-- TOC entry 412 (class 1259 OID 27010)
-- Name: guide_steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guide_steps (
    id uuid NOT NULL,
    guide_id uuid NOT NULL,
    step_number integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    plain_english text,
    tip text,
    url text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 415 (class 1259 OID 27035)
-- Name: income_thresholds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.income_thresholds (
    id uuid NOT NULL,
    program_id text NOT NULL,
    household_size integer NOT NULL,
    income_limit numeric,
    income_limit_yr numeric,
    benefit_amount numeric,
    co_pay numeric,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 405 (class 1259 OID 26949)
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    related_application_id uuid,
    action_url text
);


--
-- TOC entry 417 (class 1259 OID 27067)
-- Name: org_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.org_services (
    id uuid NOT NULL,
    org_id uuid NOT NULL,
    service_type text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 416 (class 1259 OID 27043)
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id uuid NOT NULL,
    org_name text NOT NULL,
    category text NOT NULL,
    purpose text,
    phone text,
    crisis_line text,
    email text,
    website text,
    address text,
    city text DEFAULT 'Atlanta'::text,
    state text DEFAULT 'GA'::text,
    zip_code text,
    counties_served text[] DEFAULT ARRAY[]::text[],
    populations_served text[] DEFAULT ARRAY[]::text[],
    languages_served text[] DEFAULT ARRAY[]::text[],
    intake_process text,
    hours_of_operation text,
    flag_dv boolean DEFAULT false NOT NULL,
    flag_eviction boolean DEFAULT false NOT NULL,
    flag_children_u5 boolean DEFAULT false NOT NULL,
    flag_pregnant boolean DEFAULT false NOT NULL,
    flag_student boolean DEFAULT false NOT NULL,
    flag_immigrant boolean DEFAULT false NOT NULL,
    flag_no_childcare boolean DEFAULT false NOT NULL,
    dv_safety_mode boolean DEFAULT false NOT NULL,
    partner_tier text,
    last_verified_date date,
    source_url text,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    service_tags text[] DEFAULT ARRAY[]::text[],
    referral_notes text
);


--
-- TOC entry 424 (class 1259 OID 27731)
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    subscription_id uuid,
    stripe_payment_intent_id text,
    amount integer NOT NULL,
    currency text DEFAULT 'usd'::text NOT NULL,
    status public."PaymentStatus" DEFAULT 'pending'::public."PaymentStatus" NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 418 (class 1259 OID 27075)
-- Name: pdf_generations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pdf_generations (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    program_code text NOT NULL,
    program_name text,
    state text NOT NULL,
    language text DEFAULT 'en'::text NOT NULL,
    template_used text,
    storage_path text,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 400 (class 1259 OID 26863)
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    household_size integer,
    num_children_under18 integer,
    children_ages jsonb,
    gross_monthly_income double precision,
    employment_status text,
    housing_situation text,
    has_disability boolean DEFAULT false,
    pregnant boolean DEFAULT false,
    first_name text,
    last_name text,
    date_of_birth date,
    phone text,
    email text,
    language_preference text DEFAULT 'en'::text,
    street_address text,
    apartment_suite text,
    city text,
    state text DEFAULT 'GA'::text,
    zip_code text,
    monthly_rent numeric,
    monthly_utilities numeric,
    landlord_name text,
    eviction_notice boolean DEFAULT false,
    income_sources text[] DEFAULT ARRAY[]::text[],
    other_household_income boolean DEFAULT false,
    children_dobs text[] DEFAULT ARRAY[]::text[],
    child_disability boolean DEFAULT false,
    marital_status text,
    other_adults boolean DEFAULT false,
    needs_childcare boolean DEFAULT false,
    has_health_insurance boolean DEFAULT false,
    immigration_status text,
    legal_issues text[] DEFAULT ARRAY[]::text[],
    urgency_level text,
    has_savings boolean DEFAULT false,
    domestic_violence boolean DEFAULT false,
    county text,
    postpartum_months_since_birth integer,
    breastfeeding boolean DEFAULT false NOT NULL,
    children_under_5_count integer DEFAULT 0 NOT NULL,
    has_medicaid boolean DEFAULT false NOT NULL,
    has_snap boolean DEFAULT false NOT NULL,
    has_tanf_work_first boolean DEFAULT false NOT NULL,
    has_ssi boolean DEFAULT false NOT NULL,
    has_non_custodial_parent boolean DEFAULT false NOT NULL,
    us_citizen boolean DEFAULT true NOT NULL,
    qualified_immigrant boolean DEFAULT false NOT NULL,
    work_activity_hrs_per_month integer DEFAULT 0 NOT NULL,
    in_qualifying_activity boolean DEFAULT false NOT NULL,
    previously_denied_medicaid boolean DEFAULT false NOT NULL,
    intake_snapshot jsonb,
    preferred_contact text DEFAULT 'email'::text NOT NULL,
    consent_data_use boolean DEFAULT false NOT NULL,
    intake_completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    child_support_status text,
    childcare_preference text,
    childcare_provider text,
    chronic_illness boolean DEFAULT false,
    employer_name text,
    health_insurance text,
    monthly_childcare_cost numeric,
    savings_assets text,
    ssn_last_four text,
    work_situation text
);


--
-- TOC entry 421 (class 1259 OID 27545)
-- Name: program_quarter_due_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.program_quarter_due_dates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    program_id text NOT NULL,
    year integer NOT NULL,
    quarter text NOT NULL,
    due_dates_json jsonb DEFAULT '[]'::jsonb NOT NULL,
    source public."QuarterDueDateSource",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 401 (class 1259 OID 26900)
-- Name: programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programs (
    id text NOT NULL,
    program_name text NOT NULL,
    administering_agency text NOT NULL,
    program_type text NOT NULL,
    federal_or_state text,
    state text,
    description text,
    eligibility_criteria jsonb,
    estimated_monthly_value_min double precision,
    estimated_monthly_value_max double precision,
    apply_url text,
    contact_email text,
    is_active boolean DEFAULT true NOT NULL,
    tags text[] DEFAULT ARRAY[]::text[],
    metadata jsonb,
    also_known_as text,
    agency_phone text,
    agency_website text,
    eligibility_summary text,
    income_limit_pct_fpl numeric,
    income_limit_pct_smi numeric,
    asset_limit numeric,
    lifetime_limit_months integer,
    work_requirement_hrs integer,
    renewal_period text,
    counties_served text[] DEFAULT ARRAY[]::text[],
    languages_available text[] DEFAULT ARRAY[]::text[],
    waitlist_status text DEFAULT 'open'::text,
    waitlist_notes text,
    last_verified_date date,
    source_url text,
    guide_url text,
    renewal_period_months integer,
    program_code text,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    program_due_date date
);


--
-- TOC entry 420 (class 1259 OID 27511)
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_tokens (
    id uuid NOT NULL,
    token text NOT NULL,
    user_id uuid NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 419 (class 1259 OID 27084)
-- Name: reminders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reminders (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    program_id text,
    program_name text,
    renewal_date date NOT NULL,
    reminder_date date,
    dismissed boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 402 (class 1259 OID 26913)
-- Name: results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.results (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    program_id text NOT NULL,
    status public."EligibilityStatus" DEFAULT 'check_required'::public."EligibilityStatus" NOT NULL,
    confidence_score double precision DEFAULT 0 NOT NULL,
    reasoning text DEFAULT ''::text NOT NULL,
    checked_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    org_id uuid,
    match_type text,
    eligibility text,
    estimated_benefit numeric,
    match_reason text,
    ai_rank integer,
    reasons text[] DEFAULT ARRAY[]::text[],
    program_code text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 423 (class 1259 OID 27713)
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    stripe_customer_id text,
    stripe_subscription_id text,
    plan public."UserPlan" NOT NULL,
    status public."SubscriptionStatus" DEFAULT 'active'::public."SubscriptionStatus" NOT NULL,
    current_period_start timestamp with time zone,
    current_period_end timestamp with time zone,
    cancel_at_period_end boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- TOC entry 399 (class 1259 OID 26849)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email text NOT NULL,
    password_hash text DEFAULT ''::text NOT NULL,
    full_name text DEFAULT ''::text NOT NULL,
    phone text,
    role public."UserRole" DEFAULT 'user'::public."UserRole" NOT NULL,
    plan public."UserPlan" DEFAULT 'community'::public."UserPlan" NOT NULL,
    stripe_customer_id text,
    stripe_subscription_id text,
    state text,
    zip_code text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    last_active_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status public."UserStatus" DEFAULT 'active'::public."UserStatus" NOT NULL,
    profile_picture text
);


--
-- TOC entry 392 (class 1259 OID 17519)
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
)
PARTITION BY RANGE (inserted_at);


--
-- TOC entry 394 (class 1259 OID 26101)
-- Name: messages_2026_05_24; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_05_24 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
);


--
-- TOC entry 395 (class 1259 OID 26113)
-- Name: messages_2026_05_25; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_05_25 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
);


--
-- TOC entry 396 (class 1259 OID 26125)
-- Name: messages_2026_05_26; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_05_26 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
);


--
-- TOC entry 397 (class 1259 OID 26137)
-- Name: messages_2026_05_27; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_05_27 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
);


--
-- TOC entry 398 (class 1259 OID 26149)
-- Name: messages_2026_05_28; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_05_28 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
);


--
-- TOC entry 378 (class 1259 OID 17164)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- TOC entry 381 (class 1259 OID 17187)
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- TOC entry 380 (class 1259 OID 17186)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
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
-- TOC entry 384 (class 1259 OID 17235)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
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


--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 384
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 388 (class 1259 OID 17354)
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- TOC entry 389 (class 1259 OID 17367)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 383 (class 1259 OID 17227)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 385 (class 1259 OID 17245)
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
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
    user_metadata jsonb
);


--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 385
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 386 (class 1259 OID 17294)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
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
    user_metadata jsonb,
    metadata jsonb
);


--
-- TOC entry 387 (class 1259 OID 17308)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
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


--
-- TOC entry 390 (class 1259 OID 17377)
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 393 (class 1259 OID 17541)
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text,
    created_by text,
    idempotency_key text,
    rollback text[]
);


--
-- TOC entry 3872 (class 0 OID 0)
-- Name: messages_2026_05_24; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_05_24 FOR VALUES FROM ('2026-05-24 00:00:00') TO ('2026-05-25 00:00:00');


--
-- TOC entry 3873 (class 0 OID 0)
-- Name: messages_2026_05_25; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_05_25 FOR VALUES FROM ('2026-05-25 00:00:00') TO ('2026-05-26 00:00:00');


--
-- TOC entry 3874 (class 0 OID 0)
-- Name: messages_2026_05_26; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_05_26 FOR VALUES FROM ('2026-05-26 00:00:00') TO ('2026-05-27 00:00:00');


--
-- TOC entry 3875 (class 0 OID 0)
-- Name: messages_2026_05_27; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_05_27 FOR VALUES FROM ('2026-05-27 00:00:00') TO ('2026-05-28 00:00:00');


--
-- TOC entry 3876 (class 0 OID 0)
-- Name: messages_2026_05_28; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_05_28 FOR VALUES FROM ('2026-05-28 00:00:00') TO ('2026-05-29 00:00:00');


--
-- TOC entry 3886 (class 2604 OID 16514)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4661 (class 0 OID 16529)
-- Dependencies: 355
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- TOC entry 4678 (class 0 OID 17082)
-- Dependencies: 375
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4672 (class 0 OID 16887)
-- Dependencies: 369
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- TOC entry 4663 (class 0 OID 16684)
-- Dependencies: 360
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
d91fa181-d8f9-4b3f-aebc-896a9d56a286	d91fa181-d8f9-4b3f-aebc-896a9d56a286	{"sub": "d91fa181-d8f9-4b3f-aebc-896a9d56a286", "email": "wm1777568421858@proton.me", "email_verified": false, "phone_verified": false}	email	2026-04-30 17:00:21.845254+00	2026-04-30 17:00:21.845296+00	2026-04-30 17:00:21.845296+00	d9bb6179-69b1-4b40-97d2-e56cf6bbbe16
4770a57e-9f74-485f-86a4-c59f5345a005	4770a57e-9f74-485f-86a4-c59f5345a005	{"sub": "4770a57e-9f74-485f-86a4-c59f5345a005", "email": "wm1777654969667@proton.me", "email_verified": false, "phone_verified": false}	email	2026-05-01 17:02:50.860511+00	2026-05-01 17:02:50.861656+00	2026-05-01 17:02:50.861656+00	236f7f11-e791-4408-9e72-071899fedf4b
59e71244-bc52-406c-8a3c-1659d2ea5027	59e71244-bc52-406c-8a3c-1659d2ea5027	{"sub": "59e71244-bc52-406c-8a3c-1659d2ea5027", "email": "wm1777655218112@proton.me", "email_verified": false, "phone_verified": false}	email	2026-05-01 17:06:58.616539+00	2026-05-01 17:06:58.617178+00	2026-05-01 17:06:58.617178+00	98d7f465-329e-4eb9-a496-d84868e19ae3
6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	{"sub": "6ce41223-bd9c-4a7b-9eeb-157ed3f7589d", "email": "jpender95@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-05-12 12:38:24.379408+00	2026-05-12 12:38:24.380552+00	2026-05-12 12:38:24.380552+00	e432c537-6716-4dc8-a072-9dc681e0eaf4
2fab2f72-ab42-4a79-a110-d6d6591959a1	2fab2f72-ab42-4a79-a110-d6d6591959a1	{"sub": "2fab2f72-ab42-4a79-a110-d6d6591959a1", "email": "jackie.owino@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-05-14 16:45:43.561022+00	2026-05-14 16:45:43.561662+00	2026-05-14 16:45:43.561662+00	d5dc8de6-8d75-45d5-a337-a4e78ea2365d
c0552665-ee77-4406-a8a0-c1cdee93600e	c0552665-ee77-4406-a8a0-c1cdee93600e	{"sub": "c0552665-ee77-4406-a8a0-c1cdee93600e", "email": "imnimisha@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-05-16 16:06:32.744809+00	2026-05-16 16:06:32.745506+00	2026-05-16 16:06:32.745506+00	c40166ff-09b7-48fa-98b8-2b8cde2c5a60
\.


--
-- TOC entry 4660 (class 0 OID 16522)
-- Dependencies: 354
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4667 (class 0 OID 16774)
-- Dependencies: 364
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
68b065c2-d653-4753-9fb1-52f894531813	2026-05-01 17:06:58.638671+00	2026-05-01 17:06:58.638671+00	password	ca9726d3-536c-4c46-a59f-bd887b848f5f
f9a4ae0d-90e8-47cc-8384-242173e7a4bc	2026-05-12 12:38:24.462155+00	2026-05-12 12:38:24.462155+00	password	8081c965-2a71-4c3e-b18b-82ad48c44c9a
3bb7a89d-0995-41a6-a55c-00614422a854	2026-05-12 16:12:36.158088+00	2026-05-12 16:12:36.158088+00	password	0466a5b4-41bf-43f5-ae79-7826e59d2969
c4c50d6c-8b41-4870-874a-b9bf3a6d87fa	2026-05-12 17:48:06.07607+00	2026-05-12 17:48:06.07607+00	password	0334c420-bc56-439d-9d02-64b26661ec71
4582392b-8130-4224-8809-f82a33d12ebc	2026-05-14 16:45:43.664776+00	2026-05-14 16:45:43.664776+00	password	38372ea3-66b8-44aa-82d1-ec2ef77220d6
e26ec90b-5857-4aad-9419-1145defbeee1	2026-05-16 16:06:32.843096+00	2026-05-16 16:06:32.843096+00	password	437b6729-236c-4b18-b478-3e64a55e64e5
9e14fb68-5b5b-4139-bb5a-d0aae643bbd7	2026-05-25 18:53:46.615716+00	2026-05-25 18:53:46.615716+00	password	60bd432b-d84e-49c9-bc53-634776a65bf0
\.


--
-- TOC entry 4666 (class 0 OID 16762)
-- Dependencies: 363
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- TOC entry 4665 (class 0 OID 16749)
-- Dependencies: 362
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- TOC entry 4675 (class 0 OID 16999)
-- Dependencies: 372
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- TOC entry 4677 (class 0 OID 17072)
-- Dependencies: 374
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- TOC entry 4674 (class 0 OID 16969)
-- Dependencies: 371
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- TOC entry 4676 (class 0 OID 17032)
-- Dependencies: 373
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- TOC entry 4673 (class 0 OID 16937)
-- Dependencies: 370
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
61f06305-e046-4084-b0bb-99810da7d6fe	d91fa181-d8f9-4b3f-aebc-896a9d56a286	confirmation_token	956753d9d92b66ad490fcb8f5361b376616e5a79e624f9349e7fdbe4	wm1777568421858@proton.me	2026-04-30 17:00:22.215331	2026-04-30 17:00:22.215331
72533e56-3148-411d-af47-7be002ccf33b	4770a57e-9f74-485f-86a4-c59f5345a005	confirmation_token	db15e86488b93921a71cb4e718ec1c2f6b3a51ab6a72dfe87564ca15	wm1777654969667@proton.me	2026-05-01 17:02:51.29331	2026-05-01 17:02:51.29331
\.


--
-- TOC entry 4659 (class 0 OID 16511)
-- Dependencies: 353
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	1	6gpt4mx5rjqm	59e71244-bc52-406c-8a3c-1659d2ea5027	f	2026-05-01 17:06:58.629345+00	2026-05-01 17:06:58.629345+00	\N	68b065c2-d653-4753-9fb1-52f894531813
00000000-0000-0000-0000-000000000000	2	2ta3mk6vuxge	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-12 12:38:24.447848+00	2026-05-12 13:36:44.122783+00	\N	f9a4ae0d-90e8-47cc-8384-242173e7a4bc
00000000-0000-0000-0000-000000000000	3	glqhjurzmoml	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-12 13:36:44.134898+00	2026-05-12 14:34:46.21638+00	2ta3mk6vuxge	f9a4ae0d-90e8-47cc-8384-242173e7a4bc
00000000-0000-0000-0000-000000000000	4	vpdwcy52z6kg	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-12 14:34:46.225863+00	2026-05-12 16:22:38.473945+00	glqhjurzmoml	f9a4ae0d-90e8-47cc-8384-242173e7a4bc
00000000-0000-0000-0000-000000000000	6	fhj5hoytnwv2	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	f	2026-05-12 16:22:38.483243+00	2026-05-12 16:22:38.483243+00	vpdwcy52z6kg	f9a4ae0d-90e8-47cc-8384-242173e7a4bc
00000000-0000-0000-0000-000000000000	5	e2quuhdavylv	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-12 16:12:36.147436+00	2026-05-12 17:11:05.994344+00	\N	3bb7a89d-0995-41a6-a55c-00614422a854
00000000-0000-0000-0000-000000000000	7	drfhjqay7sw4	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	f	2026-05-12 17:11:06.008234+00	2026-05-12 17:11:06.008234+00	e2quuhdavylv	3bb7a89d-0995-41a6-a55c-00614422a854
00000000-0000-0000-0000-000000000000	8	rn3ujti2uabb	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-12 17:48:06.052055+00	2026-05-12 20:07:57.953467+00	\N	c4c50d6c-8b41-4870-874a-b9bf3a6d87fa
00000000-0000-0000-0000-000000000000	9	4owc5ro2axrs	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-12 20:07:57.966864+00	2026-05-12 21:12:51.312831+00	rn3ujti2uabb	c4c50d6c-8b41-4870-874a-b9bf3a6d87fa
00000000-0000-0000-0000-000000000000	10	2sef6yhpfgq2	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-12 21:12:51.326502+00	2026-05-14 00:24:52.562+00	4owc5ro2axrs	c4c50d6c-8b41-4870-874a-b9bf3a6d87fa
00000000-0000-0000-0000-000000000000	13	wpqrc5zkawek	c0552665-ee77-4406-a8a0-c1cdee93600e	t	2026-05-16 16:06:32.819941+00	2026-05-16 17:49:20.227939+00	\N	e26ec90b-5857-4aad-9419-1145defbeee1
00000000-0000-0000-0000-000000000000	11	syfemokuz3wa	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-14 00:24:52.586258+00	2026-05-22 16:32:52.273913+00	2sef6yhpfgq2	c4c50d6c-8b41-4870-874a-b9bf3a6d87fa
00000000-0000-0000-0000-000000000000	14	7ch3nqmkwogm	c0552665-ee77-4406-a8a0-c1cdee93600e	t	2026-05-16 17:49:20.247159+00	2026-05-22 18:15:24.536694+00	wpqrc5zkawek	e26ec90b-5857-4aad-9419-1145defbeee1
00000000-0000-0000-0000-000000000000	16	atdlputdtawj	c0552665-ee77-4406-a8a0-c1cdee93600e	t	2026-05-22 18:15:24.55028+00	2026-05-22 19:33:05.296256+00	7ch3nqmkwogm	e26ec90b-5857-4aad-9419-1145defbeee1
00000000-0000-0000-0000-000000000000	15	fic464kdqjso	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-22 16:32:52.292143+00	2026-05-22 21:42:43.413536+00	syfemokuz3wa	c4c50d6c-8b41-4870-874a-b9bf3a6d87fa
00000000-0000-0000-0000-000000000000	18	zpj225fy5r2b	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	f	2026-05-22 21:42:43.422756+00	2026-05-22 21:42:43.422756+00	fic464kdqjso	c4c50d6c-8b41-4870-874a-b9bf3a6d87fa
00000000-0000-0000-0000-000000000000	17	zpuffgyfggx5	c0552665-ee77-4406-a8a0-c1cdee93600e	t	2026-05-22 19:33:05.304166+00	2026-05-23 02:26:49.217397+00	atdlputdtawj	e26ec90b-5857-4aad-9419-1145defbeee1
00000000-0000-0000-0000-000000000000	19	2bjeibknoctj	c0552665-ee77-4406-a8a0-c1cdee93600e	t	2026-05-23 02:26:49.233396+00	2026-05-23 05:59:14.760569+00	zpuffgyfggx5	e26ec90b-5857-4aad-9419-1145defbeee1
00000000-0000-0000-0000-000000000000	20	xnqp7h73qtqm	c0552665-ee77-4406-a8a0-c1cdee93600e	f	2026-05-23 05:59:14.769698+00	2026-05-23 05:59:14.769698+00	2bjeibknoctj	e26ec90b-5857-4aad-9419-1145defbeee1
00000000-0000-0000-0000-000000000000	21	mslnobmvtbzr	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-25 18:53:46.585348+00	2026-05-25 23:16:12.351329+00	\N	9e14fb68-5b5b-4139-bb5a-d0aae643bbd7
00000000-0000-0000-0000-000000000000	12	szmglqzvuizv	2fab2f72-ab42-4a79-a110-d6d6591959a1	t	2026-05-14 16:45:43.637981+00	2026-05-26 17:12:39.281629+00	\N	4582392b-8130-4224-8809-f82a33d12ebc
00000000-0000-0000-0000-000000000000	23	bkf7sdt2xiqi	2fab2f72-ab42-4a79-a110-d6d6591959a1	f	2026-05-26 17:12:39.302054+00	2026-05-26 17:12:39.302054+00	szmglqzvuizv	4582392b-8130-4224-8809-f82a33d12ebc
00000000-0000-0000-0000-000000000000	22	qipnk7jvrwap	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-05-25 23:16:12.373628+00	2026-06-04 15:07:06.512019+00	mslnobmvtbzr	9e14fb68-5b5b-4139-bb5a-d0aae643bbd7
00000000-0000-0000-0000-000000000000	24	p5jkj3umflmb	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-06-04 15:07:06.527734+00	2026-06-04 18:04:05.44369+00	qipnk7jvrwap	9e14fb68-5b5b-4139-bb5a-d0aae643bbd7
00000000-0000-0000-0000-000000000000	25	hefksqndioyd	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	t	2026-06-04 18:04:05.462167+00	2026-06-06 13:59:30.091914+00	p5jkj3umflmb	9e14fb68-5b5b-4139-bb5a-d0aae643bbd7
00000000-0000-0000-0000-000000000000	26	gmwws55dpaf7	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	f	2026-06-06 13:59:30.11459+00	2026-06-06 13:59:30.11459+00	hefksqndioyd	9e14fb68-5b5b-4139-bb5a-d0aae643bbd7
\.


--
-- TOC entry 4670 (class 0 OID 16816)
-- Dependencies: 367
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- TOC entry 4671 (class 0 OID 16834)
-- Dependencies: 368
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- TOC entry 4662 (class 0 OID 16537)
-- Dependencies: 356
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
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
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- TOC entry 4664 (class 0 OID 16714)
-- Dependencies: 361
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
68b065c2-d653-4753-9fb1-52f894531813	59e71244-bc52-406c-8a3c-1659d2ea5027	2026-05-01 17:06:58.623675+00	2026-05-01 17:06:58.623675+00	\N	aal1	\N	\N	node	172.125.254.55	\N	\N	\N	\N	\N
f9a4ae0d-90e8-47cc-8384-242173e7a4bc	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	2026-05-12 12:38:24.429104+00	2026-05-12 16:22:38.498209+00	\N	aal1	\N	2026-05-12 16:22:38.498098	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	172.125.254.55	\N	\N	\N	\N	\N
3bb7a89d-0995-41a6-a55c-00614422a854	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	2026-05-12 16:12:36.12598+00	2026-05-12 17:11:06.028254+00	\N	aal1	\N	2026-05-12 17:11:06.028143	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	172.125.254.55	\N	\N	\N	\N	\N
c4c50d6c-8b41-4870-874a-b9bf3a6d87fa	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	2026-05-12 17:48:06.026883+00	2026-05-22 21:42:43.437885+00	\N	aal1	\N	2026-05-22 21:42:43.437772	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36	172.56.66.255	\N	\N	\N	\N	\N
e26ec90b-5857-4aad-9419-1145defbeee1	c0552665-ee77-4406-a8a0-c1cdee93600e	2026-05-16 16:06:32.79177+00	2026-05-23 05:59:14.784226+00	\N	aal1	\N	2026-05-23 05:59:14.784131	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	50.146.57.106	\N	\N	\N	\N	\N
4582392b-8130-4224-8809-f82a33d12ebc	2fab2f72-ab42-4a79-a110-d6d6591959a1	2026-05-14 16:45:43.608057+00	2026-05-26 17:12:39.324902+00	\N	aal1	\N	2026-05-26 17:12:39.324793	Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.166 Mobile/15E148 Safari/604.1	174.220.109.218	\N	\N	\N	\N	\N
9e14fb68-5b5b-4139-bb5a-d0aae643bbd7	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	2026-05-25 18:53:46.547092+00	2026-06-06 13:59:30.146498+00	\N	aal1	\N	2026-06-06 13:59:30.144803	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	97.201.1.109	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4669 (class 0 OID 16801)
-- Dependencies: 366
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4668 (class 0 OID 16792)
-- Dependencies: 365
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- TOC entry 4657 (class 0 OID 16499)
-- Dependencies: 351
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	59e71244-bc52-406c-8a3c-1659d2ea5027	authenticated	authenticated	wm1777655218112@proton.me	$2a$10$c2Ptzb10tPJCYVhTKHYcTOpF1osnLS7oIW4UYUC2CNsImF9EDZUX2	2026-05-01 17:06:58.620446+00	\N		\N		\N			\N	2026-05-01 17:06:58.623573+00	{"provider": "email", "providers": ["email"]}	{"sub": "59e71244-bc52-406c-8a3c-1659d2ea5027", "email": "wm1777655218112@proton.me", "email_verified": true, "phone_verified": false}	\N	2026-05-01 17:06:58.610711+00	2026-05-01 17:06:58.638059+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2fab2f72-ab42-4a79-a110-d6d6591959a1	authenticated	authenticated	jackie.owino@gmail.com	$2a$10$2skW8QJEqBDju0Y10RHz9OvAxi5kaBEa6a/Al6zJVOcn4TP1hQQ1i	2026-05-14 16:45:43.587979+00	\N		\N		\N			\N	2026-05-14 16:45:43.606887+00	{"provider": "email", "providers": ["email"]}	{"sub": "2fab2f72-ab42-4a79-a110-d6d6591959a1", "email": "jackie.owino@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-05-14 16:45:43.523014+00	2026-05-26 17:12:39.313205+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	d91fa181-d8f9-4b3f-aebc-896a9d56a286	authenticated	authenticated	wm1777568421858@proton.me	$2a$10$v1nV/Q8BfR6CAtjtjLa4ZuguXIGiNa.HF1xzdfltVMZzndajRcbVq	\N	\N	956753d9d92b66ad490fcb8f5361b376616e5a79e624f9349e7fdbe4	2026-04-30 17:00:21.847355+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "d91fa181-d8f9-4b3f-aebc-896a9d56a286", "email": "wm1777568421858@proton.me", "email_verified": false, "phone_verified": false}	\N	2026-04-30 17:00:21.843007+00	2026-04-30 17:00:22.206749+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	6ce41223-bd9c-4a7b-9eeb-157ed3f7589d	authenticated	authenticated	jpender95@gmail.com	$2a$10$lHrCJBxOnYKhO1BfN7vv8OlLGs2JNuizD7Gbvx4vLrDhP1xRCu64K	2026-05-12 12:38:24.407837+00	\N		\N		\N			\N	2026-05-25 18:53:46.546033+00	{"provider": "email", "providers": ["email"]}	{"sub": "6ce41223-bd9c-4a7b-9eeb-157ed3f7589d", "email": "jpender95@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-05-12 12:38:24.350275+00	2026-06-06 13:59:30.127216+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-111111111111	authenticated	authenticated	reviewer@wisermoms.app	$2a$06$3dBgJxVKxALeKAAVAl1aee0RAptTO6Q5EMQ5PEG6b1ewABBo97gpm	2026-05-22 17:28:41.500161+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{"last_name": "Reviewer", "first_name": "Demo"}	\N	2026-05-22 17:28:41.500161+00	2026-05-22 17:28:41.500161+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4770a57e-9f74-485f-86a4-c59f5345a005	authenticated	authenticated	wm1777654969667@proton.me	$2a$10$0RYGSyK4XpBYEVjcBFJl.uivsVkfoU2rDFEhBiCE.9L.czjMKyagu	\N	\N	db15e86488b93921a71cb4e718ec1c2f6b3a51ab6a72dfe87564ca15	2026-05-01 17:02:50.892839+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "4770a57e-9f74-485f-86a4-c59f5345a005", "email": "wm1777654969667@proton.me", "email_verified": false, "phone_verified": false}	\N	2026-05-01 17:02:50.821131+00	2026-05-01 17:02:51.276264+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c0552665-ee77-4406-a8a0-c1cdee93600e	authenticated	authenticated	imnimisha@gmail.com	$2a$10$f9eZuT1m67/7aYWi6a.N..VTx2Bp6WHn0dgKtTmR.ieDKF8rc5Rpy	2026-05-16 16:06:32.770786+00	\N		\N		\N			\N	2026-05-16 16:06:32.790575+00	{"provider": "email", "providers": ["email"]}	{"sub": "c0552665-ee77-4406-a8a0-c1cdee93600e", "email": "imnimisha@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-05-16 16:06:32.70354+00	2026-05-23 05:59:14.772555+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- TOC entry 4680 (class 0 OID 17147)
-- Dependencies: 377
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- TOC entry 4679 (class 0 OID 17124)
-- Dependencies: 376
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- TOC entry 4721 (class 0 OID 27567)
-- Dependencies: 422
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
26f6ebd7-712d-461c-9709-2ca266ae9f0b	7795824e4c78dc5378e3a36e404c482c22b113e03d78025d2fe12eb6ffb4425e	2026-06-09 19:34:42.841813+00	20250610120000_init		\N	2026-06-09 19:34:42.841813+00	0
02557531-9f82-41d0-8a2b-740b49a900a4	f646d17b5aa03a5ea197d662d8314f39d95dd82c097a840a71efea4c80e7b781	2026-06-10 17:49:51.957378+00	20250610130000_add_pdf_quarter_year	\N	\N	2026-06-10 17:49:50.611563+00	1
241c93d0-e0d2-4c52-9307-6b56e0d77654	0cace7efeddd1973bd75816d01e68a144fa4b147a7f9cedf6b0447657b3373cd	2026-06-11 18:10:11.448249+00	20250611120000_billing_subscriptions	\N	\N	2026-06-11 18:10:09.792976+00	1
\.


--
-- TOC entry 4709 (class 0 OID 26992)
-- Dependencies: 410
-- Data for Name: account_deletion_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.account_deletion_requests (id, user_id, requested_at, completed_at, status, error_message) FROM stdin;
\.


--
-- TOC entry 4710 (class 0 OID 27001)
-- Dependencies: 411
-- Data for Name: application_guides; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.application_guides (id, program_id, guide_name, overview, apply_url, phone, last_verified, source_url, created_at, state) FROM stdin;
a1000001-0000-0000-0000-000000000001	snap_tx	How to Apply for SNAP Food Benefits in Texas	Step-by-step guide to applying for SNAP (food stamps) through the Your Texas Benefits portal. Covers eligibility screening, document upload, and the required phone interview.	https://www.yourtexasbenefits.com	1-877-541-7905	2026-06-06	\N	2026-06-07 00:37:13.880085+00	TX
a1000001-0000-0000-0000-000000000002	wic_tx	How to Apply for WIC in Texas	Step-by-step guide to enrolling in Texas WIC for nutrition benefits, breastfeeding support, and food assistance for pregnant women and children under 5.	https://www.texaswic.org/apply	1-800-942-3678	2026-06-06	\N	2026-06-07 00:37:13.880085+00	TX
a1000001-0000-0000-0000-000000000003	tanf_tx	How to Apply for TANF Cash Help in Texas	Step-by-step guide to applying for temporary cash assistance through the Your Texas Benefits portal, including asset declarations and the Personal Responsibility Agreement.	https://www.yourtexasbenefits.com	1-877-541-7905	2026-06-06	\N	2026-06-07 00:37:13.880085+00	TX
a1000001-0000-0000-0000-000000000004	medicaid_tx	How to Apply for Medicaid in Texas	Step-by-step guide to applying for Medicaid coverage in Texas for pregnant women, children, and eligible parents through the Your Texas Benefits portal.	https://www.yourtexasbenefits.com	1-877-541-7905	2026-06-06	\N	2026-06-07 00:37:13.880085+00	TX
a1000001-0000-0000-0000-000000000005	childcare_tx	How to Apply for Child Care Services in Texas	Step-by-step guide to applying for state-subsidized childcare through the Texas Workforce Commission and your local workforce board.	https://www.twc.texas.gov/programs/childcare	1-800-628-5115	2026-06-06	\N	2026-06-07 00:37:13.880085+00	TX
a1000001-0000-0000-0000-000000000006	liheap_tx	How to Apply for CEAP Energy Assistance in Texas	Step-by-step guide to applying for utility bill assistance through the Texas Comprehensive Energy Assistance Program via local Community Action Agencies.	https://www.tdhca.texas.gov/community-action-partners	1-877-399-8939	2026-06-06	\N	2026-06-07 00:37:13.880085+00	TX
a1000001-0000-0000-0000-000000000007	childsupport_tx	How to Apply for Child Support Services in Texas	Step-by-step guide to establishing paternity and securing child support orders through the Texas Office of the Attorney General.	https://www.texasattorneygeneral.gov/child-support	1-800-252-8014	2026-06-06	\N	2026-06-07 00:37:13.880085+00	TX
a2000002-0000-0000-0000-000000000001	snap_ca	How to Apply for CalFresh in California	Step-by-step guide to applying for CalFresh food benefits through BenefitsCal. Covers account creation, the online application, and the required phone interview.	https://www.benefitscal.com	1-877-847-3663	2026-06-06	\N	2026-06-07 00:37:13.880085+00	CA
a2000002-0000-0000-0000-000000000002	wic_ca	How to Apply for WIC in California	Step-by-step guide to enrolling in California WIC through the mobile registration portal and scheduling your clinic intake appointment.	https://myfamily.wic.ca.gov	1-888-942-9675	2026-06-06	\N	2026-06-07 00:37:13.880085+00	CA
a2000002-0000-0000-0000-000000000003	tanf_ca	How to Apply for CalWORKs in California	Step-by-step guide to applying for CalWORKs cash assistance and Welfare-to-Work services through BenefitsCal and your county social services office.	https://www.benefitscal.com	1-877-410-8809	2026-06-06	\N	2026-06-07 00:37:13.880085+00	CA
a2000002-0000-0000-0000-000000000004	medicaid_ca	How to Apply for Medi-Cal in California	Step-by-step guide to applying for Medi-Cal health coverage through BenefitsCal or Covered California.	https://www.benefitscal.com	1-800-541-5555	2026-06-06	\N	2026-06-07 00:37:13.880085+00	CA
a3000003-0000-0000-0000-000000000001	snap_fl	How to Apply for Food Assistance in Florida	Step-by-step guide to applying for SNAP food benefits through the ACCESS Florida online portal.	https://www.myflfamilies.com	1-850-300-4323	2026-06-06	\N	2026-06-07 00:37:13.880085+00	FL
a3000003-0000-0000-0000-000000000002	medicaid_fl	How to Apply for ACCESS Florida Medicaid	Step-by-step guide to applying for Medicaid health coverage in Florida, including guidance on non-expanded eligibility categories.	https://www.myflfamilies.com	1-850-300-4323	2026-06-06	\N	2026-06-07 00:37:13.880085+00	FL
a3000003-0000-0000-0000-000000000003	tanf_fl	How to Apply for Temporary Cash Assistance in Florida	Step-by-step guide to applying for TCA cash assistance through ACCESS Florida, including asset limits and work registration requirements.	https://www.myflfamilies.com	1-850-300-4323	2026-06-06	\N	2026-06-07 00:37:13.880085+00	FL
a4000004-0000-0000-0000-000000000001	snap_ny	How to Apply for SNAP in New York	Step-by-step guide to applying for SNAP food benefits through the myBenefits NY portal, covering the online application and required phone or in-person interview.	https://www.mybenefits.ny.gov	1-800-342-3009	2026-06-06	\N	2026-06-07 00:37:13.880085+00	NY
a4000004-0000-0000-0000-000000000002	medicaid_ny	How to Apply for NY State of Health Medicaid	Step-by-step guide to enrolling in New York Medicaid through the NY State of Health marketplace, including ACA expansion eligibility.	https://nystateofhealth.ny.gov	1-855-355-5777	2026-06-06	\N	2026-06-07 00:37:13.880085+00	NY
a4000004-0000-0000-0000-000000000003	tanf_ny	How to Apply for Family Assistance in New York	Step-by-step guide to applying for New York Family Assistance cash aid through myBenefits, including the mandatory in-person county DSS interview.	https://www.mybenefits.ny.gov	1-800-342-3009	2026-06-06	\N	2026-06-07 00:37:13.880085+00	NY
a5000005-0000-0000-0000-000000000001	snap_il	How to Apply for Food Assistance in Illinois	Step-by-step guide to applying for SNAP food assistance (Illinois Link card) through the ABE online portal.	https://abe.illinois.gov	1-800-843-6154	2026-06-06	\N	2026-06-07 00:37:13.880085+00	IL
a5000005-0000-0000-0000-000000000002	medicaid_il	How to Apply for Illinois Medicaid	Step-by-step guide to enrolling in Illinois Medicaid through the ABE portal, including ACA expansion eligibility at 138% FPL.	https://abe.illinois.gov	1-800-226-0768	2026-06-06	\N	2026-06-07 00:37:13.880085+00	IL
a5000005-0000-0000-0000-000000000003	tanf_il	How to Apply for TANF Cash Assistance in Illinois	Step-by-step guide to applying for TANF cash assistance in Illinois through the ABE portal and completing the Responsibility and Services Plan.	https://abe.illinois.gov	1-800-843-6154	2026-06-06	\N	2026-06-07 00:37:13.880085+00	IL
\.


--
-- TOC entry 4702 (class 0 OID 26926)
-- Dependencies: 403
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.applications (id, user_id, program_id, status, submitted_at, last_updated_at, notes, assigned_admin_id, priority, pdf_generated, created_at, updated_at) FROM stdin;
2e2a5850-d6c1-4eb8-992e-59cb48617333	55b28a2d-ac96-4dff-b111-ca4338daebb0	ccdf	draft	\N	2026-05-30 12:57:42.125	\N	\N	normal	f	2026-05-30 12:57:42.125+00	2026-05-30 12:57:42.125+00
087fa83e-f335-4a8a-8e42-3c40b514167e	d63c70ab-4901-4a3b-86db-91f1b21d942e	pell_grant	draft	\N	2026-05-31 14:05:28.449	\N	\N	normal	f	2026-05-31 14:05:28.449+00	2026-05-31 14:05:28.449+00
5e137ded-4a66-4c95-9729-898ee61f6344	316212a7-d942-4fbb-8d19-e6bad5d09df3	ccdf	draft	\N	2026-05-31 22:05:14.427	\N	\N	normal	f	2026-05-31 22:05:14.427+00	2026-05-31 22:05:14.427+00
bfe41128-05a6-4f01-99ed-76a6bd64c620	d63c70ab-4901-4a3b-86db-91f1b21d942e	medicaid	draft	\N	2026-06-01 00:16:22.562	\N	\N	normal	f	2026-06-01 00:16:22.562+00	2026-06-01 00:16:22.562+00
1c8088ee-f020-457b-8ff5-b7c7a9ab8e7b	020a979b-5495-4452-80c9-ef8c5d4a552b	legal_aid	draft	\N	2026-06-02 14:53:07.184	\N	\N	normal	f	2026-06-02 14:53:07.184+00	2026-06-02 14:53:07.184+00
8d978230-a9c5-4e04-a5de-cd65b2e4a68f	020a979b-5495-4452-80c9-ef8c5d4a552b	legal_aid	draft	\N	2026-06-02 14:53:08.476	\N	\N	normal	f	2026-06-02 14:53:08.476+00	2026-06-02 14:53:08.476+00
c6cc222b-bebd-4432-9db8-92f3304e2cd8	020a979b-5495-4452-80c9-ef8c5d4a552b	child_tax_credit	draft	\N	2026-06-02 14:56:37.485	\N	\N	normal	f	2026-06-02 14:56:37.485+00	2026-06-02 14:56:37.485+00
13befec9-eac7-4739-aad9-30b96ffd19b2	10648b38-417c-4511-8d34-d6021f19d2c2	eitc	draft	\N	2026-06-02 15:01:12.681	\N	\N	normal	f	2026-06-02 15:01:12.681+00	2026-06-02 15:01:12.681+00
439e3118-ce6e-4029-826d-0f5c3e185802	020a979b-5495-4452-80c9-ef8c5d4a552b	eitc	draft	\N	2026-06-02 15:04:58.874	\N	\N	normal	f	2026-06-02 15:04:58.874+00	2026-06-02 15:04:58.874+00
1c7c40c9-31b9-4bbd-bc5b-67b9a435527a	020a979b-5495-4452-80c9-ef8c5d4a552b	pell_grant	draft	\N	2026-06-02 15:08:53.745	\N	\N	normal	f	2026-06-02 15:08:53.745+00	2026-06-02 15:08:53.745+00
dda3694d-f874-43db-9dfc-9026a34f1eb3	020a979b-5495-4452-80c9-ef8c5d4a552b	ccdf	draft	\N	2026-06-02 15:12:45.745	\N	\N	normal	f	2026-06-02 15:12:45.745+00	2026-06-02 15:12:45.745+00
2490bd4c-792f-48a4-88c2-4639f397b52a	020a979b-5495-4452-80c9-ef8c5d4a552b	head_start	draft	\N	2026-06-02 15:19:12.678	\N	\N	normal	f	2026-06-02 15:19:12.678+00	2026-06-02 15:19:12.678+00
c01979aa-9db8-4bd7-ba91-64fb697ed018	020a979b-5495-4452-80c9-ef8c5d4a552b	liheap	draft	\N	2026-06-02 15:30:25.751	\N	\N	normal	f	2026-06-02 15:30:25.751+00	2026-06-02 15:30:25.751+00
379795c8-0350-4f8d-9e7a-982afd261ee9	020a979b-5495-4452-80c9-ef8c5d4a552b	lifeline	draft	\N	2026-06-02 15:36:00.949	\N	\N	normal	f	2026-06-02 15:36:00.949+00	2026-06-02 15:36:00.949+00
2b3dcbec-074b-4f68-8fa1-d35e87fd39bf	020a979b-5495-4452-80c9-ef8c5d4a552b	snap	draft	\N	2026-06-02 17:12:20.053	\N	\N	normal	f	2026-06-02 17:12:20.053+00	2026-06-02 17:12:20.053+00
4c506eaa-c3a9-41c0-8b82-98d090a36371	020a979b-5495-4452-80c9-ef8c5d4a552b	medicaid	draft	\N	2026-06-03 05:22:28.202	\N	\N	normal	f	2026-06-03 05:22:28.202+00	2026-06-03 05:22:28.202+00
59f004ae-6894-4507-9ea6-02f45ea49fa3	99377481-f483-4c4c-afdf-bf3ece076349	snap	draft	\N	2026-06-04 13:05:07.34	\N	\N	normal	f	2026-06-04 13:05:07.34+00	2026-06-04 13:05:07.34+00
e88e3711-7f28-42e6-a265-f977713377e3	99377481-f483-4c4c-afdf-bf3ece076349	medicaid	draft	\N	2026-06-04 13:05:19.896	\N	\N	normal	f	2026-06-04 13:05:19.896+00	2026-06-04 13:05:19.896+00
5cc0dbe4-9c84-4333-b706-1615bcb057b4	99377481-f483-4c4c-afdf-bf3ece076349	ccdf	draft	\N	2026-06-04 13:05:31.996	\N	\N	normal	f	2026-06-04 13:05:31.996+00	2026-06-04 13:05:31.996+00
50a69e29-b0bf-4ca8-b3f1-0e9aa974c231	99377481-f483-4c4c-afdf-bf3ece076349	section8	draft	\N	2026-06-04 13:05:44.485	\N	\N	normal	f	2026-06-04 13:05:44.485+00	2026-06-04 13:05:44.485+00
3b143b65-8f4e-4a51-9578-98073918eadd	99377481-f483-4c4c-afdf-bf3ece076349	liheap	draft	\N	2026-06-04 13:05:56.582	\N	\N	normal	f	2026-06-04 13:05:56.582+00	2026-06-04 13:05:56.582+00
f26c650b-a903-49df-a400-18051f735ca3	99377481-f483-4c4c-afdf-bf3ece076349	eitc	draft	\N	2026-06-04 13:06:08.987	\N	\N	normal	f	2026-06-04 13:06:08.987+00	2026-06-04 13:06:08.987+00
6a99c3d8-1ea4-4e5c-b45e-3a26691cea50	99377481-f483-4c4c-afdf-bf3ece076349	child_tax_credit	draft	\N	2026-06-04 13:06:21.727	\N	\N	normal	f	2026-06-04 13:06:21.727+00	2026-06-04 13:06:21.727+00
f8b13a67-bfdb-49d2-a6ab-90784c99f6a8	99377481-f483-4c4c-afdf-bf3ece076349	pell_grant	draft	\N	2026-06-04 13:06:34.833	\N	\N	normal	f	2026-06-04 13:06:34.833+00	2026-06-04 13:06:34.833+00
b1aa0f97-db64-4838-830f-37ab8a24b5c5	99377481-f483-4c4c-afdf-bf3ece076349	head_start	draft	\N	2026-06-04 13:06:47.837	\N	\N	normal	f	2026-06-04 13:06:47.837+00	2026-06-04 13:06:47.837+00
5af2d475-0448-41b1-8efc-2042dd3fda83	99377481-f483-4c4c-afdf-bf3ece076349	lifeline	draft	\N	2026-06-04 13:07:00.911	\N	\N	normal	f	2026-06-04 13:07:00.911+00	2026-06-04 13:07:00.911+00
989f72c9-83f9-4a63-917d-8a2a4011c1bc	99377481-f483-4c4c-afdf-bf3ece076349	tanf	draft	\N	2026-06-04 13:07:13.918	\N	\N	normal	f	2026-06-04 13:07:13.918+00	2026-06-04 13:07:13.918+00
fcfa9fcc-d1de-4307-a90e-3303d9238e97	99377481-f483-4c4c-afdf-bf3ece076349	legal_aid	draft	\N	2026-06-04 13:07:27.217	\N	\N	normal	f	2026-06-04 13:07:27.217+00	2026-06-04 13:07:27.217+00
973940a4-3a56-4683-bfac-3fc228c5e9f3	99377481-f483-4c4c-afdf-bf3ece076349	tanf	draft	\N	2026-06-04 13:10:15.648	\N	\N	normal	f	2026-06-04 13:10:15.648+00	2026-06-04 13:10:15.648+00
8016e417-ffd4-4853-b4b3-7e2b4ce7e6aa	b7f6902d-d0fe-4c69-ac1f-51faf9245226	snap	draft	\N	2026-06-05 04:11:10.536	\N	\N	normal	f	2026-06-05 04:11:10.536+00	2026-06-05 04:11:10.536+00
a3e545ff-4225-4fa2-84f6-55ab68d04dfc	b7f6902d-d0fe-4c69-ac1f-51faf9245226	medicaid	draft	\N	2026-06-05 04:11:24.216	\N	\N	normal	f	2026-06-05 04:11:24.216+00	2026-06-05 04:11:24.216+00
8bec9ec9-a26c-4838-b62b-034b1ea0349d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8	draft	\N	2026-06-05 04:11:37.184	\N	\N	normal	f	2026-06-05 04:11:37.184+00	2026-06-05 04:11:37.184+00
e23656c5-c471-468f-9f24-4c7c3e8fd5b5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	liheap	draft	\N	2026-06-05 04:11:50.286	\N	\N	normal	f	2026-06-05 04:11:50.286+00	2026-06-05 04:11:50.286+00
28fc7fce-2279-4de4-9f69-843c9bb8506c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-05 04:12:03.419	\N	\N	normal	f	2026-06-05 04:12:03.419+00	2026-06-05 04:12:03.419+00
fa95ed66-5890-41fc-86c9-79c796d8b560	b7f6902d-d0fe-4c69-ac1f-51faf9245226	pell_grant	draft	\N	2026-06-05 04:12:16.42	\N	\N	normal	f	2026-06-05 04:12:16.42+00	2026-06-05 04:12:16.42+00
5bc5ceda-e6f5-4d5d-946c-60f525d07e60	b7f6902d-d0fe-4c69-ac1f-51faf9245226	lifeline	draft	\N	2026-06-05 04:12:28.516	\N	\N	normal	f	2026-06-05 04:12:28.516+00	2026-06-05 04:12:28.516+00
b2222510-e320-4210-809e-21bc3fd72513	b7f6902d-d0fe-4c69-ac1f-51faf9245226	legal_aid	draft	\N	2026-06-05 04:12:40.218	\N	\N	normal	f	2026-06-05 04:12:40.218+00	2026-06-05 04:12:40.218+00
9984654d-424a-497f-86f5-4bf6ac0bd662	b7f6902d-d0fe-4c69-ac1f-51faf9245226	legal_aid	draft	\N	2026-06-05 04:14:18.006	\N	\N	normal	f	2026-06-05 04:14:18.006+00	2026-06-05 04:14:18.006+00
f71b6345-96bf-4fa0-9108-80446d014e7b	b2fde45d-108b-400a-9b65-e42184ed68a2	snap	draft	\N	2026-06-08 14:22:30.86	\N	\N	normal	f	2026-06-08 14:22:30.86+00	2026-06-08 14:22:30.86+00
07f6841d-4774-4fe7-83f6-02b96ed0d009	b2fde45d-108b-400a-9b65-e42184ed68a2	wic	draft	\N	2026-06-08 14:22:44.332	\N	\N	normal	f	2026-06-08 14:22:44.332+00	2026-06-08 14:22:44.332+00
d6d1d4ba-29cf-4cda-99e4-5e32da32eff3	b2fde45d-108b-400a-9b65-e42184ed68a2	medicaid	draft	\N	2026-06-08 14:22:57.012	\N	\N	normal	f	2026-06-08 14:22:57.012+00	2026-06-08 14:22:57.012+00
a84b94e5-4e49-4f4f-93aa-a800d2b40568	b2fde45d-108b-400a-9b65-e42184ed68a2	ccdf	draft	\N	2026-06-08 14:23:09.501	\N	\N	normal	f	2026-06-08 14:23:09.501+00	2026-06-08 14:23:09.501+00
3fdd21af-83e9-4d9f-9574-77fe69c50fe9	b2fde45d-108b-400a-9b65-e42184ed68a2	section8	draft	\N	2026-06-08 14:23:22.397	\N	\N	normal	f	2026-06-08 14:23:22.397+00	2026-06-08 14:23:22.397+00
d3f9a0f2-68a0-4fdf-913e-420c8753b1ae	b2fde45d-108b-400a-9b65-e42184ed68a2	liheap	draft	\N	2026-06-08 14:23:35.708	\N	\N	normal	f	2026-06-08 14:23:35.708+00	2026-06-08 14:23:35.708+00
c6318ee6-f43b-4fbd-8218-9c24f531704b	b2fde45d-108b-400a-9b65-e42184ed68a2	child_tax_credit	draft	\N	2026-06-08 14:23:45.598	\N	\N	normal	f	2026-06-08 14:23:45.598+00	2026-06-08 14:23:45.598+00
f04bfeff-fe3e-4ddb-b58b-e41d9bd784f6	b2fde45d-108b-400a-9b65-e42184ed68a2	child_tax_credit	draft	\N	2026-06-08 14:23:47.461	\N	\N	normal	f	2026-06-08 14:23:47.461+00	2026-06-08 14:23:47.461+00
9520ee12-d006-4a81-a3a7-31498e8afa92	b2fde45d-108b-400a-9b65-e42184ed68a2	eitc	draft	\N	2026-06-08 14:23:48.315	\N	\N	normal	f	2026-06-08 14:23:48.315+00	2026-06-08 14:23:48.315+00
c23bacee-d1dd-464b-b0b7-f44c5b83fd03	b2fde45d-108b-400a-9b65-e42184ed68a2	pell_grant	draft	\N	2026-06-08 14:24:12.022	\N	\N	normal	f	2026-06-08 14:24:12.022+00	2026-06-08 14:24:12.022+00
575ac081-c411-45b8-8953-b6df5faa1e13	b2fde45d-108b-400a-9b65-e42184ed68a2	head_start	draft	\N	2026-06-08 14:24:24.121	\N	\N	normal	f	2026-06-08 14:24:24.121+00	2026-06-08 14:24:24.121+00
537e1ef0-e08f-4554-902b-e459a19cfe3b	b2fde45d-108b-400a-9b65-e42184ed68a2	lifeline	draft	\N	2026-06-08 14:24:36.712	\N	\N	normal	f	2026-06-08 14:24:36.712+00	2026-06-08 14:24:36.712+00
31636b41-1f19-46f5-893f-789c2c38297b	b2fde45d-108b-400a-9b65-e42184ed68a2	tanf	draft	\N	2026-06-08 14:24:50.211	\N	\N	normal	f	2026-06-08 14:24:50.211+00	2026-06-08 14:24:50.211+00
bf794610-1d75-4b8e-b160-9fea9c61e36b	b2fde45d-108b-400a-9b65-e42184ed68a2	legal_aid	draft	\N	2026-06-08 14:25:02.265	\N	\N	normal	f	2026-06-08 14:25:02.265+00	2026-06-08 14:25:02.265+00
17238901-8f00-470f-b69f-3d6f15f3b99c	c4966c51-a590-485c-bf82-0d699e087ab8	snap	draft	\N	2026-06-09 03:40:26.627	\N	\N	normal	f	2026-06-09 03:40:26.627+00	2026-06-09 03:40:26.627+00
59e00f73-3ac4-409e-9d1a-8bc2a4a63eb7	c4966c51-a590-485c-bf82-0d699e087ab8	medicaid	draft	\N	2026-06-09 03:40:39.664	\N	\N	normal	f	2026-06-09 03:40:39.664+00	2026-06-09 03:40:39.664+00
d848a1fa-edbe-438f-90a6-a8ce69ed7a2e	c4966c51-a590-485c-bf82-0d699e087ab8	section8	draft	\N	2026-06-09 03:40:52.362	\N	\N	normal	f	2026-06-09 03:40:52.362+00	2026-06-09 03:40:52.362+00
b79b4c04-f7f8-469e-945e-e1e2c917e031	c4966c51-a590-485c-bf82-0d699e087ab8	liheap	draft	\N	2026-06-09 03:41:04.857	\N	\N	normal	f	2026-06-09 03:41:04.857+00	2026-06-09 03:41:04.857+00
1253871f-1225-4faf-bde1-26d2cd1902d6	c4966c51-a590-485c-bf82-0d699e087ab8	eitc	draft	\N	2026-06-09 03:41:17.744	\N	\N	normal	f	2026-06-09 03:41:17.744+00	2026-06-09 03:41:17.744+00
0ea3d64b-5685-453e-9564-568bd28821ad	c4966c51-a590-485c-bf82-0d699e087ab8	pell_grant	draft	\N	2026-06-09 03:41:30.447	\N	\N	normal	f	2026-06-09 03:41:30.447+00	2026-06-09 03:41:30.447+00
dd01f3e2-1c4e-4751-bf00-0783b1a32e32	c4966c51-a590-485c-bf82-0d699e087ab8	lifeline	draft	\N	2026-06-09 03:41:43.362	\N	\N	normal	f	2026-06-09 03:41:43.362+00	2026-06-09 03:41:43.362+00
9cbebbd0-d890-4978-b5cc-5fdfe3227a49	c4966c51-a590-485c-bf82-0d699e087ab8	legal_aid	draft	\N	2026-06-09 03:41:55.751	\N	\N	normal	f	2026-06-09 03:41:55.751+00	2026-06-09 03:41:55.751+00
49fd446e-4278-4ea3-b986-b7625e9db6ae	c4966c51-a590-485c-bf82-0d699e087ab8	pell_grant	draft	\N	2026-06-09 03:43:16.836	\N	\N	normal	f	2026-06-09 03:43:16.836+00	2026-06-09 03:43:16.836+00
d95b60a5-70cd-4ab5-9c80-1f122cb3ce56	ad89b347-7133-4c28-b420-0c6601fc139f	snap	draft	\N	2026-06-09 05:39:00.775	\N	\N	normal	f	2026-06-09 05:39:00.775+00	2026-06-09 05:39:00.775+00
816e4be9-2a2c-4f38-9ea3-8db80f6688d9	ad89b347-7133-4c28-b420-0c6601fc139f	medicaid	draft	\N	2026-06-09 05:39:12.742	\N	\N	normal	f	2026-06-09 05:39:12.742+00	2026-06-09 05:39:12.742+00
82b08d0f-73f8-4e1b-8aef-f853ab02ab35	ad89b347-7133-4c28-b420-0c6601fc139f	section8	draft	\N	2026-06-09 05:39:24.806	\N	\N	normal	f	2026-06-09 05:39:24.806+00	2026-06-09 05:39:24.806+00
0537806c-a3c0-44be-aed6-9e79a818e62e	ad89b347-7133-4c28-b420-0c6601fc139f	liheap	draft	\N	2026-06-09 05:39:37.298	\N	\N	normal	f	2026-06-09 05:39:37.298+00	2026-06-09 05:39:37.298+00
9b11b0a0-90d4-46b7-8ca9-a050b987af24	ad89b347-7133-4c28-b420-0c6601fc139f	eitc	draft	\N	2026-06-09 05:39:49.997	\N	\N	normal	f	2026-06-09 05:39:49.997+00	2026-06-09 05:39:49.997+00
ca6c10e3-89b8-4892-951b-630edd216fe3	ad89b347-7133-4c28-b420-0c6601fc139f	pell_grant	draft	\N	2026-06-09 05:40:02.483	\N	\N	normal	f	2026-06-09 05:40:02.483+00	2026-06-09 05:40:02.483+00
d0f968d4-b559-4244-97ab-c2920c2662d0	ad89b347-7133-4c28-b420-0c6601fc139f	lifeline	draft	\N	2026-06-09 05:40:15.298	\N	\N	normal	f	2026-06-09 05:40:15.298+00	2026-06-09 05:40:15.298+00
57bac84e-3e08-4bfd-abc2-1f2202b3feac	ad89b347-7133-4c28-b420-0c6601fc139f	legal_aid	draft	\N	2026-06-09 05:40:27.798	\N	\N	normal	f	2026-06-09 05:40:27.798+00	2026-06-09 05:40:27.798+00
db31dd02-d5f9-40ef-99dc-86da9506b59f	dcf8d6a3-0282-402d-b40f-95ad3b24be73	snap	draft	\N	2026-06-09 05:58:04.539	\N	\N	normal	f	2026-06-09 05:58:04.539+00	2026-06-09 05:58:04.539+00
bd9bf8d6-d399-424a-b316-03452eaf3280	dcf8d6a3-0282-402d-b40f-95ad3b24be73	wic	draft	\N	2026-06-09 05:58:17.197	\N	\N	normal	f	2026-06-09 05:58:17.197+00	2026-06-09 05:58:17.197+00
cf3c6ffc-89f5-4ba7-b7f7-5ead9c7200ca	dcf8d6a3-0282-402d-b40f-95ad3b24be73	medicaid	draft	\N	2026-06-09 05:58:29.759	\N	\N	normal	f	2026-06-09 05:58:29.759+00	2026-06-09 05:58:29.759+00
f8c50736-69ab-4377-ad2e-5441a46692c5	dcf8d6a3-0282-402d-b40f-95ad3b24be73	ccdf	draft	\N	2026-06-09 05:58:42.206	\N	\N	normal	f	2026-06-09 05:58:42.206+00	2026-06-09 05:58:42.206+00
805508e0-1656-4a7d-bdad-5ab9d1337b49	dcf8d6a3-0282-402d-b40f-95ad3b24be73	section8	draft	\N	2026-06-09 05:58:54.95	\N	\N	normal	f	2026-06-09 05:58:54.95+00	2026-06-09 05:58:54.95+00
1e3d7159-e3e4-4660-b2c8-6c41617e665e	dcf8d6a3-0282-402d-b40f-95ad3b24be73	liheap	draft	\N	2026-06-09 05:59:07.551	\N	\N	normal	f	2026-06-09 05:59:07.551+00	2026-06-09 05:59:07.551+00
2d8aaa4d-46ec-475e-84c5-3da13beeeb48	dcf8d6a3-0282-402d-b40f-95ad3b24be73	tanf	draft	\N	2026-06-09 05:59:12.051	\N	\N	normal	f	2026-06-09 05:59:12.051+00	2026-06-09 05:59:12.051+00
9282f6b8-4b3a-4811-a836-18155d226bbf	dcf8d6a3-0282-402d-b40f-95ad3b24be73	tanf	draft	\N	2026-06-09 05:59:14.296	\N	\N	normal	f	2026-06-09 05:59:14.296+00	2026-06-09 05:59:14.296+00
371d3e7b-85bb-4065-b780-b5da201e32cc	dcf8d6a3-0282-402d-b40f-95ad3b24be73	eitc	draft	\N	2026-06-09 05:59:19.945	\N	\N	normal	f	2026-06-09 05:59:19.945+00	2026-06-09 05:59:19.945+00
e9b6313c-7405-4e7f-82f9-d8acc5161964	dcf8d6a3-0282-402d-b40f-95ad3b24be73	child_tax_credit	draft	\N	2026-06-09 05:59:32.435	\N	\N	normal	f	2026-06-09 05:59:32.435+00	2026-06-09 05:59:32.435+00
2e4cebbe-c277-4a86-80e7-84fe194bc139	dcf8d6a3-0282-402d-b40f-95ad3b24be73	pell_grant	draft	\N	2026-06-09 05:59:45.119	\N	\N	normal	f	2026-06-09 05:59:45.119+00	2026-06-09 05:59:45.119+00
7b5e0eec-3c25-4d17-b666-a64cf6ddb8b0	dcf8d6a3-0282-402d-b40f-95ad3b24be73	head_start	draft	\N	2026-06-09 05:59:57.436	\N	\N	normal	f	2026-06-09 05:59:57.436+00	2026-06-09 05:59:57.436+00
de11a01a-2290-4350-ab57-d299983cc8b1	dcf8d6a3-0282-402d-b40f-95ad3b24be73	lifeline	draft	\N	2026-06-09 06:00:10.551	\N	\N	normal	f	2026-06-09 06:00:10.551+00	2026-06-09 06:00:10.551+00
0764db22-1b48-43cb-93b9-50bf76ad867e	dcf8d6a3-0282-402d-b40f-95ad3b24be73	legal_aid	draft	\N	2026-06-09 06:00:34.654	\N	\N	normal	f	2026-06-09 06:00:34.654+00	2026-06-09 06:00:34.654+00
fe7a8ef8-27b7-420e-b49a-5e3592bbecbb	9f96c2cf-298d-4553-a094-a13af906b497	wic	draft	\N	2026-06-09 07:01:35.917	\N	\N	normal	f	2026-06-09 07:01:35.917+00	2026-06-09 07:01:35.917+00
f2fd9b02-c010-4fd3-a64d-adb4691ea773	9f96c2cf-298d-4553-a094-a13af906b497	eitc	draft	\N	2026-06-09 07:01:48.572	\N	\N	normal	f	2026-06-09 07:01:48.572+00	2026-06-09 07:01:48.572+00
ff3ed46e-a8a8-4709-99e4-5c9e32950171	9f96c2cf-298d-4553-a094-a13af906b497	pell_grant	draft	\N	2026-06-09 07:02:01.306	\N	\N	normal	f	2026-06-09 07:02:01.306+00	2026-06-09 07:02:01.306+00
a015205e-9a6a-4511-9517-a3fd116fbd17	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 10:44:19.025	\N	\N	normal	f	2026-06-10 10:44:19.025+00	2026-06-10 10:44:19.025+00
6d87cdd7-8b34-4c80-9e75-0b6747d2c34f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8	draft	\N	2026-06-10 15:36:46.058	\N	\N	normal	f	2026-06-10 15:36:46.058+00	2026-06-10 15:36:46.058+00
40e792ed-6638-4b32-9d62-588767c2e5d8	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 17:52:42.353	\N	\N	normal	f	2026-06-10 17:52:42.353+00	2026-06-10 17:52:42.353+00
104659fd-3bb2-4113-bc76-672e9288a414	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 17:55:33.874	\N	\N	normal	f	2026-06-10 17:55:33.874+00	2026-06-10 17:55:33.874+00
42b9e00c-9de6-4c10-979a-fa8dcf7ac29b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8	draft	\N	2026-06-10 18:00:36.27	\N	\N	normal	f	2026-06-10 18:00:36.27+00	2026-06-10 18:00:36.27+00
63be169f-852d-44bf-af26-b138697b16b5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 18:30:10.117	\N	\N	normal	f	2026-06-10 18:30:10.117+00	2026-06-10 18:30:10.117+00
a33f1acd-3612-4e1f-b4a5-681c86512029	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 18:31:04.39	\N	\N	normal	f	2026-06-10 18:31:04.39+00	2026-06-10 18:31:04.39+00
cb61511c-f798-4946-840e-976199bf0023	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 18:34:15.747	\N	\N	normal	f	2026-06-10 18:34:15.747+00	2026-06-10 18:34:15.747+00
44bdce17-f936-4578-93f5-66407972bb58	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 18:36:54.649	\N	\N	normal	f	2026-06-10 18:36:54.649+00	2026-06-10 18:36:54.649+00
0a11f50e-0192-4aff-8bb0-7e0e34463470	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 18:47:01.105	\N	\N	normal	f	2026-06-10 18:47:01.105+00	2026-06-10 18:47:01.105+00
ccd1701a-5b68-4353-8db0-ef3c59935347	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 18:51:14.503	\N	\N	normal	f	2026-06-10 18:51:14.503+00	2026-06-10 18:51:14.503+00
3590bfaf-8d85-4edb-9124-edfff2e9aed6	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	draft	\N	2026-06-10 19:32:31.657	\N	\N	normal	f	2026-06-10 19:32:31.657+00	2026-06-10 19:32:31.657+00
dfcf6b8b-8987-4a28-9fc5-5d5a133d0feb	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8	draft	\N	2026-06-10 19:39:53.677	\N	\N	normal	f	2026-06-10 19:39:53.677+00	2026-06-10 19:39:53.677+00
64af7f48-7a57-48e8-89f8-c383c200e1a4	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8	draft	\N	2026-06-11 09:25:22.986	\N	\N	normal	f	2026-06-11 09:25:22.986+00	2026-06-11 09:25:22.986+00
46bfe8ce-bcc6-4b7a-a19b-ee5180bfd6b5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8	draft	\N	2026-06-11 09:34:48.111	\N	\N	normal	f	2026-06-11 09:34:48.111+00	2026-06-11 09:34:48.111+00
f4e92d14-befa-4e05-b4ff-1c6e8ab4ffd9	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8	draft	\N	2026-06-11 09:36:04.001	\N	\N	normal	f	2026-06-11 09:36:04.001+00	2026-06-11 09:36:04.001+00
fc395ca2-6519-4494-8179-6639576d59af	b7f6902d-d0fe-4c69-ac1f-51faf9245226	snap	draft	\N	2026-06-11 09:42:32.391	\N	\N	normal	f	2026-06-11 09:42:32.391+00	2026-06-11 09:42:32.391+00
\.


--
-- TOC entry 4712 (class 0 OID 27018)
-- Dependencies: 413
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.appointments (id, user_id, org_id, agency_name, appointment_date, notes, created_at) FROM stdin;
\.


--
-- TOC entry 4707 (class 0 OID 26974)
-- Dependencies: 408
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_logs (id, admin_id, action, target_type, target_id, metadata, created_at) FROM stdin;
\.


--
-- TOC entry 4724 (class 0 OID 27754)
-- Dependencies: 425
-- Data for Name: billing_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.billing_events (id, user_id, event_type, stripe_event_id, payload, created_at) FROM stdin;
\.


--
-- TOC entry 4706 (class 0 OID 26966)
-- Dependencies: 407
-- Data for Name: counselor_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.counselor_sessions (id, user_id, counselor_id, scheduled_at, duration_minutes, status, notes, meeting_url) FROM stdin;
\.


--
-- TOC entry 4705 (class 0 OID 26958)
-- Dependencies: 406
-- Data for Name: deadlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deadlines (id, user_id, application_id, deadline_type, due_date, reminder_sent_at, is_completed) FROM stdin;
\.


--
-- TOC entry 4703 (class 0 OID 26939)
-- Dependencies: 404
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.documents (id, user_id, application_id, document_type, file_name, display_name, storage_path, file_size, mime_type, uploaded_at) FROM stdin;
b73a4035-77ba-40eb-b212-681e2b9b766c	55b28a2d-ac96-4dff-b111-ca4338daebb0	2e2a5850-d6c1-4eb8-992e-59cb48617333	childcare_record	Child_Care_Subsidy_(CCDF)_Package (6).pdf	Child_Care_Subsidy_(CCDF)_Package (6).pdf	/opt/render/project/src/backend/uploads/documents/55b28a2d-ac96-4dff-b111-ca4338daebb0/91b9aa2f-365b-4383-91ed-230782091ea5.pdf	15627	application/pdf	2026-05-30 12:58:07.378+00
603379da-25d0-4553-8f09-bb1dd2183891	d63c70ab-4901-4a3b-86db-91f1b21d942e	087fa83e-f335-4a8a-8e42-3c40b514167e	other	Medicaid_&_CHIP_Package.pdf	Medicaid_&_CHIP_Package.pdf	/opt/render/project/src/backend/uploads/documents/d63c70ab-4901-4a3b-86db-91f1b21d942e/2148e919-ce93-4c87-97b0-a7cb4310d57a.pdf	15360	application/pdf	2026-05-31 14:06:30.341+00
d80f8e70-7294-46a3-ab45-f714b712e91d	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	government_id	slidedeck-7.pdf	slidedeck-7.pdf	/opt/render/project/src/backend/uploads/documents/316212a7-d942-4fbb-8d19-e6bad5d09df3/50eddee2-b4ac-4d2c-ad53-1e611235d93e.pdf	99343	application/pdf	2026-05-31 21:45:54.34+00
83bd50b0-3a44-49c9-8d43-f89c57eeda24	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	government_id	Screenshot 2026-05-13 at 8.52.58â¯AM.png	Screenshot 2026-05-13 at 8.52.58â¯AM.png	/opt/render/project/src/backend/uploads/documents/316212a7-d942-4fbb-8d19-e6bad5d09df3/5c1c2525-02b9-4b63-8b12-4c35664c36f9.png	1449795	image/png	2026-05-31 21:46:22.925+00
e55d71bb-133f-407c-ae03-64450e84da18	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	government_id	Screenshot 2026-05-13 at 8.52.58â¯AM.png	Screenshot 2026-05-13 at 8.52.58â¯AM.png	/opt/render/project/src/backend/uploads/documents/316212a7-d942-4fbb-8d19-e6bad5d09df3/eafa1bed-7d3e-4437-8034-a703f8d308a6.png	1449795	image/png	2026-05-31 22:04:45.617+00
1a3bd53f-0b88-40af-821b-d82cbf96b430	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	government_id	Screenshot 2026-05-13 at 8.50.54â¯AM.png	Screenshot 2026-05-13 at 8.50.54â¯AM.png	/opt/render/project/src/backend/uploads/documents/316212a7-d942-4fbb-8d19-e6bad5d09df3/e81c97ef-a1bd-4b61-ae14-c513a262d9dc.png	633585	image/png	2026-05-31 22:04:54.512+00
372aaeaf-4a76-4f4c-b0a7-398e22ce3a02	10648b38-417c-4511-8d34-d6021f19d2c2	13befec9-eac7-4739-aad9-30b96ffd19b2	proof_of_income	Earned_Income_Tax_Credit_(EITC)_Package (1).pdf	Earned_Income_Tax_Credit_(EITC)_Package (1).pdf	/opt/render/project/src/backend/uploads/documents/10648b38-417c-4511-8d34-d6021f19d2c2/c8c608c3-039f-468a-86e2-8fdadf543aed.pdf	15463	application/pdf	2026-06-02 15:04:53.635+00
a6391aa2-d3ae-49b6-966b-3ea438e30c88	020a979b-5495-4452-80c9-ef8c5d4a552b	dda3694d-f874-43db-9dfc-9026a34f1eb3	other	2023_09_21_034314(1).pdf	2023_09_21_034314(1).pdf	/opt/render/project/src/backend/uploads/documents/020a979b-5495-4452-80c9-ef8c5d4a552b/72456d0f-3c9b-41e9-a44e-21e2662a71fa.pdf	111864	application/pdf	2026-06-02 15:13:41.518+00
97875bbd-99ef-41ab-b5a0-d7a2d31f67ef	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	government_id	2023_09_21_034314(1) (1).pdf	2023_09_21_034314(1) (1).pdf	/opt/render/project/src/backend/uploads/documents/020a979b-5495-4452-80c9-ef8c5d4a552b/ed16448a-376b-43d7-a401-2857ffb4b496.pdf	111864	application/pdf	2026-06-02 15:14:43.396+00
82456fe6-ae18-4a00-af5a-616967869dec	10648b38-417c-4511-8d34-d6021f19d2c2	13befec9-eac7-4739-aad9-30b96ffd19b2	proof_of_income	Earned_Income_Tax_Credit_(EITC)_Package (1).pdf	Earned_Income_Tax_Credit_(EITC)_Package (1).pdf	/opt/render/project/src/backend/uploads/documents/10648b38-417c-4511-8d34-d6021f19d2c2/970dd896-ac96-4f08-b56e-c102b6cdd22c.pdf	15463	application/pdf	2026-06-02 16:31:57.12+00
eabe1e47-666b-4223-85df-9c1918af0ec5	b2fde45d-108b-400a-9b65-e42184ed68a2	\N	government_id	2023_09_21_034314(1).pdf	2023_09_21_034314(1).pdf	/opt/render/project/src/backend/uploads/documents/b2fde45d-108b-400a-9b65-e42184ed68a2/05ef13e1-4703-490e-9137-04b0d2b19d24.pdf	111864	application/pdf	2026-06-08 14:27:53.954+00
d9a5a3ac-f8ce-47c3-b44d-e294a2687def	b7f6902d-d0fe-4c69-ac1f-51faf9245226	\N	government_id	2023_09_21_034314(1).pdf	2023_09_21_034314(1).pdf	/opt/render/project/src/backend/uploads/documents/b7f6902d-d0fe-4c69-ac1f-51faf9245226/676add12-1d8a-4966-988c-b78f0d7b31d6.pdf	111864	application/pdf	2026-06-08 15:00:25.262+00
856700f6-9c5e-4a6c-9afd-608a5887de92	9f96c2cf-298d-4553-a094-a13af906b497	\N	government_id	sample.pdf	sample.pdf	/opt/render/project/src/backend/uploads/documents/9f96c2cf-298d-4553-a094-a13af906b497/963f3520-7bb8-40c7-9f22-337913e2b956.pdf	18810	application/pdf	2026-06-09 07:17:21.259+00
f27d2749-da8f-4660-a6cd-c202d1fb9e5c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	40e792ed-6638-4b32-9d62-588767c2e5d8	application_package	generated_pdf:e2e42eb5-b2c2-42da-a9da-7cbc21d80330	Earned_Income_Tax_Credit_(EITC)_Package_Q1_2026_v1.pdf	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/e2e42eb5-b2c2-42da-a9da-7cbc21d80330.pdf	9154	application/pdf	2026-06-10 19:32:35.178+00
6cde350e-60b1-4961-ab00-bdebb619dd8f	dcf8d6a3-0282-402d-b40f-95ad3b24be73	\N	government_id	sterling-accuris-pathology-sample-report-unlocked.pdf	sterling-accuris-pathology-sample-report-unlocked.pdf	/opt/render/project/src/backend/uploads/documents/dcf8d6a3-0282-402d-b40f-95ad3b24be73/abd6db5e-6f85-4f45-b964-b584b94291fd.pdf	6908257	application/pdf	2026-06-09 06:21:10.35+00
d4f54af2-ecc8-435c-aacc-52d29ae5ef7c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	0a11f50e-0192-4aff-8bb0-7e0e34463470	application_package	generated_pdf:7028976b-432f-4ae3-8204-4ad8cb546a1c	Earned_Income_Tax_Credit_(EITC)_Package_Q4_2026_v1.pdf	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/7028976b-432f-4ae3-8204-4ad8cb546a1c.pdf	10848	application/pdf	2026-06-10 18:50:22.502+00
a545e029-5605-4376-9bcf-22eeb92b4f97	b7f6902d-d0fe-4c69-ac1f-51faf9245226	ccd1701a-5b68-4353-8db0-ef3c59935347	application_package	generated_pdf:8fe2f49a-9527-407b-a041-2f2eb12b07a3	Earned_Income_Tax_Credit_(EITC)_Package_Q2_2026_v3.pdf	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/8fe2f49a-9527-407b-a041-2f2eb12b07a3.pdf	10912	application/pdf	2026-06-10 18:46:25.369+00
041afc05-9219-4e42-9ae7-1e4f70dab4f5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	8016e417-ffd4-4853-b4b3-7e2b4ce7e6aa	application_package	generated_pdf:3235f665-56f5-484d-8d97-f51ae9f3c511	SNAP_—_Food_Stamps_Package_Q1_2026_v1.pdf	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/3235f665-56f5-484d-8d97-f51ae9f3c511.pdf	11139	application/pdf	2026-06-11 09:37:46.665+00
203a5bbc-5be1-4c1b-8202-e71aa7c01a57	b7f6902d-d0fe-4c69-ac1f-51faf9245226	42b9e00c-9de6-4c10-979a-fa8dcf7ac29b	application_package	generated_pdf:9e9521bf-24da-47c5-8d22-6195de116ec5	Section_8_Housing_Choice_Voucher_Package_Q1_2026_v2.pdf	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/9e9521bf-24da-47c5-8d22-6195de116ec5.pdf	11481	application/pdf	2026-06-10 19:38:10.277+00
29b9ff33-7615-49fe-9bf7-eaa1a1a51173	b7f6902d-d0fe-4c69-ac1f-51faf9245226	42b9e00c-9de6-4c10-979a-fa8dcf7ac29b	application_package	generated_pdf:16e5a279-9ee2-4046-9b81-caf268fa9f26	Section_8_Housing_Choice_Voucher_Package_Q2_2026_v1.pdf	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/16e5a279-9ee2-4046-9b81-caf268fa9f26.pdf	11496	application/pdf	2026-06-10 19:37:14.89+00
\.


--
-- TOC entry 4713 (class 0 OID 27026)
-- Dependencies: 414
-- Data for Name: documents_required; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.documents_required (id, program_id, document_name, description, required, conditional_on, created_at) FROM stdin;
\.


--
-- TOC entry 4708 (class 0 OID 26982)
-- Dependencies: 409
-- Data for Name: generated_pdfs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.generated_pdfs (id, user_id, application_id, program_id, file_url, file_size, version, status, validation_report, generated_at, quarter, year) FROM stdin;
3216b682-6b08-4515-a661-8ca47a1e2a6f	55b28a2d-ac96-4dff-b111-ca4338daebb0	\N	eitc	/opt/render/project/src/backend/uploads/pdfs/55b28a2d-ac96-4dff-b111-ca4338daebb0/3216b682-6b08-4515-a661-8ca47a1e2a6f.pdf	15664	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["childcare_record"], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-05-30 12:59:11.203+00	\N	\N
23170417-e534-4c91-b015-004dc3d1d380	55b28a2d-ac96-4dff-b111-ca4338daebb0	2e2a5850-d6c1-4eb8-992e-59cb48617333	ccdf	/opt/render/project/src/backend/uploads/pdfs/55b28a2d-ac96-4dff-b111-ca4338daebb0/23170417-e534-4c91-b015-004dc3d1d380.pdf	15780	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["childcare_record"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-05-30 13:00:29.568+00	\N	\N
e755b75e-cd1a-4a2f-a0d6-3444bf274e98	10648b38-417c-4511-8d34-d6021f19d2c2	\N	pell_grant	/opt/render/project/src/backend/uploads/pdfs/10648b38-417c-4511-8d34-d6021f19d2c2/e755b75e-cd1a-4a2f-a0d6-3444bf274e98.pdf	15340	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-05-31 11:31:22.783+00	\N	\N
91ac08b0-2f7a-4a8f-b424-971519ecf73a	10648b38-417c-4511-8d34-d6021f19d2c2	\N	pell_grant	/opt/render/project/src/backend/uploads/pdfs/10648b38-417c-4511-8d34-d6021f19d2c2/91ac08b0-2f7a-4a8f-b424-971519ecf73a.pdf	15340	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-05-31 11:38:14.477+00	\N	\N
12a146f4-dd4b-4f8a-8275-dd4b3eb2ac3c	10648b38-417c-4511-8d34-d6021f19d2c2	\N	pell_grant	/opt/render/project/src/backend/uploads/pdfs/10648b38-417c-4511-8d34-d6021f19d2c2/12a146f4-dd4b-4f8a-8275-dd4b3eb2ac3c.pdf	15339	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-05-31 11:52:29.483+00	\N	\N
c259e515-ec40-4016-bd83-79e52d64011c	10648b38-417c-4511-8d34-d6021f19d2c2	\N	pell_grant	/opt/render/project/src/backend/uploads/pdfs/10648b38-417c-4511-8d34-d6021f19d2c2/c259e515-ec40-4016-bd83-79e52d64011c.pdf	15338	4	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-05-31 11:53:34.46+00	\N	\N
d8db0f2d-1083-4ed2-9e8c-08c493a41f71	10648b38-417c-4511-8d34-d6021f19d2c2	\N	snap	/opt/render/project/src/backend/uploads/pdfs/10648b38-417c-4511-8d34-d6021f19d2c2/d8db0f2d-1083-4ed2-9e8c-08c493a41f71.pdf	15569	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name", "income_sources"], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-05-31 11:54:09.458+00	\N	\N
ac18ac2b-e1cc-482f-8969-7b5d09aac8b4	d63c70ab-4901-4a3b-86db-91f1b21d942e	\N	pell_grant	/opt/render/project/src/backend/uploads/pdfs/d63c70ab-4901-4a3b-86db-91f1b21d942e/ac18ac2b-e1cc-482f-8969-7b5d09aac8b4.pdf	15347	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-05-31 13:56:54.726+00	\N	\N
ad2df013-13e7-44df-b75c-4f0a96e3cdb2	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	head_start	/opt/render/project/src/backend/uploads/pdfs/316212a7-d942-4fbb-8d19-e6bad5d09df3/ad2df013-13e7-44df-b75c-4f0a96e3cdb2.pdf	15955	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["government_id", "proof_of_income", "birth_certificate"]}	2026-05-31 21:37:29.053+00	\N	\N
acfff626-1dce-4395-8380-7dd5eedb9b52	316212a7-d942-4fbb-8d19-e6bad5d09df3	5e137ded-4a66-4c95-9729-898ee61f6344	ccdf	/opt/render/project/src/backend/uploads/pdfs/316212a7-d942-4fbb-8d19-e6bad5d09df3/acfff626-1dce-4395-8380-7dd5eedb9b52.pdf	15618	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-05-31 22:15:16.537+00	\N	\N
d80ae01c-c2ca-4aeb-8b28-f3c9cd396be3	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	wic	/opt/render/project/src/backend/uploads/pdfs/316212a7-d942-4fbb-8d19-e6bad5d09df3/d80ae01c-c2ca-4aeb-8b28-f3c9cd396be3.pdf	15715	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-05-31 22:19:46.606+00	\N	\N
a41c4010-5169-460d-9290-ca22ddba7d17	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	wic	/opt/render/project/src/backend/uploads/pdfs/316212a7-d942-4fbb-8d19-e6bad5d09df3/a41c4010-5169-460d-9290-ca22ddba7d17.pdf	15711	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-05-31 22:21:11+00	\N	\N
5a5af98c-b1cc-44d9-9a28-756168c725e5	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	section8	/opt/render/project/src/backend/uploads/pdfs/316212a7-d942-4fbb-8d19-e6bad5d09df3/5a5af98c-b1cc-44d9-9a28-756168c725e5.pdf	15998	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income", "lease_agreement"]}	2026-05-31 22:21:59.69+00	\N	\N
3b879af4-98f3-447c-83fa-a6b78b355008	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	tanf	/opt/render/project/src/backend/uploads/pdfs/316212a7-d942-4fbb-8d19-e6bad5d09df3/3b879af4-98f3-447c-83fa-a6b78b355008.pdf	16198	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["bank_statement", "lease_agreement"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-05-31 22:22:28.513+00	\N	\N
6ee4c2dd-051a-4654-9577-3da8e2bccffd	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	section8	/opt/render/project/src/backend/uploads/pdfs/316212a7-d942-4fbb-8d19-e6bad5d09df3/6ee4c2dd-051a-4654-9577-3da8e2bccffd.pdf	15997	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income", "lease_agreement"]}	2026-05-31 22:26:43.307+00	\N	\N
dd2572f5-545b-456e-8f4e-b0a8cd8a8e49	316212a7-d942-4fbb-8d19-e6bad5d09df3	\N	medicaid	/opt/render/project/src/backend/uploads/pdfs/316212a7-d942-4fbb-8d19-e6bad5d09df3/dd2572f5-545b-456e-8f4e-b0a8cd8a8e49.pdf	12751	1	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": []}	2026-05-31 22:27:13.198+00	\N	\N
7ed2ab99-9d46-4064-9be5-762c79bcee2a	d63c70ab-4901-4a3b-86db-91f1b21d942e	\N	medicaid	/opt/render/project/src/backend/uploads/pdfs/d63c70ab-4901-4a3b-86db-91f1b21d942e/7ed2ab99-9d46-4064-9be5-762c79bcee2a.pdf	15198	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["other"], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-01 00:16:03.282+00	\N	\N
4549b870-05c2-4f8b-9b56-0dca78ebd262	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	legal_aid	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/4549b870-05c2-4f8b-9b56-0dca78ebd262.pdf	15386	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-02 14:52:05.009+00	\N	\N
a116c46a-0d8f-414f-a86c-89bab30e5196	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/a116c46a-0d8f-414f-a86c-89bab30e5196.pdf	15499	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id", "birth_certificate"]}	2026-06-02 14:56:20.48+00	\N	\N
42e94575-d4fe-4493-a37e-dfc981957af1	10648b38-417c-4511-8d34-d6021f19d2c2	\N	eitc	/opt/render/project/src/backend/uploads/pdfs/10648b38-417c-4511-8d34-d6021f19d2c2/42e94575-d4fe-4493-a37e-dfc981957af1.pdf	15463	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-02 15:01:03.16+00	\N	\N
4a4d7b55-c39e-40ef-b96b-3c22669b2f87	020a979b-5495-4452-80c9-ef8c5d4a552b	c6cc222b-bebd-4432-9db8-92f3304e2cd8	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/4a4d7b55-c39e-40ef-b96b-3c22669b2f87.pdf	15500	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id", "birth_certificate"]}	2026-06-02 15:02:30.562+00	\N	\N
be6a2428-0318-4f0b-9a62-463c7f23f461	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	eitc	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/be6a2428-0318-4f0b-9a62-463c7f23f461.pdf	15593	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-02 15:04:29.955+00	\N	\N
0a7844f4-4515-47fc-8d7b-977eef1f10e6	020a979b-5495-4452-80c9-ef8c5d4a552b	439e3118-ce6e-4029-826d-0f5c3e185802	eitc	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/0a7844f4-4515-47fc-8d7b-977eef1f10e6.pdf	15596	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-02 15:05:30.655+00	\N	\N
3f40e475-1a1b-41c3-901c-43b7a466d2c6	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	pell_grant	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/3f40e475-1a1b-41c3-901c-43b7a466d2c6.pdf	15485	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-02 15:08:11.369+00	\N	\N
90814d74-39f5-4d4e-b8d3-40cbd5626cba	020a979b-5495-4452-80c9-ef8c5d4a552b	1c7c40c9-31b9-4bbd-bc5b-67b9a435527a	pell_grant	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/90814d74-39f5-4d4e-b8d3-40cbd5626cba.pdf	15486	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-02 15:09:32.291+00	\N	\N
833ea71c-6019-4fb0-8100-af2568854424	020a979b-5495-4452-80c9-ef8c5d4a552b	dda3694d-f874-43db-9dfc-9026a34f1eb3	ccdf	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/833ea71c-6019-4fb0-8100-af2568854424.pdf	15669	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-02 15:15:12.055+00	\N	\N
7be629d3-900a-4a4e-bde5-1dcfaba5ca03	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	head_start	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/7be629d3-900a-4a4e-bde5-1dcfaba5ca03.pdf	15992	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-02 15:16:44.474+00	\N	\N
676ab964-44c6-42a4-a204-c4a08c5f26fe	020a979b-5495-4452-80c9-ef8c5d4a552b	2490bd4c-792f-48a4-88c2-4639f397b52a	head_start	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/676ab964-44c6-42a4-a204-c4a08c5f26fe.pdf	15990	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-02 15:19:59.756+00	\N	\N
bb7d448e-179f-4784-9865-9c6f4badf3b1	020a979b-5495-4452-80c9-ef8c5d4a552b	2490bd4c-792f-48a4-88c2-4639f397b52a	head_start	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/bb7d448e-179f-4784-9865-9c6f4badf3b1.pdf	15993	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-02 15:22:23.976+00	\N	\N
a30b593c-3980-46e8-b159-3350a9f67e41	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	liheap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/a30b593c-3980-46e8-b159-3350a9f67e41.pdf	15791	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income", "utility_bill"]}	2026-06-02 15:29:36.159+00	\N	\N
e8a145df-f5a8-46ad-987a-4bb054616dab	020a979b-5495-4452-80c9-ef8c5d4a552b	2b3dcbec-074b-4f68-8fa1-d35e87fd39bf	snap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/e8a145df-f5a8-46ad-987a-4bb054616dab.pdf	15619	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-02 15:26:28.864+00	\N	\N
4657120e-612a-4b1a-8691-26c314fe2698	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	lifeline	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/4657120e-612a-4b1a-8691-26c314fe2698.pdf	15431	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-02 15:35:39.507+00	\N	\N
ece5a561-c9d6-48c2-8dbe-32077cf11887	020a979b-5495-4452-80c9-ef8c5d4a552b	379795c8-0350-4f8d-9e7a-982afd261ee9	lifeline	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/ece5a561-c9d6-48c2-8dbe-32077cf11887.pdf	15431	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-02 15:36:38.43+00	\N	\N
e15bc1bc-d3f2-4c04-b87e-2da3c71eedb1	020a979b-5495-4452-80c9-ef8c5d4a552b	c01979aa-9db8-4bd7-ba91-64fb697ed018	liheap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/e15bc1bc-d3f2-4c04-b87e-2da3c71eedb1.pdf	15790	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income", "utility_bill"]}	2026-06-02 15:38:26.534+00	\N	\N
817751c5-44d2-4de1-a0d3-6dd4da45c626	020a979b-5495-4452-80c9-ef8c5d4a552b	c01979aa-9db8-4bd7-ba91-64fb697ed018	liheap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/817751c5-44d2-4de1-a0d3-6dd4da45c626.pdf	15787	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income", "utility_bill"]}	2026-06-02 15:39:49.332+00	\N	\N
d5fc0160-a587-4778-9478-2d5b31973d88	10648b38-417c-4511-8d34-d6021f19d2c2	13befec9-eac7-4739-aad9-30b96ffd19b2	eitc	/opt/render/project/src/backend/uploads/pdfs/10648b38-417c-4511-8d34-d6021f19d2c2/d5fc0160-a587-4778-9478-2d5b31973d88.pdf	15347	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["proof_of_income"], "missing_optional_documents": [], "missing_required_documents": ["government_id"]}	2026-06-02 16:31:36.272+00	\N	\N
f2f026a0-d192-4d15-828f-d85e23f74744	020a979b-5495-4452-80c9-ef8c5d4a552b	2b3dcbec-074b-4f68-8fa1-d35e87fd39bf	snap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/f2f026a0-d192-4d15-828f-d85e23f74744.pdf	15615	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-02 15:24:52.926+00	\N	\N
e7376f28-a3c0-4183-b4c3-e8502e3f1a12	020a979b-5495-4452-80c9-ef8c5d4a552b	2b3dcbec-074b-4f68-8fa1-d35e87fd39bf	snap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/e7376f28-a3c0-4183-b4c3-e8502e3f1a12.pdf	15617	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-02 17:11:32.815+00	\N	\N
9c08ee39-c52a-4908-99cc-acc588ee3df1	020a979b-5495-4452-80c9-ef8c5d4a552b	2b3dcbec-074b-4f68-8fa1-d35e87fd39bf	snap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/9c08ee39-c52a-4908-99cc-acc588ee3df1.pdf	15615	4	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-02 17:12:59.471+00	\N	\N
bf7799d0-8780-4cbd-86f8-7792c32cef66	020a979b-5495-4452-80c9-ef8c5d4a552b	c01979aa-9db8-4bd7-ba91-64fb697ed018	liheap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/bf7799d0-8780-4cbd-86f8-7792c32cef66.pdf	15787	4	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income", "utility_bill"]}	2026-06-02 17:13:53.364+00	\N	\N
b79e5ca1-419f-4779-8910-ef33ccdc3bae	020a979b-5495-4452-80c9-ef8c5d4a552b	439e3118-ce6e-4029-826d-0f5c3e185802	eitc	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/b79e5ca1-419f-4779-8910-ef33ccdc3bae.pdf	15515	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-02 17:15:23.176+00	\N	\N
69fe5615-8672-4705-92c3-488dcc06dbc6	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/69fe5615-8672-4705-92c3-488dcc06dbc6.pdf	15411	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["birth_certificate"]}	2026-06-03 05:16:58.87+00	\N	\N
57d64bdb-5914-4ed1-8112-d39579568976	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	pell_grant	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/57d64bdb-5914-4ed1-8112-d39579568976.pdf	15414	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-03 05:17:40.691+00	\N	\N
478cd70b-12ca-42e2-9c24-1530e4a7bebd	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	eitc	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/478cd70b-12ca-42e2-9c24-1530e4a7bebd.pdf	15519	4	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-03 05:18:34.924+00	\N	\N
85d6b1a0-dd83-4fc2-a832-5d16795ed5b4	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	liheap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/85d6b1a0-dd83-4fc2-a832-5d16795ed5b4.pdf	15793	5	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income", "utility_bill"]}	2026-06-03 05:19:11.01+00	\N	\N
386e7c49-3b11-4d24-a025-784549fd7eab	020a979b-5495-4452-80c9-ef8c5d4a552b	\N	snap	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/386e7c49-3b11-4d24-a025-784549fd7eab.pdf	15623	5	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-03 05:19:54.806+00	\N	\N
ba42f68a-2c1b-4584-9539-9bf93671ce72	020a979b-5495-4452-80c9-ef8c5d4a552b	4c506eaa-c3a9-41c0-8b82-98d090a36371	medicaid	/opt/render/project/src/backend/uploads/pdfs/020a979b-5495-4452-80c9-ef8c5d4a552b/ba42f68a-2c1b-4584-9539-9bf93671ce72.pdf	12731	1	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["other", "government_id"], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": []}	2026-06-03 05:21:50.134+00	\N	\N
2a366cb6-9261-4eb9-bb22-152669f87547	99377481-f483-4c4c-afdf-bf3ece076349	59f004ae-6894-4507-9ea6-02f45ea49fa3	snap	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/2a366cb6-9261-4eb9-bb22-152669f87547.pdf	15750	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-04 13:05:16.88+00	\N	\N
14ec977e-e5c4-4a4f-a036-a99043461725	99377481-f483-4c4c-afdf-bf3ece076349	e88e3711-7f28-42e6-a265-f977713377e3	medicaid	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/14ec977e-e5c4-4a4f-a036-a99043461725.pdf	15323	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-04 13:05:29.184+00	\N	\N
90e8f2ea-c296-4e2f-857a-90db8e4ad348	99377481-f483-4c4c-afdf-bf3ece076349	5cc0dbe4-9c84-4333-b706-1615bcb057b4	ccdf	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/90e8f2ea-c296-4e2f-857a-90db8e4ad348.pdf	15772	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-04 13:05:41.672+00	\N	\N
09ec0ba1-3ac5-4137-8450-f7da79a0ecf2	99377481-f483-4c4c-afdf-bf3ece076349	50a69e29-b0bf-4ca8-b3f1-0e9aa974c231	section8	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/09ec0ba1-3ac5-4137-8450-f7da79a0ecf2.pdf	16098	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income", "lease_agreement"]}	2026-06-04 13:05:53.768+00	\N	\N
bb4926a3-3d96-483b-a029-304b12652257	99377481-f483-4c4c-afdf-bf3ece076349	3b143b65-8f4e-4a51-9578-98073918eadd	liheap	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/bb4926a3-3d96-483b-a029-304b12652257.pdf	15898	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income", "utility_bill"]}	2026-06-04 13:06:05.974+00	\N	\N
a593c682-9802-48df-a15f-9de1717bacf6	99377481-f483-4c4c-afdf-bf3ece076349	f26c650b-a903-49df-a400-18051f735ca3	eitc	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/a593c682-9802-48df-a15f-9de1717bacf6.pdf	15643	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-04 13:06:18.664+00	\N	\N
343f41c5-78f8-485c-b4ab-b3deedb16517	99377481-f483-4c4c-afdf-bf3ece076349	6a99c3d8-1ea4-4e5c-b45e-3a26691cea50	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/343f41c5-78f8-485c-b4ab-b3deedb16517.pdf	15545	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id", "birth_certificate"]}	2026-06-04 13:06:31.773+00	\N	\N
f868b699-cb91-455d-a2f9-a4ce7f05a9ab	99377481-f483-4c4c-afdf-bf3ece076349	f8b13a67-bfdb-49d2-a6ab-90784c99f6a8	pell_grant	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/f868b699-cb91-455d-a2f9-a4ce7f05a9ab.pdf	15515	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-04 13:06:44.56+00	\N	\N
0a1160c5-e56a-4041-bdee-e1354cabd70e	99377481-f483-4c4c-afdf-bf3ece076349	b1aa0f97-db64-4838-830f-37ab8a24b5c5	head_start	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/0a1160c5-e56a-4041-bdee-e1354cabd70e.pdf	16082	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["government_id", "proof_of_income", "birth_certificate"]}	2026-06-04 13:06:57.853+00	\N	\N
75e266b3-1294-4d4c-8f08-b69204af446a	99377481-f483-4c4c-afdf-bf3ece076349	5af2d475-0448-41b1-8efc-2042dd3fda83	lifeline	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/75e266b3-1294-4d4c-8f08-b69204af446a.pdf	15548	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-04 13:07:10.86+00	\N	\N
3119a29b-db54-46fa-b798-07599c5e3af4	99377481-f483-4c4c-afdf-bf3ece076349	989f72c9-83f9-4a63-917d-8a2a4011c1bc	tanf	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/3119a29b-db54-46fa-b798-07599c5e3af4.pdf	16278	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["bank_statement", "lease_agreement"], "missing_required_documents": ["government_id", "proof_of_income", "birth_certificate"]}	2026-06-04 13:07:24.158+00	\N	\N
7b6afa67-db06-4d85-b534-c22ac39da96f	99377481-f483-4c4c-afdf-bf3ece076349	fcfa9fcc-d1de-4307-a90e-3303d9238e97	legal_aid	/opt/render/project/src/backend/uploads/pdfs/99377481-f483-4c4c-afdf-bf3ece076349/7b6afa67-db06-4d85-b534-c22ac39da96f.pdf	15409	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-04 13:07:37.478+00	\N	\N
516b54b4-d099-4fcf-91e3-39130c78bcda	b7f6902d-d0fe-4c69-ac1f-51faf9245226	8016e417-ffd4-4853-b4b3-7e2b4ce7e6aa	snap	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/516b54b4-d099-4fcf-91e3-39130c78bcda.pdf	15582	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name", "income_sources"], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-05 04:11:20.939+00	\N	\N
94681c32-54c5-4774-bf97-05bc7995d4f2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	a3e545ff-4225-4fa2-84f6-55ab68d04dfc	medicaid	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/94681c32-54c5-4774-bf97-05bc7995d4f2.pdf	15155	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-05 04:11:34.128+00	\N	\N
79fb0d0d-902d-4a0f-ac9c-a5eb24e5400d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	8bec9ec9-a26c-4838-b62b-034b1ea0349d	section8	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/79fb0d0d-902d-4a0f-ac9c-a5eb24e5400d.pdf	15922	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income", "lease_agreement"]}	2026-06-05 04:11:47.226+00	\N	\N
0b293559-4410-40f5-85f0-14f56e1b156a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	e23656c5-c471-468f-9f24-4c7c3e8fd5b5	liheap	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/0b293559-4410-40f5-85f0-14f56e1b156a.pdf	15726	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income", "utility_bill"]}	2026-06-05 04:12:00.364+00	\N	\N
be86cbf2-408b-45ee-ba4d-e951bc5a6a12	b7f6902d-d0fe-4c69-ac1f-51faf9245226	28fc7fce-2279-4de4-9f69-843c9bb8506c	eitc	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/be86cbf2-408b-45ee-ba4d-e951bc5a6a12.pdf	15470	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-05 04:12:13.621+00	\N	\N
d3e25612-fc2a-4a97-9423-0e37fef13b56	b7f6902d-d0fe-4c69-ac1f-51faf9245226	fa95ed66-5890-41fc-86c9-79c796d8b560	pell_grant	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/d3e25612-fc2a-4a97-9423-0e37fef13b56.pdf	15351	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-05 04:12:25.727+00	\N	\N
4ab30491-4715-4ef5-810f-e688d74aa85f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	5bc5ceda-e6f5-4d5d-946c-60f525d07e60	lifeline	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/4ab30491-4715-4ef5-810f-e688d74aa85f.pdf	15376	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-05 04:12:37.429+00	\N	\N
bf589219-a038-482c-bda0-31faf8495040	b7f6902d-d0fe-4c69-ac1f-51faf9245226	b2222510-e320-4210-809e-21bc3fd72513	legal_aid	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/bf589219-a038-482c-bda0-31faf8495040.pdf	15251	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": ["date_of_birth", "address", "legal_issues"], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-05 04:12:49.431+00	\N	\N
5d18e01f-bccd-4bac-90a0-2abd620f41ba	b7f6902d-d0fe-4c69-ac1f-51faf9245226	9984654d-424a-497f-86f5-4bf6ac0bd662	legal_aid	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/5d18e01f-bccd-4bac-90a0-2abd620f41ba.pdf	15249	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": ["date_of_birth", "address", "legal_issues"], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-05 04:12:55.736+00	\N	\N
7787abaa-145e-4087-acc6-d8448c8dfe78	b2fde45d-108b-400a-9b65-e42184ed68a2	f71b6345-96bf-4fa0-9108-80446d014e7b	snap	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/7787abaa-145e-4087-acc6-d8448c8dfe78.pdf	15652	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-08 14:22:41.385+00	\N	\N
dc2397a1-628d-4c26-ae42-5ce8b10e107f	b2fde45d-108b-400a-9b65-e42184ed68a2	07f6841d-4774-4fe7-83f6-02b96ed0d009	wic	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/dc2397a1-628d-4c26-ae42-5ce8b10e107f.pdf	15704	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-08 14:22:53.858+00	\N	\N
78a8e482-a9b5-4c6a-a813-58d298758f00	b2fde45d-108b-400a-9b65-e42184ed68a2	d6d1d4ba-29cf-4cda-99e4-5e32da32eff3	medicaid	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/78a8e482-a9b5-4c6a-a813-58d298758f00.pdf	15218	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-08 14:23:06.553+00	\N	\N
442926c0-a34b-4dc7-b540-938d15d9d023	b2fde45d-108b-400a-9b65-e42184ed68a2	a84b94e5-4e49-4f4f-93aa-a800d2b40568	ccdf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/442926c0-a34b-4dc7-b540-938d15d9d023.pdf	15698	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-08 14:23:19.452+00	\N	\N
6feacfb6-bbc8-408b-b2bb-d68d1e680672	b2fde45d-108b-400a-9b65-e42184ed68a2	3fdd21af-83e9-4d9f-9574-77fe69c50fe9	section8	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/6feacfb6-bbc8-408b-b2bb-d68d1e680672.pdf	15991	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income", "lease_agreement"]}	2026-06-08 14:23:32.764+00	\N	\N
d4638bf9-d109-4c19-9a78-3b7541a82aca	b2fde45d-108b-400a-9b65-e42184ed68a2	d3f9a0f2-68a0-4fdf-913e-420c8753b1ae	liheap	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/d4638bf9-d109-4c19-9a78-3b7541a82aca.pdf	15799	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income", "utility_bill"]}	2026-06-08 14:23:45.16+00	\N	\N
d363f661-3781-4e11-b16b-7fa20e0beeed	b2fde45d-108b-400a-9b65-e42184ed68a2	9520ee12-d006-4a81-a3a7-31498e8afa92	eitc	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/d363f661-3781-4e11-b16b-7fa20e0beeed.pdf	15540	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-08 14:23:57.828+00	\N	\N
64ed5231-82dd-42cb-92dd-c61ee4947e10	b2fde45d-108b-400a-9b65-e42184ed68a2	c6318ee6-f43b-4fbd-8218-9c24f531704b	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/64ed5231-82dd-42cb-92dd-c61ee4947e10.pdf	15438	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id", "birth_certificate"]}	2026-06-08 14:24:08.938+00	\N	\N
36dba5a5-c920-49d0-bc4a-035066fbb680	b2fde45d-108b-400a-9b65-e42184ed68a2	c23bacee-d1dd-464b-b0b7-f44c5b83fd03	pell_grant	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/36dba5a5-c920-49d0-bc4a-035066fbb680.pdf	15423	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-08 14:24:21.231+00	\N	\N
96d099b2-3bca-45f3-9b79-02ebbfa20a73	b2fde45d-108b-400a-9b65-e42184ed68a2	575ac081-c411-45b8-8953-b6df5faa1e13	head_start	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/96d099b2-3bca-45f3-9b79-02ebbfa20a73.pdf	16008	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["government_id", "proof_of_income", "birth_certificate"]}	2026-06-08 14:24:33.833+00	\N	\N
743a6cd7-f7b3-44a7-8e5c-5c7a56fe5d84	b2fde45d-108b-400a-9b65-e42184ed68a2	537e1ef0-e08f-4554-902b-e459a19cfe3b	lifeline	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/743a6cd7-f7b3-44a7-8e5c-5c7a56fe5d84.pdf	15447	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-08 14:24:46.129+00	\N	\N
95254105-f036-46aa-a905-a4f4003bfe21	b2fde45d-108b-400a-9b65-e42184ed68a2	31636b41-1f19-46f5-893f-789c2c38297b	tanf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/95254105-f036-46aa-a905-a4f4003bfe21.pdf	16178	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["bank_statement", "lease_agreement"], "missing_required_documents": ["government_id", "proof_of_income", "birth_certificate"]}	2026-06-08 14:24:59.416+00	\N	\N
5035c416-8c73-48e2-bcfa-c1256d92e935	b2fde45d-108b-400a-9b65-e42184ed68a2	bf794610-1d75-4b8e-b160-9fea9c61e36b	legal_aid	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/5035c416-8c73-48e2-bcfa-c1256d92e935.pdf	15329	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-08 14:25:11.528+00	\N	\N
5c633ba2-a2e0-498c-9fa9-7c65569a2597	b2fde45d-108b-400a-9b65-e42184ed68a2	\N	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/5c633ba2-a2e0-498c-9fa9-7c65569a2597.pdf	15320	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["birth_certificate"]}	2026-06-08 14:28:50.763+00	\N	\N
74b1e303-15be-4be4-bd01-15ab88d115bd	b2fde45d-108b-400a-9b65-e42184ed68a2	\N	ccdf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/74b1e303-15be-4be4-bd01-15ab88d115bd.pdf	15582	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-08 14:30:25.368+00	\N	\N
fbc6845c-fabc-4332-92da-94e063896762	b7f6902d-d0fe-4c69-ac1f-51faf9245226	\N	pell_grant	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/fbc6845c-fabc-4332-92da-94e063896762.pdf	15245	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-08 18:22:36.82+00	\N	\N
ba1e746f-10af-415f-a655-5044dd700ed3	b7f6902d-d0fe-4c69-ac1f-51faf9245226	a3e545ff-4225-4fa2-84f6-55ab68d04dfc	medicaid	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/ba1e746f-10af-415f-a655-5044dd700ed3.pdf	12702	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": ["medical_record"], "missing_required_documents": []}	2026-06-08 18:50:27.192+00	\N	\N
0f68112a-c439-429c-beb4-59f3dbd9a24d	c4966c51-a590-485c-bf82-0d699e087ab8	17238901-8f00-470f-b69f-3d6f15f3b99c	snap	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/0f68112a-c439-429c-beb4-59f3dbd9a24d.pdf	15597	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name", "income_sources"], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:40:36.717+00	\N	\N
d7e4238c-1ed7-4b6a-be3f-0d3478c74c77	c4966c51-a590-485c-bf82-0d699e087ab8	59e00f73-3ac4-409e-9d1a-8bc2a4a63eb7	medicaid	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/d7e4238c-1ed7-4b6a-be3f-0d3478c74c77.pdf	15166	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-09 03:40:49.205+00	\N	\N
f9ea806e-dc61-468a-be75-3003174a1eae	c4966c51-a590-485c-bf82-0d699e087ab8	d848a1fa-edbe-438f-90a6-a8ce69ed7a2e	section8	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/f9ea806e-dc61-468a-be75-3003174a1eae.pdf	15943	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income", "lease_agreement"]}	2026-06-09 03:41:01.903+00	\N	\N
17116eec-074c-4c35-951b-9202117758c6	c4966c51-a590-485c-bf82-0d699e087ab8	b79b4c04-f7f8-469e-945e-e1e2c917e031	liheap	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/17116eec-074c-4c35-951b-9202117758c6.pdf	15742	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income", "utility_bill"]}	2026-06-09 03:41:14.797+00	\N	\N
c86de1ac-0e86-4d68-91df-f51405b4e823	c4966c51-a590-485c-bf82-0d699e087ab8	1253871f-1225-4faf-bde1-26d2cd1902d6	eitc	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/c86de1ac-0e86-4d68-91df-f51405b4e823.pdf	15487	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:41:27.5+00	\N	\N
6f72c83c-1455-424a-bee9-c5750bc05ab4	c4966c51-a590-485c-bf82-0d699e087ab8	0ea3d64b-5685-453e-9564-568bd28821ad	pell_grant	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/6f72c83c-1455-424a-bee9-c5750bc05ab4.pdf	15368	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:41:40.205+00	\N	\N
16841202-1b16-4e32-ac04-cbd8ca9cb964	c4966c51-a590-485c-bf82-0d699e087ab8	dd01f3e2-1c4e-4751-bf00-0783b1a32e32	lifeline	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/16841202-1b16-4e32-ac04-cbd8ca9cb964.pdf	15393	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:41:52.802+00	\N	\N
ff60ed2e-e8d8-44df-a3a2-add6c9aa4184	c4966c51-a590-485c-bf82-0d699e087ab8	\N	snap	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/ff60ed2e-e8d8-44df-a3a2-add6c9aa4184.pdf	15597	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name", "income_sources"], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:41:56.595+00	\N	\N
7d34d3c3-e911-49d6-8121-b465017e4dc6	c4966c51-a590-485c-bf82-0d699e087ab8	9cbebbd0-d890-4978-b5cc-5fdfe3227a49	legal_aid	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/7d34d3c3-e911-49d6-8121-b465017e4dc6.pdf	15262	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": ["date_of_birth", "address", "legal_issues"], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-09 03:42:05.412+00	\N	\N
992954b8-ea26-4656-92da-51a27e61aaf5	c4966c51-a590-485c-bf82-0d699e087ab8	49fd446e-4278-4ea3-b986-b7625e9db6ae	pell_grant	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/992954b8-ea26-4656-92da-51a27e61aaf5.pdf	15365	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:42:36.207+00	\N	\N
9686500a-8644-4bcf-8b5c-b73e1fb2ccc4	c4966c51-a590-485c-bf82-0d699e087ab8	17238901-8f00-470f-b69f-3d6f15f3b99c	snap	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/9686500a-8644-4bcf-8b5c-b73e1fb2ccc4.pdf	15601	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name", "income_sources"], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:48:58.112+00	\N	\N
692c5550-81e3-46d5-88cc-bdcd2a661eb1	c4966c51-a590-485c-bf82-0d699e087ab8	59e00f73-3ac4-409e-9d1a-8bc2a4a63eb7	medicaid	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/692c5550-81e3-46d5-88cc-bdcd2a661eb1.pdf	15172	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-09 03:49:09.707+00	\N	\N
701d2020-ed5c-475e-bb32-f2171257e3ed	c4966c51-a590-485c-bf82-0d699e087ab8	d848a1fa-edbe-438f-90a6-a8ce69ed7a2e	section8	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/701d2020-ed5c-475e-bb32-f2171257e3ed.pdf	15947	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income", "lease_agreement"]}	2026-06-09 03:49:21.513+00	\N	\N
c97b167d-630f-4edd-9fc8-eb79eca9ae92	c4966c51-a590-485c-bf82-0d699e087ab8	b79b4c04-f7f8-469e-945e-e1e2c917e031	liheap	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/c97b167d-630f-4edd-9fc8-eb79eca9ae92.pdf	15751	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income", "utility_bill"]}	2026-06-09 03:49:32.909+00	\N	\N
b29f024a-5445-4305-9b88-45f3da4927e7	c4966c51-a590-485c-bf82-0d699e087ab8	1253871f-1225-4faf-bde1-26d2cd1902d6	eitc	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/b29f024a-5445-4305-9b88-45f3da4927e7.pdf	15491	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:49:44.509+00	\N	\N
1f74575f-466d-4776-9d54-0c1e9ada55cd	c4966c51-a590-485c-bf82-0d699e087ab8	0ea3d64b-5685-453e-9564-568bd28821ad	pell_grant	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/1f74575f-466d-4776-9d54-0c1e9ada55cd.pdf	15371	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:49:56.203+00	\N	\N
b25c1319-64d3-4d39-be4f-f0b60a2779a1	c4966c51-a590-485c-bf82-0d699e087ab8	dd01f3e2-1c4e-4751-bf00-0783b1a32e32	lifeline	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/b25c1319-64d3-4d39-be4f-f0b60a2779a1.pdf	15396	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 03:50:07.817+00	\N	\N
8e612253-9fe6-438c-8112-26d74fb6ab7b	c4966c51-a590-485c-bf82-0d699e087ab8	9cbebbd0-d890-4978-b5cc-5fdfe3227a49	legal_aid	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/8e612253-9fe6-438c-8112-26d74fb6ab7b.pdf	15267	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": ["date_of_birth", "address", "legal_issues"], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-09 03:50:19.293+00	\N	\N
7057f70b-4399-42ca-a807-2f82c80393a6	ad89b347-7133-4c28-b420-0c6601fc139f	d95b60a5-70cd-4ab5-9c80-1f122cb3ce56	snap	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/7057f70b-4399-42ca-a807-2f82c80393a6.pdf	15758	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:39:09.952+00	\N	\N
6c3eac1b-0b15-4964-9e82-84c9b75d63c7	ad89b347-7133-4c28-b420-0c6601fc139f	816e4be9-2a2c-4f38-9ea3-8db80f6688d9	medicaid	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/6c3eac1b-0b15-4964-9e82-84c9b75d63c7.pdf	15334	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-09 05:39:21.9+00	\N	\N
ec873973-f9c7-4bf3-8461-8d81a2c76ba2	ad89b347-7133-4c28-b420-0c6601fc139f	82b08d0f-73f8-4e1b-8aef-f853ab02ab35	section8	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/ec873973-f9c7-4bf3-8461-8d81a2c76ba2.pdf	16100	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income", "lease_agreement"]}	2026-06-09 05:39:34.187+00	\N	\N
145c8134-1399-44ce-8265-abc2fb484f3d	ad89b347-7133-4c28-b420-0c6601fc139f	0537806c-a3c0-44be-aed6-9e79a818e62e	liheap	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/145c8134-1399-44ce-8265-abc2fb484f3d.pdf	15909	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income", "utility_bill"]}	2026-06-09 05:39:47.089+00	\N	\N
3e1a0e24-817c-4c16-be61-ddf3004edcb7	ad89b347-7133-4c28-b420-0c6601fc139f	9b11b0a0-90d4-46b7-8ca9-a050b987af24	eitc	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/3e1a0e24-817c-4c16-be61-ddf3004edcb7.pdf	15650	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:39:59.516+00	\N	\N
8c9576fc-6188-48ad-8b56-f0df5847d525	ad89b347-7133-4c28-b420-0c6601fc139f	ca6c10e3-89b8-4892-951b-630edd216fe3	pell_grant	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/8c9576fc-6188-48ad-8b56-f0df5847d525.pdf	15531	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:40:12.389+00	\N	\N
929f083f-7458-41e9-b97d-a117c506a0dd	ad89b347-7133-4c28-b420-0c6601fc139f	d0f968d4-b559-4244-97ab-c2920c2662d0	lifeline	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/929f083f-7458-41e9-b97d-a117c506a0dd.pdf	15560	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:40:24.685+00	\N	\N
10c9a0d6-5620-4388-9c32-7866aa19549d	ad89b347-7133-4c28-b420-0c6601fc139f	57bac84e-3e08-4bfd-abc2-1f2202b3feac	legal_aid	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/10c9a0d6-5620-4388-9c32-7866aa19549d.pdf	15422	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-09 05:40:37.179+00	\N	\N
3ef5be77-d403-4b71-b681-358520659f3c	ad89b347-7133-4c28-b420-0c6601fc139f	d95b60a5-70cd-4ab5-9c80-1f122cb3ce56	snap	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/3ef5be77-d403-4b71-b681-358520659f3c.pdf	15760	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:41:13.555+00	\N	\N
ad4f1eb9-76bc-44da-ad22-d30518c48617	ad89b347-7133-4c28-b420-0c6601fc139f	816e4be9-2a2c-4f38-9ea3-8db80f6688d9	medicaid	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/ad4f1eb9-76bc-44da-ad22-d30518c48617.pdf	15332	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-09 05:41:24.449+00	\N	\N
52445cbf-5292-4e49-97c7-e3035276c20c	ad89b347-7133-4c28-b420-0c6601fc139f	82b08d0f-73f8-4e1b-8aef-f853ab02ab35	section8	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/52445cbf-5292-4e49-97c7-e3035276c20c.pdf	16103	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income", "lease_agreement"]}	2026-06-09 05:41:35.35+00	\N	\N
f68289e6-83d6-4bd0-80b9-c371a9b02bd7	ad89b347-7133-4c28-b420-0c6601fc139f	0537806c-a3c0-44be-aed6-9e79a818e62e	liheap	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/f68289e6-83d6-4bd0-80b9-c371a9b02bd7.pdf	15906	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income", "utility_bill"]}	2026-06-09 05:41:46.249+00	\N	\N
974d5a56-1c0e-4562-a333-709ee71fef38	ad89b347-7133-4c28-b420-0c6601fc139f	9b11b0a0-90d4-46b7-8ca9-a050b987af24	eitc	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/974d5a56-1c0e-4562-a333-709ee71fef38.pdf	15651	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:41:56.952+00	\N	\N
be1b34af-ef10-43d2-b067-9670cb2b0ed6	ad89b347-7133-4c28-b420-0c6601fc139f	ca6c10e3-89b8-4892-951b-630edd216fe3	pell_grant	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/be1b34af-ef10-43d2-b067-9670cb2b0ed6.pdf	15530	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:42:07.944+00	\N	\N
ca491d39-32f7-4d41-99be-b84b2f3f8799	ad89b347-7133-4c28-b420-0c6601fc139f	d0f968d4-b559-4244-97ab-c2920c2662d0	lifeline	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/ca491d39-32f7-4d41-99be-b84b2f3f8799.pdf	15558	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:42:18.845+00	\N	\N
8b4a94a5-8e6c-4afd-9f69-09d2792b0270	ad89b347-7133-4c28-b420-0c6601fc139f	57bac84e-3e08-4bfd-abc2-1f2202b3feac	legal_aid	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/8b4a94a5-8e6c-4afd-9f69-09d2792b0270.pdf	15421	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-09 05:42:29.947+00	\N	\N
07a5222d-0923-4326-91dc-b67abb5b61d1	ad89b347-7133-4c28-b420-0c6601fc139f	\N	snap	/opt/render/project/src/backend/uploads/pdfs/ad89b347-7133-4c28-b420-0c6601fc139f/07a5222d-0923-4326-91dc-b67abb5b61d1.pdf	15759	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:44:47.288+00	\N	\N
d9089dae-a165-4cca-b523-f58546349326	dcf8d6a3-0282-402d-b40f-95ad3b24be73	db31dd02-d5f9-40ef-99dc-86da9506b59f	snap	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/d9089dae-a165-4cca-b523-f58546349326.pdf	15687	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:58:14.25+00	\N	\N
36d0d1a0-cc01-49fc-b0bd-73881bc69769	dcf8d6a3-0282-402d-b40f-95ad3b24be73	bd9bf8d6-d399-424a-b316-03452eaf3280	wic	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/36d0d1a0-cc01-49fc-b0bd-73881bc69769.pdf	15748	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:58:26.603+00	\N	\N
0d433d62-f972-4417-8fbe-55e96cdce72e	dcf8d6a3-0282-402d-b40f-95ad3b24be73	cf3c6ffc-89f5-4ba7-b7f7-5ead9c7200ca	medicaid	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/0d433d62-f972-4417-8fbe-55e96cdce72e.pdf	15255	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-09 05:58:39.26+00	\N	\N
bc99dce3-6bad-4f3e-86fa-fe025ab1367a	dcf8d6a3-0282-402d-b40f-95ad3b24be73	\N	wic	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/bc99dce3-6bad-4f3e-86fa-fe025ab1367a.pdf	15749	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:58:51.011+00	\N	\N
7a9678dc-ef4b-4def-8e0f-77b3390bd258	dcf8d6a3-0282-402d-b40f-95ad3b24be73	f8c50736-69ab-4377-ad2e-5441a46692c5	ccdf	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/7a9678dc-ef4b-4def-8e0f-77b3390bd258.pdf	15746	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:58:51.914+00	\N	\N
7b53c0e0-c3cd-49e3-b387-24a347e68063	dcf8d6a3-0282-402d-b40f-95ad3b24be73	805508e0-1656-4a7d-bdad-5ab9d1337b49	section8	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/7b53c0e0-c3cd-49e3-b387-24a347e68063.pdf	16024	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["government_id", "proof_of_income", "lease_agreement"]}	2026-06-09 05:59:04.608+00	\N	\N
ba8fbed5-d8fb-4fe0-a12f-a71e12bce9f5	dcf8d6a3-0282-402d-b40f-95ad3b24be73	1e3d7159-e3e4-4660-b2c8-6c41617e665e	liheap	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/ba8fbed5-d8fb-4fe0-a12f-a71e12bce9f5.pdf	15834	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income", "utility_bill"]}	2026-06-09 05:59:17.013+00	\N	\N
881d70cc-9766-4597-a587-d4314e701543	dcf8d6a3-0282-402d-b40f-95ad3b24be73	e9b6313c-7405-4e7f-82f9-d8acc5161964	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/881d70cc-9766-4597-a587-d4314e701543.pdf	15479	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id", "birth_certificate"]}	2026-06-09 05:59:41.956+00	\N	\N
84000c42-5f3e-4081-a927-e7d32b16e7eb	dcf8d6a3-0282-402d-b40f-95ad3b24be73	2e4cebbe-c277-4a86-80e7-84fe194bc139	pell_grant	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/84000c42-5f3e-4081-a927-e7d32b16e7eb.pdf	15457	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:59:54.501+00	\N	\N
2fbb08a8-1fa6-4150-aae5-ccc94975efab	dcf8d6a3-0282-402d-b40f-95ad3b24be73	7b5e0eec-3c25-4d17-b666-a64cf6ddb8b0	head_start	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/2fbb08a8-1fa6-4150-aae5-ccc94975efab.pdf	16056	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["government_id", "proof_of_income", "birth_certificate"]}	2026-06-09 06:00:07.606+00	\N	\N
e43cfe0f-9324-4319-98a2-0157b27b47f4	dcf8d6a3-0282-402d-b40f-95ad3b24be73	de11a01a-2290-4350-ab57-d299983cc8b1	lifeline	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/e43cfe0f-9324-4319-98a2-0157b27b47f4.pdf	15487	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 06:00:20.11+00	\N	\N
dde12d1c-b8a0-4bd5-9d30-2a2455635c39	dcf8d6a3-0282-402d-b40f-95ad3b24be73	2d8aaa4d-46ec-475e-84c5-3da13beeeb48	tanf	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/dde12d1c-b8a0-4bd5-9d30-2a2455635c39.pdf	16215	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["bank_statement", "lease_agreement"], "missing_required_documents": ["government_id", "proof_of_income", "birth_certificate"]}	2026-06-09 06:00:31.5+00	\N	\N
a2eadba4-3561-4cc8-87fe-6a8d4d221fcf	dcf8d6a3-0282-402d-b40f-95ad3b24be73	0764db22-1b48-43cb-93b9-50bf76ad867e	legal_aid	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/a2eadba4-3561-4cc8-87fe-6a8d4d221fcf.pdf	15356	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-09 06:00:44.122+00	\N	\N
e7a3b92c-14e7-4e30-abe9-8348d6e6153f	dcf8d6a3-0282-402d-b40f-95ad3b24be73	371d3e7b-85bb-4065-b780-b5da201e32cc	eitc	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/e7a3b92c-14e7-4e30-abe9-8348d6e6153f.pdf	15578	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 05:59:29.5+00	\N	\N
89243598-612f-4e5d-b763-093f58985526	dcf8d6a3-0282-402d-b40f-95ad3b24be73	0764db22-1b48-43cb-93b9-50bf76ad867e	legal_aid	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/89243598-612f-4e5d-b763-093f58985526.pdf	15353	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["government_id"]}	2026-06-09 06:20:57.125+00	\N	\N
60fe2292-fb1d-45e4-b805-e6bc05ea7dcb	9f96c2cf-298d-4553-a094-a13af906b497	fe7a8ef8-27b7-420e-b49a-5e3592bbecbb	wic	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/60fe2292-fb1d-45e4-b805-e6bc05ea7dcb.pdf	15688	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 07:01:45.625+00	\N	\N
e758418b-d845-4d04-870a-a572d939edbd	9f96c2cf-298d-4553-a094-a13af906b497	f2fd9b02-c010-4fd3-a64d-adb4691ea773	eitc	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/e758418b-d845-4d04-870a-a572d939edbd.pdf	15521	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 07:01:58.388+00	\N	\N
18970c1c-d101-423f-b088-54814364c278	9f96c2cf-298d-4553-a094-a13af906b497	ff3ed46e-a8a8-4709-99e4-5c9e32950171	pell_grant	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/18970c1c-d101-423f-b088-54814364c278.pdf	15404	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 07:02:10.708+00	\N	\N
321bb623-f17f-4761-8a29-6f2efe6ba2f6	9f96c2cf-298d-4553-a094-a13af906b497	fe7a8ef8-27b7-420e-b49a-5e3592bbecbb	wic	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/321bb623-f17f-4761-8a29-6f2efe6ba2f6.pdf	15689	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 07:15:03.964+00	\N	\N
3c5a932e-416a-49b7-9a56-b30b4dfd6f5e	9f96c2cf-298d-4553-a094-a13af906b497	f2fd9b02-c010-4fd3-a64d-adb4691ea773	eitc	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/3c5a932e-416a-49b7-9a56-b30b4dfd6f5e.pdf	15522	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 07:15:14.962+00	\N	\N
8ca04dca-c8b6-4c0b-9222-3b465761a73d	9f96c2cf-298d-4553-a094-a13af906b497	ff3ed46e-a8a8-4709-99e4-5c9e32950171	pell_grant	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/8ca04dca-c8b6-4c0b-9222-3b465761a73d.pdf	15402	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": [], "missing_required_documents": ["government_id", "proof_of_income"]}	2026-06-09 07:15:26.261+00	\N	\N
8bca4e6a-d116-42f1-acdf-ee2e6a3d398e	9f96c2cf-298d-4553-a094-a13af906b497	fe7a8ef8-27b7-420e-b49a-5e3592bbecbb	wic	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/8bca4e6a-d116-42f1-acdf-ee2e6a3d398e.pdf	15546	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-09 07:19:10.475+00	\N	\N
b3546e62-16fa-493b-8697-70e3af19b2d8	9f96c2cf-298d-4553-a094-a13af906b497	f2fd9b02-c010-4fd3-a64d-adb4691ea773	eitc	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/b3546e62-16fa-493b-8697-70e3af19b2d8.pdf	15390	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-09 07:19:21.463+00	\N	\N
ef282c85-9966-4b28-ba56-8c45a0a4f829	9f96c2cf-298d-4553-a094-a13af906b497	ff3ed46e-a8a8-4709-99e4-5c9e32950171	pell_grant	/opt/render/project/src/backend/uploads/pdfs/9f96c2cf-298d-4553-a094-a13af906b497/ef282c85-9966-4b28-ba56-8c45a0a4f829.pdf	15271	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-09 07:19:32.571+00	\N	\N
932885da-fb43-479c-a8d6-00fa2e9fdaf3	dcf8d6a3-0282-402d-b40f-95ad3b24be73	\N	legal_aid	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/932885da-fb43-479c-a8d6-00fa2e9fdaf3.pdf	12842	3	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": []}	2026-06-09 08:24:17.655+00	\N	\N
b0d1e99d-54a8-46ed-bf7f-5ed9b8c1308c	dcf8d6a3-0282-402d-b40f-95ad3b24be73	db31dd02-d5f9-40ef-99dc-86da9506b59f	snap	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/b0d1e99d-54a8-46ed-bf7f-5ed9b8c1308c.pdf	15645	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-09 09:24:04.869+00	\N	\N
67bfbb80-cadd-4a7f-ba64-126117df913b	dcf8d6a3-0282-402d-b40f-95ad3b24be73	bd9bf8d6-d399-424a-b316-03452eaf3280	wic	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/67bfbb80-cadd-4a7f-ba64-126117df913b.pdf	15703	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-09 09:24:16.448+00	\N	\N
2652b2e9-6bd1-4f33-bfb3-4b0488cc9079	dcf8d6a3-0282-402d-b40f-95ad3b24be73	cf3c6ffc-89f5-4ba7-b7f7-5ead9c7200ca	medicaid	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/2652b2e9-6bd1-4f33-bfb3-4b0488cc9079.pdf	12749	2	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": []}	2026-06-09 09:24:27.799+00	\N	\N
fd48d214-f3c6-4156-bbe8-f1a51da22b4e	dcf8d6a3-0282-402d-b40f-95ad3b24be73	f8c50736-69ab-4377-ad2e-5441a46692c5	ccdf	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/fd48d214-f3c6-4156-bbe8-f1a51da22b4e.pdf	15701	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-09 09:24:38.902+00	\N	\N
93b6595b-a591-40c7-b55e-907436282728	dcf8d6a3-0282-402d-b40f-95ad3b24be73	805508e0-1656-4a7d-bdad-5ab9d1337b49	section8	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/93b6595b-a591-40c7-b55e-907436282728.pdf	15987	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income", "lease_agreement"]}	2026-06-09 09:24:50.097+00	\N	\N
677e420f-15fe-42ff-b029-196cb2f8a456	dcf8d6a3-0282-402d-b40f-95ad3b24be73	1e3d7159-e3e4-4660-b2c8-6c41617e665e	liheap	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/677e420f-15fe-42ff-b029-196cb2f8a456.pdf	15808	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income", "utility_bill"]}	2026-06-09 09:25:01.198+00	\N	\N
eef345a6-c4b8-4426-8469-36800f1f21b1	dcf8d6a3-0282-402d-b40f-95ad3b24be73	371d3e7b-85bb-4065-b780-b5da201e32cc	eitc	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/eef345a6-c4b8-4426-8469-36800f1f21b1.pdf	15543	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-09 09:25:12.601+00	\N	\N
2a4f4b38-80d1-4c47-9d20-a29b39417d93	dcf8d6a3-0282-402d-b40f-95ad3b24be73	e9b6313c-7405-4e7f-82f9-d8acc5161964	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/2a4f4b38-80d1-4c47-9d20-a29b39417d93.pdf	15432	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["birth_certificate"]}	2026-06-09 09:25:23.5+00	\N	\N
7aff95a1-d6b1-431f-a2d5-2b75bdb3ee81	dcf8d6a3-0282-402d-b40f-95ad3b24be73	2e4cebbe-c277-4a86-80e7-84fe194bc139	pell_grant	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/7aff95a1-d6b1-431f-a2d5-2b75bdb3ee81.pdf	15424	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-09 09:25:34.696+00	\N	\N
99e1dc9b-09ff-4633-ad2c-feb7a2d218fb	dcf8d6a3-0282-402d-b40f-95ad3b24be73	7b5e0eec-3c25-4d17-b666-a64cf6ddb8b0	head_start	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/99e1dc9b-09ff-4633-ad2c-feb7a2d218fb.pdf	16023	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-09 09:25:45.798+00	\N	\N
fe9d3e22-e3e0-44e8-b2a4-cfb1919ab64a	dcf8d6a3-0282-402d-b40f-95ad3b24be73	de11a01a-2290-4350-ab57-d299983cc8b1	lifeline	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/fe9d3e22-e3e0-44e8-b2a4-cfb1919ab64a.pdf	15450	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-09 09:25:57.004+00	\N	\N
9a9d1c13-6b6a-41ab-b84b-e15f234078f1	dcf8d6a3-0282-402d-b40f-95ad3b24be73	2d8aaa4d-46ec-475e-84c5-3da13beeeb48	tanf	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/9a9d1c13-6b6a-41ab-b84b-e15f234078f1.pdf	16185	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["bank_statement", "lease_agreement"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-09 09:26:07.897+00	\N	\N
a63880b9-39db-42fd-834c-61be9ee9d93c	dcf8d6a3-0282-402d-b40f-95ad3b24be73	0764db22-1b48-43cb-93b9-50bf76ad867e	legal_aid	/opt/render/project/src/backend/uploads/pdfs/dcf8d6a3-0282-402d-b40f-95ad3b24be73/a63880b9-39db-42fd-834c-61be9ee9d93c.pdf	12892	4	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": []}	2026-06-09 09:26:19.197+00	\N	\N
59fc7c3b-c8b4-4df6-8daa-8e6644349e36	b7f6902d-d0fe-4c69-ac1f-51faf9245226	8016e417-ffd4-4853-b4b3-7e2b4ce7e6aa	snap	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/59fc7c3b-c8b4-4df6-8daa-8e6644349e36.pdf	12825	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name", "income_sources"], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": []}	2026-06-09 19:09:05.311+00	\N	\N
903032ab-6424-4af0-9cc4-115d287ce10f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	a3e545ff-4225-4fa2-84f6-55ab68d04dfc	medicaid	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/903032ab-6424-4af0-9cc4-115d287ce10f.pdf	12704	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": ["medical_record"], "missing_required_documents": []}	2026-06-09 19:09:22.495+00	\N	\N
74762e65-a07d-4df2-89da-8c687b32c743	b7f6902d-d0fe-4c69-ac1f-51faf9245226	8bec9ec9-a26c-4838-b62b-034b1ea0349d	section8	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/74762e65-a07d-4df2-89da-8c687b32c743.pdf	15636	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["lease_agreement"]}	2026-06-09 19:09:38.788+00	\N	\N
83268c40-85a8-47c0-ab04-d2c1b9ffe473	b7f6902d-d0fe-4c69-ac1f-51faf9245226	e23656c5-c471-468f-9f24-4c7c3e8fd5b5	liheap	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/83268c40-85a8-47c0-ab04-d2c1b9ffe473.pdf	15460	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": ["utility_bill"]}	2026-06-09 19:09:55.814+00	\N	\N
19f04820-654d-44b8-9646-15c8d3cc8f34	b7f6902d-d0fe-4c69-ac1f-51faf9245226	28fc7fce-2279-4de4-9f69-843c9bb8506c	eitc	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/19f04820-654d-44b8-9646-15c8d3cc8f34.pdf	12687	4	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": []}	2026-06-09 19:10:12.017+00	\N	\N
10f34035-cd4a-4f2b-bdb4-625353579552	b7f6902d-d0fe-4c69-ac1f-51faf9245226	fa95ed66-5890-41fc-86c9-79c796d8b560	pell_grant	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/10f34035-cd4a-4f2b-bdb4-625353579552.pdf	12611	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": []}	2026-06-09 19:10:29.389+00	\N	\N
b6bd6e7b-c263-4ad4-abaf-92a5fa913905	b7f6902d-d0fe-4c69-ac1f-51faf9245226	5bc5ceda-e6f5-4d5d-946c-60f525d07e60	lifeline	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/b6bd6e7b-c263-4ad4-abaf-92a5fa913905.pdf	12634	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": []}	2026-06-09 19:10:45.425+00	\N	\N
03023670-e9ec-42b7-b95e-9c112e87008b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	b2222510-e320-4210-809e-21bc3fd72513	legal_aid	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/03023670-e9ec-42b7-b95e-9c112e87008b.pdf	12763	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": ["date_of_birth", "address", "legal_issues"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": []}	2026-06-09 19:11:01.409+00	\N	\N
885a255b-87d5-49a5-99f5-b3de2c2cfb16	b2fde45d-108b-400a-9b65-e42184ed68a2	\N	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/885a255b-87d5-49a5-99f5-b3de2c2cfb16.pdf	15326	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["birth_certificate"]}	2026-06-10 03:47:38.664+00	\N	\N
69c5d6dc-d813-4aac-b300-c39d907a8acb	b2fde45d-108b-400a-9b65-e42184ed68a2	\N	ccdf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/69c5d6dc-d813-4aac-b300-c39d907a8acb.pdf	15593	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:48:26.701+00	\N	\N
55747a51-c075-43e9-b2c0-31ae94ec47f5	b2fde45d-108b-400a-9b65-e42184ed68a2	\N	ccdf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/55747a51-c075-43e9-b2c0-31ae94ec47f5.pdf	15590	4	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:50:09.234+00	\N	\N
8458b0dc-ae93-49ec-82c1-ed45935d45aa	b2fde45d-108b-400a-9b65-e42184ed68a2	f71b6345-96bf-4fa0-9108-80446d014e7b	snap	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/8458b0dc-ae93-49ec-82c1-ed45935d45aa.pdf	15537	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:54:31.203+00	\N	\N
427159b4-70d6-4674-a2d7-c42dbff1af84	b2fde45d-108b-400a-9b65-e42184ed68a2	07f6841d-4774-4fe7-83f6-02b96ed0d009	wic	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/427159b4-70d6-4674-a2d7-c42dbff1af84.pdf	15595	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:54:42.204+00	\N	\N
beff8960-b3ec-4bab-8c5d-5b94c7ac78d0	b2fde45d-108b-400a-9b65-e42184ed68a2	d6d1d4ba-29cf-4cda-99e4-5e32da32eff3	medicaid	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/beff8960-b3ec-4bab-8c5d-5b94c7ac78d0.pdf	12651	2	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": []}	2026-06-10 03:54:53.01+00	\N	\N
3bd4b7f3-919b-4132-8fe3-ca149189a128	b2fde45d-108b-400a-9b65-e42184ed68a2	a84b94e5-4e49-4f4f-93aa-a800d2b40568	ccdf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/3bd4b7f3-919b-4132-8fe3-ca149189a128.pdf	15590	5	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:55:03.9+00	\N	\N
a48c64bd-4d31-4a4b-9707-e37b2c11d3d2	b2fde45d-108b-400a-9b65-e42184ed68a2	3fdd21af-83e9-4d9f-9574-77fe69c50fe9	section8	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/a48c64bd-4d31-4a4b-9707-e37b2c11d3d2.pdf	15892	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income", "lease_agreement"]}	2026-06-10 03:55:14.603+00	\N	\N
fd538b18-d6f9-4860-acde-b0e853d9eb46	b2fde45d-108b-400a-9b65-e42184ed68a2	d3f9a0f2-68a0-4fdf-913e-420c8753b1ae	liheap	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/fd538b18-d6f9-4860-acde-b0e853d9eb46.pdf	15708	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income", "utility_bill"]}	2026-06-10 03:55:25.505+00	\N	\N
984dd787-2369-4315-b78d-548d4ed1d018	b2fde45d-108b-400a-9b65-e42184ed68a2	9520ee12-d006-4a81-a3a7-31498e8afa92	eitc	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/984dd787-2369-4315-b78d-548d4ed1d018.pdf	15437	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:55:36.302+00	\N	\N
d5584ddd-2354-45df-80bd-150c53de935a	b2fde45d-108b-400a-9b65-e42184ed68a2	c6318ee6-f43b-4fbd-8218-9c24f531704b	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/d5584ddd-2354-45df-80bd-150c53de935a.pdf	15326	4	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["birth_certificate"]}	2026-06-10 03:55:46.9+00	\N	\N
91067f82-72d5-4e01-9e24-20be742d7070	b2fde45d-108b-400a-9b65-e42184ed68a2	c23bacee-d1dd-464b-b0b7-f44c5b83fd03	pell_grant	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/91067f82-72d5-4e01-9e24-20be742d7070.pdf	15320	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:55:57.702+00	\N	\N
277348bb-302f-4977-a8ac-8ff3e40eba88	b2fde45d-108b-400a-9b65-e42184ed68a2	575ac081-c411-45b8-8953-b6df5faa1e13	head_start	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/277348bb-302f-4977-a8ac-8ff3e40eba88.pdf	15915	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-10 03:56:08.495+00	\N	\N
5a07727a-2851-40af-815c-978b87865ae4	b2fde45d-108b-400a-9b65-e42184ed68a2	537e1ef0-e08f-4554-902b-e459a19cfe3b	lifeline	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/5a07727a-2851-40af-815c-978b87865ae4.pdf	15346	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:56:19.399+00	\N	\N
e3aa88f3-0061-4a27-964f-64418a6102a1	b2fde45d-108b-400a-9b65-e42184ed68a2	31636b41-1f19-46f5-893f-789c2c38297b	tanf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/e3aa88f3-0061-4a27-964f-64418a6102a1.pdf	16084	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["bank_statement", "lease_agreement"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-10 03:56:30.2+00	\N	\N
6afa75b8-372a-47c0-b5f3-fb887d6686f0	b2fde45d-108b-400a-9b65-e42184ed68a2	bf794610-1d75-4b8e-b160-9fea9c61e36b	legal_aid	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/6afa75b8-372a-47c0-b5f3-fb887d6686f0.pdf	12752	2	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": []}	2026-06-10 03:56:40.998+00	\N	\N
20baf713-e782-4348-b8e7-cc742428fdac	b2fde45d-108b-400a-9b65-e42184ed68a2	\N	lifeline	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/20baf713-e782-4348-b8e7-cc742428fdac.pdf	15346	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 04:01:17.071+00	\N	\N
282a27c3-122e-4f62-a3f3-679234a5bb50	b2fde45d-108b-400a-9b65-e42184ed68a2	31636b41-1f19-46f5-893f-789c2c38297b	tanf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/282a27c3-122e-4f62-a3f3-679234a5bb50.pdf	16085	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["bank_statement", "lease_agreement"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-10 04:01:44.657+00	\N	\N
1e8f33b7-8db1-4361-ae26-ca495f0f51dc	b2fde45d-108b-400a-9b65-e42184ed68a2	f71b6345-96bf-4fa0-9108-80446d014e7b	snap	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/1e8f33b7-8db1-4361-ae26-ca495f0f51dc.pdf	15539	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:59:42.414+00	\N	\N
c4a6156e-aa8b-4ebf-9ca1-3580379d12d8	b2fde45d-108b-400a-9b65-e42184ed68a2	07f6841d-4774-4fe7-83f6-02b96ed0d009	wic	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/c4a6156e-aa8b-4ebf-9ca1-3580379d12d8.pdf	15596	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-10 03:59:53.512+00	\N	\N
b4eb5ea8-a607-4200-939d-89862d3c836a	b2fde45d-108b-400a-9b65-e42184ed68a2	d6d1d4ba-29cf-4cda-99e4-5e32da32eff3	medicaid	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/b4eb5ea8-a607-4200-939d-89862d3c836a.pdf	12651	3	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": []}	2026-06-10 04:00:04.517+00	\N	\N
5f0a4c59-a2fc-456e-a19d-acb48bba3a95	b2fde45d-108b-400a-9b65-e42184ed68a2	\N	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/5f0a4c59-a2fc-456e-a19d-acb48bba3a95.pdf	15330	5	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["birth_certificate"]}	2026-06-10 04:00:10.422+00	\N	\N
94f810b7-e8aa-46e0-b7ac-d4a3fcd56dab	b2fde45d-108b-400a-9b65-e42184ed68a2	a84b94e5-4e49-4f4f-93aa-a800d2b40568	ccdf	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/94f810b7-e8aa-46e0-b7ac-d4a3fcd56dab.pdf	15592	6	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["monthly_childcare_cost"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["birth_certificate"], "missing_required_documents": ["proof_of_income"]}	2026-06-10 04:00:15.599+00	\N	\N
14c3db55-5366-4fce-b9a5-0434dafa4baa	b2fde45d-108b-400a-9b65-e42184ed68a2	3fdd21af-83e9-4d9f-9574-77fe69c50fe9	section8	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/14c3db55-5366-4fce-b9a5-0434dafa4baa.pdf	15893	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income", "lease_agreement"]}	2026-06-10 04:00:26.206+00	\N	\N
293b97f4-724e-46ff-a36b-a4f82d8ada38	b2fde45d-108b-400a-9b65-e42184ed68a2	d3f9a0f2-68a0-4fdf-913e-420c8753b1ae	liheap	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/293b97f4-724e-46ff-a36b-a4f82d8ada38.pdf	15704	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income", "utility_bill"]}	2026-06-10 04:00:37.213+00	\N	\N
491a6156-d0b8-41cb-aeb4-dfad7b35097a	b2fde45d-108b-400a-9b65-e42184ed68a2	9520ee12-d006-4a81-a3a7-31498e8afa92	eitc	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/491a6156-d0b8-41cb-aeb4-dfad7b35097a.pdf	15438	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 04:00:48.314+00	\N	\N
13942597-15ac-4724-b4cb-c67be296a865	b2fde45d-108b-400a-9b65-e42184ed68a2	c6318ee6-f43b-4fbd-8218-9c24f531704b	child_tax_credit	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/13942597-15ac-4724-b4cb-c67be296a865.pdf	15330	6	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": ["birth_certificate"]}	2026-06-10 04:00:59.429+00	\N	\N
b01ed337-3eb4-47c5-b042-d1f256d03404	b2fde45d-108b-400a-9b65-e42184ed68a2	c23bacee-d1dd-464b-b0b7-f44c5b83fd03	pell_grant	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/b01ed337-3eb4-47c5-b042-d1f256d03404.pdf	15321	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 04:01:10.402+00	\N	\N
fb42608c-a338-4364-9f26-5c8348066295	b2fde45d-108b-400a-9b65-e42184ed68a2	575ac081-c411-45b8-8953-b6df5faa1e13	head_start	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/fb42608c-a338-4364-9f26-5c8348066295.pdf	15912	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["childcare_record"], "missing_required_documents": ["proof_of_income", "birth_certificate"]}	2026-06-10 04:01:21.57+00	\N	\N
60a8d9df-8228-4f32-bf63-c7f916335118	b2fde45d-108b-400a-9b65-e42184ed68a2	537e1ef0-e08f-4554-902b-e459a19cfe3b	lifeline	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/60a8d9df-8228-4f32-bf63-c7f916335118.pdf	15348	4	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 04:01:33.069+00	\N	\N
13626b4f-3cd5-457d-aa5d-a05727a78db8	b2fde45d-108b-400a-9b65-e42184ed68a2	bf794610-1d75-4b8e-b160-9fea9c61e36b	legal_aid	/opt/render/project/src/backend/uploads/pdfs/b2fde45d-108b-400a-9b65-e42184ed68a2/13626b4f-3cd5-457d-aa5d-a05727a78db8.pdf	12748	3	generated	{"is_valid": true, "can_generate": true, "missing_optional_fields": ["urgency"], "missing_required_fields": [], "uploaded_document_types": ["government_id"], "missing_optional_documents": ["proof_of_income"], "missing_required_documents": []}	2026-06-10 04:01:56.27+00	\N	\N
75d49888-8133-4113-9926-4ba1fd5e595c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	\N	liheap	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/75d49888-8133-4113-9926-4ba1fd5e595c.pdf	10837	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": ["utility_bill"]}	2026-06-10 10:41:53.476+00	\N	\N
7f618634-5555-4449-8b5f-22296d3bca95	b7f6902d-d0fe-4c69-ac1f-51faf9245226	a015205e-9a6a-4511-9517-a3fd116fbd17	eitc	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/7f618634-5555-4449-8b5f-22296d3bca95.pdf	15359	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-08 15:00:50.768+00	\N	\N
282a04eb-a582-40bb-8cd1-481a79d87c78	b7f6902d-d0fe-4c69-ac1f-51faf9245226	a015205e-9a6a-4511-9517-a3fd116fbd17	eitc	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/282a04eb-a582-40bb-8cd1-481a79d87c78.pdf	12688	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": []}	2026-06-09 06:31:26.471+00	\N	\N
78771829-fb03-4375-8c0f-aebe5d7683fc	b7f6902d-d0fe-4c69-ac1f-51faf9245226	a015205e-9a6a-4511-9517-a3fd116fbd17	eitc	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/78771829-fb03-4375-8c0f-aebe5d7683fc.pdf	12691	5	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": []}	2026-06-10 10:18:17.324+00	\N	\N
bb86cdb8-1f63-41f3-b585-e8bc999a041b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	a015205e-9a6a-4511-9517-a3fd116fbd17	eitc	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/bb86cdb8-1f63-41f3-b585-e8bc999a041b.pdf	8979	6	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": []}	2026-06-10 10:38:50.675+00	\N	\N
2837c012-b3bd-44b1-9184-e4dacdd8da34	b7f6902d-d0fe-4c69-ac1f-51faf9245226	6d87cdd7-8b34-4c80-9e75-0b6747d2c34f	section8	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/2837c012-b3bd-44b1-9184-e4dacdd8da34.pdf	11071	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["lease_agreement"]}	2026-06-10 10:39:42.955+00	\N	\N
ed733555-c84b-49b5-8cf4-b45420208241	c4966c51-a590-485c-bf82-0d699e087ab8	\N	medicaid	/opt/render/project/src/backend/uploads/pdfs/c4966c51-a590-485c-bf82-0d699e087ab8/ed733555-c84b-49b5-8cf4-b45420208241.pdf	10604	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": [], "missing_optional_documents": ["proof_of_income", "medical_record"], "missing_required_documents": ["government_id"]}	2026-06-10 16:43:57.261+00	\N	\N
e2e42eb5-b2c2-42da-a9da-7cbc21d80330	b7f6902d-d0fe-4c69-ac1f-51faf9245226	40e792ed-6638-4b32-9d62-588767c2e5d8	eitc	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/e2e42eb5-b2c2-42da-a9da-7cbc21d80330.pdf	9154	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id", "proof_of_income"], "missing_optional_documents": [], "missing_required_documents": []}	2026-06-10 17:50:42.36+00	Q1	2026
8fe2f49a-9527-407b-a041-2f2eb12b07a3	b7f6902d-d0fe-4c69-ac1f-51faf9245226	ccd1701a-5b68-4353-8db0-ef3c59935347	eitc	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/8fe2f49a-9527-407b-a041-2f2eb12b07a3.pdf	10912	3	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id", "application_package"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 19:32:05.621+00	Q2	2026
7028976b-432f-4ae3-8204-4ad8cb546a1c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	0a11f50e-0192-4aff-8bb0-7e0e34463470	eitc	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/7028976b-432f-4ae3-8204-4ad8cb546a1c.pdf	10848	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth"], "uploaded_document_types": ["government_id", "application_package"], "missing_optional_documents": [], "missing_required_documents": ["proof_of_income"]}	2026-06-10 18:50:18.075+00	Q4	2026
9e9521bf-24da-47c5-8d22-6195de116ec5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	42b9e00c-9de6-4c10-979a-fa8dcf7ac29b	section8	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/9e9521bf-24da-47c5-8d22-6195de116ec5.pdf	11481	2	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "application_package"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income", "lease_agreement"]}	2026-06-10 19:39:02.313+00	Q1	2026
16e5a279-9ee2-4046-9b81-caf268fa9f26	b7f6902d-d0fe-4c69-ac1f-51faf9245226	42b9e00c-9de6-4c10-979a-fa8dcf7ac29b	section8	/opt/render/project/src/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/16e5a279-9ee2-4046-9b81-caf268fa9f26.pdf	11496	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": [], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "application_package"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income", "lease_agreement"]}	2026-06-10 19:37:12.11+00	Q2	2026
3235f665-56f5-484d-8d97-f51ae9f3c511	b7f6902d-d0fe-4c69-ac1f-51faf9245226	8016e417-ffd4-4853-b4b3-7e2b4ce7e6aa	snap	/Users/diptanshu/Projects/Mom_Plan/backend/uploads/pdfs/b7f6902d-d0fe-4c69-ac1f-51faf9245226/3235f665-56f5-484d-8d97-f51ae9f3c511.pdf	11139	1	generated	{"is_valid": false, "can_generate": true, "missing_optional_fields": ["employer_name", "income_sources"], "missing_required_fields": ["date_of_birth", "address"], "uploaded_document_types": ["government_id", "application_package"], "missing_optional_documents": ["utility_bill", "bank_statement"], "missing_required_documents": ["proof_of_income"]}	2026-06-11 09:37:41.991+00	Q1	2026
\.


--
-- TOC entry 4711 (class 0 OID 27010)
-- Dependencies: 412
-- Data for Name: guide_steps; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guide_steps (id, guide_id, step_number, title, description, plain_english, tip, url, created_at) FROM stdin;
3b5cae7e-5111-4c39-85e1-0a125e028d5d	a1000001-0000-0000-0000-000000000001	1	Create your account	Visit yourtexasbenefits.com and select Create a New Account. Set up your login with a valid email address and password.	Set up an online portal profile.	Save your login credentials — you will need them to track your case status and upload documents later.	\N	2026-06-07 00:38:26.933135+00
eb5c5a80-07e6-4a32-b84e-1ba2ef9be999	a1000001-0000-0000-0000-000000000001	2	Start the SNAP application	Select Apply for Benefits and choose SNAP. Complete the questionnaire about your household size, monthly income, and expenses including rent, utilities, and childcare.	Fill out the online food benefits form.	Include all household income sources including child support, part-time work, and any cash benefits.	\N	2026-06-07 00:38:26.933135+00
1ef84af9-5330-4c89-b3dc-93df3e73aa5e	a1000001-0000-0000-0000-000000000001	3	Upload asset documents	Upload bank statements and vehicle registration. Texas limits household assets to $5,000 and evaluates vehicle values — only one vehicle excluded up to $22,000.	Upload copies of your savings records and car registration.	If your vehicle is worth more than $22,000, the excess value counts toward your $5,000 asset limit. Most standard vehicles are fine.	\N	2026-06-07 00:38:26.933135+00
ca942a22-f02d-4add-bb37-e4db5bb70a54	a1000001-0000-0000-0000-000000000001	4	Complete the phone interview	HHSC will schedule a telephone interview with a caseworker within 30 days. Be ready to confirm your household information and income details over the phone.	Speak with a benefits worker over the phone.	Keep your documents handy during the call. If you miss the call, reschedule the same day to avoid delays.	\N	2026-06-07 00:38:26.933135+00
e9d569ac-1abf-4dba-82a9-7101edaaea1f	a1000001-0000-0000-0000-000000000001	5	Receive your Lone Star EBT card	If approved, your Lone Star card will arrive by mail within 7–10 days of the decision. Benefits are loaded monthly. Use it like a debit card at grocery stores.	Receive your food debit card by mail.	Your first month may include back-dated benefits if processing took more than 30 days.	https://www.yourtexasbenefits.com	2026-06-07 00:38:26.933135+00
ca993f11-1d76-4bd4-9407-48c0ab113fc5	a1000001-0000-0000-0000-000000000002	1	Complete the pre-screening	Visit texaswic.org and complete the short online pre-qualification form to confirm you likely meet basic WIC eligibility before calling.	Fill out the basic pre-qualification form online.	WIC is open to pregnant women, breastfeeding mothers, and children under 5 with income at or below 185% FPL.	https://www.texaswic.org/apply	2026-06-07 00:38:26.933135+00
8c72808f-c4e8-4724-aade-d5e52603635a	a1000001-0000-0000-0000-000000000002	2	Find your nearest clinic	Use the zip code locator on texaswic.org to find the WIC clinic closest to your home or workplace.	Locate a local WIC office.	\N	https://www.texaswic.org	2026-06-07 00:38:26.933135+00
d05ff840-f526-4846-9fdf-2f2dfda70d4e	a1000001-0000-0000-0000-000000000002	3	Call the clinic to schedule	Contact the clinic directly by phone to book your in-person intake appointment. Texas WIC requires an in-person visit for initial enrollment.	Call the clinic to book an appointment.	Ask about weekend or evening hours if weekday appointments are hard to get.	\N	2026-06-07 00:38:26.933135+00
68383a7d-98c6-4006-8c22-70faebd55167	a1000001-0000-0000-0000-000000000002	4	Bring your documents	Attend the appointment with photo ID, proof of address (utility bill or lease), and your child's immunization records. If pregnant, bring proof of pregnancy from your doctor.	Bring your ID, a utility bill, and your child's vaccine records to the clinic.	Already on SNAP or Medicaid? You are automatically income-eligible — bring your benefit letter to skip the income verification step.	\N	2026-06-07 00:38:26.933135+00
462192cc-3409-47df-9722-944eea052cba	a1000001-0000-0000-0000-000000000002	5	Complete the health screening and receive your eWIC card	A nutritionist will review your health information and your child's growth. Once approved, you receive a preloaded eWIC card the same day.	Complete your clinic visit and receive your food benefits card.	eWIC works at most major grocery stores. Ask the clinic for the approved food list.	\N	2026-06-07 00:38:26.933135+00
ec1b9229-b0f0-43d3-9cf7-be3ac1a386a9	a1000001-0000-0000-0000-000000000003	1	Log in and start the TANF application	Go to yourtexasbenefits.com, log in, and select Apply for TANF Cash Help.	Log in and start the cash assistance form.	\N	https://www.yourtexasbenefits.com	2026-06-07 00:38:26.933135+00
d867aab5-eb6e-43e4-94c7-ff32be432224	a1000001-0000-0000-0000-000000000003	2	Declare your assets	List all household cash, bank accounts, and owned property. Texas enforces a $1,000 asset limit for TANF — this is strict. Vehicles are evaluated separately.	List your money and assets.	If your household assets exceed $1,000, you must spend down to that level before approval. This does not apply to SNAP.	\N	2026-06-07 00:38:26.933135+00
4cf250c5-fe36-4a9f-95fd-338ae088134b	a1000001-0000-0000-0000-000000000003	3	Sign the Personal Responsibility Agreement	You must sign a Personal Responsibility Agreement committing to work or training, cooperating with child support, and ensuring your children are immunized and enrolled in school.	Sign the state rules agreement and upload proof that your kids are in school.	If you are a survivor of domestic violence, you may be eligible for a good cause exemption from some work requirements. Ask your caseworker.	\N	2026-06-07 00:38:26.933135+00
001945f7-310a-4c82-a192-f73108c047b5	a1000001-0000-0000-0000-000000000003	4	Complete the caseworker interview	HHSC will schedule a telephone intake interview. Have your income documents, children's birth certificates, and SSNs ready.	Talk to a program caseworker over the phone.	\N	\N	2026-06-07 00:38:26.933135+00
d6aecb0c-b080-4990-bb36-0bf676446e6c	a1000001-0000-0000-0000-000000000003	5	Receive your monthly cash benefit	If approved, benefits are deposited monthly to your Lone Star EBT card. The maximum for a family of 3 is $382/month.	Receive your cash payments on your benefit card.	TANF has a federal 60-month lifetime limit. Texas does not have a shorter state limit.	\N	2026-06-07 00:38:26.933135+00
5103fbff-1d92-4824-8e2b-46237d8d011f	a2000002-0000-0000-0000-000000000001	1	Create a BenefitsCal account	Go to benefitscal.com and click Get Started. Create a personal account with your email address.	Create a benefits account online.	BenefitsCal is the single portal for CalFresh, CalWORKs, and Medi-Cal — you only need one account.	https://www.benefitscal.com	2026-06-07 00:38:26.933135+00
185f4e3c-51a9-4368-a761-911bae41aeff	a2000002-0000-0000-0000-000000000001	2	Complete the CalFresh application	Select CalFresh and complete the application with details on household members, monthly income, and housing costs including rent, utilities, and childcare expenses.	Complete the online food assistance form.	Include all income even if irregular. Being honest is important — errors can cause delays or overpayment recovery later.	\N	2026-06-07 00:38:26.933135+00
76c24204-f6e3-401a-ad62-24a6007d1339	a2000002-0000-0000-0000-000000000001	3	Upload your documents	Upload photo ID, proof of California residency (utility bill or lease), and recent pay stubs or award letters.	Upload copies of your ID and pay stubs.	California has no asset limit for CalFresh under Broad-Based Categorical Eligibility — you do not need to report savings or vehicle value.	\N	2026-06-07 00:38:26.933135+00
5f49c176-27a0-4893-adef-f853ff5ecbc3	a2000002-0000-0000-0000-000000000001	4	Complete the caseworker phone interview	A county social services caseworker will contact you to verify your information. The interview is usually by phone.	Speak with a county worker over the phone.	If you need interpretation services, request them when you apply — California supports multiple languages.	\N	2026-06-07 00:38:26.933135+00
0e0cec97-f307-4187-b5af-1f5517fb012b	a2000002-0000-0000-0000-000000000001	5	Receive your Golden State Advantage EBT card	Approved benefits load to your Golden State Advantage EBT card, which arrives by mail within 30 days of approval.	Get your food stamp debit card by mail.	You can check your balance and transaction history at ebt.ca.gov or through the Providers app.	\N	2026-06-07 00:38:26.933135+00
277d3f72-0b09-4c6b-a5e9-fbded60ad13c	a2000002-0000-0000-0000-000000000003	1	Apply through BenefitsCal	Go to benefitscal.com and select Apply for CalWORKs.	Apply for cash aid online.	\N	https://www.benefitscal.com	2026-06-07 00:38:26.933135+00
890dafbc-631f-4b16-8b75-5096fbaae845	a2000002-0000-0000-0000-000000000003	2	Declare income and assets	List all household income, bank account balances, and vehicle information. California's asset limit for CalWORKs is $12,552 (raised in 2026).	List your earnings, savings, and vehicles.	Vehicles are generally excluded from the asset count. The $12,552 limit applies to liquid assets like bank accounts.	\N	2026-06-07 00:38:26.933135+00
1ee5a1b4-b274-465c-9acf-caa14381b210	a2000002-0000-0000-0000-000000000003	3	Attend the county intake interview	You must attend an in-person interview at your county social services office. This can take 3–4 hours. Bring photo ID, SSNs, children's birth certificates, and proof of residency.	Attend the face-to-face meeting at the county office.	Arrange childcare before you go — the interview is long and children can be difficult to manage during the session.	\N	2026-06-07 00:38:26.933135+00
13744427-e41a-462f-9eb2-931291d063a1	a2000002-0000-0000-0000-000000000003	4	Complete Welfare-to-Work appraisal	Meet with your assigned employment counselor to complete the OCAT (Online CalWORKs Appraisal Tool) assessment and create your Welfare-to-Work plan.	Meet with a job coach to set up your work training plan.	If you have a child under 6, your work requirement is 20 hours/week instead of 30. DV survivors can request safety accommodations.	\N	2026-06-07 00:38:26.933135+00
ba9e659d-9654-4cc8-bdaf-d9cdc9c11119	a2000002-0000-0000-0000-000000000003	5	Receive monthly cash on EBT	Approved cash aid is loaded monthly to your Golden State Advantage EBT card. For a family of 3 in Region 1, the maximum is $1,175/month.	Receive your cash payments on your benefits card.	Stage 1 childcare is available immediately alongside CalWORKs — request it at the same intake appointment.	\N	2026-06-07 00:38:26.933135+00
c5d8f5b8-d840-4149-862f-2cba93b5650f	a3000003-0000-0000-0000-000000000001	1	Create an ACCESS Florida account	Go to myflfamilies.com and select Create My ACCESS Account.	Go online and register for a state benefits account.	\N	https://www.myflfamilies.com	2026-06-07 00:38:26.933135+00
11ce60cf-3a0a-43b7-b1f1-d331cf8ae4aa	a3000003-0000-0000-0000-000000000001	2	Complete the food assistance application	Fill out the online form with your household size, monthly income, and expenses.	Complete the food assistance form online.	Florida has no asset test for most food assistance households under Broad-Based Categorical Eligibility.	\N	2026-06-07 00:38:26.933135+00
75a9db8c-db81-4999-8115-9d93820b48c0	a3000003-0000-0000-0000-000000000001	3	Upload your documents	Upload photo ID, proof of Florida residency, and recent pay stubs.	Upload copies of your ID and pay stubs.	\N	\N	2026-06-07 00:38:26.933135+00
e31253f4-71d4-4d7c-9a27-ffd9cb94094f	a3000003-0000-0000-0000-000000000001	4	Complete the phone interview	A DCF benefits caseworker will call to verify your information.	Complete your benefits phone call with a caseworker.	If you have Haitian Creole or Spanish-speaking household members, request interpretation when you apply.	\N	2026-06-07 00:38:26.933135+00
4207a44e-6346-4524-b87f-02a646092be1	a3000003-0000-0000-0000-000000000001	5	Receive your ACCESS EBT card	Approved benefits load to your ACCESS Florida EBT card within 30 days.	Receive your food debit card by mail.	\N	https://www.myflfamilies.com	2026-06-07 00:38:26.933135+00
8c11a62c-45b4-4796-86bf-29323c1ed130	a4000004-0000-0000-0000-000000000001	1	Create a myBenefits NY account	Go to mybenefits.ny.gov and create a personal NY.gov ID account.	Create a state benefits account online.	\N	https://www.mybenefits.ny.gov	2026-06-07 00:38:26.933135+00
96b12202-3387-4cfe-ac7e-8d607ebedafb	a4000004-0000-0000-0000-000000000001	2	Complete the SNAP application	Select Apply for SNAP and fill out the questionnaire about your household, income, and housing expenses.	Complete the online food benefits form.	New York has no asset limit for most SNAP households under Broad-Based Categorical Eligibility.	\N	2026-06-07 00:38:26.933135+00
54ad8c5f-a70f-48a7-9653-6dbed78ed249	a4000004-0000-0000-0000-000000000001	3	Upload your proof documents	Upload photo ID, proof of NY residency, and recent pay stubs.	Upload copies of your ID and pay stubs.	\N	\N	2026-06-07 00:38:26.933135+00
b8fe177b-5531-4857-a619-fde4bec63011	a4000004-0000-0000-0000-000000000001	4	Complete the required interview	A county social services caseworker will contact you for a phone or in-person interview.	Speak with a county worker.	\N	\N	2026-06-07 00:38:26.933135+00
e7dc82a7-48bb-4d9f-a70d-19e0714e3a41	a4000004-0000-0000-0000-000000000001	5	Receive your Common Benefit Identification Card	Your SNAP benefits load to the CBIC EBT card, which arrives by mail.	Get your food stamp debit card by mail.	NYC residents can use Fresh Connect Checks for farmers markets in addition to the CBIC card.	\N	2026-06-07 00:38:26.933135+00
d0d3403b-2c78-4bf6-b1b5-806c5a5a35eb	a5000005-0000-0000-0000-000000000001	1	Access the ABE portal	Go to abe.illinois.gov and click Apply for Benefits.	Go online and create a benefits account.	\N	https://abe.illinois.gov	2026-06-07 00:38:26.933135+00
4889ddab-1a6f-493d-aa4c-2b5fcee2a499	a5000005-0000-0000-0000-000000000001	2	Complete the SNAP application	Select SNAP and fill out the application with your household members, income, and housing costs.	Complete the food assistance form online.	Illinois has no asset limit for SNAP under Broad-Based Categorical Eligibility.	\N	2026-06-07 00:38:26.933135+00
b03c41b7-c7bb-4be4-b913-d75586f6fca8	a5000005-0000-0000-0000-000000000001	3	Upload your documents	Upload photo ID, proof of Illinois residency, and recent pay stubs.	Upload copies of your ID and pay stubs.	\N	\N	2026-06-07 00:38:26.933135+00
481f8c3d-3edc-4641-8e7e-c1ea4f2cea3a	a5000005-0000-0000-0000-000000000001	4	Complete the IDHS phone interview	An IDHS caseworker will call to verify your household information.	Speak with a benefits caseworker over the phone.	If you need Spanish-language service, request it when you apply at abe.illinois.gov.	\N	2026-06-07 00:38:26.933135+00
9e797aa2-5ce6-4bd2-8f27-0c172579307c	a5000005-0000-0000-0000-000000000001	5	Receive your Illinois Link card	Approved SNAP benefits load to your Illinois Link card, which arrives by mail.	Receive your Link card by mail.	You can check your Link card balance at illinoislink.com or by calling 1-800-678-5465.	\N	2026-06-07 00:38:26.933135+00
\.


--
-- TOC entry 4714 (class 0 OID 27035)
-- Dependencies: 415
-- Data for Name: income_thresholds; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.income_thresholds (id, program_id, household_size, income_limit, income_limit_yr, benefit_amount, co_pay, notes, created_at) FROM stdin;
9e98d8ee-bae1-4388-ace4-b78b3f0e41be	snap	1	1580	18960	291	\N	2026 federal SNAP gross income limit at 130% FPL. Max benefit HH of 1.	2026-06-07 00:36:40.174289+00
359924b5-a030-4ecf-9bfe-ff5d6817e40b	snap	2	2137	25644	535	\N	2026 federal SNAP gross income limit at 130% FPL. Max benefit HH of 2.	2026-06-07 00:36:40.174289+00
542dc22e-6328-4b48-8032-18f28612a5cb	snap	3	2694	32328	766	\N	2026 federal SNAP gross income limit at 130% FPL. Max benefit HH of 3.	2026-06-07 00:36:40.174289+00
ed859272-ad2f-48a9-9433-fff0d28dec44	snap	4	3250	39000	973	\N	2026 federal SNAP gross income limit at 130% FPL. Max benefit HH of 4.	2026-06-07 00:36:40.174289+00
4645af6d-408c-4efa-9ce1-cbedf8a96d00	snap	5	3807	45684	1155	\N	2026 federal SNAP gross income limit at 130% FPL. Max benefit HH of 5.	2026-06-07 00:36:40.174289+00
80d78d66-f3a2-4d00-b681-cde649dc3e92	wic	1	2248	26973	\N	\N	2026 federal WIC gross income limit at 185% FPL. HH of 1.	2026-06-07 00:36:40.174289+00
0e561aeb-c037-42de-9699-a8c931998abe	wic	2	3041	36482	\N	\N	2026 federal WIC gross income limit at 185% FPL. HH of 2.	2026-06-07 00:36:40.174289+00
b449aaca-cc94-4c24-8b60-0ff24eae18fa	wic	3	3833	45990	\N	\N	2026 federal WIC gross income limit at 185% FPL. HH of 3.	2026-06-07 00:36:40.174289+00
f8f9d8a4-f929-4149-ad5f-36562ff1d8ee	wic	4	4625	55500	\N	\N	2026 federal WIC gross income limit at 185% FPL. HH of 4.	2026-06-07 00:36:40.174289+00
fdafa10a-ddc6-46e4-a71b-0995f1399d9d	wic	5	5418	65010	\N	\N	2026 federal WIC gross income limit at 185% FPL. HH of 5.	2026-06-07 00:36:40.174289+00
375ddb4b-613f-4ba6-89eb-4a9760b9886f	tanf_tx	1	159	1908	159	\N	TX TANF HH of 1: income limit ~$159/mo. Max benefit $159/mo.	2026-06-07 00:36:40.174289+00
5eee0fd8-38fb-41c8-8f5a-23284239e1c6	tanf_tx	2	163	1956	163	\N	TX TANF HH of 2: income limit ~$163/mo. Max benefit $163/mo.	2026-06-07 00:36:40.174289+00
56cb40fc-ce9c-46f5-98e9-7329a9f04cb1	tanf_tx	3	188	2256	382	\N	TX TANF HH of 3: income limit ~$188/mo. Max benefit $382/mo (1 parent + 2 children). Note: very low — one of lowest in the nation.	2026-06-07 00:36:40.174289+00
db08ca76-c174-4b7c-bf65-974368395272	tanf_tx	4	226	2712	430	\N	TX TANF HH of 4: income limit ~$226/mo. Max benefit $430/mo.	2026-06-07 00:36:40.174289+00
0c96d900-08bf-40ce-8275-567ebfff2074	tanf_tx	5	251	3012	497	\N	TX TANF HH of 5: income limit ~$251/mo. Max benefit $497/mo.	2026-06-07 00:36:40.174289+00
b11b0d4b-3b80-4c2a-884a-d289a2dd22a2	medicaid_tx	3	341	4092	\N	\N	TX Medicaid adult parent income limit ~12-17% FPL ($341/mo for family of 3). Non-expanded state.	2026-06-07 00:36:40.174289+00
25f14ecb-704f-47b9-a8d5-e7c9127a73b2	tanf_ca	1	734	8808	734	\N	CA CalWORKs HH of 1. Max benefit and income limit ~$734/mo.	2026-06-07 00:36:40.174289+00
495042d9-6306-474c-aa28-2e1863f8a286	tanf_ca	2	930	11160	930	\N	CA CalWORKs HH of 2. Max benefit and income limit ~$930/mo.	2026-06-07 00:36:40.174289+00
a81be8db-9e80-4ef1-8775-0e175f84b6d0	tanf_ca	3	1175	14100	1175	\N	CA CalWORKs HH of 3 (Region 1). Max benefit $1,175/mo — highest TANF benefit in the nation.	2026-06-07 00:36:40.174289+00
a22ea767-fd81-4e70-9760-c62dbad2c6f8	tanf_ca	4	1416	16992	1416	\N	CA CalWORKs HH of 4. Max benefit ~$1,416/mo.	2026-06-07 00:36:40.174289+00
638fd0e3-accd-470f-996c-adc63ee72784	tanf_ca	5	1659	19908	1659	\N	CA CalWORKs HH of 5. Max benefit ~$1,659/mo.	2026-06-07 00:36:40.174289+00
ab062dde-d1bd-45d3-ab4c-76ba5fe0a045	medicaid_ca	3	3141	37692	\N	\N	CA Medi-Cal expanded: adult income limit 138% FPL ($3,141/mo for family of 3). No work requirement.	2026-06-07 00:36:40.174289+00
1b379240-9e17-4a14-965d-d2750ed0f806	tanf_fl	1	180	2160	180	\N	FL TCA HH of 1. Max benefit $180/mo.	2026-06-07 00:36:40.174289+00
6fd2e732-7998-43a4-8374-e768f28358e5	tanf_fl	2	241	2892	241	\N	FL TCA HH of 2. Max benefit $241/mo.	2026-06-07 00:36:40.174289+00
68b64cdf-a7a8-4f53-b983-a72a201cd03d	tanf_fl	3	303	3636	303	\N	FL TCA HH of 3. Max benefit $303/mo — one of the lowest in the nation. 48-month lifetime limit.	2026-06-07 00:36:40.174289+00
a229305d-1d9a-46e6-b063-df56ab4cbb17	tanf_fl	4	355	4260	355	\N	FL TCA HH of 4. Max benefit $355/mo.	2026-06-07 00:36:40.174289+00
7d5e8720-ac6b-4a5c-9ba9-65eb8496455a	tanf_fl	5	415	4980	415	\N	FL TCA HH of 5. Max benefit $415/mo.	2026-06-07 00:36:40.174289+00
3e4c6ad7-bb81-46e7-b677-943ad66b9328	medicaid_fl	3	615	7380	\N	\N	FL Medicaid adult parent income limit ~27% FPL ($615/mo for family of 3). Non-expanded state.	2026-06-07 00:36:40.174289+00
9ffe3aa3-674b-4b12-b64e-87758bf7afd4	tanf_ny	1	450	5400	450	\N	NY Family Assistance HH of 1. Benefit varies by county, ~$450/mo.	2026-06-07 00:36:40.174289+00
6a86153d-56ba-402f-83e7-036a9f9abce9	tanf_ny	2	648	7776	648	\N	NY Family Assistance HH of 2. Benefit ~$648/mo.	2026-06-07 00:36:40.174289+00
60e1d760-f729-4b84-bea4-d01b00721d93	tanf_ny	3	836	10032	836	\N	NY Family Assistance HH of 3. Benefit $648–$836/mo depending on county. Income limit ~$336/mo Standard of Need.	2026-06-07 00:36:40.174289+00
6ef3f0b3-6547-4353-adda-8461a0e0aae6	tanf_ny	4	900	10800	900	\N	NY Family Assistance HH of 4. Benefit ~$900/mo.	2026-06-07 00:36:40.174289+00
74b67b35-16f7-41a0-bb46-23e8bb0037f7	medicaid_ny	3	3065	36780	\N	\N	NY Medicaid expanded: adult income limit 138% FPL ($3,065/mo for family of 3). No work requirement.	2026-06-07 00:36:40.174289+00
2d45414b-2b5d-4ebd-a0ef-d031a1da1c32	tanf_il	1	456	5472	456	\N	IL TANF HH of 1. Max benefit $456/mo.	2026-06-07 00:36:40.174289+00
403ff52a-2fed-49d7-92bc-69a1e4fd5718	tanf_il	2	617	7404	617	\N	IL TANF HH of 2. Max benefit $617/mo.	2026-06-07 00:36:40.174289+00
c7394f23-cec6-4e47-901a-55c70b27c5d3	tanf_il	3	777	9324	777	\N	IL TANF HH of 3. Max benefit $777/mo. Child-only case limit is $583/mo.	2026-06-07 00:36:40.174289+00
ebaeb65d-a9d9-4e54-97fd-b401a453e7eb	tanf_il	4	938	11256	938	\N	IL TANF HH of 4. Max benefit $938/mo.	2026-06-07 00:36:40.174289+00
3bb15c4c-676b-4416-ae24-66cf133844eb	tanf_il	5	1098	13176	1098	\N	IL TANF HH of 5. Max benefit $1,098/mo.	2026-06-07 00:36:40.174289+00
a15d485e-dad5-4ff2-a7cf-2fbda5b98138	medicaid_il	3	3141	37692	\N	\N	IL Medicaid expanded: adult income limit 138% FPL ($3,141/mo for family of 3). No work requirement.	2026-06-07 00:36:40.174289+00
\.


--
-- TOC entry 4704 (class 0 OID 26949)
-- Dependencies: 405
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, type, title, message, is_read, created_at, related_application_id, action_url) FROM stdin;
e1f26f94-0d7e-48ef-aa92-15b6d7c18064	99377481-f483-4c4c-afdf-bf3ece076349	status_update	🎯 Eligibility Scan Complete	Scan complete: 12 programs matched out of 13 checked. View your Benefits page for details.	f	2026-06-04 13:05:05.327+00	\N	\N
16b879cd-ae51-49cd-b6a2-77e3cddc28dc	b7f6902d-d0fe-4c69-ac1f-51faf9245226	status_update	🎯 Eligibility Scan Complete	Scan complete: 8 programs matched out of 13 checked. View your Benefits page for details.	f	2026-06-05 04:11:08.243+00	\N	\N
faca17d5-51c2-40b3-9938-3235db8c4401	b2fde45d-108b-400a-9b65-e42184ed68a2	status_update	🎯 Eligibility Scan Complete	Scan complete: 13 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-08 14:22:28.74+00	\N	\N
ffd584af-e1b7-40ad-bdbf-2ce4e6f51e37	c4966c51-a590-485c-bf82-0d699e087ab8	status_update	🎯 Eligibility Scan Complete	Scan complete: 8 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-09 03:40:24.52+00	\N	\N
c3a5d86a-24f3-4137-8c81-f0a41b26e398	c4966c51-a590-485c-bf82-0d699e087ab8	status_update	🎯 Eligibility Scan Complete	Scan complete: 8 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-09 03:48:47.588+00	\N	\N
a4c61be2-1ab4-418a-9d82-7f7132c42cc9	ad89b347-7133-4c28-b420-0c6601fc139f	status_update	🎯 Eligibility Scan Complete	Scan complete: 8 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-09 05:38:58.786+00	\N	\N
6e59f56b-0bd5-4e47-9af7-0e87bc4e42dc	ad89b347-7133-4c28-b420-0c6601fc139f	status_update	🎯 Eligibility Scan Complete	Scan complete: 8 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-09 05:41:03.673+00	\N	\N
ddf7fbff-94fb-44e8-948e-12ba5509f6dd	9f96c2cf-298d-4553-a094-a13af906b497	status_update	🎯 Eligibility Scan Complete	Scan complete: 3 programs matched out of 53 checked. View your Benefits page for details.	t	2026-06-09 07:01:33.809+00	\N	\N
bd932cbd-7ee5-4e5d-ad2b-3b31433a4e41	9f96c2cf-298d-4553-a094-a13af906b497	status_update	🎯 Eligibility Scan Complete	Scan complete: 3 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-09 07:14:53.506+00	\N	\N
e46a30f8-32a3-4754-982e-f11e81f4f348	9f96c2cf-298d-4553-a094-a13af906b497	status_update	🎯 Eligibility Scan Complete	Scan complete: 3 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-09 07:19:00.21+00	\N	\N
9e3d5cc5-49ad-4d2b-852f-f80ae132c253	dcf8d6a3-0282-402d-b40f-95ad3b24be73	status_update	🎯 Eligibility Scan Complete	Scan complete: 13 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-09 09:23:53.838+00	\N	\N
aac35f93-ef5d-4249-b0ac-6b15cb9fb795	b7f6902d-d0fe-4c69-ac1f-51faf9245226	status_update	🎯 Eligibility Scan Complete	Scan complete: 8 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-09 19:08:49.872+00	\N	\N
f780e062-a295-4ebd-b1fb-3db42136b2ed	b2fde45d-108b-400a-9b65-e42184ed68a2	status_update	🎯 Eligibility Scan Complete	Scan complete: 13 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-10 03:54:21.243+00	\N	\N
63969ace-3105-4afa-8517-efeb48418c6c	b2fde45d-108b-400a-9b65-e42184ed68a2	status_update	🎯 Eligibility Scan Complete	Scan complete: 13 programs matched out of 53 checked. View your Benefits page for details.	f	2026-06-10 03:59:32.045+00	\N	\N
\.


--
-- TOC entry 4716 (class 0 OID 27067)
-- Dependencies: 417
-- Data for Name: org_services; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.org_services (id, org_id, service_type, notes, created_at) FROM stdin;
\.


--
-- TOC entry 4715 (class 0 OID 27043)
-- Dependencies: 416
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.organizations (id, org_name, category, purpose, phone, crisis_line, email, website, address, city, state, zip_code, counties_served, populations_served, languages_served, intake_process, hours_of_operation, flag_dv, flag_eviction, flag_children_u5, flag_pregnant, flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode, partner_tier, last_verified_date, source_url, active, created_at, updated_at, service_tags, referral_notes) FROM stdin;
f5225321-3ee1-4145-a286-49faaa3fac3f	2-1-1 Texas	211	Statewide information and referral service connecting Texans to health, human services, and emergency assistance programs in their area.	211	\N	\N	https://www.211texas.org	\N	statewide	TX	\N	{statewide}	{everyone}	{en,es}	Dial 2-1-1 or visit 211texas.org to search online.	24/7	f	f	f	f	f	f	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
c7723dc4-08a2-4532-8d1c-168eb53e94d6	Gracewood	shelter	Transitional housing and wraparound support for single mothers and children, providing safe housing, childcare support, and workforce development.	713-988-9757	\N	\N	https://www.gracewood.org	\N	Houston	TX	\N	{Harris}	{"single mothers",children}	{en,es}	Submit an online intake application at gracewood.org.	Mon–Fri 9am–5pm	f	t	t	f	f	f	t	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
c92580c7-40ed-4552-9e6f-cae8e69dbda7	Houston Food Bank	food	Largest food bank in the nation by distribution, serving 18 counties with food pantries, mobile distributions, and SNAP outreach.	832-369-9390	\N	\N	https://www.houstonfoodbank.org	\N	Houston	TX	\N	{Harris,Montgomery,Chambers,"Fort Bend"}	{"low income families"}	{en,es}	Walk in during distribution hours or use the online food finder.	Varies by location	f	f	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
224c3eea-4a6a-4ded-bc93-55ace68438cd	Aldine Community WIC Center	maternal_health	State-contracted WIC clinic providing nutrition education, breastfeeding support, and monthly food benefits for pregnant women, new mothers, and children under 5.	832-393-5427	\N	\N	https://www.texaswic.org	\N	Houston	TX	\N	{Harris}	{"pregnant women",infants,"children under 5"}	{en,es}	Call to schedule an appointment.	Mon–Fri 8am–5pm	f	f	t	t	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
0234ee22-d573-418d-a768-9cee37e90759	Harris County Social Services	government	County agency providing benefits screening, emergency assistance, and referrals to SNAP, Medicaid, and other assistance programs for Harris County residents.	713-696-7900	\N	\N	https://csd.harriscountytx.gov	\N	Houston	TX	\N	{Harris}	{"low income residents"}	{en,es}	Walk in or apply online at harriscountytx.gov.	Mon–Fri 8am–5pm	f	t	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
7a52c13d-767c-4bbc-8426-b1c0839b3505	Houston Housing Authority	government	Public housing authority administering Section 8 Housing Choice Vouchers and public housing units for low-income Houston households.	713-260-0500	\N	\N	https://www.housingforhouston.com	\N	Houston	TX	\N	{Harris}	{"low income households"}	{en,es}	Apply during active waitlist openings announced on the HHA website.	Mon–Fri 8am–5pm	f	t	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
95a7880c-286a-46eb-acad-ca972b70a897	Guadalupe Home	shelter	Residential program for pregnant women and parenting mothers providing safe transitional housing, parenting education, and case management.	210-476-0707	\N	\N	https://ccaosa.org/guadalupe-home	\N	San Antonio	TX	\N	{Bexar}	{"pregnant women","parenting mothers"}	{en,es}	Call for intake screening.	Mon–Fri 8am–5pm	f	t	t	t	f	f	t	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
a1a49799-de1c-4b18-8ebb-fafcd2ad8556	SAMMinistries	housing	Nonprofit providing emergency shelter, transitional housing, and rapid rehousing for homeless individuals and families at risk of homelessness.	210-340-1550	\N	\N	https://www.samm.org	\N	San Antonio	TX	\N	{Bexar}	{homeless,"at risk of homelessness"}	{en,es}	Visit the intake office for assessment.	24/7 for emergency shelter	f	t	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
d986a5be-abe9-43e7-8f75-db8f0235202e	Arms of Hope	wraparound	Comprehensive wraparound support for single mothers including residential care, childcare, education, job training, and financial literacy.	903-224-4900	\N	\N	https://armsofhope.org	\N	Dallas	TX	\N	{Dallas,Kaufman}	{"single mothers",children}	{en}	Submit an online intake application at armsofhope.org.	Mon–Fri 8am–5pm	f	t	t	t	t	f	t	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
91a31f7e-34fd-4a65-a752-526ecec18cb7	Legal Aid of Northwest Texas	legal	Free civil legal services for low-income individuals including eviction defense, family law, benefits denials, and domestic violence orders.	1-888-529-5277	\N	\N	https://www.lanwt.org	\N	Dallas	TX	\N	{Dallas,Tarrant,Parker,Denton}	{"low income individuals"}	{en,es}	Call the intake line or apply online at lanwt.org.	Mon–Fri 9am–5pm	t	t	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
5777d64b-4fe1-4dfc-86a1-3d3c22d0e3e4	The Family Place	dv	Comprehensive domestic violence services including emergency shelter, counseling, legal advocacy, and economic empowerment programs for survivors.	214-559-2170	214-941-1991	\N	https://www.familyplace.org	\N	Dallas	TX	\N	{Dallas}	{"survivors of domestic violence"}	{en,es}	Call the 24/7 crisis line — address protected for safety.	24/7 crisis line	t	t	t	f	f	f	f	t	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
87518f89-1f02-4cd0-9cb5-79d77e39fa6a	OAG Child Support San Antonio	government	Texas Office of the Attorney General local child support office handling paternity establishment, support orders, and enforcement for Bexar County.	210-208-6800	\N	\N	https://www.texasattorneygeneral.gov/child-support	\N	San Antonio	TX	\N	{Bexar}	{"single mothers","custodial parents"}	{en,es}	Apply online at texasattorneygeneral.gov or visit the local office.	Mon–Fri 8am–5pm	f	f	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
ac160a62-76c4-4e56-9083-35646295e921	211 LA County / CA 211	211	Statewide information and referral network connecting Californians to social services, health resources, and emergency assistance.	211	\N	\N	https://www.211la.org	\N	statewide	CA	\N	{statewide}	{everyone}	{en,es,zh,vi}	Dial 2-1-1 or visit 211la.org to search online.	24/7	f	f	f	f	f	t	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
0df551f4-a5ac-410f-a81d-ad78b0194437	SHE IS HOPE LA	shelter	Transitional housing and comprehensive support services specifically for single mothers, offering safe housing, childcare referrals, and workforce development.	818-763-4673	\N	\N	https://www.sheishopela.org	\N	Los Angeles	CA	\N	{"Los Angeles"}	{"single mothers",children}	{en,es}	Complete online intake form at sheishopela.org.	Mon–Fri 9am–5pm	f	t	t	f	t	f	t	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
ffbd7c8a-7c69-4fd6-993d-411f7a9b8da2	Los Angeles Regional Food Bank	food	One of the largest food banks in the US, distributing food through 700+ partner agencies across Los Angeles County.	323-234-3030	\N	\N	https://www.lafoodbank.org	\N	Los Angeles	CA	\N	{"Los Angeles"}	{"low income families"}	{en,es,zh}	Search the food pantry locator online at lafoodbank.org.	Varies by location	f	f	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
1f379fb1-0bca-45e0-af56-f0639db529fd	Legal Aid Foundation of LA	legal	Free civil legal services for low-income LA residents including eviction defense, domestic violence restraining orders, immigration, and public benefits.	1-800-399-4529	\N	\N	https://lafla.org	\N	Los Angeles	CA	\N	{"Los Angeles"}	{"low income individuals"}	{en,es,zh,ko}	Apply online or call the intake line.	Mon–Fri 9am–5pm	t	t	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
1676a7f2-3e3b-42ed-97b9-330a835de42f	Jenesse Center	dv	Comprehensive domestic violence services for survivors including emergency shelter, legal advocacy, children's programming, and long-term housing.	323-759-9909	1-800-479-7328	\N	https://www.jenesse.org	\N	Los Angeles	CA	\N	{"Los Angeles"}	{"domestic violence survivors"}	{en,es}	Call the 24/7 emergency hotline — address protected for safety.	24/7 crisis line	t	t	t	f	f	f	f	t	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
bcb72a82-57ed-474b-92e8-6cbd0a8fa4d6	South LA Health Projects WIC	maternal_health	WIC clinic providing nutrition education, breastfeeding support, and monthly food benefits for pregnant women, mothers, and children under 5 in South LA.	323-757-7510	\N	\N	https://www.slahp.org	\N	Los Angeles	CA	\N	{"Los Angeles"}	{"pregnant women",infants,"children under 5"}	{en,es}	Call to schedule appointment.	Mon–Fri 8am–5pm	f	f	t	t	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
53260c00-ef3e-4925-b849-3c91bd9e7c1a	LA County DPSS	government	County Department of Public Social Services administering CalFresh, CalWORKs, Medi-Cal, General Relief, and other benefit programs.	1-866-613-3777	\N	\N	https://dpss.lacounty.gov	\N	Los Angeles	CA	\N	{"Los Angeles"}	{"low income residents"}	{en,es,zh,vi,ko,tl}	Walk in or apply online at benefitscal.com.	Mon–Fri 8am–5pm	f	t	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
ceeed526-e56d-4e61-8096-dc669e528474	Housing Authority of the City of LA (HACLA)	government	Public housing authority administering Section 8 Housing Choice Vouchers and public housing for low-income Los Angeles residents.	213-252-2500	\N	\N	https://www.hacla.org	\N	Los Angeles	CA	\N	{"Los Angeles"}	{"low income families"}	{en,es,zh,tl}	Apply during active waitlist openings announced on the HACLA website.	Mon–Fri 8am–5pm	f	t	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
19a3ce48-26c0-45f3-9e22-94a604d3c09e	San Diego Rescue Mission	shelter	Emergency shelter, transitional housing, and wraparound support for homeless women and families in San Diego County.	619-687-3720	\N	\N	https://www.sdrescue.org	\N	San Diego	CA	\N	{"San Diego"}	{"single mothers",families}	{en,es}	Walk in or call for emergency shelter screening.	24/7 for emergency	f	t	t	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
8b18aae9-046a-441d-a1aa-ebd2b4917f96	Feeding San Diego	food	Regional food bank serving San Diego County through a network of food pantries, mobile distributions, and direct food access programs.	858-452-3663	\N	\N	https://feedingsandiego.org	\N	San Diego	CA	\N	{"San Diego"}	{"low income families"}	{en,es}	Use the find food map online at feedingsandiego.org.	Varies by location	f	f	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
5df174e9-cf5a-463e-aaab-1950eee910bf	Martha's Kitchen	food	Provides hot meals, food pantry services, and nutrition support for low-income individuals and families in Santa Clara County.	408-293-6111	\N	\N	https://www.marthas-kitchen.org	\N	San Jose	CA	\N	{"Santa Clara"}	{"low income individuals"}	{en,es,vi}	Walk in during meal and pantry service hours.	Mon–Fri 7am–1pm	f	f	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
33472138-56e0-4bbc-940b-a7c45fe33334	2-1-1 Florida	211	Statewide 24/7 information and referral service connecting Floridians to health, human services, food, housing, and emergency assistance programs.	211	\N	\N	https://www.211.org	\N	statewide	FL	\N	{statewide}	{everyone}	{en,es,ht}	Dial 2-1-1 or search online at 211.org.	24/7	f	f	f	f	f	t	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
c6cb5473-0417-43ce-8ce6-2bd1901a59de	Lotus House	shelter	Largest women's shelter in the US, providing emergency shelter, transitional housing, and comprehensive services for homeless women, single mothers, and infants.	305-438-0556	1-800-500-1119	\N	https://www.lotushouse.org	\N	Miami	FL	\N	{Miami-Dade}	{"homeless women","single mothers",infants}	{en,es,ht}	Email needshelter@lotushouse.org or call — walk-in assessment available.	24/7	t	t	t	t	f	f	t	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
2036f9eb-814b-4500-8163-ad09cf49b4fb	Legal Services of Greater Miami	legal	Free civil legal services for low-income Miami-Dade residents including eviction defense, domestic violence orders, public benefits appeals, and family law.	305-576-0080	\N	\N	https://www.legalservicesmiami.org	\N	Miami	FL	\N	{Miami-Dade}	{"low income individuals"}	{en,es,ht}	Apply online or call intake line.	Mon–Fri 9am–5pm	t	t	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
688600a3-b7bd-406d-af41-a3e6b860adfb	Miami-Dade Health Department WIC	maternal_health	WIC clinic providing nutrition benefits, breastfeeding support, and health referrals for pregnant women, new mothers, and children under 5.	786-336-1300	\N	\N	https://miamidade.floridahealth.gov	\N	Miami	FL	\N	{Miami-Dade}	{"pregnant women",infants,"children under 5"}	{en,es,ht}	Call to schedule an appointment.	Mon–Fri 8am–5pm	f	f	t	t	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
0a8b4c5d-4a2e-4acb-9998-d20686ef421c	Florida Dept of Children & Families ACCESS Center	government	State agency administering SNAP, Medicaid, TCA (TANF), and other public assistance programs through online and in-person ACCESS centers.	1-850-300-4323	\N	\N	https://www.myflfamilies.com	\N	Miami	FL	\N	{statewide}	{"low income residents"}	{en,es,ht}	Apply online at myflfamilies.com or visit a local ACCESS service center.	Mon–Fri 8am–5pm	f	t	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
f907d6e7-5af5-41b0-8c59-e124d8176c49	Miami-Dade Public Housing and Community Development	government	Public housing authority administering Section 8 Housing Choice Vouchers and affordable housing programs for low-income Miami-Dade County residents.	786-469-4100	\N	\N	https://www.miamidade.gov/housing	\N	Miami	FL	\N	{Miami-Dade}	{"low income families"}	{en,es,ht}	Apply during active waitlist openings announced on the agency website.	Mon–Fri 8am–5pm	f	t	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
5f088da1-9517-4586-8a7a-bfe7a957bbe5	Hope Villages of America	shelter	Emergency shelter and domestic violence services for homeless families and DV survivors in Pinellas County, with crisis housing and support programs.	727-584-3528	727-442-4128	\N	https://hopevillagesofamerica.org	\N	Tampa	FL	\N	{Pinellas}	{"homeless families","domestic violence survivors"}	{en,es}	Call emergency helpline for intake.	24/7	t	t	t	f	f	f	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
49cb91a2-154c-4202-8be6-48f8041984da	Feeding Tampa Bay	food	Regional food bank serving 10 counties in the Tampa Bay area through food pantries, mobile distributions, and SNAP application assistance.	813-254-1190	\N	\N	https://feedingtampabay.org	\N	Tampa	FL	\N	{Hillsborough,Pinellas,Pasco,Polk,Highlands}	{"low income families"}	{en,es}	Use the food pantry locator at feedingtampabay.org.	Varies by location	f	f	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
b5452ace-eb19-4059-a5fe-0c3df1f89dad	E.S.T.H.E.R. Single Mothers Outreach	wraparound	Wraparound support organization specifically serving single mothers with case management, benefits navigation, childcare resources, and career coaching.	407-331-6436	\N	\N	https://esthersmo.com	\N	Orlando	FL	\N	{Orange}	{"single mothers"}	{en}	Submit online partner request form at esthersmo.com.	Mon–Fri 9am–5pm	f	f	t	f	t	f	t	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
9d1dd9ea-30ae-44e9-bd13-293d805c9bca	211 New York	211	Statewide 24/7 information and referral service connecting New Yorkers to health, human services, housing, food, and emergency assistance.	211	\N	\N	https://www.211ny.org	\N	statewide	NY	\N	{statewide}	{everyone}	{en,es,zh,ru,ar,bn}	Dial 2-1-1 or visit 211ny.org.	24/7	f	f	f	f	f	t	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
dee3c1f5-f8a0-4c0e-8203-791bdd586d69	Win (Women in Need)	shelter	Largest provider of shelter for homeless single mothers in New York City, operating 11 family shelters and 3 transitional living programs.	212-695-4758	\N	\N	https://winnyc.org	\N	New York City	NY	\N	{"New York",Kings,Queens,Bronx}	{"homeless women","single mothers",children}	{en,es}	Walk in at the PATH center for shelter assessment.	24/7	f	t	t	t	t	f	t	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
576b9d27-502e-49ff-8f0f-e1f4a209e071	Food Bank For New York City	food	Largest hunger-relief organization in NYC, distributing food through 900+ community partners citywide including food pantries and soup kitchens.	212-566-7855	\N	\N	https://www.foodbanknyc.org	\N	New York City	NY	\N	{"New York",Kings,Queens,Bronx,Richmond}	{"low income families"}	{en,es,zh,ru,bn}	Search the online food map or visit a partner pantry.	Varies by location	f	f	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
1573ae21-60dd-4126-98b4-8b7852584577	Legal Aid Society NYC	legal	Provides free civil and criminal legal services to low-income New Yorkers including eviction defense, benefits appeals, family law, and domestic violence orders.	212-577-3300	\N	\N	https://www.legalaidnyc.org	\N	New York City	NY	\N	{"New York",Kings,Queens,Bronx,Richmond}	{"low income individuals"}	{en,es,zh,ru}	Call regional intake number or apply online.	Mon–Fri 9am–5pm	t	t	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
8ad61d3b-306f-4ccb-afc6-aad3f9e5d2c7	Safe Horizon	dv	Nation's largest victim services organization providing emergency shelter, counseling, legal advocacy, and crisis support for domestic violence survivors and crime victims.	212-577-7700	1-800-621-4673	\N	https://www.safehorizon.org	\N	New York City	NY	\N	{"New York",Kings,Queens,Bronx}	{"domestic violence survivors"}	{en,es,zh,ru,ar}	Call the 24/7 crisis hotline — address protected for safety.	24/7 crisis line	t	t	t	f	f	t	f	t	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
16085b60-67c8-4e27-9185-d8a260c2f3da	IFH WIC Program	maternal_health	WIC nutrition program providing food benefits, breastfeeding support, and health referrals for pregnant women, mothers, and children under 5 in NYC.	646-218-4888	1-800-522-5006	\N	https://institute.org/health-care/services/wic	\N	New York City	NY	\N	{Bronx,"New York"}	{"pregnant women",infants,"children under 5"}	{en,es}	Apply in person or call clinic to schedule.	Mon–Fri 8am–4pm	f	f	t	t	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
d6437116-df97-4338-91d0-1121c6111b6a	NYC Human Resources Administration (HRA)	government	City agency administering SNAP, cash assistance, Medicaid, and emergency housing services for New York City residents.	718-557-1399	\N	\N	https://www.nyc.gov/hra	\N	New York City	NY	\N	{"New York",Kings,Queens,Bronx,Richmond}	{"low income residents"}	{en,es,zh,ru,ar,bn,ko,ht}	Walk in at local Job Center or apply online via ACCESS HRA.	Mon–Fri 8am–5pm	f	t	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
2fb78813-8a16-4eae-afbd-ed59a0b303bb	New York City Housing Authority (NYCHA)	government	Largest public housing authority in North America, administering public housing and over 90,000 Section 8 Housing Choice Vouchers for NYC residents.	212-306-3000	\N	\N	https://www.nyc.gov/nycha	\N	New York City	NY	\N	{"New York",Kings,Queens,Bronx,Richmond}	{"low income families"}	{en,es,zh,ru}	Apply during active waitlist openings announced on NYCHA website.	Mon–Fri 8am–5pm	f	t	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
574705aa-e73d-4d9e-ac1f-d649230da71c	The Community Place of Rochester	wraparound	Comprehensive family support center providing food, housing assistance, emergency aid, job training, and childcare resources for Monroe County families.	585-327-7200	\N	\N	https://www.communityplace.org	\N	Rochester	NY	\N	{Monroe}	{"low income families",children}	{en,es}	Walk in during service hours.	Mon–Fri 8am–5pm	f	t	t	f	f	f	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
1e0f4450-421e-4cde-bd17-5ad74ff7ad04	Catholic Charities of Buffalo	wraparound	Comprehensive social services including emergency assistance, pregnancy support, housing, food, and refugee resettlement serving Western New York.	716-218-1400	\N	\N	https://ccwny.org	\N	Buffalo	NY	\N	{Erie,Niagara,Allegany}	{"low income families","new mothers"}	{en,es}	Call the district office for needs screening.	Mon–Fri 8am–5pm	f	t	t	t	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
8bd987d0-33e5-496d-baa6-ad60c25914b5	211 Illinois	211	Statewide information and referral service connecting Illinois residents to health, human services, housing, food, and emergency assistance programs.	211	\N	\N	https://www.211illinois.org	\N	statewide	IL	\N	{statewide}	{everyone}	{en,es}	Dial 2-1-1 or visit 211illinois.org.	24/7	f	f	f	f	f	f	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
008ec88d-e722-4604-931a-78243249dd18	Sarah's Circle	shelter	Drop-in center and transitional housing for homeless women in Chicago, providing meals, case management, and connections to permanent housing.	773-728-1014	1-877-863-6338	\N	https://sarahs-circle.org	\N	Chicago	IL	\N	{Cook}	{"homeless women","domestic violence survivors"}	{en,es}	Walk in during daytime drop-in hours at the Uptown location.	Mon–Fri 9am–5pm	t	t	f	f	f	f	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
845b94e9-8ad1-4912-80a9-efdb95866217	Greater Chicago Food Depository (GCFD)	food	Chicago's primary food bank distributing food through 700+ partner pantries, soup kitchens, and shelters across Cook County.	773-247-3663	\N	\N	https://www.chicagosfoodbank.org	\N	Chicago	IL	\N	{Cook}	{"low income families"}	{en,es}	Use the food locator online or call for nearest partner pantry.	Varies by location	f	f	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
95fca0d1-55df-4f24-bb9a-308b8ca19457	Legal Aid Chicago	legal	Free civil legal services for low-income Chicagoans including eviction defense, family law, domestic violence orders, and public benefits appeals.	312-341-1070	\N	\N	https://www.legalaidchicago.org	\N	Chicago	IL	\N	{Cook}	{"low income individuals","domestic violence survivors"}	{en,es}	Apply online or call the intake line.	Mon–Fri 9am–5pm	t	t	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
35b4241a-96a8-4725-8bd9-4f090334c030	Apna Ghar	dv	Domestic violence shelter and advocacy organization specializing in serving immigrant and South Asian survivors, providing emergency shelter, legal help, and counseling.	773-334-4663	773-899-1041	\N	https://www.apnaghar.org	\N	Chicago	IL	\N	{Cook}	{"immigrant domestic violence survivors"}	{en,es,hi,ur,pa}	Call the 24/7 crisis line — address protected for safety.	24/7 crisis line	t	t	t	f	f	t	f	t	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
33c14bef-1010-493e-920c-51f6889fa28f	TCA Health WIC	maternal_health	WIC nutrition clinic providing food benefits, breastfeeding education, and health referrals for pregnant women and children under 5 on Chicago's South Side.	773-846-3000	\N	\N	https://tcahealth.org/women-infants-children-wic-chicago	\N	Chicago	IL	\N	{Cook}	{"pregnant women",infants,"children under 5"}	{en,es}	Call to schedule appointment.	Mon–Fri 8am–5pm	f	f	t	t	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
e7c7f403-cb9f-41e8-b2c8-1e330f99389d	IDHS Chicago Family Community Resource Center	government	Illinois Department of Human Services local office administering SNAP, TANF, Medicaid, and CCAP applications and case management for Cook County residents.	1-800-843-6154	\N	\N	https://abe.illinois.gov	\N	Chicago	IL	\N	{Cook}	{"low income residents"}	{en,es}	Apply online at abe.illinois.gov or visit local FCRC office.	Mon–Fri 8am–5pm	f	t	f	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
5383bc8d-9b70-4625-9304-7eec041383e2	Chicago Housing Authority	government	Public housing authority administering Section 8 Housing Choice Vouchers and public housing units for low-income Chicago and Cook County residents.	312-742-8500	\N	\N	https://www.thecha.org	\N	Chicago	IL	\N	{Cook}	{"low income families"}	{en,es}	Apply during active waitlist openings announced on the CHA website.	Mon–Fri 8am–5pm	f	t	f	f	f	f	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
0062c508-5ce0-4e76-a803-64a3c69326a6	Hesed House	shelter	Emergency shelter and transitional housing for homeless individuals and families in the Fox Valley region, offering meals, case management, and housing navigation.	630-897-2156	\N	\N	https://www.hesedhouse.org	\N	Aurora	IL	\N	{Kane,DuPage}	{homeless,"low income families"}	{en,es}	Walk in for emergency shelter assessment.	24/7 for emergency	f	t	t	f	f	f	f	f	Tier 1: Beta Partner	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
e03f1d31-548f-4df8-9530-80b53b910eff	Aurora Area Interfaith Food Pantry	food	Community food pantry serving low-income families in Kane County with monthly food distributions and nutrition support.	630-897-2127	\N	\N	https://www.aurorafoodpantry.org	\N	Aurora	IL	\N	{Kane}	{"low income families"}	{en,es}	Register to shop during distribution hours.	Varies by distribution schedule	f	f	t	f	f	t	f	f	\N	2026-06-06	\N	t	2026-06-07 00:36:06.234234+00	2026-06-07 00:36:06.234234+00	{}	\N
\.


--
-- TOC entry 4723 (class 0 OID 27731)
-- Dependencies: 424
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (id, user_id, subscription_id, stripe_payment_intent_id, amount, currency, status, created_at) FROM stdin;
659fd7b5-b8dc-42f3-b35e-135d18584a90	377b4aad-d563-49a6-88f7-78560490e3d0	df9d543a-cbc9-432e-8a0c-aea6f90d4108	pi_mock_1781202217337	358800	usd	succeeded	2026-06-11 18:23:45.088+00
5adefcb8-11b6-40f2-a1f4-a824b94a3c7f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	8dca6d62-e202-4116-960a-79ee3e5b1b1a	pi_mock_1781202243213	358800	usd	succeeded	2026-06-11 18:24:10.297+00
e485f653-beb0-4756-996b-d6a4bc99f400	b7f6902d-d0fe-4c69-ac1f-51faf9245226	8dca6d62-e202-4116-960a-79ee3e5b1b1a	pi_mock_upgrade_1781202280053	898800	usd	succeeded	2026-06-11 18:24:45.296+00
1a1a7655-1791-4a03-ae17-95aa6ece6949	b7f6902d-d0fe-4c69-ac1f-51faf9245226	02016db7-b429-4af4-a794-1e79508e706c	pi_mock_1781209009119	358800	usd	succeeded	2026-06-11 20:16:54.422+00
\.


--
-- TOC entry 4717 (class 0 OID 27075)
-- Dependencies: 418
-- Data for Name: pdf_generations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pdf_generations (id, user_id, program_code, program_name, state, language, template_used, storage_path, generated_at) FROM stdin;
\.


--
-- TOC entry 4699 (class 0 OID 26863)
-- Dependencies: 400
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (id, user_id, household_size, num_children_under18, children_ages, gross_monthly_income, employment_status, housing_situation, has_disability, pregnant, first_name, last_name, date_of_birth, phone, email, language_preference, street_address, apartment_suite, city, state, zip_code, monthly_rent, monthly_utilities, landlord_name, eviction_notice, income_sources, other_household_income, children_dobs, child_disability, marital_status, other_adults, needs_childcare, has_health_insurance, immigration_status, legal_issues, urgency_level, has_savings, domestic_violence, county, postpartum_months_since_birth, breastfeeding, children_under_5_count, has_medicaid, has_snap, has_tanf_work_first, has_ssi, has_non_custodial_parent, us_citizen, qualified_immigrant, work_activity_hrs_per_month, in_qualifying_activity, previously_denied_medicaid, intake_snapshot, preferred_contact, consent_data_use, intake_completed_at, created_at, updated_at, child_support_status, childcare_preference, childcare_provider, chronic_illness, employer_name, health_insurance, monthly_childcare_cost, savings_assets, ssn_last_four, work_situation) FROM stdin;
95e19816-e78b-4e94-850e-fa4760fbe416	55b28a2d-ac96-4dff-b111-ca4338daebb0	1	1	[0]	2500	self_employed	renting	f	f	\N	\N	1998-10-13	\N	\N	English	Test1 234 ny	\N	NY	GA	78701	1000	150	\N	f	{"Job or wages"}	f	{}	f	separated	f	f	f	citizen	{none}	not_urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-05-30 12:55:35.592+00	2026-05-30 12:55:35.592+00	no_arrangement	need_help	\N	f	\N	none	\N	none	1234	self_employed
f5bd41c2-fc85-48a5-895b-d5bd2d5b25a4	d63c70ab-4901-4a3b-86db-91f1b21d942e	1	0	[]	0	full_time	renting	f	f	Nimish_mom	\N	\N	\N	\N	English	\N	\N	\N	GA	\N	0	0	\N	f	{}	f	{}	f	single	f	f	f	citizen	{}	not_urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-05-31 13:55:49.972+00	2026-05-31 13:55:49.972+00	none	\N	\N	f	\N	none	\N	none	1	full_time
40827017-96fe-4677-9400-19c252185481	af514448-9bd8-4a42-a2d5-770c24084e9f	1	0	[]	0	full_time	renting	f	f	Jane	Doe	\N	\N	\N	English	\N	\N	\N	GA	\N	0	0	\N	f	{}	f	{}	f	single	f	f	f	citizen	{}	not_urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-05-31 14:14:47.214+00	2026-05-31 14:14:47.214+00	none	\N	\N	f	\N	none	\N	none	\N	full_time
4a6c95bf-3869-451d-a05d-897b969684a9	10648b38-417c-4511-8d34-d6021f19d2c2	1	0	[]	0	full_time	renting	f	f	Maria	\N	\N	\N	\N	English	\N	\N	\N	GA	\N	1000	150	\N	f	{}	f	{}	f	single	f	f	f	citizen	{}	not_urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-05-31 11:25:20.914+00	2026-05-31 14:45:04.724+00	none	\N	\N	f	\N	none	\N	none	1234	full_time
8d99a364-f758-480c-8f9c-28190d49714f	316212a7-d942-4fbb-8d19-e6bad5d09df3	4	2	[2, 2]	1200	full_time	renting	t	f	Grace	check	1995-01-03	\N	\N	English	1020 Sandy Lane	\N	San fransisco	CA	94102	899	300	\N	t	{}	f	{"",""}	f	single	t	f	f	citizen	{}	soon	f	t	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-05-31 21:35:47.404+00	2026-05-31 21:35:47.404+00	none	\N	\N	f	\N	none	\N	none	1111	full_time
79740312-2050-4bbe-9ad5-8a838bcad62c	020a979b-5495-4452-80c9-ef8c5d4a552b	4	2	[18, 14]	1000	full_time	renting	t	f	Jenny	Yochanan	2007-05-07	\N	\N	English	1020 Sandy Lane	\N	Johns Creek	GA	30022	1000	300	\N	f	{Self-employment}	f	{2008-03-05,2012-04-08}	f	single	t	t	f	citizen	{eviction,custody}	urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-06-02 14:51:08.042+00	2026-06-02 14:51:08.042+00	none	licensed_center	\N	t	\N	none	1000	checking_low	1111	full_time
b7df8d4e-f1d5-41ed-b6cc-dc25966ad718	99377481-f483-4c4c-afdf-bf3ece076349	4	2	[7, 9]	600	part_time	renting	f	f	Jerry	L Pender	1983-01-01	\N	\N	English	1607 Branch Creek Cove	\N	lawrenceville	GA	30043	1000	200	\N	f	{"Job or wages"}	f	{2019-02-09,2017-05-08}	f	single	f	f	f	citizen	{none}	urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-06-04 13:04:55.611+00	2026-06-04 13:04:55.611+00	none	\N	Pamper Me	f	Amazon	none	\N	none	1358	part_time
e9cf151c-ced4-407d-93b4-a37b1650df8e	c4966c51-a590-485c-bf82-0d699e087ab8	1	0	[]	0	full_time	renting	f	f	\N	nimisha.mom3@gmail.com	\N	\N	\N	English	\N	\N	\N	GA	30005	0	0	\N	f	{}	f	{}	f	single	f	f	f	citizen	{}	not_urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-06-09 03:40:10.51+00	2026-06-09 03:48:34.695+00	none	\N	\N	f	\N	none	\N	none	\N	full_time
ebb3b35b-5747-458c-bbf2-973716930be9	ad89b347-7133-4c28-b420-0c6601fc139f	5	0	[]	600	full_time	owning	f	f	Kevin	Day	2001-01-25	\N	\N	English	20, Shiv darshan soc, katargam, surat, gujarat, india - 395004	\N	Surat	GA	39500	0	40	\N	f	{"Job or wages"}	f	{}	f	married	t	f	f	prefer_not	{none}	not_urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-06-09 05:38:45.504+00	2026-06-09 05:38:45.504+00	none	need_help	Sunshine	f	DDS	none	\N	savings_high	2501	full_time
020050e7-6edd-4ae4-a65f-2b5c0faa1227	9f96c2cf-298d-4553-a094-a13af906b497	1	0	[]	2000	full_time	renting	t	t	TEST	dev	\N	\N	\N	English	\N	\N	\N	GA		10	2	\N	f	{"Job or wages"}	f	{}	f	single	f	f	f	citizen	{}	not_urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-06-09 07:01:21.043+00	2026-06-09 07:14:39.903+00	none	\N	\N	f	\N	none	\N	none	9610	full_time
e019f2fb-f63c-4540-ac8f-28654c848421	dcf8d6a3-0282-402d-b40f-95ad3b24be73	1	1	[2]	0	caretaker	renting	t	f	Lusia	\N	1970-08-13	\N	\N	Spanish	Sector 45	\N	Austin	FL	45663	222	2223	\N	t	{"Child support",Unemployment}	f	{""}	f	divorced	t	t	f	citizen	{eviction,custody,domestic_violence,child_support,benefits_denial}	urgent	f	t	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-06-09 05:57:49.262+00	2026-06-09 09:23:40.614+00	none	licensed_home	ds qd 	t	DR. Vjay Singh	none	\N	none	3345	caretaker
66db6bc9-5b88-40a6-9fd9-e4acc252aa4e	b2fde45d-108b-400a-9b65-e42184ed68a2	4	2	[2, 2]	1200	full_time	renting	f	f	Nimisha	ffff	2008-04-08	\N	\N	English	1020 sssssss	\N	Rosewell	GA	30005	1000	50	\N	f	{"Job or wages"}	f	{"",""}	f	single	f	t	f	citizen	{child_support,domestic_violence}	soon	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-06-08 14:22:15.474+00	2026-06-10 03:59:16.043+00	none	licensed_home	\N	f	\N	none	200	none	1111	full_time
cb82eb66-fb1d-40ea-8f4d-ecc5aba9039c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	1	0	[]	0	full_time	renting	f	f	Jennys	\N	\N	\N	\N	English	\N	\N	\N	IL		0	0	\N	f	{}	f	{}	f	single	f	f	f	citizen	{}	not_urgent	f	f	\N	\N	f	0	f	f	f	f	f	t	f	0	f	f	\N	email	f	\N	2026-06-05 04:10:59.127+00	2026-06-12 01:04:27.806+00	none	\N	\N	f	\N	none	\N	none	\N	full_time
\.


--
-- TOC entry 4720 (class 0 OID 27545)
-- Dependencies: 421
-- Data for Name: program_quarter_due_dates; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.program_quarter_due_dates (id, program_id, year, quarter, due_dates_json, source, created_at, updated_at) FROM stdin;
e392e66f-2a20-4f71-bf4d-f18339db3e46	eitc	2026	Q4	["2027-01-31"]	GOVT	2026-06-09 19:44:05.42+00	2026-06-10 15:29:13.573+00
5ea5b851-7e9c-4156-a8e2-591078dd5844	snap	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:42:25.662+00	2026-06-10 18:16:39.169+00
afa4ec20-0fad-4fc4-b7d6-5d211d4baba4	eitc	2026	Q3	["2026-10-31"]	GOVT	2026-06-09 19:44:01.253+00	2026-06-10 15:29:09.226+00
bfb325a5-61ab-4f76-9749-dc909923aa6f	wic	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:42:30.777+00	2026-06-10 18:16:43.899+00
bb478ff9-c521-497d-a4b1-bbbb2989be3d	wic	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:42:34.093+00	2026-06-10 18:16:46.798+00
b97d0ef6-96ef-4722-af92-d3c49fdca8bc	wic	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:42:41.647+00	2026-06-10 18:16:52.428+00
5c47a3a6-4413-4791-8f65-696177850c3e	ccdf	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:43:04.316+00	2026-06-10 18:16:56.682+00
019d27bd-dd84-4a27-bdfa-a0fdae676b35	ccdf	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:43:11.712+00	2026-06-10 18:17:02.258+00
8d94239c-88b2-4bd6-8dda-03637f56c4a2	section8	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:43:24.811+00	2026-06-10 18:17:12.004+00
e9f1e446-5bd9-4392-bad7-edbcd825e191	section8	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:43:28.58+00	2026-06-10 18:17:15.06+00
948cb42e-69e1-4828-a195-7453d4cdb1ec	liheap	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:43:37.497+00	2026-06-10 18:17:22.328+00
c66047ba-51c6-4460-bcfc-aa56e3d6ebb9	liheap	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:43:41.099+00	2026-06-10 18:17:25.436+00
a5d1f104-baf1-4dac-affc-9d985eb544b9	liheap	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:43:48.884+00	2026-06-10 18:17:31.234+00
eee55775-bae8-42a4-858a-ca97cfafc41d	child_tax_credit	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:44:14.579+00	2026-06-10 18:17:50.932+00
3aab9601-b58a-4665-875a-431fd0e66dbf	child_tax_credit	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:44:18.332+00	2026-06-10 18:17:53.86+00
24fba71a-f8a0-42ac-a878-25f63661f2a0	pell_grant	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:44:27.318+00	2026-06-10 18:18:00.947+00
0b846c28-9f33-4e7e-a765-ae6c2f98be2a	pell_grant	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:44:31.192+00	2026-06-10 18:18:04.29+00
02026050-dc2c-4604-840b-2f13e82ebc25	pell_grant	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:44:38.282+00	2026-06-10 18:18:09.74+00
bff0aa71-78a0-4637-9789-8c3eb1f3ee03	head_start	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:44:43.649+00	2026-06-10 18:18:14.106+00
0c1f0d34-e227-4892-95f4-233828646cdb	head_start	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:44:51.391+00	2026-06-10 18:18:19.841+00
a8a4e4fe-c661-403f-93ec-d0417ad47364	snap	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:42:18.626+00	2026-06-10 18:16:33.469+00
c4754b00-0405-4718-b4a3-aef5d7334660	snap	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:42:22.235+00	2026-06-10 18:16:36.302+00
7fc34365-ca69-4438-979d-b63715ca67c6	lifeline	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:45:00.02+00	2026-06-10 18:18:26.801+00
b91558df-632f-461e-a546-55c5765c4c63	lifeline	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:45:03.399+00	2026-06-10 18:18:29.57+00
a174e7a2-e8e8-4b04-a238-e41705e7f4ce	lifeline	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:45:10.566+00	2026-06-10 18:18:35.296+00
fb483ec5-973a-4011-9442-10af86582f02	tanf	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:45:15.579+00	2026-06-10 18:18:46.304+00
192ee6eb-0909-47fe-84c5-324a232be82c	tanf	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:45:23.244+00	2026-06-10 18:18:52.646+00
5b400899-4d6d-4a3e-a761-c4f5180e4718	legal_aid	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:45:32.639+00	2026-06-10 18:19:00.314+00
6c1752fa-5b10-42e3-96cc-2653aa2d4f45	legal_aid	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:45:36.523+00	2026-06-10 18:19:02.952+00
8f72e466-802e-4794-a2ac-ea86af092771	legal_aid	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:45:43.693+00	2026-06-10 18:19:08.71+00
1bc482e9-7383-4799-aebd-e9f28bd2f3cb	snap_tx	2026	Q2	["2026-06-30"]	CALCULATED	2026-06-09 19:45:51.581+00	2026-06-10 18:19:15.501+00
d2e1e0a2-98d8-493d-a5df-9e90bbe8e048	snap_tx	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:45:54.343+00	2026-06-10 18:19:18.103+00
21ff6789-e290-4f4e-a0c8-4199fa21b0b4	snap_tx	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:45:57.182+00	2026-06-10 18:19:21.011+00
2567a072-abe2-40ad-bdea-c3386c067f86	wic_tx	2026	Q1	["2026-06-30"]	CALCULATED	2026-06-09 19:46:02.368+00	2026-06-10 18:19:25.561+00
e4b0b824-b0f2-4503-8f37-ce0ba4e0d1c0	wic_tx	2026	Q2	["2026-06-30"]	CALCULATED	2026-06-09 19:46:05.153+00	2026-06-10 18:19:28.393+00
382fc3ef-1abc-4dc7-b567-f0108e23eaa1	wic_tx	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:46:07.922+00	2026-06-10 18:19:31.454+00
9a5392ee-05fb-4ade-8699-7832f2efd5cc	wic_tx	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:46:10.675+00	2026-06-10 18:19:34.275+00
ca7c66c0-5a1b-4c2e-8884-5622c3bc883e	tanf_tx	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:46:15.14+00	2026-06-10 18:19:39.018+00
67575ec7-9d3a-4d43-a036-fe660d5686d9	tanf_tx	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:46:18.06+00	2026-06-10 18:19:41.937+00
02e1244e-8157-402f-af88-a1499964274b	tanf_tx	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:46:21.057+00	2026-06-10 18:19:44.777+00
e32d016b-5a75-4600-8a41-f22f5052921a	tanf_tx	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:46:23.965+00	2026-06-10 18:19:47.738+00
eaba47ca-2ced-418c-b126-c64c06aeca11	medicaid_tx	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:46:28.575+00	2026-06-10 18:19:51.988+00
9e06a6ff-891c-4570-93c5-e34d49de489d	medicaid_tx	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:46:31.769+00	2026-06-10 18:19:55.114+00
2b97e00b-dc3f-4d22-8a8f-c8e8b688a9fd	medicaid_tx	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:46:34.648+00	2026-06-10 18:19:57.88+00
600264a1-64de-43cb-b2ff-f4286487c8ee	medicaid_tx	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:46:37.723+00	2026-06-10 18:20:00.462+00
4ce465f2-651e-48fb-8dc7-54152203f2de	childcare_tx	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:46:42.164+00	2026-06-10 18:20:04.351+00
d1e17f34-68ed-4c0b-8794-4dbffbf24f52	childcare_tx	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:46:45.175+00	2026-06-10 18:20:07.046+00
45af3bca-e2c9-4499-931a-6e37d80e51cb	childcare_tx	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:46:48.734+00	2026-06-10 18:20:10.011+00
308f331a-561a-4311-8273-f3f1a2f0db48	childcare_tx	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:46:51.543+00	2026-06-10 18:20:13.452+00
a32025e6-9154-465c-b258-dbb56d9f68fe	section8_tx	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:46:55.781+00	2026-06-10 18:20:17.457+00
deb1455a-152e-4e03-b23e-de1a308168e5	section8_tx	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:47:01.851+00	2026-06-10 18:20:22.966+00
10cee56b-0e51-449c-8314-eaaf3f5b6d51	section8_tx	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:47:05.697+00	2026-06-10 18:20:26.094+00
d33c885e-19f7-4daf-a5d7-39141b4f0d51	liheap_tx	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:47:10.463+00	2026-06-10 18:20:31.021+00
325fe83e-0245-4d04-ae18-1ee8adca5ac1	liheap_tx	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:47:15.489+00	2026-06-10 18:20:33.658+00
d4b37a46-0296-4de3-aedb-5a33fa5edefb	liheap_tx	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:47:18.5+00	2026-06-10 18:20:36.649+00
29b6a311-ca33-416e-a35b-b2b42211e29f	liheap_tx	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:47:21.253+00	2026-06-10 18:20:39.761+00
b5abe35d-cd37-4f79-904d-3b0464fe2d1b	childsupport_tx	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:47:25.521+00	2026-06-10 18:20:44.539+00
13bf9e84-83b8-4cc2-a510-02df0854a2c1	childsupport_tx	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:47:32.866+00	2026-06-10 18:20:50.611+00
770f745a-5627-44d2-b110-73a7d93a44a2	snap_ca	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:47:41.723+00	2026-06-10 18:20:58.141+00
6e8a47ba-cd80-4aba-9008-1efbf13f0fe9	snap_ca	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:47:44.71+00	2026-06-10 18:21:01.484+00
2e7d183e-b499-47dd-87dc-9d23ff7b39ba	snap_ca	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:47:47.968+00	2026-06-10 18:21:04.455+00
f79df143-abdd-4c09-849d-89c166c87aa4	snap_ca	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:47:50.941+00	2026-06-10 18:21:07.433+00
57135b1c-fd55-4b2a-8495-2a565401579d	wic_ca	2026	Q1	["2026-06-30"]	CALCULATED	2026-06-09 19:47:55.05+00	2026-06-10 18:21:12.082+00
2fa8aecf-b394-4f42-b827-856550a6c8db	snap	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:42:14.453+00	2026-06-10 18:16:30.493+00
4a62b730-a6f3-428f-8c81-a03041176fb4	tanf_ca	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:48:14.364+00	2026-06-10 18:21:39.963+00
7cf8a3e0-dc86-47c1-b68f-bc61d3c14f06	tanf_ca	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:48:17.308+00	2026-06-10 18:21:43.126+00
c1cfe535-6a45-45b3-85ff-2bf003eaa40a	medicaid_ca	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:48:24.724+00	2026-06-10 18:21:50.912+00
6d7d3aeb-8df6-4eb0-aaf7-e10a7f98aede	medicaid_ca	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:48:27.396+00	2026-06-10 18:21:53.881+00
71f76166-f538-4bc6-9749-5d1bbeb7db00	medicaid_ca	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:48:30.336+00	2026-06-10 18:21:56.912+00
db32c98b-d176-4fbd-bc39-96298a827926	childcare_ca	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:48:35.025+00	2026-06-10 18:22:01.353+00
aae65aa9-1568-46bf-ab77-6787cc48cc25	childcare_ca	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:48:37.954+00	2026-06-10 18:22:04.728+00
794e8a32-8c66-47ce-a909-c5462d9b6903	childcare_ca	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:48:40.624+00	2026-06-10 18:22:07.65+00
63e098a4-50a8-417f-93f3-6eb59ee1034a	childcare_ca	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:48:43.317+00	2026-06-10 18:22:10.641+00
6ad0739a-238e-43c0-abe1-16165c995b85	section8_ca	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:48:47.501+00	2026-06-10 18:22:14.705+00
d402be6d-d424-4e04-b5e9-9f3ec116000b	section8_ca	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:48:50.961+00	2026-06-10 18:22:17.43+00
7b9be97a-aa20-4e52-bc3a-8b07017a4a44	section8_ca	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:48:53.734+00	2026-06-10 18:22:20.625+00
d4b13571-296c-4a2b-8fa7-32b70e2900e8	wic_ca	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:48:03.944+00	2026-06-10 18:21:23.369+00
6d2a240d-0ade-4333-8503-b476100863d3	tanf_ca	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:48:08.082+00	2026-06-10 18:21:33.483+00
82743ba6-8d5c-4a68-991c-39c2fe4e0e26	section8_ca	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:48:56.446+00	2026-06-10 18:22:23.537+00
bb25023f-1545-49f3-9d50-cd84af40e75e	liheap_ca	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:49:00.952+00	2026-06-10 18:22:27.975+00
d0a605af-b3fb-4bea-bcad-560eaaa26764	liheap_ca	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:49:03.885+00	2026-06-10 18:22:30.86+00
b4b11b5e-9550-44f1-8a4b-8cab965fba61	liheap_ca	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:49:07.147+00	2026-06-10 18:22:33.559+00
b19ff68b-3561-43db-bc0b-8e5e8e0d30f4	liheap_ca	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:49:10.182+00	2026-06-10 18:22:36.733+00
ba8a22f8-d300-408c-99cd-830bec6dc197	childsupport_ca	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:49:15.215+00	2026-06-10 18:22:41.258+00
83d8f44b-8701-4691-87ba-d2db51c2e786	childsupport_ca	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:49:18.415+00	2026-06-10 18:22:44.249+00
c240c61c-f2c8-453e-a319-94753cea2311	childsupport_ca	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:49:25.92+00	2026-06-10 18:22:50.62+00
d4b63b52-0bb3-4034-9d1e-1c82333d1ad1	snap_fl	2026	Q1	["2026-06-30"]	CALCULATED	2026-06-09 19:49:30.631+00	2026-06-10 18:22:55.349+00
a17cf3da-328b-4c69-9990-5860dc4d00b8	snap_fl	2026	Q2	["2026-06-30"]	CALCULATED	2026-06-09 19:49:33.513+00	2026-06-10 18:22:57.982+00
2b8c6831-ab8f-42d3-bbfd-74032693b262	snap_fl	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:49:39.789+00	2026-06-10 18:23:03.763+00
e5157709-6aa1-4f2b-a681-8771948c0c66	wic_fl	2026	Q1	["2026-06-30"]	CALCULATED	2026-06-09 19:49:44.2+00	2026-06-10 18:23:08.035+00
9a13b5be-6070-44d8-aed7-04f46df676be	wic_fl	2026	Q2	["2026-06-30"]	CALCULATED	2026-06-09 19:49:47.387+00	2026-06-10 18:23:11.118+00
4e7d573b-f695-4c31-b9a7-e20186a8c2ea	wic_fl	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:49:50.496+00	2026-06-10 18:23:14.262+00
6b31db11-0fb5-48bd-a322-c44222c916e4	wic_fl	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:49:53.468+00	2026-06-10 18:23:17.089+00
eb0f01ef-7645-4cbe-b72b-1181f8d01a65	tanf_fl	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:49:57.829+00	2026-06-10 18:23:21.314+00
143d26e3-a4a9-41bd-85a7-49091a762fb4	tanf_fl	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:50:00.788+00	2026-06-10 18:23:24.3+00
63e43633-f0e2-4f64-87f3-ec9e951cadac	tanf_fl	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:50:03.462+00	2026-06-10 18:23:26.875+00
077c0a51-e0aa-4920-a05b-d9efdd0c1ee6	tanf_fl	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:50:06.177+00	2026-06-10 18:23:29.673+00
69ea697c-b9b5-4ece-b20a-de878897de86	medicaid_fl	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:50:10.847+00	2026-06-10 18:23:34.032+00
9865c2e1-394d-40c4-b290-e44a09df4c31	medicaid_fl	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:50:13.732+00	2026-06-10 18:23:37.011+00
a41bd34f-8d68-4357-82ec-6ae747fe8ae6	medicaid_fl	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:50:16.529+00	2026-06-10 18:23:39.963+00
b54c9078-d9f8-4940-8686-200975f00eaa	medicaid_fl	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:50:19.637+00	2026-06-10 18:23:42.64+00
6d56f9fb-52f4-4dde-86eb-51b5d94b433a	childcare_fl	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:50:24.477+00	2026-06-10 18:23:46.719+00
15b5aa2e-d06c-4ac3-86e0-6792401f086c	childcare_fl	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:50:27.502+00	2026-06-10 18:23:49.435+00
f5456086-31e9-48ab-ad40-50e8fe03da9b	childcare_fl	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:50:30.335+00	2026-06-10 18:23:52.007+00
838909a2-4e72-4eaa-9292-a73b01e7123b	childcare_fl	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:50:33.958+00	2026-06-10 18:23:54.657+00
fb03a402-8ff8-4ea8-a168-8ae2fce1c3ac	section8_fl	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:50:38.031+00	2026-06-10 18:23:58.869+00
0fb22410-8256-491d-9d39-b68d5e41b07b	section8_fl	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:50:40.992+00	2026-06-10 18:24:01.795+00
e9a4fa8c-4f22-4125-aea6-75d10839d29b	section8_fl	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:50:44.454+00	2026-06-10 18:24:04.504+00
aeb11b5a-6528-49cd-bae0-cc8d1e5805e0	section8_fl	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:50:47.655+00	2026-06-10 18:24:07.625+00
c9c18f1e-ac23-4d23-9a9c-06039b6e9521	liheap_fl	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:50:51.796+00	2026-06-10 18:24:11.868+00
cca04a15-e64c-46a2-a6b3-2eb438801711	wic_ca	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:48:00.998+00	2026-06-10 18:21:19.711+00
4c3eab3d-2d5c-49f1-8c4a-181a70923384	liheap_fl	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:50:58.289+00	2026-06-10 18:24:17.341+00
b1d17c6e-061a-44a4-b8b9-51abcfc13708	liheap_fl	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:51:01.583+00	2026-06-10 18:24:20.107+00
8b3c1456-dba6-458d-bb0c-c90968bee967	childsupport_fl	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:51:06.175+00	2026-06-10 18:24:24.378+00
feda8f4c-f459-4f51-b69e-643e60d1bde9	childsupport_fl	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:51:14.521+00	2026-06-10 18:24:30.993+00
0acf6787-d547-4a65-b636-3d1d648dec48	childsupport_fl	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:51:19.141+00	2026-06-10 18:24:33.883+00
1a256c53-c6bd-44bf-982a-dea36d6782f7	snap_ny	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:51:30.075+00	2026-06-10 18:24:41.201+00
fe758275-66ef-4ab8-8531-ac21b0a0761e	snap_ny	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:51:32.999+00	2026-06-10 18:24:44.131+00
42383789-184a-4325-b8da-324b678a4829	snap_ny	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:51:36.887+00	2026-06-10 18:24:47.165+00
46c7de3b-6d1d-4b56-8ae4-5e5e4aa00f65	wic_ny	2026	Q1	["2026-06-30"]	CALCULATED	2026-06-09 19:51:41.16+00	2026-06-10 18:24:51.336+00
ebf22570-dc34-4172-a379-29dac48e0bca	wic_ny	2026	Q2	["2026-06-30"]	CALCULATED	2026-06-09 19:51:44.11+00	2026-06-10 18:24:54.273+00
126de1fa-659e-4a41-bb9d-2e2020263367	wic_ny	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:51:47.56+00	2026-06-10 18:24:57.223+00
e23eb37b-7f86-4556-86fe-a138d02d929f	wic_ny	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:51:51.173+00	2026-06-10 18:25:00.46+00
64d2b29f-a505-44dd-8a77-f0245e82de1e	tanf_ny	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:51:55.73+00	2026-06-10 18:25:04.573+00
50b23307-2f96-40f0-a670-f388e01919a3	tanf_ny	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:51:59.285+00	2026-06-10 18:25:07.838+00
948dba5f-a98f-4ca3-a17a-f1b9846aa254	tanf_ny	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:52:02.491+00	2026-06-10 18:25:10.691+00
cf8b8075-b7af-4e6d-92b9-e47ef35e43d8	tanf_ny	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:52:05.321+00	2026-06-10 18:25:13.394+00
c9bcdd89-9dab-4594-adf3-9e2fe2a4f4cd	medicaid_ny	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:52:09.724+00	2026-06-10 18:25:17.962+00
f01341b3-ee3a-4e7c-aebf-3cbc55a7f486	medicaid_ny	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:52:12.75+00	2026-06-10 18:25:20.729+00
9e74ec66-3e5e-4fca-ac6c-b443973bdf87	medicaid_ny	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:52:18.718+00	2026-06-10 18:25:23.903+00
48296a8e-c8a2-4233-b83f-396e452cb179	medicaid_ny	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:52:21.698+00	2026-06-10 18:25:26.673+00
2111d790-3e34-45c4-a7f8-f12eb424fafe	childcare_ny	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:52:25.885+00	2026-06-10 18:25:30.802+00
c6a0c142-a9c9-479a-8866-eae719152e51	childcare_ny	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:52:29.123+00	2026-06-10 18:25:33.988+00
42f276fd-e733-4168-b5c4-1eda809a3f79	childcare_ny	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:52:32.786+00	2026-06-10 18:25:36.811+00
4e59b5fc-b15a-4d13-b7f7-4ca8d21692fb	childcare_ny	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:52:36.33+00	2026-06-10 18:25:39.671+00
d9750ff4-1ce9-4ac1-bd08-80f0bef4ff7a	eitc	2026	Q1	["2026-04-30"]	GOVT	2026-06-09 19:43:54.207+00	2026-06-10 15:29:00.712+00
09df2f55-e570-4ef2-9252-eb5a241fd0f1	eitc	2026	Q2	["2026-07-31"]	GOVT	2026-06-09 19:43:57.545+00	2026-06-10 15:29:05.076+00
21ba6764-2d62-4646-b646-baad5945b15c	tanf_ca	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:48:10.929+00	2026-06-10 18:21:36.848+00
90e6d803-f872-4f95-81c7-7fec4df3be52	medicaid_ca	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:48:21.772+00	2026-06-10 18:21:48.009+00
627a9293-6664-418f-abaa-3f47905eba77	snap_fl	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:49:36.656+00	2026-06-10 18:23:01.054+00
78157cdf-8bbd-4d2f-bc1d-f9a870bf436d	liheap_fl	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:50:54.537+00	2026-06-10 18:24:14.502+00
d599380a-bedb-4c3e-a8ad-d25de9b88706	section8_ny	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:52:44.863+00	2026-06-10 18:25:47.047+00
a5c593a7-0a8a-4420-9eb4-0270818a0b8f	section8_ny	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:52:48.315+00	2026-06-10 18:25:50.116+00
9279d317-dbd7-43df-b0f0-80e251e1aa19	section8_ny	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:52:51.695+00	2026-06-10 18:25:52.979+00
32d1570b-01c8-4b09-b98e-54d1a76045eb	liheap_ny	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:52:55.985+00	2026-06-10 18:25:57.49+00
3225674c-7493-4f03-a680-287f3f89b464	liheap_ny	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:52:58.853+00	2026-06-10 18:26:00.14+00
b090a93d-e052-498b-96bb-2410e81515eb	liheap_ny	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:53:01.881+00	2026-06-10 18:26:03.026+00
5badc5e9-94b4-4076-8b43-4568e3e46013	liheap_ny	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:53:04.863+00	2026-06-10 18:26:06.294+00
f6fdb7ea-6c67-47c0-add4-8ef48bb2eb52	childsupport_ny	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:53:09.729+00	2026-06-10 18:26:10.401+00
f4e2677e-09d5-4709-9ff7-4fd396dfdc80	childsupport_ny	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:53:19.425+00	2026-06-10 18:26:16.127+00
c5496e95-7be6-4bc9-83ad-272db8a772cc	childsupport_ny	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:53:24.025+00	2026-06-10 18:26:18.946+00
fb32f986-4f06-4e3a-8872-838225fc3a74	snap_il	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:53:29.226+00	2026-06-10 18:26:23.602+00
a1db2a1d-1633-43c6-bd11-97be52895b7f	snap_il	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:53:32.147+00	2026-06-10 18:26:26.365+00
d5a0db71-1a41-47b4-b335-5cd9cc2ca15e	snap_il	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:53:35.049+00	2026-06-10 18:26:29.491+00
14fd6e32-fd57-43a5-88ba-49f895fda522	snap_il	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:53:38.451+00	2026-06-10 18:26:34.917+00
99aac90c-3d71-4142-a011-485e50b247f3	wic_il	2026	Q1	["2026-06-30"]	CALCULATED	2026-06-09 19:53:43.2+00	2026-06-10 18:26:39.384+00
8e53d45d-b5da-4ac5-91a1-f7fd12dd312c	wic_il	2026	Q2	["2026-06-30"]	CALCULATED	2026-06-09 19:53:46.189+00	2026-06-10 18:26:42.158+00
91a07e77-b4e4-4043-b25c-d4fe9eac70bc	wic_il	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:53:49.179+00	2026-06-10 18:26:45.106+00
ffc988f2-1556-4859-a6b8-4ae3eb493866	wic_il	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:53:52.485+00	2026-06-10 18:26:48.23+00
d4da46b3-7b1e-458c-bce6-fff8b5caa059	tanf_il	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:53:56.662+00	2026-06-10 18:26:52.747+00
07150903-e99c-4743-94de-9a911c26fc27	tanf_il	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:53:59.674+00	2026-06-10 18:26:55.414+00
3de11eba-08db-4532-899e-5bd056399ee6	tanf_il	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:54:02.867+00	2026-06-10 18:26:58.201+00
61ea6bf5-1748-4efb-943b-63d1f371f7ed	tanf_il	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:54:05.871+00	2026-06-10 18:27:00.773+00
326feb90-4b68-4270-b341-eb87ad201a32	medicaid_il	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:54:10.495+00	2026-06-10 18:27:04.864+00
57db1f4e-54e1-4f13-ae76-53aa8b5a2735	medicaid_il	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:54:13.601+00	2026-06-10 18:27:08.116+00
48498971-b3b8-4968-abbe-9b53402d1d69	medicaid_il	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:54:17.08+00	2026-06-10 18:27:10.687+00
5e5c1f92-7c84-48ca-83e6-ea6301351fe3	medicaid_il	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:54:20.265+00	2026-06-10 18:27:13.254+00
e41c050d-1fd7-4cb9-8bb6-317ab65bc34e	childcare_il	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:54:25.316+00	2026-06-10 18:27:17.151+00
62df96b8-debc-46e1-90d3-1935bc855099	childcare_il	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:54:28.161+00	2026-06-10 18:27:19.861+00
16c8661d-a06c-4e7d-b11e-f54b9f200f8c	childcare_il	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:54:30.958+00	2026-06-10 18:27:23.203+00
2e215baf-76df-49a2-b1c7-4c59f0c4130e	childcare_il	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:54:33.709+00	2026-06-10 18:27:26.366+00
86b17abd-d143-4bf3-9ab3-75a89abc1cf9	section8_il	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:54:38.077+00	2026-06-10 18:27:30.424+00
6681db50-59c9-467a-b614-20b64df8435f	section8_il	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:54:41.278+00	2026-06-10 18:27:33.082+00
db487882-42b0-44b5-8ce1-5a6f11d389e4	section8_il	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:54:44.657+00	2026-06-10 18:27:35.811+00
9fb9efc0-9091-4211-bb1e-ffd0b455d589	section8_il	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:54:47.577+00	2026-06-10 18:27:38.522+00
0c77b195-e9b7-430f-b06c-7a35beaf0912	liheap_il	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:54:52.203+00	2026-06-10 18:27:42.798+00
af4a6223-7dc4-491c-b750-cc0cac63d5d5	liheap_il	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:54:54.944+00	2026-06-10 18:27:45.527+00
96126f7b-5ca9-4f32-b883-e6609356ce39	ccdf	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:43:15.788+00	2026-06-10 18:17:05.107+00
c6084189-a157-4494-aaeb-079e5d4af23a	liheap_il	2026	Q3	["2026-12-31"]	CALCULATED	2026-06-09 19:54:58.103+00	2026-06-10 18:27:48.103+00
e52694ad-991a-4c18-8e8a-d50c17378e21	liheap_il	2026	Q4	["2026-12-31"]	CALCULATED	2026-06-09 19:55:00.806+00	2026-06-10 18:27:51.357+00
da4a3f16-fe73-456d-90f5-02625e39fef6	childsupport_il	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:55:08.433+00	2026-06-10 18:27:58.37+00
927d195e-5862-4201-ac99-6eb464d05087	childsupport_il	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:55:12.277+00	2026-06-10 18:28:01.205+00
a8ad0c87-6c2f-4e75-b8b6-0f4488491778	section8	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:43:21.154+00	2026-06-10 18:17:09.33+00
ba4e92bd-27fa-4ca8-aa82-9a5205b3744f	medicaid	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-10 16:29:50.631+00	2026-06-10 18:17:41.011+00
397f6c94-cf6f-4723-a924-561b4acabd17	section8_tx	2026	Q2	["2026-12-31"]	CALCULATED	2026-06-09 19:46:58.53+00	2026-06-10 18:20:20.056+00
2db1b6bd-4817-40ec-aca4-2be7e6df4ed8	wic_ca	2026	Q2	["2026-06-30"]	CALCULATED	2026-06-09 19:47:57.836+00	2026-06-10 18:21:16.146+00
37852e2e-4fa6-46f1-950b-ebef579a3648	wic	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:42:37.789+00	2026-06-10 18:16:49.674+00
bfc6d5f7-5afc-456a-ad8b-f08fcfbf60de	ccdf	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:43:07.728+00	2026-06-10 18:16:59.526+00
81b21d83-a854-47fe-85b9-3feae42ac660	section8	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:43:32.375+00	2026-06-10 18:17:17.926+00
078b5568-4ae7-4fbf-a116-a2bb11a46cda	liheap	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:43:44.907+00	2026-06-10 18:17:28.373+00
230aa387-4f90-4126-a1e6-2f04573304c3	medicaid	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-10 16:29:44.93+00	2026-06-10 18:17:35.654+00
e98d900a-395a-442c-abd7-587b36eae4b5	medicaid	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-10 16:29:47.863+00	2026-06-10 18:17:38.337+00
98cf3cd3-9405-4b24-91e2-b37c50580b3d	medicaid	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-10 16:29:54.785+00	2026-06-10 18:17:43.718+00
097c3d5d-16fa-4482-8910-1cb37c272bff	child_tax_credit	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:44:10.644+00	2026-06-10 18:17:48.236+00
2114e124-b7d9-4dad-86f7-ec296d938117	child_tax_credit	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:44:22.618+00	2026-06-10 18:17:56.575+00
2959e804-11e5-4736-bd81-dd3271891156	pell_grant	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:44:34.607+00	2026-06-10 18:18:07.012+00
7b05e9a0-12c0-478f-b6ea-ec548bb82cf1	head_start	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:44:47.55+00	2026-06-10 18:18:16.704+00
dafa24c3-07c5-4d72-b4af-f1e8f774e6c1	head_start	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:44:55.046+00	2026-06-10 18:18:22.599+00
08191542-23c0-42cf-83ce-71db8f782897	lifeline	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:45:06.805+00	2026-06-10 18:18:32.284+00
2da39295-8106-484c-aca0-1dc4a54921c3	tanf	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:45:19.665+00	2026-06-10 18:18:49.862+00
e4b205d8-3f77-4b53-9b89-0db9b234875f	tanf	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:45:27.164+00	2026-06-10 18:18:55.674+00
51e77f33-ca25-415b-8374-4ecefdadf638	section8_ny	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:52:41.87+00	2026-06-10 18:25:44.28+00
4c5a38c3-5ec4-40b7-83fa-30cc0e52eedd	legal_aid	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:45:39.869+00	2026-06-10 18:19:06.016+00
9be39137-2f6c-4541-bf98-ca7a3cd0f5bc	snap_tx	2026	Q1	["2026-06-30"]	CALCULATED	2026-06-09 19:45:48.678+00	2026-06-10 18:19:12.903+00
964b5e37-8220-4451-b200-7b80f0c72f51	childsupport_tx	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:47:28.861+00	2026-06-10 18:20:47.745+00
2b76aac1-0334-442e-801f-8c8543b6c294	childsupport_tx	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:47:36.647+00	2026-06-10 18:20:53.444+00
dcf9b21b-c85e-4d1f-b0af-49772c8b13b0	childsupport_ca	2026	Q3	["2026-07-31", "2026-08-31", "2026-09-30"]	CALCULATED	2026-06-09 19:49:21.737+00	2026-06-10 18:22:47.638+00
12eb1664-a221-4c22-a200-53be8f8911f1	childsupport_fl	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:51:09.899+00	2026-06-10 18:24:27.732+00
85013359-fa89-44d3-bf7d-093a04ce2f9b	snap_ny	2026	Q1	["2026-12-31"]	CALCULATED	2026-06-09 19:51:25.474+00	2026-06-10 18:24:38.132+00
eaad0daa-a88b-490b-98db-b254767f3426	childsupport_ny	2026	Q2	["2026-04-30", "2026-05-31", "2026-06-30"]	CALCULATED	2026-06-09 19:53:13.948+00	2026-06-10 18:26:13.268+00
810c641b-f007-43e4-b727-c8b841d802af	childsupport_il	2026	Q1	["2026-01-31", "2026-02-28", "2026-03-31"]	CALCULATED	2026-06-09 19:55:05.148+00	2026-06-10 18:27:55.722+00
f1aa2608-6397-487f-90a5-8c3de7bc3064	childsupport_il	2026	Q4	["2026-10-31", "2026-11-30", "2026-12-31"]	CALCULATED	2026-06-09 19:55:15.86+00	2026-06-10 18:28:03.787+00
\.


--
-- TOC entry 4700 (class 0 OID 26900)
-- Dependencies: 401
-- Data for Name: programs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.programs (id, program_name, administering_agency, program_type, federal_or_state, state, description, eligibility_criteria, estimated_monthly_value_min, estimated_monthly_value_max, apply_url, contact_email, is_active, tags, metadata, also_known_as, agency_phone, agency_website, eligibility_summary, income_limit_pct_fpl, income_limit_pct_smi, asset_limit, lifetime_limit_months, work_requirement_hrs, renewal_period, counties_served, languages_available, waitlist_status, waitlist_notes, last_verified_date, source_url, guide_url, renewal_period_months, program_code, notes, created_at, updated_at, program_due_date) FROM stdin;
snap	SNAP — Food Stamps	USDA	Federal Program	Federal Program	\N	Monthly EBT benefits to buy groceries for you and your family.	{"category": "Food", "priority_score": 90, "requires_children": false, "income_threshold_type": "low"}	180	1200	https://www.fns.usda.gov/snap/state-directory	AskUSDA@usda.gov	t	{food,essential,ebt}	{"category": "Food", "priority_score": 90, "requires_children": false, "income_threshold_type": "low"}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:17.096+00	2026-05-30 11:54:49.57+00	\N
wic	WIC — Women, Infants & Children	USDA	Federal Program	Federal Program	\N	Nutritious food, formula, breastfeeding support, and health referrals for pregnant women and kids under 5.	{"category": "Nutrition", "priority_score": 98, "income_threshold_type": "moderate", "requires_pregnancy_or_child_under_5": true}	50	300	https://www.fns.usda.gov/wic/wic-state-agencies	AskUSDA@usda.gov	t	{food,nutrition,pregnancy,children}	{"category": "Nutrition", "priority_score": 98, "income_threshold_type": "moderate", "requires_pregnancy_or_child_under_5": true}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:18.259+00	2026-05-30 11:54:51.156+00	\N
ccdf	Child Care Subsidy (CCDF)	Office of Child Care	Federal Program	Federal Program	\N	Help paying for daycare or after-school care so you can work or attend school.	{"category": "Childcare", "priority_score": 88, "requires_children": true, "income_threshold_type": "moderate", "requires_employment_or_student": true}	200	1500	https://www.childcare.gov/state-resources	OCCPolicyInfo@acf.hhs.gov	t	{childcare,employment,education}	{"category": "Childcare", "priority_score": 88, "requires_children": true, "income_threshold_type": "moderate", "requires_employment_or_student": true}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:20.569+00	2026-05-30 11:54:54.133+00	\N
section8	Section 8 Housing Choice Voucher	HUD	Federal Program	Federal Program	\N	Rental assistance — pay ~30% of your income, voucher covers the rest.	{"category": "Housing", "priority_score": 85, "requires_children": false, "supports_disability": true, "income_threshold_type": "very_low"}	500	2500	https://www.hud.gov/program_offices/public_indian_housing/pha/contacts	answers@hud.gov	t	{housing,rent,low-income}	{"category": "Housing", "priority_score": 85, "requires_children": false, "supports_disability": true, "income_threshold_type": "very_low"}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:21.721+00	2026-05-30 11:54:55.687+00	\N
liheap	LIHEAP — Energy Assistance	HHS	Federal Program	Federal Program	\N	Help paying heating, cooling, and energy bills.	{"category": "Utilities", "priority_score": 80, "income_threshold_type": "low", "supports_seniors_and_disability": true}	20	100	https://www.acf.hhs.gov/ocs/low-income-home-energy-assistance-program-liheap	LIHEAP@acf.hhs.gov	t	{utilities,energy,heating,cooling}	{"category": "Utilities", "priority_score": 80, "income_threshold_type": "low", "supports_seniors_and_disability": true}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:22.874+00	2026-05-30 11:54:57.25+00	\N
medicaid	Medicaid & CHIP	CMS	Federal Program	Federal Program	\N	Free or low-cost health coverage for you and your kids.	{"category": "Health", "priority_score": 92, "requires_children": false, "supports_disability": true, "income_threshold_type": "low"}	300	2000	https://www.healthcare.gov/medicaid-chip/	Medicaid.gov@cms.hhs.gov	t	{healthcare,health,children,pregnancy}	{"category": "Health", "priority_score": 92, "requires_children": false, "supports_disability": true, "income_threshold_type": "low"}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	1	\N	\N	2026-05-30 11:34:19.413+00	2026-06-10 16:19:38.355+00	\N
child_tax_credit	Child Tax Credit	IRS	Federal Program	Federal Program	\N	Up to $2,000 per qualifying child under 17 on your federal return.	{"category": "Tax", "max_child_age": 17, "priority_score": 90, "requires_children": true, "income_threshold_type": "high"}	160	160	https://www.irs.gov/credits-deductions/child-tax-credit	TAS.Form.911.Request.for.Assistance@irs.gov	t	{tax,children,cash}	{"category": "Tax", "max_child_age": 17, "priority_score": 90, "requires_children": true, "income_threshold_type": "high"}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:25.181+00	2026-05-30 11:55:00.834+00	\N
pell_grant	Federal Pell Grant	Dept. of Education	Federal Program	Federal Program	\N	Free college money for low-income students — doesn't need to be repaid.	{"category": "Education", "priority_score": 75, "income_threshold_type": "moderate", "requires_student_status": true}	100	615	https://studentaid.gov/h/apply-for-aid/fafsa	customerservice@studentaid.gov	t	{education,college,students}	{"category": "Education", "priority_score": 75, "income_threshold_type": "moderate", "requires_student_status": true}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:26.336+00	2026-05-30 11:55:02.782+00	\N
head_start	Head Start & Early Head Start	HHS	Federal Program	Federal Program	\N	Free early learning, health, and family services for kids 0–5.	{"category": "Education", "max_child_age": 5, "priority_score": 91, "requires_children": true, "income_threshold_type": "low"}	500	1200	https://eclkc.ohs.acf.hhs.gov/center-locator	HeadStart@eclkc.info	t	{education,children,preschool}	{"category": "Education", "max_child_age": 5, "priority_score": 91, "requires_children": true, "income_threshold_type": "low"}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:27.501+00	2026-05-30 11:55:05.034+00	\N
lifeline	Lifeline Phone & Internet	FCC	Federal Program	Federal Program	\N	Discount on monthly phone or internet for qualifying households.	{"category": "Utilities", "priority_score": 72, "income_threshold_type": "low"}	9	9	https://www.lifelinesupport.org/get-started/	LifelineSupport@usac.org	t	{utilities,phone,internet}	{"category": "Utilities", "priority_score": 72, "income_threshold_type": "low"}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:29.996+00	2026-05-30 11:55:06.743+00	\N
eitc	Earned Income Tax Credit (EITC)	IRS	Federal Program	Federal Program	\N	Refundable tax credit for working parents — money back even if you owe nothing.	{"category": "Tax", "priority_score": 82, "requires_employment": true, "income_threshold_type": "moderate"}	50	650	https://www.irs.gov/credits-deductions/individuals/earned-income-tax-credit-eitc	TAS.Form.911.Request.for.Assistance@irs.gov	t	{tax,cash,employment}	{"category": "Tax", "priority_score": 82, "requires_employment": true, "income_threshold_type": "moderate"}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	3	\N	\N	2026-05-30 11:34:24.023+00	2026-06-10 15:20:28.329+00	\N
tanf	TANF — Temporary Assistance for Needy Families	U.S. Dept. of Health & Human Services	Cash Assistance	Federal And State Program	\N	Monthly cash assistance for low-income families with children, plus job training and childcare support.	{"category": "Cash", "priority_score": 95, "requires_children": true, "income_threshold_type": "low", "requires_unemployment": false}	400	900	https://www.acf.hhs.gov/ofa/map/about/help-families	infocollection@acf.hhs.gov	t	{cash,children,emergency}	{"category": "Cash", "priority_score": 95, "requires_children": true, "income_threshold_type": "low", "requires_unemployment": false}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:15.936+00	2026-05-30 11:54:47.716+00	\N
legal_aid	Civil Legal Aid Services	Legal Services Corporation (LSC)	Federal and State Program	Federal Program	\N	Free civil legal assistance for low-income individuals facing housing, family, domestic violence, or benefits issues.	{"category": "Legal", "priority_score": 80, "supports_legal_aid": true, "income_threshold_type": "low"}	150	800	https://www.lsc.gov/grants/our-grantees	info@lsc.gov	t	{legal,civil-rights,emergency,family-safety}	{"category": "Legal", "priority_score": 80, "supports_legal_aid": true, "income_threshold_type": "low"}	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	{}	open	\N	\N	\N	\N	\N	\N	\N	2026-05-30 11:34:31.387+00	2026-05-30 11:55:08.687+00	\N
snap_tx	SNAP Food Benefits	Texas Health and Human Services Commission (HHSC)	food	\N	TX	\N	\N	\N	\N	https://www.yourtexasbenefits.com	\N	t	{}	\N	SNAP / Food Stamps	1-877-541-7905	https://www.hhs.texas.gov	Gross income at or below 165% FPL under BBCE. Retains $5,000 asset limit — vehicle asset test applies (one vehicle excluded up to $22,000 fair market value; excess value counts toward limit). Must be a Texas resident.	165	\N	5000	\N	80	6 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	6	snap	Vehicle asset test applies: only 1 vehicle excluded up to $22,000; excess value counts toward the $5,000 limit. Texas uses Lone Star EBT card.	2026-06-07 00:31:54.551499+00	2026-06-06 00:00:00+00	\N
wic_tx	Texas WIC	Texas Department of State Health Services (DSHS)	food	\N	TX	\N	\N	\N	\N	https://www.texaswic.org/apply	\N	t	{}	\N	WIC	1-800-942-3678	https://www.texaswic.org	Pregnant, postpartum, or breastfeeding women, and children under age 5 with household income at or below 185% FPL. Automatically eligible if currently receiving SNAP or Medicaid.	185	\N	\N	\N	\N	6 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	6	wic	Clinic finder available at texaswic.org. Auto-eligible if on SNAP or Medicaid.	2026-06-07 00:31:54.551499+00	2026-06-06 00:00:00+00	\N
tanf_tx	TANF Cash Help	Texas Health and Human Services Commission (HHSC)	cash	\N	TX	\N	\N	\N	\N	https://www.yourtexasbenefits.com	\N	t	{}	\N	Texas TANF / Choices	1-877-541-7905	https://www.hhs.texas.gov	Low-income families with minor children meeting strict income standard (approximately 12–17% FPL or $341/month for a family of 3). Requires agreement to work or train, cooperation with child support, and immunization of children.	16	\N	1000	60	120	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	tanf_work_first	Maximum monthly cash benefit for a family of 3 (1 parent) is $382. One-time crisis TANF of $1,000 available. Federal 60-month lifetime limit applies.	2026-06-07 00:31:54.551499+00	2026-06-06 00:00:00+00	\N
medicaid_tx	Texas Medicaid	Texas Health and Human Services Commission (HHSC)	healthcare	\N	TX	\N	\N	\N	\N	https://www.yourtexasbenefits.com	\N	t	{}	\N	Medicaid / CHIP Perinatal	1-877-541-7905	https://www.hhs.texas.gov	Texas has NOT expanded Medicaid under the ACA. Adults must be pregnant (up to 203% FPL), disabled, or parents meeting a very low income cap (~12–17% FPL, approximately $341/month for a family of 3). Children qualify up to 206% FPL via CHIP.	17	\N	\N	\N	\N	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	medicaid	Texas has NOT expanded Medicaid. Non-disabled, childless adults are completely ineligible. Pregnant women qualify at 203% FPL. CHIP Perinatal covers unborn children up to 202% FPL. Children qualify at 206% FPL.	2026-06-07 00:31:54.551499+00	2026-06-06 00:00:00+00	\N
childcare_tx	Child Care Services (CCS)	Texas Workforce Commission (TWC)	childcare	\N	TX	\N	\N	\N	\N	https://www.twc.texas.gov/programs/childcare	\N	t	{}	\N	CCS / TWC Childcare	1-800-628-5115	https://www.twc.texas.gov	Parents must be working, in training, or in school at least 25 hours per week (50 hours combined for two-parent households) with income at or below 85% SMI. Assets must not exceed $1,000,000.	\N	85	1000000	\N	108	12 months	{}	{en,es}	closed	High demand; waitlist active across most workforce boards. Applications from May 2025 currently under review.	2026-06-06	\N	\N	12	childcare_subsidy	Copayments are capped at 7% of gross monthly income. Parents must log daily attendance using a digital card system. Applied through local workforce boards.	2026-06-07 00:31:54.551499+00	2026-06-06 00:00:00+00	\N
section8_tx	Housing Choice Voucher Program	Public Housing Agencies (PHAs) / HUD	housing	\N	TX	\N	\N	\N	\N	https://www.hud.gov/states/texas/renting	\N	t	{}	\N	Section 8 Voucher	1-800-955-2232	https://www.hud.gov	Low-income households with income at or below 50% of Area Median Income (AMI). Priority given to extremely low-income households at or below 30% AMI.	50	\N	\N	\N	\N	12 months	{}	{en,es}	closed	Houston Housing Authority: housingforhouston.com | Dallas Housing Authority: dhantx.com | San Antonio Housing Authority (Opportunity Home): opportunityhome.org	2026-06-06	\N	\N	12	section8	Waitlists open rarely; users must check local PHA portals frequently. Almost always closed.	2026-06-07 00:31:54.551499+00	2026-06-06 00:00:00+00	\N
liheap_tx	Comprehensive Energy Assistance Program (CEAP)	Texas Department of Housing and Community Affairs (TDHCA)	energy	\N	TX	\N	\N	\N	\N	https://www.tdhca.texas.gov/community-action-partners	\N	t	{}	\N	CEAP / LIHEAP / Utility Help	1-877-399-8939	https://www.tdhca.texas.gov	Household income must be at or below 150% FPL. Applied through local Community Action Agencies — NOT the state agency directly. Focuses on crisis bills and weatherization.	150	\N	\N	\N	\N	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	liheap	Program prioritizes households with elderly members, disabled members, or children under age 6. Applied through Community Action Agencies, not HHSC. Benefits paid directly to utility company.	2026-06-07 00:31:54.551499+00	2026-06-06 00:00:00+00	\N
childsupport_tx	Child Support Division	Office of the Attorney General (OAG)	legal	\N	TX	\N	\N	\N	\N	https://www.texasattorneygeneral.gov/child-support	\N	t	{}	\N	OAG Child Support	1-800-252-8014	https://www.texasattorneygeneral.gov	Custodial parents seeking to establish paternity, locate non-custodial parents, or enforce child support orders. Services are free if receiving TANF or Medicaid. Federal $35 annual service fee applies once $550 collected for non-assistance cases.	\N	\N	\N	\N	\N	\N	{}	{en,es}	open	\N	2026-06-06	\N	\N	\N	child_support	Federal annual service fee of $35 applies for non-assistance cases once $550 is collected. Paternity can be established up to child's 20th birthday.	2026-06-07 00:31:54.551499+00	2026-06-06 00:00:00+00	\N
snap_ca	CalFresh	California Department of Social Services (CDSS)	food	\N	CA	\N	\N	\N	\N	https://www.benefitscal.com	\N	t	{}	\N	CalFresh / SNAP / Food Stamps	1-877-847-3663	https://www.cdss.ca.gov	Gross income at or below 200% FPL under Broad-Based Categorical Eligibility. No asset limit for the vast majority of households. Must reside in California. Immigrant-friendly: undocumented individuals can receive CalFresh for eligible children.	200	\N	\N	\N	80	12 months	{}	{en,es,zh,vi,ko,tl,hy,ru}	open	\N	2026-06-06	\N	\N	12	snap	California has Broad-Based Categorical Eligibility extending CalFresh to 200% FPL with no asset limit for most households. Undocumented parents may receive CalFresh for eligible children. Uses Golden State Advantage EBT card.	2026-06-07 00:32:34.727244+00	2026-06-06 00:00:00+00	\N
wic_ca	California WIC	California Department of Public Health (CDPH)	food	\N	CA	\N	\N	\N	\N	https://myfamily.wic.ca.gov	\N	t	{}	\N	WIC	1-888-942-9675	https://www.cdph.ca.gov	Pregnant, breastfeeding, or postpartum women, and children under age 5 with income at or below 185% FPL. Automatically eligible if currently enrolled in Medi-Cal.	185	\N	\N	\N	\N	6 months	{}	{en,es,zh,vi}	open	\N	2026-06-06	\N	\N	6	wic	Auto-eligible if enrolled in Medicaid, CalWORKs, or CalFresh. Mobile registration available at myfamily.wic.ca.gov.	2026-06-07 00:32:34.727244+00	2026-06-06 00:00:00+00	\N
tanf_ca	CalWORKs	California Department of Social Services (CDSS)	cash	\N	CA	\N	\N	\N	\N	https://www.benefitscal.com	\N	t	{}	\N	CalWORKs Cash Aid / California TANF	1-877-410-8809	https://www.cdss.ca.gov	Low-income families with minor children. Income must be less than the Maximum Aid Payment (MAP) standard. Countable assets must not exceed $12,552 (raised in 2026). Welfare-to-Work activity required.	50	\N	12552	60	87	12 months	{}	{en,es,zh,vi,ko,tl}	open	\N	2026-06-06	\N	\N	12	tanf_work_first	Maximum monthly cash benefit for Region 1 (family of 3, non-exempt) is $1,175. Assets limit raised to $12,552 in 2026. Work requirement is 20 hrs/week if child under 6; 30 hrs/week if no child under 6. Mandatory in-person county intake interview.	2026-06-07 00:32:34.727244+00	2026-06-06 00:00:00+00	\N
medicaid_ca	Medi-Cal	California Department of Health Care Services (DHCS)	healthcare	\N	CA	\N	\N	\N	\N	https://www.benefitscal.com	\N	t	{}	\N	Medi-Cal / Medicaid	1-800-541-5555	https://www.dhcs.ca.gov	California expanded Medicaid under the ACA. Adults age 19–64 qualify at 138% FPL with NO work requirement. Postpartum and pregnant individuals qualify up to 213% FPL. Immigrants qualify for full-scope Medi-Cal regardless of immigration status.	138	\N	130000	\N	\N	12 months	{}	{en,es,zh,vi,ko,tl}	open	\N	2026-06-06	\N	\N	12	medicaid	California expanded Medicaid — NO work requirement for adults 19–64 at 138% FPL. Immigrants qualify regardless of status. Note: Federal H.R. 1 (signed July 4, 2025) will require 80 hrs/month work requirement effective December 31, 2026 for expansion adults. Asset limit $130,000.	2026-06-07 00:32:34.727244+00	2026-06-06 00:00:00+00	\N
childcare_ca	CalWORKs Stage 1/2 Child Care	California Department of Social Services (CDSS)	childcare	\N	CA	\N	\N	\N	\N	https://www.benefitscal.com	\N	t	{}	\N	CalWORKs Childcare / CCDF	1-800-500-1112	https://www.cdss.ca.gov	Families receiving CalWORKs or meeting gross income standards at or below 85% SMI. Parent must be participating in an approved Welfare-to-Work activity. Stage 1 care is guaranteed during Welfare-to-Work.	\N	85	1000000	\N	87	12 months	{}	{en,es,zh,vi}	open	Stage 1 is immediate for CalWORKs enrollees; Stage 3/General Child Care has localized waitlists.	2026-06-06	\N	\N	12	childcare_subsidy	Copayments capped at 7% of gross monthly income. Stage 1 care guaranteed during Welfare-to-Work. Applied through county Alternative Payment Program (APP) agencies.	2026-06-07 00:32:34.727244+00	2026-06-06 00:00:00+00	\N
section8_ca	Housing Choice Voucher Program	Public Housing Agencies (PHAs) / HUD	housing	\N	CA	\N	\N	\N	\N	https://www.hud.gov/states/california/renting	\N	t	{}	\N	Section 8 Voucher	1-800-955-2232	https://www.hud.gov	Household income at or below 50% of Area Median Income (AMI). Priority given to extremely low-income households at or below 30% AMI.	50	\N	\N	\N	\N	12 months	{}	{en,es,zh,vi}	closed	Housing Authority of the City of LA (HACLA): hacla.org | LA County Housing: lacda.org | Santa Clara County: scchousingauthority.org	2026-06-06	\N	\N	12	section8	Voucher waitlists remain closed across major urban centers. Users must enroll in local notification systems to be alerted when waitlists open.	2026-06-07 00:32:34.727244+00	2026-06-06 00:00:00+00	\N
liheap_ca	California LIHEAP	Department of Community Services and Development (CSD)	energy	\N	CA	\N	\N	\N	\N	https://www.csd.ca.gov/Pages/LIHEAP.aspx	\N	t	{}	\N	LIHEAP / Energy Help	1-866-675-6623	https://www.csd.ca.gov	Household gross income must be at or below 60% of State Median Income (SMI). Applied through county Community Action Agencies. Supports both heating and cooling assistance.	\N	60	\N	\N	\N	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	liheap	Applied through local Community Action Agencies. Supports heating, cooling, and weatherization. Benefits paid directly to utility company.	2026-06-07 00:32:34.727244+00	2026-06-06 00:00:00+00	\N
childsupport_ca	Department of Child Support Services	California Department of Child Support Services (DCSS)	legal	\N	CA	\N	\N	\N	\N	https://childsupport.ca.gov	\N	t	{}	\N	DCSS Child Support	1-866-901-3212	https://childsupport.ca.gov	Custodial parents seeking parentage establishment, support orders, or collection enforcement. Services are entirely free — no application fees apply in California.	\N	\N	\N	\N	\N	\N	{}	{en,es,vi,ko,zh}	open	\N	2026-06-06	\N	\N	\N	child_support	California does not charge application fees for child support cases. Legal aid partners provide pro-bono assistance. Paternity can be established up to child's 18th birthday.	2026-06-07 00:32:34.727244+00	2026-06-06 00:00:00+00	\N
snap_fl	Food Assistance Program	Department of Children and Families (DCF)	food	\N	FL	\N	\N	\N	\N	https://www.myflfamilies.com	\N	t	{}	\N	SNAP / Food Stamps / ACCESS Florida	1-850-300-4323	https://www.myflfamilies.com	Gross income at or below 200% FPL under Broad-Based Categorical Eligibility. No asset test for standard households. Must be a Florida resident.	200	\N	\N	\N	80	6 months	{}	{en,es,ht}	open	\N	2026-06-06	\N	\N	6	snap	Florida has Broad-Based Categorical Eligibility extending SNAP to 200% FPL with no asset limit for most households. Uses ACCESS Florida EBT card.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
wic_fl	Florida WIC	Florida Department of Health (DOH)	food	\N	FL	\N	\N	\N	\N	https://www.floridahealth.gov/programs-and-services/clinical-and-nutrition-services/wic	\N	t	{}	\N	WIC	1-800-342-3556	https://www.floridahealth.gov	Pregnant, postpartum, or breastfeeding women, and children under age 5 with household income at or below 185% FPL. Automatically eligible if currently receiving SNAP.	185	\N	\N	\N	\N	6 months	{}	{en,es,ht}	open	\N	2026-06-06	\N	\N	6	wic	Applied through county health department WIC clinics. Miami-Dade appointment line: 786-336-1300.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
tanf_fl	Temporary Cash Assistance (TCA)	Department of Children and Families (DCF)	cash	\N	FL	\N	\N	\N	\N	https://www.myflfamilies.com	\N	t	{}	\N	TCA / Florida TANF	1-850-300-4323	https://www.myflfamilies.com	Low-income families with gross income at or below 185% FPL and net income below the payment standard ($303 for family of 3). Liquid assets at or below $2,000. Children under 5 must be immunized; children 6–18 must attend school.	185	\N	2000	48	120	12 months	{}	{en,es,ht}	open	\N	2026-06-06	\N	\N	12	tanf_work_first	Maximum monthly cash benefit for a family of 3 is $303 — one of the lowest in the nation. Florida has a 48-month lifetime limit (shorter than federal 60-month). Requires work registration via CareerSource Florida.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
medicaid_fl	ACCESS Florida Medicaid	Department of Children and Families (DCF)	healthcare	\N	FL	\N	\N	\N	\N	https://www.myflfamilies.com	\N	t	{}	\N	Family Medicaid / CHIP Florida	1-850-300-4323	https://www.myflfamilies.com	Florida has NOT expanded Medicaid under the ACA. Adults must be pregnant (up to 196% FPL with 12 months postpartum) or parents meeting a very low income standard (approximately 27% FPL, $615/month for a family of 3). Children covered under CHIP up to 215% FPL.	27	\N	\N	\N	\N	12 months	{}	{en,es,ht}	open	\N	2026-06-06	\N	\N	12	medicaid	Florida has NOT expanded Medicaid. Non-disabled, childless adults are completely ineligible. Pregnant women qualify at 196% FPL with 12-month postpartum coverage. CHIP covers children up to 215% FPL.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
childcare_fl	School Readiness Program	Division of Early Learning (DEL) / Local Coalitions	childcare	\N	FL	\N	\N	\N	\N	https://familyportal.floridaearlylearning.com	\N	t	{}	\N	SR / Early Learning Subsidy	1-866-357-3239	https://www.floridaearlylearning.com	Low-income working parents (minimum 20 hours/week) with household gross income at or below 150% FPL initially. Families can remain eligible up to 85% SMI. Administered locally by regional Early Learning Coalitions.	150	85	\N	\N	87	12 months	{}	{en,es,ht}	open	Local Early Learning Coalitions manage waitlists; priority given to foster children, homeless families, and TANF enrollees.	2026-06-06	\N	\N	12	childcare_subsidy	Administered by regional Early Learning Coalitions. Initial eligibility 150% FPL; exit threshold 85% SMI. Applied through Family Portal online.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
section8_fl	Housing Choice Voucher Program	Public Housing Agencies (PHAs) / HUD	housing	\N	FL	\N	\N	\N	\N	https://www.hud.gov/states/florida/renting	\N	t	{}	\N	Section 8 Voucher	1-800-955-2232	https://www.hud.gov	Household income at or below 50% of Area Median Income (AMI). Priority given to extremely low-income households at or below 30% AMI.	50	\N	\N	\N	\N	12 months	{}	{en,es}	closed	Miami-Dade Public Housing: miamidade.gov/housing | Tampa Housing Authority: thafl.com | Jacksonville Housing Authority: jaxha.org	2026-06-06	\N	\N	12	section8	Waitlists are almost always closed across major cities in Florida. Check local PHA portals frequently for openings.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
liheap_fl	Low Income Home Energy Assistance Program	Department of Commerce (FloridaCommerce)	energy	\N	FL	\N	\N	\N	\N	https://floridaliheap.com	\N	t	{}	\N	LIHEAP / Utility Help	1-850-717-8450	https://www.floridajobs.org	Household income must be at or below 60% of State Median Income (SMI). Applied through local Community Action Agencies.	\N	60	\N	\N	\N	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	liheap	Applied through county Community Action Agencies. Benefits paid directly to utility company. Supports both heating and cooling given Florida climate.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
childsupport_fl	Child Support Program	Florida Department of Revenue (DOR)	legal	\N	FL	\N	\N	\N	\N	https://floridarevenue.com/childsupport	\N	t	{}	\N	DOR Child Support	1-850-488-5437	https://floridarevenue.com/childsupport	Custodial parents seeking to locate a parent, establish paternity, or enforce support orders. Services are free — Florida does not charge an application fee for child support cases.	\N	\N	\N	\N	\N	\N	{}	{en,es,ht}	open	\N	2026-06-06	\N	\N	\N	child_support	Florida does not charge an application fee for child support cases. Paternity can be established up to child's 22nd birthday.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
snap_ny	Supplemental Nutrition Assistance Program	Office of Temporary and Disability Assistance (OTDA)	food	\N	NY	\N	\N	\N	\N	https://www.mybenefits.ny.gov	\N	t	{}	\N	SNAP / Food Stamps / myBenefits	1-800-342-3009	https://otda.ny.gov/programs/snap	Gross income at or below 200% FPL under Broad-Based Categorical Eligibility for households with dependent care costs or elderly/disabled members. 150% FPL gross limit if earning income. No asset limit for the majority of households.	200	\N	\N	\N	80	12 months	{}	{en,es,zh,ru,ar,bn,ko,ht}	open	\N	2026-06-06	\N	\N	12	snap	New York uses myBenefits portal (mybenefits.ny.gov). Under Broad-Based Categorical Eligibility, no asset limit for most households. Uses Common Benefit Identification Card (CBIC) EBT.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
wic_ny	New York State WIC	New York State Department of Health (DOH)	food	\N	NY	\N	\N	\N	\N	https://www.health.ny.gov/prevention/nutrition/wic	\N	t	{}	\N	WIC	1-800-522-5006	https://www.health.ny.gov	Pregnant, postpartum, or breastfeeding women, and children under age 5 with gross household income at or below 185% FPL. Automatically eligible if receiving Medicaid or SNAP.	185	\N	\N	\N	\N	6 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	6	wic	Clinic finder available at health.ny.gov. Auto-eligible if enrolled in Medicaid or SNAP.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
tanf_ny	Family Assistance (FA)	Office of Temporary and Disability Assistance (OTDA)	cash	\N	NY	\N	\N	\N	\N	https://www.mybenefits.ny.gov	\N	t	{}	\N	TA / Cash Assistance / New York TANF	1-800-342-3009	https://otda.ny.gov	Low-income families with minor children. Income must be less than the state Standard of Need (approximately $336/month). Countable liquid assets must not exceed $2,000.	16	\N	2000	60	120	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	tanf_work_first	Cash assistance benefit ranges from $648 to $836 for a family of three, depending on county of residence. Mandatory in-person intake at county DSS office. $2,000 asset limit enforced.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
medicaid_ny	NY State of Health Medicaid	Department of Health (DOH) / NY State of Health	healthcare	\N	NY	\N	\N	\N	\N	https://nystateofhealth.ny.gov	\N	t	{}	\N	MAGI Medicaid / FHP / Child Health Plus	1-855-355-5777	https://nystateofhealth.ny.gov	New York expanded Medicaid under the ACA. Adults age 19–64 qualify at 138% FPL with NO work requirement. Pregnant individuals and infants under 1 qualify up to 223% FPL. Children qualify up to 154% FPL.	138	\N	\N	\N	\N	12 months	{}	{en,es,zh,vi,ko,ru}	open	\N	2026-06-06	\N	\N	12	medicaid	NY expanded Medicaid — NO work requirement. CRITICAL: NY Essential Plan income limit is dropping from 250% FPL to 200% FPL on July 1, 2026 due to federal H.R. 1 — approximately 450,000 New Yorkers affected. Federal work requirement (80 hrs/month) takes effect December 31, 2026 for ACA expansion adults.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
childcare_ny	Child Care Assistance Program (CCAP)	Office of Children and Family Services (OCFS)	childcare	\N	NY	\N	\N	\N	\N	https://mycity.nyc.gov	\N	t	{}	\N	CCAP / Childcare Subsidy	1-518-474-9454	https://ocfs.ny.gov/programs/childcare/ccap	Low-income parents working 10+ hours per week, seeking work, or in training, with household gross income at or below 85% SMI ($95,396 annually for a family of 3). Administered by local social services districts.	\N	85	\N	\N	43	12 months	{}	{en,es,zh,ru,ar,bn,ko,ht}	closed	Families face waitlists for vouchers in NYC unless in temporary shelter. Stage 1 care is immediate for cash assistance enrollees.	2026-06-06	\N	\N	12	childcare_subsidy	Copayments capped at 7% of gross monthly income. NYC families use MyCity portal. Outside NYC, apply at local county DSS office. Work requirement is only 10 hrs/week.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
section8_ny	Housing Choice Voucher Program	Public Housing Agencies (PHAs) / HUD	housing	\N	NY	\N	\N	\N	\N	https://www.hud.gov/states/new_york/renting	\N	t	{}	\N	Section 8 Voucher	1-800-955-2232	https://www.hud.gov	Household income at or below 50% of Area Median Income (AMI). Priority given to extremely low-income households at or below 30% AMI.	50	\N	\N	\N	\N	12 months	{}	{en,es}	closed	New York City Housing Authority (NYCHA): nyc.gov/nycha | NY State Homes & Community Renewal: hcr.ny.gov | Buffalo Municipal Housing: bmha-ny.org	2026-06-06	\N	\N	12	section8	NYCHA administers the largest Section 8 voucher program in the country with over 90,000 vouchers. Waitlists almost always closed.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
liheap_ny	Home Energy Assistance Program (HEAP)	Office of Temporary and Disability Assistance (OTDA)	energy	\N	NY	\N	\N	\N	\N	https://www.mybenefits.ny.gov	\N	t	{}	\N	HEAP / Energy Assistance	1-800-342-3009	https://otda.ny.gov/programs/heap	Gross household monthly income at or below 60% of State Median Income (SMI, approximately $5,611 for a family of 3). Applied through local county Departments of Social Services. Primarily heating assistance.	\N	60	\N	\N	\N	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	liheap	Applied through local county Departments of Social Services (LDSS). Primarily heating assistance given New York climate. Benefits paid directly to utility company.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
childsupport_ny	Division of Child Support Services	Division of Child Support Services (OTDA)	legal	\N	NY	\N	\N	\N	\N	https://childsupport.ny.gov	\N	t	{}	\N	Child Support Services NY	1-888-208-4485	https://childsupport.ny.gov	Custodial parents seeking parentage establishment, support orders, or collection enforcement. Services are free — New York does not charge an application fee.	\N	\N	\N	\N	\N	\N	{}	{en,es,zh,ru}	open	\N	2026-06-06	\N	\N	\N	child_support	New York does not charge application fees for child support cases. Paternity can be established up to child's 21st birthday.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
snap_il	Food Assistance	Illinois Department of Human Services (IDHS)	food	\N	IL	\N	\N	\N	\N	https://abe.illinois.gov	\N	t	{}	\N	SNAP / Link Card / Illinois SNAP	1-800-843-6154	https://www.dhs.state.il.us	Gross income at or below 165% FPL under Broad-Based Categorical Eligibility. No asset limit for standard households. Must reside in Illinois.	165	\N	\N	\N	80	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	snap	Illinois uses ABE portal (abe.illinois.gov). Under Broad-Based Categorical Eligibility, no asset limit for most households. Uses Illinois Link card.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
wic_il	Illinois WIC	Illinois Department of Human Services (IDHS)	food	\N	IL	\N	\N	\N	\N	http://www.dhs.state.il.us	\N	t	{}	\N	WIC	1-800-323-4769	https://www.dhs.state.il.us	Pregnant, breastfeeding, or postpartum women, and children under age 5 with gross household income at or below 185% FPL. Automatically eligible if on SNAP or Medicaid.	185	\N	\N	\N	\N	6 months	{}	{en,es,zh,ar,pl}	open	\N	2026-06-06	\N	\N	6	wic	Auto-eligible if enrolled in Medicaid, TANF, or SNAP. Clinic finder at signup.wic.il.gov.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
tanf_il	TANF Cash Assistance	Illinois Department of Human Services (IDHS)	cash	\N	IL	\N	\N	\N	\N	https://abe.illinois.gov	\N	t	{}	\N	Illinois TANF / FamilyCare	1-800-843-6154	https://www.dhs.state.il.us	Low-income families with minor children. Income must be less than the Assistance Payment Level ($777 for a family of 3). No asset limit applies for standard families.	16	\N	\N	60	120	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	tanf_work_first	Maximum monthly cash benefit for a family of 3 (adult + children) is $777. Child-only case limit is $583. No asset limit for TANF in Illinois. Work registration via Responsibility and Services Plan (RSP).	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
medicaid_il	Illinois Medicaid	Department of Healthcare and Family Services (HFS)	healthcare	\N	IL	\N	\N	\N	\N	https://abe.illinois.gov	\N	t	{}	\N	FamilyCare / All Kids Assist / Medicaid	1-800-226-0768	https://hfs.illinois.gov	Illinois expanded Medicaid under the ACA. Adults age 19–64 qualify at 138% FPL with NO work requirement. Pregnant individuals qualify up to 213% FPL. Children (CHIP/All Kids) qualify up to 318% FPL.	138	\N	\N	\N	\N	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	medicaid	Illinois expanded Medicaid — NO work requirement for adults 19–64 at 138% FPL. All Kids Assist provides coverage for children up to 318% FPL. Federal H.R. 1 work requirement (80 hrs/month) takes effect December 31, 2026 for ACA expansion adults.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
childcare_il	Child Care Assistance Program (CCAP)	Illinois Department of Human Services (IDHS)	childcare	\N	IL	\N	\N	\N	\N	https://www.dhs.state.il.us/page.aspx?item=30355	\N	t	{}	\N	Illinois CCAP / Childcare Subsidy	1-877-202-4453	https://www.dhs.state.il.us	Gross household monthly income at or below 225% FPL initially (~$4,997/month for family of 3). Redetermination eligibility up to 275% FPL. Phase-out period up to 85% SMI (~$7,267/month). Parent must be working or in school.	225	85	\N	\N	87	12 months	{}	{en,es}	open	No waitlist; slots are open for eligible families in Illinois.	2026-06-06	\N	\N	12	childcare_subsidy	No waitlist in Illinois — slots open for eligible families. Copayments capped at 7% of gross monthly income. Families can remain eligible up to 85% SMI during redetermination. Applied through local CCR&R agencies.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
section8_il	Housing Choice Voucher Program	Public Housing Agencies (PHAs) / HUD	housing	\N	IL	\N	\N	\N	\N	https://www.hud.gov/states/illinois/renting	\N	t	{}	\N	Section 8 Voucher	1-800-955-2232	https://www.hud.gov	Household income at or below 50% of Area Median Income (AMI). Priority given to extremely low-income households at or below 30% AMI.	50	\N	\N	\N	\N	12 months	{}	{en,es}	closed	Chicago Housing Authority: thecha.org | Housing Authority of Cook County: thehacc.org | Rockford Housing Authority: rockfordha.org	2026-06-06	\N	\N	12	section8	Waitlists almost always closed across major Illinois cities. Check local PHA portals frequently.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
liheap_il	Low Income Home Energy Assistance Program	Department of Commerce and Economic Opportunity (DCEO)	energy	\N	IL	\N	\N	\N	\N	https://www.illinois.gov	\N	t	{}	\N	LIHEAP / Utility Help	1-877-411-9276	https://www.illinois.gov	Gross household monthly income at or below 60% of State Median Income (SMI). Applied through county Community Action Agencies.	\N	60	\N	\N	\N	12 months	{}	{en,es}	open	\N	2026-06-06	\N	\N	12	liheap	Applied through local Community Action Agencies. Supports primarily heating assistance. Benefits paid directly to utility company.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
childsupport_il	Child Support Services	Department of Healthcare and Family Services (HFS)	legal	\N	IL	\N	\N	\N	\N	https://www.hfs.illinois.gov/childsupport	\N	t	{}	\N	HFS Child Support / Illinois CSS	1-800-447-4278	https://hfs.illinois.gov	Custodial parents seeking parentage establishment, support orders, or collection enforcement. Services are free — Illinois does not charge application fees.	\N	\N	\N	\N	\N	\N	{}	{en,es}	open	\N	2026-06-06	\N	\N	\N	child_support	Illinois does not charge application fees for child support cases. Paternity can be established up to child's 20th birthday.	2026-06-07 00:34:02.718646+00	2026-06-06 00:00:00+00	\N
\.


--
-- TOC entry 4719 (class 0 OID 27511)
-- Dependencies: 420
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.refresh_tokens (id, token, user_id, expires_at, revoked, created_at) FROM stdin;
3ca36ab8-4f26-4216-a39b-645f9ec949fa	f557334ac6451cf8b5fd7ce6ba06af7805442ff026678959bb0796b432b76ea7	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 14:23:00.614+00	t	2026-06-09 14:23:00.615+00
f2e6fd36-ece4-4648-a600-e600460fec34	c4b4868090e4653957b36dc59c5072201c4637d91c9e274cc4a9e754ecff826c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 14:23:33.823+00	t	2026-06-09 14:23:33.824+00
9b2e2f0a-3f5a-4dd6-adbe-ad806da96815	63450687212c2e83f8273cf87baf5c9a692d271a525fc61ca8a424de3be09206	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 14:38:41.306+00	t	2026-06-09 14:38:41.307+00
ecc9fa58-7ddb-4d5a-b561-b0c76aa13cad	394b072edef58d3125b3a74096b974b34d066a85c1b191d11dfa79f7f2558867	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 14:44:18.115+00	t	2026-06-09 14:44:18.116+00
0237b8bd-2b8e-44aa-b605-c0c9ff724205	d15b9b60ece619d717ed76ff5c552097298ce19b7ee529acfe677fdb104ddb57	b2fde45d-108b-400a-9b65-e42184ed68a2	2026-07-09 14:45:02.114+00	f	2026-06-09 14:45:02.115+00
729cab25-1870-4d27-b4be-b91f9826b994	3e2e78598a706fc5b757fd83666121ad49b94a4fd24c77d7a001de5e8be14b06	b2fde45d-108b-400a-9b65-e42184ed68a2	2026-07-09 14:46:25.331+00	f	2026-06-09 14:46:25.332+00
af4531e9-fdb6-47dc-928e-84240c2d2d23	e9863ab8fce80ec3c32de321c4ba0f33b167f7d28861d1cb559bc2d5ddc71f07	b2fde45d-108b-400a-9b65-e42184ed68a2	2026-07-09 14:47:18.269+00	f	2026-06-09 14:47:18.27+00
35af70c6-d220-438a-a91e-36dfccc9479c	03c9b82b966c59c42381e93ea24079733d5f8a288a589ae179039f7956873985	b2fde45d-108b-400a-9b65-e42184ed68a2	2026-07-09 16:25:17.131+00	f	2026-06-09 16:25:17.132+00
5723e3ba-0ef8-402b-9daf-b3f1b9c6e07c	c46a796d1ac118fc19d5513b5ea9317b0a814e476ec720def840ce4ba1be107d	c4966c51-a590-485c-bf82-0d699e087ab8	2026-07-09 16:35:40.175+00	f	2026-06-09 16:35:40.176+00
27a757ab-5416-4309-b368-5917cf5564b5	e85be4c5fd2ff639eef7810b4497793126cd6882c5a87e49613d137b17738f7d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 16:42:49.846+00	t	2026-06-09 16:42:49.847+00
3e3a7fc1-ee1c-4091-98ce-16951b3bb088	b0fbde0ce5a489cd2e61bac8870739e549a9fff85f9697c992fb2b54a1fb692f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 16:43:39.167+00	t	2026-06-09 16:43:39.168+00
a823a438-1bd4-45dc-83c5-2ecb1556baba	fae3b48577c6b6dca3ceb186bc4099e37c2dbda600160dba5ddbdc0f97666a3e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 16:50:55.951+00	t	2026-06-09 16:50:55.952+00
480166ef-983c-455a-8fe0-b78ebae2f155	93a17257e2c3521a81b3b73d9a6767a5feaf4025d1217ef5bcd61247d2030c80	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 16:53:51.072+00	t	2026-06-09 16:53:51.074+00
30df5784-b0f6-401e-a694-2ba53e6651e4	6d0be4e5d202441e08f40fccf07d225f727a933a33761f49df30e769bb24bfb9	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 16:55:54.482+00	t	2026-06-09 16:55:54.483+00
5274654a-ce46-458f-a0a1-fa29167f2a64	f6147457cdc524ca4822effb41a29e884cd6e954c2af7a959057418fe73eebe9	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 16:56:27.57+00	t	2026-06-09 16:56:27.571+00
757fed6c-7bd8-43d2-8ec4-06f7f3b7fe31	f4b343be33deb9a0c6db4e06703817f4302fe25876407961790f2eb33070d7da	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 17:00:13.169+00	t	2026-06-09 17:00:13.17+00
2831428c-24f5-4a83-aab9-a77bcf4e1b6c	3121d7d67beaf99ea206e69ab1a1e572c2eda14c49fc5adf933812719079e1f6	c4966c51-a590-485c-bf82-0d699e087ab8	2026-07-09 18:13:59.346+00	f	2026-06-09 18:13:59.347+00
a5194f54-b93b-4b8d-b4b5-ce6540d98fa0	0f8aee1dfc012d2d48f0a2833f6047d01e98652f18405e3bd67ba219bd86444c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 17:31:30.905+00	t	2026-06-09 17:31:30.906+00
c4723d5e-c376-4bff-97bc-e5375507462d	d2878303013f8ea5343237ed8feacdcabc173f916a635706e820d5f87ebf7282	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 18:30:21.476+00	t	2026-06-09 18:30:21.477+00
45f108a1-6d31-4780-8da1-32e753ed0a00	cac356bad607a4a985c6d186f7dfb735e387a6301351cd70b8387249e2570206	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 19:03:33.637+00	t	2026-06-09 19:03:33.637+00
d18cb118-1321-48f4-9bc1-825697737c00	bb693e46c60e2a804cfe6f9eee27c39f397bffa0bcd142b9898ef34f7a9a3087	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 19:06:51.739+00	t	2026-06-09 19:06:51.739+00
1e519c07-09fe-42ca-86d4-4ae218c0ca56	95010f8828c52eaf337a176fc02e628612c8e7b7c45ddd93e0b6802131be7fcb	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 19:22:57.043+00	t	2026-06-09 19:22:57.044+00
371fb5af-e74e-4483-a9c0-d538d02688aa	6dfcf268834e217292fb526f954ce93df8a550adc599396bb0be01de8f492e2c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 19:29:20.149+00	t	2026-06-09 19:29:20.149+00
58df3060-5c47-49b0-a2d3-d9f381b197a7	97e7ca7b515b9169c94e65efad09417ce656c9f197ac365b0deb6da39ac91d49	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 19:37:49.461+00	t	2026-06-09 19:37:49.462+00
f1c1f4df-ccca-4335-bc8d-0113a097762d	952037de6857f1a4210184bf9b9652601e952407f7a7ba4917115968c65ba6e2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 19:52:57.066+00	t	2026-06-09 19:52:57.068+00
5570b39d-f8b4-4c53-aad2-a883f8fb4ed8	b0a7b28420ca42123803e21ac14a581535498eaeff8561de97d5da9b16cd3b30	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 20:08:57.369+00	t	2026-06-09 20:08:57.371+00
cf73d939-b180-4ff1-88a7-f8e4e9edc63b	c026f69c1782866187f8a7d9136a1a4069d76eb3d1e13a55f1c1d041c9ae8ee0	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 20:24:59.459+00	t	2026-06-09 20:24:59.46+00
967f096d-a206-4720-be72-a03fbf6685d4	452199558bc8345135e819a9ec2fb04b0f2febc2201f1ae3c7139f49f48eef1c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 20:33:55.913+00	t	2026-06-09 20:33:55.913+00
a7754ca1-d43e-4794-a6e7-34c2c7c2df27	8ebd538527943ca60eb4ab669b6e8ddc07ec07fadc6310315a7ffee781726862	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 01:02:48.5+00	t	2026-06-10 01:02:48.501+00
ed480aa2-b9a9-418a-842c-c7e40b1f8ce8	00a68e5300e89e9c2f6521ad9daf8c63c9106f973992eb8da1cd2c969097a0ae	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 20:40:27.899+00	t	2026-06-09 20:40:27.9+00
aebfa6f7-0b99-4867-8566-056d14a19e31	1bd92c507f5c2ef33cd10bb145d5ec026fb8f2413b1d63e431dca6f49ff2f7d9	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 20:44:45.352+00	t	2026-06-09 20:44:45.353+00
7ce93e3c-a03c-4ffe-ad24-bc981771fdbd	ca24e6ef42ba5f8a95c06b7c08c547f15cbf2eec1067bea86049c86e92def358	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 20:47:58.831+00	t	2026-06-09 20:47:58.832+00
9816c5fe-a5f2-422d-a925-4e48c3e35f75	1fdf3b187a7b59a7bd01943864c8a2d108f724342346808c09f4d9dc02fb749a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 21:17:31.481+00	t	2026-06-09 21:17:31.482+00
e62f390d-b84e-45d4-b800-e390f4fa96a8	6c1f205be832ad431b2b9345acecc435bc311df7c3dfc4dce9d533c0525bef36	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 23:00:51.12+00	t	2026-06-09 23:00:51.121+00
3b246b26-5039-465f-bd62-9fd81d203171	5f00673e80209901e1b6ad1cec0d56fa85def7bd7a3a457aa806839f5820ca1e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 23:53:42.315+00	t	2026-06-09 23:53:42.316+00
3c36e897-59ff-42cb-be99-d972f7d938cb	ef3ec5e50ceb7714afba8afe7f79ec310da2d9440ddca533a86505fceac2fe15	c4966c51-a590-485c-bf82-0d699e087ab8	2026-07-10 01:47:41.684+00	f	2026-06-10 01:47:41.684+00
6e5fa3ae-7b39-4767-b6ca-1d06213a577c	edd1c46631dd81d4b27b24f4fc1b07c85957b6903e9910cd39db5b3ee41b51fe	c4966c51-a590-485c-bf82-0d699e087ab8	2026-07-10 01:47:52.477+00	f	2026-06-10 01:47:52.478+00
28d8cbc5-02de-441a-a2e9-e6a088090fa2	d8d4a1492f9355a83dba45025387ebb69626abdf7ed7834297137a67af213aa7	c4966c51-a590-485c-bf82-0d699e087ab8	2026-07-10 02:54:51.579+00	f	2026-06-10 02:54:51.58+00
1407296a-b894-4561-82bc-4ddcfe8b77d1	57bb3e30cad8fbe84a7b53fb880a2ffc7a009e20d3515a15df2212e43c7ecec0	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 02:03:45.322+00	t	2026-06-10 02:03:45.323+00
6d397f15-4b70-4f65-a4aa-654281bf61d0	4d0a5de4216144d82773afe4ae6b0ba61acd63f64eca9b8e948e68555eeb9f6d	b2fde45d-108b-400a-9b65-e42184ed68a2	2026-07-10 03:42:43.914+00	f	2026-06-10 03:42:43.915+00
b0983a3e-a15b-4cc1-b572-e2082448a780	277422559bc647a322774f6c38316bbcd415a0a194bfe84525533392965377b5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 03:04:42.462+00	t	2026-06-10 03:04:42.463+00
50f66196-6365-4084-8fee-a45d38ed0249	65ef6f782f8d502acb4361b85b9109dbb9d92d695eb8beafc39241ee8af46cdd	b2fde45d-108b-400a-9b65-e42184ed68a2	2026-07-10 03:57:40.925+00	f	2026-06-10 03:57:40.925+00
4ff2c821-b679-4172-9d4d-370d2e5f407f	35d1c4553e96f24928cb1e78223b4307761e404b8336d762ed6cc653debbe0c5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 03:46:57.607+00	t	2026-06-10 03:46:57.608+00
2f5bbfca-f8bd-4952-ace6-22244850e267	91af154994f7a622b92c0630a2291cba67f8c8daa4d75432bec24bd81547c26a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 19:09:31.135+00	t	2026-06-09 19:09:31.136+00
02774f67-465a-4070-8a03-0159460b249e	7363e2e62049f4873ebbac94f8797c83696cf04ac5ed1038036161659bf52895	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-09 20:44:43.736+00	t	2026-06-09 20:44:43.737+00
e57d6de6-0292-4a6d-8770-03bd12d21cd9	d0fe347a81e5ae8ae9355949f986e2516faf2d6e108bd21d9a253c99694b3a24	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 01:01:50.947+00	t	2026-06-10 01:01:50.948+00
4fc6519c-4df1-40b4-aebb-3b061a81d4ce	8146e77441d5bddcfb0185d87250fe8188e9a48b849b6e0c0fea6581712c5c43	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 05:52:25.822+00	t	2026-06-10 05:52:25.823+00
da3d87fa-f15f-40de-8d85-8853c6ab96d7	cf4cb8cc022971e33eb51a019c3a2a0e55076e5e075d48a2abce5bc0ff2c91bc	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 09:16:55.972+00	t	2026-06-10 09:16:55.973+00
bca9715a-091f-47f2-a0e6-2a4ab000b469	bcd24572da8cbb958219b22c6ceb862fcb2936e78dd1de18c9b7c5b8b64e6cd9	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 09:37:07.989+00	t	2026-06-10 09:37:07.99+00
d38d326b-a074-490a-ae86-199c98edb38a	62a8e7a1ee0fcf1f911ad990bce83a0acc844534d60860d360733450c94c3d7c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 09:45:02.521+00	t	2026-06-10 09:45:02.522+00
f3dc9703-f566-4f62-b234-42377df8158b	8ec31f0286b9432c9f87b34fa155d41e7b98044da8e2156778cb6520fcd786ea	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 09:45:17.578+00	t	2026-06-10 09:45:17.579+00
e50d1c36-af34-49c7-bfde-56b348b82d02	9430e24ed762b531a88159d7cf50d3b9f904962c3cd6277df9c4883202e45a05	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 09:47:36.95+00	t	2026-06-10 09:47:36.952+00
38707f99-4326-43e0-8c69-0f3d08670a88	43d64edf6f63950dff8b82288f7d3bc9da327e465e4367ecc37988eaba9fa353	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 09:49:52.29+00	t	2026-06-10 09:49:52.291+00
d76872e0-225d-47f1-9faf-bb64baf0a09b	b46f4285d6ff20dbcbca62b6f69b39668d7ef3cacf95d4845f451dbbc30a19e7	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 09:50:44.979+00	t	2026-06-10 09:50:44.98+00
d3e7099a-6721-4d81-8b44-467467b82587	bbb9ae07c073cef751b47d44ff74df4b30db94b4f6b14b9d2d6d89300e7ababf	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 10:17:18.54+00	t	2026-06-10 10:17:18.541+00
0de52571-f2fa-45ae-bf97-3e8b08773739	3fe2cc93301554465cea183418b3afcb32fb657d4308d035f5c773e8d722f1e2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 10:32:24.641+00	t	2026-06-10 10:32:24.642+00
d9e816da-f241-4e88-9aee-ac726d42f699	e9e8f64528997b3fdac89316ca9e7c4c3cc7f0be4b316fd672ea6238f6fedd8a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 10:42:30.733+00	t	2026-06-10 10:42:30.735+00
f7d03de3-b97f-4909-a52a-0deb76860b4b	49bdd812ddcd2d87030f213e3e04294cea814efb7fca93c1249fb3eec343514d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 10:57:38.816+00	t	2026-06-10 10:57:38.817+00
389182a0-b0c0-498b-a89f-077566090e1c	4f2c594393b78ac78ebcbe642e060f4d4b05f7731f9f2898b45b20cab9ab68ad	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 14:24:13.964+00	t	2026-06-10 14:24:13.965+00
51e13eb1-9486-4930-988e-8dd8b202986b	458af5f2f4d51e0e0935063846b86e653894c6583904ffcfeefd1527747a26d8	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 14:25:52.672+00	t	2026-06-10 14:25:52.673+00
2b447f4d-2ecf-48d5-9642-fd1d9de07ec7	d1e1450d894086b949f6caf9ecb4f5c13029b17f8fb2129b721392fc896b7063	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 14:41:09.356+00	t	2026-06-10 14:41:09.357+00
3d720197-5ea4-4491-8a63-c23eb8251ae3	24f0e723afc178be833f964785c5643cb7504e3fcda99fc14bebe09027fcfa12	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 14:57:12.252+00	t	2026-06-10 14:57:12.253+00
0d99a5eb-3383-4067-bb0e-1e83a9296eb0	b0f6f6151e9c0b507472d97fc4d44ed2330939293578e7c70932da1af1ee4692	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 15:13:06.679+00	t	2026-06-10 15:13:06.68+00
54dac702-09b3-4c46-a148-48b37a7d8178	8de5ca1eec163a2754426329672400ef20828f6cf62218e981c89230dd3d0ffe	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 15:29:06.58+00	t	2026-06-10 15:29:06.581+00
6b5d5c16-2d4e-4c1d-b1bc-0415e0484dd8	398281056d9ff5fe55c4ba5e2eb6f279d4588de8588aeff80e5baf1f6f12c9db	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 15:31:41.879+00	t	2026-06-10 15:31:41.88+00
93df61cc-034c-4dd8-bd66-223de3a3c676	c0fa3b74a80da845fdb0adac1590825935f1ca03d59d60a2a1cdd3aeed935875	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 15:47:07.487+00	t	2026-06-10 15:47:07.488+00
7ca78eff-b0ae-4b87-a6ad-582f91a477ca	45d91e77b8a79a2dbcf1badc1d8083f7ae6626a554a1b3797a1d8100105b2572	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 16:03:07.213+00	t	2026-06-10 16:03:07.214+00
de7b3c15-101c-4083-8a08-e73732cfc736	72a1798faa15ed852cdc6f7dccb609a179d6f31b5cd5fbdd653d0f31cdfa6c41	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 16:18:21.975+00	t	2026-06-10 16:18:21.976+00
9a889acd-7dd8-409e-b172-e3469dda5270	addcf478c83dc758e258f3917361babc49ed075014bc88d97ac56d9f02404b35	c4966c51-a590-485c-bf82-0d699e087ab8	2026-07-10 16:42:50.706+00	f	2026-06-10 16:42:50.707+00
2c201197-1b42-4ccc-bc7f-42407f982ed2	f6f93779bdab595d66e608e095bd50a39e16528364639e402652f42cb97840fb	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 16:25:22.27+00	t	2026-06-10 16:25:22.271+00
121e2bcd-b81d-4801-9776-b2c0a29271a2	fdc5b43908cf4055417e475eac443ce5aee125532e4032bc467a9dbe02264fdf	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 17:00:19.875+00	t	2026-06-10 17:00:19.876+00
6d7ffc51-bc88-47d2-98e2-931407ee5072	9fd492d17ce9e8313587438c8264edef839f977c3d29d82a5a91c5f07c8d99c1	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 17:16:18.882+00	t	2026-06-10 17:16:18.883+00
fd12152c-7e5f-44ee-8b95-59c674ad0d16	f9610edebac42d9c6036ba6d6570375c72ccd8f6855fc4202238a675bbceae61	c4966c51-a590-485c-bf82-0d699e087ab8	2026-07-10 17:26:30.301+00	f	2026-06-10 17:26:30.302+00
98ebb653-8d80-4a61-8954-955f1affd25a	daffe0f7ff201eacc798bd82444f7aa165fd90d92993426ea44f5bc247ec06c2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 17:24:24.509+00	t	2026-06-10 17:24:24.511+00
067b293b-306f-4690-a040-d41309e065dc	1768355cdd7216681cc1976726441c3b47cc66399ef8f48663274a544d87a31f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 17:50:09.612+00	t	2026-06-10 17:50:09.613+00
69035b0d-787f-4450-a565-02da2a66f620	b04054adb6be75e309cc1ffcfe00160b91c5dd0301d45fa030962f4130418786	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 18:05:15.362+00	t	2026-06-10 18:05:15.363+00
e9b38e47-15dc-4862-a5e2-cbc4c039c476	d7b06a603083c654c3bef2f8e5cae0d6cb10041902b819eea75c603fb31eae2f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 18:21:20.01+00	t	2026-06-10 18:21:20.011+00
14d90ddf-8f96-4539-9789-10d36a60b8a5	2b53672fd4234c5376b05e7847cf0dc696b0eae7421d237eaa1d740f22fb1f12	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 18:28:46.432+00	t	2026-06-10 18:28:46.433+00
18df7f70-38c7-4441-ab81-2973885eb78f	b43e7bc84a73b629956c262cbec1c50fd228c4366f3f562f689e0a8a5bc2705f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 17:26:40.6+00	t	2026-06-10 17:26:40.601+00
cf6b38a7-aa14-4338-b7cc-95a91290896b	1846bfff61f038f1e3c8952e882db0d42f078d91ebec8c95f7eddbdc0f7cdda7	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 17:40:16.697+00	t	2026-06-10 17:40:16.698+00
1463fa9a-847a-4a05-8248-6dc6e66d8362	7c745f81020c703f6e8c5aed61c354f7c042e834145f771665bc2fd23efb5c6c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 18:33:38.401+00	t	2026-06-10 18:33:38.402+00
10d56925-3010-4021-b346-1ca54a0ece64	5b2892f32419738718f66a4ed534c5da2c10c42a19900a669d3d0703ce8261d3	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 18:34:03.805+00	t	2026-06-10 18:34:03.805+00
673ab545-668f-4df1-83fa-72a94c53a77e	7c442f9b35071df9d675c8c4ed4b5042a12e21fa2bd620f0381eb088c49f169d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 18:49:09.536+00	t	2026-06-10 18:49:09.537+00
59ca1f01-6182-46d1-9903-1b75083de358	3f71415538f5c0b630e50638af70d3f302a46de8277df7b73fc176f8da267fb5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 18:58:04.268+00	t	2026-06-10 18:58:04.269+00
08f9a654-2356-4536-94b1-bc557590dbfe	4a1023b075a65c80bb5218e52f1887ef8c0caa2a07819e3a7d24de6350acb7b1	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 18:59:37.331+00	t	2026-06-10 18:59:37.331+00
66780c18-a48e-403e-a0d1-8c59e77ecfcb	1240eee2c32f082a3f27502b097d9a1ff4ad68ef5fa72a3973f85b76b4cbd70c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 19:00:09.863+00	t	2026-06-10 19:00:09.864+00
24195c70-f8b5-4fc0-9f55-6c2d92a1654d	43faf9def733ab6b34d125e1ec2896482d54036e99be6acda2a4ebb28053d8da	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 08:13:54.931+00	t	2026-06-11 08:13:54.933+00
627ab3f9-ff90-4ace-8bb9-75b5bc7829db	9d611a40198569bef0223444995b882ae6414c80ce08a9e6426f0537c2739e9f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 19:07:19.752+00	t	2026-06-10 19:07:19.753+00
61cd0695-e1f5-4225-8383-d8e156e1cc0c	be5a87fe7ccc04ed2dff4541336b45aa71560ce47316634ba141da61f9be7d06	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 19:07:34.639+00	t	2026-06-10 19:07:34.64+00
5709274c-e6c6-4d3d-8fc3-db12da861ddd	be105cf32201d6ba41f7e5a77ae507ecb7a55608c058f9602a44957cf1884ab0	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 19:23:19.16+00	t	2026-06-10 19:23:19.162+00
311052d8-2f56-425d-8832-9fc09d1c1729	662089e67d8f21bd1a981cb93d0050f45b2fb65b9053e8787b14acaaa26d2c0f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 19:39:16.549+00	t	2026-06-10 19:39:16.55+00
e0cbaa5f-0e77-4cff-873e-e27b65051fff	2f370c5798746ebce3b2dba61dddcf8fff0788f23e0028514791a8eb4d4931d9	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 08:09:48.269+00	t	2026-06-11 08:09:48.271+00
b26663d0-299e-42fb-b984-274a5c38bea6	61fea9822de33ed654f0e337e3eaee35873fb28273bfa43379364b8051fe4d63	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 08:25:48.827+00	t	2026-06-11 08:25:48.828+00
4f8ca962-b8f1-4f69-8c97-c0a94ef1ec3a	378da7b022af061ea5d434fa632fe62e3bfffd2e4339a650b26d78b4dd09fd7e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 08:54:32.707+00	t	2026-06-11 08:54:32.708+00
2e634048-0027-4632-8f3c-6bd6d241629b	db353770750ac2e3ecb68f97c5491cca3b45a7616ca2102a1535bb0df652ae51	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:10:28.922+00	t	2026-06-11 09:10:28.923+00
b4f571df-792d-430d-98f6-81083c89fa85	e941f7726a1dab4f5997a9c9a335f93eab2d4183afffb803fc652bb511f56d97	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:26:29.739+00	t	2026-06-11 09:26:29.74+00
eee13615-3bac-4650-b864-cfd221a03325	051c6ae0bd65aed0a5a76a7bb8e1a23a41e82141c4323f452b329c620256cc12	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 19:07:32.591+00	t	2026-06-10 19:07:32.591+00
2ae58d51-3bbb-4e8a-ab0a-cdd39ab21b6b	c56bf422250dfb0ce3720dbd444e128794c01c8a2de99741ada27a130217392a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:33:55.191+00	t	2026-06-11 09:33:55.192+00
a67e5164-9b04-47b5-94a0-f7a32f3a04fd	59b0a39e28fbc36c49df39138d0c3198a805b01794bf023727b07b82bc393cd3	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:34:12.46+00	t	2026-06-11 09:34:12.461+00
0c6c0369-16c7-43af-8709-721db0d902ce	d8226df0d5cd65c09b508e5c0aabd9d89ba962bfd8abb53c23488aca177ce9cb	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:49:20.833+00	t	2026-06-11 09:49:20.834+00
3d459822-6948-42e5-b543-727f3f15e69b	b8509363fda45d0055876330251a6c37bf9998c9777c88b1ac54b8bc77a4034a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 10:04:30.161+00	t	2026-06-11 10:04:30.162+00
399b48cd-105d-4cdd-a6f3-37cfc228b530	1833dd0f39b3314748f1e0943b829ee12b8e792332087430f755940c9d1f8d47	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 10:46:23.682+00	t	2026-06-11 10:46:23.683+00
22b58cdb-970c-4f78-85f7-17b61e9b4b26	2ccd5e5ba24950f1622ca3efee1e9d0cfb4f239d66d2390a1e81eb7b0be10c57	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 11:02:21.061+00	t	2026-06-11 11:02:21.062+00
1b190431-3501-46a8-a31a-b7bbea3ead80	e721cdc85bbc51a1819fd786c3794065b7b0160deec1e93d7ff88705ecbc509f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 11:17:55.56+00	t	2026-06-11 11:17:55.561+00
6189b08c-5087-4a07-a5f9-4e080f8bfcd6	f6f5b8dba21e12be8e79693ff120c7a4c181101d3d2ea695fe4ed0a80993dcd0	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 11:31:11.558+00	t	2026-06-11 11:31:11.559+00
507544d9-f26f-4ce9-8965-94f83174e10d	d1c2d02f119280dc2f57922a4f14581c3b7133f168275f9b13c4e6ca5978f611	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 11:41:45.95+00	t	2026-06-11 11:41:45.951+00
0db93243-9132-4de0-a3b3-a18b86c07353	984d24588350c480c6f0fe7961045fd3c66d8d67eae7c6119052a78a6e17d618	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 11:49:56.799+00	t	2026-06-11 11:49:56.8+00
d6845024-5999-4da6-a458-c3deab5ec7fe	578b3c9d45575fcc762c3763ca2191a6ac7b79751a7c990c86677351a7e5d16d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 14:49:03.442+00	t	2026-06-11 14:49:03.443+00
31f686d6-d568-4ddd-a668-0702d9e65102	eb2e8cffb6eed78ee2c9ee9c51b3e73408819879f1a56bc4024e23954bba4823	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 12:05:54.946+00	t	2026-06-11 12:05:54.947+00
38d81ec3-3e9d-4ffb-b342-b835a05f5811	2d488bd47d3073f226fad32041cd2ade7aad53c31ee380992c310cef960cc775	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 12:24:02.486+00	t	2026-06-11 12:24:02.487+00
40538e27-6941-439f-8c84-962fca2048ff	409f2a6daed9f0959cf060f882749be18d8a43453f87b2923a48c5bb7a0474eb	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 12:39:54.39+00	t	2026-06-11 12:39:54.391+00
b7ebbed9-7daf-439d-b471-25b221d93bbf	26708a93a21aa1cf2340ba3408779251dc764a169632d22d95886ed93df9087d	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 12:42:44.555+00	t	2026-06-11 12:42:44.556+00
9c8263d4-dc06-4228-b939-29719964db19	29e885c76822e1d9d26f3e7c62671bd8b48ca9776c280c02ba9d94be0eac641a	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 14:26:03.529+00	t	2026-06-11 14:26:03.531+00
db9207c5-581a-420d-b98a-9c2939d4c825	4ee597bc3bacf27aae98994c3c8283a2109b32e565d6335b166f9bcef3e7be28	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 12:24:02.185+00	t	2026-06-11 12:24:02.185+00
09a2152f-648e-4330-8c51-dc6f22fdde9e	2e2afac40455f0df708f67d5fe3439961bf3d66a0345790eb7ee3dc31f64626d	a77f02a4-a0a7-4e65-963c-1076b1981d7a	2026-07-11 14:41:22.494+00	t	2026-06-11 14:41:22.495+00
99cdfd28-ba08-47a6-bba4-f8315eb50d8f	85f9168b18e7ff0f5fa66deb6127097972f814b03f76015cffe94407ad5feb44	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 14:43:26.114+00	t	2026-06-11 14:43:26.115+00
4bd66028-68d8-4746-b3a1-e489298ccd54	646ea7a99a5f0fc2fec0317ea27e6333241ab4d80d9c8a3577cfd036ca336ef6	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 14:47:45.446+00	t	2026-06-11 14:47:45.447+00
cd7d6f9a-db98-4d39-bb02-e9f7774a174c	ca4eed79ddf935d8838e3b2749eed10cbd8f29eb9202c4af0f5c1d120086ed6c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-10 19:31:15.546+00	t	2026-06-10 19:31:15.547+00
5e72c67d-5328-41e7-86ba-e4a96e95bd84	d8c02602066e64adf36b178d5e7251c1d4d76b53d36c8f9781c2b85b5b60d69b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 08:14:34.091+00	t	2026-06-11 08:14:34.092+00
bd7ad91f-21a2-4d9e-977c-7c36051a4049	2e2ced5375769be0c266db9e1ab0ce2198dfc504d194bb74f1459eb2d7d2aead	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:11:03.878+00	t	2026-06-11 09:11:03.88+00
59487ce8-be65-423c-9bd7-2bf3b11ba715	214032a35bae877ce83b50ba64a7bdfe188bd26623917d0f5320d2d7fcb00851	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:11:43.055+00	t	2026-06-11 09:11:43.056+00
e2e8be74-aa37-48cc-af44-a1109ccfc7e1	5d3ff0f6966019cc4a5a2f0a82c656520fbc50e9006396006fc8720521012f50	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:20:28.325+00	t	2026-06-11 09:20:28.326+00
17cb66c9-0060-4255-a048-8b12cf786c11	2cd95e1cb92314feb7478a42b3a83a3af2149ef12182bb5afec07c3ff94d2f9d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 09:41:31.762+00	t	2026-06-11 09:41:31.763+00
adbe2af0-33cf-476b-a021-53410be09915	b5eb125f8a1986cd7e171df534e4ed5193e9bcd796cd32d670eb61ad010f51cf	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 11:33:54.725+00	t	2026-06-11 11:33:54.726+00
0047393c-d415-4647-9e61-887acfa8bb0c	046f8e618a2edef5c76e99f86ac562924759a04b0ab5dee91a73008492653772	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 14:47:54.683+00	t	2026-06-11 14:47:54.683+00
063239d0-0b3c-4a05-b334-d3b589adad44	0f482be89b135ddebf9b61f1d5253fecce4fb76077a2becc56f43fd7bb06bf6e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 14:49:09.249+00	t	2026-06-11 14:49:09.25+00
76690327-e5ba-4807-9fc4-a2e797af2d06	9fe675728e37f14c28a8e8aef8210be810bb3cb5a5660b9994beb427d8be46ba	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 14:54:51.646+00	t	2026-06-11 14:54:51.647+00
5f0d49b1-ef15-40f8-b1fa-be2465957fbc	0ebd05129fef07db84a313ca056448552390b5bdc2ba7330e15dfdbddb0f5f9b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 14:55:01.252+00	t	2026-06-11 14:55:01.253+00
1419ab67-bcc8-4cb1-ab1d-2e74ddefdb58	6218400f7ae66458690276f748ca7ea49dad9ba9a03235bf37af69342336d187	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:07:55.62+00	t	2026-06-11 16:07:55.621+00
41a3194c-fee2-4a90-b1ef-ac25ee27066a	831e372cbdf3b00fdc14e9b789bc70dfc9eef378e9099f6aa6b180ddaa2b6f11	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:13:31.242+00	t	2026-06-11 16:13:31.243+00
a9f29892-340c-4e2b-a946-4188be35298c	1e3bacaf75ce5b73c05a62e6abd814c42b298bdd9e11125df999ecaa6c91bcf4	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:20:32.896+00	t	2026-06-11 16:20:32.898+00
50474281-77ff-486f-82b2-bfee7a65654f	9f067d95504acc75f81937f2bbe69c17b8815206d24f4ea176311b589adbb446	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 14:50:06.929+00	t	2026-06-11 14:50:06.93+00
9447ccd6-0e1b-44f7-9c87-3ed8997ca6b7	aaf4888eaab36ad5e0b4b04a7461c18823f8e92f7ea8cad3636fcc7a8222dbc4	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:14:35.985+00	t	2026-06-11 16:14:35.986+00
ab2219e3-c007-452b-8597-1205dfc29605	cbac0f135d319e7ff40951d3edd44c6ffac52a232e42001303373915f673a25c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:15:13.22+00	t	2026-06-11 16:15:13.221+00
a9296d3f-bf33-409e-9532-7c3d6f97d0d4	cb540efea1662c5542294585a3cc23c2c93c989d4a063861a1bedfab369e5cb4	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:15:30.21+00	t	2026-06-11 16:15:30.21+00
8d02146c-3f8b-4be6-b277-a91235532187	91efcb2724961715bf3247a70606dc217a583cb1522ca52e96d6aa5a317fd8b8	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:20:45.576+00	t	2026-06-11 16:20:45.577+00
04890ff5-27b7-4828-883a-c1d146acb94a	bb0ef7de20a69a854f47489188cc84fb7cb54ab534d029504457e6fe805dfd3e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:21:08.73+00	t	2026-06-11 16:21:08.73+00
5301ed56-1c9f-434f-aeb5-c248a234d41d	243b116827c5ba313a8478f2f5e16459d1f39ad06aeb24f1e21d62ce2dbf46d7	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:24:04.52+00	t	2026-06-11 16:24:04.522+00
3f939c50-94f3-4ea4-941c-597879883322	8c7a0ae5c6d51159a5762a9b04a7a39c3e84abd01eed4f55cd9e5040b738546b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:31:55.202+00	t	2026-06-11 16:31:55.203+00
b7ca7241-5efc-4400-b238-46016e46a9d4	97ae60eb462da6d6eac2a7a2627bd077408f72fd038936c66148820563712ae1	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:36:38.209+00	t	2026-06-11 16:36:38.21+00
a6c46cf1-e7d2-4931-a511-366a6d7ca569	49b6ef7d6115f0bf1e0ebb78556d6e30f0ae9933bef310a8d553fd5b409471ef	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 17:27:02.983+00	t	2026-06-11 17:27:02.984+00
32c5e4fc-d423-404b-aa50-04872c54cb3e	184b782b3697fc8f1c737e0ab95f1fec79d6943b8e941514ae437fde6d348da0	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:11:07.654+00	t	2026-06-11 18:11:07.655+00
7b42a062-c7dc-4a8f-96dd-227f6de0bb9f	cece0556a74a5b169f172bd353c74e947088448a78950248f23cca58c215132e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:13:40.158+00	t	2026-06-11 18:13:40.159+00
c9671444-af90-4941-b33c-f284054f4c81	4a8a4438bcd71193b57f758db2130ca0e532f8f533cbfcc12a1e34abc9fa0cde	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:12:43.894+00	t	2026-06-11 18:12:43.895+00
ddc17a22-407e-4ed4-b9bc-74530abca405	ce60ec47b22f613d8d847790b52877af22bcd2098ef1c4e15dd185ed921f0c1b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:13:42.787+00	t	2026-06-11 18:13:42.788+00
3ee28bed-a636-41df-85b2-de608d3b8110	03f2225220563b17d524bff764e77b5c81101630e2e86463fc2c600e1c9f713f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:13:24.941+00	t	2026-06-11 18:13:24.942+00
0090285a-8bee-4202-901f-1cb6a9b880bb	61354ff84a362ffc11b1c4e450ff65182d12834cb22780af18f86ffd97616cb1	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:22:11.81+00	t	2026-06-11 16:22:11.811+00
f716b9e3-27de-4960-b732-57695acedd0a	1f03993e5fa64e546cae29c7af649742b6ad01e01378d6f15e4ec5b8e91a453f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 16:28:09.624+00	t	2026-06-11 16:28:09.625+00
95ed7e7b-a70a-4503-bf02-884732dcad99	875b6bc89842728b789224f6f84d695293440f1a8a3b8ba093facf91be331816	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:13:24.632+00	t	2026-06-11 18:13:24.632+00
71fa80d8-4e09-4f89-9909-3a006338f269	740f0ad5921c4ed73f5824398e6028a6086e0919d0e1d1068cdff4ea9dc43fc5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:13:38.405+00	t	2026-06-11 18:13:38.406+00
3a44d7fe-7c00-4256-8809-2c1fa7486768	3826450e5f67088567e5f4b8920491429030fd40baa935f7a6b7ad4a45a9012a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:16:31.849+00	t	2026-06-11 18:16:31.85+00
a1db31ab-172b-4b13-95ed-8e18122405bd	829b9104d5243e5dafd4a97032ee6b18f5b9a0af0427b973174c6650a718fa7d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:16:41.559+00	t	2026-06-11 18:16:41.56+00
0a4caf29-4756-4a98-8947-3627a2856a17	423dce13da20c654993d9908bf1630fecc06c69bf5d6db6a21830ec676f2ff80	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:19:30.416+00	t	2026-06-11 18:19:30.417+00
57c7647d-fc2e-4c04-a248-bf7e93b72ba3	14cd1510eea9bd09202c4c80bf52d0d1bfca825d7762388779c1a74bf4b716e8	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:19:37.611+00	t	2026-06-11 18:19:37.611+00
875b2de3-96c7-4099-95ba-0e1c61a14dca	01c1dfeb8cdb4f0e84570223331e8e1a6b9d202ef1f1aa47409cab68e8f7175b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:20:55.616+00	t	2026-06-11 18:20:55.617+00
5d45477b-d8eb-4f4e-b82d-9c8fa9504afd	7824fd106e014027126ed0fb2971ae296294cc6c29511e7e9ea0e699e656fe73	377b4aad-d563-49a6-88f7-78560490e3d0	2026-07-11 18:23:34.371+00	f	2026-06-11 18:23:34.374+00
ebe09e91-3132-487a-8ebf-2e6b7e8cd3f1	97ca4ca8978d661b2204baa9d039aa946ba34f3054481ac21bf6f9d36f47ab48	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:21:40.631+00	t	2026-06-11 18:21:40.632+00
fa199234-1df7-46ac-9a6a-c89dc2966917	81b1783f4c6dffc2fb3d69db9a941f25746c37a655bb9fa4f958f3b9557de175	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:24:17.027+00	t	2026-06-11 18:24:17.028+00
accc4472-8079-42f5-a55d-ff9f1c454039	47b8cd11d25336203068c03003d1e139cd089462ff36059f6c79e90568ca4989	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:24:24.522+00	t	2026-06-11 18:24:24.523+00
df3bb8cb-9187-40d2-a15f-6326bb079503	d39368eb2f502e99e847b97de1cebe50aea301413b2b08ad56ff1225eaa1a70c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:24:49.782+00	t	2026-06-11 18:24:49.783+00
d3b13372-0813-4a66-864e-9b9ce1b1ce24	05d66152d7d9eea86abc90becda79a7c2f31829b28ace1f777ec8174deecd5a5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:25:31.001+00	t	2026-06-11 18:25:31.002+00
e0fa7414-7d1a-4c30-9a74-f8d4d0d32fa8	427cb54dc48e56b1c826b73cae2c3210ed7f159fcd2a60f9acca8460ee1a0578	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:27:03.406+00	t	2026-06-11 18:27:03.407+00
4046f1b0-2c9b-47d9-a2ab-19c9b9b1e12a	932405314c44f73ea42cad3c409d0a6326598f26f8320765d67e03c16f236a13	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:34:48.884+00	t	2026-06-11 18:34:48.885+00
188796db-b9df-4070-8af2-c2b53da1edf4	7b24595862e5cc867cd2e8c121444b2833c06621a63a301c9bc5cba69555f0d9	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:51:33.465+00	f	2026-06-11 18:51:33.466+00
cec2c362-0911-4518-b240-f5eb322accb1	ce09de9feb74d050b5ea42a419aa56fe1c0e7273a125cccf628bc2296864db3e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:49:26.016+00	t	2026-06-11 18:49:26.017+00
2e84191b-331d-4eba-bf5d-2fa978ae90c6	8c58858f36ef1a976cd2bc3815688e75b479c2b5462f01e90924fd9bd53ab08e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 19:04:07.817+00	f	2026-06-11 19:04:07.818+00
3e0046b2-2461-4764-bc9a-c96516625146	99b4409bbc10cfe684476322fbaf2f83c1907461a73f2b34bbd34ff61896c91a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 19:04:58.306+00	f	2026-06-11 19:04:58.307+00
46f7ec93-6ed6-4b81-a4c2-d39c8db609d0	640885ae6f3242123d321d8b68a0db2c93061c793be5737d7dd1cdffa3179abc	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 18:55:47.053+00	t	2026-06-11 18:55:47.054+00
b815dbc1-bace-4f69-a9aa-67039d868691	d09caf503c1fa88775bdda49e4822a89f82c3266a09c035285ff6ecee59a7588	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 19:06:42.392+00	f	2026-06-11 19:06:42.393+00
610676b1-c76f-48e5-ad2c-5af411eb6faf	2aa7bb154a7688a9f5b7c8e19e70500a249a5816be7837bb3dcc3c8586f629b5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 19:34:45.485+00	f	2026-06-11 19:34:45.486+00
bf4ae631-8a93-4984-8e40-5a7a07e2a001	3f66b481e970a0eda016fb16bb03bb737227fbbfe9d541212e041733dba5ccad	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 19:59:46.522+00	f	2026-06-11 19:59:46.523+00
c9b4320c-11d4-4db6-b161-6b725f58d2a0	29400af703f4350d84a3d620fd4844a487b8375c428dd923522a4c132f277714	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:01:13.381+00	t	2026-06-11 20:01:13.382+00
49b6d65b-878c-4ae7-ab11-228d0b98085e	2cb4bd16d1a1110884600eee56d4b0801a6bf65a846935c144dea2e99258512a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:01:17.973+00	t	2026-06-11 20:01:17.974+00
e1b643b8-f155-4cb9-b408-5d185aad1b60	c0b3b0dac0544456b1376aa90435fa3936e0662bac4458b3778a3978f325e9b5	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:01:32.565+00	t	2026-06-11 20:01:32.566+00
1582f9e5-df25-4f40-8a58-aabd7b81f9d9	d54b13a97d3203414e375895dc639c5aa378eabe5ea3b8260c491ae2122b402b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:07:52.538+00	t	2026-06-11 20:07:52.539+00
65ca7d0b-ff32-4ce2-aec6-22880f38a4d1	42b3edd53a6a84b204eeee60894b66d5000c4d97f79dfb9dcf73b73dbb074f9a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:01:42.053+00	t	2026-06-11 20:01:42.055+00
538c7613-ffb3-4f70-b0ce-81712abed075	77b20aa65861c52d2eea539e79367469bd4ea154b256add2a71b9690cb6108a6	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:07:56.595+00	t	2026-06-11 20:07:56.596+00
fb299b31-46f4-4083-a187-36be06f3a900	f74c57a67ac7833465d8260ff639457c7e5adfe9bbef578ebd86c8f4d946aa94	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:09:34.316+00	t	2026-06-11 20:09:34.317+00
1576a3a3-fd49-49dc-8d3a-e09d5c73723b	b41b8b323cb6f78010d37388a848f1ebba700164c3dfb71a2c4d6875f500609e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:12:51.477+00	t	2026-06-11 20:12:51.477+00
cfe16003-3c37-4035-8f42-4e287928ba1c	c98f8d5fdb25ec504366d7de2f7377fe3f7c9520d4f1cdaa2d64ca3138bb3808	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:13:52.454+00	t	2026-06-11 20:13:52.455+00
b7785819-a99b-4bc4-8d92-d91e4eede26f	e0395bcc5e67d9df41d38cfc775340a6b5ac31e9380de6a53dc9da93e1e089b7	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:08:25.307+00	t	2026-06-11 20:08:25.308+00
3cbfc86c-f186-4535-85e9-4531ed852e3f	75d4cd52286bce31a46f65f22175b4cc6f74d5cdda3b16a6c6a0e303d94b7e4c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:11:05.197+00	t	2026-06-11 20:11:05.198+00
81d78f57-8ab5-471d-ab52-5937778d4398	d6857fde6b3120392eac7e5e2b847a32dba68f5eadc06c305fa3798426506bb2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:11:43.475+00	t	2026-06-11 20:11:43.475+00
88a3b13f-a522-4690-a583-646ea750852e	431bfa6cb92e3697c95af4bf5b8b7994c546878a7bf52a863b9846294ddaff91	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:15:00.941+00	t	2026-06-11 20:15:00.941+00
284fc2d9-be7e-43f9-aefc-a1413355aae5	96222c558db751011651551ea5399ce9ee18de88b66ccbff030fa8dc20faa0b2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:16:30.39+00	t	2026-06-11 20:16:30.391+00
c2db3114-f7a2-4e6f-88de-a26f519be3e9	fd0e818a4a0607d6f93d3b482bea9387f944e9ee1f1b03896d1748afcb68a7ce	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:16:41.218+00	t	2026-06-11 20:16:41.219+00
8ee4d783-60f3-4163-8d1d-010b0257533a	1c555312a9bd50143243c1fd56acbd2855d1b858be3a6e4429417838b5070791	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:16:59.546+00	t	2026-06-11 20:16:59.546+00
c104df0d-720d-47eb-a035-43f26ef87d75	82d40bc1abf8ae2b9b5609fda723562c1147e367449db62a6226dc521133c266	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:37:18.308+00	t	2026-06-12 00:37:18.309+00
bd0c659e-8732-434d-ab81-281d1ccc608f	a682ced9ae8bf030f34b32bb4632228156b19da1988fa9e533aeb951ac3acd11	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:37:22.431+00	t	2026-06-12 00:37:22.432+00
abdc4910-9450-4488-bb9c-dc5ee2bb2103	08c70fc76598cdb84a7dabb4a74dbaa738b0a739d0fed599e313ff4991f58788	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:38:29.24+00	t	2026-06-12 00:38:29.241+00
cff63445-91c2-4589-93eb-9a2aacb179af	026b8cf6567127dc2b023acbb59964a32a332e1e79f390a582a8124e3d1380ee	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:39:59.806+00	t	2026-06-12 00:39:59.807+00
ed34d978-7150-461a-89bc-1ab0648b02e2	01fcd9de0ba72c4a7dda9fa3bad9017a833a6aaed6e8d80165e385a693a31c60	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:41:30.015+00	t	2026-06-12 00:41:30.016+00
5b4025e0-a439-477f-b6cf-7dd4e6d1f84e	0c1d01f4141eaffd254b38d78b262349e5de7dee25cb27d2fdf49ec410ef507a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:43:01.234+00	t	2026-06-12 00:43:01.235+00
9953db03-2d47-4a8e-853b-5b813fda88d6	70518834e2809ffa3113f0016cb49e8c03cdb532fe6066bf5c81c1b0632a30c2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:44:51.653+00	t	2026-06-12 00:44:51.654+00
8c26e73a-c946-452f-bb20-28bf9f6e4792	29fbd50fb6a7aace9d3006d56d7b9b63bc905f6ef8d5a39f5fade603cdc8d429	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:46:52.133+00	t	2026-06-12 00:46:52.133+00
a967447a-3dce-4a52-a2c4-1c5d9f888823	590d751491b00a901fa3f5c2afdf08dd7bc5dfcf6fb0afa8d0b7547a617e768e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 00:53:01.187+00	t	2026-06-12 00:53:01.187+00
8f086978-e7b6-4236-adde-30b0a93f7cfb	5d3e10326d239403af267e8cf82f5959d24d82a84f5625259c7d88eaf6ffc72d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 01:03:31.522+00	t	2026-06-12 01:03:31.523+00
95187d46-f0a7-456b-9e61-4f8131a78622	eb1479b867a2539680e8adac21a187510db0956bf5bb263e6e346610aaf57e17	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 01:04:38.089+00	t	2026-06-12 01:04:38.09+00
6b9cabc0-dc92-411e-8045-ac662dbba068	17b28027b794550c059001573d304604db1743c9d54d6abded172d85b4ea41d6	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 01:11:07.908+00	t	2026-06-12 01:11:07.909+00
aeb4dff5-f6af-46d6-9a38-1c543a070363	3c4be56a2ba88d965cefde941bbd21b7777b92d7bc6cd993b4b6c1527106e73b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 01:11:39.413+00	t	2026-06-12 01:11:39.414+00
5bda5341-4750-41ad-bec2-ac39c2598499	a31a71fe908d417caa262cf8fa53f3a1a07ac4242dcb8421927fb6fc41cf1a84	eb230de5-9f9b-4830-9b4d-4a75bc64eff2	2026-07-12 01:12:52.855+00	t	2026-06-12 01:12:52.856+00
cc166244-b7fa-468d-8e00-371103e69d23	a18ad2ce09ee6cdb4f59d25189791706d3d83434cdc73374462f9162f4392d5d	eb230de5-9f9b-4830-9b4d-4a75bc64eff2	2026-07-12 01:12:56.761+00	f	2026-06-12 01:12:56.762+00
0a535a61-8849-4283-8da7-71e15298a756	5b2657c89f34835fa6d519f752abb49add5c23ba30dc4a38fdb6954239a2340e	77547d68-225e-4f72-8ed1-2f35354529d6	2026-07-12 01:13:23.633+00	f	2026-06-12 01:13:23.634+00
4a64a9b1-7fe8-4bf3-9b8d-c60911cd1510	d67d53d93f8b24e9db4c73ad18cdc311d2d7dbdc3fe36a1ad18a1cd3962bb2f2	962cfc17-a6b2-4fda-b823-64e5ad7ea261	2026-07-12 01:14:10.332+00	f	2026-06-12 01:14:10.333+00
ccdc544f-1970-4f1c-b49f-5649995abc3d	4fac7545fcd4a9cf070e7d343668e917d74586e98b445ff3b28326252286c184	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-11 20:17:06.149+00	t	2026-06-11 20:17:06.149+00
f9b96f90-9138-49ce-a9a9-49aa4350fdfe	6effc71c1fb14c45a09e1c71db6f22cc3d2903a93fcd3a2cb3d603732f8d215e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 06:56:51.069+00	t	2026-06-12 06:56:51.07+00
5cf7751a-5c8d-4058-a903-e7fd3c5b5979	8eeaef929631d38692cf179b1d53c47040a154de61f8eca73c38fe82dc2097b8	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 06:57:58.91+00	t	2026-06-12 06:57:58.911+00
117bff9a-3f3b-40a8-8b7a-654ccfba7bb6	bfb22e1a1a279d9f9de8fc5e165f5ba23fed6da3c593ab83168ba27cf0ae6d0e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 06:59:29.031+00	t	2026-06-12 06:59:29.031+00
56490904-2093-4ec9-93e1-792e8868a1a4	95e29a77ccac50fedc00fe2e3d37ae51fb3dae22a0f99aed757d769e7dbcb5bc	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:00:48.022+00	t	2026-06-12 07:00:48.023+00
e56c1a6c-117c-411c-b596-e718c2bfc95d	9dde0725baf7361965fa1fa4a270dd9e213e6cb238007dcb1ec2fb77d16aa427	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:01:26.464+00	t	2026-06-12 07:01:26.467+00
54582bb1-f4c2-4706-8abf-5ebca5227253	1e149c7c49fd7bc4d1981876053f0ed9370f94884b75dbfdcd8fcea6293be0bd	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:04:13.527+00	t	2026-06-12 07:04:13.528+00
9c82b3d4-0de5-46f6-a67a-ff91b11dfa9d	0d48a754a8e25578641804b2dcf63b1d61cba9c2d1d7f7c9b0faa01c422f71cb	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:08:33.383+00	t	2026-06-12 07:08:33.384+00
7fff91f8-54db-4662-8d7c-67e5726bb46f	ed1334ec67370bb9ea12399df8b39d57a9cb0b26290533a37ac9f286186e3c20	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:09:34.209+00	t	2026-06-12 07:09:34.21+00
a572baa6-ed2f-401f-91b1-e041b000cb56	aff36daa6703b933816e0a6fa36834b37f735b1a0b8a98ec0274d5e2da9bad87	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:49:39.005+00	t	2026-06-12 07:49:39.006+00
67fedc61-6ff5-4c07-b9ed-26aaea694e11	2bed81ce09583cb0dbf7eeffb566aaa1e3592dd9e3033d431816717e69b0634f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:49:43.572+00	t	2026-06-12 07:49:43.573+00
7253100e-e2b1-4430-a348-ac07a93f7c1d	7be1b815d606a31689cc0af8460ba83742c34910e6afefa561d32267ed3f6613	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:11:15.679+00	t	2026-06-12 07:11:15.68+00
08fcdd4a-8810-4e54-a478-5996062fa82b	9a10a6aa2ddddbfd173ab632510483af01917b5f4b6526f674bb84cf628546ab	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:54:51.628+00	t	2026-06-12 07:54:51.629+00
2cf6cd42-dd33-4ba4-8007-dce07768be3b	da8c6cda8f1040057bcbaf5c0f92af7532d877865922fdc69a29099f9ef0ad74	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:26:47.345+00	t	2026-06-12 07:26:47.347+00
d487951e-e1fa-4400-8ade-bbeb95919f58	a751c7947eb50098fc687e36844855720372aa7619bad5d7cd8fbc65286585ef	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 07:41:55.502+00	t	2026-06-12 07:41:55.503+00
cefd1168-7b79-4f02-8469-e3e496545889	947d2446081df7c7ee1a6200f68c415e72bcb83fe6e0a89c3337147acf652f0d	8122bc15-ff15-44f4-8751-0bdc6c3f3386	2026-07-12 07:47:14.922+00	t	2026-06-12 07:47:14.923+00
2032f880-5687-45ef-ab2a-508b4619350e	db45883260c27e427fd9db8891ff6d9807acd3734a18ddea2db3ca21779f273f	8122bc15-ff15-44f4-8751-0bdc6c3f3386	2026-07-12 07:47:20.041+00	t	2026-06-12 07:47:20.042+00
befa4347-6f09-42dc-8091-b2d6f51b315f	3ab2c15439afb910cadf115815136d3966d96f1c97a171f18f4239bfaa4ec9ca	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 08:10:50.074+00	t	2026-06-12 08:10:50.075+00
33142bf6-248e-47a8-8eba-f047f2e793a5	d4bb28934e719a90cc262b49e8a96857ef985ce236da2d8955ab0e8711b09511	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 08:14:35.892+00	t	2026-06-12 08:14:35.893+00
4cb7cf8e-cbba-401a-9db3-d1b3fa970a01	7c544f690541263cf1485cf383ef87d0621d0d61595bde93e272d1ae3a4c964a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 08:29:43.81+00	t	2026-06-12 08:29:43.811+00
b2efab8b-4f45-46dc-a00b-3049d93487e9	7f8d8fef9e2a351d11870b0d4d5c34fc609b097a3b8b5dc6e1380762bcaf8726	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 09:24:15.421+00	t	2026-06-12 09:24:15.423+00
424034c5-223c-4540-892e-3128872e6b75	19ba338966d38debf1897e93e7cfcf70379c514028cee4f35a63f926e34f0f91	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 09:49:48.023+00	t	2026-06-12 09:49:48.025+00
a7933ad5-241c-448b-a9aa-0eef56a788fa	6295f48f58879da3c0be86a29321bd8fb7f87ac674b6271766eabb4ead7cb240	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 09:39:20.187+00	t	2026-06-12 09:39:20.188+00
d58589c1-b6b9-490c-b4bb-6102cdce52c2	a8883cc9e4d452fc3952e6664dfc8d3edf2f8ca5060de20a4db1816efe57fcb6	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 09:49:52.282+00	t	2026-06-12 09:49:52.282+00
38da5fb1-1366-4a70-85c7-97735ce3327f	b21f87e40898b076ebcfa5fbbee1a5f3a7864086628d816486c43504e178e445	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 09:55:20.755+00	t	2026-06-12 09:55:20.755+00
4633af2e-ae16-4e0c-80e9-b4ed92ffdf59	1a27e992922bee498ee9b00f9833b93899967f32d9a1d6e174400a1ce7689597	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 10:05:56.762+00	t	2026-06-12 10:05:56.763+00
7fb6068a-15d2-406f-8b14-81d655bbc976	9ecf615eb55f55bd26dd45c474a4371adaa145450f87bba36f321496747109a6	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 10:08:15.899+00	t	2026-06-12 10:08:15.9+00
e450d8bc-c7d4-4084-beb6-046f8d3795ea	dec46be4156504a4cf42884959fc4dd6bb26c6ebfb852894cabaa7a00b5c5b8b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 10:10:15.913+00	t	2026-06-12 10:10:15.913+00
2ced6ebb-d529-419f-a323-6cba439acaf8	bd47147a5673d73025b7e69e71d148a753fd7365af3d3bf1e2461220199d908e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 10:22:56.946+00	f	2026-06-12 10:22:56.947+00
83d57450-1540-4451-ae1e-95cf7dd10ccc	c5a211acbf3233470969043baccd7af43bb8b7efe0a25e5aedab02a6a1155518	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 10:21:14.626+00	t	2026-06-12 10:21:14.627+00
577e5856-4c8f-43c0-8901-1daa825a5589	3269ba9042896a6a723e1f5903246b27756597861470f16b0726f31a4b06e149	b7f6902d-d0fe-4c69-ac1f-51faf9245226	2026-07-12 10:36:56.756+00	f	2026-06-12 10:36:56.757+00
\.


--
-- TOC entry 4718 (class 0 OID 27084)
-- Dependencies: 419
-- Data for Name: reminders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reminders (id, user_id, program_id, program_name, renewal_date, reminder_date, dismissed, created_at) FROM stdin;
\.


--
-- TOC entry 4701 (class 0 OID 26913)
-- Dependencies: 402
-- Data for Name: results; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.results (id, user_id, program_id, status, confidence_score, reasoning, checked_at, org_id, match_type, eligibility, estimated_benefit, match_reason, ai_rank, reasons, program_code, created_at) FROM stdin;
fb0b8708-9cf9-46f2-9b49-8f310cde24db	55b28a2d-ac96-4dff-b111-ca4338daebb0	snap	not_qualified	15	Income exceeds the low threshold for this household size.	2026-05-30 12:55:40.637	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:40.637+00
6f900feb-4dc4-4fc0-b480-88a3bbbde32d	55b28a2d-ac96-4dff-b111-ca4338daebb0	wic	qualified	100	Income qualifies at moderate threshold (100% of limit). Has child(ren) under age 5.	2026-05-30 12:55:41.645	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:41.645+00
6a082bf9-eaed-4002-adc4-f0d0a9915ec4	55b28a2d-ac96-4dff-b111-ca4338daebb0	medicaid	not_qualified	15	Income exceeds the low threshold for this household size.	2026-05-30 12:55:42.643	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:42.643+00
a7354dc0-50d9-4f24-a3d3-6ebec9213b40	55b28a2d-ac96-4dff-b111-ca4338daebb0	ccdf	qualified	100	Income qualifies at moderate threshold (100% of limit). Household includes dependent children. Meets employment or education requirements.	2026-05-30 12:55:43.645	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:43.645+00
39d5fc60-59b7-4f5b-8cff-9ab246722477	55b28a2d-ac96-4dff-b111-ca4338daebb0	section8	not_qualified	15	Income exceeds the very_low threshold for this household size.	2026-05-30 12:55:44.643	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:44.643+00
82b1d7dd-2db3-48cc-8fc5-cc6466c2334b	55b28a2d-ac96-4dff-b111-ca4338daebb0	liheap	not_qualified	15	Income exceeds the low threshold for this household size.	2026-05-30 12:55:45.643	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:45.643+00
e6989101-b392-4cdf-a56d-e850986c9517	55b28a2d-ac96-4dff-b111-ca4338daebb0	eitc	likely_qualified	75	Income qualifies at moderate threshold (100% of limit).	2026-05-30 12:55:46.645	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:46.645+00
06dfbc6f-ce72-4c19-879c-c83dfd804751	55b28a2d-ac96-4dff-b111-ca4338daebb0	child_tax_credit	qualified	100	Income qualifies at high threshold (50% of limit). Has 1 child(ren) within age limit (≤17).	2026-05-30 12:55:47.643	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:47.643+00
7141c84d-8efb-4f34-9852-fbfaf3ec4b96	55b28a2d-ac96-4dff-b111-ca4338daebb0	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (100% of limit).	2026-05-30 12:55:48.645	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:48.645+00
fbb2e0f8-c0e2-470e-ae92-464e6c7e6f8b	55b28a2d-ac96-4dff-b111-ca4338daebb0	head_start	check_required	40	Income exceeds the low threshold for this household size. Has 1 child(ren) within age limit (≤5).	2026-05-30 12:55:49.643	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:49.643+00
20adec1d-5b21-4ff0-8b9d-845f98865bf8	55b28a2d-ac96-4dff-b111-ca4338daebb0	lifeline	not_qualified	15	Income exceeds the low threshold for this household size.	2026-05-30 12:55:50.843	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:50.843+00
33592cfc-bed7-451b-ab48-a81bf92f7e3a	55b28a2d-ac96-4dff-b111-ca4338daebb0	tanf	not_qualified	30	Income exceeds the low threshold for this household size. Household includes dependent children.	2026-05-30 12:55:53.027	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:53.027+00
b49a91d7-2877-4eff-9fa1-a38fccb583af	55b28a2d-ac96-4dff-b111-ca4338daebb0	legal_aid	not_qualified	15	Income exceeds the low threshold for this household size.	2026-05-30 12:55:54.017	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-30 12:55:54.017+00
d799118f-63df-4499-ae45-3752f4790872	b2fde45d-108b-400a-9b65-e42184ed68a2	medicaid	likely_qualified	75	Income qualifies at low threshold (47% of limit).	2026-06-08 14:22:22.099	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.099+00
8af6579d-b867-47bb-b6a4-51735b016dca	d63c70ab-4901-4a3b-86db-91f1b21d942e	snap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 13:55:55.579	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:55:55.579+00
366806ae-8797-40de-9a06-7e1f16956d79	d63c70ab-4901-4a3b-86db-91f1b21d942e	wic	not_qualified	20	Income qualifies at moderate threshold (0% of limit). Program requires pregnancy or children under 5.	2026-05-31 13:55:56.632	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:55:56.632+00
e7135ac8-072d-440c-b757-7a828c76a2ba	d63c70ab-4901-4a3b-86db-91f1b21d942e	medicaid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 13:55:57.682	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:55:57.682+00
b22da16f-62a3-431b-aa10-ea553b4b5562	d63c70ab-4901-4a3b-86db-91f1b21d942e	ccdf	check_required	45	Income qualifies at moderate threshold (0% of limit). Program requires at least one child in the household. Meets employment or education requirements.	2026-05-31 13:55:58.733	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:55:58.733+00
de8cba32-4338-4520-95c8-cd8f16c9250f	d63c70ab-4901-4a3b-86db-91f1b21d942e	section8	likely_qualified	75	Income qualifies at very_low threshold (0% of limit).	2026-05-31 13:55:59.784	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:55:59.784+00
32a31934-ac19-4a7e-9836-04d93529a092	d63c70ab-4901-4a3b-86db-91f1b21d942e	liheap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 13:56:00.835	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:56:00.835+00
06eb15e9-3ed5-47c0-b8dd-49a50ba0ce12	d63c70ab-4901-4a3b-86db-91f1b21d942e	eitc	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-05-31 13:56:01.886	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:56:01.886+00
a83a0c19-583a-4397-86f8-9e1b0d463ba2	d63c70ab-4901-4a3b-86db-91f1b21d942e	child_tax_credit	not_qualified	30	Income qualifies at high threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 13:56:02.938	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:56:02.938+00
cc2d0439-1c4c-4c2e-b10a-a10b3409e5cc	d63c70ab-4901-4a3b-86db-91f1b21d942e	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-05-31 13:56:03.988	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:56:03.988+00
264dc5d9-eb16-413a-becd-bf84eb011a38	d63c70ab-4901-4a3b-86db-91f1b21d942e	head_start	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 13:56:05.249	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:56:05.249+00
46c3de2f-2dc8-4bb6-be50-b25d68f7f290	d63c70ab-4901-4a3b-86db-91f1b21d942e	lifeline	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 13:56:06.302	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:56:06.302+00
79208e3c-25e8-405b-ba17-1af887307313	d63c70ab-4901-4a3b-86db-91f1b21d942e	tanf	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 13:56:07.353	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:56:07.353+00
e00607c4-6652-4a78-8516-95dbb04fe417	d63c70ab-4901-4a3b-86db-91f1b21d942e	legal_aid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 13:56:08.402	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 13:56:08.402+00
1cb81d3a-3cef-4fe0-b171-77846fc006a9	af514448-9bd8-4a42-a2d5-770c24084e9f	snap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 14:15:05.473	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:05.473+00
0e3b7225-8729-48e3-8bd1-c73c7f69cf0d	10648b38-417c-4511-8d34-d6021f19d2c2	lifeline	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 11:25:36.927	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:36.927+00
4c3a0e23-b03d-414f-9dcb-c3752d04c060	10648b38-417c-4511-8d34-d6021f19d2c2	head_start	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 11:25:35.877	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:35.877+00
51ce9793-ca2c-46c5-acf0-c2390dd65e71	10648b38-417c-4511-8d34-d6021f19d2c2	tanf	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 11:25:37.977	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:37.977+00
cc896a2f-a1c8-4ba4-b8d6-35faf1aca4d1	10648b38-417c-4511-8d34-d6021f19d2c2	legal_aid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 11:25:39.028	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:39.028+00
7b4f7f5a-cfd3-4c73-8273-a4fead2a3a22	af514448-9bd8-4a42-a2d5-770c24084e9f	wic	not_qualified	20	Income qualifies at moderate threshold (0% of limit). Program requires pregnancy or children under 5.	2026-05-31 14:15:06.519	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:06.519+00
71d13c88-ad3a-49c8-aaaf-5de21b55ada8	af514448-9bd8-4a42-a2d5-770c24084e9f	medicaid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 14:15:07.566	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:07.566+00
47d4ad14-4711-4a0c-b174-ff5ae87a82ed	af514448-9bd8-4a42-a2d5-770c24084e9f	ccdf	check_required	45	Income qualifies at moderate threshold (0% of limit). Program requires at least one child in the household. Meets employment or education requirements.	2026-05-31 14:15:08.606	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:08.606+00
c64e51e4-d29a-417b-b7dc-50452b2801d4	af514448-9bd8-4a42-a2d5-770c24084e9f	section8	likely_qualified	75	Income qualifies at very_low threshold (0% of limit).	2026-05-31 14:15:09.646	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:09.646+00
59efe67b-3f4a-455a-b5f4-1c20e13e51d3	af514448-9bd8-4a42-a2d5-770c24084e9f	liheap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 14:15:10.686	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:10.686+00
766346f6-be6b-457b-af1b-18ea04a354e9	af514448-9bd8-4a42-a2d5-770c24084e9f	eitc	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-05-31 14:15:11.726	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:11.726+00
193b376d-2a3e-4ad4-a827-c459480ecde2	af514448-9bd8-4a42-a2d5-770c24084e9f	child_tax_credit	not_qualified	30	Income qualifies at high threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 14:15:12.765	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:12.765+00
985388c1-3fbe-4a3e-92f6-68ea64453f76	af514448-9bd8-4a42-a2d5-770c24084e9f	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-05-31 14:15:13.805	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:13.805+00
fce0ad94-7dde-4ea3-b2e8-0749f0639d03	af514448-9bd8-4a42-a2d5-770c24084e9f	head_start	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 14:15:14.844	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:14.844+00
93c2e7d5-743e-4fef-abbe-5c2cbb9ed5e1	af514448-9bd8-4a42-a2d5-770c24084e9f	lifeline	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 14:15:15.883	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:15.883+00
7c285988-07f8-43fd-b08f-54cc2ec0aff8	af514448-9bd8-4a42-a2d5-770c24084e9f	tanf	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 14:15:16.922	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:16.922+00
eece86fa-a9be-44bc-9d47-d47ea460ef4f	af514448-9bd8-4a42-a2d5-770c24084e9f	legal_aid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 14:15:17.961	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 14:15:17.961+00
d5a6e8de-5969-45c2-94e1-6e7706e794b2	10648b38-417c-4511-8d34-d6021f19d2c2	snap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 11:25:26.423	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:26.423+00
6f4294bf-004d-4214-9eb0-a8111c21bb08	10648b38-417c-4511-8d34-d6021f19d2c2	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-05-31 11:25:34.827	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:34.827+00
1c11a826-0ac4-4a1d-a83d-33fb504a35b8	10648b38-417c-4511-8d34-d6021f19d2c2	child_tax_credit	not_qualified	30	Income qualifies at high threshold (0% of limit). Program requires at least one child in the household.	2026-05-31 11:25:33.777	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:33.777+00
306aa88b-351d-47dd-b584-bebc77f6bc6b	10648b38-417c-4511-8d34-d6021f19d2c2	section8	likely_qualified	75	Income qualifies at very_low threshold (0% of limit).	2026-05-31 11:25:30.627	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:30.627+00
aeb63878-7294-4a22-96a4-ff06c8f3c6e8	10648b38-417c-4511-8d34-d6021f19d2c2	eitc	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-05-31 11:25:32.727	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:32.727+00
084de7f0-e634-438f-9aea-64ede4991d7e	10648b38-417c-4511-8d34-d6021f19d2c2	liheap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 11:25:31.677	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:31.677+00
36cc0ce9-8ff2-453b-8758-6a0cf91d43d8	10648b38-417c-4511-8d34-d6021f19d2c2	wic	not_qualified	20	Income qualifies at moderate threshold (0% of limit). Program requires pregnancy or children under 5.	2026-05-31 11:25:27.477	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:27.477+00
545b8fb0-1443-49c8-abb3-cd7122a877fa	10648b38-417c-4511-8d34-d6021f19d2c2	medicaid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-05-31 11:25:28.527	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:28.527+00
c4004c01-47a8-4ca2-9386-7b76a9467cba	10648b38-417c-4511-8d34-d6021f19d2c2	ccdf	check_required	45	Income qualifies at moderate threshold (0% of limit). Program requires at least one child in the household. Meets employment or education requirements.	2026-05-31 11:25:29.578	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 11:25:29.578+00
4c023c78-99f5-433c-aa6b-bf0f39e34d5c	316212a7-d942-4fbb-8d19-e6bad5d09df3	snap	likely_qualified	75	Income qualifies at low threshold (47% of limit).	2026-05-31 21:35:53.313	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.313+00
d29c595f-5a5e-4635-91cf-e2e453c619a8	316212a7-d942-4fbb-8d19-e6bad5d09df3	lifeline	likely_qualified	75	Income qualifies at low threshold (47% of limit).	2026-05-31 21:35:53.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.316+00
056fdfd1-1f69-4f01-8045-6b93a6cb2e4a	316212a7-d942-4fbb-8d19-e6bad5d09df3	medicaid	qualified	95	Income qualifies at low threshold (47% of limit). Priority given for disability or chronic illness status.	2026-05-31 21:35:53.314	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.314+00
b5751c4d-3156-4cad-9aeb-12d1c416206b	316212a7-d942-4fbb-8d19-e6bad5d09df3	liheap	likely_qualified	75	Income qualifies at low threshold (47% of limit).	2026-05-31 21:35:53.315	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.315+00
c69f400e-3983-4077-bd92-f4a9deda2c63	316212a7-d942-4fbb-8d19-e6bad5d09df3	eitc	likely_qualified	75	Income qualifies at moderate threshold (23% of limit).	2026-05-31 21:35:53.315	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.315+00
be6766cc-ec45-45da-9595-8d12678b0d97	316212a7-d942-4fbb-8d19-e6bad5d09df3	ccdf	qualified	100	Income qualifies at moderate threshold (23% of limit). Household includes dependent children. Meets employment or education requirements.	2026-05-31 21:35:53.314	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.314+00
86fa1794-ba9d-4be0-ac9f-39fb11804843	316212a7-d942-4fbb-8d19-e6bad5d09df3	wic	qualified	100	Income qualifies at moderate threshold (23% of limit). Has child(ren) under age 5.	2026-05-31 21:35:53.313	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.313+00
e8ccb2c5-92ff-4c1a-8bcc-07c441a6b39c	316212a7-d942-4fbb-8d19-e6bad5d09df3	section8	qualified	95	Income qualifies at very_low threshold (94% of limit). Priority given for disability or chronic illness status.	2026-05-31 21:35:53.314	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.314+00
834c65d2-7595-4a7e-b74d-4340a14dfab4	316212a7-d942-4fbb-8d19-e6bad5d09df3	child_tax_credit	qualified	100	Income qualifies at high threshold (12% of limit). Has 2 child(ren) within age limit (≤17).	2026-05-31 21:35:53.315	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.315+00
8436bf67-5276-46ae-ac29-bf6e40adbcf5	316212a7-d942-4fbb-8d19-e6bad5d09df3	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (23% of limit).	2026-05-31 21:35:53.315	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.315+00
5a93bdfc-2f2d-4fd3-9be0-7d814c059ee6	316212a7-d942-4fbb-8d19-e6bad5d09df3	head_start	qualified	100	Income qualifies at low threshold (47% of limit). Has 2 child(ren) within age limit (≤5).	2026-05-31 21:35:53.315	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.315+00
7595438b-3e6e-4f1c-bc14-237ac0cbeb9d	316212a7-d942-4fbb-8d19-e6bad5d09df3	tanf	qualified	90	Income qualifies at low threshold (47% of limit). Household includes dependent children.	2026-05-31 21:35:53.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.316+00
f64cfbbc-5b43-4711-8a8e-13a4015fff83	316212a7-d942-4fbb-8d19-e6bad5d09df3	legal_aid	likely_qualified	75	Income qualifies at low threshold (47% of limit).	2026-05-31 21:35:53.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-05-31 21:35:53.316+00
c865799c-b65b-4096-87e5-907e5fc5d3c9	020a979b-5495-4452-80c9-ef8c5d4a552b	snap	likely_qualified	75	Income qualifies at low threshold (39% of limit).	2026-06-02 14:51:14.464	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.464+00
aa1ee749-5159-42d7-a2e8-702a3425f18d	020a979b-5495-4452-80c9-ef8c5d4a552b	lifeline	likely_qualified	75	Income qualifies at low threshold (39% of limit).	2026-06-02 14:51:14.56	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.56+00
0938d31d-36ac-45bf-93a4-41ac9cda41c8	020a979b-5495-4452-80c9-ef8c5d4a552b	wic	not_qualified	20	Income qualifies at moderate threshold (20% of limit). Program requires pregnancy or children under 5.	2026-06-02 14:51:14.465	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.465+00
6e4a89d4-e74b-4ced-8a03-4c1c51f65a26	020a979b-5495-4452-80c9-ef8c5d4a552b	ccdf	qualified	100	Income qualifies at moderate threshold (20% of limit). Household includes dependent children. Meets employment or education requirements.	2026-06-02 14:51:14.465	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.465+00
657a114c-2368-4082-8662-ddf9455854b8	020a979b-5495-4452-80c9-ef8c5d4a552b	section8	qualified	95	Income qualifies at very_low threshold (78% of limit). Priority given for disability or chronic illness status.	2026-06-02 14:51:14.466	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.466+00
1250e98c-c8d6-48b9-91d3-d0743447e816	020a979b-5495-4452-80c9-ef8c5d4a552b	medicaid	qualified	95	Income qualifies at low threshold (39% of limit). Priority given for disability or chronic illness status.	2026-06-02 14:51:14.465	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.465+00
fe510dcf-71bd-4a00-8ea7-2595dab87b96	020a979b-5495-4452-80c9-ef8c5d4a552b	child_tax_credit	qualified	100	Income qualifies at high threshold (10% of limit). Has 1 child(ren) within age limit (≤17).	2026-06-02 14:51:14.467	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.467+00
e400c0f9-c3c2-4c4f-966a-081cb8d59a97	020a979b-5495-4452-80c9-ef8c5d4a552b	liheap	likely_qualified	75	Income qualifies at low threshold (39% of limit).	2026-06-02 14:51:14.466	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.466+00
74728671-df8d-4b92-9501-f9c679cb6078	020a979b-5495-4452-80c9-ef8c5d4a552b	eitc	likely_qualified	75	Income qualifies at moderate threshold (20% of limit).	2026-06-02 14:51:14.466	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.466+00
39b59905-16b1-41ac-b5db-f6e9b28dbe1c	020a979b-5495-4452-80c9-ef8c5d4a552b	head_start	likely_qualified	65	Income qualifies at low threshold (39% of limit). Children exceed age limit of 5.	2026-06-02 14:51:14.56	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.56+00
3ba51abf-496e-413e-bd6d-77eb1a81bdda	020a979b-5495-4452-80c9-ef8c5d4a552b	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (20% of limit).	2026-06-02 14:51:14.559	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.559+00
d1873163-9d23-4770-8899-199c21eb1125	020a979b-5495-4452-80c9-ef8c5d4a552b	legal_aid	qualified	100	Income qualifies at low threshold (39% of limit). Dealing with civil legal issues (eviction, custody). Qualifies for free legal aid services. Urgent situation (deadline or court date within 2 weeks) — priority queue routing.	2026-06-02 14:51:14.56	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.56+00
17ee12ef-fee7-4e1f-8409-c085c703739b	b2fde45d-108b-400a-9b65-e42184ed68a2	eitc	likely_qualified	75	Income qualifies at moderate threshold (23% of limit).	2026-06-08 14:22:22.102	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.102+00
0214d54d-7d1b-45e1-9f7c-c7798401b983	020a979b-5495-4452-80c9-ef8c5d4a552b	tanf	qualified	90	Income qualifies at low threshold (39% of limit). Household includes dependent children.	2026-06-02 14:51:14.56	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-02 14:51:14.56+00
5712423c-10a4-4865-bd1b-c9451ff29a79	99377481-f483-4c4c-afdf-bf3ece076349	snap	likely_qualified	75	Income qualifies at low threshold (23% of limit).	2026-06-04 13:05:01.863	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.863+00
4c1fce24-03b3-4da9-ae5c-ec9e9875faa8	99377481-f483-4c4c-afdf-bf3ece076349	lifeline	likely_qualified	75	Income qualifies at low threshold (23% of limit).	2026-06-04 13:05:01.865	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.865+00
063e3871-f3a7-4f93-944e-85d92fa68887	99377481-f483-4c4c-afdf-bf3ece076349	child_tax_credit	qualified	100	Income qualifies at high threshold (6% of limit). Has 2 child(ren) within age limit (≤17).	2026-06-04 13:05:01.865	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.865+00
7abe9cf9-7a07-4424-a2d3-8c7f59965b37	99377481-f483-4c4c-afdf-bf3ece076349	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (12% of limit).	2026-06-04 13:05:01.865	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.865+00
b7ed630a-422e-4b1e-8203-9e7c320484ab	99377481-f483-4c4c-afdf-bf3ece076349	ccdf	qualified	100	Income qualifies at moderate threshold (12% of limit). Household includes dependent children. Meets employment or education requirements.	2026-06-04 13:05:01.864	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.864+00
ac0dfb06-2315-45c7-ab19-fa6f4f0e6e44	99377481-f483-4c4c-afdf-bf3ece076349	wic	not_qualified	20	Income qualifies at moderate threshold (12% of limit). Program requires pregnancy or children under 5.	2026-06-04 13:05:01.864	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.864+00
3faa6ab9-3e27-4bd9-bcb8-fda298116923	99377481-f483-4c4c-afdf-bf3ece076349	eitc	likely_qualified	75	Income qualifies at moderate threshold (12% of limit).	2026-06-04 13:05:01.865	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.865+00
6a4d440b-a857-4929-9f23-88265b07827f	99377481-f483-4c4c-afdf-bf3ece076349	liheap	likely_qualified	75	Income qualifies at low threshold (23% of limit).	2026-06-04 13:05:01.865	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.865+00
05ad1468-0af9-48e6-8c9b-ccceeda9a809	99377481-f483-4c4c-afdf-bf3ece076349	head_start	likely_qualified	65	Income qualifies at low threshold (23% of limit). Children exceed age limit of 5.	2026-06-04 13:05:01.865	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.865+00
e8523931-e53e-4a61-a88f-4fcfd195ae65	99377481-f483-4c4c-afdf-bf3ece076349	medicaid	likely_qualified	75	Income qualifies at low threshold (23% of limit).	2026-06-04 13:05:01.863	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.863+00
5e6cf130-661a-42cd-8171-5a80c6a55980	99377481-f483-4c4c-afdf-bf3ece076349	section8	likely_qualified	75	Income qualifies at very_low threshold (47% of limit).	2026-06-04 13:05:01.864	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.864+00
8153b591-dd44-4144-a450-3189016cdd57	99377481-f483-4c4c-afdf-bf3ece076349	tanf	qualified	90	Income qualifies at low threshold (23% of limit). Household includes dependent children.	2026-06-04 13:05:01.865	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.865+00
da361180-a605-47b0-bb9e-60829c058724	99377481-f483-4c4c-afdf-bf3ece076349	legal_aid	likely_qualified	75	Income qualifies at low threshold (23% of limit).	2026-06-04 13:05:01.865	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-04 13:05:01.865+00
4315306c-807d-4181-9671-eaeab0933f33	b2fde45d-108b-400a-9b65-e42184ed68a2	section8	likely_qualified	75	Income qualifies at very_low threshold (94% of limit).	2026-06-08 14:22:22.102	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.102+00
11058921-1e04-43b4-ba19-cb396a0412eb	b2fde45d-108b-400a-9b65-e42184ed68a2	tanf	qualified	90	Income qualifies at low threshold (47% of limit). Household includes dependent children.	2026-06-08 14:22:22.105	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.105+00
d7eacffa-434a-4e37-9c0f-b5bbf13732cc	b2fde45d-108b-400a-9b65-e42184ed68a2	legal_aid	qualified	100	Income qualifies at low threshold (47% of limit). Dealing with civil legal issues (child_support, domestic_violence). Qualifies for free legal aid services. Issue requires attention soon (within next month).	2026-06-08 14:22:22.105	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.105+00
102883ae-3c52-4277-8b80-2cc6ae5c1043	b2fde45d-108b-400a-9b65-e42184ed68a2	snap_tx	check_required	50		2026-06-08 14:22:22.106	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.106+00
496a2f38-b9bb-4a93-ba8b-997ceb7fc4bf	b7f6902d-d0fe-4c69-ac1f-51faf9245226	legal_aid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-05 04:11:05.737	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.737+00
bfbe4d2c-5629-405a-a6be-374bce110400	b7f6902d-d0fe-4c69-ac1f-51faf9245226	head_start	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
5398b2cc-1fef-4647-a3ca-265af27a0127	b7f6902d-d0fe-4c69-ac1f-51faf9245226	liheap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
7dabc088-a570-41f8-a0b0-b3505cd20122	b7f6902d-d0fe-4c69-ac1f-51faf9245226	snap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-05 04:11:05.735	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.735+00
feb340fd-0e46-4877-8303-40909447330e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	medicaid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
5fbad521-9236-4d16-a354-a6046f6b1547	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8	likely_qualified	75	Income qualifies at very_low threshold (0% of limit).	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
5b81eba2-f26d-46f8-bbdb-b2499c326454	b7f6902d-d0fe-4c69-ac1f-51faf9245226	tanf	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
2380a18d-3025-4b29-9aa6-71d3a895fb82	b7f6902d-d0fe-4c69-ac1f-51faf9245226	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
4c4839f0-ef1c-4466-804f-d7490a1d19cc	b2fde45d-108b-400a-9b65-e42184ed68a2	snap	likely_qualified	75	Income qualifies at low threshold (47% of limit).	2026-06-08 14:22:22.01	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.01+00
40aea26e-896a-47ec-af97-52770e81b84f	b2fde45d-108b-400a-9b65-e42184ed68a2	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (23% of limit).	2026-06-08 14:22:22.104	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.104+00
b62786c2-0db9-4de5-b18b-632d02105497	b2fde45d-108b-400a-9b65-e42184ed68a2	ccdf	qualified	100	Income qualifies at moderate threshold (23% of limit). Household includes dependent children. Meets employment or education requirements.	2026-06-08 14:22:22.101	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.101+00
fbade7dc-946a-4e07-8fd9-d97a8afafc1e	b2fde45d-108b-400a-9b65-e42184ed68a2	lifeline	likely_qualified	75	Income qualifies at low threshold (47% of limit).	2026-06-08 14:22:22.105	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.105+00
d8e1476c-8b6e-4324-b269-95a161e8f4f1	b2fde45d-108b-400a-9b65-e42184ed68a2	head_start	qualified	100	Income qualifies at low threshold (47% of limit). Has 2 child(ren) within age limit (≤5).	2026-06-08 14:22:22.104	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.104+00
0918b819-9f1f-44af-8753-95da01c0be3f	b2fde45d-108b-400a-9b65-e42184ed68a2	wic	qualified	100	Income qualifies at moderate threshold (23% of limit). Has child(ren) under age 5.	2026-06-08 14:22:22.099	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.099+00
505d1548-70ff-4965-80a0-0f19f2cf4045	b2fde45d-108b-400a-9b65-e42184ed68a2	liheap	likely_qualified	75	Income qualifies at low threshold (47% of limit).	2026-06-08 14:22:22.102	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.102+00
a8a26cea-5690-4daf-997f-be6044be7ab9	b2fde45d-108b-400a-9b65-e42184ed68a2	child_tax_credit	qualified	100	Income qualifies at high threshold (12% of limit). Has 2 child(ren) within age limit (≤17).	2026-06-08 14:22:22.104	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.104+00
24dc9e19-d9c4-4b95-95a0-c8b3263d344d	b2fde45d-108b-400a-9b65-e42184ed68a2	wic_tx	check_required	50		2026-06-08 14:22:22.106	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.106+00
81738d8c-84fd-482c-9df0-fda64f7483ab	b2fde45d-108b-400a-9b65-e42184ed68a2	medicaid_tx	check_required	50		2026-06-08 14:22:22.106	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.106+00
1dadbb8c-91f7-4b76-881b-b53fe4078e75	b2fde45d-108b-400a-9b65-e42184ed68a2	medicaid_ca	check_required	50		2026-06-08 14:22:22.107	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.107+00
06cc2169-ee17-4d6c-80fb-cecfa607db43	b2fde45d-108b-400a-9b65-e42184ed68a2	childcare_fl	check_required	50		2026-06-08 14:22:22.111	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.111+00
853767bc-1bb3-4a6b-b97c-b9ee26c42991	b2fde45d-108b-400a-9b65-e42184ed68a2	liheap_fl	check_required	50		2026-06-08 14:22:22.112	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.112+00
eed23595-f48e-4187-8856-8063ef820f7f	b2fde45d-108b-400a-9b65-e42184ed68a2	medicaid_ny	check_required	50		2026-06-08 14:22:22.199	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.199+00
3e8a2876-31bb-4073-8a27-df043697e5e8	b2fde45d-108b-400a-9b65-e42184ed68a2	childsupport_ny	check_required	50		2026-06-08 14:22:22.201	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.201+00
a5e4e600-629e-4ff7-8b81-95bfb5ac49e1	b2fde45d-108b-400a-9b65-e42184ed68a2	medicaid_il	check_required	50		2026-06-08 14:22:22.202	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.202+00
cb122066-5750-4360-92cd-2ac35c6ccd62	b2fde45d-108b-400a-9b65-e42184ed68a2	tanf_tx	check_required	50		2026-06-08 14:22:22.106	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.106+00
0b514b6b-357c-43b3-a839-32f71ac1c11b	b2fde45d-108b-400a-9b65-e42184ed68a2	childcare_ca	check_required	50		2026-06-08 14:22:22.108	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.108+00
53f05476-d9c1-4d74-9812-02b115ec9975	b2fde45d-108b-400a-9b65-e42184ed68a2	section8_fl	check_required	50		2026-06-08 14:22:22.112	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.112+00
93517544-1ad9-4baa-9302-f59549201645	b2fde45d-108b-400a-9b65-e42184ed68a2	snap_il	check_required	50		2026-06-08 14:22:22.201	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.201+00
0b967364-f41a-4591-ae44-d8879e5a1130	b2fde45d-108b-400a-9b65-e42184ed68a2	childcare_tx	check_required	50		2026-06-08 14:22:22.106	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.106+00
6316a5be-d216-4681-939f-d547d6599159	b2fde45d-108b-400a-9b65-e42184ed68a2	medicaid_fl	check_required	50		2026-06-08 14:22:22.111	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.111+00
c6e9bacd-1e01-415f-8684-43dc66fbfb55	b2fde45d-108b-400a-9b65-e42184ed68a2	tanf_ny	check_required	50		2026-06-08 14:22:22.113	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.113+00
3c86fb9e-bd71-47b9-9867-5228b09dd89b	b2fde45d-108b-400a-9b65-e42184ed68a2	wic_il	check_required	50		2026-06-08 14:22:22.201	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.201+00
65123a1b-bce3-497f-b70d-d83aab127970	b2fde45d-108b-400a-9b65-e42184ed68a2	section8_tx	check_required	50		2026-06-08 14:22:22.107	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.107+00
77883fd4-69df-4c4b-95ac-7429cf5ee319	b2fde45d-108b-400a-9b65-e42184ed68a2	tanf_fl	check_required	50		2026-06-08 14:22:22.111	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.111+00
1c7b0ab2-53de-416f-82a3-b44498187b3a	b2fde45d-108b-400a-9b65-e42184ed68a2	wic_ny	check_required	50		2026-06-08 14:22:22.113	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.113+00
f9900cbf-ea09-43d0-a68e-fbbd89d6ce57	b2fde45d-108b-400a-9b65-e42184ed68a2	tanf_il	check_required	50		2026-06-08 14:22:22.202	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.202+00
ef992ed2-c713-4d7f-8c8d-f0fbdf024f2e	b2fde45d-108b-400a-9b65-e42184ed68a2	liheap_tx	check_required	50		2026-06-08 14:22:22.107	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.107+00
0fbff45c-87ac-4806-a151-1c928e28282f	b2fde45d-108b-400a-9b65-e42184ed68a2	snap_fl	check_required	50		2026-06-08 14:22:22.111	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.111+00
6607a808-539c-464a-a180-34db45f922a6	b2fde45d-108b-400a-9b65-e42184ed68a2	snap_ny	check_required	50		2026-06-08 14:22:22.113	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.113+00
8b726967-5cc0-4003-819d-da15bca9a41b	b2fde45d-108b-400a-9b65-e42184ed68a2	childsupport_il	check_required	50		2026-06-08 14:22:22.203	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.203+00
aedeac78-9f20-49aa-a59b-bfe6fd7ea7d4	b2fde45d-108b-400a-9b65-e42184ed68a2	childsupport_tx	check_required	50		2026-06-08 14:22:22.107	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.107+00
4b8068f6-7dce-40c1-9ed5-43327bb46182	b2fde45d-108b-400a-9b65-e42184ed68a2	childsupport_ca	check_required	50		2026-06-08 14:22:22.109	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.109+00
b004760a-fa24-4f56-adae-a7d7a0055196	b2fde45d-108b-400a-9b65-e42184ed68a2	childcare_ny	check_required	50		2026-06-08 14:22:22.199	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.199+00
347cc7b0-d65d-49e2-8203-5fbee118d0fc	b2fde45d-108b-400a-9b65-e42184ed68a2	childcare_il	check_required	50		2026-06-08 14:22:22.202	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.202+00
66947df1-a4fd-4e2c-9104-0f4fe226adec	b2fde45d-108b-400a-9b65-e42184ed68a2	snap_ca	check_required	50		2026-06-08 14:22:22.107	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.107+00
72e805d0-4dc5-4427-843e-50d3b3f370a4	b2fde45d-108b-400a-9b65-e42184ed68a2	liheap_ca	check_required	50		2026-06-08 14:22:22.108	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.108+00
1a0aa8dc-574b-4cfd-a156-99d3bfb75e45	b2fde45d-108b-400a-9b65-e42184ed68a2	section8_ny	check_required	50		2026-06-08 14:22:22.2	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.2+00
39ec34b8-1278-40ba-8541-cbed1702bf77	b2fde45d-108b-400a-9b65-e42184ed68a2	liheap_il	check_required	50		2026-06-08 14:22:22.203	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.203+00
bbeb5dd7-75f4-4ab3-b799-baf2794fd61f	b2fde45d-108b-400a-9b65-e42184ed68a2	wic_ca	check_required	50		2026-06-08 14:22:22.107	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.107+00
381c8cc8-5f50-4411-bcc8-610d32d37c7c	b2fde45d-108b-400a-9b65-e42184ed68a2	section8_ca	check_required	50		2026-06-08 14:22:22.108	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.108+00
111abefd-e77f-4308-8fb3-a8529e08adfe	b2fde45d-108b-400a-9b65-e42184ed68a2	liheap_ny	check_required	50		2026-06-08 14:22:22.2	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.2+00
c9d63143-1830-4b10-9d7c-e6d390105117	b2fde45d-108b-400a-9b65-e42184ed68a2	section8_il	check_required	50		2026-06-08 14:22:22.202	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.202+00
eff18560-6c79-4830-b929-ec7b0c104a84	b2fde45d-108b-400a-9b65-e42184ed68a2	tanf_ca	check_required	50		2026-06-08 14:22:22.107	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.107+00
7fcc7d2f-02b7-4934-b84f-1bdfc3ffb7af	b2fde45d-108b-400a-9b65-e42184ed68a2	wic_fl	check_required	50		2026-06-08 14:22:22.111	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.111+00
5d0a3f9b-fb49-44e5-aada-558c4e50d6f8	b2fde45d-108b-400a-9b65-e42184ed68a2	childsupport_fl	check_required	50		2026-06-08 14:22:22.113	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-08 14:22:22.113+00
515a16ef-5dff-4b5c-b082-2c0a792912f6	c4966c51-a590-485c-bf82-0d699e087ab8	wic	not_qualified	20	Income qualifies at moderate threshold (0% of limit). Program requires pregnancy or children under 5.	2026-06-09 03:40:17.749	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.749+00
dba69f9b-4e60-41b3-bc2e-691c0e4c5eaf	c4966c51-a590-485c-bf82-0d699e087ab8	lifeline	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
20413311-f32e-446d-8885-b0d61d967b58	c4966c51-a590-485c-bf82-0d699e087ab8	eitc	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-06-09 03:40:17.845	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.845+00
25287964-6db9-4ad6-99ac-2204da2225cb	c4966c51-a590-485c-bf82-0d699e087ab8	legal_aid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
15a5e62b-8286-496e-a422-e3005ca83f64	c4966c51-a590-485c-bf82-0d699e087ab8	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-06-09 03:40:17.845	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.845+00
3196b2f5-9bcb-4616-9bc3-774c293d3bfc	c4966c51-a590-485c-bf82-0d699e087ab8	snap_tx	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
d4869c15-5c81-49af-8676-cbf9ddfbb144	c4966c51-a590-485c-bf82-0d699e087ab8	wic_tx	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
24b7fc37-76cf-4b51-953d-d08588e05de8	c4966c51-a590-485c-bf82-0d699e087ab8	tanf_tx	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
8e95c925-9dcc-42c8-b701-e0d89f4b96f4	c4966c51-a590-485c-bf82-0d699e087ab8	medicaid_tx	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
df42a4cd-2a12-46c7-8eb0-7c9e96055880	c4966c51-a590-485c-bf82-0d699e087ab8	childcare_tx	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
1a72d0c4-9998-45db-a430-305311dfec40	c4966c51-a590-485c-bf82-0d699e087ab8	section8_tx	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
f620ff40-23df-4173-8e5d-3d8b98eed737	c4966c51-a590-485c-bf82-0d699e087ab8	liheap_tx	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
c2272dcb-f4ae-4ab0-8c72-07109a0006a9	c4966c51-a590-485c-bf82-0d699e087ab8	childsupport_tx	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
e30bb07c-f45a-4afc-b169-692cf2f30a4b	c4966c51-a590-485c-bf82-0d699e087ab8	snap_ca	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
9756e8e7-b70a-4eaf-99b5-3cd670c98703	c4966c51-a590-485c-bf82-0d699e087ab8	wic_ca	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
59b8ffb3-7d90-450d-a8ce-f11e5e83d826	c4966c51-a590-485c-bf82-0d699e087ab8	tanf_ca	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
33f879d1-722a-4a73-94ae-c7847e649400	c4966c51-a590-485c-bf82-0d699e087ab8	medicaid_ca	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
43082de3-ec54-4b22-891f-c091d1cea63e	c4966c51-a590-485c-bf82-0d699e087ab8	childcare_ca	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
00cdff93-2576-4efa-99da-0be5e534526b	c4966c51-a590-485c-bf82-0d699e087ab8	liheap_ca	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
fd3b9402-deea-4b9e-b766-959c0a5cc9ab	c4966c51-a590-485c-bf82-0d699e087ab8	childsupport_ca	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
89f4242a-41f2-4ff5-b7dd-9101f8bec518	c4966c51-a590-485c-bf82-0d699e087ab8	section8_ca	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
509acd6b-9ad5-494a-8c80-a03d94719ec1	c4966c51-a590-485c-bf82-0d699e087ab8	snap_fl	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
dd3c1dab-f9d8-4e6f-8718-9c63c19063d6	c4966c51-a590-485c-bf82-0d699e087ab8	wic_fl	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
c2b7be0c-33cf-49bb-a363-84e576fa0038	c4966c51-a590-485c-bf82-0d699e087ab8	tanf_fl	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
705327f4-1be6-42ce-ac38-de3ef5d80b79	c4966c51-a590-485c-bf82-0d699e087ab8	medicaid_fl	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
fd5e6f72-a589-4224-92e3-447ef69828ee	c4966c51-a590-485c-bf82-0d699e087ab8	childcare_fl	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
a25f3ea6-c410-4735-b786-6afd2618bb13	c4966c51-a590-485c-bf82-0d699e087ab8	section8_fl	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
b4604b0d-dd6e-43b2-adf2-750478d34607	c4966c51-a590-485c-bf82-0d699e087ab8	liheap_fl	check_required	50		2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
9f848cf2-c594-4a5a-a2da-eb6df5258b41	c4966c51-a590-485c-bf82-0d699e087ab8	childsupport_fl	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
8c30c330-410d-45c9-b736-ecc6228d7872	c4966c51-a590-485c-bf82-0d699e087ab8	snap_ny	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
48b38b0a-fc4e-4228-bf66-0a77826f8273	c4966c51-a590-485c-bf82-0d699e087ab8	wic_ny	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
6f1f6ce9-0d3c-426e-bf1c-8d6194de669b	c4966c51-a590-485c-bf82-0d699e087ab8	tanf_ny	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
c112c0f9-6766-4e0a-8a4c-e02c65ace8dd	c4966c51-a590-485c-bf82-0d699e087ab8	medicaid_ny	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
6457d36d-5a66-4beb-838c-abd4d6b736c4	c4966c51-a590-485c-bf82-0d699e087ab8	childcare_ny	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
5026f287-d734-4120-b7e3-6d92b6d5197e	c4966c51-a590-485c-bf82-0d699e087ab8	section8_ny	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
561f69ac-d0da-4851-b854-7047ad9230ac	c4966c51-a590-485c-bf82-0d699e087ab8	liheap_ny	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
8c88732b-2f16-44dc-9306-0d478c9198d8	c4966c51-a590-485c-bf82-0d699e087ab8	childsupport_ny	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
2966c534-7238-4016-8de9-dda5be0a4424	c4966c51-a590-485c-bf82-0d699e087ab8	snap_il	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
0359d91c-2a87-43f8-8268-e64ed75e46c4	c4966c51-a590-485c-bf82-0d699e087ab8	wic_il	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
12afcb8c-3ba4-4d5e-be88-9513f63def59	c4966c51-a590-485c-bf82-0d699e087ab8	tanf_il	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
bbd59fea-274f-4c56-9393-91cc226e25ab	c4966c51-a590-485c-bf82-0d699e087ab8	medicaid_il	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
9bfbbda2-3e92-4ab6-ae9d-26eeddf9bdea	c4966c51-a590-485c-bf82-0d699e087ab8	childcare_il	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
160ad1b6-b59d-40ef-a451-c5395c8f4e83	c4966c51-a590-485c-bf82-0d699e087ab8	section8_il	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
9e519933-9f04-4967-aff1-7d759639d3f2	c4966c51-a590-485c-bf82-0d699e087ab8	liheap_il	check_required	50		2026-06-09 03:40:17.847	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.847+00
cc37ab36-fc54-47de-8fb2-78e25576fb8f	c4966c51-a590-485c-bf82-0d699e087ab8	section8	likely_qualified	75	Income qualifies at very_low threshold (0% of limit).	2026-06-09 03:40:17.845	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.845+00
7be7a802-2779-456c-941a-6570786f21f9	c4966c51-a590-485c-bf82-0d699e087ab8	snap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-09 03:40:17.748	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.748+00
fceaf3c1-dc29-41f0-8136-9d03a3467ba6	c4966c51-a590-485c-bf82-0d699e087ab8	tanf	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-06-09 03:40:17.846	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.846+00
e6ca6e1c-1c52-4a2e-ae5a-ab841b883edc	c4966c51-a590-485c-bf82-0d699e087ab8	medicaid	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-09 03:40:17.845	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.845+00
d8a244e7-5dab-4873-a22d-c2834b8b03bc	c4966c51-a590-485c-bf82-0d699e087ab8	child_tax_credit	not_qualified	30	Income qualifies at high threshold (0% of limit). Program requires at least one child in the household.	2026-06-09 03:40:17.845	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.845+00
83632cb5-5303-42b3-9bf1-b0e3131c19f4	c4966c51-a590-485c-bf82-0d699e087ab8	ccdf	check_required	45	Income qualifies at moderate threshold (0% of limit). Program requires at least one child in the household. Meets employment or education requirements.	2026-06-09 03:40:17.845	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.845+00
45d85f7a-5e42-49c4-8b9a-49d00184966b	c4966c51-a590-485c-bf82-0d699e087ab8	liheap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-09 03:40:17.845	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.845+00
0475fc66-0974-4cbc-97cb-edfcb3981b4b	c4966c51-a590-485c-bf82-0d699e087ab8	head_start	not_qualified	30	Income qualifies at low threshold (0% of limit). Program requires at least one child in the household.	2026-06-09 03:40:17.845	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.845+00
7835ce33-08e6-4153-a86a-befbf69f26af	c4966c51-a590-485c-bf82-0d699e087ab8	childsupport_il	check_required	50		2026-06-09 03:40:17.848	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 03:40:17.848+00
fa014acc-22a6-4d44-a882-6e6b92f2fc0e	ad89b347-7133-4c28-b420-0c6601fc139f	snap	likely_qualified	75	Income qualifies at low threshold (20% of limit).	2026-06-09 05:38:51.496	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.496+00
567dc822-15ff-49c7-bd3f-7692b5255e73	ad89b347-7133-4c28-b420-0c6601fc139f	lifeline	likely_qualified	75	Income qualifies at low threshold (20% of limit).	2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
a1c27047-ab55-4b3e-b1ec-2612dac9440e	ad89b347-7133-4c28-b420-0c6601fc139f	tanf	not_qualified	30	Income qualifies at low threshold (20% of limit). Program requires at least one child in the household.	2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
673ff673-5d57-4d1e-902b-709a6b62b0dd	ad89b347-7133-4c28-b420-0c6601fc139f	legal_aid	likely_qualified	75	Income qualifies at low threshold (20% of limit).	2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
855c446d-4ba5-4dd8-b05d-fa01b257bc56	ad89b347-7133-4c28-b420-0c6601fc139f	snap_tx	check_required	50		2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
221bae2c-eff1-40ba-9812-1932b85f189d	ad89b347-7133-4c28-b420-0c6601fc139f	wic_tx	check_required	50		2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
f040df52-7e20-4c3d-a981-5200b491322e	ad89b347-7133-4c28-b420-0c6601fc139f	tanf_tx	check_required	50		2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
3ce8a479-926c-4a68-8d21-db694b3baef3	ad89b347-7133-4c28-b420-0c6601fc139f	medicaid_tx	check_required	50		2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
4d0d91e8-b412-4205-a6ff-713ba473e904	ad89b347-7133-4c28-b420-0c6601fc139f	childcare_tx	check_required	50		2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
b6e69363-1f92-464d-8a1d-a6f6f2a2788a	ad89b347-7133-4c28-b420-0c6601fc139f	section8_tx	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
650f18cd-dd29-4eb3-8f09-bd380fa92d17	ad89b347-7133-4c28-b420-0c6601fc139f	liheap_tx	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
8ccd1fcd-6b53-42df-8f57-f0ca4561b8b7	ad89b347-7133-4c28-b420-0c6601fc139f	childsupport_tx	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
88451de9-2884-4b2e-9142-b43659fd2500	ad89b347-7133-4c28-b420-0c6601fc139f	snap_ca	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
b6fd9714-ac1f-4287-8729-96e7e46f5558	ad89b347-7133-4c28-b420-0c6601fc139f	tanf_ca	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
e3309f8b-e678-46c4-9346-f5c81ad9ae4b	ad89b347-7133-4c28-b420-0c6601fc139f	medicaid_ca	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
7472ff73-b281-4672-ae89-ebe76ef0492f	ad89b347-7133-4c28-b420-0c6601fc139f	wic_ca	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
608ee33a-2267-428a-864b-9a3e25a2c98b	ad89b347-7133-4c28-b420-0c6601fc139f	childcare_ca	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
7f45949a-411b-4cc8-9295-cdc39e73f7b2	ad89b347-7133-4c28-b420-0c6601fc139f	section8_ca	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
15677f5c-04f6-41a2-93b9-981880d93c23	ad89b347-7133-4c28-b420-0c6601fc139f	liheap_ca	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
a977e696-d274-41dc-bf82-ba5daf6a7677	ad89b347-7133-4c28-b420-0c6601fc139f	childsupport_ca	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
8bf223f6-2f07-4733-93b8-1aace2ddfb95	ad89b347-7133-4c28-b420-0c6601fc139f	snap_fl	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
7cda3281-acd5-42dc-aeb4-50ef147cfb83	ad89b347-7133-4c28-b420-0c6601fc139f	wic_fl	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
0cc9a37c-e3d6-4475-be3a-c636734efb43	ad89b347-7133-4c28-b420-0c6601fc139f	liheap_fl	check_required	50		2026-06-09 05:38:51.551	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.551+00
caa3904a-d600-487c-8dc5-493450d030c3	ad89b347-7133-4c28-b420-0c6601fc139f	medicaid_fl	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
c71aa0e6-4e8f-42a1-8ace-0034c0ff5254	ad89b347-7133-4c28-b420-0c6601fc139f	childcare_fl	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
ef6b7d43-a247-4ee2-b2c0-9f892bceafb0	ad89b347-7133-4c28-b420-0c6601fc139f	section8_fl	check_required	50		2026-06-09 05:38:51.551	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.551+00
56b7ea2c-0606-48d4-a9b9-43db8fb004b7	ad89b347-7133-4c28-b420-0c6601fc139f	tanf_fl	check_required	50		2026-06-09 05:38:51.55	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.55+00
fec7e783-9e3a-46a3-985a-517b05477db4	ad89b347-7133-4c28-b420-0c6601fc139f	childsupport_fl	check_required	50		2026-06-09 05:38:51.551	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.551+00
c7e37b80-5300-4832-9df5-7688798341c8	ad89b347-7133-4c28-b420-0c6601fc139f	snap_ny	check_required	50		2026-06-09 05:38:51.551	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.551+00
0a46ca23-c764-458c-b506-b53455c44ef8	ad89b347-7133-4c28-b420-0c6601fc139f	wic_ny	check_required	50		2026-06-09 05:38:51.551	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.551+00
fc425900-65a2-4c01-b1ea-b28efc4ec349	ad89b347-7133-4c28-b420-0c6601fc139f	tanf_ny	check_required	50		2026-06-09 05:38:51.551	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.551+00
fd8986cd-bd39-42e5-889e-d61f6c9a2ab2	ad89b347-7133-4c28-b420-0c6601fc139f	wic_il	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
62cfb465-6f05-4e56-ae3e-e694b964827c	ad89b347-7133-4c28-b420-0c6601fc139f	medicaid_ny	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
9989f106-3ca3-4a79-89b9-6ff2017ac361	ad89b347-7133-4c28-b420-0c6601fc139f	tanf_il	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
4ba5105e-5581-44d7-b8dc-54a677544f8a	ad89b347-7133-4c28-b420-0c6601fc139f	childcare_ny	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
5c6a0f88-55e7-4e28-9e47-7bb95c1bcab3	ad89b347-7133-4c28-b420-0c6601fc139f	section8_ny	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
491ce5a1-18de-4c6e-bb39-6441df6519d0	ad89b347-7133-4c28-b420-0c6601fc139f	liheap_ny	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
2ec02d87-b94a-42db-a03a-45e970828f4f	ad89b347-7133-4c28-b420-0c6601fc139f	childsupport_ny	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
3d21b3ef-99fe-4d45-9e5b-dc8b2ceb578d	ad89b347-7133-4c28-b420-0c6601fc139f	childsupport_il	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
0f065085-f72f-4cdd-944b-5c6fc5bcadfe	ad89b347-7133-4c28-b420-0c6601fc139f	snap_il	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
4c23409e-4b1a-45ad-af70-a981e9a5ccfa	ad89b347-7133-4c28-b420-0c6601fc139f	liheap_il	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
43502e27-03e0-42d4-ad59-5a88f60ad0d8	ad89b347-7133-4c28-b420-0c6601fc139f	medicaid_il	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
e1c2a5d3-a440-4f56-a439-261212c760db	ad89b347-7133-4c28-b420-0c6601fc139f	childcare_il	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
3b62d9e4-0171-4882-8d35-ea5204aac968	ad89b347-7133-4c28-b420-0c6601fc139f	wic	not_qualified	20	Income qualifies at moderate threshold (10% of limit). Program requires pregnancy or children under 5.	2026-06-09 05:38:51.497	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.497+00
0a691ebf-5103-464f-a084-d1245bb1a9ff	ad89b347-7133-4c28-b420-0c6601fc139f	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (10% of limit).	2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
9b97ca56-80ee-4fd4-8ffa-bdc7873d2c87	ad89b347-7133-4c28-b420-0c6601fc139f	medicaid	likely_qualified	75	Income qualifies at low threshold (20% of limit).	2026-06-09 05:38:51.496	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.496+00
b2c25cd1-04c3-4611-981e-399b08824a67	ad89b347-7133-4c28-b420-0c6601fc139f	head_start	not_qualified	30	Income qualifies at low threshold (20% of limit). Program requires at least one child in the household.	2026-06-09 05:38:51.549	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.549+00
5457de2b-53d6-4bd3-ac21-f7f49965a119	ad89b347-7133-4c28-b420-0c6601fc139f	section8	likely_qualified	75	Income qualifies at very_low threshold (40% of limit).	2026-06-09 05:38:51.497	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.497+00
5a8530b9-8c7a-4156-97e5-d6c54be602d9	ad89b347-7133-4c28-b420-0c6601fc139f	child_tax_credit	not_qualified	30	Income qualifies at high threshold (5% of limit). Program requires at least one child in the household.	2026-06-09 05:38:51.498	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.498+00
266db709-afc9-4dd8-ade3-2d696b412b5c	ad89b347-7133-4c28-b420-0c6601fc139f	eitc	likely_qualified	75	Income qualifies at moderate threshold (10% of limit).	2026-06-09 05:38:51.498	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.498+00
86bd6999-d7bc-42a6-aab9-830ef0058627	ad89b347-7133-4c28-b420-0c6601fc139f	liheap	likely_qualified	75	Income qualifies at low threshold (20% of limit).	2026-06-09 05:38:51.497	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.497+00
bcbeb646-36a4-4aa3-b0fa-52ce439c5bdf	ad89b347-7133-4c28-b420-0c6601fc139f	ccdf	check_required	45	Income qualifies at moderate threshold (10% of limit). Program requires at least one child in the household. Meets employment or education requirements.	2026-06-09 05:38:51.497	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.497+00
bb63479a-5c34-4d1f-a0a4-56ba6cb9ba53	ad89b347-7133-4c28-b420-0c6601fc139f	section8_il	check_required	50		2026-06-09 05:38:51.552	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:38:51.552+00
8a498292-a7a5-4e6d-910a-39a6e0eda0db	dcf8d6a3-0282-402d-b40f-95ad3b24be73	snap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-09 05:57:55.748	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.748+00
138ca52f-0076-4875-83a1-263fea0e6257	dcf8d6a3-0282-402d-b40f-95ad3b24be73	lifeline	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-09 05:57:55.751	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.751+00
e0a75a6f-83ae-4fde-ba50-96d71fcde0d4	dcf8d6a3-0282-402d-b40f-95ad3b24be73	eitc	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-06-09 05:57:55.749	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.749+00
12fdc10c-4c89-4193-8c6f-6edb947fe712	dcf8d6a3-0282-402d-b40f-95ad3b24be73	tanf	qualified	90	Income qualifies at low threshold (0% of limit). Household includes dependent children.	2026-06-09 05:57:55.751	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.751+00
b60546b4-c555-44df-b608-d3e5c92b30ec	dcf8d6a3-0282-402d-b40f-95ad3b24be73	medicaid	qualified	95	Income qualifies at low threshold (0% of limit). Priority given for disability or chronic illness status.	2026-06-09 05:57:55.749	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.749+00
fb5d3d4f-2018-4070-82b7-f4967398f42d	dcf8d6a3-0282-402d-b40f-95ad3b24be73	tanf_tx	check_required	50		2026-06-09 05:57:55.751	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.751+00
cc813593-d21b-49ad-ab53-f5aeea9f12e0	dcf8d6a3-0282-402d-b40f-95ad3b24be73	wic_tx	check_required	50		2026-06-09 05:57:55.751	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.751+00
80f738ce-23a0-4705-9154-be6ddc59036f	dcf8d6a3-0282-402d-b40f-95ad3b24be73	medicaid_tx	check_required	50		2026-06-09 05:57:55.85	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.85+00
4798efbb-0269-44b5-be00-71198cd8bc4a	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childcare_tx	check_required	50		2026-06-09 05:57:55.85	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.85+00
a3a5398b-fce5-477c-bf41-48a4ce99b747	dcf8d6a3-0282-402d-b40f-95ad3b24be73	section8_tx	check_required	50		2026-06-09 05:57:55.85	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.85+00
52930a46-d563-432d-988f-413ff99b85b1	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childsupport_tx	check_required	50		2026-06-09 05:57:55.85	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.85+00
0d97d1d4-62a0-4ae8-9607-2cd091d60e55	dcf8d6a3-0282-402d-b40f-95ad3b24be73	snap_ca	check_required	50		2026-06-09 05:57:55.85	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.85+00
e1c969a5-3a60-463a-af75-1dadc73bc6e9	dcf8d6a3-0282-402d-b40f-95ad3b24be73	liheap_tx	check_required	50		2026-06-09 05:57:55.85	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.85+00
8f02d984-8b6f-4000-9d59-75d146dde8eb	dcf8d6a3-0282-402d-b40f-95ad3b24be73	wic_ca	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
7dbf4275-ce5b-464a-af04-dd90482409c5	dcf8d6a3-0282-402d-b40f-95ad3b24be73	tanf_ca	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
420b8b78-d7c2-4dd1-99f0-fb1fa275c399	dcf8d6a3-0282-402d-b40f-95ad3b24be73	medicaid_ca	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
d73bdfa0-c264-4cb5-a120-9d395aad103d	dcf8d6a3-0282-402d-b40f-95ad3b24be73	section8_ca	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
078d94b5-60da-4d42-8c86-27840b8fabe6	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childcare_ca	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
37248e2b-0f87-4ac7-80f4-6b05e3def5ed	dcf8d6a3-0282-402d-b40f-95ad3b24be73	liheap_ca	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
fb8aceed-d7d3-4ba2-83db-1310c50ede96	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childsupport_ca	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
9f34f5cc-9267-4793-b09c-0f74d537ff4f	dcf8d6a3-0282-402d-b40f-95ad3b24be73	snap_fl	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
cc105f3b-e327-4f15-83cd-8761f909fafd	dcf8d6a3-0282-402d-b40f-95ad3b24be73	wic_fl	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
5232c2c6-5e45-4953-92d8-ec44c371e536	dcf8d6a3-0282-402d-b40f-95ad3b24be73	tanf_fl	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
fceab21f-067a-47b0-9ce4-e67dee2e4fea	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childcare_fl	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
1b63e661-86c2-4f08-881e-3bfe63067558	dcf8d6a3-0282-402d-b40f-95ad3b24be73	medicaid_fl	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
a27153d9-e58b-4397-aa78-32ff49bd03a8	dcf8d6a3-0282-402d-b40f-95ad3b24be73	section8_fl	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
811649d5-3a57-4899-91f1-4e0c7c1ff00d	dcf8d6a3-0282-402d-b40f-95ad3b24be73	liheap_fl	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
7e14e5b4-f62c-4df6-9c94-ea649de99180	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childsupport_fl	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
7da74f17-67c8-4e88-8fdd-33e1da7e77eb	dcf8d6a3-0282-402d-b40f-95ad3b24be73	snap_ny	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
9f602de0-564b-446f-98e3-2d6899416d67	dcf8d6a3-0282-402d-b40f-95ad3b24be73	liheap_il	check_required	50		2026-06-09 05:57:55.852	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.852+00
1eccb1ff-767a-40af-b240-a7a0416df3cb	dcf8d6a3-0282-402d-b40f-95ad3b24be73	wic_ny	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
b8376668-4b04-4bbf-9000-d964e86a5082	dcf8d6a3-0282-402d-b40f-95ad3b24be73	wic_il	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
4d1c4fa2-7afc-4164-952e-0d0aebd20e45	dcf8d6a3-0282-402d-b40f-95ad3b24be73	tanf_ny	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
a2e8a418-36dc-4a66-917b-ea856200f00f	dcf8d6a3-0282-402d-b40f-95ad3b24be73	snap_il	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
3e685bdc-35ff-424a-86f8-0815ca7c0db2	dcf8d6a3-0282-402d-b40f-95ad3b24be73	medicaid_ny	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
f96636bb-8271-4bfe-ac55-bac3074b3751	dcf8d6a3-0282-402d-b40f-95ad3b24be73	tanf_il	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
6df6183d-0640-4cf0-8fa5-ec2778887c4c	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childcare_ny	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
a1e12c10-cb72-40a5-a136-44e96106d03d	dcf8d6a3-0282-402d-b40f-95ad3b24be73	medicaid_il	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
4563db0e-4b95-4795-ab2b-0362ae0cfa47	dcf8d6a3-0282-402d-b40f-95ad3b24be73	section8_ny	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
c5e0f952-67be-400e-8b06-657458966b1b	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childcare_il	check_required	50		2026-06-09 05:57:55.852	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.852+00
cdbddf28-7e28-4a61-8f0a-9aae3e5171ed	dcf8d6a3-0282-402d-b40f-95ad3b24be73	liheap_ny	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
601060e2-30b8-457b-a804-569d813b079e	dcf8d6a3-0282-402d-b40f-95ad3b24be73	section8_il	check_required	50		2026-06-09 05:57:55.852	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.852+00
c40eabed-5a42-4097-88ab-07ce50863fee	9f96c2cf-298d-4553-a094-a13af906b497	childsupport_tx	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
6ae6d01d-1fa0-4874-a303-79db302aca7a	9f96c2cf-298d-4553-a094-a13af906b497	legal_aid	not_qualified	15	Income exceeds the low threshold for this household size.	2026-06-09 07:01:27.138	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.138+00
98aa126e-75ed-41c3-80f8-c462860e9713	9f96c2cf-298d-4553-a094-a13af906b497	snap_ca	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
5b8d6a12-6890-4088-96e3-f59548d98b68	9f96c2cf-298d-4553-a094-a13af906b497	tanf_ca	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
05c74abf-e333-4916-b63a-b750913d92cc	9f96c2cf-298d-4553-a094-a13af906b497	wic_ca	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
1e28614d-0ba8-4388-9e46-b979380ebde8	9f96c2cf-298d-4553-a094-a13af906b497	medicaid_ca	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
75152488-2811-4618-acb9-1fdfe455c91a	9f96c2cf-298d-4553-a094-a13af906b497	childcare_ca	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
96436a18-fd01-4ac2-bfd1-76b9b817d769	9f96c2cf-298d-4553-a094-a13af906b497	section8_ca	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
5d2eb7d1-2f68-4dd8-848d-d29e554dbb0e	9f96c2cf-298d-4553-a094-a13af906b497	liheap_ca	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
285748b9-6ba6-47c1-af4e-ea06eaebb419	9f96c2cf-298d-4553-a094-a13af906b497	wic_fl	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
d77c58e4-32f0-4bd0-a087-5911462042d8	9f96c2cf-298d-4553-a094-a13af906b497	tanf_fl	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
79c15384-3882-4050-a724-6c1cf38ced04	9f96c2cf-298d-4553-a094-a13af906b497	medicaid_fl	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
10d12c3e-9b10-498d-85c3-c3d1014adb0f	9f96c2cf-298d-4553-a094-a13af906b497	childcare_fl	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
a942cb6b-bf1b-4b75-82d4-dd4391ff3035	9f96c2cf-298d-4553-a094-a13af906b497	snap_fl	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
15d3fea9-7178-4666-839b-f1097ddcc34f	9f96c2cf-298d-4553-a094-a13af906b497	section8_fl	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
c8c9084f-9c7b-455c-924a-22021126f269	9f96c2cf-298d-4553-a094-a13af906b497	liheap_fl	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
cda3eb70-8557-49b8-90c3-7a7cac6b65e7	9f96c2cf-298d-4553-a094-a13af906b497	childsupport_fl	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
cd34c23f-1a22-4a33-bbc3-3f45d4c77399	9f96c2cf-298d-4553-a094-a13af906b497	snap_ny	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
fc29deb4-88cc-4267-b399-b53bcd6e1277	9f96c2cf-298d-4553-a094-a13af906b497	wic_ny	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
af9e2bed-6748-4c5d-918c-c110b6f56f2f	9f96c2cf-298d-4553-a094-a13af906b497	tanf_ny	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
a0b86eb3-c027-45ea-9a22-473cbb0ccb08	9f96c2cf-298d-4553-a094-a13af906b497	medicaid_ny	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
efabc1c4-d9ed-4bb9-ae32-1d3e00bb5a9d	9f96c2cf-298d-4553-a094-a13af906b497	childcare_ny	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
9710c928-fed5-4833-8944-ff5d24e7281d	9f96c2cf-298d-4553-a094-a13af906b497	section8_ny	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
a599b591-9a77-4296-9114-b6bc33537475	9f96c2cf-298d-4553-a094-a13af906b497	childsupport_ny	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
660f6cd2-878d-4e5d-8242-6d76b226f326	9f96c2cf-298d-4553-a094-a13af906b497	snap_il	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
af0329eb-03de-4e0f-a882-3086282f066b	9f96c2cf-298d-4553-a094-a13af906b497	wic_il	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
71d24e04-1d4b-4178-bb67-d7ed6a6d733d	9f96c2cf-298d-4553-a094-a13af906b497	tanf_il	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
a33e5d45-5c76-4e21-8b7c-f23f5a7cee46	9f96c2cf-298d-4553-a094-a13af906b497	medicaid_il	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
3a9de07d-3f2c-4832-8862-1b716a14ed20	9f96c2cf-298d-4553-a094-a13af906b497	childcare_il	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
f893fffc-d7c0-4880-82ee-d0e1268ef7d6	9f96c2cf-298d-4553-a094-a13af906b497	section8_il	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
f9fb2fcf-6982-4270-9fbd-7f7ccc2535d2	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childsupport_ny	check_required	50		2026-06-09 05:57:55.851	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.851+00
128e66be-8dfe-46ec-8186-e5311d635aa9	dcf8d6a3-0282-402d-b40f-95ad3b24be73	childsupport_il	check_required	50		2026-06-09 05:57:55.852	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.852+00
41131cad-7b31-42ca-9961-044ad01421fd	9f96c2cf-298d-4553-a094-a13af906b497	section8	check_required	35	Income exceeds the very_low threshold for this household size. Priority given for disability or chronic illness status.	2026-06-09 07:01:27.136	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.136+00
6a717c85-add6-4a0e-80b2-4d5dad906f28	9f96c2cf-298d-4553-a094-a13af906b497	lifeline	not_qualified	15	Income exceeds the low threshold for this household size.	2026-06-09 07:01:27.138	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.138+00
e1dd6d11-47a1-4467-8e58-4fa1b6170be0	9f96c2cf-298d-4553-a094-a13af906b497	snap_tx	check_required	50		2026-06-09 07:01:27.148	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.148+00
4823f0ee-1741-443f-852a-d30de8e29d4a	9f96c2cf-298d-4553-a094-a13af906b497	tanf_tx	check_required	50		2026-06-09 07:01:27.148	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.148+00
e2291186-5852-4fe0-aed3-e80e5be578de	9f96c2cf-298d-4553-a094-a13af906b497	wic_tx	check_required	50		2026-06-09 07:01:27.148	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.148+00
b6a1263a-03e0-4ab1-b578-f76547214e69	9f96c2cf-298d-4553-a094-a13af906b497	medicaid_tx	check_required	50		2026-06-09 07:01:27.148	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.148+00
e2912b0f-e0fd-4784-873a-af2c8b5cd300	9f96c2cf-298d-4553-a094-a13af906b497	childcare_tx	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
e87dc8a8-bc2a-485d-96d0-75ca501671b9	9f96c2cf-298d-4553-a094-a13af906b497	section8_tx	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
f095b9e1-84e6-451f-8cd9-f0c44fa34ced	9f96c2cf-298d-4553-a094-a13af906b497	liheap_tx	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
805bd507-a65d-43bb-b858-bc434bb8e7f3	9f96c2cf-298d-4553-a094-a13af906b497	childsupport_ca	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
cf51780a-4dce-43d9-96f2-7d900e4a283f	9f96c2cf-298d-4553-a094-a13af906b497	liheap_il	check_required	50		2026-06-09 07:01:27.15	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.15+00
966491ed-0621-461e-bcb9-04b60c2bc5e1	9f96c2cf-298d-4553-a094-a13af906b497	snap	not_qualified	15	Income exceeds the low threshold for this household size.	2026-06-09 07:01:27.135	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.135+00
a433e3af-1f0a-4cda-93c1-472c3b511556	9f96c2cf-298d-4553-a094-a13af906b497	childsupport_il	check_required	50		2026-06-09 07:01:27.15	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.15+00
51821236-3e03-4cf9-be41-8e3cfd670470	b7f6902d-d0fe-4c69-ac1f-51faf9245226	wic	not_qualified	20	Income qualifies at moderate threshold (0% of limit). Program requires pregnancy or children under 5.	2026-06-05 04:11:05.735	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.735+00
7e9c20db-91a2-4028-bbe6-40d48648a6ef	9f96c2cf-298d-4553-a094-a13af906b497	medicaid	check_required	35	Income exceeds the low threshold for this household size. Priority given for disability or chronic illness status.	2026-06-09 07:01:27.135	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.135+00
ddfef773-8d16-4e73-8624-36697f281c9e	9f96c2cf-298d-4553-a094-a13af906b497	eitc	likely_qualified	75	Income qualifies at moderate threshold (80% of limit).	2026-06-09 07:01:27.136	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.136+00
646b15f8-05f1-460b-9350-aa0e82dd74e7	9f96c2cf-298d-4553-a094-a13af906b497	wic	qualified	100	Income qualifies at moderate threshold (80% of limit). Current pregnancy status qualifies.	2026-06-09 07:01:27.135	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.135+00
1deec6d9-2e75-486b-a863-9891306287bb	9f96c2cf-298d-4553-a094-a13af906b497	head_start	not_qualified	0	Income exceeds the low threshold for this household size. Program requires at least one child in the household.	2026-06-09 07:01:27.137	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.137+00
55af78db-53f2-4c32-9884-a58a56debb7c	9f96c2cf-298d-4553-a094-a13af906b497	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (80% of limit).	2026-06-09 07:01:27.137	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.137+00
8ffb254a-10da-4043-b3e5-55ba969e7080	9f96c2cf-298d-4553-a094-a13af906b497	child_tax_credit	not_qualified	30	Income qualifies at high threshold (40% of limit). Program requires at least one child in the household.	2026-06-09 07:01:27.137	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.137+00
d2c4f93c-4388-4b44-9cdb-e849443eb4aa	9f96c2cf-298d-4553-a094-a13af906b497	liheap	not_qualified	15	Income exceeds the low threshold for this household size.	2026-06-09 07:01:27.136	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.136+00
63ab101a-2564-4752-b3aa-825ccdfd7e68	9f96c2cf-298d-4553-a094-a13af906b497	tanf	not_qualified	0	Income exceeds the low threshold for this household size. Program requires at least one child in the household.	2026-06-09 07:01:27.138	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.138+00
fe44a0ca-9427-49ac-bb93-4da809165435	9f96c2cf-298d-4553-a094-a13af906b497	ccdf	check_required	45	Income qualifies at moderate threshold (80% of limit). Program requires at least one child in the household. Meets employment or education requirements.	2026-06-09 07:01:27.136	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.136+00
7b5efc1c-ef6b-4748-849d-ec47651d5667	9f96c2cf-298d-4553-a094-a13af906b497	liheap_ny	check_required	50		2026-06-09 07:01:27.149	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 07:01:27.149+00
344967c6-2a29-40a9-a7f1-a21cf5bd67e6	dcf8d6a3-0282-402d-b40f-95ad3b24be73	ccdf	qualified	100	Income qualifies at moderate threshold (0% of limit). Household includes dependent children. Meets employment or education requirements.	2026-06-09 05:57:55.749	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.749+00
c5f48591-7295-4c34-b034-12aa3920f89a	dcf8d6a3-0282-402d-b40f-95ad3b24be73	section8	qualified	95	Income qualifies at very_low threshold (0% of limit). Priority given for disability or chronic illness status.	2026-06-09 05:57:55.749	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.749+00
81aa307c-5a14-498e-b066-997a0ea32244	dcf8d6a3-0282-402d-b40f-95ad3b24be73	wic	qualified	100	Income qualifies at moderate threshold (0% of limit). Has child(ren) under age 5.	2026-06-09 05:57:55.749	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.749+00
d4371c0f-f814-45aa-bf61-cd447b9315bd	dcf8d6a3-0282-402d-b40f-95ad3b24be73	legal_aid	qualified	100	Income qualifies at low threshold (0% of limit). Dealing with civil legal issues (eviction, custody, domestic_violence, child_support, benefits_denial). Qualifies for free legal aid services. Urgent situation (deadline or court date within 2 weeks) — priority queue routing.	2026-06-09 05:57:55.751	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.751+00
d2c09f8b-4ef1-443d-94ce-4d1db2d81798	dcf8d6a3-0282-402d-b40f-95ad3b24be73	head_start	qualified	100	Income qualifies at low threshold (0% of limit). Has 1 child(ren) within age limit (≤5).	2026-06-09 05:57:55.751	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.751+00
646f4c30-a238-4c52-9bb4-708a5c22ae4a	dcf8d6a3-0282-402d-b40f-95ad3b24be73	snap_tx	check_required	50		2026-06-09 05:57:55.751	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.751+00
1d525d16-9a4c-422d-b8a4-e8fbed499e24	dcf8d6a3-0282-402d-b40f-95ad3b24be73	pell_grant	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-06-09 05:57:55.75	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.75+00
01558e55-ad9a-4132-a736-2dcac058bf85	dcf8d6a3-0282-402d-b40f-95ad3b24be73	liheap	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-09 05:57:55.749	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.749+00
00ff482e-7106-4950-a656-79126d4bccfb	dcf8d6a3-0282-402d-b40f-95ad3b24be73	child_tax_credit	qualified	100	Income qualifies at high threshold (0% of limit). Has 1 child(ren) within age limit (≤17).	2026-06-09 05:57:55.75	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 05:57:55.75+00
643374a0-8f17-44ba-afec-814eab34ef03	b7f6902d-d0fe-4c69-ac1f-51faf9245226	tanf_tx	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
bc3c1d31-b988-4546-b563-7e0347ebb374	b7f6902d-d0fe-4c69-ac1f-51faf9245226	eitc	likely_qualified	75	Income qualifies at moderate threshold (0% of limit).	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
2ca1b5db-1bbc-488e-9126-74dff8903ff4	b7f6902d-d0fe-4c69-ac1f-51faf9245226	ccdf	check_required	45	Income qualifies at moderate threshold (0% of limit). Program requires at least one child in the household. Meets employment or education requirements.	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
6870acdd-43ce-45a5-9553-b5341576354d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	snap_tx	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
f96de445-174f-4b1c-8015-2d7e6b221aaa	b7f6902d-d0fe-4c69-ac1f-51faf9245226	liheap_tx	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
ac10bb25-2640-40a8-b8e9-c7949d5afc58	b7f6902d-d0fe-4c69-ac1f-51faf9245226	tanf_ca	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
60ec26e1-7ded-4249-ac29-dc344867674a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childcare_tx	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
a93a7588-e484-42f6-91d7-e45a3d9c76f7	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8_tx	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
a5078fa6-cf07-4690-96e3-f8dd8b820ef6	b7f6902d-d0fe-4c69-ac1f-51faf9245226	wic_tx	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
f52179f1-4012-4faf-9318-98d465d6e4d3	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childsupport_ca	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
98bdba4e-3467-4cd1-bc2a-bcf8ee1c2586	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childcare_fl	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
c0f5c67d-1f66-4c09-8925-d556ba534e07	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childsupport_fl	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
be218e75-5f2b-4629-ac3e-34ebdf4dff94	b7f6902d-d0fe-4c69-ac1f-51faf9245226	liheap_il	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
7a01d7ac-ef52-483e-b1bb-02011fa16737	b7f6902d-d0fe-4c69-ac1f-51faf9245226	lifeline	likely_qualified	75	Income qualifies at low threshold (0% of limit).	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
7c2fc751-323d-4306-821e-abab66dbf02c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childcare_ca	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
fa0c5ed8-939f-4cda-8f48-574eac5d0469	b7f6902d-d0fe-4c69-ac1f-51faf9245226	snap_ca	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
ef96ad2f-f30d-4e94-a418-928f6c9383fd	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childcare_ny	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
73fa2d82-87a6-4bbd-9bdb-f1d206321082	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8_ny	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
473581a5-68ce-4b3c-a708-e3e12d8267b7	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8_fl	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
6cfd769d-582c-4a80-a39b-9653aaaaa358	b7f6902d-d0fe-4c69-ac1f-51faf9245226	medicaid_il	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
c7055fc3-99a7-4772-a01b-0e1fbf588d61	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childcare_il	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
ded145d9-faa5-4084-a736-9c12f0f08db7	b7f6902d-d0fe-4c69-ac1f-51faf9245226	snap_fl	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
6cebde9c-28b8-4a90-be4d-e5f2ee47f679	b7f6902d-d0fe-4c69-ac1f-51faf9245226	liheap_ca	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
54611596-5a5d-4847-91e9-956c3ab864d2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	medicaid_fl	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
72753e81-6bea-49a1-8638-c3f4dc9eec30	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childsupport_ny	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
804da1b3-c725-4e31-bd2e-e4a4f146b6f2	b7f6902d-d0fe-4c69-ac1f-51faf9245226	medicaid_ca	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
7570d30a-8bae-45a2-bd0b-652843614a8e	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childsupport_tx	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
047c1dfd-e15b-4350-9f7e-a160b49c01e6	b7f6902d-d0fe-4c69-ac1f-51faf9245226	wic_ny	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
08d68cc0-dbf6-4293-b5e2-d4b9eacd12a9	b7f6902d-d0fe-4c69-ac1f-51faf9245226	tanf_ny	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
0364dbd3-9ae6-463f-beb1-23257f78c73f	b7f6902d-d0fe-4c69-ac1f-51faf9245226	snap_ny	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
edc1f49b-a35f-4e94-8cd0-6c0cef31cf07	b7f6902d-d0fe-4c69-ac1f-51faf9245226	wic_il	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
e762bc87-ecde-4cde-9822-0335c8ea25f8	b7f6902d-d0fe-4c69-ac1f-51faf9245226	medicaid_tx	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
25e9841a-1193-4d69-9f19-0937af86aa18	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8_ca	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
ecbd6d02-ac2e-4e25-8000-297715354276	b7f6902d-d0fe-4c69-ac1f-51faf9245226	liheap_fl	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
5855753c-f7f7-416e-a8eb-72e93abd9612	b7f6902d-d0fe-4c69-ac1f-51faf9245226	section8_il	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
3c6906e0-6276-4878-a0f4-75cc7f87b0a4	b7f6902d-d0fe-4c69-ac1f-51faf9245226	wic_ca	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
25673455-2fa6-49a3-8922-8794b68036e4	b7f6902d-d0fe-4c69-ac1f-51faf9245226	medicaid_ny	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
7fcf9949-dcdb-47b6-aac5-ebc8485977c8	b7f6902d-d0fe-4c69-ac1f-51faf9245226	child_tax_credit	not_qualified	30	Income qualifies at high threshold (0% of limit). Program requires at least one child in the household.	2026-06-05 04:11:05.736	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-05 04:11:05.736+00
a14d883c-ea93-43b5-9144-8ff7e78b990b	b7f6902d-d0fe-4c69-ac1f-51faf9245226	wic_fl	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
b4d3b62d-bf9e-4d3a-8f45-321c51314398	b7f6902d-d0fe-4c69-ac1f-51faf9245226	liheap_ny	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
9faed48e-06a0-4598-a532-1048a259c6dd	b7f6902d-d0fe-4c69-ac1f-51faf9245226	snap_il	check_required	50		2026-06-09 19:08:40.652	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 19:08:40.652+00
75866cbc-d3d3-49e7-ae64-0d24cb4d7a08	b7f6902d-d0fe-4c69-ac1f-51faf9245226	tanf_il	check_required	50		2026-06-09 16:52:58.316	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 16:52:58.316+00
187af06f-9583-4df5-99ec-a8edd14c980a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	tanf_fl	check_required	50		2026-06-09 19:08:40.652	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 19:08:40.652+00
e5ce2abe-7b2a-428d-ba9d-ee602c30f86d	b7f6902d-d0fe-4c69-ac1f-51faf9245226	childsupport_il	check_required	50		2026-06-09 19:08:40.652	\N	\N	\N	\N	\N	\N	{}	\N	2026-06-09 19:08:40.652+00
\.


--
-- TOC entry 4722 (class 0 OID 27713)
-- Dependencies: 423
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subscriptions (id, user_id, stripe_customer_id, stripe_subscription_id, plan, status, current_period_start, current_period_end, cancel_at_period_end, created_at, updated_at) FROM stdin;
df9d543a-cbc9-432e-8a0c-aea6f90d4108	377b4aad-d563-49a6-88f7-78560490e3d0	cus_mock_377b4aad-d563-49a6-88f7-78560490e3d0	sub_mock_1781202217337	partner	active	2026-06-11 18:23:37.337+00	2027-06-11 18:23:37.337+00	f	2026-06-11 18:23:41.667+00	2026-06-11 18:23:41.667+00
8dca6d62-e202-4116-960a-79ee3e5b1b1a	b7f6902d-d0fe-4c69-ac1f-51faf9245226	cus_mock_b7f6902d-d0fe-4c69-ac1f-51faf9245226	sub_mock_1781202243213	network	canceled	2026-06-11 18:24:40.053+00	2027-06-11 18:24:40.053+00	f	2026-06-11 18:24:07.685+00	2026-06-11 20:16:51.239+00
02016db7-b429-4af4-a794-1e79508e706c	b7f6902d-d0fe-4c69-ac1f-51faf9245226	cus_mock_b7f6902d-d0fe-4c69-ac1f-51faf9245226	sub_mock_1781209009119	partner	active	2026-06-11 20:16:49.119+00	2027-06-11 20:16:49.119+00	f	2026-06-11 20:16:52.302+00	2026-06-11 20:16:52.302+00
\.


--
-- TOC entry 4698 (class 0 OID 26849)
-- Dependencies: 399
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password_hash, full_name, phone, role, plan, stripe_customer_id, stripe_subscription_id, state, zip_code, created_at, updated_at, last_active_at, status, profile_picture) FROM stdin;
10648b38-417c-4511-8d34-d6021f19d2c2	Maria12@gmail.com	$2b$10$irgqTpC9FleWSyurvupAzeUhf8jQSwykIEbzPmzhGH4hKI16CD0Ee	Maria	123534643523	user	community	\N	\N	GA	\N	2026-05-31 10:23:02.484+00	2026-06-02 18:06:10.628+00	2026-06-02 18:06:10.627+00	active	\N
b7f6902d-d0fe-4c69-ac1f-51faf9245226	nimisha.mom3@gmail.com	$2b$10$zD7B0iqwhvlBX6W1Nw9gmOzC5v4N5m.VCYkxbI1D/2.hoeQk9mKNi	Jennys	6313988313	user	partner	cus_mock_b7f6902d-d0fe-4c69-ac1f-51faf9245226	sub_mock_1781209009119	IL		2026-06-03 19:04:04.39+00	2026-06-12 09:49:46.93+00	2026-06-12 09:49:46.929+00	active	
f8b94482-c4ba-4cca-9bdd-051fa82fb228	imnimisha@gmail.com	$2b$10$v5PugWiOXCjduIwcqYQObeHhbcQKEzi581Y2/rib7gFNmetk3yOlC	NImisha Gandhi	imnimisha@gmail.com	user	community	\N	\N	\N	\N	2026-05-31 09:52:49.79+00	2026-05-31 10:18:37.188+00	2026-05-31 10:18:37.187+00	active	\N
55b28a2d-ac96-4dff-b111-ca4338daebb0	jane12@gmail.com	$2b$10$TpZJ8mGMtrDP0XOgHsNaLulzNtn0JFKgVmySMxbvu3HtnBKyaJWZW	Jane jane12@gmail.com	293098124	user	community	\N	\N	GA	78701	2026-05-30 12:07:50.568+00	2026-05-31 10:22:01.787+00	2026-05-31 10:22:01.786+00	active	\N
0f49d56a-6596-4912-be25-e3767e722bfd	maria.test.93@example.com	$2b$10$6zyvMi9MnQ.C4QwOymx5meZ8EOadGiJZu1RMnLjaIEfhRjTzw8doe	Maria Garcia	5125550100	user	community	\N	\N	\N	\N	2026-05-31 10:37:06.822+00	2026-05-31 10:37:06.822+00	2026-05-31 10:37:06.822+00	active	\N
316212a7-d942-4fbb-8d19-e6bad5d09df3	nimisha.mom1@gmail.com	$2b$10$QQFEsAUq9iV7zSU9yCGMr.O30de4fSyRYMQgZLSAcUfQkIlY2wTnS	Grace check	6313988313	user	community	\N	\N	CA	94102	2026-05-31 21:30:18.223+00	2026-05-31 22:14:33.174+00	2026-05-31 22:14:33.173+00	active	\N
b384fae6-ae91-4d62-8e2c-cb2b6707cdc2	hardik@dazzlebirds.com	$2b$10$CPdq7P0hN3uQ/gFH6pbB1uoZLNWaESzhzJXoz8tglco7wgtEu8sHO	hardik mehta	09925593893	user	community	\N	\N	\N	\N	2026-06-05 16:17:00.097+00	2026-06-05 16:17:01.168+00	2026-06-05 16:17:00.097+00	active	\N
020a979b-5495-4452-80c9-ef8c5d4a552b	nimisha.mom2@gmail.com	$2b$10$9Yetr5TQq38BNzUHX73MYuCacNYTRM3ZN1rYONqAFFlVdSgE50ccG	Jenny Yochanan	5165878787	user	community	\N	\N	GA	30022	2026-06-02 14:44:46.27+00	2026-06-03 16:42:18.201+00	2026-06-03 16:42:18.2+00	active	\N
d63c70ab-4901-4a3b-86db-91f1b21d942e	nimisha.mom@gmail.com	$2b$10$g2.FM4/eOiQDF3g1tgFwFOcQ3eNdIVPvoSWc3mjmSD8zToE0.Cyla	Nimish_mom	6313988313	user	community	\N	\N	GA	\N	2026-05-31 12:58:57.935+00	2026-06-02 14:35:45.672+00	2026-06-02 14:35:45.671+00	active	\N
a77f02a4-a0a7-4e65-963c-1076b1981d7a	admin@momplan.com	$2b$10$JOCw6agIcbjdOv/M7jLE0ekjgXE6/xncyYmT9pGFYa5ugGJzSuGnS	System Admin	\N	admin	community	\N	\N	\N	\N	2026-05-30 11:34:43.312+00	2026-06-11 11:41:44.323+00	2026-06-11 11:41:44.322+00	active	\N
99377481-f483-4c4c-afdf-bf3ece076349	jpender95@gmail.com	$2b$10$bhA/4IxvspsxDKrPSMczseIUBlRRKoaSvl3eXMxopLMACzWElxXRa	Jerry L Pender	2055410400	user	community	\N	\N	GA	30043	2026-06-04 12:55:33.27+00	2026-06-06 17:59:16.504+00	2026-06-06 17:56:51.944+00	active	\N
af514448-9bd8-4a42-a2d5-770c24084e9f	jane.doe.test12@example.com	$2b$10$qzx7xpCm5fzvBie.VgjtMutI5T3RkIaA/SytHWz7vXmCMbxnbiOTy	Jane Doe	5125550100	user	community	\N	\N	GA	\N	2026-05-31 14:08:59.747+00	2026-05-31 14:14:45.134+00	2026-05-31 14:14:17.525+00	active	\N
e327ad63-3ac2-43b7-81d8-e90c542086dd	jerry.pender@professorp.info	$2b$10$.Lh/mNba3NurzdIhCr7wp.eHh9PC.m.WHwIX5B20yG.2rpnOWP.j2	Jerry L Pender	2055410400	user	community	\N	\N	\N	\N	2026-06-06 18:00:57.152+00	2026-06-06 18:00:58.279+00	2026-06-06 18:00:57.152+00	active	\N
c4966c51-a590-485c-bf82-0d699e087ab8	nimisha.mom6@gmail.com	$2b$10$aphS9eSljrpCMPrYCAKimO5lotO3jcbIGxmiQ5S.B1/laaVtV2RJK	nimisha.mom3@gmail.com	6313988313	user	community	\N	\N	GA	30005	2026-06-09 03:39:50.455+00	2026-06-10 17:26:29.259+00	2026-06-10 17:26:29.257+00	active	
ad89b347-7133-4c28-b420-0c6601fc139f	cuvelywuw@mailinator.com	$2b$10$B2TXoLKCWHDea.yZR415f.4AD4gWM0JrdH6/o7uzlT9T5o4EcyjTi	Kevin Day	9976813237	user	community	\N	\N	GA	39500	2026-06-09 05:34:15.959+00	2026-06-09 05:38:43.43+00	2026-06-09 05:34:15.959+00	active	\N
bdaf1e4d-8a4f-40c3-8cd4-884a7c7210c4	bojucyn@mailinator.com	$2b$10$8pZr4aUKKhPBqEkuaRpN.uS61BfjyxQKJEquFP1OmTcvHX5fwK1le	Nevada Frost	+1 (271) 861-6037	user	community	\N	\N	\N	\N	2026-06-09 05:30:14.062+00	2026-06-09 05:32:46.349+00	2026-06-09 05:30:14.062+00	active	\N
1b8ab450-cf8e-4e98-84b4-e90f6a633900	zigaze@mailinator.com	$2b$10$ay2aEQwBGdXXcvDO2oSPc.eL3puyddMwwt8MJ3qycHjINhfa4MN4u	Melinda Burns	+1 (328) 255-7283	user	community	\N	\N	\N	\N	2026-06-09 05:33:24.659+00	2026-06-09 05:33:42.06+00	2026-06-09 05:33:42.059+00	active	\N
48912eab-5c06-42b4-ab9c-31c82a6436db	test@gmail.com	$2b$10$S0Pmk0DgEU.RXM.BDEUrM.nEs9Z15TAY5smxCUv601rutZHgzgSG6	test testor	123456789456	user	community	\N	\N	\N	\N	2026-06-09 06:25:54.16+00	2026-06-09 06:29:58.032+00	2026-06-09 06:25:54.16+00	active	\N
dcf8d6a3-0282-402d-b40f-95ad3b24be73	lu@gmail.com	$2b$10$sISZidI8Mx5ENkKAFyqOKu6el.pX9Jd7JQVpDAZDwb/UlXvS5aq2u	Lusia	5546233526	user	community	\N	\N	FL	45663	2026-06-09 05:53:09.961+00	2026-06-09 09:28:55.202+00	2026-06-09 09:25:01.187+00	active	
b2fde45d-108b-400a-9b65-e42184ed68a2	nimisha.mom5@gmail.com	$2b$10$ZO8TWOVrQq1pKRSao2c6bemqz3tN6b3O.ZV/Ke4ccVeVxtr6mnWGe	Nimisha ffff	555555555	user	community	\N	\N	GA	30005	2026-06-08 14:19:41.111+00	2026-06-10 03:59:14.191+00	2026-06-10 03:57:39.917+00	active	
9f96c2cf-298d-4553-a094-a13af906b497	sainibundi123@gmail.com	$2b$10$vN2xkTq5ix6Zw3gVdX74Guo83Q00QOef995e9ExXJRNw3mwkgbnG6	TEST dev	0123456789	user	community	\N	\N	GA		2026-06-09 06:56:31.857+00	2026-06-09 07:33:08.959+00	2026-06-09 07:33:08.958+00	active	
377b4aad-d563-49a6-88f7-78560490e3d0	checkout-test-1781202211@example.com	$2b$10$MukTrzmlOcB2XqBgbCOKwOkz4RD4CjW9z/xfmldSUOybrxHxWKXGO	Test User	\N	user	partner	cus_mock_377b4aad-d563-49a6-88f7-78560490e3d0	sub_mock_1781202217337	\N	\N	2026-06-11 18:23:33.019+00	2026-06-11 18:23:43.333+00	2026-06-11 18:23:33.019+00	active	\N
eb230de5-9f9b-4830-9b4d-4a75bc64eff2	nimisha.mom7@gmail.com	$2b$10$rXB4QkFfeaI0RtDhwd8Th.sS7./mI8UhXzhCzL7fq3cTP2ioInMoi	Maria	5757778787	user	community	\N	\N	\N	\N	2026-06-12 01:12:51.799+00	2026-06-12 01:12:51.799+00	2026-06-12 01:12:51.799+00	active	\N
77547d68-225e-4f72-8ed1-2f35354529d6	nimisha.mom9@gmail.com	$2b$10$zoRVGmKgI8bh19N//kwKKO4RsMG7eRnDaKTeY6EhX3qiIkX6qrzGe	Maria Johnson	5757778787	user	community	\N	\N	\N	\N	2026-06-12 01:13:22.596+00	2026-06-12 01:13:22.596+00	2026-06-12 01:13:22.596+00	active	\N
962cfc17-a6b2-4fda-b823-64e5ad7ea261	nimisha.mom10@gmail.com	$2b$10$HWDUyVQZYFvFIBXiQal7OeCYnsKNfcCeJUWS9Wk/uoc9byqreXaRK	Sheela Jackson	5757778787	user	community	\N	\N	\N	\N	2026-06-12 01:14:09.297+00	2026-06-12 01:14:09.297+00	2026-06-12 01:14:09.297+00	active	\N
8122bc15-ff15-44f4-8751-0bdc6c3f3386	test@gmail.co.in	$2b$10$IUFiK5ldVdPg0APInP4dDe46tBnJsQjovLx06ayJRwJOOvcuD4xg.	Test		user	community	\N	\N	\N	\N	2026-06-12 07:47:13.352+00	2026-06-12 07:47:13.352+00	2026-06-12 07:47:13.352+00	active	\N
\.


--
-- TOC entry 4693 (class 0 OID 26101)
-- Dependencies: 394
-- Data for Name: messages_2026_05_24; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_05_24 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- TOC entry 4694 (class 0 OID 26113)
-- Dependencies: 395
-- Data for Name: messages_2026_05_25; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_05_25 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- TOC entry 4695 (class 0 OID 26125)
-- Dependencies: 396
-- Data for Name: messages_2026_05_26; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_05_26 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- TOC entry 4696 (class 0 OID 26137)
-- Dependencies: 397
-- Data for Name: messages_2026_05_27; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_05_27 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- TOC entry 4697 (class 0 OID 26149)
-- Dependencies: 398
-- Data for Name: messages_2026_05_28; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_05_28 (topic, extension, payload, event, private, updated_at, inserted_at, id, binary_payload) FROM stdin;
\.


--
-- TOC entry 4681 (class 0 OID 17164)
-- Dependencies: 378
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-04-07 13:24:59
20211116045059	2026-04-07 13:25:00
20211116050929	2026-04-07 13:25:00
20211116051442	2026-04-07 13:25:00
20211116212300	2026-04-07 13:25:00
20211116213355	2026-04-07 13:25:00
20211116213934	2026-04-07 13:25:00
20211116214523	2026-04-07 13:25:00
20211122062447	2026-04-07 13:25:01
20211124070109	2026-04-07 13:25:01
20211202204204	2026-04-07 14:45:53
20211202204605	2026-04-07 14:45:53
20211210212804	2026-04-07 14:45:53
20211228014915	2026-04-07 14:45:54
20220107221237	2026-04-07 14:45:54
20220228202821	2026-04-07 14:45:54
20220312004840	2026-04-07 14:45:54
20220603231003	2026-04-07 14:45:54
20220603232444	2026-04-07 14:45:54
20220615214548	2026-04-07 14:45:55
20220712093339	2026-04-07 14:45:55
20220908172859	2026-04-07 14:45:55
20220916233421	2026-04-07 14:45:55
20230119133233	2026-04-07 14:45:55
20230128025114	2026-04-07 14:45:55
20230128025212	2026-04-07 14:45:55
20230227211149	2026-04-07 14:45:56
20230228184745	2026-04-07 14:45:56
20230308225145	2026-04-07 14:45:56
20230328144023	2026-04-07 14:45:56
20231018144023	2026-04-07 14:45:56
20231204144023	2026-04-07 14:45:56
20231204144024	2026-04-07 14:45:56
20231204144025	2026-04-07 14:45:57
20240108234812	2026-04-07 14:45:57
20240109165339	2026-04-07 14:45:57
20240227174441	2026-04-07 14:45:57
20240311171622	2026-04-07 14:45:57
20240321100241	2026-04-07 14:45:58
20240401105812	2026-04-07 14:45:58
20240418121054	2026-04-07 14:45:58
20240523004032	2026-04-07 14:45:59
20240618124746	2026-04-07 14:45:59
20240801235015	2026-04-07 14:45:59
20240805133720	2026-04-07 14:45:59
20240827160934	2026-04-07 14:45:59
20240919163303	2026-04-07 14:45:59
20240919163305	2026-04-07 14:45:59
20241019105805	2026-04-07 14:46:00
20241030150047	2026-04-07 14:46:00
20241108114728	2026-04-07 14:46:00
20241121104152	2026-04-07 14:46:00
20241130184212	2026-04-07 14:46:01
20241220035512	2026-04-07 14:46:01
20241220123912	2026-04-07 14:46:01
20241224161212	2026-04-07 14:46:01
20250107150512	2026-04-07 14:46:01
20250110162412	2026-04-07 14:46:01
20250123174212	2026-04-07 14:46:01
20250128220012	2026-04-07 14:46:02
20250506224012	2026-04-07 14:46:02
20250523164012	2026-04-07 14:46:02
20250714121412	2026-04-07 14:46:02
20250905041441	2026-04-07 14:46:02
20251103001201	2026-04-07 14:46:02
20251120212548	2026-04-07 14:46:02
20251120215549	2026-04-07 14:46:02
20260218120000	2026-04-07 14:46:03
20260326120000	2026-04-30 16:10:59
20260514120000	2026-06-08 14:33:55
20260527120000	2026-06-08 14:33:55
20260528120000	2026-06-08 14:33:55
20260603120000	2026-06-08 14:33:55
\.


--
-- TOC entry 4683 (class 0 OID 17187)
-- Dependencies: 381
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- TOC entry 4685 (class 0 OID 17235)
-- Dependencies: 384
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
pdf-templates	pdf-templates	\N	2026-05-22 15:42:07.09736+00	2026-05-22 15:42:07.09736+00	t	f	10485760	{application/pdf}	\N	STANDARD
user-documents	user-documents	\N	2026-05-22 15:42:07.09736+00	2026-05-22 15:42:07.09736+00	f	f	52428800	{application/pdf,image/jpeg,image/png,image/webp,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document}	\N	STANDARD
\.


--
-- TOC entry 4689 (class 0 OID 17354)
-- Dependencies: 388
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- TOC entry 4690 (class 0 OID 17367)
-- Dependencies: 389
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4684 (class 0 OID 17227)
-- Dependencies: 383
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-04-07 13:25:43.406454
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-04-07 13:25:43.440344
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-04-07 13:25:43.442935
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-04-07 13:25:43.461671
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-04-07 13:25:43.471893
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-04-07 13:25:43.474115
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-04-07 13:25:43.477152
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-04-07 13:25:43.480229
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-04-07 13:25:43.482633
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-04-07 13:25:43.485264
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-04-07 13:25:43.488822
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-04-07 13:25:43.491575
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-04-07 13:25:43.494731
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-04-07 13:25:43.497195
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-04-07 13:25:43.499856
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-04-07 13:25:43.520569
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-04-07 13:25:43.523614
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-04-07 13:25:43.527212
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-04-07 13:25:43.529597
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-04-07 13:25:43.533512
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-04-07 13:25:43.536031
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-04-07 13:25:43.540267
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-04-07 13:25:43.552183
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-04-07 13:25:43.560446
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-04-07 13:25:43.563055
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-04-07 13:25:43.565695
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-04-07 13:25:43.568373
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-04-07 13:25:43.570602
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-04-07 13:25:43.572577
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-04-07 13:25:43.574543
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-04-07 13:25:43.576597
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-04-07 13:25:43.578735
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-04-07 13:25:43.580717
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-04-07 13:25:43.582744
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-04-07 13:25:43.58484
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-04-07 13:25:43.587359
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-04-07 13:25:43.589584
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-04-07 13:25:43.591608
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-04-07 13:25:43.594455
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-04-07 13:25:43.602928
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-04-07 13:25:43.604955
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-04-07 13:25:43.606998
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-04-07 13:25:43.608891
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-04-07 13:25:43.610797
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-04-07 13:25:43.612761
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-04-07 13:25:43.615943
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-04-07 13:25:43.626096
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-04-07 13:25:43.628869
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-04-07 13:25:43.6316
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-04-07 13:25:43.644517
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-04-07 13:25:43.647832
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-04-07 13:25:43.792484
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-04-07 13:25:43.793985
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-04-07 13:25:43.803133
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-04-07 13:25:43.804889
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-04-07 13:25:43.806194
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-07 13:25:43.813668
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-07 13:25:43.816103
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-04-07 13:25:43.809409
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-05-12 12:42:48.401552
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-05-12 12:42:48.416137
\.


--
-- TOC entry 4686 (class 0 OID 17245)
-- Dependencies: 385
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- TOC entry 4687 (class 0 OID 17294)
-- Dependencies: 386
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- TOC entry 4688 (class 0 OID 17308)
-- Dependencies: 387
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- TOC entry 4691 (class 0 OID 17377)
-- Dependencies: 390
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4692 (class 0 OID 17541)
-- Dependencies: 393
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name, created_by, idempotency_key, rollback) FROM stdin;
20260407144746	{"\nCREATE EXTENSION IF NOT EXISTS \\"uuid-ossp\\";\nCREATE EXTENSION IF NOT EXISTS pgcrypto;\n"}	phase_01_extensions	jpender95@gmail.com	\N	\N
20260407144756	{"\nCREATE TABLE public.users (\n  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\n  email       TEXT,\n  phone       TEXT,\n  language    TEXT DEFAULT 'en',\n  created_at  TIMESTAMPTZ DEFAULT NOW(),\n  updated_at  TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE public.profiles (\n  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id                 UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,\n  first_name              TEXT,\n  last_name               TEXT,\n  date_of_birth           DATE,\n  phone                   TEXT,\n  email                   TEXT,\n  language_preference     TEXT DEFAULT 'en',\n  street_address          TEXT,\n  city                    TEXT,\n  state                   TEXT DEFAULT 'GA',\n  zip_code                TEXT,\n  housing_situation       TEXT,\n  monthly_rent            NUMERIC(10,2),\n  monthly_utilities       NUMERIC(10,2),\n  landlord_name           TEXT,\n  eviction_notice         BOOLEAN DEFAULT FALSE,\n  gross_monthly_income    NUMERIC(10,2),\n  income_sources          TEXT[],\n  employment_status       TEXT,\n  employer_name           TEXT,\n  other_household_income  BOOLEAN DEFAULT FALSE,\n  household_size          INTEGER,\n  num_children_under18    INTEGER,\n  children_dobs           DATE[],\n  child_disability        BOOLEAN DEFAULT FALSE,\n  pregnant                BOOLEAN DEFAULT FALSE,\n  marital_status          TEXT,\n  other_adults            BOOLEAN DEFAULT FALSE,\n  needs_childcare         BOOLEAN DEFAULT FALSE,\n  has_health_insurance    BOOLEAN DEFAULT FALSE,\n  immigration_status      TEXT,\n  legal_issues            TEXT[],\n  urgency_level           TEXT,\n  has_savings             BOOLEAN DEFAULT FALSE,\n  domestic_violence       BOOLEAN DEFAULT FALSE,\n  created_at              TIMESTAMPTZ DEFAULT NOW(),\n  updated_at              TIMESTAMPTZ DEFAULT NOW(),\n  CONSTRAINT one_profile_per_user UNIQUE (user_id)\n);\n"}	phase_02_users_profiles	jpender95@gmail.com	\N	\N
20260407144806	{"\nCREATE TABLE public.programs (\n  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  program_name          TEXT NOT NULL,\n  also_known_as         TEXT,\n  program_type          TEXT NOT NULL,\n  administering_agency  TEXT NOT NULL,\n  agency_phone          TEXT,\n  agency_website        TEXT,\n  apply_url             TEXT,\n  eligibility_summary   TEXT,\n  income_limit_pct_fpl  NUMERIC(5,2),\n  income_limit_pct_smi  NUMERIC(5,2),\n  asset_limit           NUMERIC(10,2),\n  lifetime_limit_months INTEGER,\n  work_requirement_hrs  INTEGER,\n  renewal_period        TEXT,\n  counties_served       TEXT[],\n  languages_available   TEXT[],\n  waitlist_status       TEXT DEFAULT 'open',\n  waitlist_notes        TEXT,\n  last_verified_date    DATE,\n  source_url            TEXT,\n  created_at            TIMESTAMPTZ DEFAULT NOW(),\n  updated_at            TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE public.income_thresholds (\n  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  program_id      UUID NOT NULL REFERENCES public.programs(id) ON DELETE CASCADE,\n  household_size  INTEGER NOT NULL,\n  income_limit    NUMERIC(10,2),\n  income_limit_yr NUMERIC(10,2),\n  benefit_amount  NUMERIC(10,2),\n  co_pay          NUMERIC(10,2),\n  notes           TEXT,\n  created_at      TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE public.documents_required (\n  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  program_id      UUID NOT NULL REFERENCES public.programs(id) ON DELETE CASCADE,\n  document_name   TEXT NOT NULL,\n  description     TEXT,\n  required        BOOLEAN DEFAULT TRUE,\n  conditional_on  TEXT,\n  created_at      TIMESTAMPTZ DEFAULT NOW()\n);\n"}	phase_03_programs	jpender95@gmail.com	\N	\N
20260407144813	{"\nCREATE TABLE public.organizations (\n  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  org_name            TEXT NOT NULL,\n  category            TEXT NOT NULL,\n  purpose             TEXT,\n  phone               TEXT,\n  crisis_line         TEXT,\n  email               TEXT,\n  website             TEXT,\n  address             TEXT,\n  city                TEXT DEFAULT 'Atlanta',\n  state               TEXT DEFAULT 'GA',\n  zip_code            TEXT,\n  counties_served     TEXT[],\n  populations_served  TEXT[],\n  languages_served    TEXT[],\n  intake_process      TEXT,\n  hours_of_operation  TEXT,\n  flag_dv             BOOLEAN DEFAULT FALSE,\n  flag_eviction       BOOLEAN DEFAULT FALSE,\n  flag_children_u5    BOOLEAN DEFAULT FALSE,\n  flag_pregnant       BOOLEAN DEFAULT FALSE,\n  flag_student        BOOLEAN DEFAULT FALSE,\n  flag_immigrant      BOOLEAN DEFAULT FALSE,\n  flag_no_childcare   BOOLEAN DEFAULT FALSE,\n  dv_safety_mode      BOOLEAN DEFAULT FALSE,\n  partner_tier        TEXT,\n  last_verified_date  DATE,\n  source_url          TEXT,\n  active              BOOLEAN DEFAULT TRUE,\n  created_at          TIMESTAMPTZ DEFAULT NOW(),\n  updated_at          TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE public.org_services (\n  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  org_id          UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\n  service_type    TEXT NOT NULL,\n  notes           TEXT,\n  created_at      TIMESTAMPTZ DEFAULT NOW()\n);\n"}	phase_04_organizations	jpender95@gmail.com	\N	\N
20260407144818	{"\nCREATE TABLE public.application_guides (\n  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  program_id      UUID REFERENCES public.programs(id),\n  guide_name      TEXT NOT NULL,\n  overview        TEXT,\n  apply_url       TEXT,\n  phone           TEXT,\n  last_verified   DATE,\n  source_url      TEXT,\n  created_at      TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE public.guide_steps (\n  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  guide_id        UUID NOT NULL REFERENCES public.application_guides(id) ON DELETE CASCADE,\n  step_number     INTEGER NOT NULL,\n  title           TEXT NOT NULL,\n  description     TEXT NOT NULL,\n  plain_english   TEXT,\n  tip             TEXT,\n  url             TEXT,\n  created_at      TIMESTAMPTZ DEFAULT NOW()\n);\n"}	phase_05_application_guides	jpender95@gmail.com	\N	\N
20260407145801	{"\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for SNAP (Food Stamps) in Georgia',\n  'SNAP gives you a monthly EBT card to buy groceries. The whole process takes about 2–4 weeks from application to receiving your card. You can apply online in under 30 minutes.',\n  'gateway.ga.gov',\n  '(877) 423-4746',\n  '2026-04-01',\n  'dfcs.georgia.gov/services/snap'\nFROM public.programs p WHERE p.program_name = 'Supplemental Nutrition Assistance Program';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for WIC in Georgia',\n  'WIC gives you a monthly eWIC card to buy nutritious food. If you are pregnant, nursing, or have a child under 5, you likely qualify. The appointment takes about an hour.',\n  'gateway.ga.gov',\n  '(800) 228-9173',\n  '2026-04-01',\n  'dph.georgia.gov/WIC'\nFROM public.programs p WHERE p.program_name = 'Women Infants and Children';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for CAPS (Childcare Assistance) in Georgia',\n  'CAPS helps pay for childcare so you can work, go to school, or train for a job. Apply online and a CAPS staff member will call you within 30 days.',\n  'gateway.ga.gov',\n  '(877) 255-4254',\n  '2026-04-01',\n  'caps.decal.ga.gov'\nFROM public.programs p WHERE p.program_name = 'Childcare and Parent Services';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for TANF (Cash Assistance) in Georgia',\n  'TANF provides monthly cash on your EBT card for families with children. It has strict income limits and a 48-month lifetime limit — use it as a bridge while building toward stable income.',\n  'gateway.ga.gov',\n  '(877) 423-4746',\n  '2026-04-01',\n  'dfcs.georgia.gov/services/temporary-assistance-needy-families'\nFROM public.programs p WHERE p.program_name = 'Temporary Assistance for Needy Families';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for Section 8 (Housing Voucher) in Georgia',\n  'Section 8 caps your rent at 30% of your income. The waitlist is currently closed in most areas — this guide explains how to get on lists when they open and what to do in the meantime.',\n  'atlantahousing.org',\n  '(404) 892-4700',\n  '2026-04-01',\n  'dca.georgia.gov/housing-choice-voucher'\nFROM public.programs p WHERE p.program_name = 'Housing Choice Voucher Program';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for Georgia Medicaid',\n  'Georgia Medicaid covers doctor visits, prescriptions, and hospital care at little or no cost. Pregnant women and children have the broadest eligibility. Apply online through Georgia Gateway.',\n  'gateway.ga.gov',\n  '(877) 423-4746',\n  '2026-04-01',\n  'medicaid.georgia.gov'\nFROM public.programs p WHERE p.program_name = 'Georgia Medicaid';\n"}	phase_15a_application_guides_seed	jpender95@gmail.com	\N	\N
20260407144826	{"\nCREATE TABLE public.results (\n  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id           UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,\n  program_id        UUID REFERENCES public.programs(id),\n  org_id            UUID REFERENCES public.organizations(id),\n  match_type        TEXT,\n  eligibility       TEXT,\n  estimated_benefit NUMERIC(10,2),\n  match_reason      TEXT,\n  ai_rank           INTEGER,\n  created_at        TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE public.applications (\n  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,\n  program_id      UUID REFERENCES public.programs(id),\n  status          TEXT DEFAULT 'not_started',\n  submitted_at    TIMESTAMPTZ,\n  notes           TEXT,\n  pdf_generated   BOOLEAN DEFAULT FALSE,\n  created_at      TIMESTAMPTZ DEFAULT NOW(),\n  updated_at      TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE public.appointments (\n  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id           UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,\n  org_id            UUID REFERENCES public.organizations(id),\n  agency_name       TEXT,\n  appointment_date  TIMESTAMPTZ,\n  notes             TEXT,\n  created_at        TIMESTAMPTZ DEFAULT NOW()\n);\n\nCREATE TABLE public.reminders (\n  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,\n  program_id      UUID REFERENCES public.programs(id),\n  program_name    TEXT,\n  renewal_date    DATE NOT NULL,\n  reminder_date   DATE,\n  dismissed       BOOLEAN DEFAULT FALSE,\n  created_at      TIMESTAMPTZ DEFAULT NOW()\n);\n"}	phase_06_user_activity	jpender95@gmail.com	\N	\N
20260407144836	{"\nALTER TABLE public.users        ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.profiles     ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.results      ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.reminders    ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.programs              ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.organizations         ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.income_thresholds     ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.documents_required    ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.org_services          ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.application_guides    ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.guide_steps           ENABLE ROW LEVEL SECURITY;\n\nCREATE POLICY user_own_profile ON public.profiles\n  FOR ALL USING (auth.uid() = user_id);\n\nCREATE POLICY user_own_results ON public.results\n  FOR ALL USING (auth.uid() = user_id);\n\nCREATE POLICY user_own_applications ON public.applications\n  FOR ALL USING (auth.uid() = user_id);\n\nCREATE POLICY user_own_appointments ON public.appointments\n  FOR ALL USING (auth.uid() = user_id);\n\nCREATE POLICY user_own_reminders ON public.reminders\n  FOR ALL USING (auth.uid() = user_id);\n\nCREATE POLICY public_read_programs ON public.programs\n  FOR SELECT TO authenticated USING (true);\n\nCREATE POLICY public_read_organizations ON public.organizations\n  FOR SELECT TO authenticated USING (true);\n\nCREATE POLICY public_read_thresholds ON public.income_thresholds\n  FOR SELECT TO authenticated USING (true);\n\nCREATE POLICY public_read_doc_required ON public.documents_required\n  FOR SELECT TO authenticated USING (true);\n\nCREATE POLICY public_read_org_services ON public.org_services\n  FOR SELECT TO authenticated USING (true);\n\nCREATE POLICY public_read_guides ON public.application_guides\n  FOR SELECT TO authenticated USING (true);\n\nCREATE POLICY public_read_steps ON public.guide_steps\n  FOR SELECT TO authenticated USING (true);\n\nREVOKE SELECT (domestic_violence) ON public.profiles FROM authenticated;\nGRANT  SELECT (domestic_violence) ON public.profiles TO service_role;\n\nCREATE OR REPLACE FUNCTION get_my_dv_flag()\nRETURNS BOOLEAN\nLANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n  RETURN (SELECT domestic_violence FROM public.profiles WHERE user_id = auth.uid());\nEND;\n$$;\n"}	phase_07_rls	jpender95@gmail.com	\N	\N
20260407144904	{"\nINSERT INTO public.programs (program_name, also_known_as, program_type, administering_agency, agency_phone, agency_website, apply_url, income_limit_pct_fpl, asset_limit, renewal_period, counties_served, languages_available, waitlist_status, eligibility_summary, last_verified_date, source_url)\nVALUES\n('Supplemental Nutrition Assistance Program', 'SNAP / Food Stamps', 'food', 'Georgia Division of Family & Children Services (DFCS)', '(877) 423-4746', 'dfcs.georgia.gov/services/snap', 'gateway.ga.gov', 130, 2750, '6 months', ARRAY['statewide'], ARRAY['en','es'], 'open', 'Monthly food benefits via EBT card for households earning up to 130% of the Federal Poverty Level. Asset limit $2,750.', '2026-04-01', 'dfcs.georgia.gov/services/snap'),\n\n('Women Infants and Children', 'WIC', 'food', 'Georgia Department of Public Health (DPH)', '(800) 228-9173', 'dph.georgia.gov/WIC', 'gateway.ga.gov', 185, NULL, '6 months', ARRAY['statewide'], ARRAY['en','es'], 'open', 'Nutritious foods via eWIC card for pregnant women, new moms up to 6 months postpartum, breastfeeding mothers up to 12 months, and children under 5. Already on SNAP, Medicaid, or TANF? You automatically qualify.', '2026-04-01', 'dph.georgia.gov/WIC'),\n\n('Temporary Assistance for Needy Families', 'TANF', 'cash', 'Georgia Division of Family & Children Services (DFCS)', '(877) 423-4746', 'dfcs.georgia.gov/services/temporary-assistance-needy-families', 'gateway.ga.gov', NULL, 1000, '12 months', ARRAY['statewide'], ARRAY['en','es'], 'open', 'Monthly cash assistance for families with children under 18. Must cooperate with child support services. 48-month lifetime limit. 30 hrs/week work requirement.', '2026-04-01', 'dfcs.georgia.gov/services/temporary-assistance-needy-families'),\n\n('Childcare and Parent Services', 'CAPS', 'childcare', 'Georgia Department of Early Care and Learning (DECAL)', '(877) 255-4254', 'caps.decal.ga.gov', 'gateway.ga.gov', NULL, NULL, 'annual', ARRAY['statewide'], ARRAY['en','es'], 'open', 'Financial help paying for childcare at any Quality Rated provider. Child must be 12 or under. Parent must be working, in school, or in training. Income limit approximately 50% of State Median Income — verify current thresholds at caps.decal.ga.gov.', '2026-04-01', 'caps.decal.ga.gov'),\n\n('Housing Choice Voucher Program', 'Section 8', 'housing', 'Georgia Department of Community Affairs (DCA) / Local Housing Authorities', NULL, 'dca.georgia.gov/housing-choice-voucher', 'atlantahousing.org', NULL, NULL, 'annual', ARRAY['Fulton','DeKalb','Gwinnett','Cobb'], ARRAY['en'], 'closed', 'Rent subsidy capping your rent at 30% of your income. Income must be below 50% of Area Median Income. Criminal background check required.', '2026-04-01', 'dca.georgia.gov/housing-choice-voucher'),\n\n('Georgia Medicaid', 'Medicaid / PeachCare', 'healthcare', 'Georgia Department of Community Health (DCH)', '(800) 869-1150', 'medicaid.georgia.gov', 'gateway.ga.gov', NULL, NULL, 'annual', ARRAY['statewide'], ARRAY['en','es'], 'open', 'Free or low-cost health coverage. Pregnant women qualify up to 220% FPL. Children (PeachCare) up to 247% FPL. Adults through Georgia Pathways up to 100% FPL with 80 hrs/month qualifying activity. Georgia has NOT expanded Medicaid under the ACA.', '2026-04-01', 'medicaid.georgia.gov'),\n\n('Low-Income Home Energy Assistance Program', 'LIHEAP', 'housing', 'Georgia Division of Family & Children Services (DFCS)', '(877) 423-4746', 'dfcs.georgia.gov/services/low-income-home-energy-assistance-program-liheap', 'Local DFCS office', NULL, NULL, 'annual', ARRAY['statewide'], ARRAY['en','es'], 'open', 'One-time annual payment directly to your utility company for heating or cooling costs. Income must be at or below 60% of State Median Income. Heating assistance opens December 1 annually.', '2026-04-01', 'dfcs.georgia.gov/services/low-income-home-energy-assistance-program-liheap'),\n\n('Child Support Services', 'DCSS', 'legal', 'Georgia Division of Child Support Services (DCSS)', '(877) 423-4746', 'childsupport.georgia.gov', 'services.georgia.gov/dhr/cspp', NULL, NULL, NULL, ARRAY['statewide'], ARRAY['en','es'], 'open', 'Free if receiving TANF or Medicaid. $25 fee for others. Establishes paternity, creates child support orders, enforces payment. TANF recipients must cooperate unless there is good cause such as domestic violence.', '2026-04-01', 'childsupport.georgia.gov');\n"}	phase_08a_seed_programs	jpender95@gmail.com	\N	\N
20260407144917	{"\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit, benefit_amount)\nSELECT id, 1, 1632, 292  FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program' UNION ALL\nSELECT id, 2, 2215, 536  FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program' UNION ALL\nSELECT id, 3, 2798, 768  FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program' UNION ALL\nSELECT id, 4, 3381, 975  FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program';\n\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit, benefit_amount)\nSELECT id, 1, 435, 155  FROM public.programs WHERE program_name = 'Temporary Assistance for Needy Families' UNION ALL\nSELECT id, 2, 569, 235  FROM public.programs WHERE program_name = 'Temporary Assistance for Needy Families' UNION ALL\nSELECT id, 3, 784, 280  FROM public.programs WHERE program_name = 'Temporary Assistance for Needy Families' UNION ALL\nSELECT id, 4, 958, 330  FROM public.programs WHERE program_name = 'Temporary Assistance for Needy Families';\n\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit_yr)\nSELECT id, 1, 26973 FROM public.programs WHERE program_name = 'Women Infants and Children' UNION ALL\nSELECT id, 2, 36482 FROM public.programs WHERE program_name = 'Women Infants and Children' UNION ALL\nSELECT id, 3, 45991 FROM public.programs WHERE program_name = 'Women Infants and Children' UNION ALL\nSELECT id, 4, 55500 FROM public.programs WHERE program_name = 'Women Infants and Children';\n\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit_yr, notes)\nSELECT id, 1, 34549, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program' UNION ALL\nSELECT id, 2, 45127, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program' UNION ALL\nSELECT id, 3, 55705, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program' UNION ALL\nSELECT id, 4, 66283, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program' UNION ALL\nSELECT id, 5, 77071, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program';\n\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit_yr, notes)\nSELECT id, 1, 26000, 'CAPS ~50% SMI — verify annually with DECAL at caps.decal.ga.gov' FROM public.programs WHERE program_name = 'Childcare and Parent Services' UNION ALL\nSELECT id, 2, 34000, 'CAPS ~50% SMI — verify annually with DECAL at caps.decal.ga.gov' FROM public.programs WHERE program_name = 'Childcare and Parent Services' UNION ALL\nSELECT id, 3, 42000, 'CAPS ~50% SMI — verify annually with DECAL at caps.decal.ga.gov' FROM public.programs WHERE program_name = 'Childcare and Parent Services' UNION ALL\nSELECT id, 4, 51000, 'CAPS ~50% SMI — verify annually with DECAL at caps.decal.ga.gov' FROM public.programs WHERE program_name = 'Childcare and Parent Services';\n"}	phase_08b_seed_income_thresholds	jpender95@gmail.com	\N	\N
20260407144955	{"\nINSERT INTO public.organizations (org_name, category, phone, crisis_line, email, website, city, counties_served, populations_served, languages_served, flag_dv, flag_eviction, flag_children_u5, flag_pregnant, flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode, partner_tier, active, last_verified_date, source_url)\nVALUES\n('The Drake House', 'housing', '(770) 587-4712', NULL, 'info@thedrakehouse.org', 'thedrakehouse.org', 'Roswell', ARRAY['North Fulton'], ARRAY['single_mothers','children'], ARRAY['en'], false, false, false, false, false, false, false, false, 'Tier 2: Distribution Partner', true, '2026-04-01', 'thedrakehouse.org'),\n\n('Sonya''s House', 'housing', '(470) 486-3109', NULL, NULL, 'sonyashouse.com', 'Duluth', ARRAY['Fulton'], ARRAY['single_mothers','children'], ARRAY['en'], false, false, true, false, false, false, true, false, 'Tier 1: Beta Partner', true, '2026-04-01', 'sonyashouse.com'),\n\n('Atlanta Mission: My Sister''s House', 'housing', '(404) 367-2465', NULL, NULL, 'atlantamission.org', 'Atlanta', ARRAY['Fulton'], ARRAY['single_mothers','children','dv_survivors'], ARRAY['en'], false, false, false, false, false, false, false, false, 'Tier 1: Beta Partner', true, '2026-04-01', 'atlantamission.org'),\n\n('Our House', 'housing', '(404) 522-6056', NULL, NULL, 'ourhousega.org', 'Atlanta', ARRAY['Fulton'], ARRAY['single_mothers','children'], ARRAY['en'], false, false, true, false, false, false, false, false, NULL, true, '2026-04-01', 'ourhousega.org'),\n\n('Nicholas House', 'housing', '(404) 622-0793', NULL, 'intake@nicholashouse.org', 'nicholashouse.org', 'Atlanta', ARRAY['Fulton','DeKalb'], ARRAY['single_mothers','children'], ARRAY['en'], false, true, false, false, false, false, false, false, NULL, true, '2026-04-01', 'nicholashouse.org'),\n\n('SPARC - Single Parent Alliance & Resource Center', 'wraparound', '(678) 964-7209', NULL, 'info@singleparent411.org', 'singleparent411.org', 'Atlanta', ARRAY['Fulton','DeKalb','Gwinnett','Cobb'], ARRAY['single_mothers'], ARRAY['en'], false, false, false, false, false, false, false, false, 'Tier 1: Beta Partner', true, '2026-04-01', 'singleparent411.org'),\n\n('Helping Mamas', 'food', '(770) 985-8010', NULL, 'info@helpingmamas.org', 'helpingmamas.org', 'Duluth', ARRAY['statewide'], ARRAY['single_mothers','children'], ARRAY['en'], false, false, true, false, false, false, false, false, 'Tier 2: Distribution Partner', true, '2026-04-01', 'helpingmamas.org'),\n\n('Nana Grants', 'childcare', NULL, NULL, NULL, 'nanagrants.org', 'Atlanta', ARRAY['statewide'], ARRAY['single_mothers','student_parents'], ARRAY['en'], false, false, false, false, true, false, true, false, NULL, true, '2026-04-01', 'nanagrants.org'),\n\n('Hosea Helps', 'food', '(404) 373-5705', NULL, NULL, '4hosea.org', 'Atlanta', ARRAY['Fulton'], ARRAY['single_mothers'], ARRAY['en'], false, true, false, false, false, false, false, false, NULL, true, '2026-04-01', '4hosea.org'),\n\n('H.O.P.E. Inc. (HOPBE)', 'wraparound', '(678) 695-6688', NULL, NULL, 'hopbe.org', 'Atlanta', ARRAY['Fulton','DeKalb'], ARRAY['single_mothers','student_parents'], ARRAY['en'], false, false, false, false, true, false, false, false, NULL, true, '2026-04-01', 'hopbe.org'),\n\n('WIT Single Mothers'' Program', 'workforce', NULL, NULL, NULL, 'mywit.org', 'Atlanta', ARRAY['Fulton','DeKalb'], ARRAY['single_mothers'], ARRAY['en'], false, false, false, false, true, false, false, false, NULL, true, '2026-04-01', 'mywit.org'),\n\n('Urban League of Greater Atlanta', 'workforce', '(404) 659-1150', NULL, NULL, 'ulgatl.org', 'Atlanta', ARRAY['Fulton','DeKalb'], ARRAY['single_mothers'], ARRAY['en'], false, false, false, false, false, false, false, false, 'Tier 1: Beta Partner', true, '2026-04-01', 'ulgatl.org'),\n\n('Dress for Success Atlanta', 'workforce', '(404) 589-1177', NULL, 'admin@dfsatlanta.org', 'dressforsuccessatlanta.org', 'Atlanta', ARRAY['Fulton'], ARRAY['single_mothers'], ARRAY['en'], false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'dressforsuccessatlanta.org'),\n\n('Partnership Against Domestic Violence (PADV)', 'health', NULL, '(404) 873-1766', NULL, 'padv.org', 'Atlanta', ARRAY['Fulton','DeKalb','Cobb'], ARRAY['single_mothers','dv_survivors','children'], ARRAY['en','es'], true, false, false, false, false, false, false, true, 'Tier 1: Beta Partner', true, '2026-04-01', 'padv.org'),\n\n('Atlanta Legal Aid Society', 'legal', '(404) 524-5811', NULL, NULL, 'atlantalegalaid.org', 'Atlanta', ARRAY['Fulton','DeKalb','Gwinnett','Clayton','Cobb'], ARRAY['single_mothers','dv_survivors'], ARRAY['en','es'], true, true, false, false, false, false, false, false, NULL, true, '2026-04-01', 'atlantalegalaid.org'),\n\n('Center for Black Women''s Wellness (CBWW)', 'health', '(404) 688-9202', NULL, 'info@cbww.org', 'cbww.org', 'Atlanta', ARRAY['Fulton','DeKalb'], ARRAY['single_mothers','pregnant_women'], ARRAY['en'], false, false, false, true, false, false, false, false, 'Tier 2: Distribution Partner', true, '2026-04-01', 'cbww.org'),\n\n('Tapestri', 'health', '(404) 299-2185', NULL, NULL, 'tapestri.org', 'Atlanta', ARRAY['statewide'], ARRAY['dv_survivors','immigrants','refugees'], ARRAY['en','es'], true, false, false, false, false, true, false, true, NULL, true, '2026-04-01', 'tapestri.org'),\n\n('Atlanta Community Food Bank (ACFB)', 'food', '(404) 892-9822', NULL, NULL, 'acfb.org', 'Atlanta', ARRAY['statewide'], ARRAY['single_mothers','children'], ARRAY['en','es'], false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'acfb.org'),\n\n('Atlanta Legal Aid Society (AVLF)', 'legal', '(404) 521-0790', NULL, NULL, 'avlf.org', 'Atlanta', ARRAY['Fulton','DeKalb'], ARRAY['single_mothers','dv_survivors'], ARRAY['en'], true, true, false, false, false, false, false, false, NULL, true, '2026-04-01', 'avlf.org'),\n\n('Center for Pan Asian Community Services (CPACS)', 'immigration', '(770) 936-0969', NULL, NULL, 'cpacs.org', 'Atlanta', ARRAY['statewide'], ARRAY['immigrants'], ARRAY['en','ko','vi'], false, false, false, false, false, true, false, false, NULL, true, '2026-04-01', 'cpacs.org'),\n\n('Latin American Association', 'immigration', '(404) 638-1800', NULL, NULL, 'thelaa.org', 'Atlanta', ARRAY['Fulton','DeKalb','Gwinnett'], ARRAY['immigrants'], ARRAY['en','es'], false, false, false, false, false, true, false, false, NULL, true, '2026-04-01', 'thelaa.org'),\n\n('WorkSource Atlanta', 'workforce', NULL, NULL, NULL, 'worksourceatlanta.org', 'Atlanta', ARRAY['Fulton'], ARRAY['single_mothers'], ARRAY['en'], false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'worksourceatlanta.org'),\n\n('BCM Georgia', 'health', NULL, NULL, NULL, 'bcmgeorgia.org', 'Atlanta', ARRAY['Fulton','DeKalb'], ARRAY['single_mothers'], ARRAY['en'], false, true, false, false, false, false, false, false, NULL, true, '2026-04-01', 'bcmgeorgia.org'),\n\n('Georgia Crisis & Access Line', 'health', NULL, '(800) 715-4225', NULL, NULL, 'Atlanta', ARRAY['statewide'], ARRAY['single_mothers'], ARRAY['en'], false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', NULL),\n\n('Georgia HOPE', 'health', NULL, NULL, NULL, 'gahope.org', 'Atlanta', ARRAY['statewide'], ARRAY['single_mothers'], ARRAY['en'], false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'gahope.org');\n"}	phase_09_seed_organizations	jpender95@gmail.com	\N	\N
20260407145005	{"\nCREATE VIEW public.partner_analytics AS\nSELECT\n  DATE_TRUNC('month', r.created_at)   AS month,\n  p.program_name,\n  p.program_type,\n  pr.zip_code,\n  COUNT(DISTINCT r.user_id)            AS mothers_matched,\n  COUNT(DISTINCT a.id)\n    FILTER (WHERE a.status = 'submitted') AS applications_submitted,\n  COUNT(DISTINCT a.id)\n    FILTER (WHERE a.status = 'approved')  AS applications_approved\nFROM public.results r\nJOIN public.programs p    ON r.program_id = p.id\nJOIN public.profiles pr   ON r.user_id    = pr.user_id\nLEFT JOIN public.applications a\n  ON a.user_id = r.user_id AND a.program_id = r.program_id\nGROUP BY 1, 2, 3, 4\nORDER BY 1 DESC, 5 DESC;\n\nCREATE VIEW public.program_stats AS\nSELECT\n  p.program_name,\n  p.program_type,\n  COUNT(DISTINCT r.user_id)              AS total_mothers_matched,\n  COUNT(DISTINCT a.id)\n    FILTER (WHERE a.status = 'submitted') AS total_applications,\n  COUNT(DISTINCT a.id)\n    FILTER (WHERE a.status = 'approved')  AS total_approvals\nFROM public.results r\nJOIN public.programs p ON r.program_id = p.id\nLEFT JOIN public.applications a\n  ON a.user_id = r.user_id AND a.program_id = r.program_id\nGROUP BY p.id, p.program_name, p.program_type\nORDER BY total_mothers_matched DESC;\n"}	phase_10_analytics_views	jpender95@gmail.com	\N	\N
20260407145016	{"\nCREATE OR REPLACE FUNCTION get_eligible_programs(p_user_id UUID)\nRETURNS TABLE (\n  program_id        UUID,\n  program_name      TEXT,\n  program_type      TEXT,\n  eligibility       TEXT,\n  estimated_benefit NUMERIC,\n  apply_url         TEXT\n)\nLANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n  v_income     NUMERIC;\n  v_hh_size    INTEGER;\n  v_pregnant   BOOLEAN;\n  v_children   INTEGER;\n  v_childcare  BOOLEAN;\nBEGIN\n  SELECT gross_monthly_income, household_size, pregnant,\n         num_children_under18, needs_childcare\n  INTO v_income, v_hh_size, v_pregnant, v_children, v_childcare\n  FROM public.profiles WHERE user_id = p_user_id;\n\n  RETURN QUERY\n  SELECT\n    prog.id,\n    prog.program_name,\n    prog.program_type,\n    CASE\n      WHEN v_income <= it.income_limit THEN 'likely_eligible'\n      WHEN v_income <= it.income_limit * 1.1 THEN 'possibly_eligible'\n      ELSE 'ineligible'\n    END AS eligibility,\n    it.benefit_amount,\n    prog.apply_url\n  FROM public.programs prog\n  JOIN public.income_thresholds it\n    ON it.program_id = prog.id\n    AND it.household_size = COALESCE(v_hh_size, 1)\n  WHERE\n    prog.program_name != 'Georgia Medicaid'\n    AND (prog.program_name != 'Childcare and Parent Services' OR v_childcare = TRUE)\n    AND (prog.program_name != 'Women Infants and Children' OR v_pregnant = TRUE OR v_children > 0)\n    AND it.income_limit IS NOT NULL\n  ORDER BY\n    CASE\n      WHEN v_income <= it.income_limit THEN 1\n      WHEN v_income <= it.income_limit * 1.1 THEN 2\n      ELSE 3\n    END,\n    it.benefit_amount DESC NULLS LAST;\nEND;\n$$;\n"}	phase_11_eligibility_function	jpender95@gmail.com	\N	\N
20260407145644	{"DROP FUNCTION IF EXISTS get_eligible_programs(UUID);"}	phase_13a_drop_old_eligibility_fn	jpender95@gmail.com	\N	\N
20260407145705	{"\nCREATE OR REPLACE FUNCTION get_eligible_programs(p_user_id UUID)\nRETURNS TABLE (\n  program_id        UUID,\n  program_name      TEXT,\n  program_type      TEXT,\n  eligibility       TEXT,\n  estimated_benefit NUMERIC,\n  apply_url         TEXT,\n  eligibility_note  TEXT\n)\nLANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n  v_income     NUMERIC;\n  v_hh_size    INTEGER;\n  v_pregnant   BOOLEAN;\n  v_children   INTEGER;\n  v_childcare  BOOLEAN;\n  -- 2025 FPL monthly values (source: Georgia Master Resource Database / HHS)\n  v_fpl        NUMERIC;\nBEGIN\n  SELECT gross_monthly_income, household_size, pregnant,\n         num_children_under18, needs_childcare\n  INTO v_income, v_hh_size, v_pregnant, v_children, v_childcare\n  FROM public.profiles WHERE user_id = p_user_id;\n\n  -- Monthly FPL by household size (linear extrapolation beyond 4)\n  v_fpl := CASE COALESCE(v_hh_size, 1)\n    WHEN 1 THEN 1255\n    WHEN 2 THEN 1703\n    WHEN 3 THEN 2152\n    WHEN 4 THEN 2600\n    ELSE 2600 + ((COALESCE(v_hh_size, 1) - 4) * 448)\n  END;\n\n  -- ── Standard income-threshold programs ────────────────────────────\n  RETURN QUERY\n  SELECT\n    prog.id,\n    prog.program_name,\n    prog.program_type,\n    CASE\n      WHEN v_income <= it.income_limit       THEN 'likely_eligible'\n      WHEN v_income <= it.income_limit * 1.1 THEN 'possibly_eligible'\n      ELSE 'ineligible'\n    END AS eligibility,\n    it.benefit_amount,\n    prog.apply_url,\n    NULL::TEXT AS eligibility_note\n  FROM public.programs prog\n  JOIN public.income_thresholds it\n    ON it.program_id = prog.id\n   AND it.household_size = COALESCE(v_hh_size, 1)\n  WHERE\n    prog.program_name NOT IN ('Georgia Medicaid', 'Housing Choice Voucher Program')\n    AND (prog.program_name != 'Childcare and Parent Services' OR v_childcare = TRUE)\n    AND (prog.program_name != 'Women Infants and Children'\n         OR v_pregnant = TRUE OR COALESCE(v_children, 0) > 0)\n    AND it.income_limit IS NOT NULL\n  ORDER BY\n    CASE\n      WHEN v_income <= it.income_limit       THEN 1\n      WHEN v_income <= it.income_limit * 1.1 THEN 2\n      ELSE 3\n    END,\n    it.benefit_amount DESC NULLS LAST;\n\n  -- ── Medicaid Branch 1: Pregnant → 220% FPL ────────────────────────\n  IF v_pregnant = TRUE THEN\n    RETURN QUERY\n    SELECT\n      prog.id, prog.program_name, prog.program_type,\n      CASE\n        WHEN v_income <= v_fpl * 2.20 THEN 'likely_eligible'\n        WHEN v_income <= v_fpl * 2.42 THEN 'possibly_eligible'\n        ELSE 'ineligible'\n      END,\n      NULL::NUMERIC,\n      prog.apply_url,\n      'Pregnant women qualify up to 220% FPL (Right from the Start Medicaid). Covers prenatal care, delivery, and 60 days postpartum.'\n    FROM public.programs prog\n    WHERE prog.program_name = 'Georgia Medicaid';\n  END IF;\n\n  -- ── Medicaid Branch 2: Children → PeachCare 247% FPL ─────────────\n  IF COALESCE(v_children, 0) > 0 THEN\n    RETURN QUERY\n    SELECT\n      prog.id, prog.program_name, prog.program_type,\n      CASE\n        WHEN v_income <= v_fpl * 2.47 THEN 'likely_eligible'\n        WHEN v_income <= v_fpl * 2.72 THEN 'possibly_eligible'\n        ELSE 'ineligible'\n      END,\n      NULL::NUMERIC,\n      prog.apply_url,\n      'Children (PeachCare for Kids) qualify up to 247% FPL. Low or no-cost health coverage for kids under 19.'\n    FROM public.programs prog\n    WHERE prog.program_name = 'Georgia Medicaid';\n  END IF;\n\n  -- ── Medicaid Branch 3: Adults without children → Pathways 100% FPL ─\n  IF v_pregnant IS NOT TRUE AND COALESCE(v_children, 0) = 0 THEN\n    RETURN QUERY\n    SELECT\n      prog.id, prog.program_name, prog.program_type,\n      CASE\n        WHEN v_income <= v_fpl * 1.00 THEN 'possibly_eligible'\n        ELSE 'ineligible'\n      END,\n      NULL::NUMERIC,\n      prog.apply_url,\n      'Georgia Pathways to Coverage (ages 19–64): income limit 100% FPL. Requires 80 hours/month of qualifying activity. Georgia has NOT expanded Medicaid under the ACA.'\n    FROM public.programs prog\n    WHERE prog.program_name = 'Georgia Medicaid';\n  END IF;\n\n  -- ── Housing Voucher — always surface with waitlist warning ─────────\n  RETURN QUERY\n  SELECT\n    prog.id, prog.program_name, prog.program_type,\n    CASE\n      WHEN v_income <= v_fpl * 0.50 THEN 'possibly_eligible'\n      ELSE 'ineligible'\n    END,\n    NULL::NUMERIC,\n    prog.apply_url,\n    'WAITLIST CURRENTLY CLOSED. Income limit is 50% of Area Median Income. Check atlantahousing.org for project-based openings. While waiting, contact The Drake House (770-587-4712) or Atlanta Mission (404-367-2465) for emergency housing.'\n  FROM public.programs prog\n  WHERE prog.program_name = 'Housing Choice Voucher Program';\n\nEND;\n$$;\n"}	phase_13b_medicaid_eligibility_function	jpender95@gmail.com	\N	\N
20260407145742	{"\n-- SNAP documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id,\n  unnest(ARRAY[\n    'Photo ID',\n    'Social Security Number (all household members)',\n    'Proof of citizenship or immigration status',\n    'Proof of income (last 30 days pay stubs or benefit award letters)',\n    'Proof of housing expenses (rent/mortgage statement)',\n    'Proof of utility costs',\n    'Proof of childcare expenses',\n    'Proof of Georgia residency (utility bill or lease)'\n  ]),\n  unnest(ARRAY[\n    'Driver''s license, state ID, passport, or employer/school ID',\n    'SSN card or document showing SSN for every person in your household',\n    'U.S. birth certificate, passport, or immigration documents',\n    'Pay stubs from the last 30 days, employer letter, or benefit award letters',\n    'Lease agreement or mortgage statement',\n    'Utility bills showing your name and address',\n    'Childcare receipts or provider statement',\n    'Utility bill, lease agreement, or official mail showing your Georgia address'\n  ]),\n  true,\n  NULL\nFROM public.programs p WHERE p.program_name = 'Supplemental Nutrition Assistance Program';\n\n-- WIC documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id,\n  unnest(ARRAY[\n    'Photo ID',\n    'Proof of Georgia residency',\n    'Proof of income',\n    'Proof of pregnancy or child''s birth certificate',\n    'Immunization records (children)',\n    'Proof of SNAP/Medicaid/TANF enrollment (if applicable)'\n  ]),\n  unnest(ARRAY[\n    'Driver''s license, passport, birth certificate, or school ID',\n    'Utility bill, lease agreement, or official mail',\n    'Pay stubs, tax return, or benefit award letter — or proof of SNAP/Medicaid/TANF for automatic income eligibility',\n    'Documentation of pregnancy from a healthcare provider, or child''s birth certificate',\n    'Georgia Form 3231 (Certificate of Immunization) for children',\n    'Award letter showing active SNAP, Medicaid, or TANF — automatically meets income requirement'\n  ]),\n  unnest(ARRAY[true, true, true, true, false, false]),\n  unnest(ARRAY[NULL, NULL, NULL, NULL, 'Required for children only', 'Only needed if using automatic eligibility pathway'])\nFROM public.programs p WHERE p.program_name = 'Women Infants and Children';\n\n-- TANF documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id,\n  unnest(ARRAY[\n    'Social Security Numbers (all household members)',\n    'Birth certificates for all children',\n    'Proof of income (all sources)',\n    'Proof of Georgia residency',\n    'Proof of citizenship or immigration status',\n    'Immunization records (children under 7)',\n    'Proof of school enrollment (children ages 6–18)',\n    'Information about non-custodial parent'\n  ]),\n  unnest(ARRAY[\n    'SSN card or document showing SSN for every household member',\n    'Official birth certificate for each child under 18',\n    'All income sources: wages, child support, unemployment, SNAP, etc.',\n    'Utility bill, lease agreement, or official mail',\n    'U.S. birth certificate, passport, or immigration documents',\n    'Georgia Form 3231 or doctor''s immunization record',\n    'Current school enrollment letter or report card',\n    'Name, address, and employer of the other parent if known — required to cooperate with child support unless you have a domestic violence exemption'\n  ]),\n  true,\n  NULL\nFROM public.programs p WHERE p.program_name = 'Temporary Assistance for Needy Families';\n\n-- CAPS documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id,\n  unnest(ARRAY[\n    'Proof of Georgia residency',\n    'Proof of identity',\n    'Child''s birth certificate',\n    'Proof of child''s citizenship or lawful immigrant status',\n    'Certificate of Immunization (Georgia Form 3231)',\n    'Proof of employment',\n    'Proof of school enrollment or training program'\n  ]),\n  unnest(ARRAY[\n    'Driver''s license, lease, utility bill, or motor vehicle registration',\n    'Government-issued ID for the parent or guardian',\n    'Official birth certificate for each child under 13',\n    'U.S. birth certificate, passport, or immigration documents for the child',\n    'Georgia Form 3231 showing child is up-to-date on immunizations',\n    'Pay stubs or employer letter showing current employment',\n    'School enrollment letter or training program acceptance letter'\n  ]),\n  unnest(ARRAY[true, true, true, true, true, false, false]),\n  unnest(ARRAY[NULL, NULL, NULL, NULL, NULL, 'Required if qualifying through employment', 'Required if qualifying through school or training'])\nFROM public.programs p WHERE p.program_name = 'Childcare and Parent Services';\n\n-- Section 8 documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id,\n  unnest(ARRAY[\n    'Photo ID (all adults)',\n    'Social Security Numbers (all household members)',\n    'Birth certificates for all children',\n    'Proof of income',\n    'Proof of current address',\n    'Criminal history disclosure'\n  ]),\n  unnest(ARRAY[\n    'Valid government-issued photo ID for every adult in the household',\n    'SSN card or document for every household member',\n    'Official birth certificate for each child',\n    'Pay stubs, benefit award letters, child support documentation',\n    'Current lease, utility bill, or official mail',\n    'Background check will be conducted — certain convictions may disqualify'\n  ]),\n  true,\n  NULL\nFROM public.programs p WHERE p.program_name = 'Housing Choice Voucher Program';\n\n-- Medicaid documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id,\n  unnest(ARRAY[\n    'Proof of identity',\n    'Social Security Number',\n    'Proof of Georgia residency',\n    'Proof of income (all household members)',\n    'Proof of pregnancy',\n    'Immigration status documentation'\n  ]),\n  unnest(ARRAY[\n    'Government-issued ID or birth certificate',\n    'SSN card or document',\n    'Utility bill, lease, or official mail',\n    'Pay stubs, benefit letters, or employer letter for all household members',\n    'Documentation from a healthcare provider — required for Right from the Start Medicaid',\n    'Immigration documents if not a U.S. citizen'\n  ]),\n  unnest(ARRAY[true, true, true, true, false, false]),\n  unnest(ARRAY[NULL, NULL, NULL, NULL, 'Required for pregnant women applying for RSM only', 'Required only for non-citizens'])\nFROM public.programs p WHERE p.program_name = 'Georgia Medicaid';\n\n-- LIHEAP documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id,\n  unnest(ARRAY[\n    'Proof of identity',\n    'Proof of Georgia residency',\n    'Proof of income (all household members)',\n    'Most recent utility bill',\n    'Social Security Numbers (all household members)'\n  ]),\n  unnest(ARRAY[\n    'Government-issued ID or birth certificate',\n    'Utility bill, lease, or official mail at current address',\n    'Pay stubs or benefit award letters for the last 30 days',\n    'Your most recent heating or cooling bill showing your account number and provider',\n    'SSN card or document for every household member'\n  ]),\n  true,\n  NULL\nFROM public.programs p WHERE p.program_name = 'Low-Income Home Energy Assistance Program';\n\n-- Child Support documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id,\n  unnest(ARRAY[\n    'Proof of identity',\n    'Child''s birth certificate',\n    'Information about the non-custodial parent',\n    'Proof of TANF or Medicaid enrollment (for fee waiver)',\n    'Documentation of domestic violence (if claiming good cause exemption)'\n  ]),\n  unnest(ARRAY[\n    'Government-issued ID',\n    'Official birth certificate for each child',\n    'Full name, last known address, employer, and date of birth of the other parent if known',\n    'Award letter showing active TANF or Medicaid — waives the $25 application fee',\n    'Police report, protective order, or other documentation — allows you to skip cooperating with child support if it would put you in danger'\n  ]),\n  unnest(ARRAY[true, true, true, false, false]),\n  unnest(ARRAY[NULL, NULL, NULL, 'Only needed to waive the $25 fee', 'Only needed if requesting domestic violence good cause exemption'])\nFROM public.programs p WHERE p.program_name = 'Child Support Services';\n"}	phase_14_documents_required_seed	jpender95@gmail.com	\N	\N
20260407145833	{"\nDO $$\nDECLARE\n  v_guide_id UUID;\nBEGIN\n  SELECT id INTO v_guide_id FROM public.application_guides\n  WHERE guide_name = 'How to Apply for SNAP (Food Stamps) in Georgia';\n\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_guide_id, 1, 'Check your eligibility',\n   'Visit the SNAP eligibility screener at snapscreener.com/screener/georgia to estimate whether you qualify and how much you might receive.',\n   'This free tool gives you a quick yes/no estimate before you fill out the full application. No personal information is saved.',\n   'If you are already on Medicaid, TANF, or SSI, you may qualify automatically — called categorical eligibility.',\n   'https://snapscreener.com/screener/georgia'),\n\n  (v_guide_id, 2, 'Choose how to apply',\n   'You have three options: Online at gateway.ga.gov (recommended, available Mon–Fri 5am–midnight); By phone at (877) 423-4746; or Paper application (Form 297) mailed or hand-delivered to your local DFCS office.',\n   'Online is the fastest option. You can save your progress and come back to finish later.',\n   'Online is fastest. You can save your application and come back to it.',\n   'https://gateway.ga.gov'),\n\n  (v_guide_id, 3, 'Submit your application',\n   'Your application is officially filed when DFCS receives: (1) name of head of household, (2) address, (3) date, and (4) your signature.',\n   'You do not need all your documents to submit the first form. Send what you have — you can upload the rest afterward.',\n   'You do not need all your documents to submit. Send what you have and upload the rest after.',\n   'https://gateway.ga.gov'),\n\n  (v_guide_id, 4, 'Complete the phone interview',\n   'After filing, a DFCS eligibility worker will call you. Be ready to answer questions about your household members and income, housing and utility costs, childcare expenses, and employment status.',\n   'This is just a phone call — not an in-person meeting. It usually takes 20–30 minutes.',\n   'DFCS will call from an unknown or blocked number. Answer all calls after you apply.',\n   NULL),\n\n  (v_guide_id, 5, 'Upload your documents',\n   'Upload or mail any required documents. You can upload documents directly in your Georgia Gateway account under My Account > Documents.',\n   'Take photos of your documents with your phone and upload them in the Georgia Gateway app.',\n   'Uploading documents online is faster than mailing them. DFCS receives them instantly.',\n   'https://gateway.ga.gov'),\n\n  (v_guide_id, 6, 'Get your decision',\n   'You will be notified within 30 days. If approved, your EBT card will be mailed to you. Benefits are loaded to the card monthly.',\n   'Your EBT card works like a debit card at any grocery store. You can check your balance by calling the number on the back of the card.',\n   'If denied, you have the right to appeal within 90 days. Call (877) 423-4746.',\n   NULL),\n\n  (v_guide_id, 7, 'Renew your benefits',\n   'SNAP must be renewed every 6 or 12 months. You will receive a renewal notice in the mail. Complete Form 508 or renew online at Georgia Gateway.',\n   'Mark your renewal date on your calendar. Missing the deadline means your benefits stop immediately — even if you still qualify.',\n   'Set a renewal reminder in the WiserMoms app so you never miss your deadline.',\n   'https://gateway.ga.gov');\nEND $$;\n"}	phase_15b_guide_steps_snap	jpender95@gmail.com	\N	\N
20260407145919	{"\nDO $$\nDECLARE\n  v_wic_id  UUID;\n  v_caps_id UUID;\n  v_tanf_id UUID;\nBEGIN\n\n  SELECT id INTO v_wic_id FROM public.application_guides WHERE guide_name = 'How to Apply for WIC in Georgia';\n  SELECT id INTO v_caps_id FROM public.application_guides WHERE guide_name = 'How to Apply for CAPS (Childcare Assistance) in Georgia';\n  SELECT id INTO v_tanf_id FROM public.application_guides WHERE guide_name = 'How to Apply for TANF (Cash Assistance) in Georgia';\n\n  -- WIC STEPS\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_wic_id, 1, 'Check your eligibility',\n   'Visit dph.georgia.gov/wic-eligibility-assessment. You must be pregnant, breastfeeding, postpartum (up to 6 months), or have a child under 5. Income must be at or below 185% FPL.',\n   'If you are already on SNAP, Medicaid, or TANF, you automatically meet the income requirement — no income documents needed.',\n   'Already on SNAP, Medicaid, or TANF? You skip the income check entirely.',\n   'https://dph.georgia.gov/wic-eligibility-assessment'),\n  (v_wic_id, 2, 'Find your local WIC clinic',\n   'Visit wic.ga.gov or call (800) 228-9173 to find the WIC clinic nearest to you. WIC is available at health departments, community health centers, hospitals, and DFCS offices statewide.',\n   'There are WIC clinics all over Georgia. Most can schedule you within a week.',\n   'Bring your child to the appointment — WIC staff need to take height and weight measurements.',\n   'https://wic.ga.gov'),\n  (v_wic_id, 3, 'Apply online or schedule an appointment',\n   'Start your application at gateway.ga.gov (select WIC) or call your local clinic directly to schedule an in-person appointment.',\n   'You can start online but you will need to come in for a nutrition assessment before your eWIC card is issued.',\n   NULL, 'https://gateway.ga.gov'),\n  (v_wic_id, 4, 'Attend your nutrition assessment',\n   'At your appointment, a WIC health professional will review your documents, take height and weight measurements, conduct a blood test for anemia, determine your nutritional needs, and issue your eWIC card.',\n   'The appointment usually takes about an hour. Bring all your documents.',\n   'The blood test is just a small finger prick — it checks for iron levels.',\n   NULL),\n  (v_wic_id, 5, 'Use your eWIC card',\n   'Your eWIC card works like a debit card at over 1,400 authorized WIC vendors in Georgia. Approved foods include milk, eggs, bread, cereal, juice, peanut butter, fresh fruits and vegetables, and infant formula.',\n   'Not every item on the shelf is WIC-approved. Look for the WIC shelf label or use the WIC Shopper app to check before you buy.',\n   'Download the WIC Shopper app to scan products before you put them in your cart.',\n   NULL),\n  (v_wic_id, 6, 'Renew every 6 months',\n   'Women must renew every 6 months. Children renew annually. Your WIC clinic will contact you before your benefits expire.',\n   'Mark your renewal date in the WiserMoms app. Missing it means a gap in your food benefits.',\n   'Set a renewal reminder so your eWIC card never runs out unexpectedly.',\n   NULL);\n\n  -- CAPS STEPS\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_caps_id, 1, 'Check your eligibility',\n   'Visit caps.decal.ga.gov. Key requirements: Georgia resident, child under 13, parent working/in school/in training, family income below 50% of State Median Income.',\n   'Income limits are based on your family size. The CAPS website has a table. If you are unsure, apply anyway — CAPS staff will determine eligibility.',\n   'Children with disabilities may qualify up to age 17.',\n   'https://caps.decal.ga.gov'),\n  (v_caps_id, 2, 'Apply online through Georgia Gateway',\n   'Go to gateway.ga.gov, log in or create an account, select \\"Child care\\" from the list of assistance programs, and follow the prompts.',\n   'The application asks about your work schedule, income, and your child''s information. Have your documents ready before you start.',\n   NULL, 'https://gateway.ga.gov'),\n  (v_caps_id, 3, 'Upload your documents',\n   'Upload all required documents directly in the Georgia Gateway portal. Uploading documents promptly speeds up processing significantly.',\n   'Missing documents are the #1 reason for delays. Upload everything at once if you can.',\n   'Take photos of documents with your phone and upload them right from the Gateway app.',\n   'https://gateway.ga.gov'),\n  (v_caps_id, 4, 'Wait for a call from CAPS staff',\n   'A CAPS staff member will call you to review your application and determine eligibility. Applications are processed in the order received. You will be notified within 30 calendar days.',\n   'CAPS can get busy. If you have not heard back in 30 days, call (877) 255-4254.',\n   'Answer calls from unknown numbers — CAPS staff may call from different numbers.',\n   NULL),\n  (v_caps_id, 5, 'Find a Quality Rated childcare provider',\n   'Once approved, you will be assigned a Family Support Consultant. You may enroll your child in any eligible Quality Rated child care program. Find providers at families.decal.ga.gov.',\n   'Quality Rated means the provider has been inspected and rated for safety and education quality. You can filter by ZIP code, hours, and age group.',\n   'Call your top 3 choices before visiting — some have waitlists.',\n   'https://families.decal.ga.gov'),\n  (v_caps_id, 6, 'Renew annually',\n   'You must renew your CAPS eligibility every year. Your Family Support Consultant will help you through this process.',\n   'Missing renewal means your childcare subsidy stops and you may owe the provider directly.',\n   'Set an annual renewal reminder in the WiserMoms app.',\n   NULL);\n\n  -- TANF STEPS\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_tanf_id, 1, 'Check your eligibility',\n   'TANF has very strict income and asset limits. For a family of 3 (mother + 2 children), gross income must be below $784/month and assets below $1,000. Use Georgia Gateway''s pre-screening tool.',\n   'TANF cash amounts are low — a family of 3 receives up to $280/month. It is designed as short-term help while you build toward stable income.',\n   'TANF has a 48-month lifetime limit. Consider whether you need it now or may need it more urgently later.',\n   'https://gateway.ga.gov'),\n  (v_tanf_id, 2, 'Apply through Georgia Gateway',\n   'Go to gateway.ga.gov and select \\"Apply for Benefits.\\" Choose TANF. Alternatively, call (877) 423-4746 or visit your local DFCS office.',\n   NULL, NULL, 'https://gateway.ga.gov'),\n  (v_tanf_id, 3, 'Complete the interview',\n   'A DFCS eligibility worker will conduct a phone or in-person interview to verify your information.',\n   'Bring or have ready all your documents. The worker will ask about all household income and the situation of the other parent.',\n   NULL, NULL),\n  (v_tanf_id, 4, 'Cooperate with Child Support Services',\n   'You must cooperate with the Division of Child Support Services to establish and collect child support from the non-custodial parent, unless you have good cause (such as domestic violence).',\n   'If cooperating with child support would put you in danger, tell your DFCS worker. You can request a domestic violence exemption.',\n   'If you are in a domestic violence situation, you do NOT have to cooperate with child support. Ask for the DV good cause exemption.',\n   'https://childsupport.georgia.gov'),\n  (v_tanf_id, 5, 'Meet the work requirements',\n   'You must participate in work activities or training for at least 30 hours per week. DFCS will connect you with Georgia CREW for employment services.',\n   'Georgia CREW helps with job search, job training, GED, and vocational programs. It is not just a job board — they provide real support.',\n   'Georgia CREW can count school, job training, and volunteering toward your 30 hours.',\n   'https://dfcs.georgia.gov/services/georgia-crew'),\n  (v_tanf_id, 6, 'Receive and manage your benefits',\n   'If approved, cash benefits are loaded monthly to your EBT card. Benefit amounts range from $155/month (1 person) to $330+/month (family of 4).',\n   'TANF cash can be used for anything — rent, utilities, diapers, transportation. It is your money.',\n   'TANF has a 48-month lifetime limit across all states. Keep track of how many months you have used.',\n   NULL);\n\nEND $$;\n"}	phase_15c_guide_steps_wic_caps_tanf	jpender95@gmail.com	\N	\N
20260407145953	{"\nDO $$\nDECLARE\n  v_s8_id  UUID;\n  v_mc_id  UUID;\nBEGIN\n\n  SELECT id INTO v_s8_id FROM public.application_guides WHERE guide_name = 'How to Apply for Section 8 (Housing Voucher) in Georgia';\n  SELECT id INTO v_mc_id FROM public.application_guides WHERE guide_name = 'How to Apply for Georgia Medicaid';\n\n  -- SECTION 8 STEPS\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_s8_id, 1, 'Find an open waitlist — this is the critical first step',\n   'Most Section 8 waitlists in Georgia are CLOSED. Check: Georgia DCA statewide waitlist (currently closed); Atlanta Housing Authority (check for project-based openings); DeKalb Housing Authority; Gwinnett Housing Corporation.',\n   'Waitlists open without much notice and close within days. Sign up for alerts at each housing authority website.',\n   'Set calendar reminders to check atlantahousing.org every 2 months. Waitlists can open suddenly.',\n   'https://atlantahousing.org'),\n  (v_s8_id, 2, 'Apply immediately when a waitlist opens',\n   'When a waitlist opens, apply immediately — they often close within 48–72 hours. Applications are submitted online during the open period.',\n   'You cannot apply when the waitlist is closed. All you can do is wait and watch for openings.',\n   'Bookmark atlantahousing.org, dekalbhousing.org, and gwinnetthousing.org on your phone.',\n   'https://dca.georgia.gov/housing-choice-voucher/waiting-list'),\n  (v_s8_id, 3, 'Wait — and apply for emergency housing now',\n   'Waitlists can be 2–5+ years long. While you wait, apply for emergency rental assistance through BCM Georgia, AVLF, and Hosea Helps. Contact The Drake House or Nicholas House for transitional housing.',\n   'Do not wait for Section 8 if you need housing now. Use the emergency resources in WiserMoms while your name moves up the list.',\n   'Keep your address updated with every housing authority where you applied — an outdated address means a missed voucher offer.',\n   NULL),\n  (v_s8_id, 4, 'Complete the full application when contacted',\n   'When your name comes up, you will submit a full application with all documents and undergo a criminal background check and income verification.',\n   'You will have a limited time window — usually 30 days — to submit the full application. Do not miss it.',\n   'Respond to any housing authority letters immediately. Missing their deadline means starting over.',\n   NULL),\n  (v_s8_id, 5, 'Find a housing unit',\n   'Once you receive a voucher, you have a limited time (typically 60–120 days) to find a landlord who accepts Section 8. The housing unit must pass a HUD inspection.',\n   'Not all landlords accept Section 8. Ask specifically \\"Do you accept Housing Choice Vouchers?\\" when calling about a rental.',\n   'Atlanta Legal Aid Society can help if a landlord unlawfully refuses to accept your voucher.',\n   'https://atlantalegalaid.org'),\n  (v_s8_id, 6, 'Sign your lease',\n   'The Housing Authority will pay a portion of your rent directly to the landlord. You pay the difference, which should be approximately 30% of your income.',\n   'Your portion is calculated based on your income. If your income drops, report it to the housing authority — your share goes down.',\n   'Never pay more than your assigned share. If your landlord asks for more, contact your housing authority immediately.',\n   NULL);\n\n  -- MEDICAID STEPS\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_mc_id, 1, 'Determine which category you may qualify for',\n   'Pregnant? Apply for Right from the Start Medicaid — income up to 220% FPL. Have children? Apply for PeachCare for Kids — income up to 247% FPL. Adult without children? Apply for Georgia Pathways — income up to 100% FPL with 80 hrs/month qualifying activity.',\n   'Most single mothers qualify through their children (PeachCare) or pregnancy (RSM). Adult-only Medicaid is very limited in Georgia because the state has not expanded Medicaid.',\n   'Georgia has NOT expanded Medicaid under the ACA. If you are not pregnant and have no children at home, your options are limited.',\n   'https://medicaid.georgia.gov'),\n  (v_mc_id, 2, 'Apply through Georgia Gateway',\n   'Go to gateway.ga.gov and select \\"Apply for Benefits.\\" Choose Medicaid. Alternatively, call (877) 423-4746 or visit your local DFCS office.',\n   NULL, NULL, 'https://gateway.ga.gov'),\n  (v_mc_id, 3, 'Complete the interview and provide documents',\n   'Upload or mail all required documents. A DFCS worker will review your application and may call you for additional information.',\n   'Uploading documents in Georgia Gateway is faster than mailing. You can see when DFCS receives them.',\n   'If you are pregnant, apply as soon as possible. Right from the Start Medicaid can cover you retroactively back to the month you became pregnant.',\n   'https://gateway.ga.gov'),\n  (v_mc_id, 4, 'Receive your Medicaid card',\n   'If approved, you will receive a Medicaid card in the mail. You can use it at any Medicaid-accepting provider in Georgia.',\n   'Show your Medicaid card at every doctor, dentist, pharmacy, and hospital visit. Keep it safe.',\n   'Lost your card? Call (877) 423-4746 to request a replacement.',\n   NULL),\n  (v_mc_id, 5, 'Renew annually',\n   'Medicaid must be renewed each year. You will receive a renewal notice. Respond promptly to avoid losing coverage.',\n   'If you miss the renewal, your coverage stops immediately — even mid-pregnancy or mid-treatment. Set a reminder.',\n   'Set an annual renewal reminder in the WiserMoms app. Losing Medicaid mid-pregnancy can leave you with large medical bills.',\n   'https://gateway.ga.gov');\n\nEND $$;\n"}	phase_15d_guide_steps_section8_medicaid	jpender95@gmail.com	\N	\N
20260407150032	{"\nINSERT INTO public.organizations (org_name, category, phone, crisis_line, email, website, address, city, state, counties_served, populations_served, languages_served, flag_dv, flag_eviction, flag_children_u5, flag_pregnant, flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode, partner_tier, active, last_verified_date, source_url)\nVALUES\n-- Housing & Shelter (extended)\n('Homestretch', 'housing', '(770) 642-9185', NULL, NULL, 'homestretchinc.org', NULL, 'Alpharetta', 'GA',\n ARRAY['North Fulton','Gwinnett'], ARRAY['families','children'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'homestretchinc.org'),\n\n('Sheltering Grace Ministry', 'housing', '(678) 337-7858', NULL, NULL, 'shelteringgrace.org', NULL, 'Atlanta', 'GA',\n ARRAY['statewide'], ARRAY['pregnant_women','single_mothers','children'], ARRAY['en'],\n false, false, true, true, false, false, false, false, NULL, true, '2026-04-01', 'shelteringgrace.org'),\n\n('Rainbow Village', 'housing', '(770) 497-1888', NULL, NULL, 'rainbowvillage.org', NULL, 'Duluth', 'GA',\n ARRAY['North Atlanta','Gwinnett'], ARRAY['families','children'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'rainbowvillage.org'),\n\n('Center for Family Resources', 'housing', '(770) 428-2601', NULL, NULL, 'cfr-atlanta.org', NULL, 'Marietta', 'GA',\n ARRAY['Cobb'], ARRAY['single_mothers','families','children'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'cfr-atlanta.org'),\n\n('Gateway Center', 'housing', '(404) 215-6600', NULL, NULL, 'gatewayctr.org', NULL, 'Atlanta', 'GA',\n ARRAY['Fulton'], ARRAY['single_mothers','families','men'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'gatewayctr.org'),\n\n('Right-Hand Foundations', 'housing', '(404) 952-1201', NULL, 'info@righthandfdn.org', NULL, NULL, 'Atlanta', 'GA',\n ARRAY['statewide'], ARRAY['single_mothers','children'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', NULL),\n\n('Decatur Cooperative Ministry', 'housing', '(404) 687-3500', NULL, NULL, 'decaturcm.org', NULL, 'Decatur', 'GA',\n ARRAY['DeKalb'], ARRAY['families','single_mothers'], ARRAY['en'],\n false, true, false, false, false, false, false, false, NULL, true, '2026-04-01', 'decaturcm.org'),\n\n('MUST Ministries', 'housing', '(770) 427-9862', NULL, NULL, 'mustministries.org', NULL, 'Marietta', 'GA',\n ARRAY['Cobb','Cherokee'], ARRAY['families','single_mothers'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'mustministries.org'),\n\n('Family Promise of Gwinnett', 'housing', '(678) 376-8950', NULL, NULL, 'familypromise.org', NULL, 'Lawrenceville', 'GA',\n ARRAY['Gwinnett'], ARRAY['families','children'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'familypromise.org'),\n\n('Caring Works', 'housing', '(404) 371-1230', NULL, NULL, 'caringworks.org', NULL, 'Atlanta', 'GA',\n ARRAY['Fulton','DeKalb'], ARRAY['single_mothers','families'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'caringworks.org'),\n\n('Mary Hall Freedom Village', 'housing', '(470) 260-4263', NULL, NULL, 'mhfh.org', NULL, 'Atlanta', 'GA',\n ARRAY['Fulton','DeKalb'], ARRAY['single_mothers','children'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'mhfh.org'),\n\n-- Food & Basic Needs (extended)\n('North Fulton Community Charities', 'food', '(770) 640-0399', NULL, NULL, 'nfcc.net', NULL, 'Roswell', 'GA',\n ARRAY['North Fulton'], ARRAY['single_mothers','families'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'nfcc.net'),\n\n('Community Assistance Center', 'food', '(770) 552-4015', NULL, NULL, 'ourcac.org', NULL, 'Sandy Springs', 'GA',\n ARRAY['Fulton'], ARRAY['single_mothers','families'], ARRAY['en'],\n false, true, false, false, false, false, false, false, NULL, true, '2026-04-01', 'ourcac.org'),\n\n('The Giving Kitchen', 'food', '(404) 254-1227', NULL, NULL, 'thegivingkitchen.org', NULL, 'Atlanta', 'GA',\n ARRAY['Fulton'], ARRAY['food_service_workers'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'thegivingkitchen.org'),\n\n('Furniture Bank of Metro Atlanta', 'food', '(404) 355-8530', NULL, NULL, 'furniturebankatlanta.org', NULL, 'Atlanta', 'GA',\n ARRAY['Cobb','Fulton','Gwinnett'], ARRAY['families','single_mothers'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'furniturebankatlanta.org'),\n\n('Wholesome Wave Georgia', 'food', NULL, NULL, NULL, 'wholesomewavega.org', NULL, 'Atlanta', 'GA',\n ARRAY['Fulton','DeKalb'], ARRAY['single_mothers','families'], ARRAY['en','es'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'wholesomewavega.org'),\n\n('Neighborhood Cooperative Ministry', 'food', NULL, NULL, NULL, 'neighborhoodcm.org', NULL, 'Lawrenceville', 'GA',\n ARRAY['Gwinnett'], ARRAY['single_mothers','families'], ARRAY['en','es'],\n false, true, false, false, false, true, false, false, NULL, true, '2026-04-01', 'neighborhoodcm.org'),\n\n-- Workforce (extended)\n('Goodwill of North Georgia', 'workforce', NULL, NULL, NULL, 'goodwillng.org', NULL, 'Atlanta', 'GA',\n ARRAY['statewide'], ARRAY['single_mothers','adults'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', 'goodwillng.org'),\n\n-- Legal (extended)\n('Georgia Legal Services Program', 'legal', '(404) 206-5175', NULL, NULL, 'georgialegalaid.org', NULL, 'Atlanta', 'GA',\n ARRAY['statewide'], ARRAY['single_mothers','dv_survivors'], ARRAY['en','es'],\n true, true, false, false, false, false, false, false, NULL, true, '2026-04-01', 'georgialegalaid.org'),\n\n-- DV / Health (extended)\n('LiveSafe Resources', 'health', '(770) 423-3581', NULL, NULL, 'livesaferesources.org', NULL, 'Marietta', 'GA',\n ARRAY['Cobb'], ARRAY['dv_survivors','single_mothers'], ARRAY['en'],\n true, false, false, false, false, false, false, true, NULL, true, '2026-04-01', 'livesaferesources.org'),\n\n('Cherokee Family Violence Center', 'health', '(770) 479-1804', NULL, NULL, 'cherokeefvc.org', NULL, 'Canton', 'GA',\n ARRAY['Cherokee'], ARRAY['dv_survivors','single_mothers'], ARRAY['en'],\n true, false, false, false, false, false, false, true, NULL, true, '2026-04-01', 'cherokeefvc.org'),\n\n-- Immigration (extended)\n('New American Pathways', 'immigration', '(404) 299-6099', NULL, NULL, 'newamericanpathways.org', NULL, 'Atlanta', 'GA',\n ARRAY['statewide'], ARRAY['immigrants','refugees'], ARRAY['en','es'],\n false, false, false, false, false, true, false, false, NULL, true, '2026-04-01', 'newamericanpathways.org'),\n\n('Raksha', 'immigration', '(404) 876-0670', NULL, NULL, 'raksha.org', NULL, 'Atlanta', 'GA',\n ARRAY['statewide'], ARRAY['immigrants','dv_survivors'], ARRAY['en','hi','bn','ur'],\n true, false, false, false, false, true, false, true, NULL, true, '2026-04-01', 'raksha.org'),\n\n('Georgia Asylum & Immigration Network (GAIN)', 'immigration', '(678) 335-6040', NULL, NULL, 'georgiaasylum.org', NULL, 'Atlanta', 'GA',\n ARRAY['statewide'], ARRAY['immigrants','asylum_seekers'], ARRAY['en','es'],\n false, false, false, false, false, true, false, false, NULL, true, '2026-04-01', 'georgiaasylum.org'),\n\n('International Women''s House', 'immigration', '(770) 413-5557', NULL, NULL, 'iwh.org', NULL, 'Atlanta', 'GA',\n ARRAY['statewide'], ARRAY['immigrants','dv_survivors'], ARRAY['en','es'],\n true, false, false, false, false, true, false, true, NULL, true, '2026-04-01', 'iwh.org'),\n\n-- Wraparound (extended)\n('10 Women of Hope', 'wraparound', NULL, NULL, NULL, '10womenofhope.org', NULL, 'Marietta', 'GA',\n ARRAY['Cobb'], ARRAY['single_mothers','families'], ARRAY['en'],\n false, false, false, false, false, false, false, false, NULL, true, '2026-04-01', '10womenofhope.org');\n"}	phase_16_extended_organizations_seed	jpender95@gmail.com	\N	\N
20260407150113	{"\nDO $$\nBEGIN\n\n  -- Housing orgs\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['emergency_shelter','transitional_housing','case_management']), NULL\n  FROM public.organizations WHERE org_name = 'The Drake House';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['emergency_shelter','free_childcare','meals','education']), NULL\n  FROM public.organizations WHERE org_name = 'Sonya''s House';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['emergency_shelter','transitional_housing','childcare','vocational_training']), NULL\n  FROM public.organizations WHERE org_name = 'Atlanta Mission: My Sister''s House';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['emergency_shelter','healthcare','early_childhood_education']), NULL\n  FROM public.organizations WHERE org_name = 'Our House';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['emergency_shelter','rapid_rehousing','rental_assistance']), NULL\n  FROM public.organizations WHERE org_name = 'Nicholas House';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['transitional_housing','support_groups','financial_coaching']), NULL\n  FROM public.organizations WHERE org_name = 'Sheltering Grace Ministry';\n\n  -- Food orgs\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['food_pantry','baby_supplies','diapers','formula']), NULL\n  FROM public.organizations WHERE org_name = 'Helping Mamas';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['food_distribution','network_referrals']), 'Connects to 700+ food pantries across 29 counties'\n  FROM public.organizations WHERE org_name = 'Atlanta Community Food Bank (ACFB)';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['food_pantry','utility_assistance','rental_assistance','life_skills']), NULL\n  FROM public.organizations WHERE org_name = 'Hosea Helps';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['snap_enrollment_assistance','food_access']), 'Free help applying for SNAP and other food benefits'\n  FROM public.organizations WHERE org_name = 'Wholesome Wave Georgia';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['food_pantry','utility_assistance','rental_assistance','clothing']), NULL\n  FROM public.organizations WHERE org_name = 'Neighborhood Cooperative Ministry';\n\n  -- Childcare / Education\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['childcare_grants','student_support']), '100% childcare coverage for student mothers in accredited college or job training'\n  FROM public.organizations WHERE org_name = 'Nana Grants';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['rental_assistance','childcare_assistance','financial_counseling']), 'For single parents enrolled in college'\n  FROM public.organizations WHERE org_name = 'H.O.P.E. Inc. (HOPBE)';\n\n  -- Workforce\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['job_training','it_certifications','job_placement','mentoring']), 'IT Fundamentals + cybersecurity certification for single mothers'\n  FROM public.organizations WHERE org_name = 'WIT Single Mothers'' Program';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['workforce_development','emergency_assistance','housing_assistance']), NULL\n  FROM public.organizations WHERE org_name = 'Urban League of Greater Atlanta';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['professional_clothing','networking','career_development']), NULL\n  FROM public.organizations WHERE org_name = 'Dress for Success Atlanta';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['job_training','education','career_services']), 'WIOA-funded, up to 2 years of free training'\n  FROM public.organizations WHERE org_name = 'WorkSource Atlanta';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['job_training','paid_stipends','childcare','wraparound_services']), NULL\n  FROM public.organizations WHERE org_name = 'Goodwill of North Georgia';\n\n  -- Legal\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['free_legal_aid','family_law','housing_law','dv_legal_advocacy','eviction_defense']), NULL\n  FROM public.organizations WHERE org_name = 'Atlanta Legal Aid Society';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['free_legal_aid','emergency_financial_assistance','dv_legal_advocacy','eviction_defense']), NULL\n  FROM public.organizations WHERE org_name = 'Atlanta Legal Aid Society (AVLF)';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['free_legal_aid','family_law','housing_law']), 'Serves rural and low-income Georgians statewide'\n  FROM public.organizations WHERE org_name = 'Georgia Legal Services Program';\n\n  -- DV & Health\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['dv_shelter','crisis_intervention','legal_advocacy','safety_planning']), '24-hr crisis line: (404) 873-1766'\n  FROM public.organizations WHERE org_name = 'Partnership Against Domestic Violence (PADV)';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['dv_services','immigrant_services','crisis_support']), 'Specializes in immigrant and refugee DV survivors'\n  FROM public.organizations WHERE org_name = 'Tapestri';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['dv_shelter','crisis_support','elder_care']), NULL\n  FROM public.organizations WHERE org_name = 'LiveSafe Resources';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['dv_shelter','crisis_support']), NULL\n  FROM public.organizations WHERE org_name = 'Cherokee Family Violence Center';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['maternal_health','healthcare','economic_empowerment']), 'Culturally competent care for Black women'\n  FROM public.organizations WHERE org_name = 'Center for Black Women''s Wellness (CBWW)';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['mental_health','substance_use','family_preservation']), NULL\n  FROM public.organizations WHERE org_name = 'Georgia HOPE';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, 'mental_health_crisis_line', '24/7 statewide mental health crisis line'\n  FROM public.organizations WHERE org_name = 'Georgia Crisis & Access Line';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['emergency_rental_assistance','financial_education']), NULL\n  FROM public.organizations WHERE org_name = 'BCM Georgia';\n\n  -- Immigration\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['immigration_services','legal_aid','esl','family_services']), 'Korean, Vietnamese, Chinese, and other East Asian communities'\n  FROM public.organizations WHERE org_name = 'Center for Pan Asian Community Services (CPACS)';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['immigration_services','legal_aid','esl','family_services']), 'Serves Latino community in Atlanta, Dalton, and Lawrenceville'\n  FROM public.organizations WHERE org_name = 'Latin American Association';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['refugee_resettlement','family_empowerment','career_services']), NULL\n  FROM public.organizations WHERE org_name = 'New American Pathways';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['dv_services','immigration_services','counseling']), 'Serves South Asian communities (India, Bangladesh, Pakistan)'\n  FROM public.organizations WHERE org_name = 'Raksha';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['immigration_legal_aid','asylum_representation']), 'Pro bono legal representation for asylum seekers and trafficking victims'\n  FROM public.organizations WHERE org_name = 'Georgia Asylum & Immigration Network (GAIN)';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['esl','immigration_services','legal_aid','dv_services']), NULL\n  FROM public.organizations WHERE org_name = 'International Women''s House';\n\n  -- Wraparound\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, unnest(ARRAY['support_groups','resource_navigation','leadership_development','financial_coaching']), 'Primary beta partner for WiserMoms'\n  FROM public.organizations WHERE org_name = 'SPARC - Single Parent Alliance & Resource Center';\n\n  INSERT INTO public.org_services (org_id, service_type, notes)\n  SELECT id, 'financial_crisis_assistance', 'For single parents in Cobb County facing financial emergencies'\n  FROM public.organizations WHERE org_name = '10 Women of Hope';\n\nEND $$;\n"}	phase_17_org_services_seed	jpender95@gmail.com	\N	\N
20260430161126	{"\n-- Keep only the most recently created record per program name\nDELETE FROM public.income_thresholds\nWHERE program_id IN (\n  SELECT id FROM public.programs\n  WHERE id NOT IN (\n    SELECT DISTINCT ON (program_name) id\n    FROM public.programs\n    ORDER BY program_name, created_at DESC\n  )\n);\n\nDELETE FROM public.documents_required\nWHERE program_id IN (\n  SELECT id FROM public.programs\n  WHERE id NOT IN (\n    SELECT DISTINCT ON (program_name) id\n    FROM public.programs\n    ORDER BY program_name, created_at DESC\n  )\n);\n\nDELETE FROM public.application_guides\nWHERE program_id IN (\n  SELECT id FROM public.programs\n  WHERE id NOT IN (\n    SELECT DISTINCT ON (program_name) id\n    FROM public.programs\n    ORDER BY program_name, created_at DESC\n  )\n);\n\nDELETE FROM public.results\nWHERE program_id IN (\n  SELECT id FROM public.programs\n  WHERE id NOT IN (\n    SELECT DISTINCT ON (program_name) id\n    FROM public.programs\n    ORDER BY program_name, created_at DESC\n  )\n);\n\nDELETE FROM public.applications\nWHERE program_id IN (\n  SELECT id FROM public.programs\n  WHERE id NOT IN (\n    SELECT DISTINCT ON (program_name) id\n    FROM public.programs\n    ORDER BY program_name, created_at DESC\n  )\n);\n\nDELETE FROM public.reminders\nWHERE program_id IN (\n  SELECT id FROM public.programs\n  WHERE id NOT IN (\n    SELECT DISTINCT ON (program_name) id\n    FROM public.programs\n    ORDER BY program_name, created_at DESC\n  )\n);\n\n-- Now delete the duplicate programs themselves\nDELETE FROM public.programs\nWHERE id NOT IN (\n  SELECT DISTINCT ON (program_name) id\n  FROM public.programs\n  ORDER BY program_name, created_at DESC\n);\n"}	deduplicate_programs	jpender95@gmail.com	\N	\N
20260430161135	{"\n-- Remove org_services for duplicate orgs first\nDELETE FROM public.org_services\nWHERE org_id IN (\n  SELECT id FROM public.organizations\n  WHERE id NOT IN (\n    SELECT DISTINCT ON (org_name) id\n    FROM public.organizations\n    ORDER BY org_name, created_at DESC\n  )\n);\n\n-- Remove duplicate organizations, keeping newest\nDELETE FROM public.organizations\nWHERE id NOT IN (\n  SELECT DISTINCT ON (org_name) id\n  FROM public.organizations\n  ORDER BY org_name, created_at DESC\n);\n"}	deduplicate_organizations	jpender95@gmail.com	\N	\N
20260430161143	{"\n-- Remove duplicate income thresholds (same program + household_size)\nDELETE FROM public.income_thresholds\nWHERE id NOT IN (\n  SELECT DISTINCT ON (program_id, household_size) id\n  FROM public.income_thresholds\n  ORDER BY program_id, household_size, created_at DESC\n);\n"}	deduplicate_income_thresholds	jpender95@gmail.com	\N	\N
20260430161236	{"\n-- Wipe all program-dependent data cleanly\nTRUNCATE public.guide_steps CASCADE;\nTRUNCATE public.application_guides CASCADE;\nTRUNCATE public.documents_required CASCADE;\nTRUNCATE public.income_thresholds CASCADE;\nTRUNCATE public.programs CASCADE;\n\n-- Reseed the 8 canonical programs\nINSERT INTO public.programs (\n  program_name, also_known_as, program_type, administering_agency,\n  agency_phone, agency_website, apply_url, eligibility_summary,\n  income_limit_pct_fpl, asset_limit, renewal_period,\n  counties_served, languages_available, waitlist_status,\n  last_verified_date, source_url\n) VALUES\n(\n  'Supplemental Nutrition Assistance Program',\n  'SNAP / Food Stamps', 'food',\n  'Georgia Division of Family & Children Services (DFCS)',\n  '(877) 423-4746', 'dfcs.georgia.gov/services/snap', 'gateway.ga.gov',\n  'Monthly food benefits via EBT card for households earning up to 130% FPL. Asset limit $2,750. Already on Medicaid, TANF, or SSI? You may qualify automatically.',\n  130, 2750, '6 months', ARRAY['statewide'], ARRAY['en','es'], 'open',\n  '2026-04-30', 'dfcs.georgia.gov/services/snap'\n),\n(\n  'Women Infants and Children',\n  'WIC', 'food',\n  'Georgia Department of Public Health (DPH)',\n  '(800) 228-9173', 'dph.georgia.gov/WIC', 'gateway.ga.gov',\n  'Nutritious foods via eWIC card for pregnant women, new moms up to 6 months postpartum, breastfeeding mothers up to 12 months, and children under 5. Already on SNAP, Medicaid, or TANF? You automatically qualify.',\n  185, NULL, '6 months', ARRAY['statewide'], ARRAY['en','es'], 'open',\n  '2026-04-30', 'dph.georgia.gov/WIC'\n),\n(\n  'Temporary Assistance for Needy Families',\n  'TANF', 'cash',\n  'Georgia Division of Family & Children Services (DFCS)',\n  '(877) 423-4746', 'dfcs.georgia.gov/services/temporary-assistance-needy-families', 'gateway.ga.gov',\n  'Monthly cash assistance for families with children under 18. Must cooperate with child support services unless domestic violence exemption applies. 48-month lifetime limit. 30 hrs/week work requirement.',\n  NULL, 1000, '12 months', ARRAY['statewide'], ARRAY['en','es'], 'open',\n  '2026-04-30', 'dfcs.georgia.gov/services/temporary-assistance-needy-families'\n),\n(\n  'Childcare and Parent Services',\n  'CAPS', 'childcare',\n  'Georgia Department of Early Care and Learning (DECAL)',\n  '(877) 255-4254', 'caps.decal.ga.gov', 'gateway.ga.gov',\n  'Financial help paying for childcare at any Quality Rated provider. Child must be 12 or under (17 if disabled). Parent must be working, in school, or in training. Income limit approximately 50% State Median Income — verify annually at caps.decal.ga.gov.',\n  NULL, NULL, 'annual', ARRAY['statewide'], ARRAY['en','es'], 'open',\n  '2026-04-30', 'caps.decal.ga.gov'\n),\n(\n  'Housing Choice Voucher Program',\n  'Section 8', 'housing',\n  'Georgia Department of Community Affairs (DCA) / Local Housing Authorities',\n  NULL, 'dca.georgia.gov/housing-choice-voucher', 'atlantahousing.org',\n  'Rent subsidy capping your share at 30% of your income. Income must be below 50% of Area Median Income. Criminal background check required. WAITLIST CURRENTLY CLOSED — check atlantahousing.org for project-based openings.',\n  NULL, NULL, 'annual',\n  ARRAY['Fulton','DeKalb','Gwinnett','Cobb'], ARRAY['en'], 'closed',\n  '2026-04-30', 'dca.georgia.gov/housing-choice-voucher'\n),\n(\n  'Georgia Medicaid',\n  'Medicaid / PeachCare', 'healthcare',\n  'Georgia Department of Community Health (DCH)',\n  '(800) 869-1150', 'medicaid.georgia.gov', 'gateway.ga.gov',\n  'Free or low-cost health coverage. Pregnant women qualify up to 220% FPL. Children (PeachCare) up to 247% FPL. Adults via Georgia Pathways up to 100% FPL with 80 hrs/month qualifying activity. Georgia has NOT expanded Medicaid under the ACA.',\n  NULL, NULL, 'annual', ARRAY['statewide'], ARRAY['en','es'], 'open',\n  '2026-04-30', 'medicaid.georgia.gov'\n),\n(\n  'Low-Income Home Energy Assistance Program',\n  'LIHEAP', 'housing',\n  'Georgia Division of Family & Children Services (DFCS)',\n  '(877) 423-4746', 'dfcs.georgia.gov/services/low-income-home-energy-assistance-program-liheap', 'Local DFCS office',\n  'One-time annual payment directly to your utility company for heating or cooling. Income must be at or below 60% State Median Income. Heating assistance opens December 1 annually. In DeKalb/Gwinnett counties, apply through Partnership for Community Action (pcaction.org).',\n  NULL, NULL, 'annual', ARRAY['statewide'], ARRAY['en','es'], 'open',\n  '2026-04-30', 'dfcs.georgia.gov/services/low-income-home-energy-assistance-program-liheap'\n),\n(\n  'Child Support Services',\n  'DCSS', 'legal',\n  'Georgia Division of Child Support Services (DCSS)',\n  '(877) 423-4746', 'childsupport.georgia.gov', 'services.georgia.gov/dhr/cspp',\n  'Free if receiving TANF or Medicaid ($25 fee otherwise). Establishes paternity, creates child support orders, enforces payment. TANF recipients must cooperate unless domestic violence good cause exemption applies.',\n  NULL, NULL, NULL, ARRAY['statewide'], ARRAY['en','es'], 'open',\n  '2026-04-30', 'childsupport.georgia.gov'\n);\n"}	clean_wipe_and_reseed_programs	jpender95@gmail.com	\N	\N
20260430161257	{"\n-- SNAP thresholds (monthly income limit + benefit amounts, FY2025)\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit, benefit_amount)\nSELECT id, 1, 1632, 292  FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program' UNION ALL\nSELECT id, 2, 2215, 536  FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program' UNION ALL\nSELECT id, 3, 2798, 768  FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program' UNION ALL\nSELECT id, 4, 3381, 975  FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program' UNION ALL\nSELECT id, 5, 3964, 1155 FROM public.programs WHERE program_name = 'Supplemental Nutrition Assistance Program';\n\n-- TANF thresholds (monthly gross income ceiling + max benefit, FY2025)\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit, benefit_amount)\nSELECT id, 1, 435, 155  FROM public.programs WHERE program_name = 'Temporary Assistance for Needy Families' UNION ALL\nSELECT id, 2, 569, 235  FROM public.programs WHERE program_name = 'Temporary Assistance for Needy Families' UNION ALL\nSELECT id, 3, 784, 280  FROM public.programs WHERE program_name = 'Temporary Assistance for Needy Families' UNION ALL\nSELECT id, 4, 958, 330  FROM public.programs WHERE program_name = 'Temporary Assistance for Needy Families';\n\n-- WIC thresholds (annual income limits at 185% FPL, FY2025)\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit_yr, notes)\nSELECT id, 1, 26973, 'WIC 185% FPL FY2025' FROM public.programs WHERE program_name = 'Women Infants and Children' UNION ALL\nSELECT id, 2, 36482, 'WIC 185% FPL FY2025' FROM public.programs WHERE program_name = 'Women Infants and Children' UNION ALL\nSELECT id, 3, 45991, 'WIC 185% FPL FY2025' FROM public.programs WHERE program_name = 'Women Infants and Children' UNION ALL\nSELECT id, 4, 55500, 'WIC 185% FPL FY2025' FROM public.programs WHERE program_name = 'Women Infants and Children' UNION ALL\nSELECT id, 5, 65009, 'WIC 185% FPL FY2025' FROM public.programs WHERE program_name = 'Women Infants and Children';\n\n-- LIHEAP thresholds (annual income limits at 60% SMI, FY2025)\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit_yr, notes)\nSELECT id, 1, 34549, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program' UNION ALL\nSELECT id, 2, 45127, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program' UNION ALL\nSELECT id, 3, 55705, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program' UNION ALL\nSELECT id, 4, 66283, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program' UNION ALL\nSELECT id, 5, 77071, 'LIHEAP 60% SMI FY2025' FROM public.programs WHERE program_name = 'Low-Income Home Energy Assistance Program';\n\n-- CAPS thresholds (annual ~50% SMI — verify at caps.decal.ga.gov each October)\nINSERT INTO public.income_thresholds (program_id, household_size, income_limit_yr, notes)\nSELECT id, 1, 26000, 'CAPS ~50% SMI — verify annually at caps.decal.ga.gov each October' FROM public.programs WHERE program_name = 'Childcare and Parent Services' UNION ALL\nSELECT id, 2, 34000, 'CAPS ~50% SMI — verify annually at caps.decal.ga.gov each October' FROM public.programs WHERE program_name = 'Childcare and Parent Services' UNION ALL\nSELECT id, 3, 42000, 'CAPS ~50% SMI — verify annually at caps.decal.ga.gov each October' FROM public.programs WHERE program_name = 'Childcare and Parent Services' UNION ALL\nSELECT id, 4, 51000, 'CAPS ~50% SMI — verify annually at caps.decal.ga.gov each October' FROM public.programs WHERE program_name = 'Childcare and Parent Services' UNION ALL\nSELECT id, 5, 59000, 'CAPS ~50% SMI — verify annually at caps.decal.ga.gov each October' FROM public.programs WHERE program_name = 'Childcare and Parent Services';\n"}	reseed_income_thresholds	jpender95@gmail.com	\N	\N
20260430161334	{"\n-- SNAP documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, doc, desc_, true, cond FROM public.programs p,\n(VALUES\n  ('Photo ID', 'Driver''s license, state ID, passport, or employer/school ID', NULL),\n  ('Social Security Number (all household members)', 'SSN card or document for every person in your household', NULL),\n  ('Proof of citizenship or immigration status', 'U.S. birth certificate, passport, or immigration documents', NULL),\n  ('Proof of income (last 30 days)', 'Pay stubs, employer letter, or benefit award letters for all household members', NULL),\n  ('Proof of housing expenses', 'Rent/mortgage statement or lease agreement', NULL),\n  ('Proof of utility costs', 'Utility bills showing your name and address', NULL),\n  ('Proof of childcare expenses', 'Childcare receipts or provider statement', 'Only if claiming childcare deduction'),\n  ('Proof of Georgia residency', 'Utility bill, lease agreement, or official mail at current address', NULL)\n) AS t(doc, desc_, cond)\nWHERE p.program_name = 'Supplemental Nutrition Assistance Program';\n\n-- WIC documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, doc, desc_, req, cond FROM public.programs p,\n(VALUES\n  ('Photo ID', 'Driver''s license, passport, birth certificate, or school ID', true, NULL),\n  ('Proof of Georgia residency', 'Utility bill, lease, or official mail', true, NULL),\n  ('Proof of income', 'Pay stubs, tax return, or benefit letter — OR proof of SNAP/Medicaid/TANF for automatic eligibility', true, NULL),\n  ('Proof of pregnancy or child''s birth certificate', 'Documentation from a healthcare provider if pregnant', false, 'Required for pregnant women or children'),\n  ('Immunization records', 'Georgia Form 3231 for children', false, 'Required for children only')\n) AS t(doc, desc_, req, cond)\nWHERE p.program_name = 'Women Infants and Children';\n\n-- TANF documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, doc, desc_, true, cond FROM public.programs p,\n(VALUES\n  ('Social Security Numbers (all household members)', 'SSN card or document for every household member', NULL),\n  ('Birth certificates for all children', 'Official birth certificate for each child under 18', NULL),\n  ('Proof of income (all sources)', 'Wages, child support, unemployment, SNAP, and any other income', NULL),\n  ('Proof of Georgia residency', 'Utility bill, lease, or official mail', NULL),\n  ('Proof of citizenship or immigration status', 'U.S. birth certificate, passport, or immigration documents', NULL),\n  ('Immunization records (children under 7)', 'Georgia Form 3231 or doctor''s immunization record', NULL),\n  ('Proof of school enrollment (children 6-18)', 'Current school enrollment letter or report card', NULL),\n  ('Non-custodial parent information', 'Name, address, employer of other parent — required unless domestic violence exemption applies', NULL)\n) AS t(doc, desc_, cond)\nWHERE p.program_name = 'Temporary Assistance for Needy Families';\n\n-- CAPS documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, doc, desc_, req, cond FROM public.programs p,\n(VALUES\n  ('Proof of Georgia residency', 'Driver''s license, lease, utility bill, or motor vehicle registration', true, NULL),\n  ('Proof of identity', 'Government-issued ID for the parent or guardian', true, NULL),\n  ('Child''s birth certificate', 'Official birth certificate for each child under 13', true, NULL),\n  ('Proof of child''s citizenship or immigration status', 'U.S. birth certificate, passport, or immigration documents for the child', true, NULL),\n  ('Certificate of Immunization (Georgia Form 3231)', 'Shows child is up-to-date on immunizations', true, NULL),\n  ('Proof of employment', 'Pay stubs or employer letter showing current employment', false, 'Required if qualifying through employment'),\n  ('Proof of school enrollment or training', 'School enrollment letter or training program acceptance letter', false, 'Required if qualifying through school or training')\n) AS t(doc, desc_, req, cond)\nWHERE p.program_name = 'Childcare and Parent Services';\n\n-- Section 8 documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, doc, desc_, true, NULL FROM public.programs p,\n(VALUES\n  ('Photo ID (all adults)', 'Valid government-issued photo ID for every adult in the household'),\n  ('Social Security Numbers (all household members)', 'SSN card or document for every household member'),\n  ('Birth certificates for all children', 'Official birth certificate for each child'),\n  ('Proof of income', 'Pay stubs, benefit award letters, child support documentation'),\n  ('Proof of current address', 'Current lease, utility bill, or official mail'),\n  ('Criminal history disclosure', 'Background check will be conducted — certain convictions may disqualify')\n) AS t(doc, desc_)\nWHERE p.program_name = 'Housing Choice Voucher Program';\n\n-- Medicaid documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, doc, desc_, req, cond FROM public.programs p,\n(VALUES\n  ('Proof of identity', 'Government-issued ID or birth certificate', true, NULL),\n  ('Social Security Number', 'SSN card or document', true, NULL),\n  ('Proof of Georgia residency', 'Utility bill, lease, or official mail', true, NULL),\n  ('Proof of income (all household members)', 'Pay stubs, benefit letters, or employer letter', true, NULL),\n  ('Proof of pregnancy', 'Documentation from a healthcare provider', false, 'Required for Right from the Start Medicaid only'),\n  ('Immigration status documentation', 'Immigration documents if not a U.S. citizen', false, 'Required only for non-citizens')\n) AS t(doc, desc_, req, cond)\nWHERE p.program_name = 'Georgia Medicaid';\n\n-- LIHEAP documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, doc, desc_, true, NULL FROM public.programs p,\n(VALUES\n  ('Proof of identity', 'Government-issued ID or birth certificate'),\n  ('Proof of Georgia residency', 'Utility bill, lease, or official mail at current address'),\n  ('Proof of income (all household members)', 'Pay stubs or benefit award letters for the last 30 days'),\n  ('Most recent utility bill', 'Your most recent heating or cooling bill showing your account number and provider'),\n  ('Social Security Numbers (all household members)', 'SSN card or document for every household member')\n) AS t(doc, desc_)\nWHERE p.program_name = 'Low-Income Home Energy Assistance Program';\n\n-- Child Support documents\nINSERT INTO public.documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, doc, desc_, req, cond FROM public.programs p,\n(VALUES\n  ('Proof of identity', 'Government-issued ID', true, NULL),\n  ('Child''s birth certificate', 'Official birth certificate for each child', true, NULL),\n  ('Information about the non-custodial parent', 'Full name, last known address, employer, and date of birth of the other parent if known', true, NULL),\n  ('Proof of TANF or Medicaid enrollment', 'Award letter showing active TANF or Medicaid — waives the $25 application fee', false, 'Only needed to waive the $25 fee'),\n  ('Documentation of domestic violence', 'Police report, protective order, or other documentation — allows skipping child support cooperation if it would put you in danger', false, 'Only if requesting DV good cause exemption')\n) AS t(doc, desc_, req, cond)\nWHERE p.program_name = 'Child Support Services';\n"}	reseed_documents_required	jpender95@gmail.com	\N	\N
20260430161357	{"\n-- Application guides\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for SNAP (Food Stamps) in Georgia',\n  'SNAP gives you a monthly EBT card to buy groceries. The whole process takes about 2–4 weeks from application to receiving your card. You can apply online in under 30 minutes.',\n  'gateway.ga.gov', '(877) 423-4746', '2026-04-30', 'dfcs.georgia.gov/services/snap'\nFROM public.programs p WHERE p.program_name = 'Supplemental Nutrition Assistance Program';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for WIC in Georgia',\n  'WIC gives you a monthly eWIC card to buy nutritious food. If you are pregnant, nursing, or have a child under 5, you likely qualify. The appointment takes about an hour.',\n  'gateway.ga.gov', '(800) 228-9173', '2026-04-30', 'dph.georgia.gov/WIC'\nFROM public.programs p WHERE p.program_name = 'Women Infants and Children';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for CAPS (Childcare Assistance) in Georgia',\n  'CAPS helps pay for childcare so you can work, go to school, or train for a job. Apply online and a CAPS staff member will call you within 30 days.',\n  'gateway.ga.gov', '(877) 255-4254', '2026-04-30', 'caps.decal.ga.gov'\nFROM public.programs p WHERE p.program_name = 'Childcare and Parent Services';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for TANF (Cash Assistance) in Georgia',\n  'TANF provides monthly cash on your EBT card for families with children. It has strict income limits and a 48-month lifetime limit — use it as a bridge while building toward stable income.',\n  'gateway.ga.gov', '(877) 423-4746', '2026-04-30', 'dfcs.georgia.gov/services/temporary-assistance-needy-families'\nFROM public.programs p WHERE p.program_name = 'Temporary Assistance for Needy Families';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for Section 8 (Housing Voucher) in Georgia',\n  'Section 8 caps your rent at 30% of your income. The waitlist is currently closed in most areas — this guide explains how to get on lists when they open and what to do in the meantime.',\n  'atlantahousing.org', '(404) 892-4700', '2026-04-30', 'dca.georgia.gov/housing-choice-voucher'\nFROM public.programs p WHERE p.program_name = 'Housing Choice Voucher Program';\n\nINSERT INTO public.application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url)\nSELECT p.id,\n  'How to Apply for Georgia Medicaid',\n  'Georgia Medicaid covers doctor visits, prescriptions, and hospital care at little or no cost. Pregnant women and children have the broadest eligibility. Apply online through Georgia Gateway.',\n  'gateway.ga.gov', '(877) 423-4746', '2026-04-30', 'medicaid.georgia.gov'\nFROM public.programs p WHERE p.program_name = 'Georgia Medicaid';\n"}	reseed_application_guides_and_steps	jpender95@gmail.com	\N	\N
20260430161523	{"\nDO $$\nDECLARE\n  v_snap_id UUID;\n  v_wic_id  UUID;\n  v_caps_id UUID;\n  v_tanf_id UUID;\n  v_s8_id   UUID;\n  v_mc_id   UUID;\nBEGIN\n  SELECT id INTO v_snap_id FROM public.application_guides WHERE guide_name LIKE 'How to Apply for SNAP%';\n  SELECT id INTO v_wic_id  FROM public.application_guides WHERE guide_name LIKE 'How to Apply for WIC%';\n  SELECT id INTO v_caps_id FROM public.application_guides WHERE guide_name LIKE 'How to Apply for CAPS%';\n  SELECT id INTO v_tanf_id FROM public.application_guides WHERE guide_name LIKE 'How to Apply for TANF%';\n  SELECT id INTO v_s8_id   FROM public.application_guides WHERE guide_name LIKE 'How to Apply for Section 8%';\n  SELECT id INTO v_mc_id   FROM public.application_guides WHERE guide_name LIKE 'How to Apply for Georgia Medicaid%';\n\n  -- SNAP steps\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_snap_id,1,'Check your eligibility','Visit snapscreener.com/screener/georgia to estimate whether you qualify and how much you might receive.','This free tool gives you a quick yes/no estimate before you fill out the full application. No personal information is saved.','If you are already on Medicaid, TANF, or SSI, you may qualify automatically — this is called categorical eligibility.','https://snapscreener.com/screener/georgia'),\n  (v_snap_id,2,'Choose how to apply','Online at gateway.ga.gov (recommended, Mon–Fri 5am–midnight); by phone at (877) 423-4746; or paper Form 297 mailed to your local DFCS office.','Online is fastest. You can save your progress and come back to finish later.','Online is fastest. You can save your application and come back to it.','https://gateway.ga.gov'),\n  (v_snap_id,3,'Submit your application','Your application is officially filed when DFCS receives: your name, address, date, and signature.','You do not need all your documents to submit the first form. Send what you have — you can upload the rest afterward.',NULL,'https://gateway.ga.gov'),\n  (v_snap_id,4,'Complete the phone interview','A DFCS eligibility worker will call you after you file. Be ready to discuss household income, housing costs, childcare expenses, and employment status.','This is just a phone call — not an in-person meeting. It usually takes 20–30 minutes.','DFCS calls from unknown or blocked numbers. Answer all calls after you apply.',NULL),\n  (v_snap_id,5,'Upload your documents','Upload documents directly in Georgia Gateway under My Account > Documents. Uploading is faster than mailing.','Take photos of your documents with your phone and upload them right from the app.','Uploading documents online is faster than mailing. DFCS receives them instantly.','https://gateway.ga.gov'),\n  (v_snap_id,6,'Receive your decision','You will be notified within 30 days. If approved, your EBT card will be mailed. Benefits are loaded monthly.','Your EBT card works like a debit card at any grocery store. Check your balance by calling the number on the back.','If denied, you have the right to appeal within 90 days. Call (877) 423-4746.',NULL),\n  (v_snap_id,7,'Renew your benefits','SNAP must be renewed every 6 or 12 months. Complete Form 508 or renew online at Georgia Gateway.','Mark your renewal date. Missing the deadline means your benefits stop immediately — even if you still qualify.','Set a renewal reminder in the WiserMoms app so you never miss your deadline.','https://gateway.ga.gov');\n\n  -- WIC steps\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_wic_id,1,'Check your eligibility','Visit dph.georgia.gov/wic-eligibility-assessment. Must be pregnant, breastfeeding, postpartum, or have a child under 5. Income at or below 185% FPL.','If you are already on SNAP, Medicaid, or TANF, you automatically meet the income requirement — no income documents needed.','Already on SNAP, Medicaid, or TANF? You skip the income check entirely.','https://dph.georgia.gov/wic-eligibility-assessment'),\n  (v_wic_id,2,'Find your local WIC clinic','Visit wic.ga.gov or call (800) 228-9173 to find the nearest clinic. Available at health departments, community health centers, hospitals, and DFCS offices.','There are WIC clinics all over Georgia. Most can schedule you within a week.','Bring your child to the appointment — WIC staff need height and weight measurements.','https://wic.ga.gov'),\n  (v_wic_id,3,'Apply online or schedule an appointment','Start at gateway.ga.gov (select WIC) or call your local clinic directly.','You can start online but you will need to come in for a nutrition assessment before your eWIC card is issued.',NULL,'https://gateway.ga.gov'),\n  (v_wic_id,4,'Attend your nutrition assessment','A WIC health professional reviews your documents, takes height/weight measurements, does a blood test for anemia, and issues your eWIC card.','The appointment takes about an hour. Bring all your documents.','The blood test is just a small finger prick — it checks iron levels.',NULL),\n  (v_wic_id,5,'Use your eWIC card','Your eWIC card works at 1,400+ authorized Georgia vendors. Approved foods include milk, eggs, bread, cereal, juice, peanut butter, fresh produce, and infant formula.','Download the WIC Shopper app to scan products and confirm they are WIC-approved before you buy.',NULL,NULL),\n  (v_wic_id,6,'Renew every 6 months','Women renew every 6 months. Children renew annually. Your WIC clinic will contact you before your benefits expire.','Mark your renewal date in the WiserMoms app.','Missing renewal means a gap in your food benefits.',NULL);\n\n  -- CAPS steps\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_caps_id,1,'Check your eligibility','Visit caps.decal.ga.gov. Georgia resident, child under 13, parent working/in school/in training, income below 50% State Median Income.','Income limits change every October — always check the current table at caps.decal.ga.gov before assuming you qualify or do not qualify.','Children with disabilities may qualify up to age 17.','https://caps.decal.ga.gov'),\n  (v_caps_id,2,'Apply through Georgia Gateway','Go to gateway.ga.gov, select \\"Child care,\\" and follow the prompts.','Have your documents ready before you start. The application asks about your work schedule, income, and your child''s information.',NULL,'https://gateway.ga.gov'),\n  (v_caps_id,3,'Upload your documents promptly','Upload all required documents in Georgia Gateway. Prompt uploading is the #1 way to speed up processing.','Take photos of documents with your phone and upload them right from the Gateway app.',NULL,'https://gateway.ga.gov'),\n  (v_caps_id,4,'Wait for a call from CAPS staff','A CAPS staff member will call to review your application. You will be notified within 30 calendar days.','If you have not heard back in 30 days, call (877) 255-4254.','Answer calls from unknown numbers — CAPS staff may call from different numbers.',NULL),\n  (v_caps_id,5,'Find a Quality Rated childcare provider','Once approved you will be assigned a Family Support Consultant. Enroll your child in any eligible Quality Rated provider. Find providers at families.decal.ga.gov.','Call your top 3 choices before visiting — some have waitlists.','Quality Rated means the provider has been inspected for safety and education quality.','https://families.decal.ga.gov'),\n  (v_caps_id,6,'Renew annually','CAPS eligibility must be renewed every year. Your Family Support Consultant will help you.','Missing renewal means your childcare subsidy stops and you may owe the provider directly.','Set an annual renewal reminder in the WiserMoms app.',NULL);\n\n  -- TANF steps\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_tanf_id,1,'Check your eligibility','Very strict limits. Family of 3: gross income below $784/month and assets below $1,000.','TANF cash amounts are low — up to $280/month for a family of 3. It is designed as short-term help while you build toward stable income.','TANF has a 48-month lifetime limit across all states. Track how many months you have used.','https://gateway.ga.gov'),\n  (v_tanf_id,2,'Apply through Georgia Gateway','Go to gateway.ga.gov and select \\"Apply for Benefits.\\" Choose TANF. Or call (877) 423-4746 or visit your local DFCS office.',NULL,NULL,'https://gateway.ga.gov'),\n  (v_tanf_id,3,'Complete the interview','A DFCS eligibility worker will conduct a phone or in-person interview to verify your information.','Bring or have ready all your documents. The worker will ask about all household income and the situation of the other parent.',NULL,NULL),\n  (v_tanf_id,4,'Cooperate with Child Support Services','You must cooperate with DCSS to establish and collect child support from the non-custodial parent, unless you have a domestic violence good cause exemption.','If cooperating with child support would put you in danger, tell your DFCS worker immediately. You can request the DV good cause exemption.','If you are in a domestic violence situation, you do NOT have to cooperate with child support. Ask for the DV good cause exemption.',  'https://childsupport.georgia.gov'),\n  (v_tanf_id,5,'Meet the work requirements','Must participate in work activities or training for at least 30 hours per week. DFCS connects you with Georgia CREW for employment services.','Georgia CREW can count school, job training, and volunteering toward your 30 hours — it is not just a job board.','Georgia CREW provides real support: job search, job training, GED, vocational programs.','https://dfcs.georgia.gov/services/georgia-crew'),\n  (v_tanf_id,6,'Receive and manage your benefits','If approved, cash benefits are loaded monthly to your EBT card — $155/month (1 person) to $330+/month (family of 4).','TANF cash can be used for anything — rent, utilities, diapers, transportation.','TANF has a 48-month lifetime limit. Use the employment services DFCS offers to build toward self-sufficiency.',NULL);\n\n  -- Section 8 steps\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_s8_id,1,'Find an open waitlist — this is the critical first step','Most Section 8 waitlists in Georgia are CLOSED. Check: Atlanta Housing Authority (atlantahousing.org), DeKalb Housing Authority (dekalbhousing.org), Gwinnett Housing Corporation (gwinnetthousing.org).','Waitlists open without much notice and close within 48–72 hours.','Bookmark atlantahousing.org and check every 2 months. Waitlists can open suddenly.','https://atlantahousing.org'),\n  (v_s8_id,2,'Apply immediately when a waitlist opens','When a waitlist opens, apply the same day — they often close within 48 hours. Applications are submitted online during the open period.','You cannot apply when the waitlist is closed. All you can do is watch for openings.','Bookmark all three housing authority sites on your phone right now.',NULL),\n  (v_s8_id,3,'Apply for emergency housing NOW while you wait','Waitlists can be 2–5+ years. Apply for emergency rental assistance through BCM Georgia, AVLF (404-521-0790), and Hosea Helps (404-373-5705). Contact The Drake House (770-587-4712) for transitional housing.','Do not wait for Section 8 if you need housing now. Use the emergency resources in WiserMoms while your name moves up the list.','Keep your address updated with every housing authority where you applied — an outdated address means a missed voucher offer.',NULL),\n  (v_s8_id,4,'Complete the full application when contacted','When your name comes up, you will have a limited window (usually 30 days) to submit all documents and complete a criminal background check.','Respond to any housing authority letters immediately. Missing their deadline means starting over.',NULL,NULL),\n  (v_s8_id,5,'Find a housing unit','Once you receive a voucher you have 60–120 days to find a landlord who accepts Section 8. The unit must pass a HUD inspection.','Not all landlords accept Section 8. Ask specifically \\"Do you accept Housing Choice Vouchers?\\" when calling about a rental.','Atlanta Legal Aid Society can help if a landlord unlawfully refuses to accept your voucher.','https://atlantalegalaid.org'),\n  (v_s8_id,6,'Sign your lease','The Housing Authority pays a portion of rent directly to the landlord. You pay approximately 30% of your income.','If your income drops, report it to the housing authority immediately — your share goes down.','Never pay more than your assigned share. If your landlord asks for more, contact your housing authority immediately.',NULL);\n\n  -- Medicaid steps\n  INSERT INTO public.guide_steps (guide_id, step_number, title, description, plain_english, tip, url) VALUES\n  (v_mc_id,1,'Determine which category you qualify for','Pregnant → Right from the Start Medicaid (220% FPL). Children → PeachCare (247% FPL). Adult with children → Medicaid for parents (35% FPL, very restrictive). Adult without children → Georgia Pathways (100% FPL + 80 hrs/month work activity).','Most single mothers qualify through their children (PeachCare) or pregnancy (RSM). Adult-only Medicaid is very limited because Georgia has not expanded Medicaid under the ACA.','Georgia has NOT expanded Medicaid. If you are not pregnant and have no children at home, your options are very limited.','https://medicaid.georgia.gov'),\n  (v_mc_id,2,'Apply through Georgia Gateway','Go to gateway.ga.gov and select Medicaid. Or call (877) 423-4746 or visit your local DFCS office.',NULL,NULL,'https://gateway.ga.gov'),\n  (v_mc_id,3,'Complete the interview and provide documents','Upload or mail all required documents. A DFCS worker will review your application.','Uploading documents in Georgia Gateway is faster than mailing. You can see when DFCS receives them.','If you are pregnant, apply as soon as possible — Right from the Start Medicaid can cover you retroactively to the month you became pregnant.','https://gateway.ga.gov'),\n  (v_mc_id,4,'Receive your Medicaid card','If approved, your Medicaid card arrives by mail. Use it at any Medicaid-accepting provider in Georgia.','Show your Medicaid card at every doctor, dentist, pharmacy, and hospital visit. Keep it safe.','Lost your card? Call (877) 423-4746 to request a replacement.',NULL),\n  (v_mc_id,5,'Renew annually','Medicaid must be renewed each year. You will receive a renewal notice. Respond promptly to avoid losing coverage.','Missing renewal stops your coverage immediately — even mid-pregnancy or mid-treatment.','Set an annual renewal reminder in the WiserMoms app.',NULL);\n\nEND $$;\n"}	reseed_guide_steps	jpender95@gmail.com	\N	\N
20260430161607	{"\nDROP FUNCTION IF EXISTS get_eligible_programs(UUID);\nDROP FUNCTION IF EXISTS get_my_dv_flag();\n\nCREATE OR REPLACE FUNCTION get_eligible_programs(p_user_id UUID)\nRETURNS TABLE (\n  program_id        UUID,\n  program_name      TEXT,\n  program_type      TEXT,\n  eligibility       TEXT,\n  estimated_benefit NUMERIC,\n  apply_url         TEXT,\n  eligibility_note  TEXT\n)\nLANGUAGE plpgsql SECURITY DEFINER AS $$\nDECLARE\n  v_income    NUMERIC;\n  v_hh_size   INTEGER;\n  v_pregnant  BOOLEAN;\n  v_children  INTEGER;\n  v_childcare BOOLEAN;\n  v_fpl       NUMERIC;\nBEGIN\n  SELECT gross_monthly_income, household_size, pregnant,\n         num_children_under18, needs_childcare\n  INTO v_income, v_hh_size, v_pregnant, v_children, v_childcare\n  FROM public.profiles WHERE user_id = p_user_id;\n\n  -- Monthly FPL by household size (HHS 2025 guidelines)\n  v_fpl := CASE COALESCE(v_hh_size, 1)\n    WHEN 1 THEN 1255  WHEN 2 THEN 1703\n    WHEN 3 THEN 2152  WHEN 4 THEN 2600\n    ELSE 2600 + ((COALESCE(v_hh_size, 1) - 4) * 448)\n  END;\n\n  -- Standard income-threshold programs (SNAP, WIC, TANF, CAPS, LIHEAP, Child Support)\n  RETURN QUERY\n  SELECT prog.id, prog.program_name, prog.program_type,\n    CASE\n      WHEN v_income <= it.income_limit       THEN 'likely_eligible'\n      WHEN v_income <= it.income_limit * 1.1 THEN 'possibly_eligible'\n      ELSE 'ineligible'\n    END,\n    it.benefit_amount, prog.apply_url, NULL::TEXT\n  FROM public.programs prog\n  JOIN public.income_thresholds it\n    ON it.program_id = prog.id\n   AND it.household_size = COALESCE(v_hh_size, 1)\n  WHERE prog.program_name NOT IN ('Georgia Medicaid','Housing Choice Voucher Program','Child Support Services')\n    AND (prog.program_name != 'Childcare and Parent Services' OR v_childcare = TRUE)\n    AND (prog.program_name != 'Women Infants and Children'\n         OR v_pregnant = TRUE OR COALESCE(v_children, 0) > 0)\n    AND it.income_limit IS NOT NULL\n  ORDER BY\n    CASE WHEN v_income <= it.income_limit THEN 1\n         WHEN v_income <= it.income_limit * 1.1 THEN 2\n         ELSE 3 END,\n    it.benefit_amount DESC NULLS LAST;\n\n  -- Child Support — always surface (no income test, free if on TANF/Medicaid)\n  RETURN QUERY\n  SELECT prog.id, prog.program_name, prog.program_type,\n    'likely_eligible'::TEXT, NULL::NUMERIC, prog.apply_url,\n    'Free if you receive TANF or Medicaid ($25 fee otherwise). Establishes paternity, creates child support orders, and enforces payment. If cooperating with child support would put you in danger, request the domestic violence good cause exemption from your DFCS worker.'\n  FROM public.programs prog\n  WHERE prog.program_name = 'Child Support Services'\n    AND COALESCE(v_children, 0) > 0;\n\n  -- Medicaid Branch 1: Pregnant → Right from the Start (220% FPL)\n  IF v_pregnant = TRUE THEN\n    RETURN QUERY\n    SELECT prog.id, prog.program_name, prog.program_type,\n      CASE WHEN v_income <= v_fpl * 2.20 THEN 'likely_eligible'\n           WHEN v_income <= v_fpl * 2.42 THEN 'possibly_eligible'\n           ELSE 'ineligible' END,\n      NULL::NUMERIC, prog.apply_url,\n      'Pregnant women qualify up to 220% FPL (Right from the Start Medicaid). Covers prenatal care, delivery, and 60 days postpartum. Apply immediately — coverage can be retroactive to the month you became pregnant.'\n    FROM public.programs prog WHERE prog.program_name = 'Georgia Medicaid';\n  END IF;\n\n  -- Medicaid Branch 2: Children → PeachCare (247% FPL)\n  IF COALESCE(v_children, 0) > 0 THEN\n    RETURN QUERY\n    SELECT prog.id, prog.program_name, prog.program_type,\n      CASE WHEN v_income <= v_fpl * 2.47 THEN 'likely_eligible'\n           WHEN v_income <= v_fpl * 2.72 THEN 'possibly_eligible'\n           ELSE 'ineligible' END,\n      NULL::NUMERIC, prog.apply_url,\n      'Children (PeachCare for Kids) qualify up to 247% FPL. Low or no-cost health coverage for kids under 19.'\n    FROM public.programs prog WHERE prog.program_name = 'Georgia Medicaid';\n  END IF;\n\n  -- Medicaid Branch 3: Adults without children → Pathways (100% FPL + work req)\n  IF v_pregnant IS NOT TRUE AND COALESCE(v_children, 0) = 0 THEN\n    RETURN QUERY\n    SELECT prog.id, prog.program_name, prog.program_type,\n      CASE WHEN v_income <= v_fpl * 1.00 THEN 'possibly_eligible'\n           ELSE 'ineligible' END,\n      NULL::NUMERIC, prog.apply_url,\n      'Georgia Pathways to Coverage (ages 19–64): income limit 100% FPL. Requires 80 hours/month of qualifying activity (work, school, job training, or volunteering). Georgia has NOT expanded Medicaid under the ACA.'\n    FROM public.programs prog WHERE prog.program_name = 'Georgia Medicaid';\n  END IF;\n\n  -- Housing Choice Voucher — always surface with waitlist warning\n  RETURN QUERY\n  SELECT prog.id, prog.program_name, prog.program_type,\n    CASE WHEN v_income <= v_fpl * 0.50 THEN 'possibly_eligible'\n         ELSE 'ineligible' END,\n    NULL::NUMERIC, prog.apply_url,\n    'WAITLIST CURRENTLY CLOSED. Income limit is 50% of Area Median Income. Check atlantahousing.org weekly for project-based voucher openings. While waiting: contact The Drake House (770-587-4712), Atlanta Mission (404-367-2465), BCM Georgia, or AVLF (404-521-0790) for emergency rental assistance.'\n  FROM public.programs prog WHERE prog.program_name = 'Housing Choice Voucher Program';\n\nEND;\n$$;\n\n-- DV flag privacy function\nCREATE OR REPLACE FUNCTION get_my_dv_flag()\nRETURNS BOOLEAN\nLANGUAGE plpgsql SECURITY DEFINER AS $$\nBEGIN\n  RETURN (SELECT domestic_violence FROM public.profiles WHERE user_id = auth.uid());\nEND;\n$$;\n"}	rebuild_eligibility_function	jpender95@gmail.com	\N	\N
20260430161650	{"\nINSERT INTO public.organizations (\n  org_name, category, purpose, phone, website, city, state,\n  counties_served, populations_served, languages_served,\n  flag_dv, flag_eviction, flag_children_u5, flag_pregnant,\n  flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode,\n  active, last_verified_date, source_url\n)\nSELECT org_name, category, purpose, phone, website, city, 'GA',\n  counties_served, populations_served, languages_served,\n  flag_dv, flag_eviction, flag_children_u5, flag_pregnant,\n  flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode,\n  true, '2026-04-30', source_url\nFROM (VALUES\n  ('Homestretch','housing','Transitional housing for families with children','(770) 642-9185','homestretchinc.org','Alpharetta',ARRAY['North Fulton','Gwinnett'],ARRAY['single_mothers','families','children'],ARRAY['en'],false,false,false,false,false,false,false,false,'homestretchinc.org'),\n  ('Sheltering Grace Ministry','housing','Support and housing for pregnant women and mothers with children under 10','(678) 337-7858','shelteringgrace.org','Atlanta',ARRAY['statewide'],ARRAY['single_mothers','pregnant_women','children'],ARRAY['en'],false,false,true,true,false,false,false,false,'shelteringgrace.org'),\n  ('Rainbow Village','housing','Transitional housing for families','(770) 497-1888','rainbowvillage.org','Duluth',ARRAY['North Fulton','Gwinnett'],ARRAY['families','children'],ARRAY['en'],false,false,false,false,false,false,false,false,'rainbowvillage.org'),\n  ('Center for Family Resources','housing','Transitional housing — must be Cobb resident 2+ months with child under 18','(770) 428-2601','cfr-atlanta.org','Marietta',ARRAY['Cobb'],ARRAY['single_mothers','families','children'],ARRAY['en'],false,true,false,false,false,false,false,false,'cfr-atlanta.org'),\n  ('Gateway Center','housing','Client Engagement Center and emergency shelter for Fulton County homeless services','(404) 215-6600','gatewayctr.org','Atlanta',ARRAY['Fulton'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'gatewayctr.org'),\n  ('Right-Hand Foundations','housing','Long-term housing for single mothers with kids','(404) 952-1201',NULL,'Atlanta',ARRAY['statewide'],ARRAY['single_mothers','children'],ARRAY['en'],false,false,false,false,false,false,false,false,NULL),\n  ('Calvary Refuge Center','housing','Emergency night shelter (21 nights) and transitional housing','(404) 361-5309',NULL,'East Point',ARRAY['Fulton'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,NULL),\n  ('Interfaith Outreach Home','housing','Emergency housing for families including teen boys','(770) 457-3727',NULL,'Atlanta',ARRAY['North Fulton'],ARRAY['families','children'],ARRAY['en'],false,true,false,false,false,false,false,false,NULL),\n  ('Decatur Cooperative Ministry','housing','Emergency housing and services for homeless and low-income families in DeKalb County','(404) 687-3500','decaturcm.org','Decatur',ARRAY['DeKalb'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'decaturcm.org'),\n  ('MUST Ministries','housing','Shelter, food, and wraparound services for families in Cobb and Cherokee counties','(770) 427-9862','mustministries.org','Marietta',ARRAY['Cobb','Cherokee'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'mustministries.org'),\n  ('Family Promise of North Fulton','housing','Overnight housing at local congregations plus Day Center for families','(770) 609-5407','familypromise.org','Roswell',ARRAY['North Fulton'],ARRAY['families','children'],ARRAY['en'],false,true,false,false,false,false,false,false,'familypromise.org'),\n  ('Family Promise of Gwinnett','housing','Overnight housing plus Day Center — Gwinnett residents only','(678) 376-8950','familypromise.org','Lawrenceville',ARRAY['Gwinnett'],ARRAY['families','children'],ARRAY['en'],false,true,false,false,false,false,false,false,'familypromise.org'),\n  ('Family Promise of Cobb','housing','Overnight housing plus Day Center for Cobb County families','(678) 594-3150','familypromise.org','Marietta',ARRAY['Cobb'],ARRAY['families','children'],ARRAY['en'],false,true,false,false,false,false,false,false,'familypromise.org'),\n  ('Caring Works','housing','Short and long-term housing for men, women, and children in metro Atlanta','(404) 371-1230','caringworks.org','Atlanta',ARRAY['Fulton','DeKalb'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'caringworks.org'),\n  ('Chris180','housing','Housing and crisis services for youth up to age 24','(404) 486-2900','chris180.org','Atlanta',ARRAY['Fulton','DeKalb'],ARRAY['youth'],ARRAY['en'],false,false,false,false,false,false,false,false,'chris180.org'),\n  ('Mary Hall Freedom Village','housing','Housing for women and children with substance use disorder or chronic homelessness','(470) 260-4263','mhfh.org','Atlanta',ARRAY['Fulton','DeKalb'],ARRAY['single_mothers','children'],ARRAY['en'],false,false,false,false,false,false,false,false,'mhfh.org'),\n  ('Families First','housing','Housing for those with mental health or substance abuse issues, ages 17–26','(404) 853-2844','familiesfirst.org','Atlanta',ARRAY['Fulton','DeKalb'],ARRAY['youth','single_mothers'],ARRAY['en'],false,false,false,false,false,false,false,false,'familiesfirst.org')\n) AS t(org_name,category,purpose,phone,website,city,counties_served,populations_served,languages_served,flag_dv,flag_eviction,flag_children_u5,flag_pregnant,flag_student,flag_immigrant,flag_no_childcare,dv_safety_mode,source_url)\nWHERE NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.org_name = t.org_name);\n"}	sync_new_orgs_batch1_housing	jpender95@gmail.com	\N	\N
20260430161730	{"\nINSERT INTO public.organizations (\n  org_name, category, purpose, phone, website, city, state,\n  counties_served, populations_served, languages_served,\n  flag_dv, flag_eviction, flag_children_u5, flag_pregnant,\n  flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode,\n  active, last_verified_date, source_url\n)\nSELECT org_name, category, purpose, phone, website, city, 'GA',\n  counties_served, populations_served, languages_served,\n  flag_dv, flag_eviction, flag_children_u5, flag_pregnant,\n  flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode,\n  true, '2026-04-30', source_url\nFROM (VALUES\n  ('North Fulton Community Charities','food','Food pantry, clothing, benefit screening, and education programs','(770) 640-0399','nfcc.net','Roswell',ARRAY['North Fulton'],ARRAY['single_mothers','families'],ARRAY['en'],false,false,false,false,false,false,false,false,'nfcc.net'),\n  ('Community Assistance Center','food','Job placement, rent assistance, utilities, and food for Sandy Springs and Dunwoody residents','(770) 552-4015','ourcac.org','Sandy Springs',ARRAY['Fulton'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'ourcac.org'),\n  ('Bloom Closet','food','Free clothing, shoes, books, and toys for children in foster care statewide',NULL,'bloomfosters.org','Atlanta',ARRAY['statewide'],ARRAY['children','foster_care'],ARRAY['en'],false,false,true,false,false,false,false,false,'bloomfosters.org'),\n  ('Operation School Bell (Assistance League of Atlanta)','food','New clothing, uniforms, shoes, and hygiene kits for students in need',NULL,'assistanceleague.org/atlanta','Atlanta',ARRAY['Fulton','DeKalb'],ARRAY['children','single_mothers'],ARRAY['en'],false,false,false,false,true,false,false,false,'assistanceleague.org/atlanta'),\n  ('The Giving Kitchen','food','Emergency financial assistance for food service workers facing a crisis','(404) 254-1227','thegivingkitchen.org','Atlanta',ARRAY['Fulton'],ARRAY['single_mothers'],ARRAY['en'],false,true,false,false,false,false,false,false,'thegivingkitchen.org'),\n  ('Furniture Bank of Metro Atlanta','food','Free furniture for families transitioning out of homelessness','(404) 355-8530','furniturebankatlanta.org','Atlanta',ARRAY['Cobb','Fulton','Gwinnett'],ARRAY['single_mothers','families'],ARRAY['en'],false,false,false,false,false,false,false,false,'furniturebankatlanta.org'),\n  ('Wholesome Wave Georgia','food','Free assistance applying for SNAP and other food benefits — SNAP Connection program',NULL,'wholesomewavega.org','Atlanta',ARRAY['Fulton','DeKalb'],ARRAY['single_mothers','families'],ARRAY['en','es'],false,false,false,false,false,false,false,false,'wholesomewavega.org'),\n  ('Neighborhood Cooperative Ministry','food','Clothing, utility assistance, emergency housing, rent, and prescriptions for Gwinnett residents',NULL,'neighborhoodcm.org','Lawrenceville',ARRAY['Gwinnett'],ARRAY['single_mothers','families'],ARRAY['en','es'],false,true,false,false,false,true,false,false,'neighborhoodcm.org'),\n  ('LiveSafe Resources','health','Domestic violence shelter, elder care, and Haven House for Cobb County residents','(770) 423-3581','livesaferesources.org','Marietta',ARRAY['Cobb'],ARRAY['dv_survivors','single_mothers'],ARRAY['en'],true,false,false,false,false,false,false,true,'livesaferesources.org'),\n  ('Cherokee Family Violence Center','health','Domestic violence shelter and crisis services for Cherokee County residents','(770) 479-1804','cherokeefvc.org','Canton',ARRAY['Cherokee'],ARRAY['dv_survivors','single_mothers'],ARRAY['en'],true,false,false,false,false,false,false,true,'cherokeefvc.org'),\n  ('Clayton County Association Against Family Violence','health','Domestic violence crisis services and shelter for Clayton County residents','(770) 961-7233',NULL,'Jonesboro',ARRAY['Clayton'],ARRAY['dv_survivors','single_mothers'],ARRAY['en'],true,false,false,false,false,false,false,true,NULL),\n  ('Gilgal','health','Women''s residential recovery homes — women only, no children','(404) 305-8007','womenofgilgal.org','Atlanta',ARRAY['Fulton'],ARRAY['single_mothers'],ARRAY['en'],false,false,false,false,false,false,false,false,'womenofgilgal.org'),\n  ('Georgia Legal Services Program','legal','Free legal aid for rural and low-income Georgians statewide — family law, housing, consumer, and benefits','(404) 206-5175','georgialegalaid.org','Atlanta',ARRAY['statewide'],ARRAY['single_mothers','dv_survivors'],ARRAY['en','es'],true,true,false,false,false,false,false,false,'georgialegalaid.org'),\n  ('Atlanta Women''s Foundation','wraparound','Grants to organizations serving women''s economic empowerment — Breaking Barriers, Building Women program','(404) 577-5000','atlantawomen.org','Atlanta',ARRAY['Fulton','DeKalb'],ARRAY['single_mothers'],ARRAY['en'],false,false,false,false,false,false,false,false,'atlantawomen.org'),\n  ('10 Women of Hope','wraparound','Financial crisis assistance for single parents in Cobb County',NULL,'10womenofhope.org','Marietta',ARRAY['Cobb'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'10womenofhope.org'),\n  ('Goodwill of North Georgia','workforce','Job training, paid stipends, and wraparound services including childcare for adults',NULL,'goodwillng.org','Atlanta',ARRAY['statewide'],ARRAY['single_mothers'],ARRAY['en'],false,false,false,false,false,false,true,false,'goodwillng.org'),\n  ('Atlanta Women''s Foundation: Women''s Pathway to Success','workforce','12-week certificate course — graduates earn $50,000+/year in high-demand fields','(404) 577-5000','atlantawomen.org','Atlanta',ARRAY['Fulton','DeKalb'],ARRAY['single_mothers'],ARRAY['en'],false,false,false,false,true,false,false,false,'atlantawomen.org'),\n  ('New American Pathways','immigration','Refugee resettlement, family empowerment, and career services for refugees and immigrants','(404) 299-6099','newamericanpathways.org','Atlanta',ARRAY['statewide'],ARRAY['immigrants','refugees'],ARRAY['en','es'],false,false,false,false,false,true,false,false,'newamericanpathways.org'),\n  ('Raksha','immigration','Services for South Asian-Americans — domestic violence, immigration, and counseling','(404) 876-0670','raksha.org','Atlanta',ARRAY['statewide'],ARRAY['immigrants','dv_survivors'],ARRAY['en'],true,false,false,false,false,true,false,true,'raksha.org'),\n  ('Georgia Asylum & Immigration Network (GAIN)','immigration','Pro bono legal representation for asylum seekers and trafficking victims statewide','(678) 335-6040','georgiaasylum.org','Atlanta',ARRAY['statewide'],ARRAY['immigrants'],ARRAY['en','es'],false,false,false,false,false,true,false,false,'georgiaasylum.org'),\n  ('International Women''s House','immigration','ESL, immigration legal aid, and human trafficking services for immigrant women','(770) 413-5557','iwh.org','Atlanta',ARRAY['statewide'],ARRAY['immigrants','dv_survivors'],ARRAY['en','es'],true,false,false,false,false,true,false,true,'iwh.org'),\n  ('Partnership for Community Action (PCA)','wraparound','Administers LIHEAP for DeKalb, Gwinnett, Rockdale, Newton, and Walton counties','(404) 363-0575','pcaction.org','Decatur',ARRAY['DeKalb','Gwinnett'],ARRAY['single_mothers','families'],ARRAY['en'],false,false,false,false,false,false,false,false,'pcaction.org')\n) AS t(org_name,category,purpose,phone,website,city,counties_served,populations_served,languages_served,flag_dv,flag_eviction,flag_children_u5,flag_pregnant,flag_student,flag_immigrant,flag_no_childcare,dv_safety_mode,source_url)\nWHERE NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.org_name = t.org_name);\n"}	sync_new_orgs_batch2_food_health_legal	jpender95@gmail.com	\N	\N
20260430161756	{"\nINSERT INTO public.organizations (\n  org_name, category, purpose, phone, website, address, city, state,\n  counties_served, populations_served, languages_served,\n  flag_dv, flag_eviction, flag_children_u5, flag_pregnant,\n  flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode,\n  active, last_verified_date, source_url\n)\nSELECT org_name, category, purpose, phone, website, address, city, 'GA',\n  counties_served, populations_served, languages_served,\n  flag_dv, flag_eviction, flag_children_u5, flag_pregnant,\n  flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode,\n  true, '2026-04-30', source_url\nFROM (VALUES\n  ('Fulton County DFCS','government','Apply in person for SNAP, TANF, Medicaid, CAPS, and LIHEAP — main Fulton County office','(404) 206-5000',NULL,'2 Peachtree St NW','Atlanta',ARRAY['Fulton'],ARRAY['single_mothers','families'],ARRAY['en','es'],false,false,false,false,false,false,false,false,NULL),\n  ('DeKalb County DFCS','government','Apply in person for SNAP, TANF, Medicaid, CAPS, and LIHEAP — DeKalb County office','(404) 371-4000',NULL,'178 Sams St','Decatur',ARRAY['DeKalb'],ARRAY['single_mothers','families'],ARRAY['en','es'],false,false,false,false,false,false,false,false,NULL),\n  ('Gwinnett County DFCS','government','Apply in person for SNAP, TANF, Medicaid, CAPS, and LIHEAP — Gwinnett County office','(770) 339-4000',NULL,'750 South Perry St','Lawrenceville',ARRAY['Gwinnett'],ARRAY['single_mothers','families'],ARRAY['en','es'],false,false,false,false,false,false,false,false,NULL),\n  ('Cobb County DFCS','government','Apply in person for SNAP, TANF, Medicaid, CAPS, and LIHEAP — Cobb County office','(770) 528-5800',NULL,'1738 County Services Pkwy','Marietta',ARRAY['Cobb'],ARRAY['single_mothers','families'],ARRAY['en','es'],false,false,false,false,false,false,false,false,NULL),\n  ('Clayton County DFCS','government','Apply in person for SNAP, TANF, Medicaid, CAPS, and LIHEAP — Clayton County office','(404) 363-7500',NULL,'1000 Main St','Forest Park',ARRAY['Clayton'],ARRAY['single_mothers','families'],ARRAY['en','es'],false,false,false,false,false,false,false,false,NULL),\n  ('Cherokee County DFCS','government','Apply in person for SNAP, TANF, Medicaid, CAPS, and LIHEAP — Cherokee County office','(770) 345-7000',NULL,'100 North St','Canton',ARRAY['Cherokee'],ARRAY['single_mothers','families'],ARRAY['en','es'],false,false,false,false,false,false,false,false,NULL),\n  ('Atlanta Housing Authority','government','Section 8 / Housing Choice Voucher program for Fulton County — waitlist currently CLOSED','(404) 892-4700','atlantahousing.org',NULL,'Atlanta',ARRAY['Fulton'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'atlantahousing.org'),\n  ('DeKalb Housing Authority','government','Section 8 / Housing Choice Voucher program for DeKalb County','(404) 270-2100','dekalbhousing.org',NULL,'Decatur',ARRAY['DeKalb'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'dekalbhousing.org'),\n  ('Gwinnett Housing Corporation','government','Section 8 / Housing Choice Voucher program for Gwinnett County','(770) 822-5110','gwinnetthousing.org',NULL,'Lawrenceville',ARRAY['Gwinnett'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'gwinnetthousing.org'),\n  ('Cobb Housing Authority','government','Section 8 / Housing Choice Voucher program for Cobb County','(770) 528-1000','cobbhousing.org',NULL,'Marietta',ARRAY['Cobb'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'cobbhousing.org'),\n  ('Fulton County Coordinated Entry','government','Coordinated entry for all homeless services in Fulton County. South Fulton line: (404) 612-0137','(404) 215-6600',NULL,NULL,'Atlanta',ARRAY['Fulton'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,NULL),\n  ('DeKalb Human Services','government','County human services grants and emergency assistance referrals for DeKalb residents','(470) 543-0754',NULL,NULL,'Decatur',ARRAY['DeKalb'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,NULL),\n  ('Georgia Department of Community Affairs (DCA)','government','Statewide Housing Choice Voucher / Section 8 oversight — statewide tenant-based waitlist currently CLOSED',NULL,'dca.georgia.gov/housing-choice-voucher',NULL,'Atlanta',ARRAY['statewide'],ARRAY['single_mothers','families'],ARRAY['en'],false,true,false,false,false,false,false,false,'dca.georgia.gov/housing-choice-voucher')\n) AS t(org_name,category,purpose,phone,website,address,city,counties_served,populations_served,languages_served,flag_dv,flag_eviction,flag_children_u5,flag_pregnant,flag_student,flag_immigrant,flag_no_childcare,dv_safety_mode,source_url)\nWHERE NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.org_name = t.org_name);\n"}	sync_new_orgs_batch3_government	jpender95@gmail.com	\N	\N
20260522150011	{"\nALTER TABLE programs ADD COLUMN IF NOT EXISTS state text NOT NULL DEFAULT 'GA';\nALTER TABLE application_guides ADD COLUMN IF NOT EXISTS state text NOT NULL DEFAULT 'GA';\nUPDATE programs SET state = 'GA' WHERE state = 'GA';\nUPDATE application_guides SET state = 'GA' WHERE state = 'GA';\nCREATE INDEX IF NOT EXISTS idx_programs_state ON programs(state);\nCREATE INDEX IF NOT EXISTS idx_organizations_state ON organizations(state);\nCREATE INDEX IF NOT EXISTS idx_application_guides_state ON application_guides(state);\n"}	add_state_column_to_programs_and_guides	jpender95@gmail.com	\N	\N
20260522150049	{"\nINSERT INTO programs (\n  program_name, also_known_as, program_type, administering_agency,\n  agency_phone, agency_website, apply_url, eligibility_summary,\n  income_limit_pct_fpl, income_limit_pct_smi, lifetime_limit_months,\n  work_requirement_hrs, renewal_period, counties_served,\n  languages_available, waitlist_status, last_verified_date, source_url, state\n) VALUES\n(\n  'Food and Nutrition Services',\n  'FNS / SNAP / Food Stamps',\n  'food',\n  'NC Department of Health and Human Services (NCDHHS) / County DSS',\n  '1-866-719-0141',\n  'ncdhhs.gov/fns',\n  'epass.nc.gov',\n  'Monthly EBT card to buy groceries. Income must be at or below 130% FPL gross (or up to 200% under Categorical Eligibility). Asset limit $2,750 ($4,250 if a household member is 60+ or disabled). Already on Medicaid, Work First, or SSI? You may qualify automatically.',\n  130,\n  NULL,\n  NULL,\n  NULL,\n  '6 months',\n  ARRAY['statewide'],\n  ARRAY['en', 'es'],\n  'open',\n  '2026-04-10',\n  'https://www.ncdhhs.gov/divisions/child-and-family-well-being/food-and-nutrition-services-food-stamps',\n  'NC'\n),\n(\n  'Women Infants and Children',\n  'WIC',\n  'food',\n  'NC Division of Public Health / Local Health Departments',\n  '1-800-367-2229',\n  'nutritionnc.com/wic',\n  'nutritionnc.com/wic',\n  'Supplemental nutritious foods via eWIC card for pregnant, postpartum, or breastfeeding women and children under 5. Income at or below 185% FPL. Already on Medicaid, Work First, or SNAP? You automatically qualify.',\n  185,\n  NULL,\n  NULL,\n  NULL,\n  '6 months',\n  ARRAY['statewide'],\n  ARRAY['en', 'es'],\n  'open',\n  '2026-04-10',\n  'https://www.nutritionnc.com/wic/',\n  'NC'\n),\n(\n  'Work First Family Assistance',\n  'Work First / TANF',\n  'cash',\n  'NC DHHS / County DSS',\n  '1-800-662-7030',\n  'ncdhhs.gov/divisions/social-services/work-first',\n  'epass.nc.gov',\n  'Monthly cash assistance for families with children under 18. Must have a dependent child deprived of parental support. Must cooperate with Child Support Services. 30 hrs/week work activity required. State lifetime limit: 24 months. Federal lifetime limit: 60 months.',\n  NULL,\n  NULL,\n  24,\n  120,\n  '12 months',\n  ARRAY['statewide'],\n  ARRAY['en', 'es'],\n  'open',\n  '2026-04-10',\n  'https://www.ncdhhs.gov/divisions/social-services/work-first',\n  'NC'\n),\n(\n  'NC Medicaid',\n  'Medicaid / NC Health Choice',\n  'healthcare',\n  'NC DHHS / Division of Health Benefits',\n  '1-888-245-0179',\n  'medicaid.ncdhhs.gov',\n  'epass.nc.gov',\n  'Free or low-cost health coverage. NC EXPANDED Medicaid under the ACA (effective Dec 1, 2023) — adults 19–64 qualify up to 138% FPL with NO work requirement. Pregnant women qualify up to 196% FPL. Children qualify up to 211% FPL. This is different from Georgia — no Pathways work requirement in NC.',\n  138,\n  NULL,\n  NULL,\n  NULL,\n  'annual',\n  ARRAY['statewide'],\n  ARRAY['en', 'es'],\n  'open',\n  '2026-04-10',\n  'https://medicaid.ncdhhs.gov/',\n  'NC'\n),\n(\n  'NC Child Care Subsidy',\n  'Child Care Subsidy / DCDEE',\n  'childcare',\n  'NC DHHS / Division of Child Development and Early Education (DCDEE) / County DSS',\n  '1-800-859-0829',\n  'ncchildcare.ncdhhs.gov',\n  'Apply at county DSS office',\n  'Financial assistance to help low-income working parents afford quality childcare. Child must be under age 13. Parent must be working, in school, or in a training program. Families may pay a co-pay based on income. Note: Many counties have a waitlist — contact your county DSS for current status.',\n  NULL,\n  NULL,\n  NULL,\n  NULL,\n  'annual',\n  ARRAY['statewide'],\n  ARRAY['en', 'es'],\n  'open',\n  '2026-04-10',\n  'https://ncchildcare.ncdhhs.gov/',\n  'NC'\n),\n(\n  'Housing Choice Voucher Program',\n  'Section 8',\n  'housing',\n  'NC Housing Finance Agency / Local Housing Authorities',\n  NULL,\n  'inlivian.com',\n  'inlivian.com',\n  'Rent subsidy capping your share at approximately 30% of your income. Income must be below 50% of Area Median Income. Criminal background check required. WAITLIST FREQUENTLY CLOSED — check Inlivian (Charlotte), Greensboro Housing Authority, and Durham Housing Authority for current openings.',\n  NULL,\n  NULL,\n  NULL,\n  NULL,\n  'annual',\n  ARRAY['Mecklenburg', 'Guilford', 'Durham', 'Wake', 'Orange'],\n  ARRAY['en'],\n  'closed',\n  '2026-04-10',\n  'https://www.inlivian.com/',\n  'NC'\n),\n(\n  'Low-Income Home Energy Assistance Program',\n  'LIHEAP',\n  'housing',\n  'NC DHHS / County DSS / Community Action Agencies',\n  '1-800-662-7030',\n  'ncdhhs.gov/assistance/low-income-services/low-income-energy-assistance',\n  'Apply at county DSS office',\n  'One-time annual payment directly to your utility company for heating or cooling. Income must be at or below 130% FPL. Apply at your county DSS or local Community Action Agency. In Mecklenburg County, apply through Mecklenburg DSS (704-336-3000).',\n  130,\n  NULL,\n  NULL,\n  NULL,\n  'annual',\n  ARRAY['statewide'],\n  ARRAY['en', 'es'],\n  'open',\n  '2026-04-10',\n  'https://www.ncdhhs.gov/assistance/low-income-services/low-income-energy-assistance',\n  'NC'\n),\n(\n  'Child Support Services',\n  'CSS / NC Child Support',\n  'legal',\n  'NC DHHS / Child Support Services',\n  '1-800-992-9457',\n  'ncdhhs.gov/divisions/social-services/child-support-services',\n  'ncdhhs.gov/divisions/social-services/child-support-services',\n  'Free if receiving Work First (TANF) or Medicaid ($25 fee otherwise). Establishes paternity, creates child support orders, and enforces payment via wage garnishment. Work First recipients must cooperate unless domestic violence good cause exemption applies.',\n  NULL,\n  NULL,\n  NULL,\n  NULL,\n  NULL,\n  ARRAY['statewide'],\n  ARRAY['en', 'es'],\n  'open',\n  '2026-04-10',\n  'https://www.ncdhhs.gov/divisions/social-services/child-support-services',\n  'NC'\n);\n"}	insert_nc_programs	jpender95@gmail.com	\N	\N
20260522150157	{"\nINSERT INTO organizations (\n  org_name, category, purpose, phone, crisis_line, email, website,\n  address, city, state, zip_code, counties_served,\n  populations_served, languages_served,\n  intake_process, hours_of_operation,\n  flag_dv, flag_eviction, flag_children_u5, flag_pregnant,\n  flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode,\n  partner_tier, last_verified_date, source_url, active\n) VALUES\n-- 211 NC\n(\n  '211 NC (United Way of North Carolina)',\n  '211',\n  'Information and referral helpline for all NC social services. Call, text, or chat 24/7.',\n  NULL, NULL, NULL, 'https://www.nc211.org',\n  NULL, NULL, 'NC', NULL, ARRAY['statewide'],\n  ARRAY['single mothers','families'], ARRAY['en','es'],\n  'Call or text 211 anytime.', '24/7',\n  false, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.nc211.org', true\n),\n-- NC Child Support Services (state agency)\n(\n  'NC Child Support Services',\n  'child_support',\n  'State agency establishing paternity, child support orders, and enforcement statewide.',\n  '1-800-992-9457', NULL, NULL, 'https://ncdhhs.gov/divisions/social-services/child-support-services',\n  NULL, 'Raleigh', 'NC', NULL, ARRAY['statewide'],\n  ARRAY['single mothers'], ARRAY['en','es'],\n  'Apply at local DSS or online portal.', 'Mon–Fri 8am–5pm',\n  false, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.ncdhhs.gov/divisions/social-services/child-support-services', true\n),\n-- Moms Moving Forward (Freedom Communities) - PRIMARY BETA PARTNER Charlotte\n(\n  'Moms Moving Forward (Freedom Communities)',\n  'wraparound',\n  '12-month cohort program for single mothers offering personal and group coaching, children''s education support, financial literacy, and up to $200/month stipends.',\n  NULL, NULL, 'MMF@freedomcommunities.com', 'https://www.freedomcommunities.com/moms-moving-forward',\n  '3501 Tuckaseegee Road', 'Charlotte', 'NC', '28208', ARRAY['Mecklenburg'],\n  ARRAY['single mothers'], ARRAY['en'],\n  'Apply through freedomcommunities.com or email MMF@freedomcommunities.com.', NULL,\n  false, false, false, false, false, false, false, false,\n  'Tier 1: Beta Partner', '2026-04-10', 'https://www.freedomcommunities.com/moms-moving-forward', true\n),\n-- Charlotte Family Housing\n(\n  'Charlotte Family Housing',\n  'housing',\n  'Temporary housing and long-term housing stability for families. Financial literacy, education, and job readiness to break the cycle of homelessness.',\n  '(704) 335-5488', NULL, NULL, 'https://www.charlottefamilyhousing.org',\n  '300 Hawthorne Lane 3rd Floor', 'Charlotte', 'NC', '28204', ARRAY['Mecklenburg'],\n  ARRAY['families','single mothers'], ARRAY['en'],\n  'Call or apply through website.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.charlottefamilyhousing.org', true\n),\n-- YWCA Central Carolinas\n(\n  'YWCA Central Carolinas',\n  'housing',\n  'Transitional housing and support for women and families via Women in Transition (WIT) and Families Together (FT) programs. Also provides DV services.',\n  '(704) 525-5770', NULL, NULL, 'https://ywcacentralcarolinas.org',\n  '3420 Park Road', 'Charlotte', 'NC', '28209', ARRAY['Mecklenburg'],\n  ARRAY['women','families'], ARRAY['en'],\n  'Call to inquire about programs.', NULL,\n  true, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://ywcacentralcarolinas.org', true\n),\n-- Gracious Hands Housing\n(\n  'Gracious Hands Housing',\n  'housing',\n  'Transitional housing and comprehensive support for homeless single mothers and their children. Includes life skills, therapy, and daycare.',\n  '(704) 962-6147', NULL, 'gracioushandshousing@gmail.com', 'https://www.gracioushandshousing.org',\n  'P.O. Box 680354', 'Charlotte', 'NC', '28216', ARRAY['Mecklenburg'],\n  ARRAY['single mothers'], ARRAY['en'],\n  'Call or email for intake.', NULL,\n  false, false, true, false, false, false, true, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.gracioushandshousing.org', true\n),\n-- Salvation Army Center of Hope\n(\n  'The Salvation Army of Greater Charlotte — Center of Hope',\n  'housing',\n  'Emergency and transitional housing for families. Rapid re-housing and shelter diversion programs. HUD-funded.',\n  '(704) 348-2560', NULL, NULL, 'https://southernusa.salvationarmy.org/greater-charlotte',\n  '534 Spratt Street', 'Charlotte', 'NC', '28206', ARRAY['Mecklenburg'],\n  ARRAY['families'], ARRAY['en'],\n  'Walk in or call during business hours.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://southernusa.salvationarmy.org/greater-charlotte', true\n),\n-- Diaper Bank of NC - Greater Charlotte\n(\n  'Diaper Bank of North Carolina — Greater Charlotte',\n  'baby_supplies',\n  'Distributes diapers, period products, and adult incontinence items through 150+ community partner agencies across Mecklenburg and surrounding counties.',\n  '(980) 900-7364', NULL, 'info@ncdiaperbank.org', 'https://www.ncdiaperbank.org/charlotte',\n  NULL, 'Charlotte', 'NC', NULL, ARRAY['Mecklenburg','surrounding counties'],\n  ARRAY['families','single mothers'], ARRAY['en'],\n  'Apply through partner agencies — see ncdiaperbank.org/charlotte.', NULL,\n  false, false, true, true, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.ncdiaperbank.org/charlotte', true\n),\n-- Baby Bundles\n(\n  'Baby Bundles',\n  'baby_supplies',\n  'Provides a bundle of clothing and essential baby items to families in financial need in the Charlotte area.',\n  NULL, NULL, 'amyfonville@babybundlesnc.org', 'https://babybundlesnc.org',\n  'P.O. Box 12303', 'Charlotte', 'NC', '28220', ARRAY['Mecklenburg'],\n  ARRAY['families','new mothers'], ARRAY['en'],\n  'Email amyfonville@babybundlesnc.org.', NULL,\n  false, false, true, true, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://babybundlesnc.org', true\n),\n-- The Kids & Me\n(\n  'The Kids & Me',\n  'wraparound',\n  'Faith-based support groups and free tutoring (K–12) for single mothers and their children in Charlotte-Mecklenburg.',\n  '(980) 216-8841', NULL, NULL, 'https://www.thekidsandme.org',\n  'PO Box 1227', 'Waxhaw', 'NC', '28173', ARRAY['Mecklenburg'],\n  ARRAY['single mothers'], ARRAY['en'],\n  'Attend a small group meeting — see thekidsandme.org.', NULL,\n  false, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.thekidsandme.org', true\n),\n-- She Built This City\n(\n  'She Built This City',\n  'workforce',\n  'Paid apprenticeship programs in skilled trades for women. 9-week pre-apprenticeship and 2-year paid apprenticeship in facilities maintenance.',\n  '(818) 963-5136', NULL, 'info@shebuiltthiscity.org', 'https://shebuiltthiscity.org',\n  '920 Blairhill Road Suite B117', 'Charlotte', 'NC', '28217', ARRAY['Mecklenburg'],\n  ARRAY['women'], ARRAY['en'],\n  'Apply at shebuiltthiscity.org.', NULL,\n  false, false, false, false, true, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://shebuiltthiscity.org', true\n),\n-- Dress for Success Charlotte\n(\n  'Dress for Success Charlotte',\n  'workforce',\n  'Professional attire, interview styling, Professional Women''s Group, and computer skills training for women entering the workforce.',\n  '(704) 525-7706', NULL, NULL, 'https://charlotte.dressforsuccess.org',\n  '500 Clanton Rd Suite A', 'Charlotte', 'NC', '28217', ARRAY['Mecklenburg'],\n  ARRAY['women'], ARRAY['en'],\n  'Contact by phone or through website.', NULL,\n  false, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://charlotte.dressforsuccess.org', true\n),\n-- Urban League of Central Carolinas\n(\n  'Urban League of Central Carolinas',\n  'workforce',\n  'Workforce development training with industry credentials (HVAC, CNA, IT). Empowers the community to reach financial stability and social justice.',\n  '(704) 373-2256', NULL, 'ulcc@urbanleaguecc.org', 'https://urbanleaguecc.org',\n  '740 West 5th Street', 'Charlotte', 'NC', '28202', ARRAY['Mecklenburg'],\n  ARRAY['single mothers','families'], ARRAY['en'],\n  'Call or email to inquire about programs.', NULL,\n  false, false, false, false, true, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://urbanleaguecc.org', true\n),\n-- Crisis Assistance Ministry\n(\n  'Crisis Assistance Ministry',\n  'emergency_assistance',\n  'Emergency financial assistance for rent and utilities, and a Free Store for clothing and household goods.',\n  '(704) 371-3001', NULL, NULL, 'https://crisisassistance.org',\n  '500-A Spratt St', 'Charlotte', 'NC', '28206', ARRAY['Mecklenburg'],\n  ARRAY['families','single mothers'], ARRAY['en'],\n  'Walk in or call during business hours.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://crisisassistance.org', true\n),\n-- Safe Alliance\n(\n  'Safe Alliance',\n  'dv',\n  'Hope and healing for those impacted by domestic violence, sexual assault, and human trafficking. Emergency shelter, counseling, legal services, and 24/7 crisis line.',\n  NULL, '(980) 771-4673', 'info@safealliance.org', 'https://www.safealliance.org',\n  NULL, 'Charlotte', 'NC', NULL, ARRAY['Mecklenburg'],\n  ARRAY['survivors','women'], ARRAY['en'],\n  'Call the Greater Charlotte Hope Line: (980) 771-4673.', '24/7 crisis line',\n  true, false, false, false, false, false, false, true,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.safealliance.org', true\n),\n-- Legal Aid of NC Charlotte\n(\n  'Legal Aid of North Carolina — Charlotte Office',\n  'legal',\n  'Free civil legal services for low-income people. Housing and eviction defense, family law, domestic violence protective orders, and employment disputes.',\n  '(704) 594-8662', NULL, NULL, 'https://legalaidnc.org',\n  '5525 Albemarle Road Suite 100', 'Charlotte', 'NC', '28212', ARRAY['Mecklenburg'],\n  ARRAY['low-income residents'], ARRAY['en'],\n  'Call to schedule an intake appointment.', NULL,\n  true, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://legalaidnc.org', true\n),\n-- Mecklenburg County Public Health\n(\n  'Mecklenburg County Public Health — Maternal and Child Health',\n  'maternal_health',\n  'WIC, case management, early intervention, and immunizations for parents and children in Mecklenburg County.',\n  '(704) 336-4700', NULL, 'Health@MeckNC.gov', 'https://health.mecknc.gov/Maternal-and-Child-Health',\n  '249 Billingsley Rd', 'Charlotte', 'NC', '28211', ARRAY['Mecklenburg'],\n  ARRAY['pregnant women','families'], ARRAY['en','es'],\n  'Call or email for appointment.', NULL,\n  false, false, true, true, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://health.mecknc.gov/Maternal-and-Child-Health', true\n),\n-- Atrium Health Maternal Wellness\n(\n  'Atrium Health Maternal Wellness Program',\n  'maternal_health',\n  'Psychiatric assessments, individual therapy, group therapy, and medication management for maternal mental health during and after pregnancy.',\n  '(704) 801-9200', NULL, NULL, 'https://atriumhealth.org/medical-services/prevention-wellness/behavioral-health/maternal-wellness-program',\n  NULL, 'Charlotte', 'NC', NULL, ARRAY['Mecklenburg'],\n  ARRAY['pregnant women','postpartum mothers'], ARRAY['en'],\n  'Call for referral or self-referral at (704) 801-9200.', NULL,\n  false, false, false, true, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://atriumhealth.org/medical-services/prevention-wellness/behavioral-health/maternal-wellness-program', true\n),\n-- Mecklenburg DSS\n(\n  'Mecklenburg County DSS',\n  'government',\n  'Apply in person for FNS/SNAP, Work First/TANF, NC Medicaid, NC Child Care Subsidy, and LIHEAP — Mecklenburg County DSS office.',\n  '(704) 336-3000', NULL, NULL, NULL,\n  '3205 Freedom Drive', 'Charlotte', 'NC', '28208', ARRAY['Mecklenburg'],\n  ARRAY['families','single mothers'], ARRAY['en','es'],\n  'Walk in or apply online at epass.nc.gov.', 'Mon–Fri 8am–5pm',\n  false, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.mecknc.gov/dss', true\n),\n-- Inlivian\n(\n  'Inlivian (Charlotte Housing Authority)',\n  'government',\n  'Section 8 / Housing Choice Voucher program for Charlotte/Mecklenburg County. Waitlist frequently closed — check inlivian.com for openings.',\n  NULL, NULL, NULL, 'https://www.inlivian.com',\n  NULL, 'Charlotte', 'NC', NULL, ARRAY['Mecklenburg'],\n  ARRAY['low-income families'], ARRAY['en'],\n  'Apply online at inlivian.com when waitlist is open.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-10', 'https://www.inlivian.com', true\n);\n"}	insert_nc_organizations_charlotte	jpender95@gmail.com	\N	\N
20260522150302	{"\nINSERT INTO organizations (\n  org_name, category, purpose, phone, crisis_line, email, website,\n  address, city, state, zip_code, counties_served,\n  populations_served, languages_served,\n  intake_process, hours_of_operation,\n  flag_dv, flag_eviction, flag_children_u5, flag_pregnant,\n  flag_student, flag_immigrant, flag_no_childcare, dv_safety_mode,\n  partner_tier, last_verified_date, source_url, active\n) VALUES\n-- GREENSBORO / GUILFORD COUNTY\n(\n  'Women''s Resource Center of Greensboro',\n  'wraparound',\n  '\\"Women to Work\\" job-readiness program, legal information network, and community resource counseling for women in Guilford County.',\n  '(336) 275-6090', NULL, 'Info@WomensCenterGSO.org', 'https://womenscentergso.org',\n  '628 Summit Ave', 'Greensboro', 'NC', '27405', ARRAY['Guilford'],\n  ARRAY['women','single mothers'], ARRAY['en'],\n  'Call or email for intake.', NULL,\n  false, false, false, false, true, false, false, false,\n  'Tier 1: Beta Partner', '2026-04-10', 'https://womenscentergso.org', true\n),\n(\n  'Room At The Inn (Greensboro)',\n  'housing',\n  'Licensed maternity home providing comprehensive services, life skills training, and aftercare specifically for homeless pregnant women and single mothers.',\n  '(336) 275-9566', NULL, 'info@roominn.org', 'https://roominn.org',\n  '734 Park Ave', 'Greensboro', 'NC', '27405', ARRAY['Guilford'],\n  ARRAY['pregnant women','single mothers'], ARRAY['en'],\n  'Call or email info@roominn.org.', NULL,\n  false, false, false, true, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://roominn.org', true\n),\n(\n  'Greensboro Urban Ministry',\n  'food',\n  'Operates the Pathways Center (family shelter), Potter''s House Community Kitchen, and food pantry. Massive reach for food assistance in Guilford County.',\n  '(336) 271-5959', NULL, 'bland@guministry.org', 'https://www.greensborourbanministry.org',\n  '305 W Gate City Blvd', 'Greensboro', 'NC', '27406', ARRAY['Guilford'],\n  ARRAY['families','single mothers'], ARRAY['en'],\n  'Walk in or call during business hours.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://www.greensborourbanministry.org', true\n),\n(\n  'The Salvation Army of Greater Greensboro',\n  'emergency_assistance',\n  'Emergency financial assistance for rent and utilities, transitional housing, and workforce development programs.',\n  '(336) 273-5572', NULL, NULL, 'https://southernusa.salvationarmy.org/greensboro',\n  '1001 Freeman Mill Rd', 'Greensboro', 'NC', '27406', ARRAY['Guilford'],\n  ARRAY['families'], ARRAY['en'],\n  'Walk in or call.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://southernusa.salvationarmy.org/greensboro', true\n),\n(\n  'GuilfordWorks',\n  'workforce',\n  'County workforce development board offering career assessments, training grants, NCWorks NextGen youth programs, and NCWorks Career Centers.',\n  '(336) 373-3025', NULL, 'info@guilfordworks.org', 'https://guilfordworks.org',\n  '301 S. Greene St.', 'Greensboro', 'NC', '27401', ARRAY['Guilford'],\n  ARRAY['job seekers'], ARRAY['en'],\n  'Visit an NCWorks Career Center or call.', NULL,\n  false, false, false, false, true, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://guilfordworks.org', true\n),\n(\n  'Backpack Beginnings',\n  'baby_supplies',\n  'Volunteer-driven organization providing essential food and clothing directly to children in need in Guilford County.',\n  '(336) 954-7445', NULL, 'info@backpackbeginnings.org', 'https://backpackbeginnings.org',\n  '3711 Alliance Drive', 'Greensboro', 'NC', '27407', ARRAY['Guilford'],\n  ARRAY['children','families'], ARRAY['en'],\n  'Contact via website or call.', NULL,\n  false, false, true, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'http://backpackbeginnings.org', true\n),\n(\n  'Family Service of the Piedmont',\n  'dv',\n  'Massive agency serving 26,000+ people annually. Domestic violence shelter, mental health counseling, and financial stability programs in Guilford County.',\n  '(336) 387-6161', NULL, 'intake@fspcares.org', 'https://fspcares.org',\n  '902 Bonner Drive', 'Jamestown', 'NC', '27282', ARRAY['Guilford'],\n  ARRAY['survivors','families'], ARRAY['en'],\n  'Call (336) 387-6161 for intake.', NULL,\n  true, false, false, false, false, false, false, true,\n  'nc_seed_2026_04', '2026-04-11', 'https://fspcares.org', true\n),\n(\n  'Guilford County Family Justice Center',\n  'legal',\n  'Centralized multi-disciplinary center offering coordinated safety, legal, and health services for survivors of domestic violence and abuse.',\n  '(336) 641-7233', NULL, 'FJCinfo@guilfordcountync.gov', 'https://www.guilfordcountync.gov/government/departments-and-agencies/family-justice-center',\n  '201 S. Greene St. Second Floor', 'Greensboro', 'NC', '27401', ARRAY['Guilford'],\n  ARRAY['survivors'], ARRAY['en'],\n  'Call or email for services.', NULL,\n  true, false, false, false, false, false, false, true,\n  'nc_seed_2026_04', '2026-04-11', 'https://www.guilfordcountync.gov', true\n),\n(\n  'Guilford County DSS',\n  'government',\n  'Apply in person for FNS/SNAP, Work First/TANF, NC Medicaid, NC Child Care Subsidy, and LIHEAP — Guilford County office.',\n  '(336) 641-3000', NULL, NULL, NULL,\n  '1203 Maple Street', 'Greensboro', 'NC', '27405', ARRAY['Guilford'],\n  ARRAY['families'], ARRAY['en','es'],\n  'Walk in or apply at epass.nc.gov.', 'Mon–Fri 8am–5pm',\n  false, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', NULL, true\n),\n-- DURHAM COUNTY\n(\n  'Unexpected NC',\n  'wraparound',\n  'Skill-building classes, emergency supplies, and vital support system for low-income, young, single mothers in Durham.',\n  '(919) 717-7298', NULL, 'info@unexpectednc.org', 'https://unexpectednc.org',\n  NULL, 'Morrisville', 'NC', NULL, ARRAY['Durham','Wake'],\n  ARRAY['young single mothers'], ARRAY['en'],\n  'Email info@unexpectednc.org or call.', NULL,\n  false, false, false, true, false, false, false, false,\n  'Tier 1: Beta Partner', '2026-04-11', 'https://unexpectednc.org', true\n),\n(\n  'Families Moving Forward (FMF)',\n  'housing',\n  'Premier Durham organization for families experiencing homelessness. Temporary housing (The NEST), after-school tutoring, and early intervention.',\n  '(919) 683-5878', NULL, 'JOE@FMFNC.ORG', 'https://fmfnc.org',\n  '300 N QUEEN ST', 'Durham', 'NC', '27701', ARRAY['Durham'],\n  ARRAY['families'], ARRAY['en'],\n  'Call or email for intake.', NULL,\n  false, true, true, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://fmfnc.org', true\n),\n(\n  'Durham Rescue Mission',\n  'shelter',\n  'Oldest and largest long-term shelter in Durham. Operates Good Samaritan Inn specifically for women and mothers with children.',\n  '(919) 688-9641', NULL, 'info@durhamrescuemission.org', 'https://durhamrescuemission.org',\n  '1201 East Main Street', 'Durham', 'NC', '27701', ARRAY['Durham'],\n  ARRAY['women','mothers'], ARRAY['en'],\n  'Walk in or call.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://durhamrescuemission.org', true\n),\n(\n  'Durham Community Food Pantry (Catholic Charities)',\n  'food',\n  'Massive food distribution hub operated by Catholic Charities serving both Durham and Orange counties.',\n  '(919) 286-1964', NULL, 'jeremy.ireland@ccharitiesdor.org', 'https://www.catholiccharitiesraleigh.org/programs/durham-community-food-pantry/',\n  '2020 Chapel Hill Rd Suite 30', 'Durham', 'NC', '27707', ARRAY['Durham','Orange'],\n  ARRAY['families'], ARRAY['en','es'],\n  'Walk in during distribution hours.', NULL,\n  false, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://www.catholiccharitiesraleigh.org/programs/durham-community-food-pantry/', true\n),\n(\n  'Durham Workforce Development Board',\n  'workforce',\n  'Job search assistance, skills training, and career development programs funded by US Department of Labor and NC Department of Commerce.',\n  '(919) 560-4965', NULL, 'Russell.Ingram@durhamnc.gov', 'https://durhamworks.org',\n  '807 E. Main Street Suite 5-100', 'Durham', 'NC', '27701', ARRAY['Durham'],\n  ARRAY['job seekers'], ARRAY['en'],\n  'Visit an NCWorks Career Center or call.', NULL,\n  false, false, false, false, true, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://durhamworks.org', true\n),\n(\n  'Family Connects Durham',\n  'maternal_health',\n  'Free postpartum nurse home visits for ALL parents of newborns in Durham County — regardless of income. Funded by The Duke Endowment.',\n  '(919) 419-3474', NULL, 'tracydellangela@ccfhnc.org', 'https://www.ccfhnc.org/programs/family-connects-durham/',\n  '1121 W. Chapel Hill St Suite 100', 'Durham', 'NC', '27701', ARRAY['Durham'],\n  ARRAY['all new parents'], ARRAY['en'],\n  'Call or email — all Durham County newborns are eligible.', NULL,\n  false, false, true, true, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://www.ccfhnc.org/programs/family-connects-durham/', true\n),\n(\n  'Durham Crisis Response Center (DCRC)',\n  'dv',\n  '24-hour help line, emergency shelter, crisis intervention, and legal advocacy for survivors of domestic and family violence in Durham.',\n  NULL, '(919) 403-6562', 'info@thedcrc.org', 'https://www.thedcrc.org',\n  '101 E. Morgan St.', 'Durham', 'NC', '27701', ARRAY['Durham'],\n  ARRAY['survivors'], ARRAY['en'],\n  'Call the 24-hour line: (919) 403-6562.', '24/7',\n  true, false, false, false, false, false, false, true,\n  'nc_seed_2026_04', '2026-04-11', 'https://www.thedcrc.org', true\n),\n(\n  'Legal Aid of North Carolina — Durham Office',\n  'legal',\n  'Free civil legal services. Eviction defense, family law, domestic violence protective orders, and employment disputes.',\n  '(919) 493-2665', NULL, NULL, 'https://legalaidnc.org',\n  NULL, 'Durham', 'NC', NULL, ARRAY['Durham','Orange'],\n  ARRAY['low-income residents'], ARRAY['en'],\n  'Call to schedule an intake appointment.', NULL,\n  true, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://legalaidnc.org', true\n),\n(\n  'Durham County DSS',\n  'government',\n  'Apply in person for FNS/SNAP, Work First/TANF, NC Medicaid, NC Child Care Subsidy, and LIHEAP — Durham County office.',\n  '(919) 560-8000', NULL, NULL, 'https://www.dconc.gov/county-departments/departments-f-z/social-services',\n  '414 E. Main Street', 'Durham', 'NC', '27701', ARRAY['Durham'],\n  ARRAY['families'], ARRAY['en','es'],\n  'Walk in or apply at epass.nc.gov.', 'Mon–Fri 8am–5pm',\n  false, false, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://www.dconc.gov/county-departments/departments-f-z/social-services', true\n),\n(\n  'Durham Housing Authority',\n  'government',\n  'Section 8 / Housing Choice Voucher program for Durham County. Waitlist frequently closed — check durhamnc.gov for openings.',\n  '(919) 683-1551', NULL, NULL, 'https://www.durhamhousingauthority.org',\n  '330 E. Main Street', 'Durham', 'NC', '27701', ARRAY['Durham'],\n  ARRAY['low-income families'], ARRAY['en'],\n  'Apply online when waitlist is open.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://www.durhamhousingauthority.org', true\n),\n(\n  'Legal Aid of North Carolina — Greensboro Office',\n  'legal',\n  'Free civil legal services. Eviction defense, family law, domestic violence protective orders, and employment disputes for Guilford County residents.',\n  '(336) 272-0148', NULL, NULL, 'https://legalaidnc.org',\n  NULL, 'Greensboro', 'NC', NULL, ARRAY['Guilford'],\n  ARRAY['low-income residents'], ARRAY['en'],\n  'Call to schedule an intake appointment.', NULL,\n  true, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://legalaidnc.org', true\n),\n(\n  'Greensboro Housing Authority',\n  'government',\n  'Section 8 / Housing Choice Voucher program for Greensboro/Guilford County. Waitlist status varies — check gha-nc.org.',\n  '(336) 275-8501', NULL, NULL, 'https://www.gha-nc.org',\n  '450 N Church Street', 'Greensboro', 'NC', '27401', ARRAY['Guilford'],\n  ARRAY['low-income families'], ARRAY['en'],\n  'Apply online when waitlist is open.', NULL,\n  false, true, false, false, false, false, false, false,\n  'nc_seed_2026_04', '2026-04-11', 'https://www.gha-nc.org', true\n);\n"}	insert_nc_organizations_greensboro_durham	jpender95@gmail.com	\N	\N
20260522150326	{"\nWITH nc_programs AS (\n  SELECT id, program_name FROM programs WHERE state = 'NC'\n),\nguide_inserts AS (\n  INSERT INTO application_guides (program_id, guide_name, overview, apply_url, phone, last_verified, source_url, state)\n  SELECT\n    p.id,\n    g.guide_name,\n    g.overview,\n    g.apply_url,\n    g.phone,\n    '2026-04-10'::date,\n    g.source_url,\n    'NC'\n  FROM (VALUES\n    ('Food and Nutrition Services', 'How to Apply for FNS (Food Stamps) in North Carolina',\n     'FNS gives you a monthly EBT card to buy groceries. The whole process takes about 30 days from application to receiving your card. You apply online through ePASS — not Georgia Gateway.',\n     'epass.nc.gov', '1-866-719-0141', 'https://www.ncdhhs.gov/divisions/child-and-family-well-being/food-and-nutrition-services-food-stamps'),\n    ('Women Infants and Children', 'How to Apply for WIC in North Carolina',\n     'WIC provides nutritious foods via eWIC card, nutrition education, and breastfeeding support. Apply at your local health department WIC clinic — not at the DSS office.',\n     'nutritionnc.com/wic', '1-800-367-2229', 'https://www.nutritionnc.com/wic/'),\n    ('Work First Family Assistance', 'How to Apply for Work First (Cash Assistance) in North Carolina',\n     'Work First provides monthly cash assistance for families with children. NC''s lifetime limit is 24 months (federal is 60 months). Apply through ePASS or your county DSS.',\n     'epass.nc.gov', '1-800-662-7030', 'https://www.ncdhhs.gov/divisions/social-services/work-first'),\n    ('NC Medicaid', 'How to Apply for NC Medicaid',\n     'NC Medicaid covers doctor visits, prescriptions, and hospital care at little or no cost. NC EXPANDED Medicaid in December 2023 — adults 19–64 qualify up to 138% FPL with NO work requirement. This is different from Georgia.',\n     'epass.nc.gov', '1-888-245-0179', 'https://medicaid.ncdhhs.gov/'),\n    ('Housing Choice Voucher Program', 'How to Apply for Section 8 in North Carolina',\n     'Section 8 caps your rent at approximately 30% of your income. Waitlists are frequently closed. This guide covers Charlotte (Inlivian), Greensboro (GHA), and Durham (DHA).',\n     'inlivian.com', NULL, 'https://www.inlivian.com/'),\n    ('NC Child Care Subsidy', 'How to Apply for NC Child Care Subsidy',\n     'The NC Child Care Subsidy helps low-income working parents afford quality childcare. Apply at your county DSS — not through an online portal. Many counties have waitlists.',\n     'Apply at county DSS', '1-800-859-0829', 'https://ncchildcare.ncdhhs.gov/')\n  ) AS g(program_name, guide_name, overview, apply_url, phone, source_url)\n  JOIN nc_programs p ON p.program_name = g.program_name\n  RETURNING id, guide_name\n)\nSELECT id, guide_name FROM guide_inserts;\n"}	insert_nc_application_guides_and_steps	jpender95@gmail.com	\N	\N
20260522150453	{"\nINSERT INTO guide_steps (guide_id, step_number, title, description, plain_english, tip, url)\nSELECT ag.id, s.step_number, s.title, s.description, s.plain_english, s.tip, s.url\nFROM application_guides ag\nCROSS JOIN LATERAL (VALUES\n\n-- FNS / SNAP GUIDE\n(CASE WHEN ag.guide_name = 'How to Apply for FNS (Food Stamps) in North Carolina' THEN 1 END,\n 'Check your eligibility',\n 'Income must be at or below 130% FPL gross (or up to 200% under Categorical Eligibility). Asset limit $2,750. Already on NC Medicaid, Work First, or SSI? You may qualify automatically.',\n 'If you''re already on Medicaid or Work First, you can skip the income check — you automatically qualify.',\n 'Apply even if you think you might not qualify — the income limits are higher than most people expect.',\n 'epass.nc.gov'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for FNS (Food Stamps) in North Carolina' THEN 2 END,\n 'Apply through ePASS (not Georgia Gateway)',\n 'Go to epass.nc.gov and create an account. Select \\"Food and Nutrition Services.\\" NC uses ePASS, not Georgia Gateway. Do not try to apply at gateway.ga.gov.',\n 'Create an account at epass.nc.gov. It takes about 20–30 minutes.',\n 'You can also call your county DSS or walk in to apply in person if you prefer.',\n 'epass.nc.gov'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for FNS (Food Stamps) in North Carolina' THEN 3 END,\n 'Complete the required interview',\n 'A DSS caseworker will contact you for a required phone or in-person interview. Answer all questions honestly — this is a quick call.',\n 'DSS will call you to ask a few questions about your household and income.',\n 'If you miss the call, call your county DSS back the same day — missing the interview can delay your benefits.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for FNS (Food Stamps) in North Carolina' THEN 4 END,\n 'Provide required documents',\n 'Photo ID, Social Security Numbers for all household members, proof of citizenship or immigration status, proof of income (pay stubs, employer letter, benefit letters), proof of expenses (rent, utilities, childcare costs), proof of NC residency (utility bill or lease).',\n 'Upload or bring in: your ID, SSN cards, proof of income, and proof of where you live.',\n 'Upload documents through ePASS for the fastest processing. Incomplete documents are the top reason for delays.',\n 'epass.nc.gov'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for FNS (Food Stamps) in North Carolina' THEN 5 END,\n 'Receive your EBT card and renew every 6–12 months',\n 'You will be notified of your decision within 30 days. If approved, your EBT card will be mailed. Recertify every 6 or 12 months as instructed by your county DSS.',\n 'Your EBT card arrives by mail in about 1–2 weeks after approval. Renew on time or benefits stop.',\n 'Set a phone reminder for 30 days before your renewal date.',\n NULL),\n\n-- WIC GUIDE\n(CASE WHEN ag.guide_name = 'How to Apply for WIC in North Carolina' THEN 1 END,\n 'Check your eligibility',\n 'Pregnant women, breastfeeding mothers (up to 12 months), postpartum women (up to 6 months), and children under 5. Income at or below 185% FPL — or automatic if already on Medicaid, SNAP, or Work First.',\n 'If you''re pregnant or have a child under 5, you very likely qualify. Already on Medicaid? You automatically qualify.',\n 'Apply as early as possible during pregnancy — WIC benefits start right away.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for WIC in North Carolina' THEN 2 END,\n 'Find your nearest WIC clinic',\n 'Visit nutritionnc.com/wic and enter your county to find the nearest health department WIC clinic. WIC in NC is administered through local health departments — not through DSS.',\n 'Go to nutritionnc.com/wic and click \\"find WIC near me\\" to find the office closest to you.',\n 'The WIC office is at your county health department, not the DSS benefits office.',\n 'nutritionnc.com/wic'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for WIC in North Carolina' THEN 3 END,\n 'Schedule your intake appointment',\n 'Call the clinic to schedule an intake appointment. Bring: photo ID, proof of NC residency, proof of income, proof of pregnancy (if applicable), and your child''s immunization records.',\n 'Call the clinic to make an appointment. Bring your ID, proof of where you live, and proof of income.',\n 'Call early — some clinics book out 1–2 weeks. Bring your baby''s shot records if your child is already born.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for WIC in North Carolina' THEN 4 END,\n 'Attend your nutrition assessment',\n 'A WIC health professional will review your documents, assess nutritional risk (required for enrollment), and issue your eWIC card and benefits.',\n 'At your appointment, a WIC staff member checks your documents and issues your eWIC card. The whole visit is about an hour.',\n 'WIC foods include milk, eggs, bread, cereal, juice, peanut butter, fresh fruits and vegetables, infant formula, and baby food.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for WIC in North Carolina' THEN 5 END,\n 'Use your eWIC card and renew',\n 'Shop at any authorized NC WIC vendor using your eWIC card. Women renew every 6 months; children renew annually.',\n 'Swipe your eWIC card like a debit card at the grocery store checkout. Only WIC-approved items will go through.',\n 'Look for the WIC shelf tag when shopping. Not everything in the store is approved — check the NC WIC Approved Food List app.',\n NULL),\n\n-- WORK FIRST / TANF GUIDE\n(CASE WHEN ag.guide_name = 'How to Apply for Work First (Cash Assistance) in North Carolina' THEN 1 END,\n 'Understand the Work First program',\n 'Work First is NC''s version of TANF. You must have a child under 18 who is deprived of parental support, be a US citizen or lawful resident, and be an NC resident. NC state lifetime limit is 24 months. Federal lifetime limit is 60 months.',\n 'Work First gives monthly cash to families with children. You must participate in work activities 30 hrs/week.',\n 'NC has a 24-month state lifetime limit — shorter than the federal 60-month limit. Keep track of how many months you have used.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for Work First (Cash Assistance) in North Carolina' THEN 2 END,\n 'Apply through ePASS or at your county DSS',\n 'Apply at epass.nc.gov or visit your local county DSS office in person. You can also call 1-800-662-7030.',\n 'Go to epass.nc.gov or walk into your county DSS office to apply.',\n 'In-person applications at the DSS office can sometimes be processed faster.',\n 'epass.nc.gov'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for Work First (Cash Assistance) in North Carolina' THEN 3 END,\n 'Complete your interview and sign the Mutual Responsibility Agreement (MRA)',\n 'A Work First caseworker will interview you and require you to sign an MRA agreeing to participate in 30 hrs/week of work activities (work, training, education, or job search).',\n 'You''ll meet with a caseworker and sign an agreement to participate in work activities. This is required.',\n 'If you are a domestic violence survivor, you may be exempt from work requirements — tell your caseworker.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for Work First (Cash Assistance) in North Carolina' THEN 4 END,\n 'Cooperate with Child Support Services',\n 'You must cooperate with NC Child Support Services to establish and collect child support from the non-custodial parent. If you are fleeing domestic violence, a good cause exemption applies — tell your caseworker.',\n 'DSS will connect you with Child Support Services to collect support from the other parent.',\n 'The child support collected goes to you, not back to the state. This is money that belongs to your family.',\n 'ncdhhs.gov/divisions/social-services/child-support-services'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for Work First (Cash Assistance) in North Carolina' THEN 5 END,\n 'Receive benefits and renew',\n 'Monthly cash is loaded to your EBT card. Benefits renew every 12 months as long as you remain eligible and complete your work activities.',\n 'Cash is loaded to your EBT card each month. Keep doing your work activities and renew every year.',\n 'Work First can help you pay for childcare and transportation while you participate in activities — ask your caseworker.',\n NULL),\n\n-- NC MEDICAID GUIDE\n(CASE WHEN ag.guide_name = 'How to Apply for NC Medicaid' THEN 1 END,\n 'Determine which Medicaid category fits you',\n 'Adults 19–64: Medicaid Expansion — income up to 138% FPL, NO work requirement (NC expanded Dec 1, 2023). Pregnant women: up to 196% FPL. Children (NC Health Choice/Medicaid): up to 211% FPL. This is different from Georgia which did NOT expand Medicaid.',\n 'If you are an adult in NC, you qualify for Medicaid at 138% FPL with no work requirement — this changed in December 2023.',\n 'Even if you were denied Medicaid before December 2023, apply again now. NC expanded coverage significantly.',\n 'medicaid.ncdhhs.gov'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for NC Medicaid' THEN 2 END,\n 'Apply through ePASS',\n 'The fastest way is through epass.nc.gov. Or call 1-888-245-0179 or visit your county DSS office in person.',\n 'Go to epass.nc.gov and select Medicaid. It takes about 20 minutes.',\n 'NC uses ePASS — not Georgia Gateway. Make sure you are at epass.nc.gov.',\n 'epass.nc.gov'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for NC Medicaid' THEN 3 END,\n 'Submit your documents',\n 'Proof of identity, Social Security Number, proof of NC residency, proof of income, and proof of pregnancy (if applicable).',\n 'Upload your ID, proof of where you live, and proof of income through ePASS.',\n 'If you are pregnant, include your due date or a letter from your doctor — this triggers faster processing.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for NC Medicaid' THEN 4 END,\n 'Receive your Medicaid card and renew annually',\n 'If approved, your Medicaid card arrives by mail. You can use it at any NC Medicaid-accepting provider immediately. Renew annually — watch for renewal notices in the mail.',\n 'Your NC Medicaid card arrives in 1–2 weeks. Use it at your doctor''s office like an insurance card.',\n 'If you have a newborn, call DSS immediately — newborns can be added to Medicaid retroactively from birth.',\n NULL),\n\n-- SECTION 8 NC GUIDE\n(CASE WHEN ag.guide_name = 'How to Apply for Section 8 in North Carolina' THEN 1 END,\n 'Find an open waitlist — this is the critical first step',\n 'Check waitlist status at: Charlotte/Mecklenburg: Inlivian (inlivian.com). Greensboro/Guilford: Greensboro Housing Authority (gha-nc.org). Durham: Durham Housing Authority (durhamhousingauthority.org). Wake/Raleigh: Raleigh Housing Authority (rhaonline.com). Most waitlists are closed.',\n 'All NC Section 8 waitlists open and close unpredictably. Check each city''s housing authority website regularly.',\n 'Sign up for email alerts on each housing authority website. When a waitlist opens, you usually have 48–72 hours to apply.',\n 'inlivian.com'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for Section 8 in North Carolina' THEN 2 END,\n 'Apply immediately when a waitlist opens',\n 'When a waitlist opens, apply the same day at the housing authority''s website. Waitlists can fill within hours. You will need: photo ID, SSNs for all household members, proof of income.',\n 'Apply the moment you see a waitlist is open — they close fast.',\n 'Set a Google Alert for \\"Inlivian waitlist\\" and \\"Section 8 Charlotte\\" to get notified quickly.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for Section 8 in North Carolina' THEN 3 END,\n 'Apply for emergency housing while you wait',\n 'Waitlists can take 2–5+ years. Apply now for emergency help: Crisis Assistance Ministry Charlotte (704-371-3001), Families Moving Forward Durham (919-683-5878), Greensboro Urban Ministry (336-271-5959). Also apply for Salvation Army transitional housing.',\n 'Don''t just wait for Section 8 — apply for emergency and transitional housing now while you''re on the list.',\n 'Getting into transitional housing now does NOT affect your Section 8 waitlist position.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for Section 8 in North Carolina' THEN 4 END,\n 'Complete the full application when your name comes up',\n 'When selected from the waitlist, you will have a limited window (usually 30 days) to complete the full application, submit all documents, and pass a criminal background check.',\n 'When the housing authority contacts you, respond within the deadline — missing it removes you from the list.',\n 'Keep your address and phone number updated with the housing authority every time you move.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for Section 8 in North Carolina' THEN 5 END,\n 'Find a unit and sign your lease',\n 'Once you receive a voucher you have 60–120 days to find a private landlord who accepts Section 8. The unit must pass a HUD inspection. The Housing Authority pays a portion of rent directly to the landlord; you pay approximately 30% of your income.',\n 'Find a landlord who accepts Section 8 within your time window. The housing authority will inspect the apartment before you move in.',\n 'Ask Families Moving Forward (Durham) or Charlotte Family Housing for help finding Section 8 landlords — they know which ones are accepting.',\n NULL),\n\n-- NC CHILD CARE SUBSIDY GUIDE\n(CASE WHEN ag.guide_name = 'How to Apply for NC Child Care Subsidy' THEN 1 END,\n 'Check your eligibility',\n 'NC resident, child under age 13, parent must be working, in school, or in a training program, and family income cannot exceed specific limits based on family size. Many counties have waitlists — apply early.',\n 'You need to be working or in school or training. Your child must be under 13.',\n 'The NC Child Care Subsidy is administered by your county DSS — not through an online portal like ePASS.',\n 'ncchildcare.ncdhhs.gov'),\n\n(CASE WHEN ag.guide_name = 'How to Apply for NC Child Care Subsidy' THEN 2 END,\n 'Contact your county DSS to apply in person',\n 'Unlike most NC programs, the Child Care Subsidy cannot be applied for through ePASS. You must contact your county DSS office directly: Mecklenburg: (704) 336-3000 | Guilford: (336) 641-3000 | Durham: (919) 560-8000.',\n 'Call your county DSS to start the application. This one cannot be done online — you must go in person or call.',\n 'Childcare Resource Inc. (CCRI) in Mecklenburg (704-376-6697) can help you navigate the application process.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for NC Child Care Subsidy' THEN 3 END,\n 'Be aware of county waitlists',\n 'Many NC counties have waitlists for the Child Care Subsidy. Ask DSS your current waitlist position and estimated wait time. Your spot on the waitlist is NOT affected by applying for other programs.',\n 'There may be a waitlist. Get on it as soon as possible — the sooner you apply, the sooner you move up.',\n 'While waiting, ask Crisis Assistance Ministry (Charlotte) or similar emergency assistance orgs about temporary childcare help.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for NC Child Care Subsidy' THEN 4 END,\n 'Provide your documents',\n 'Proof of NC residency, photo ID, child''s birth certificate, immunization records, and proof of employment or school enrollment.',\n 'Bring your ID, your child''s birth certificate and shot records, and proof that you are working or in school.',\n 'If your employer can write a letter confirming your work hours, bring it — it speeds up the process significantly.',\n NULL),\n\n(CASE WHEN ag.guide_name = 'How to Apply for NC Child Care Subsidy' THEN 5 END,\n 'Find an approved childcare provider and renew annually',\n 'Choose a state-licensed childcare facility that accepts subsidy payments. Ask DSS for a list of approved providers in your county. Renew your eligibility annually.',\n 'Once approved, enroll your child in any licensed childcare provider that accepts the NC subsidy.',\n 'Ask the childcare provider before enrolling whether they accept the NC Child Care Subsidy — not all do.',\n 'ncchildcare.ncdhhs.gov')\n\n) AS s(step_number, title, description, plain_english, tip, url)\nWHERE ag.state = 'NC' AND s.step_number IS NOT NULL;\n"}	insert_nc_guide_steps	jpender95@gmail.com	\N	\N
20260522150524	{"\n-- NC FNS/SNAP income thresholds (2025 FPL: 130% gross limit)\nINSERT INTO income_thresholds (program_id, household_size, income_limit, income_limit_yr, benefit_amount, notes)\nSELECT p.id, t.hh, t.monthly_limit, t.annual_limit, t.max_benefit, t.notes\nFROM programs p\nCROSS JOIN (VALUES\n  (1, 1580, 18960, 291, 'Gross income at 130% FPL for HH of 1. Net limit (100% FPL) = $1,215/mo.'),\n  (2, 2137, 25644, 535, 'Gross income at 130% FPL for HH of 2.'),\n  (3, 2694, 32328, 766, 'Gross income at 130% FPL for HH of 3.'),\n  (4, 3250, 39000, 973, 'Gross income at 130% FPL for HH of 4.'),\n  (5, 3807, 45684, 1155, 'Gross income at 130% FPL for HH of 5.')\n) AS t(hh, monthly_limit, annual_limit, max_benefit, notes)\nWHERE p.program_name = 'Food and Nutrition Services' AND p.state = 'NC';\n\n-- NC WIC income thresholds (185% FPL)\nINSERT INTO income_thresholds (program_id, household_size, income_limit, income_limit_yr, notes)\nSELECT p.id, t.hh, t.monthly_limit, t.annual_limit, t.notes\nFROM programs p\nCROSS JOIN (VALUES\n  (1, 2248, 26973, 'WIC income limit: 185% FPL for HH of 1.'),\n  (2, 3041, 36482, 'WIC income limit: 185% FPL for HH of 2.'),\n  (3, 3833, 45990, 'WIC income limit: 185% FPL for HH of 3.'),\n  (4, 4625, 55500, 'WIC income limit: 185% FPL for HH of 4.'),\n  (5, 5418, 65010, 'WIC income limit: 185% FPL for HH of 5.')\n) AS t(hh, monthly_limit, annual_limit, notes)\nWHERE p.program_name = 'Women Infants and Children' AND p.state = 'NC';\n\n-- NC Medicaid expansion thresholds (138% FPL for adults)\nINSERT INTO income_thresholds (program_id, household_size, income_limit, income_limit_yr, notes)\nSELECT p.id, t.hh, t.monthly_limit, t.annual_limit, t.notes\nFROM programs p\nCROSS JOIN (VALUES\n  (1, 1677, 20120, 'NC Medicaid expansion: 138% FPL adult. No work requirement.'),\n  (2, 2269, 27228, 'NC Medicaid expansion: 138% FPL for HH of 2.'),\n  (3, 2861, 34332, 'NC Medicaid expansion: 138% FPL for HH of 3.'),\n  (4, 3453, 41436, 'NC Medicaid expansion: 138% FPL for HH of 4.'),\n  (5, 4045, 48540, 'NC Medicaid expansion: 138% FPL for HH of 5.')\n) AS t(hh, monthly_limit, annual_limit, notes)\nWHERE p.program_name = 'NC Medicaid' AND p.state = 'NC';\n\n-- Documents required for FNS/SNAP in NC\nINSERT INTO documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, d.doc_name, d.description, d.required, d.conditional_on\nFROM programs p\nCROSS JOIN (VALUES\n  ('Photo ID', 'Driver''s license, state ID, or passport', true, NULL),\n  ('Social Security Number', 'SSN for all household members who are applying', true, NULL),\n  ('Proof of citizenship or immigration status', 'US birth certificate, passport, or immigration documents', true, NULL),\n  ('Proof of income', 'Last 30 days of pay stubs, employer letter, or benefit award letters', true, NULL),\n  ('Proof of expenses', 'Rent/mortgage statement, utility bills, childcare receipts', true, NULL),\n  ('Proof of NC residency', 'Current utility bill, lease agreement, or official mail with address', true, NULL),\n  ('Proof of child support paid', 'If paying child support, provide documentation for deduction', false, 'paying child support')\n) AS d(doc_name, description, required, conditional_on)\nWHERE p.program_name = 'Food and Nutrition Services' AND p.state = 'NC';\n\n-- Documents required for WIC in NC\nINSERT INTO documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, d.doc_name, d.description, d.required, d.conditional_on\nFROM programs p\nCROSS JOIN (VALUES\n  ('Photo ID', 'Driver''s license, state ID, or passport', true, NULL),\n  ('Proof of NC residency', 'Utility bill, lease, or official mail', true, NULL),\n  ('Proof of income', 'Pay stubs, tax return, or benefit letters — waived if already on Medicaid/SNAP', false, 'not already on Medicaid or SNAP'),\n  ('Proof of pregnancy', 'Letter from doctor or midwife confirming due date', false, 'pregnant'),\n  ('Child''s immunization records', 'Shot records for children enrolling in WIC', false, 'enrolling children')\n) AS d(doc_name, description, required, conditional_on)\nWHERE p.program_name = 'Women Infants and Children' AND p.state = 'NC';\n\n-- Documents required for Work First/TANF in NC\nINSERT INTO documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, d.doc_name, d.description, d.required, d.conditional_on\nFROM programs p\nCROSS JOIN (VALUES\n  ('Social Security Numbers', 'SSNs for all household members', true, NULL),\n  ('Birth certificates', 'Birth certificates for all children', true, NULL),\n  ('Proof of income', 'All income sources — pay stubs, child support, benefits', true, NULL),\n  ('Proof of NC residency', 'Utility bill, lease, or official mail', true, NULL),\n  ('Children''s immunization records', 'Required — children must be immunized', true, NULL),\n  ('Proof of school enrollment', 'School enrollment confirmation for children', true, NULL)\n) AS d(doc_name, description, required, conditional_on)\nWHERE p.program_name = 'Work First Family Assistance' AND p.state = 'NC';\n\n-- Documents required for NC Medicaid\nINSERT INTO documents_required (program_id, document_name, description, required, conditional_on)\nSELECT p.id, d.doc_name, d.description, d.required, d.conditional_on\nFROM programs p\nCROSS JOIN (VALUES\n  ('Photo ID', 'Driver''s license, state ID, or passport', true, NULL),\n  ('Social Security Number', 'SSN for all applying household members', true, NULL),\n  ('Proof of NC residency', 'Utility bill, lease, or official mail', true, NULL),\n  ('Proof of income', 'Pay stubs, employer letter, or benefit letters', true, NULL),\n  ('Proof of pregnancy', 'Confirmation letter from OB or midwife', false, 'pregnant')\n) AS d(doc_name, description, required, conditional_on)\nWHERE p.program_name = 'NC Medicaid' AND p.state = 'NC';\n"}	insert_nc_income_thresholds_and_documents	jpender95@gmail.com	\N	\N
20260522153934	{"\n-- ============================================================\n-- Migration 20260514120000: profiles app columns + results\n-- Adds all columns saveProfile() uses, intake_snapshot,\n-- backfill from legacy names, results enhancements\n-- ============================================================\n\n-- ── profiles: eligibility engine fields ──────────────────────\nALTER TABLE public.profiles\n  ADD COLUMN IF NOT EXISTS county                      TEXT,\n  ADD COLUMN IF NOT EXISTS postpartum_months_since_birth INTEGER,\n  ADD COLUMN IF NOT EXISTS breastfeeding               BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS children_under_5_count      INTEGER NOT NULL DEFAULT 0,\n  ADD COLUMN IF NOT EXISTS has_medicaid                BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS has_snap                    BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS has_tanf_work_first         BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS has_ssi                     BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS has_non_custodial_parent    BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS us_citizen                  BOOLEAN NOT NULL DEFAULT TRUE,\n  ADD COLUMN IF NOT EXISTS qualified_immigrant         BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS work_activity_hrs_per_month INTEGER NOT NULL DEFAULT 0,\n  ADD COLUMN IF NOT EXISTS in_qualifying_activity      BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS previously_denied_medicaid  BOOLEAN NOT NULL DEFAULT FALSE;\n\n-- ── profiles: intake & UX fields ─────────────────────────────\nALTER TABLE public.profiles\n  ADD COLUMN IF NOT EXISTS intake_snapshot   JSONB,\n  ADD COLUMN IF NOT EXISTS preferred_contact TEXT NOT NULL DEFAULT 'email',\n  ADD COLUMN IF NOT EXISTS consent_data_use  BOOLEAN NOT NULL DEFAULT FALSE,\n  ADD COLUMN IF NOT EXISTS intake_completed_at TIMESTAMPTZ;\n\n-- ── backfill county from city where we can ───────────────────\n-- Charlotte → Mecklenburg, Greensboro → Guilford, Durham → Durham\nUPDATE public.profiles SET county = CASE\n  WHEN city ILIKE 'charlotte'                 THEN 'Mecklenburg'\n  WHEN city ILIKE 'greensboro'                THEN 'Guilford'\n  WHEN city ILIKE 'durham'                    THEN 'Durham'\n  WHEN city ILIKE 'raleigh'                   THEN 'Wake'\n  WHEN city ILIKE '%chapel hill%'\n    OR city ILIKE 'carrboro'                  THEN 'Orange'\n  WHEN city ILIKE 'atlanta'\n    OR city ILIKE 'decatur'\n    OR city ILIKE 'east point'\n    OR city ILIKE 'college park'              THEN 'Fulton'\n  WHEN city ILIKE 'marietta'\n    OR city ILIKE '%kennesaw%'\n    OR city ILIKE 'smyrna'                    THEN 'Cobb'\n  WHEN city ILIKE 'lawrenceville'\n    OR city ILIKE 'duluth'\n    OR city ILIKE '%suwanee%'                 THEN 'Gwinnett'\n  WHEN city ILIKE 'tucker'\n    OR city ILIKE '%stone mountain%'          THEN 'DeKalb'\n  ELSE county\nEND\nWHERE county IS NULL AND city IS NOT NULL;\n\n-- ── backfill children_under_5_count from children_dobs ───────\nUPDATE public.profiles\nSET children_under_5_count = (\n  SELECT COUNT(*)\n  FROM UNNEST(children_dobs) AS dob\n  WHERE dob > CURRENT_DATE - INTERVAL '5 years'\n)\nWHERE children_dobs IS NOT NULL AND array_length(children_dobs, 1) > 0;\n\n-- ── results: add reasons[] and program_code ───────────────────\nALTER TABLE public.results\n  ADD COLUMN IF NOT EXISTS reasons      TEXT[],\n  ADD COLUMN IF NOT EXISTS program_code TEXT;\n\nCREATE INDEX IF NOT EXISTS idx_results_program_code ON public.results(program_code);\nCREATE INDEX IF NOT EXISTS idx_profiles_county      ON public.profiles(county);\nCREATE INDEX IF NOT EXISTS idx_profiles_state_county ON public.profiles(state, county);\n"}	20260514120000_profiles_app_columns	jpender95@gmail.com	\N	\N
20260522153956	{"\n-- ============================================================\n-- Migration 20260514121000: programs guide_url, renewal_period_months,\n-- program_code for PDF template matching\n-- ============================================================\n\nALTER TABLE public.programs\n  ADD COLUMN IF NOT EXISTS guide_url             TEXT,\n  ADD COLUMN IF NOT EXISTS renewal_period_months INTEGER,\n  ADD COLUMN IF NOT EXISTS program_code          TEXT,\n  ADD COLUMN IF NOT EXISTS notes                 TEXT;\n\n-- ── Populate renewal_period_months from text field ───────────\nUPDATE public.programs SET renewal_period_months =\n  CASE\n    WHEN renewal_period ILIKE '%6 month%'                THEN 6\n    WHEN renewal_period ILIKE '%annual%'\n      OR renewal_period ILIKE '%12 month%'\n      OR renewal_period ILIKE '%yearly%'                 THEN 12\n    WHEN renewal_period ILIKE '%3 month%'                THEN 3\n    ELSE NULL\n  END\nWHERE renewal_period_months IS NULL;\n\n-- ── Assign program_code (short key for PDF templates) ────────\nUPDATE public.programs SET program_code = CASE\n  WHEN program_name ILIKE '%food and nutrition%'\n    OR program_name ILIKE '%supplemental nutrition%'\n    OR also_known_as ILIKE '%snap%'\n    OR also_known_as ILIKE '%fns%'                        THEN 'snap'\n  WHEN program_name ILIKE '%women infants%'\n    OR also_known_as ILIKE '%wic%'                        THEN 'wic'\n  WHEN program_name ILIKE '%work first%'\n    OR program_name ILIKE '%temporary assistance%'\n    OR also_known_as ILIKE '%tanf%'\n    OR also_known_as ILIKE '%work first%'                 THEN 'tanf_work_first'\n  WHEN program_name ILIKE '%medicaid%'                    THEN 'medicaid'\n  WHEN program_name ILIKE '%childcare%'\n    OR program_name ILIKE '%child care%'\n    OR also_known_as ILIKE '%caps%'\n    OR also_known_as ILIKE '%dcdee%'                      THEN 'childcare_subsidy'\n  WHEN program_name ILIKE '%housing choice%'\n    OR also_known_as ILIKE '%section 8%'                  THEN 'section8'\n  WHEN program_name ILIKE '%energy assistance%'\n    OR also_known_as ILIKE '%liheap%'                     THEN 'liheap'\n  WHEN program_name ILIKE '%child support%'               THEN 'child_support'\n  ELSE LOWER(REGEXP_REPLACE(program_name, '[^a-z0-9]+', '_', 'gi'))\nEND\nWHERE program_code IS NULL;\n\n-- ── Guide URLs pointing to in-app guide pages ─────────────────\nUPDATE public.programs SET guide_url = CASE\n  WHEN program_code = 'snap'              THEN '/guides/snap'\n  WHEN program_code = 'wic'              THEN '/guides/wic'\n  WHEN program_code = 'tanf_work_first'  THEN '/guides/cash-assistance'\n  WHEN program_code = 'medicaid'         THEN '/guides/medicaid'\n  WHEN program_code = 'childcare_subsidy' THEN '/guides/childcare'\n  WHEN program_code = 'section8'         THEN '/guides/section-8'\n  WHEN program_code = 'liheap'           THEN '/guides/liheap'\n  WHEN program_code = 'child_support'    THEN '/guides/child-support'\n  ELSE NULL\nEND\nWHERE guide_url IS NULL;\n\n-- ── State-specific notes from eligibility_summary ────────────\nUPDATE public.programs\nSET notes = eligibility_summary\nWHERE notes IS NULL AND eligibility_summary IS NOT NULL;\n\nCREATE INDEX IF NOT EXISTS idx_programs_program_code ON public.programs(program_code);\nCREATE INDEX IF NOT EXISTS idx_programs_state_type   ON public.programs(state, program_type);\n"}	20260514121000_programs_guide_and_extra	jpender95@gmail.com	\N	\N
20260522154112	{"\n-- ============================================================\n-- Migration 20260514122000: get_eligible_programs_enriched RPC\n-- Replaces the old GA-only get_eligible_programs.\n-- Returns apply_url, eligibility, notes, program_type, program_code.\n-- Housing programs returned without threshold (always show as waitlist).\n-- State-branched: GA Pathways vs NC expansion Medicaid.\n-- ============================================================\n\nDROP FUNCTION IF EXISTS public.get_eligible_programs(uuid);\n\nCREATE OR REPLACE FUNCTION public.get_eligible_programs_enriched(p_user_id UUID)\nRETURNS TABLE(\n  program_id      UUID,\n  program_name    TEXT,\n  program_type    TEXT,\n  program_code    TEXT,\n  eligibility     TEXT,\n  reasons         TEXT[],\n  estimated_benefit NUMERIC,\n  apply_url       TEXT,\n  guide_url       TEXT,\n  notes           TEXT,\n  renewal_period_months INTEGER\n)\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  v_state       TEXT;\n  v_income      NUMERIC;\n  v_hh_size     INTEGER;\n  v_pregnant    BOOLEAN;\n  v_children    INTEGER;\n  v_children_u5 INTEGER;\n  v_childcare   BOOLEAN;\n  v_breastfeed  BOOLEAN;\n  v_county      TEXT;\n  v_age         INTEGER;\n  v_citizen     BOOLEAN;\n  v_immigrant   BOOLEAN;\n  v_dv          BOOLEAN;\n  v_employment  TEXT;\n  v_work_hrs    INTEGER;\n  v_has_medicaid BOOLEAN;\n  v_has_snap    BOOLEAN;\n  v_has_tanf    BOOLEAN;\n  v_has_ssi     BOOLEAN;\n  v_denied_medicaid BOOLEAN;\n  -- 2025 FPL monthly base amounts\n  v_fpl_1  CONSTANT NUMERIC := 1215;\n  v_fpl_2  CONSTANT NUMERIC := 1644;\n  v_fpl_3  CONSTANT NUMERIC := 2072;\n  v_fpl_4  CONSTANT NUMERIC := 2500;\n  v_fpl_5  CONSTANT NUMERIC := 2929;\n  v_fpl_base NUMERIC;\nBEGIN\n  SELECT\n    p.state, p.gross_monthly_income, p.household_size, p.pregnant,\n    p.num_children_under18, COALESCE(p.children_under_5_count, 0),\n    p.needs_childcare, p.breastfeeding, p.county,\n    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth))::INTEGER,\n    COALESCE(p.us_citizen, TRUE), COALESCE(p.qualified_immigrant, FALSE),\n    p.domestic_violence, p.employment_status,\n    COALESCE(p.work_activity_hrs_per_month, 0),\n    COALESCE(p.has_medicaid, FALSE), COALESCE(p.has_snap, FALSE),\n    COALESCE(p.has_tanf_work_first, FALSE), COALESCE(p.has_ssi, FALSE),\n    COALESCE(p.previously_denied_medicaid, FALSE)\n  INTO\n    v_state, v_income, v_hh_size, v_pregnant,\n    v_children, v_children_u5,\n    v_childcare, v_breastfeed, v_county,\n    v_age, v_citizen, v_immigrant,\n    v_dv, v_employment, v_work_hrs,\n    v_has_medicaid, v_has_snap, v_has_tanf, v_has_ssi,\n    v_denied_medicaid\n  FROM public.profiles p WHERE p.user_id = p_user_id;\n\n  -- Compute FPL base for this household\n  v_fpl_base := CASE COALESCE(v_hh_size, 1)\n    WHEN 1 THEN v_fpl_1 WHEN 2 THEN v_fpl_2 WHEN 3 THEN v_fpl_3\n    WHEN 4 THEN v_fpl_4 WHEN 5 THEN v_fpl_5\n    ELSE v_fpl_5 + ((COALESCE(v_hh_size, 1) - 5) * 429)\n  END;\n\n  -- ── SNAP / FNS (federal, same thresholds both states) ──────\n  RETURN QUERY\n  SELECT\n    prog.id, prog.program_name, prog.program_type, prog.program_code,\n    CASE\n      WHEN (v_has_medicaid OR v_has_tanf OR v_has_ssi)\n        THEN 'likely_eligible'\n      WHEN v_income <= it.income_limit THEN 'likely_eligible'\n      WHEN v_income <= it.income_limit * 1.1 THEN 'possibly_eligible'\n      ELSE 'ineligible'\n    END,\n    CASE\n      WHEN (v_has_medicaid OR v_has_tanf OR v_has_ssi)\n        THEN ARRAY['Automatically eligible — receiving Medicaid, Work First/TANF, or SSI']\n      WHEN v_income <= it.income_limit\n        THEN ARRAY[FORMAT('Income $%s/mo is under the limit for household of %s', v_income::INT, COALESCE(v_hh_size, 1))]\n      WHEN v_income <= it.income_limit * 1.1\n        THEN ARRAY['Income is within 10% of the limit — worth applying']\n      ELSE ARRAY['Income exceeds limit']\n    END,\n    it.benefit_amount,\n    prog.apply_url, prog.guide_url,\n    prog.notes,\n    prog.renewal_period_months\n  FROM public.programs prog\n  JOIN public.income_thresholds it\n    ON it.program_id = prog.id\n   AND it.household_size = COALESCE(v_hh_size, 1)\n  WHERE prog.program_code = 'snap'\n    AND prog.state = v_state\n    AND it.income_limit IS NOT NULL;\n\n  -- ── WIC (federal, both states) ─────────────────────────────\n  IF v_pregnant OR v_breastfeed OR v_children_u5 > 0 THEN\n    RETURN QUERY\n    SELECT\n      prog.id, prog.program_name, prog.program_type, prog.program_code,\n      CASE\n        WHEN (v_has_medicaid OR v_has_snap OR v_has_tanf) THEN 'likely_eligible'\n        WHEN v_income <= v_fpl_base * 1.85 THEN 'likely_eligible'\n        WHEN v_income <= v_fpl_base * 2.03 THEN 'possibly_eligible'\n        ELSE 'ineligible'\n      END,\n      CASE\n        WHEN (v_has_medicaid OR v_has_snap OR v_has_tanf)\n          THEN ARRAY['Auto-eligible — already on Medicaid, SNAP, or Work First/TANF']\n        WHEN v_income <= v_fpl_base * 1.85\n          THEN ARRAY['Income qualifies at 185% FPL']\n        ELSE ARRAY['Income may exceed WIC limit']\n      END,\n      NULL::NUMERIC,\n      prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n    FROM public.programs prog\n    WHERE prog.program_code = 'wic' AND prog.state = v_state;\n  END IF;\n\n  -- ── TANF / Work First (state-branched) ─────────────────────\n  IF COALESCE(v_children, 0) > 0 AND (v_citizen OR v_immigrant) THEN\n    RETURN QUERY\n    SELECT\n      prog.id, prog.program_name, prog.program_type, prog.program_code,\n      CASE\n        WHEN v_income <= it.income_limit THEN 'likely_eligible'\n        WHEN v_income <= it.income_limit * 1.1 THEN 'possibly_eligible'\n        ELSE 'ineligible'\n      END,\n      CASE\n        WHEN v_state = 'NC'\n          THEN ARRAY['Qualifies for Work First cash. NC state limit: 24 months. ' ||\n                     CASE WHEN v_dv THEN 'DV good cause exemption available from work requirements.'\n                          ELSE 'Must do 30 hrs/week work activities.' END]\n        ELSE ARRAY['Qualifies for TANF cash. GA lifetime limit: 48 months. Must do 30 hrs/week work activities.']\n      END,\n      it.benefit_amount,\n      prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n    FROM public.programs prog\n    JOIN public.income_thresholds it\n      ON it.program_id = prog.id AND it.household_size = COALESCE(v_hh_size, 1)\n    WHERE prog.program_code = 'tanf_work_first'\n      AND prog.state = v_state\n      AND it.income_limit IS NOT NULL;\n  END IF;\n\n  -- ── Childcare assistance (state-branched) ──────────────────\n  IF v_childcare AND v_employment IN ('employed', 'in_school', 'in_training') THEN\n    RETURN QUERY\n    SELECT\n      prog.id, prog.program_name, prog.program_type, prog.program_code,\n      CASE\n        WHEN v_income <= it.income_limit THEN 'likely_eligible'\n        WHEN v_income <= it.income_limit * 1.15 THEN 'possibly_eligible'\n        ELSE 'ineligible'\n      END,\n      CASE\n        WHEN v_state = 'NC'\n          THEN ARRAY['Apply IN PERSON at county DSS — cannot use ePASS for this program', 'Many counties have waitlists — apply immediately']\n        ELSE ARRAY['Apply at gateway.ga.gov', 'Child must enroll at a Quality Rated provider']\n      END,\n      NULL::NUMERIC,\n      prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n    FROM public.programs prog\n    JOIN public.income_thresholds it\n      ON it.program_id = prog.id AND it.household_size = COALESCE(v_hh_size, 1)\n    WHERE prog.program_code = 'childcare_subsidy'\n      AND prog.state = v_state\n      AND it.income_limit IS NOT NULL;\n  END IF;\n\n  -- ── LIHEAP (income-gated) ───────────────────────────────────\n  IF v_income IS NOT NULL AND v_income <= v_fpl_base * 1.30 THEN\n    RETURN QUERY\n    SELECT\n      prog.id, prog.program_name, prog.program_type, prog.program_code,\n      'likely_eligible'::TEXT,\n      CASE\n        WHEN v_state = 'NC'\n          THEN ARRAY[FORMAT('Apply at your county DSS (%s County)', COALESCE(v_county, 'your'))]\n        WHEN v_county IN ('DeKalb','Gwinnett','Rockdale','Newton','Walton')\n          THEN ARRAY[v_county || ' routes LIHEAP through Partnership for Community Action — call (404) 363-0575, NOT DFCS']\n        ELSE ARRAY['Apply at your local DFCS office — heating opens December 1 annually']\n      END,\n      NULL::NUMERIC,\n      prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n    FROM public.programs prog\n    WHERE prog.program_code = 'liheap' AND prog.state = v_state;\n  END IF;\n\n  -- ── Medicaid — fully state-branched ────────────────────────\n  -- NC path\n  IF v_state = 'NC' THEN\n    IF v_pregnant AND v_income <= v_fpl_base * 1.96 THEN\n      RETURN QUERY SELECT prog.id, prog.program_name, prog.program_type, prog.program_code,\n        'likely_eligible'::TEXT,\n        ARRAY['Pregnant — NC Medicaid covers up to 196% FPL, no work requirement'],\n        NULL::NUMERIC, prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n      FROM public.programs prog WHERE prog.program_code = 'medicaid' AND prog.state = 'NC' LIMIT 1;\n    ELSIF COALESCE(v_children, 0) > 0 AND v_income <= v_fpl_base * 2.11 THEN\n      RETURN QUERY SELECT prog.id, prog.program_name, prog.program_type, prog.program_code,\n        'likely_eligible'::TEXT,\n        ARRAY['Children qualify at NC Health Choice up to 211% FPL'],\n        NULL::NUMERIC, prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n      FROM public.programs prog WHERE prog.program_code = 'medicaid' AND prog.state = 'NC' LIMIT 1;\n    ELSIF COALESCE(v_age, 30) BETWEEN 19 AND 64 AND v_income <= v_fpl_base * 1.38 THEN\n      RETURN QUERY SELECT prog.id, prog.program_name, prog.program_type, prog.program_code,\n        'likely_eligible'::TEXT,\n        ARRAY['NC expanded Medicaid Dec 2023 — adults 19–64 at 138% FPL, NO work requirement', FORMAT('Limit: $%s/mo for household of %s', (v_fpl_base * 1.38)::INT, COALESCE(v_hh_size,1))],\n        NULL::NUMERIC, prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n      FROM public.programs prog WHERE prog.program_code = 'medicaid' AND prog.state = 'NC' LIMIT 1;\n    ELSIF v_denied_medicaid AND COALESCE(v_age, 30) BETWEEN 19 AND 64 THEN\n      -- Show as possibly eligible to prompt re-apply\n      RETURN QUERY SELECT prog.id, prog.program_name, prog.program_type, prog.program_code,\n        'possibly_eligible'::TEXT,\n        ARRAY['NC expanded Medicaid Dec 2023 — if you were previously denied, apply again at epass.nc.gov'],\n        NULL::NUMERIC, prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n      FROM public.programs prog WHERE prog.program_code = 'medicaid' AND prog.state = 'NC' LIMIT 1;\n    END IF;\n  END IF;\n\n  -- GA Medicaid path\n  IF v_state = 'GA' THEN\n    IF v_pregnant AND v_income <= v_fpl_base * 2.20 THEN\n      RETURN QUERY SELECT prog.id, prog.program_name, prog.program_type, prog.program_code,\n        'likely_eligible'::TEXT,\n        ARRAY['Pregnant — Right From the Start Medicaid (GA) up to 220% FPL'],\n        NULL::NUMERIC, prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n      FROM public.programs prog WHERE prog.program_code = 'medicaid' AND prog.state = 'GA' LIMIT 1;\n    ELSIF COALESCE(v_children, 0) > 0 AND v_income <= v_fpl_base * 2.47 THEN\n      RETURN QUERY SELECT prog.id, prog.program_name, prog.program_type, prog.program_code,\n        'likely_eligible'::TEXT,\n        ARRAY['Children qualify for PeachCare for Kids (GA) up to 247% FPL'],\n        NULL::NUMERIC, prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n      FROM public.programs prog WHERE prog.program_code = 'medicaid' AND prog.state = 'GA' LIMIT 1;\n    ELSIF COALESCE(v_age, 30) BETWEEN 19 AND 64 AND v_income <= v_fpl_base * 1.00 THEN\n      RETURN QUERY SELECT prog.id, prog.program_name, prog.program_type, prog.program_code,\n        CASE WHEN v_work_hrs >= 80 OR v_employment IN ('employed','in_school','in_training')\n             THEN 'likely_eligible' ELSE 'possibly_eligible' END,\n        ARRAY['Georgia Pathways: income ≤100% FPL',\n              CASE WHEN v_work_hrs >= 80 OR v_employment IN ('employed','in_school','in_training')\n                   THEN 'Qualifying activity detected — likely eligible'\n                   ELSE 'Requires 80 hrs/month work, training, or education — confirm activity status' END],\n        NULL::NUMERIC, prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n      FROM public.programs prog WHERE prog.program_code = 'medicaid' AND prog.state = 'GA' LIMIT 1;\n    END IF;\n  END IF;\n\n  -- ── Section 8 (housing — always show, no income threshold gate) ──\n  RETURN QUERY\n  SELECT\n    prog.id, prog.program_name, prog.program_type, prog.program_code,\n    CASE WHEN v_income <= v_fpl_base * 2.0 THEN 'waitlist' ELSE 'ineligible' END,\n    CASE\n      WHEN v_state = 'NC'\n        THEN ARRAY['Income qualifies — check Inlivian (Charlotte), GHA (Greensboro), DHA (Durham) for open waitlists', 'Apply the same day a waitlist opens — they fill within hours']\n      ELSE ARRAY['Income qualifies — AHA waitlist currently closed', 'Check atlantahousing.org for project-based openings and DeKalb, Gwinnett, Cobb HAs']\n    END,\n    NULL::NUMERIC,\n    prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n  FROM public.programs prog\n  WHERE prog.program_code = 'section8' AND prog.state = v_state;\n\n  -- ── Child Support (always recommend if profile set) ─────────\n  RETURN QUERY\n  SELECT\n    prog.id, prog.program_name, prog.program_type, prog.program_code,\n    'likely_eligible'::TEXT,\n    CASE\n      WHEN v_dv THEN ARRAY['DV good cause exemption available — you do NOT have to cooperate if it puts you at risk']\n      WHEN v_has_medicaid OR v_has_tanf THEN ARRAY['Free — already on Medicaid or Work First/TANF']\n      ELSE ARRAY['$25 application fee if not on Medicaid or Work First']\n    END,\n    NULL::NUMERIC,\n    prog.apply_url, prog.guide_url, prog.notes, prog.renewal_period_months\n  FROM public.programs prog\n  WHERE prog.program_code = 'child_support' AND prog.state = v_state;\n\nEND;\n$$;\n\n-- Keep old function name as alias for any existing callers\nCREATE OR REPLACE FUNCTION public.get_eligible_programs(p_user_id UUID)\nRETURNS TABLE(\n  program_id UUID, program_name TEXT, program_type TEXT,\n  eligibility TEXT, estimated_benefit NUMERIC,\n  apply_url TEXT, eligibility_note TEXT\n)\nLANGUAGE SQL SECURITY DEFINER SET search_path = public AS $$\n  SELECT program_id, program_name, program_type,\n    eligibility, estimated_benefit, apply_url,\n    ARRAY_TO_STRING(reasons, '; ') AS eligibility_note\n  FROM public.get_eligible_programs_enriched(p_user_id);\n$$;\n\nGRANT EXECUTE ON FUNCTION public.get_eligible_programs_enriched(UUID) TO authenticated;\nGRANT EXECUTE ON FUNCTION public.get_eligible_programs(UUID) TO authenticated;\n"}	20260514122000_get_eligible_programs_enriched	jpender95@gmail.com	\N	\N
20260522154146	{"\n-- ============================================================\n-- Migration 20260514123000: organizations extra columns + RPCs\n-- Adds service_tags, referral_notes to organizations.\n-- Rebuilds get_my_dv_flag() to also accept explicit user_id.\n-- Adds set_my_sensitive_profile_fields() for immigration data.\n-- Adds get_orgs_for_user() RPC for flag-matched org results.\n-- ============================================================\n\n-- ── organizations: extra columns ─────────────────────────────\nALTER TABLE public.organizations\n  ADD COLUMN IF NOT EXISTS service_tags    TEXT[],\n  ADD COLUMN IF NOT EXISTS referral_notes  TEXT;\n\n-- Backfill service_tags from existing flag columns\nUPDATE public.organizations SET service_tags = (\n  ARRAY[]::TEXT[]\n  || CASE WHEN flag_dv THEN ARRAY['domestic_violence'] ELSE ARRAY[]::TEXT[] END\n  || CASE WHEN flag_eviction THEN ARRAY['eviction'] ELSE ARRAY[]::TEXT[] END\n  || CASE WHEN flag_children_u5 THEN ARRAY['children_u5'] ELSE ARRAY[]::TEXT[] END\n  || CASE WHEN flag_pregnant THEN ARRAY['pregnant'] ELSE ARRAY[]::TEXT[] END\n  || CASE WHEN flag_student THEN ARRAY['student'] ELSE ARRAY[]::TEXT[] END\n  || CASE WHEN flag_immigrant THEN ARRAY['immigrant'] ELSE ARRAY[]::TEXT[] END\n  || CASE WHEN flag_no_childcare THEN ARRAY['no_childcare'] ELSE ARRAY[]::TEXT[] END\n)\nWHERE service_tags IS NULL;\n\nCREATE INDEX IF NOT EXISTS idx_orgs_service_tags ON public.organizations USING GIN(service_tags);\nCREATE INDEX IF NOT EXISTS idx_orgs_state_active  ON public.organizations(state, active);\n\n-- ── Rebuild get_my_dv_flag (already exists, drop + recreate) ─\nDROP FUNCTION IF EXISTS public.get_my_dv_flag();\n\nCREATE OR REPLACE FUNCTION public.get_my_dv_flag()\nRETURNS BOOLEAN\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  RETURN COALESCE(\n    (SELECT domestic_violence FROM public.profiles WHERE user_id = auth.uid()),\n    FALSE\n  );\nEND;\n$$;\nGRANT EXECUTE ON FUNCTION public.get_my_dv_flag() TO authenticated;\n\n-- ── set_my_sensitive_profile_fields ──────────────────────────\n-- Separated from main saveProfile to keep immigration data\n-- behind its own security boundary and RLS policy.\nCREATE OR REPLACE FUNCTION public.set_my_sensitive_profile_fields(\n  p_immigration_status TEXT DEFAULT NULL,\n  p_legal_issues       TEXT[] DEFAULT NULL,\n  p_domestic_violence  BOOLEAN DEFAULT NULL\n)\nRETURNS VOID\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  UPDATE public.profiles SET\n    immigration_status = COALESCE(p_immigration_status, immigration_status),\n    legal_issues       = COALESCE(p_legal_issues, legal_issues),\n    domestic_violence  = COALESCE(p_domestic_violence, domestic_violence),\n    updated_at         = NOW()\n  WHERE user_id = auth.uid();\nEND;\n$$;\nGRANT EXECUTE ON FUNCTION public.set_my_sensitive_profile_fields(TEXT, TEXT[], BOOLEAN) TO authenticated;\n\n-- ── get_orgs_for_user ─────────────────────────────────────────\n-- Returns active orgs matching the user's state + their flag profile.\n-- DV safety mode: if user has DV flag, returns dv_safety_mode orgs first.\nCREATE OR REPLACE FUNCTION public.get_orgs_for_user(p_user_id UUID)\nRETURNS TABLE(\n  org_id          UUID,\n  org_name        TEXT,\n  category        TEXT,\n  purpose         TEXT,\n  phone           TEXT,\n  crisis_line     TEXT,\n  website         TEXT,\n  address         TEXT,\n  city            TEXT,\n  state           TEXT,\n  counties_served TEXT[],\n  intake_process  TEXT,\n  hours_of_operation TEXT,\n  dv_safety_mode  BOOLEAN,\n  service_tags    TEXT[],\n  relevance_score INTEGER\n)\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  v_state     TEXT;\n  v_county    TEXT;\n  v_dv        BOOLEAN;\n  v_pregnant  BOOLEAN;\n  v_eviction  BOOLEAN;\n  v_childcare BOOLEAN;\n  v_student   BOOLEAN;\n  v_immigrant BOOLEAN;\n  v_children_u5 INTEGER;\nBEGIN\n  SELECT\n    p.state, p.county, p.domestic_violence, p.pregnant,\n    p.eviction_notice, p.needs_childcare,\n    CASE WHEN p.employment_status IN ('in_school','in_training') THEN TRUE ELSE FALSE END,\n    p.immigration_status IS NOT NULL AND p.immigration_status NOT IN ('us_citizen','permanent_resident'),\n    COALESCE(p.children_under_5_count, 0)\n  INTO v_state, v_county, v_dv, v_pregnant, v_eviction,\n       v_childcare, v_student, v_immigrant, v_children_u5\n  FROM public.profiles p WHERE p.user_id = p_user_id;\n\n  RETURN QUERY\n  SELECT\n    o.id, o.org_name, o.category, o.purpose, o.phone, o.crisis_line,\n    o.website, o.address, o.city, o.state, o.counties_served,\n    o.intake_process, o.hours_of_operation, o.dv_safety_mode, o.service_tags,\n    -- Relevance scoring\n    (0\n      + CASE WHEN v_dv      AND o.flag_dv           THEN 10 ELSE 0 END\n      + CASE WHEN v_pregnant AND o.flag_pregnant     THEN 8  ELSE 0 END\n      + CASE WHEN v_eviction AND o.flag_eviction     THEN 9  ELSE 0 END\n      + CASE WHEN v_childcare AND o.flag_no_childcare THEN 7 ELSE 0 END\n      + CASE WHEN v_children_u5 > 0 AND o.flag_children_u5 THEN 6 ELSE 0 END\n      + CASE WHEN v_student  AND o.flag_student      THEN 5  ELSE 0 END\n      + CASE WHEN v_immigrant AND o.flag_immigrant   THEN 7  ELSE 0 END\n      -- County bonus: county match > statewide > other county\n      + CASE\n          WHEN v_county IS NOT NULL AND o.counties_served @> ARRAY[v_county] THEN 4\n          WHEN o.counties_served @> ARRAY['Statewide NC'] OR o.counties_served @> ARRAY['Statewide (Georgia)']\n            OR o.counties_served @> ARRAY['statewide'] THEN 2\n          ELSE 0\n        END\n    )::INTEGER AS relevance_score\n  FROM public.organizations o\n  WHERE o.state = v_state\n    AND o.active = TRUE\n    -- DV safety: if user has DV flag, only show safety-mode orgs first (others also returned)\n    -- We surface them by score; if DV, dv orgs get +10\n  ORDER BY\n    -- DV users: dv_safety_mode orgs come first\n    CASE WHEN v_dv AND o.dv_safety_mode THEN 0 ELSE 1 END,\n    relevance_score DESC,\n    o.org_name;\nEND;\n$$;\nGRANT EXECUTE ON FUNCTION public.get_orgs_for_user(UUID) TO authenticated;\n"}	20260514123000_organizations_and_dv_rpc	jpender95@gmail.com	\N	\N
20260522154207	{"\n-- ============================================================\n-- Migration 20260514124000: Storage buckets + pdf_generations table\n-- Creates pdf-templates (public) and user-documents (private).\n-- ============================================================\n\n-- ── Storage buckets ──────────────────────────────────────────\nINSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)\nVALUES\n  ('pdf-templates', 'pdf-templates', TRUE,  10485760,  -- 10 MB\n   ARRAY['application/pdf']),\n  ('user-documents', 'user-documents', FALSE, 52428800, -- 50 MB\n   ARRAY['application/pdf','image/jpeg','image/png','image/webp',\n         'application/msword',\n         'application/vnd.openxmlformats-officedocument.wordprocessingml.document'])\nON CONFLICT (id) DO NOTHING;\n\n-- ── RLS policies: pdf-templates (public read, admin write) ───\nCREATE POLICY \\"pdf_templates_public_read\\"\n  ON storage.objects FOR SELECT\n  USING (bucket_id = 'pdf-templates');\n\nCREATE POLICY \\"pdf_templates_service_write\\"\n  ON storage.objects FOR INSERT\n  WITH CHECK (bucket_id = 'pdf-templates');\n\nCREATE POLICY \\"pdf_templates_service_update\\"\n  ON storage.objects FOR UPDATE\n  USING (bucket_id = 'pdf-templates');\n\n-- ── RLS policies: user-documents (private per user) ──────────\nCREATE POLICY \\"user_documents_owner_select\\"\n  ON storage.objects FOR SELECT\n  USING (\n    bucket_id = 'user-documents'\n    AND (storage.foldername(name))[1] = auth.uid()::TEXT\n  );\n\nCREATE POLICY \\"user_documents_owner_insert\\"\n  ON storage.objects FOR INSERT\n  WITH CHECK (\n    bucket_id = 'user-documents'\n    AND (storage.foldername(name))[1] = auth.uid()::TEXT\n  );\n\nCREATE POLICY \\"user_documents_owner_delete\\"\n  ON storage.objects FOR DELETE\n  USING (\n    bucket_id = 'user-documents'\n    AND (storage.foldername(name))[1] = auth.uid()::TEXT\n  );\n\n-- ── pdf_generations audit table ───────────────────────────────\nCREATE TABLE IF NOT EXISTS public.pdf_generations (\n  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id        UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,\n  program_code   TEXT NOT NULL,\n  program_name   TEXT,\n  state          TEXT NOT NULL,\n  language       TEXT NOT NULL DEFAULT 'en',\n  template_used  TEXT,           -- 'acroform' | 'worksheet_fallback'\n  storage_path   TEXT,           -- path in user-documents bucket if saved\n  generated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()\n);\n\nALTER TABLE public.pdf_generations ENABLE ROW LEVEL SECURITY;\n\nCREATE POLICY \\"pdf_gen_owner\\"\n  ON public.pdf_generations FOR ALL\n  USING (user_id = auth.uid())\n  WITH CHECK (user_id = auth.uid());\n\nCREATE INDEX IF NOT EXISTS idx_pdf_gen_user ON public.pdf_generations(user_id, generated_at DESC);\n\nGRANT SELECT, INSERT ON public.pdf_generations TO authenticated;\n"}	20260514124000_pdf_templates_storage	jpender95@gmail.com	\N	\N
20260522165051	{"\n-- Account deletion requests audit trail\nCREATE TABLE IF NOT EXISTS public.account_deletion_requests (\n  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id       UUID NOT NULL,\n  requested_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  completed_at  TIMESTAMPTZ,\n  status        TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','completed','failed')),\n  error_message TEXT\n);\n\nCREATE INDEX IF NOT EXISTS idx_deletion_requests_user\n  ON public.account_deletion_requests(user_id);\n\n-- Documents vault tracking table\nCREATE TABLE IF NOT EXISTS public.documents (\n  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id      UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,\n  file_name    TEXT NOT NULL,\n  storage_path TEXT NOT NULL,\n  file_size    INTEGER,\n  mime_type    TEXT,\n  uploaded_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()\n);\n\nALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;\n\nDO $$\nBEGIN\n  IF NOT EXISTS (\n    SELECT 1 FROM pg_policies\n    WHERE tablename = 'documents' AND policyname = 'docs_owner'\n  ) THEN\n    CREATE POLICY docs_owner ON public.documents\n      FOR ALL USING (user_id = auth.uid())\n      WITH CHECK (user_id = auth.uid());\n  END IF;\nEND $$;\n\nCREATE INDEX IF NOT EXISTS idx_documents_user ON public.documents(user_id);\n\nGRANT SELECT, INSERT, DELETE ON public.documents TO authenticated;\n"}	20260522_account_deletion_tracking	jpender95@gmail.com	\N	\N
20260608141149	{"\n-- HFA Business Operations Schema\n-- All HFA tables live in the 'hfa' schema, isolated from the WiserMoms 'public' schema\n\nCREATE SCHEMA IF NOT EXISTS hfa;\n\n-- ─────────────────────────────────────────────\n-- LEADS: everyone who downloads the lead magnet\n-- ─────────────────────────────────────────────\nCREATE TABLE IF NOT EXISTS hfa.leads (\n  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  email        text NOT NULL UNIQUE,\n  first_name   text NOT NULL DEFAULT '',\n  source       text DEFAULT 'direct',\n  campaign     text DEFAULT 'organic',\n  status       text DEFAULT 'new'\n                CHECK (status IN ('new','in_sequence','call_booked','call_completed','client','not_a_fit')),\n  kit_tag      text DEFAULT 'lead-magnet-download',\n  notes        text,\n  created_at   timestamptz DEFAULT now(),\n  updated_at   timestamptz DEFAULT now()\n);\n\n-- ──────────────────────────────────────────────────\n-- DISCOVERY_CALLS: every Calendly booking, with brief\n-- ──────────────────────────────────────────────────\nCREATE TABLE IF NOT EXISTS hfa.discovery_calls (\n  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  name                text NOT NULL,\n  email               text NOT NULL,\n  call_time           timestamptz,\n  business_type       text,\n  problem             text,\n  current_tools       text,\n  team_size           text,\n  status              text DEFAULT 'scheduled'\n                       CHECK (status IN ('scheduled','completed','no_show','closed_won','closed_lost')),\n  recommended_tier    text\n                       CHECK (recommended_tier IN ('quick_win','system_build','full_ecosystem','retainer','not_a_fit') OR recommended_tier IS NULL),\n  brief_generated     boolean DEFAULT false,\n  proposal_sent       boolean DEFAULT false,\n  proposal_value      numeric(10,2),\n  outcome_notes       text,\n  created_at          timestamptz DEFAULT now(),\n  updated_at          timestamptz DEFAULT now()\n);\n\n-- ──────────────────────────────────────────────────────\n-- TESTIMONIALS: collected after project delivery\n-- ──────────────────────────────────────────────────────\nCREATE TABLE IF NOT EXISTS hfa.testimonials (\n  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  client_name         text NOT NULL,\n  client_email        text,\n  business_type       text,\n  project_type        text,\n  testimonial_text    text NOT NULL,\n  rating              integer CHECK (rating BETWEEN 1 AND 5),\n  approved_for_use    boolean DEFAULT false,\n  hours_saved_weekly  numeric(5,1),\n  revenue_impact      numeric(10,2),\n  submitted_at        timestamptz DEFAULT now()\n);\n\n-- ──────────────────────────────────────────────────────\n-- REVENUE_TRACKER: every closed deal for 60-day tracking\n-- ──────────────────────────────────────────────────────\nCREATE TABLE IF NOT EXISTS hfa.revenue_tracker (\n  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  week_number     integer NOT NULL CHECK (week_number BETWEEN 1 AND 8),\n  client_name     text NOT NULL,\n  client_email    text,\n  service_tier    text NOT NULL\n                   CHECK (service_tier IN ('quick_win','system_build','full_ecosystem','retainer_monthly')),\n  amount          numeric(10,2) NOT NULL,\n  paid_at         date,\n  source          text,\n  notes           text,\n  created_at      timestamptz DEFAULT now()\n);\n\n-- ──────────────────────────────────────────────────────\n-- WEEKLY_METRICS: rolled-up KPIs updated each Sunday\n-- ──────────────────────────────────────────────────────\nCREATE TABLE IF NOT EXISTS hfa.weekly_metrics (\n  id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  week_number             integer NOT NULL CHECK (week_number BETWEEN 1 AND 8),\n  week_start              date NOT NULL,\n  lead_magnet_downloads   integer DEFAULT 0,\n  new_subscribers         integer DEFAULT 0,\n  email_open_rate         numeric(5,2),\n  email_click_rate        numeric(5,2),\n  calls_booked            integer DEFAULT 0,\n  calls_completed         integer DEFAULT 0,\n  proposals_sent          integer DEFAULT 0,\n  revenue_closed          numeric(10,2) DEFAULT 0,\n  top_content_post        text,\n  top_platform            text,\n  notes                   text,\n  created_at              timestamptz DEFAULT now()\n);\n\n-- ──────────────────────────────────────────────────────\n-- INDEXES for common query patterns\n-- ──────────────────────────────────────────────────────\nCREATE INDEX IF NOT EXISTS idx_hfa_leads_email     ON hfa.leads(email);\nCREATE INDEX IF NOT EXISTS idx_hfa_leads_status    ON hfa.leads(status);\nCREATE INDEX IF NOT EXISTS idx_hfa_calls_email     ON hfa.discovery_calls(email);\nCREATE INDEX IF NOT EXISTS idx_hfa_calls_status    ON hfa.discovery_calls(status);\nCREATE INDEX IF NOT EXISTS idx_hfa_revenue_week    ON hfa.revenue_tracker(week_number);\nCREATE INDEX IF NOT EXISTS idx_hfa_metrics_week    ON hfa.weekly_metrics(week_number);\n\n-- ──────────────────────────────────────────────────────\n-- Seed Week 1 metrics baseline\n-- ──────────────────────────────────────────────────────\nINSERT INTO hfa.weekly_metrics (week_number, week_start, notes)\nVALUES (1, '2026-06-09', 'Week 1 baseline — plan launched June 8 2026. Target: first lead magnet downloads, Kit sequences live.')\nON CONFLICT DO NOTHING;\n"}	create_hfa_business_schema	jpender95@gmail.com	\N	\N
20260608141945	{"\n-- Remove ALL HFA business data from the WiserMoms project.\n-- HFA now lives in its own separate Supabase project: cllycowtmoesmnqpspfl\n-- This project (rskhycwjcaxmujhqslyq) is WiserMoms ONLY.\n\nDROP SCHEMA IF EXISTS hfa CASCADE;\n"}	drop_hfa_schema_from_wisermoms	jpender95@gmail.com	\N	\N
\.


--
-- TOC entry 3871 (class 0 OID 16612)
-- Dependencies: 357
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 352
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 26, true);


--
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 380
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- TOC entry 4202 (class 2606 OID 16787)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4171 (class 2606 OID 16535)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4257 (class 2606 OID 17119)
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- TOC entry 4259 (class 2606 OID 17117)
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4225 (class 2606 OID 16893)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4180 (class 2606 OID 16911)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4182 (class 2606 OID 16921)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4169 (class 2606 OID 16528)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4204 (class 2606 OID 16780)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4200 (class 2606 OID 16768)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4192 (class 2606 OID 16961)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4194 (class 2606 OID 16755)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4238 (class 2606 OID 17020)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4240 (class 2606 OID 17018)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4242 (class 2606 OID 17016)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4252 (class 2606 OID 17078)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4235 (class 2606 OID 16980)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4246 (class 2606 OID 17042)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4248 (class 2606 OID 17044)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4229 (class 2606 OID 16946)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4163 (class 2606 OID 16518)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4166 (class 2606 OID 16697)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4214 (class 2606 OID 16827)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4216 (class 2606 OID 16825)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4221 (class 2606 OID 16841)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4174 (class 2606 OID 16541)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4187 (class 2606 OID 16718)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4211 (class 2606 OID 16808)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4206 (class 2606 OID 16799)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4156 (class 2606 OID 16881)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4158 (class 2606 OID 16505)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4267 (class 2606 OID 17156)
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4263 (class 2606 OID 17139)
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4387 (class 2606 OID 27575)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4356 (class 2606 OID 27000)
-- Name: account_deletion_requests account_deletion_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_deletion_requests
    ADD CONSTRAINT account_deletion_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 4358 (class 2606 OID 27009)
-- Name: application_guides application_guides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_guides
    ADD CONSTRAINT application_guides_pkey PRIMARY KEY (id);


--
-- TOC entry 4337 (class 2606 OID 26938)
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- TOC entry 4362 (class 2606 OID 27025)
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- TOC entry 4349 (class 2606 OID 26981)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4399 (class 2606 OID 27761)
-- Name: billing_events billing_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_events
    ADD CONSTRAINT billing_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4347 (class 2606 OID 26973)
-- Name: counselor_sessions counselor_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.counselor_sessions
    ADD CONSTRAINT counselor_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4345 (class 2606 OID 26965)
-- Name: deadlines deadlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deadlines
    ADD CONSTRAINT deadlines_pkey PRIMARY KEY (id);


--
-- TOC entry 4341 (class 2606 OID 26948)
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4364 (class 2606 OID 27034)
-- Name: documents_required documents_required_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents_required
    ADD CONSTRAINT documents_required_pkey PRIMARY KEY (id);


--
-- TOC entry 4351 (class 2606 OID 26991)
-- Name: generated_pdfs generated_pdfs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_pdfs
    ADD CONSTRAINT generated_pdfs_pkey PRIMARY KEY (id);


--
-- TOC entry 4360 (class 2606 OID 27017)
-- Name: guide_steps guide_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_steps
    ADD CONSTRAINT guide_steps_pkey PRIMARY KEY (id);


--
-- TOC entry 4366 (class 2606 OID 27042)
-- Name: income_thresholds income_thresholds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.income_thresholds
    ADD CONSTRAINT income_thresholds_pkey PRIMARY KEY (id);


--
-- TOC entry 4343 (class 2606 OID 26957)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4370 (class 2606 OID 27074)
-- Name: org_services org_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_services
    ADD CONSTRAINT org_services_pkey PRIMARY KEY (id);


--
-- TOC entry 4368 (class 2606 OID 27066)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4394 (class 2606 OID 27740)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 4372 (class 2606 OID 27083)
-- Name: pdf_generations pdf_generations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pdf_generations
    ADD CONSTRAINT pdf_generations_pkey PRIMARY KEY (id);


--
-- TOC entry 4327 (class 2606 OID 26899)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4381 (class 2606 OID 27555)
-- Name: program_quarter_due_dates program_quarter_due_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_quarter_due_dates
    ADD CONSTRAINT program_quarter_due_dates_pkey PRIMARY KEY (id);


--
-- TOC entry 4384 (class 2606 OID 27557)
-- Name: program_quarter_due_dates program_quarter_due_dates_program_id_year_quarter_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_quarter_due_dates
    ADD CONSTRAINT program_quarter_due_dates_program_id_year_quarter_key UNIQUE (program_id, year, quarter);


--
-- TOC entry 4330 (class 2606 OID 26912)
-- Name: programs programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- TOC entry 4376 (class 2606 OID 27519)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4374 (class 2606 OID 27092)
-- Name: reminders reminders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reminders
    ADD CONSTRAINT reminders_pkey PRIMARY KEY (id);


--
-- TOC entry 4332 (class 2606 OID 26925)
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- TOC entry 4389 (class 2606 OID 27722)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 4325 (class 2606 OID 26862)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4303 (class 2606 OID 17533)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4310 (class 2606 OID 26109)
-- Name: messages_2026_05_24 messages_2026_05_24_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_05_24
    ADD CONSTRAINT messages_2026_05_24_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4313 (class 2606 OID 26121)
-- Name: messages_2026_05_25 messages_2026_05_25_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_05_25
    ADD CONSTRAINT messages_2026_05_25_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4316 (class 2606 OID 26133)
-- Name: messages_2026_05_26 messages_2026_05_26_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_05_26
    ADD CONSTRAINT messages_2026_05_26_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4319 (class 2606 OID 26145)
-- Name: messages_2026_05_27 messages_2026_05_27_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_05_27
    ADD CONSTRAINT messages_2026_05_27_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4322 (class 2606 OID 26157)
-- Name: messages_2026_05_28 messages_2026_05_28_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_05_28
    ADD CONSTRAINT messages_2026_05_28_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4140 (class 2606 OID 27459)
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- TOC entry 4273 (class 2606 OID 17195)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4270 (class 2606 OID 17168)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4294 (class 2606 OID 17400)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4281 (class 2606 OID 17243)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4297 (class 2606 OID 17376)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4276 (class 2606 OID 17234)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4278 (class 2606 OID 17232)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4287 (class 2606 OID 17255)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4292 (class 2606 OID 17317)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4290 (class 2606 OID 17302)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4300 (class 2606 OID 17386)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4305 (class 2606 OID 17549)
-- Name: schema_migrations schema_migrations_idempotency_key_key; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_idempotency_key_key UNIQUE (idempotency_key);


--
-- TOC entry 4307 (class 2606 OID 17547)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4172 (class 1259 OID 16536)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4146 (class 1259 OID 16707)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4253 (class 1259 OID 17123)
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- TOC entry 4254 (class 1259 OID 17122)
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- TOC entry 4255 (class 1259 OID 17120)
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- TOC entry 4260 (class 1259 OID 17121)
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- TOC entry 4147 (class 1259 OID 16709)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4148 (class 1259 OID 16710)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4190 (class 1259 OID 16789)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4223 (class 1259 OID 16897)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4178 (class 1259 OID 16877)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 4178
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4183 (class 1259 OID 16704)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4226 (class 1259 OID 16894)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4250 (class 1259 OID 17079)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4227 (class 1259 OID 16895)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4198 (class 1259 OID 16900)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4195 (class 1259 OID 16761)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4196 (class 1259 OID 16906)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4236 (class 1259 OID 17031)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4233 (class 1259 OID 16984)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4243 (class 1259 OID 17057)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4244 (class 1259 OID 17055)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4249 (class 1259 OID 17056)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4230 (class 1259 OID 16953)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4231 (class 1259 OID 16952)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4232 (class 1259 OID 16954)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4149 (class 1259 OID 16711)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4150 (class 1259 OID 16708)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4159 (class 1259 OID 16519)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4160 (class 1259 OID 16520)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4161 (class 1259 OID 16703)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4164 (class 1259 OID 16791)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4167 (class 1259 OID 16896)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4217 (class 1259 OID 16833)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4218 (class 1259 OID 16898)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4219 (class 1259 OID 16848)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4222 (class 1259 OID 16847)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4184 (class 1259 OID 16899)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4185 (class 1259 OID 17069)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4188 (class 1259 OID 16790)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4209 (class 1259 OID 16815)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4212 (class 1259 OID 16814)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4207 (class 1259 OID 16800)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4208 (class 1259 OID 16962)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4197 (class 1259 OID 16959)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4189 (class 1259 OID 16788)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4151 (class 1259 OID 16868)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 4151
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4152 (class 1259 OID 16705)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4153 (class 1259 OID 16509)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4154 (class 1259 OID 16923)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4265 (class 1259 OID 17163)
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- TOC entry 4268 (class 1259 OID 17162)
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- TOC entry 4261 (class 1259 OID 17145)
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- TOC entry 4264 (class 1259 OID 17146)
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- TOC entry 4338 (class 1259 OID 27348)
-- Name: applications_program_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX applications_program_id_idx ON public.applications USING btree (program_id);


--
-- TOC entry 4339 (class 1259 OID 27347)
-- Name: applications_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX applications_user_id_idx ON public.applications USING btree (user_id);


--
-- TOC entry 4400 (class 1259 OID 27762)
-- Name: billing_events_stripe_event_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX billing_events_stripe_event_id_key ON public.billing_events USING btree (stripe_event_id);


--
-- TOC entry 4401 (class 1259 OID 27763)
-- Name: billing_events_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX billing_events_user_id_idx ON public.billing_events USING btree (user_id);


--
-- TOC entry 4352 (class 1259 OID 27350)
-- Name: generated_pdfs_program_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX generated_pdfs_program_id_idx ON public.generated_pdfs USING btree (program_id);


--
-- TOC entry 4353 (class 1259 OID 27349)
-- Name: generated_pdfs_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX generated_pdfs_user_id_idx ON public.generated_pdfs USING btree (user_id);


--
-- TOC entry 4354 (class 1259 OID 27665)
-- Name: generated_pdfs_user_id_program_id_quarter_year_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX generated_pdfs_user_id_program_id_quarter_year_idx ON public.generated_pdfs USING btree (user_id, program_id, quarter, year);


--
-- TOC entry 4395 (class 1259 OID 27741)
-- Name: payments_stripe_payment_intent_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX payments_stripe_payment_intent_id_key ON public.payments USING btree (stripe_payment_intent_id);


--
-- TOC entry 4396 (class 1259 OID 27743)
-- Name: payments_subscription_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_subscription_id_idx ON public.payments USING btree (subscription_id);


--
-- TOC entry 4397 (class 1259 OID 27742)
-- Name: payments_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_user_id_idx ON public.payments USING btree (user_id);


--
-- TOC entry 4328 (class 1259 OID 27094)
-- Name: profiles_user_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX profiles_user_id_key ON public.profiles USING btree (user_id);


--
-- TOC entry 4382 (class 1259 OID 27563)
-- Name: program_quarter_due_dates_program_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX program_quarter_due_dates_program_id_idx ON public.program_quarter_due_dates USING btree (program_id);


--
-- TOC entry 4385 (class 1259 OID 27564)
-- Name: program_quarter_due_dates_year_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX program_quarter_due_dates_year_idx ON public.program_quarter_due_dates USING btree (year);


--
-- TOC entry 4377 (class 1259 OID 27522)
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_tokens_token_idx ON public.refresh_tokens USING btree (token);


--
-- TOC entry 4378 (class 1259 OID 27520)
-- Name: refresh_tokens_token_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX refresh_tokens_token_key ON public.refresh_tokens USING btree (token);


--
-- TOC entry 4379 (class 1259 OID 27521)
-- Name: refresh_tokens_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_tokens_user_id_idx ON public.refresh_tokens USING btree (user_id);


--
-- TOC entry 4333 (class 1259 OID 27352)
-- Name: results_program_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX results_program_id_idx ON public.results USING btree (program_id);


--
-- TOC entry 4334 (class 1259 OID 27351)
-- Name: results_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX results_user_id_idx ON public.results USING btree (user_id);


--
-- TOC entry 4335 (class 1259 OID 27095)
-- Name: results_user_id_program_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX results_user_id_program_id_key ON public.results USING btree (user_id, program_id);


--
-- TOC entry 4390 (class 1259 OID 27725)
-- Name: subscriptions_stripe_subscription_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX subscriptions_stripe_subscription_id_idx ON public.subscriptions USING btree (stripe_subscription_id);


--
-- TOC entry 4391 (class 1259 OID 27723)
-- Name: subscriptions_stripe_subscription_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX subscriptions_stripe_subscription_id_key ON public.subscriptions USING btree (stripe_subscription_id);


--
-- TOC entry 4392 (class 1259 OID 27724)
-- Name: subscriptions_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX subscriptions_user_id_idx ON public.subscriptions USING btree (user_id);


--
-- TOC entry 4323 (class 1259 OID 27093)
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- TOC entry 4271 (class 1259 OID 17534)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4301 (class 1259 OID 17535)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4308 (class 1259 OID 26110)
-- Name: messages_2026_05_24_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_05_24_inserted_at_topic_idx ON realtime.messages_2026_05_24 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4311 (class 1259 OID 26122)
-- Name: messages_2026_05_25_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_05_25_inserted_at_topic_idx ON realtime.messages_2026_05_25 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4314 (class 1259 OID 26134)
-- Name: messages_2026_05_26_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_05_26_inserted_at_topic_idx ON realtime.messages_2026_05_26 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4317 (class 1259 OID 26146)
-- Name: messages_2026_05_27_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_05_27_inserted_at_topic_idx ON realtime.messages_2026_05_27 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4320 (class 1259 OID 26158)
-- Name: messages_2026_05_28_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_05_28_inserted_at_topic_idx ON realtime.messages_2026_05_28 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4274 (class 1259 OID 27472)
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- TOC entry 4279 (class 1259 OID 17244)
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4282 (class 1259 OID 17261)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4295 (class 1259 OID 17401)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4288 (class 1259 OID 17328)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4283 (class 1259 OID 17293)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4284 (class 1259 OID 17408)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4285 (class 1259 OID 17262)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4298 (class 1259 OID 17392)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4402 (class 0 OID 0)
-- Name: messages_2026_05_24_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_05_24_inserted_at_topic_idx;


--
-- TOC entry 4403 (class 0 OID 0)
-- Name: messages_2026_05_24_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_05_24_pkey;


--
-- TOC entry 4404 (class 0 OID 0)
-- Name: messages_2026_05_25_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_05_25_inserted_at_topic_idx;


--
-- TOC entry 4405 (class 0 OID 0)
-- Name: messages_2026_05_25_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_05_25_pkey;


--
-- TOC entry 4406 (class 0 OID 0)
-- Name: messages_2026_05_26_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_05_26_inserted_at_topic_idx;


--
-- TOC entry 4407 (class 0 OID 0)
-- Name: messages_2026_05_26_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_05_26_pkey;


--
-- TOC entry 4408 (class 0 OID 0)
-- Name: messages_2026_05_27_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_05_27_inserted_at_topic_idx;


--
-- TOC entry 4409 (class 0 OID 0)
-- Name: messages_2026_05_27_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_05_27_pkey;


--
-- TOC entry 4410 (class 0 OID 0)
-- Name: messages_2026_05_28_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_05_28_inserted_at_topic_idx;


--
-- TOC entry 4411 (class 0 OID 0)
-- Name: messages_2026_05_28_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_05_28_pkey;


--
-- TOC entry 4470 (class 2620 OID 17200)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4471 (class 2620 OID 17347)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4472 (class 2620 OID 17410)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4473 (class 2620 OID 17411)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4474 (class 2620 OID 17281)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4413 (class 2606 OID 16691)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4418 (class 2606 OID 16781)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4417 (class 2606 OID 16769)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4416 (class 2606 OID 16756)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4424 (class 2606 OID 17021)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4425 (class 2606 OID 17026)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4426 (class 2606 OID 17050)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4427 (class 2606 OID 17045)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4423 (class 2606 OID 16947)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4412 (class 2606 OID 16724)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4420 (class 2606 OID 16828)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4421 (class 2606 OID 16901)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4422 (class 2606 OID 16842)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4414 (class 2606 OID 17064)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4415 (class 2606 OID 16719)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4419 (class 2606 OID 16809)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4429 (class 2606 OID 17157)
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4428 (class 2606 OID 17140)
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4454 (class 2606 OID 27191)
-- Name: application_guides application_guides_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_guides
    ADD CONSTRAINT application_guides_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4439 (class 2606 OID 27126)
-- Name: applications applications_assigned_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_assigned_admin_id_fkey FOREIGN KEY (assigned_admin_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4440 (class 2606 OID 27121)
-- Name: applications applications_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4441 (class 2606 OID 27116)
-- Name: applications applications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4456 (class 2606 OID 27206)
-- Name: appointments appointments_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4457 (class 2606 OID 27201)
-- Name: appointments appointments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4450 (class 2606 OID 27171)
-- Name: audit_logs audit_logs_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4469 (class 2606 OID 27764)
-- Name: billing_events billing_events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_events
    ADD CONSTRAINT billing_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4448 (class 2606 OID 27166)
-- Name: counselor_sessions counselor_sessions_counselor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.counselor_sessions
    ADD CONSTRAINT counselor_sessions_counselor_id_fkey FOREIGN KEY (counselor_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4449 (class 2606 OID 27161)
-- Name: counselor_sessions counselor_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.counselor_sessions
    ADD CONSTRAINT counselor_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4446 (class 2606 OID 27156)
-- Name: deadlines deadlines_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deadlines
    ADD CONSTRAINT deadlines_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4447 (class 2606 OID 27151)
-- Name: deadlines deadlines_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deadlines
    ADD CONSTRAINT deadlines_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4442 (class 2606 OID 27136)
-- Name: documents documents_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4458 (class 2606 OID 27211)
-- Name: documents_required documents_required_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents_required
    ADD CONSTRAINT documents_required_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4443 (class 2606 OID 27131)
-- Name: documents documents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4451 (class 2606 OID 27181)
-- Name: generated_pdfs generated_pdfs_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_pdfs
    ADD CONSTRAINT generated_pdfs_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4452 (class 2606 OID 27186)
-- Name: generated_pdfs generated_pdfs_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_pdfs
    ADD CONSTRAINT generated_pdfs_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4453 (class 2606 OID 27176)
-- Name: generated_pdfs generated_pdfs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_pdfs
    ADD CONSTRAINT generated_pdfs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4455 (class 2606 OID 27196)
-- Name: guide_steps guide_steps_guide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guide_steps
    ADD CONSTRAINT guide_steps_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.application_guides(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4459 (class 2606 OID 27216)
-- Name: income_thresholds income_thresholds_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.income_thresholds
    ADD CONSTRAINT income_thresholds_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4444 (class 2606 OID 27146)
-- Name: notifications notifications_related_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_related_application_id_fkey FOREIGN KEY (related_application_id) REFERENCES public.applications(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4445 (class 2606 OID 27141)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4460 (class 2606 OID 27221)
-- Name: org_services org_services_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_services
    ADD CONSTRAINT org_services_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4467 (class 2606 OID 27749)
-- Name: payments payments_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4468 (class 2606 OID 27744)
-- Name: payments payments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4461 (class 2606 OID 27226)
-- Name: pdf_generations pdf_generations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pdf_generations
    ADD CONSTRAINT pdf_generations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4435 (class 2606 OID 27096)
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4465 (class 2606 OID 27558)
-- Name: program_quarter_due_dates program_quarter_due_dates_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_quarter_due_dates
    ADD CONSTRAINT program_quarter_due_dates_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON DELETE CASCADE;


--
-- TOC entry 4464 (class 2606 OID 27523)
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4462 (class 2606 OID 27236)
-- Name: reminders reminders_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reminders
    ADD CONSTRAINT reminders_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4463 (class 2606 OID 27231)
-- Name: reminders reminders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reminders
    ADD CONSTRAINT reminders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4436 (class 2606 OID 27111)
-- Name: results results_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4437 (class 2606 OID 27106)
-- Name: results results_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4438 (class 2606 OID 27101)
-- Name: results results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4466 (class 2606 OID 27726)
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4430 (class 2606 OID 17256)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4431 (class 2606 OID 17303)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4432 (class 2606 OID 17323)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4433 (class 2606 OID 17318)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4434 (class 2606 OID 17387)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4626 (class 0 OID 16529)
-- Dependencies: 355
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4637 (class 0 OID 16887)
-- Dependencies: 369
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4628 (class 0 OID 16684)
-- Dependencies: 360
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4625 (class 0 OID 16522)
-- Dependencies: 354
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4632 (class 0 OID 16774)
-- Dependencies: 364
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4631 (class 0 OID 16762)
-- Dependencies: 363
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4630 (class 0 OID 16749)
-- Dependencies: 362
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4638 (class 0 OID 16937)
-- Dependencies: 370
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4624 (class 0 OID 16511)
-- Dependencies: 353
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4635 (class 0 OID 16816)
-- Dependencies: 367
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4636 (class 0 OID 16834)
-- Dependencies: 368
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4627 (class 0 OID 16537)
-- Dependencies: 356
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4629 (class 0 OID 16714)
-- Dependencies: 361
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4634 (class 0 OID 16801)
-- Dependencies: 366
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4633 (class 0 OID 16792)
-- Dependencies: 365
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4623 (class 0 OID 16499)
-- Dependencies: 351
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4647 (class 0 OID 17519)
-- Dependencies: 392
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4640 (class 0 OID 17235)
-- Dependencies: 384
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4644 (class 0 OID 17354)
-- Dependencies: 388
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4645 (class 0 OID 17367)
-- Dependencies: 389
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4639 (class 0 OID 17227)
-- Dependencies: 383
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4641 (class 0 OID 17245)
-- Dependencies: 385
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4648 (class 3256 OID 25898)
-- Name: objects pdf_templates_public_read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY pdf_templates_public_read ON storage.objects FOR SELECT USING ((bucket_id = 'pdf-templates'::text));


--
-- TOC entry 4650 (class 3256 OID 25900)
-- Name: objects pdf_templates_service_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY pdf_templates_service_update ON storage.objects FOR UPDATE USING ((bucket_id = 'pdf-templates'::text));


--
-- TOC entry 4649 (class 3256 OID 25899)
-- Name: objects pdf_templates_service_write; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY pdf_templates_service_write ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'pdf-templates'::text));


--
-- TOC entry 4642 (class 0 OID 17294)
-- Dependencies: 386
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4643 (class 0 OID 17308)
-- Dependencies: 387
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4653 (class 3256 OID 25903)
-- Name: objects user_documents_owner_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY user_documents_owner_delete ON storage.objects FOR DELETE USING (((bucket_id = 'user-documents'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 4652 (class 3256 OID 25902)
-- Name: objects user_documents_owner_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY user_documents_owner_insert ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'user-documents'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 4651 (class 3256 OID 25901)
-- Name: objects user_documents_owner_select; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY user_documents_owner_select ON storage.objects FOR SELECT USING (((bucket_id = 'user-documents'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 4646 (class 0 OID 17377)
-- Dependencies: 390
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4654 (class 6104 OID 16430)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- TOC entry 4655 (class 6104 OID 25642)
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


--
-- TOC entry 4656 (class 6106 OID 25643)
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: -
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- TOC entry 3864 (class 3466 OID 16575)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- TOC entry 3869 (class 3466 OID 16654)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- TOC entry 3863 (class 3466 OID 16573)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- TOC entry 3870 (class 3466 OID 16657)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- TOC entry 3865 (class 3466 OID 16576)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- TOC entry 3866 (class 3466 OID 16577)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


-- Completed on 2026-06-12 16:10:39 IST

--
-- PostgreSQL database dump complete
--

\unrestrict O2yCeQHamzi5FLNTl3sld35RN1EzqvGamWgfFkPRLX7Jaz0AR1RjaaOVSxoMQm4

