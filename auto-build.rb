require 'readline'
require 'pty'
require 'open3'
require 'find'
require 'FileUtils'

first_time = true
@rake_command = "rake device"

Signal.trap('INT') do
  puts ''
  puts '============================'
  puts 'SIGINT has to be disable because sometimes repl/rerun sends it here. Yes I agree this is silly.'
  puts "run `kill -9 #{Process.pid}` or press enter to exit."
  puts '============================'
end

def delete_nosync_files
  Find.find('.')
      .find_all { |f| f =~ /dat/ && f =~ /nosync/ }
      .each do |f|
        begin
          FileUtils.rm(f)
        rescue
        end
      end
end

def validate_syntax! file
  results = `ruby -c repl.rb`
  if results =~ /Syntax OK/
    file = File.open(file, 'rb')
    contents = file.read
    file.close
    contents + "\n\n"
  else
    puts results
    nil
  end
end

Signal.trap('SIGUSR1') do
  if first_time
    first_time = false
  else
    if @repl
      monkey_file_contents = validate_syntax! 'monkey.rb'
      if monkey_file_contents
        if @previous_monkey_file_contents != monkey_file_contents
          @stdin.puts monkey_file_contents
          @previous_monkey_file_contents = monkey_file_contents
        end
      end

      repl_contents = validate_syntax! 'repl.rb'
      if repl_contents
        @stdin.puts repl_contents
      end
    else
      kill_repl_and_run_rake
    end
  end
end

def kill_repl_and_run_rake
  if `pgrep repl`.each_line.count == 0  && `pgrep \"#{@rake_command}\"`.each_line.count == 1
    puts "==========================================================================="
    puts "Currently deploying. Touch file after deployment completes to try again."
    puts "==========================================================================="
  else
    `pgrep repl`.each_line { |l| Process.kill('INT', l.to_i) }
    delete_nosync_files
    run_rake
  end
end

def ctrl_t
  system "osascript -e 'tell application \"System Events\"' -e 'keystroke \"t\" using control down' -e 'end tell'"
end

def run_rake
  PTY.spawn("#{@rake_command}") do |stdout, stdin, _|
    @stdin = stdin
    stdin.puts 'do_live_reload'
    Thread.new do
      loop do
        stdout.each do |line|
          print line
          if line =~ /Simulate/
            sleep 0.6
            ctrl_t
            sleep 0.4
            ctrl_t
          end
        end
        sleep 1
      end
    end
  end
end

PTY.spawn("rerun \"kill -30 #{Process.pid}\" --no-notify") do |stdout, _, _|
  Thread.new do
    loop do
      stdout.each { |line| print line if line !~ /Failed/ }
      sleep 1
    end
  end
end

run_rake

while expr = Readline.readline('', true)
  if expr == 'repl'
    if !@repl
      puts 'Repl mode enabled. The app will not be reloaded and repl.rb will be sent to RM instead.'
      @repl = true
    else
      @repl = false
      puts 'Repl mode disabled.'
      kill_repl_and_run_rake
    end
  elsif expr == 'exit'
    exit(0)
  elsif expr =~ /rake/
    @rake_command = expr
    kill_repl_and_run_rake
  else
    @stdin.puts expr
  end
  sleep 0.2
end
