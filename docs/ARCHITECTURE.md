# Architecture

## Stack
Next.js (App Router) + Supabase (Postgres + RLS) + Vercel.

## Build Now vs Later
**Now (v1):** Vision CRUD, Goal CRUD, Activity logging, Weekly Scorecard generation with rule-based scoring.
**Next:** AI-powered insight summaries on scorecards, goal-vision alignment scoring, trend charts across weeks.
**Later:** Auth + per-user RLS lock-down, student accounts, notification reminders.

## Key User Action Flow (Weekly Scorecard)
1. Coach logs activities during the week (free-text + goal link + effort hours).
2. Coach opens Scorecards page, clicks **Generate Scorecard** for the current week.
3. System queries all activities in the date range, groups by goal, computes a progress score per goal (rule-based: effort logged vs. expected, goal status).
4. System computes an overall week score (weighted average of goal scores, weighted toward vision alignment).
5. Scorecard renders: per-goal bars, overall score, verdict text. Saved to `weekly_scorecards`.
6. Coach reviews, adjusts goal statuses if needed.

## Responsive Nav Shell
Left sidebar on desktop (Vision, Goals, Activities, Scorecards), collapses to hamburger on mobile. Current section highlighted.

## Layer Plan
1. **Data layer** (`lib/data/`) — all Supabase reads/writes, typed queries for visions, goals, activities, scorecards.
2. **App logic** (`lib/scorecard/`) — rule-based scoring engine: goal score = effort completeness + goal status. Overall = weighted average. Runs without any AI.
3. **AI layer** (`lib/ai/`) — optional insight generation on top of the rule-based score (drafts verdict text, suggests goal adjustments). Core app works fully with AI off.

## Why Core Runs Without AI
Scoring is deterministic: effort hours logged ÷ expected hours per goal × weight. Verdict text uses thresholds (≥80 on-track, 50–79 drifting, <50 off-track). AI only enriches the insight narrative.

## Repo Structure
```
app/(sidebar)/vision/page.tsx
app/(sidebar)/goals/page.tsx
app/(sidebar)/activities/page.tsx
app/(sidebar)/scorecards/page.tsx
components/          # UI components per feature
lib/data/           # data-access layer (all DB calls)
lib/scorecard/      # scoring engine
lib/ai/             # AI insight generation
__tests__/          # tests beside code
```

## Module Map
| Module | Responsibility | Data Owned | Build Order |
|--------|---------------|------------|-------------|
| `vision` | CRUD for the 10-year vision | visions table | 1 |
| `goals` | CRUD for goals, categorized by domain | goals table | 2 |
| `activities` | Log and list daily activities | activities table | 3 |
| `scorecard` | Generate, score, and display weekly scorecards | weekly_scorecards table | 4 |
| `ai-insight` | Draft insight text from scorecard data | none (reads scorecards) | 5 |
