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
