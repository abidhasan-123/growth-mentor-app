# Growth Mentor App — PRD

## Problem
People optimize for incremental 2x improvement and stay stuck in safe cycles. A 10-year vision as the system's primary constraint forces exponential (10x) goal-setting. Without weekly accountability against that vision, goals drift.

## Target User
A personal growth mentor or coach who sets visions and goals for themselves and their students, and needs a weekly scorecard to measure real progress.

## Core Objects
- **Vision** — a 10-year north-star statement (one active at a time).
- **Goal** — short-term or long-term, tagged by category: health, soft-skills, education, career.
- **Activity** — a logged action toward a goal (date, effort hours, free-text description).
- **Weekly Scorecard** — auto-generated summary of the week's activities, a progress score per goal, and an overall score against the vision.

## MVP (v1) Checklist
- [ ] Create / edit one active 10-year vision
- [ ] Create / edit / delete goals (short & long-term, categorized)
- [ ] Log daily activities against goals
- [ ] Generate a weekly scorecard that scores each goal and the week overall
- [ ] Scorecard shows which goals are on-track vs drifting vs the vision
- [ ] All screens viewable without login (demo data seeded)
- [ ] Every form/button persists to the database and UI reflects it

## Non-Goals (v1)
- No human check-ins or manual review by a second person
- No multi-tenant SaaS / billing / subscriptions
- No student accounts or multi-user collaboration
- No calendar / scheduling integration
- No notifications or email

## Success Criteria
Coach opens the app, writes a 10-year vision, creates 3 goals (one health, one education, one soft-skills), logs 5 activities across the week, clicks "Generate Scorecard," and sees a weekly scorecard with per-goal scores (0–100), an overall week score, and a plain-English verdict on whether the week moved toward the 10-year vision. The scorecard is saved to the database and visible on reload.
