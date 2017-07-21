# Supported tags and respective `Dockerfile` links

- [`1.0.0` (*1.0.0/Dockerfile*)](https://github.com/gomoob/docker-jenkins-jnlp-slave-php/blob/master/1.0.0/Dockerfile)

# What is jenkins-jnlp-slave-php ?

[gomoob/jenkins-jnlp-slave-php](https://github.com/gomoob/docker-jenkins-jnlp-slave-php "gomoob/jenkins-jnlp-slave-php")
is a Docker Jenkins slave image using JNLP to establish connection and providing PHP build tools.

The container is based on the official Jenkins [jenkinsci/jnlp-slave](https://hub.docker.com/r/jenkinsci/jnlp-slave "jenkinsci/jnlp-slave")
Docker slave container and adds several additional tools to build PHP projects.

The following tools can be called under the Jenkins slave.

* `php-7.1.7` or `php-7.1` or `php` to execute PHP 7.1.x with Xdebug enabled ;
* `php-without-xdebug-7.1.7` or `php-without-xdebug-7.1` or `php-without-xdebug` to execute PHP 7.1.x without Xdebug
  enabled ;
* `php-7.0.21` or `php-7.0` to execute PHP 7.0.x with Xdebug enabled ;
* `php-without-xdebug-7.0.21` or `php-without-xdebug-7.0` to execute PHP 7.0.x without Xdebug enabled ;
* `phpunit` ;
* `composer` (based on [prestissimo](https://github.com/hirak/prestissimo "prestissimo") ;
* `phpmd` ;
* `sami` ;
* `phpcov` ;
* `phpcpd` ;
* `phploc` ;
* `box`.

Each version of PHP available is compiled with the following extensions.

`bcmath`, `bz2`, `calendar`, `cli`, `ctype`, `dom`, `fileinfo`, `filter`, `ipc`, `json`, `mbregex`, `mbstring`, `mhash`,
`mcrypt`, `pcntl`, `pcre`, `pdo`, `phar`, `posix`, `readline`, `sockets`, `tokenizer`, `xml`, `curl`, `openssl`, `zip`,
`sqlite`, `mysql`, `pgsql`, `gd`

In addition the following extensions are also installed with each PHP executable.

`apcu`, `apcu_bc`, `mongodb`, `xdebug`

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

# Configuration specifics

## Enabled JNLP protocols

By default, the [JNLP3-connect](https://github.com/jenkinsci/remoting/blob/master/docs/protocols.md#jnlp3-connect "JNLP3-connect")
is disabled due to the known stability and scalability issues.

You can enable this protocol on your own risk using the
`JNLP_PROTOCOL_OPTS=-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false` property (the protocol should be
enabled on the master side as well).

In Jenkins versions starting from `2.27` there is a
[JNLP4-connect](https://github.com/jenkinsci/remoting/blob/master/docs/protocols.md#jnlp4-connect "JNLP4-connect")
protocol.

If you use Jenkins `2.32.x LTS`, it is recommended to enable the protocol on your instance.

## Amazon ECS

Make sure your ECS container agent is
[updated](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-update.html "updated") before running.
Older versions do not properly handle the
[entryPoint](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definitions "entryPoint")
parameter. See the entryPoint definition for more information.

# About Gomoob

At [Gomoob](https://www.gomoob.com) we build high quality software with awesome Open Source frameworks everyday. Would
you like to start your next project with us? That's great! Give us a call or send us an email and we will get back to
you as soon as possible !

You can contact us by email at [contact@gomoob.com](mailto:contact@gomoob.com) or by phone number
[(+33) 6 85 12 81 26](tel:+33685128126) or [(+33) 6 28 35 04 49](tel:+33685128126).

Visit also http://gomoob.github.io to discover more Open Source softwares we develop.
