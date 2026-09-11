-- Growth Mentor App — domain schema (demo-first, idempotent)

create table if not exists visions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  title text not null,
  description text not null,
  target_year int not null,
  created_at timestamptz not null default now()
);

create table if not exists goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  vision_id uuid references visions(id) on delete cascade,
  title text not null,
  description text,
  category text not null default 'education',
  timeframe text not null default 'short',
  target_date date,
  status text not null default 'active',
  ai_alignment_score numeric,
  ai_alignment_source text,
  ai_alignment_confidence numeric,
  ai_alignment_review_status text default 'unreviewed',
  created_at timestamptz not null default now()
);

create table if not exists activities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  goal_id uuid references goals(id) on delete cascade,
  description text not null,
  category text not null default 'education',
  effort_hours numeric default 0,
  logged_date date not null default current_date,
  created_at timestamptz not null default now()
);

create table if not exists weekly_scorecards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  week_start date not null,
  week_end date not null,
  overall_score numeric,
  ai_insight text,
  ai_insight_source text,
  ai_insight_confidence numeric,
  ai_insight_review_status text default 'unreviewed',
  created_at timestamptz not null default now()
);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  action text not null,
  target_table text,
  target_id uuid,
  metadata jsonb,
  created_at timestamptz not null default now()
);

-- RLS: enable on all tables
alter table visions enable row level security;
alter table goals enable row level security;
alter table activities enable row level security;
alter table weekly_scorecards enable row level security;
alter table audit_logs enable row level security;

-- Permissive v1 policies (demo-first, replaced at lock-down sprint)
drop policy if exists "visions_v1_read" on visions;
create policy "visions_v1_read" on visions for select using (true);
drop policy if exists "visions_v1_write" on visions;
create policy "visions_v1_write" on visions for all using (true) with check (true);

drop policy if exists "goals_v1_read" on goals;
create policy "goals_v1_read" on goals for select using (true);
drop policy if exists "goals_v1_write" on goals;
create policy "goals_v1_write" on goals for all using (true) with check (true);

drop policy if exists "activities_v1_read" on activities;
create policy "activities_v1_read" on activities for select using (true);
drop policy if exists "activities_v1_write" on activities;
create policy "activities_v1_write" on activities for all using (true) with check (true);

drop policy if exists "weekly_scorecards_v1_read" on weekly_scorecards;
create policy "weekly_scorecards_v1_read" on weekly_scorecards for select using (true);
drop policy if exists "weekly_scorecards_v1_write" on weekly_scorecards;
create policy "weekly_scorecards_v1_write" on weekly_scorecards for all using (true) with check (true);

drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

-- Seed: vision
insert into visions (id, user_id, title, description, target_year)
select 'a0000000-0000-0000-0000-000000000001', null, 'Become a globally recognized growth coach', 'In 10 years I will have coached 1,000 students to achieve their own 10x visions, built a recognized methodology, and achieved personal mastery in health, continuous learning, and communication.', 2035
on conflict (id) do nothing;

-- Seed: goals
insert into goals (id, user_id, vision_id, title, description, category, timeframe, target_date, status)
select 'b0000000-0000-0000-0000-000000000001', null, 'a0000000-0000-0000-0000-000000000001', 'Run a half-marathon', 'Build cardiovascular endurance and run a half-marathon in under 2 hours.', 'health', 'short', '2025-06-30', 'on_track'
on conflict (id) do nothing;

insert into goals (id, user_id, vision_id, title, description, category, timeframe, target_date, status)
select 'b0000000-0000-0000-0000-000000000002', null, 'a0000000-0000-0000-0000-000000000001', 'Read 12 books this year', 'One book per month focused on psychology, leadership, and personal growth.', 'education', 'long', '2025-12-31', 'active'
on conflict (id) do nothing;

insert into goals (id, user_id, vision_id, title, description, category, timeframe, target_date, status)
select 'b0000000-0000-0000-0000-000000000003', null, 'a0000000-0000-0000-0000-000000000001', 'Master public speaking', 'Deliver 5 keynote talks and complete a Toastmasters advanced track.', 'soft_skills', 'long', '2025-12-31', 'drifting'
on conflict (id) do nothing;

-- Seed: activities (current week)
insert into activities (id, user_id, goal_id, description, category, effort_hours, logged_date)
select 'c0000000-0000-0000-0000-000000000001', null, 'b0000000-0000-0000-0000-000000000001', 'Morning 5K run along the river', 'health', 1.0, current_date - 4
on conflict (id) do nothing;

insert into activities (id, user_id, goal_id, description, category, effort_hours, logged_date)
select 'c0000000-0000-0000-0000-000000000002', null, 'b0000000-0000-0000-0000-000000000001', 'Strength training session at gym', 'health', 1.5, current_date - 3
on conflict (id) do nothing;

insert into activities (id, user_id, goal_id, description, category, effort_hours, logged_date)
select 'c0000000-0000-0000-0000-000000000003', null, 'b0000000-0000-0000-0000-000000000002', 'Read 3 chapters of Atomic Habits', 'education', 2.0, current_date - 2
on conflict (id) do nothing;

insert into activities (id, user_id, goal_id, description, category, effort_hours, logged_date)
select 'c0000000-0000-0000-0000-000000000004', null, 'b0000000-0000-0000-0000-000000000003', 'Practice presentation for 30 minutes', 'soft_skills', 0.5, current_date - 1
on conflict (id) do nothing;

insert into activities (id, user_id, goal_id, description, category, effort_hours, logged_date)
select 'c0000000-0000-0000-0000-000000000005', null, 'b0000000-0000-0000-0000-000000000002', 'Took online course module on leadership', 'education', 1.5, current_date
on conflict (id) do nothing;

-- Seed: past scorecard
insert into weekly_scorecards (id, user_id, week_start, week_end, overall_score)
select 'd0000000-0000-0000-0000-000000000001', null, current_date - 11, current_date - 5, 72
on conflict (id) do nothing;