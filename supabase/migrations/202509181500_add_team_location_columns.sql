-- Adds city/state/jersey_color columns to teams and removes legacy contact fields.
BEGIN;

ALTER TABLE public.teams
    ADD COLUMN IF NOT EXISTS city TEXT,
    ADD COLUMN IF NOT EXISTS state TEXT,
    ADD COLUMN IF NOT EXISTS jersey_color TEXT;

-- Backfill legacy rows so new NOT NULL constraints succeed.
UPDATE public.teams
SET
    city = COALESCE(NULLIF(city, ''), 'Unspecified City'),
    state = COALESCE(NULLIF(state, ''), 'Unspecified State')
WHERE city IS NULL OR state IS NULL;

ALTER TABLE public.teams
    ALTER COLUMN city SET NOT NULL,
    ALTER COLUMN state SET NOT NULL;

ALTER TABLE public.teams
    DROP COLUMN IF EXISTS contact_email,
    DROP COLUMN IF EXISTS contact_phone;

COMMIT;