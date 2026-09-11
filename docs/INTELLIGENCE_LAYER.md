# Intelligence Layer

## Messy Inputs
Coach types free-text activity descriptions like "went for a 5k run in the morning" or "read 2 chapters of Atomic Habits." These need to be structured.

## Auto-Structure Schema
```json
{
  "goal_id": "uuid-of-linked-goal",
  "category": "health",
  "effort_hours": 0.5,
  "description": "went for a 5k run in the morning",
  "logged_date": "2025-01-15"
}
```
In v1 the coach manually links the goal and enters effort hours. Auto-categorization is a **later** AI enhancement.

## Events to Track
- `activity_logged` — goal_id, effort_hours, date
- `scorecard_generated` — week range, overall_score
- `goal_status_changed` — old status, new status

## Scoring Rules (v1 — Rule-Based, No AI Required)
**Per-goal score (0–100):**
- `effort_completeness` = min(1.0, sum(activities.effort_hours this week) / 5) × 60  — 5 hours/week assumed target per goal
- `status_bonus` = on_track→40, active→25, drifting→10, paused→0
- `goal_score` = effort_completeness + status_bonus (capped at 100)

**Overall week score:**
- Weighted average of goal scores, weights: long-term goals ×1.5, short-term goals ×1.0
- Vision alignment factor: if active vision exists, multiply overall by 1.0 (penalize if no vision set → ×0.8)

**Verdict thresholds:** ≥80 on-track, 50–79 drifting, <50 off-track.

## What Gets Ranked
Goals ranked by goal_score descending on the scorecard. Across weeks, scorecards ranked by overall_score to show trend.

## v1 vs Later
- **v1:** Pure rule-based scoring, manual goal linking, manual effort entry.
- **Later:** AI auto-categorizes activities, suggests effort estimates from text, generates insight narrative, computes vision-alignment score per goal.
