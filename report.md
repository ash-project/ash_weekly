# ash-project/ash
## [v3.4.55](https://github.com/ash-project/ash/compare/v3.4.54...v3.4.55) (2025-01-13)
### Bug Fixes:
* ensure can_* code interfaces pass arguments to actions
* another pattern match error in `Ash.can?`
* case clause error in `Ash.can?`
* handle embedded attributes in attribute generator
* `Ash.Generator`: Fix typo in skipped import name (#1704)
* reset `ash_started_transaction?` on bulk create
* set max_concurrency to 0 for generate_many
* ensure that `once` and `sequence` behave predictably across tests
### Improvements:
* destroy missing records first in `manage_relationship`
* add start_of_day function
* add `cast_dates_as` constraint to `Ash.Type.DateTime`
# team-alembic/ash_authentication
## [v4.4.1](https://github.com/team-alembic/ash_authentication/compare/v4.4.0...v4.4.1) (2025-01-16)
### Bug Fixes:
* without phoenix, don't use verified routes
## [v4.4.0](https://github.com/team-alembic/ash_authentication/compare/v4.3.12...v4.4.0) (2025-01-16)
### Features:
* add email sender igniters for swoosh (#835)
### Bug Fixes:
* properly parse multiple authentication strategies
## [v4.3.12](https://github.com/team-alembic/ash_authentication/compare/v4.3.11...v4.3.12) (2025-01-14)
### Bug Fixes:
* Fixed a link in the docs and pinned `Assent` to `0.2` (#884)
## [v4.3.11](https://github.com/team-alembic/ash_authentication/compare/v4.3.10...v4.3.11) (2025-01-13)
### Bug Fixes:
* fix google strategy dependency was requiring options it should not
* fixed `:sign_in_with_token` that was logging in user automatically even if confirmation is required and account is not confirmed (#875)
* don't pass argv through to resource generator
* convert UID to string when setting (#870)
* Fix converting tenant to string (#868)
* wrong Enum.concat in validate_attribute_unique_constraint (#869)
### Improvements:
* Removed use of `Assent.Config` (#877)
# ash-project/ash_postgres
## [v2.4.22](https://github.com/ash-project/ash_postgres/compare/v2.4.21...v2.4.22) (2025-01-13)
### Bug Fixes:
* inner join bulk operations if distinct? is present
* fully specificy synthesized indices from multi-resource tables
# ash-project/ash_admin
## [v0.12.6](https://github.com/ash-project/ash_admin/compare/v0.12.5...v0.12.6) (2025-01-13)
### Bug Fixes:
* guard against problematic primary read action configurations (#255) (#256)
### Improvements:
* add installer
# ash-project/ash_double_entry
## [v1.0.9](https://github.com/ash-project/ash_double_entry/compare/v1.0.8...v1.0.9) (2025-01-13)
### Improvements:
* proper reference for section order config in installer
## [v1.0.8](https://github.com/ash-project/ash_double_entry/compare/v1.0.7...v1.0.8) (2025-01-13)
### Improvements:
* add igniter installer