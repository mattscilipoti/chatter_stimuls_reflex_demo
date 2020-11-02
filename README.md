# Demo of StimulusReflex

I'm just learning about https://docs.stimulusreflex.com/

This code is following this video step-by-step: https://www.youtube.com/watch?v=F5hA79vKE_E

> Note: The Last step (broadcast the Likes/Reposts) was NOT necessary.

## Dockerized!

This is dockerized. You do NOT need to install *any* dependencies (besides docker).

- Start docker container with redis and rails server via `bin/setup`
  - watch this terminal for rails' logs
- Start shell(s) via `bin/shell`. Use these for commands (e.g. `bin/rails db:setup`, `rails console`, etc.)

> These are just wrappers for standard Docker commands
