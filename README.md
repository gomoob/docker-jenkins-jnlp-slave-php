# Supported tags and respective `Dockerfile` links

- [`1.0.0` (*1.0.0/Dockerfile*)](https://github.com/gomoob/docker-jenkins-jnlp-slave-php/blob/master/1.0.0/Dockerfile)

# What is jenkins-jnlp-slave-php ?

[gomoob/jenkins-jnlp-slave-php](https://github.com/gomoob/docker-jenkins-jnlp-slave-php "gomoob/jenkins-jnlp-slave-php")
is a Docker Jenkins slave image using JNLP to establish connection and providing PHP build tools

The container is based on the official Jenkins [jenkinsci/jnlp-slave](https://hub.docker.com/r/jenkinsci/jnlp-slave "jenkinsci/jnlp-slave")
Docker slave container and adds several additional tools to build PHP projects.

The following tools can be calls under the Jenkins slave.

* `php-7.0.21` or simply `php-7.0` to execute PHP 7.0.x ;
* `php-7.1.7` or simply `php-7.1` to execute PHP 7.1.x ;
* `phpunit` ;
* `composer` (based on [prestissimo](https://github.com/hirak/prestissimo "prestissimo") ;
* `phpmd` ;
* `sami` ;
* `phpcov` ;
* `phpcpd` ;
* `phploc` ;
* `box`.

# How to use this image.

## Run with command line

```console
$ docker run --name jenkins-jnlp-slave-php gomoob/jenkins-slave-php -url http://jenkins-server:port <secret> <agent name>
```

## Optional environment variables

* `JENKINS_URL` : url for the Jenkins server, can be used as a replacement to -url option, or to set alternate jenkins
  URL ;
* `JENKINS_TUNNEL`: (HOST:PORT) connect to this agent host and port instead of Jenkins server, assuming this one do
  route TCP traffic to Jenkins master. Useful when when Jenkins runs behind a load balancer, reverse proxy, etc ;
* `JENKINS_SECRET` : agent secret, if not set as an argument ;
* `JENKINS_AGENT_NAME` : agent name, if not set as an argument.

# About Gomoob

At [Gomoob](https://www.gomoob.com) we build high quality software with awesome Open Source frameworks everyday. Would
you like to start your next project with us? That's great! Give us a call or send us an email and we will get back to
you as soon as possible !

You can contact us by email at [contact@gomoob.com](mailto:contact@gomoob.com) or by phone number
[(+33) 6 85 12 81 26](tel:+33685128126) or [(+33) 6 28 35 04 49](tel:+33685128126).

Visit also http://gomoob.github.io to discover more Open Source softwares we develop.
