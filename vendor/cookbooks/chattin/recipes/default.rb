execute "apt-get update" do
  user 'root'
end

# Ruby-ish deps
%w[
  build-essential  openssl
  libreadline6     libreadline6-dev
  curl             git-core
  zlib1g           zlib1g-dev
  libssl-dev       libyaml-dev
  libsqlite3-dev   sqlite3
  libxml2-dev      libxslt-dev
  autoconf         libc6-dev
  ncurses-dev      automake
  libtool          bison
  subversion       libmysqlclient-dev
  libpq-dev        wget
  nodejs
].each do |pkg|
  package pkg do
    action :install
  end
end

# Dev deps
%w[
  vim-nox
].each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file "/etc/profile.d/env.rb" do
  source "env.rb"
  mode 0755
end

cookbook_file "/etc/profile.d/env.sh" do
  source "env.sh"
  mode 0755
end

gem_package "bundler" do
  action :install
end

package "nginx" do
  action :install
end

cookbook_file "/etc/nginx/nginx.conf" do
  source "nginx.conf"
end

# To create a shadow password, see:
#   http://stackoverflow.com/questions/9043017/
#   http://stackoverflow.com/questions/5171487/
user "deployer" do
  comment  "The web/deployment user."
  shell    "/bin/bash"
  supports :manage_home => true
end

# Manage SSH keys
ruby_block "public_keys" do
  block do
    require 'shellwords'
    users = ["root", "deployer"]
    cmds = []
    users.map do |user|
      cmds << "mkdir -p ~#{user}/.ssh"
      node["chattin"]["public_keys"].each do |key|
        cmds << "grep #{key.shellescape} ~#{user}/.ssh/authorized_keys || " +
          "echo #{key.shellescape} >> ~#{user}/.ssh/authorized_keys"
      end
      cmds << "chown -R #{user}:#{user} ~#{user}"
      Chef::ShellOut.new(cmds.join("\n")).run_command
    end
  end
end

file "/etc/profile.d/jdk.sh" do
  content <<-EOS
    export JAVA_HOME=#{node['java']["java_home"]}
  EOS
  mode 0755
end
