# Stack Parameter overrides

One of the challenges we faced using CloudFormation was being consistent about
setting stack parameters as you make requests. We settled on a strategy that
keeps all per-environment tunings in the source repository acting as both a
safety net and documentation of existing environments. Here's how it works:

When a stack update is performed, a *parameter overrides file* is checked in
`cloud_formation/parameters/environment-name.yml`. This file is YAML formatted
and takes a hash of stack parameter names and values, for example:
```yaml
---
AsgDesiredCap: 12
AsgMaxCap: 15
ELBCertificate: iam::something:star_example_com
```

If a file exists, it's used every time a CloudFormation change request is sent,
so no configuration can revert back to defaults through this tool. It's highly
recommended that you add these files back to source control as soon as possible
and be in the habit of pulling latest changes before applying any infrastructure
updates.