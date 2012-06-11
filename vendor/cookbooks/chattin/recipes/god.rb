gem_package "god" do
  action :install
end

remote_directory "/usr/local/god" do
  source "god"
  files_owner "root"
  files_group "root"
  files_mode  "0644"
  owner "root"
  group "root"
  mode  "0755"
end

cookbook_file "/etc/init/god.conf" do
  source "god.conf"
end
