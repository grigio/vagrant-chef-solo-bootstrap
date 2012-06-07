# About

This is our Chattin deployment chef config.

# Initial Configuration

The required cookbooks are bundled via the `librarian` gem. Install
`librarian` and run `librarian-chef install`:

```
$ gem install librarian
$ librarian-chef install
```

Our own custom recipes are located under `./vendor` and copied into
`./cookbooks`. Don't make changes in `./cookbooks` - they'll be lost
when you run `librarian-chef install`!!!

# Deploying

Run the following command (substitute `HOST` with a valid IP address or FQDN)

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
