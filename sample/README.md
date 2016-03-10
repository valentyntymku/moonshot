# Moonshot Sample Application

A small PHP application that is used to demo the
[Moonshot](https://github.com/acquia/moonshot) deployment tool.

## So, what's in it for me?

After setup, you will be able to repeatedly deploy a PHP app to one or more
isolated environments on AWS by running the following command:

```
bundle exec bin/environment deploy-code
```

You will also be able to update the OS and supporting software by pulling the
latest changes in this repository and updating the stack with following command:

```
bundle exec bin/environment update
```

Lastly, you get a disposable, light-weight application that can be used to learn
and hack on Moonshot without having to muck with applications that actually
matter.

## Setup

1. Create a service role for Code Deploy in your AWS account.

    Run the commands in the [Configuring an AWS account](https://github.com/acquia/moonshot#codedeploy-role)
    section of Moonshot's README. If you wish to do this manually, follow the
    [Create a Service Role for AWS CodeDeploy](http://docs.aws.amazon.com/codedeploy/latest/userguide/how-to-create-service-role.html)
    documentation, and make sure to name the role `CodeDeployRole` as that is
    what Moonshot expects.

2. Install Moonshot and it's dependencies.

    This step assumes that you have [Bundler](http://bundler.io/) and a modern
    version of Ruby installed on your system.

    ```shell
    bundle install
    ```

3. Run the setup script to create a provisioning script, a parameters file for
   your default environment, and a default `index.php` file. Change
   `[S3_BUCKET]` to an S3 bucket you can write to, e.g. `my-s3-bucket`.

    ```shell
    ./bin/setup.sh [S3-BUCKET]
    ```

4. [OPTIONAL] Modify `./docroot/index.php` accordingly.

    By default, a simple phpinfo() page is displayed.

## Usage

Run the following commands to create your environment and deploy code to it.
Note that you will likely have to set the `AWS_REGION` environment variable
prior to running these commands.

```
bundle exec bin/environment create
bundle exec bin/environment deploy-code
```

Visit the AWS console, view your Cloud Formation stack, and click on the link in
the "URL" key's value in the "Outputs" tab to view your app.

Tear down your stack by running the following command:

```
bundle exec bin/environment delete
```

See https://github.com/acquia/moonshot#basic-usage for more advanced
usage of Moonshot.
