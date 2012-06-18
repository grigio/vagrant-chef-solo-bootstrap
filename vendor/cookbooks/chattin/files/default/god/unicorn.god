# vim:filetype=ruby

# Settings
# ========
require 'yaml'
env = YAML.load_file("/etc/profile.d/env.yaml") rescue {}
env.merge(ENV.to_hash)
env['RACK_ENV'] ||= 'production'


apps = [
  'chattin-frontend',
  'chattin-presentations',
  'chattin-comments',
  'chattin-users',
]

apps.each do |app_name|
  rails_root = File.expand_path("~deployer/apps/#{app_name}")

  God.watch do |w|
    w.name  = "unicorn-#{app_name}"
    w.group  = "unicorns"
    w.interval = 30.seconds

    w.env = env

    # NOTE: unicorn needs to be run from the rails root!
    w.start = <<-CMD
      #{rails_root}/start-unicorn \
        1> #{rails_root}/log/start-unicorn.stdout \
        2> #{rails_root}/log/start-unicorn.stderr
    CMD

    w.stop = "kill -KILL `cat #{rails_root}/tmp/pids/unicorn.pid`"

    # USR2 causes the master to re-create itself and spawn a new worker pool
    w.restart = "kill -USR2 `cat #{rails_root}/tmp/pids/unicorn.pid`"

    w.start_grace = 10.seconds
    w.restart_grace = 10.seconds
    w.pid_file = "#{rails_root}/tmp/pids/unicorn.pid"

    if `whoami`.chomp == "root"
      w.uid = 'deployer'
      w.gid = 'deployer'
    end

    w.behavior(:clean_pid_file)

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end

    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 300.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end

      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
      end
    end

    # lifecycle
    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
      end
    end
  end
end
