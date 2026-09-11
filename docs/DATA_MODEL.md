# Data Model

## visions
| Field | Type | Notes |
|------|------|-------|
| id | uuid PK | `gen_random_uuid()` |
| user_id | uuid | nullable (owner-scoping at lock-down) |
| title | text | not null |
| description | text | not null — the full vision statement |
| target_year | int | not null — e.g. 2035 |
| created_at | timestamptz | default now() |

**RLS:** Permissive read/write in v1. Owner-scoped (`auth.uid() = user_id`) at lock-down sprint.

## goals
| Field | Type | Notes |
|------|------|-------|
| id | uuid PK | |
| user_id | uuid | nullable |
| vision_id | uuid FK → visions | cascade delete |
| title | text | not null |
| description | text | |
| category | text | `health` / `soft_skills` / `education` / `career` |
| timeframe | text | `short` / `long` |
| target_date | date | |
| status | text | `active` / `on_track` / `drifting` / `achieved` / `paused` |
| ai_alignment_score | numeric | AI: 0–100 alignment to vision |
| ai_alignment_source | text | AI: model name |
| ai_alignment_confidence | numeric | AI: 0–1 |
| ai_alignment_review_status | text | default `unreviewed` |
| created_at | timestamptz | default now() |

**Relationship:** Many goals belong to one vision.

## activities
| Field | Type | Notes |
|------|------|-------|
| id | uuid PK | |
| user_id | uuid | nullable |
| goal_id | uuid FK → goals | cascade delete |
| description | text | not null — free-text |
| category | text | mirrors goal category |
| effort_hours | numeric | default 0 |
| logged_date | date | default current_date |
| created_at | timestamptz | default now() |

**Relationship:** Many activities belong to one goal.

## weekly_scorecards
| Field | Type | Notes |
|------|------|-------|
| id | uuid PK | |
| user_id | uuid | nullable |
| week_start | date | not null |
| week_end | date | not null |
| overall_score | numeric | 0–100, rule-based |
| ai_insight | text | AI-generated verdict text |
| ai_insight_source | text | AI: model name |
| ai_insight_confidence | numeric | AI: 0–1 |
| ai_insight_review_status | text | default `unreviewed` |
| created_at | timestamptz | default now() |

**Relationship:** One scorecard per week. Per-goal scores are computed at generation time from activities; not persisted as separate rows in v1 (displayed from query).

## RLS / Permissions (v1 — Demo-First)
All tables: permissive select + write for anonymous demo. Lock-down sprint replaces with `auth.uid() = user_id`.
