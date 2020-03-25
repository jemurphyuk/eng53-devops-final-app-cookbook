# App Cookbook
The cookbook for a nodejs application provisions an instance to setup an the application, located in the ``recipes/default.rb`` file. The kitchencloud.yml completes this action on AWS cloud web server, kitchen.yml can be used for local.
The following environment variables are set in Jenkins, and need to be set locally to run locally

````
KITCHEN_YAML=kitchencloud.yml
````

### Unit/Integration testing using chefspec and inspec

To start the unit test, run the command

````
chef exec rspec spec
````
To start the integration test, run the command

````
kitchen test
````
A Jenkins job is capable of testing this cookbook by running the unit/int test commands, manually of using a webhook when a branch push is made
If these tests are successful, the build is merged and will trigger similar chef tests in the repository:

https://github.com/jemurphyuk/eng53-devops-final-db-cookbook

to ensure that the database will still funtion with the new application cookbook and tests. 
