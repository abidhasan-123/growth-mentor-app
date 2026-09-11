# Test Plan

## V1 Success Scenario (Manual)
1. Open app (no login) — verify sidebar shows Vision, Goals, Activities, Scorecards
2. Go to Vision — verify seeded 10-year vision displays
3. Click Edit, change the vision title, save — verify it persists on reload
4. Go to Goals — verify 3 seeded goals display (health, education, soft_skills)
5. Click New Goal — enter title "Publish research paper", category education, timeframe long-term, save — verify it appears in list
6. Go to Activities — verify seeded activities display for the current week
7. Click Log Activity — select a goal, type "Studied for 3 hours", enter 3 effort hours, save — verify it appears
8. Go to Scorecards — verify empty state or past scorecard
9. Click Generate Scorecard for current week — verify:
   - Per-goal scores (0–100) display as bars
   - Overall week score displays
   - Verdict text shows (on-track / drifting / off-track)
   - Scorecard is saved (appears in past scorecards list on reload)
10. Click "Mark as drifting" on a goal — verify goal status updates and persists

## Empty States
- **No vision set:** Vision page shows "Set your 10-year vision" prompt with create form
- **No goals:** Goals page shows "Create your first goal" with category hints
- **No activities this week:** Activities page shows "No activities logged this week" + log button
- **No scorecards yet:** Scorecards page shows "Generate your first scorecard" with week picker
- **Empty week scorecard:** Generate scorecard with 0 activities → shows 0 scores, verdict "No activity this week — goals are at risk"

## Error States
- **Supabase connection fails:** Pages show "Unable to load data — check connection" with retry button, no blank screen
- **Scorecard generation fails:** Error toast "Could not generate scorecard — try again", no silent failure
- **Goal deletion blocked by confirm dialog:** Verify delete requires confirmation; cancel returns to list

## Edge Cases
- Log activity with 0 effort hours → saved, scores reflect 0 effort
- Generate scorecard for a past week with no activities → 0 scores, helpful copy
- Create goal with no target_date → allowed, scorecard still scores based on effort
- Edit a goal that has activities → activities remain linked, scores update on next scorecard generation
