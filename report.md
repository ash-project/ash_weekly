For any versions published on the same day as the last newsletter,
you'll have to manually check if they were included in the last newsletter!

Don't forget :)

Also, add next office hours link in advance.


# ash-project/ash
## [v3.5.11](https://github.com/ash-project/ash/compare/v3.5.10...v3.5.11) (2025-05-20)
### Bug Fixes:
* ensure we fully initialize new types
* Tuple loader and serializer (#2049)
* make sure after_action is called in generate_many (#2047)
* properly pass `select` into combinations
* add_new_code_interface/5 when do block occurs after resource (#2020)
### Improvements:
* add experimental new tool `Ash.data_layer_query`
## [v3.5.10](https://github.com/ash-project/ash/compare/v3.5.9...v3.5.10) (2025-05-15)
### Bug Fixes:
* ensure field policies are logged on success
* various additional fixes for bulk action input ordering
* Fix batch order of bulk_create (#2027)
* make `lazy_init?` a callback so it can be checked on new types
* don't raise error when no policies apply to request
* ensure tenant is set on bulk created records.
* don't try to cast input before cast atomic
* properly prevent embedded attribute updates in atomics
* preserve validation messages in non-atomic-bulk-update validations
* add types for times operator
* properly handle pre-expanded newtype constraints
* shortcircuit queries properly
* only print topic if present (#2013)
### Improvements:
* support :time_usec (#2023)
* support `limit` on has_many relationships (#2016)





# ash-project/ash_ai
## [v0.1.2](https://github.com/ash-project/ash_ai/compare/v0.1.1...v0.1.2) (2025-05-20)
### Bug Fixes:
* improve chat ui heex template
* don't reply to the initialized notification (#35)
### Improvements:
* update chat heex template. (#33)
## [v0.1.1](https://github.com/ash-project/ash_ai/compare/v0.1.0...v0.1.1) (2025-05-14)
### Bug Fixes:
* more fixes for gen.chat message order
* properly generate chat message log
### Improvements:
* fix update pre_flight permission request for tools
## [v0.1.0](https://github.com/ash-project/ash_ai/compare/v0.1.0...v0.1.0) (2025-05-14)
### Bug Fixes:
* always configure chat queues
* Set additionalProperties to false in parameter_schema (#16)
* Fix load opt not working (#12)
* don't pass nil input in function/4 (#8)
* Fix schema type of actions of Options (#5)
* use `:asc` to put lowest distance records at the top
* use correct ops in vector before action
* use `message` instead of `reason`
### Improvements:
* add `mix ash_ai.gen.mcp`
* dev tools MCP
* remove vector search action
* Add an MCP server support
* support tool-level descriptions
* better name trigger
* use bulk actions for update/destroy
* first draft of `mix ash_ai.gen.chat` (#19)
* allow read actions to be aggregated in addition to run
* set up CI, various fixes and refactors
* Add aggregates to filter properties (#15)
* Add async opt to Tool
* Add load opt to tool (#9)
* Add tenant to opts of setup_ash_ai/2 (#4)
* add installer
* add tenants to action calls in functions
* add `:manual` strategy
* allow specifying tools by name of tool
* strict modes & other various improvements
* make embedding model parameterizable
* remove unnecessary deps, use langchain
* make embedding models for arbitrary vectorization
* use configured name for tools
* make the DSL more `tool` centric
* add vectorize section


# ash-project/igniter
## [v0.5.52](https://github.com/ash-project/igniter/compare/v0.5.51...v0.5.52) (2025-05-20)
### Improvements:
* bump installer version
* Add igniter.init task to igniter_new archive (#283)
* clean up igniter after adding it for installation
* Task/adds move to function and attrs (#274)
* generate a test when generating a new task
## [v0.5.51](https://github.com/ash-project/igniter/compare/v0.5.50...v0.5.51) (2025-05-15)
### Bug Fixes:
* properly detect map format
* don't always create default config files
* Add impl to generated mix task (#276)
* Matches function guards when using move_to_def (#273)


# ash-project/spark
## [v2.2.57](https://github.com/ash-project/spark/compare/v2.2.56...v2.2.57) (2025-05-20)
### Improvements:
* make compiled modules smaller via deriving spark_dsl_config
## [v2.2.56](https://github.com/ash-project/spark/compare/v2.2.55...v2.2.56) (2025-05-15)
### Bug Fixes:
* when adding an extension, don't remove it if its already there
* escape default values in info generator








# ash-project/ash_graphql
## [v1.7.11](https://github.com/ash-project/ash_graphql/compare/v1.7.10...v1.7.11) (2025-05-20)
### Improvements:
* Add meta option for adding custom resolution context (#317)
## [v1.7.10](https://github.com/ash-project/ash_graphql/compare/v1.7.9...v1.7.10) (2025-05-15)
### Bug Fixes:
* refactor internal `AshGraphql.Resource.mutation/6` (#312)
* refactor internal `AshGraphql.Resource.mutation_fields/5` (#311)
* define shared mutations options (#310)
* Support for returning relay encoded id when subscribing to destroy events (#307)
### Improvements:
* add `args` option to mutations (#314)


# ash-project/ash_json_api
## [v1.4.31](https://github.com/ash-project/ash_json_api/compare/v1.4.30...v1.4.31) (2025-05-15)
### Bug Fixes:
* use string names for parameters everywhere in open api spec
* handle more cases where path params collide w/ query params
### Improvements:
* more consistency for route & query params


# team-alembic/ash_authentication
## [v4.8.7](https://github.com/team-alembic/ash_authentication/compare/v4.8.6...v4.8.7) (2025-05-20)
### Bug Fixes:
* incorrect warning in password verifier.
* remove underscores from app name for prefix
### Improvements:
* Strategy.Custom: The `strategy_module` field is no longer required.
## [v4.8.6](https://github.com/team-alembic/ash_authentication/compare/v4.8.5...v4.8.6) (2025-05-16)
### Bug Fixes:
* remove underscores from app name for prefix
## [v4.8.5](https://github.com/team-alembic/ash_authentication/compare/v4.8.4...v4.8.5) (2025-05-15)
### Improvements:
* provide explicit name to api key strategy when installed
## [v4.8.4](https://github.com/team-alembic/ash_authentication/compare/v4.8.3...v4.8.4) (2025-05-15)
### Improvements:
* Confirmation: Provide a default accept phase form. (#986)
* pass along the action_input.context to the send_opts as `:context`. (#989)





# ash-project/ash_postgres
## [v2.5.20](https://github.com/ash-project/ash_postgres/compare/v2.5.19...v2.5.20) (2025-05-20)
### Bug Fixes:
* self-join if combination queries require more fields
* enforce tenant name rules at creation (#550)











# ash-project/ash_admin
## [v0.13.5](https://github.com/ash-project/ash_admin/compare/v0.13.4...v0.13.5) (2025-05-20)
### Bug Fixes:
* don't duplicate `ash_admin` routes on installation




















# ash-project/ash_state_machine
## [v0.2.11](https://github.com/ash-project/ash_state_machine/compare/v0.2.10...v0.2.11) (2025-05-15)
### Bug Fixes:
* use atomic error instead of modifying changeset for no such state








# ash-project/ash_phoenix
## [v2.3.1](https://github.com/ash-project/ash_phoenix/compare/v2.3.0...v2.3.1) (2025-05-15)
### Bug Fixes:
* Initialize :raw_params field of for_action() Form (#362)
* for action params option (#359)
* Accept Phoenix.LiveView.Socket in SubdomainPlug (#355)
### Improvements:
* Document `:params` option for `for_action` (#361)
* Rework gen.live (#353)
* support `AshPhoenix.Form` in error subject









Now go to the `ash-weekly` discord channel and check for any updates since the last ash-weekly post
Post to reddit.com/r/elixir
Post to https://elixirforum.com/t/ash-weekly-newsletter/68818
Post to discord