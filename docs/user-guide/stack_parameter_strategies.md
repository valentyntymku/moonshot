# Stack Parameter strategies

Currently used, valid strategy types are:
- `default`
- `merge`

Strategy type can be set both via command line, or overriding
the default behaviour in your `Moonshot::CLI` subclass.

**Command line:** `bin/environment update --parameter-strategy=merge`

**Inline:** `parameter_strategy :merge`

Accepted both as a string or a symbol.

Setting precedence is the following:
- command line option
- inline default behaviour override
- falling back to `default`

## Default strategy

Default strategy is the legacy behaviour, works exactly as previously,
prior to introducing different strategies. Each parameter is loaded from the
parameter file (eg. `cloud_formation/parameters/environment-name.yml`),
and *all of them* are overridden on update.

## Merge strategy

Merge strategy is a new way of dealing with stack parameters on stack update.
You only have to declare **parameters you want to update** in your parameter file,
the remaining parameters are not updated, meaning it stays as it's current uploaded (live) state.
This behaviour is achived by using CloudFormation's `UsePreviousValue` feature.
This way you can avoid accidentally reverting parameter values with your outdated local
parameter file.
