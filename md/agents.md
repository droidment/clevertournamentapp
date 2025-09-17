# Agents Playbook

## Purpose
This document defines a starting blueprint for AI or automation agents that assist with the CleverTournament product. It focuses on high-impact workflows where an agent can reduce organizer effort or provide real-time insights for teams and players.

## Agent Catalog
| Agent | Primary Users | Core Responsibilities | Key Data Sources |
| --- | --- | --- | --- |
| OrganizerOps Agent | Tournament organizers | Create/update tournaments, manage pools and schedules, monitor registrations, surface alerts on missing data | `tournaments`, `pools`, `teams`, `games`, `team_registrations`, `announcements` |
| Registration Concierge | Team captains, public entrants | Guide new teams through registration, validate required fields, hand off to organizer review queue | `team_registrations`, `teams`, Supabase auth profile metadata |
| Roster Assistant | Team captains, players | Maintain rosters, send join-code instructions, collect missing player info | `teams`, `players`, `join_team` RPC |
| Schedule Analyst | Organizers, spectators | Generate matchups, detect double bookings, publish daily schedules, push reminders | `games`, `pools`, tournament `settings` json |
| Standings Reporter | Spectators, media | Explain standings, highlight clinch/elimination scenarios, respond to "what-if" score updates | `games`, `teams`, computed standings logic |
| Broadcast Agent | All participants | Draft announcements, segment audiences, confirm delivery success | `announcements`, Supabase auth user metadata |

## Operating Principles
- **Human-in-the-loop:** Organizer agents should request confirmation before committing structural changes (e.g., deleting pools or regenerating join codes).
- **Least-privilege access:** Each agent should use a dedicated Supabase service role or row-level policy context that limits operations to its responsibilities.
- **Auditability:** Log agent decisions and API calls to a dedicated table (e.g., `agent_activity`) with timestamps, actors, inputs, and outcomes.
- **Opt-in messaging:** Before sending notifications (email, SMS, push), confirm participant consent and channel preferences stored in profile metadata.

## Typical Workflows
1. **Tournament bootstrap**
   - OrganizerOps Agent scaffolds a new tournament (name, sport, dates, location).
   - Registration Concierge publishes a sign-up landing page and monitors incoming entries.
   - Broadcast Agent sends confirmation emails with next steps.
2. **Pre-event roster completion**
   - Roster Assistant checks for teams with fewer than the required players.
   - Sends reminders containing deep links (`#/join?code=<code>`) to join rosters.
   - OrganizerOps Agent flags unresolved issues ahead of schedule generation.
3. **Scheduling cycle**
   - Schedule Analyst runs round-robin generation via `TournamentRepo.insertGames` equivalent endpoints.
   - Detects conflicts (same team booked twice, court overlap) and proposes fixes.
   - Broadcast Agent posts the finalized schedule announcement.
4. **Game day operations**
   - Schedule Analyst monitors start times, creates alerts for delays.
   - Standings Reporter answers queries ("Who leads Pool A?") and auto-updates social embeds.
   - OrganizerOps Agent escalates anomalies (missing scores, forfeits) to staff.
5. **Post-event wrap-up**
   - Standings Reporter summarizes final placements and awards.
   - Broadcast Agent thanks participants and distributes surveys.
   - OrganizerOps Agent archives the tournament and exports reports.

## Interfaces & Tools
- **Supabase REST/RPC:** Primary interface for CRUD operations. Agents should reuse existing RPCs (`join_team`, future `generate_schedule`) where possible.
- **Realtime channels:** Subscribe to table changes (games, announcements) to keep agent decisions timely.
- **External services:** Integrate with email/SMS providers for outreach. Store API credentials in a secure secrets manager, not in app config.
- **Task queue:** Use a worker or cron-like system for recurring checks (e.g., nightly roster audits).

## Implementation Notes
- Keep agent logic modular; each agent should be deployable as a separate service or worker to simplify scaling and permissioning.
- Standardize payloads with typed DTOs mirroring Dart models (`Tournament`, `Team`, `GameModel`) to avoid translation bugs.
- Consider embedding a lightweight rules engine so organizers can tweak thresholds (e.g., minimum roster size) without new deployments.
- When agents propose destructive actions, generate a human-readable diff (old vs. new records) for review in the dashboard or via email.
- Capture agent telemetry (latency, success rate, errors) for continuous improvement.

## Open Questions
- What communication channels will organizers trust for agent prompts (in-app, email, SMS, Slack)?
- How will authentication work for public-facing agents (e.g., Registration Concierge chat widget) to prevent spam?
- Do we need multilingual support for participant-facing messaging?
- Should agent overrides be versioned so we can roll back unintended actions quickly?

## Next Steps
1. Prioritize which agent unlocks the most value for the MVP (OrganizerOps Agent vs. Registration Concierge).
2. Define detailed user stories and success metrics for the chosen agent.
3. Design Supabase policies and service-role keys aligned with agent scope.
4. Build a proof-of-concept workflow, instrument logging, and gather user feedback before expanding to additional agents.

