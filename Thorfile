# encoding: utf-8
require 'shellwords'

class Default < Thor

  desc "sync", "copy the apps in /vagrant/apps into ~deployer/apps"
  def sync
    puts remote_bash "vagrant@vagrant", <<-CODE
      shopt -s nullglob

      sudo god stop unicorns
      sleep 1
      sudo stop god

      sudo mkdir -p ~deployer/apps/
      for app in /vagrant/apps/* ; do
        app=`basename $app`
        sudo cp -af /vagrant/apps/$app ~deployer/apps/
      done
      sudo chown -R deployer:deployer ~deployer/apps

      sudo start god
      sudo /etc/init.d/nginx restart
    CODE

    puts remote_bash "deployer@vagrant", <<-CODE
      rvm_trust_rvmrcs_flag=1
      if [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
        source "/usr/local/rvm/scripts/rvm"
      fi

      shopt -s nullglob

      for app in ~deployer/apps/* ; do
        cd $app
        bundle install --deployment --binstubs
        RACK_ENV=production bundle exec rake db:migrate
      done
    CODE
  end

  desc "restart", "restart nginx & unicorn"
  def restart
    puts remote_bash "vagrant@vagrant", <<-CODE
      shopt -s nullglob

      sudo god stop unicorns
      sleep 1
      sudo stop god
      sudo start god
      sudo /etc/init.d/nginx restart
    CODE
  end

  desc "ssh HOST", "connect via ssh"
  def ssh(host)
    exec ssh_code(host)
  end

  private

  def remote_bash(host, commands)
    `#{ssh_code(host, commands)} 2>&1`
  end

  def remote_ruby(host, commands)
    remote_bash(host, "ruby -e #{commands.shellescape}")
  end

  def ssh_code(host, commands=nil)
    user, host = host.split('@')
    port="22"
    if host == "vagrant"
      host="#{user}@127.0.0.1"
      port="2222"
      key_opt="-i '#{ENV['HOME']}/.vagrant.d/insecure_private_key'"

      # The host key might change when we instantiate a new VM, so
      # we remove (-R) the old host key from known_hosts
      `ssh-keygen -R "#{host.split('.*@')[-1]}" 2> /dev/null`
    end

    %Q(ssh -p "#{port}" -o 'StrictHostKeyChecking no' #{key_opt} "#{host}" #{commands && commands.shellescape})
  end

end
