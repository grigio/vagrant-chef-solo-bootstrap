# vim:filetype=ruby

app_root = "/usr/local/red5"

God.watch do |w|
  w.name  = "red5"
  w.keepalive

  w.env = {
    'JAVA_HOME' => '/usr/lib/jvm/default-java'
  }
  w.start = "cd #{app_root} && ./red5.sh start"
end
