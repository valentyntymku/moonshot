# CLI Commands

## List

List stacks for this application.

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Parent stack to import parameters from|--parent|-p|string|moonshot-database-sample-app|None|
|Choose if code should be deployed after stack is created|deploy|d|boolean||true|
|Show all stack events during update. When present, it will show all events|show_all_events||boolean||Errors only|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|


Example:
```shell
./bin/environment list
```

Output:

```shell
```

## Create
Create a new environment.

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Parent stack to import parameters from|parent|p|string|moonshot-database-sample-app|None|
|Choose if code should be deployed after stack is created|deploy|d|boolean||true|
|Show all stack events during update. When present, it will show all events|show_all_events||boolean||Errors only|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|

Example:

```shell
./bin/environment create --name my-service-staging --verbose
```

Output:

```shell
```


## Update

Update the CloudFormation stack within an environment.

@todo: Add more description here as to what it exactly does.

Options:

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Parent stack to import parameters from|--parent|-p|string|moonshot-database-sample-app|None|
|Show all stack events during update. When present, it will show all events|show_all_events||boolean||Errors only|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|

Example:

```shell
./bin/environment create --name my-service-staging --verbose
```

Output:

```shell
```

## Status

Get the status of an existing environment.

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|

Example:

```shell
./bin/environment create --name my-service-staging --verbose
```

Output:

```shell
```


## Deploy Code

Create a build from the working directory, and deploy it.

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|

Example:

```shell
./bin/environment create --name my-service-staging --verbose
```

Output:

```shell
```

## Build Version

Build a tarball of the software, ready for deployment.
Requires a version name parameter.

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|

Example:

```shell
./bin/environment create --name my-service-staging --verbose
```

Output:

```shell
```

## Deploy Version

Deploy a versioned release to both Elastic Beanstalk environments in an environment.
Requires a version name parameter.

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|

Example:

```shell
./bin/environment create --name my-service-staging --verbose
```

Output:

```shell
```

## Delete

Delete an existing environment.

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Show all stack events during update. When present, it will show all events|show_all_events||boolean||Errors only|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|

Example:

```shell
./bin/environment create --name my-service-staging --verbose
```

Output:

```shell
```

## Doctor
Run configuration checks against current environment. Throws an error if one or more checks failed.
For example, if you are using a deployment_mechanism that is using S3, it will check if the bucket actually exists and that you have access to. Each mechanism is able to add checks themselves that will be recognized and run.

|Description|Long Form|Short Form|Type|Example|Default|
|---|---|---|---|---|---|
|Environment Name|name|n|string|moonshot-sample-app|None|
|Interactive Logger|interactive_logger||boolean||true|
|Verbose|verbose|v|boolean||false|

Example:

```shell
./bin/environment create --name my-service-staging --verbose
```

Output:

```shell
```
