# vim:filetype=ruby

rails_root = File.expand_path("~deployer/apps/soapbox-faye")

God.watch do |w|
  w.name  = "faye"
  w.keepalive

  w.env = {
    'RACK_ENV' => 'production'
  }
  w.start = <<-CMD
    #{rails_root}/faye.sh start \
      1> #{rails_root}/log/start.stdout.log \
      2> #{rails_root}/log/start.stderr.log
  CMD

  w.stop = <<-CMD
    #{rails_root}/faye.sh stop
  CMD

  w.pid_file = "#{rails_root}/tmp/pids/faye.pid"
  w.behavior(:clean_pid_file)

  if `whoami`.chomp == "root"
    w.uid = 'deployer'
    w.gid = 'deployer'
  end
end
