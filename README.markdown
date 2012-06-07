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

Run the following command (substitute `user@example.com`):

```
$ ./deploy.sh user@example.com
```

On the first run, this will fully upgrade the server and then install ruby and
chef.

To test the deploy script against the Vagrant VM, use `./deploy.sh
vagrant`.

# Testing in Vagrant VM

Run the following command to download the requisite VM image and start
vagrant:

```
$ vagrant box add base http://files.vagrantup.com/precise32.box
$ vagrant up
```

Vagrant will automatically execute the chef recipes listed in `solo.json` each
time you run `vagrant up`. To manually run the chef recipes while the VM
is still running:

```
$ vagrant provision
```
