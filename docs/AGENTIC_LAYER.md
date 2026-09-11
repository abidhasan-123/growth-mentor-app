# Agentic Layer

## Draftable Actions (Low Risk — Auto)
| Action | Trigger | What It Does |
|--------|---------|-------------|
| Compute goal scores | Scorecard generation | Rule-based calculation, no approval needed |
| Generate insight text | Scorecard generation | AI drafts a 2–3 sentence verdict (stored as `ai_insight`, `review_status=unreviewed`) |
| Tag activity category | Activity logged | AI suggests category from description text (displayed as suggestion, not auto-saved in v1) |

## Executable-After-Approval Actions (Medium Risk)
| Action | Trigger | Approval |
|--------|---------|----------|
| Update goal status | Scorecard shows drifting | Coach clicks "Mark as drifting" — one click, persisted |
| Recommend goal adjustment | Scorecard shows off-track | AI suggests status change, coach confirms |

## Human-Only Actions (High/Critical Risk)
| Action | Why |
|--------|-----|
| Delete a goal | Data loss — confirm dialog required |
| Delete a scorecard | Historical data loss — confirm dialog required |
| Delete a vision | Cascade deletes all goals — confirm dialog required |

## Named Tools
- `generate_scorecard` — queries activities for week range, computes scores, inserts `weekly_scorecards` row.
- `draft_insight` — calls AI with scorecard data, returns insight text (no side effects until saved).
- `update_goal_status` — updates `goals.status` field.

## Audit Log Fields
Every agentic action writes to `audit_logs`: `id`, `user_id`, `action`, `target_table`, `target_id`, `metadata jsonb`, `created_at`.

## v1 vs Later
- **v1:** `generate_scorecard` + `update_goal_status`. No AI actions — insight text is optional and manual-triggered.
- **Later:** `draft_insight` (AI), auto-tag activities, scheduled weekly auto-generation.
