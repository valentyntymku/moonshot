# Custom Commands

One powerful feature of Moonshot is the ability to add custom
project-specific commands. You can hook into many of the features
provided by the `Moonshot::Controller` and `Moonshot::Stack`
interface, and make native calls to AWS using the AWS SDK for Ruby
v2.

To do this, place a file in `moonshot/cli_extensions/my_command.rb`
that extends `Moonshot::Command` (or `Moonshot::SSHCommand`, if you
want to use the Moonshot SSH interface).

## Example

```ruby
# moonshot/cli_extensions/get_elb_address.rb
class GetElbAddress < Moonshot::Command
  self.description = 'Display the ELBs external hostname.'
  self.usage       = 'get-elb-address'

  def execute
    puts controller.stack.outputs['APIElasticLoadBalancerDNS']
  end
end
```

## Account Restrictions

If you have a development- or production-only command you want
restricted to running in appropriately labelled accounts, you can use
the `only_in_account` option. This can be either a single string, or
an array of strings. For example:

```ruby
# moonshot/cli_extensions/drop_database.rb
class DropDatabase < Moonshot::Command
  self.description     = 'Delete all the data (development only!)'
  self.usage           = 'drop-database'
  self.only_in_account = 'company-dev'

  def execute
    # ...
  end
end
```

If the IAM account alias for the current AWS account does not exactly
match, the user will receive an error:

```
'drop-database' can only be run in the following accounts:
- company-dev
```
