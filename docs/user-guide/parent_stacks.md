## Parent Stacks

Moonshot supports referencing another CloudFormation stack as a
"Parent" during creation time. This relationship is used only for creation,
where any outputs of that stack that match names of the parameters for the local
stack will be used as parameters, and saved into a local .yml file for future
use.

The order of precedence for parameters is:
- Existing parameter overrides in the .yml file.
- The value from the parent stack's output.
- Any default value in the CloudFormation template.

### A word of caution

It's not advisable to use default values in the CloudFormation template.
Consider the following example:

- Developer A launches a stack, referencing a specific parent stack.
- Values are copied into a local .yml file, and used during stack creation.
- Developer B assists Developer A with a stack update issue and runs 'update'
  without the local overrides .yml file. In doing so, the default values in the
  template are used.
- Developer A is sad.
