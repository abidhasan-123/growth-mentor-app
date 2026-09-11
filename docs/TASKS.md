# Tasks — Sprints

## Sprint 1: Foundation + Core CRUD (Viewable Without Login)
**Goal:** Vision, Goal, and Activity CRUD working against the database with seeded demo data.
- [ ] Set up Next.js + Supabase client + env config
- [ ] Create migration SQL (visions, goals, activities, weekly_scorecards, audit_logs) with seed data
- [ ] Build `lib/data/` data-access layer for all four tables
- [ ] Build Vision page: create / edit active vision
- [ ] Build Goals page: create / edit / delete goals (category, timeframe, target_date)
- [ ] Build Activities page: log activity (goal link, description, effort hours, date), list by week
- [ ] Build sidebar nav shell (desktop sidebar / mobile hamburger)
- [ ] Handle loading, empty, and error states on all three pages

**Definition of Done:** Visitor opens app without login, sees seeded vision + 3 goals + 5 activities. Can create a new goal, log an activity, and edit the vision — all persist to Supabase and survive refresh.

## Sprint 2: Weekly Scorecard Engine ← V1 FUNCTIONAL MILESTONE
**Goal:** The core engine — generate a scored weekly scorecard end-to-end.
- [ ] Build `lib/scorecard/` scoring engine (per-goal score + overall score + verdict)
- [ ] Build Scorecards page: week picker, "Generate Scorecard" button
- [ ] Generate scorecard: query week's activities, compute scores, save to `weekly_scorecards`
- [ ] Display scorecard: per-goal score bars, overall score, verdict text
- [ ] List past scorecards with overall scores
- [ ] Allow goal status update from scorecard view ("Mark as drifting" button)
- [ ] Handle empty week (no activities → scorecard shows 0 scores with helpful copy)
- [ ] Handle error state (scorecard generation fails → error message, no silent failure)

**Definition of Done:** Coach logs activities, clicks Generate Scorecard, sees per-goal scores (0–100), overall week score, and verdict. Scorecard is saved and visible on reload. Empty weeks show a clear "No activities this week" state.

## Sprint 3: AI Insight Layer
**Goal:** AI-generated insight text on scorecards + goal-vision alignment scoring.
- [ ] Build `lib/ai/` module for insight generation (server-side)
- [ ] Add "Generate AI Insight" button on scorecard (optional, manual trigger)
- [ ] Store insight in `ai_insight` + `ai_insight_source` + `ai_insight_confidence` + `review_status`
- [ ] Display insight with "AI-generated" badge and review status indicator
- [ ] Compute `ai_alignment_score` per goal (how aligned is this goal to the 10-year vision?)
- [ ] Show alignment scores on Goals page
- [ ] Handle AI failure gracefully (fallback to rule-based verdict, show error badge)

**Definition of Done:** Coach clicks "Generate AI Insight," sees a 2–3 sentence narrative verdict. If AI fails, rule-based verdict still shows. Alignment scores appear on goals.

## Sprint 4: Lock It Down
**Goal:** Auth + per-user data isolation.
- [ ] Add Supabase Auth (sign up / log in / log out)
- [ ] Add login wall — redirect unauthenticated users to /login
- [ ] Replace permissive RLS with owner-scoped policies (`auth.uid() = user_id`)
- [ ] Assign `user_id` on all inserts from authenticated session
- [ ] Migrate seed data to a demo user account
- [ ] Test: user A cannot see user B's data

**Definition of Done:** New visitor must sign up to use the app. Logged-in user sees only their own visions, goals, activities, and scorecards. Cross-user data access is blocked by RLS.

## Text Gantt
```
Sprint 1  ████████░░░░░░░░  DB + CRUD + nav
Sprint 2  ░░░░░░░░████████  Scorecard engine (v1 functional)
Sprint 3  ░░░░░░░░░░░░████  AI insight layer
Sprint 4  ░░░░░░░░░░░░░░██  Auth + RLS lock-down
```
