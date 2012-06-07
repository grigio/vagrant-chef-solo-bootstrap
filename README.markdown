# About

This is our Chattin deployment chef config.

# Deploying

Run the following command (substitue `HOST` with a valid IP address or FQDN)

```
$ ./deploy.sh HOST
```

# Testing in Vagrant VM

Run the following command to download the requisite VM image and start
vagrant:

```
$ vagrant box add base http://files.vagrantup.com/precise32.box
$ vagrant up
```

Vagrant will automatically execute the chef recipes listed in `solo.json`. To
manually run the chef recipes:

```
$ vagrant provision
```
