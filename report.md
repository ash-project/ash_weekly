# ash-project/ash

)




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