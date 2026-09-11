# Security

## Secret Handling
- Supabase URL and anon key in `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` (public-safe, client-side).
- Supabase service role key in `SUPABASE_SERVICE_ROLE_KEY` — server-only, never imported in client components, never exposed in frontend bundles.
- Any AI API keys in server-only env vars, called from server actions / route handlers only.

## Permission Model
- **v1 (demo-first):** All tables have permissive RLS — anonymous read/write works. No auth wall. Seed data renders for any visitor.
- **Lock-down sprint:** Replace permissive policies with `auth.uid() = user_id` on all tables. Only the owner can read/write their visions, goals, activities, and scorecards.
- Agent (when added) inherits the logged-in user's permissions — never runs with service-role key for user-facing actions.

## Approved-Tools Rule
- Only named, server-side functions may touch the database (`generate_scorecard`, `update_goal_status`).
- No generic `run_any` or `send_any` tools exposed to the client or AI.
- AI insight generation is read-only (queries scorecard data, returns text) — no write permissions for AI in v1.

## Audit Principle
Every meaningful action (scorecard generation, goal status change, goal/vision deletion) is logged to `audit_logs` with actor, action, target, and timestamp. Audit log is append-only.
