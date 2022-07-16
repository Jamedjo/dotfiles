#!/usr/bin/env ruby

require 'json/ext'

def log(text, **args)
  $stdout.puts({text: text.chomp}.merge(**args).to_json)
  $stdout.flush
end

focuslock_file = ARGV.first
unless focuslock_file
  log("Args: focuslock /path/to/focus.txt")
  exit
end

def log_focuslock(file)
  return log("No file #{file}") unless File.file?(file)

  tasks = File.open(file) {|f| f.first(5).map(&:chomp).reject(&:empty?) }
  current_task = tasks.first
  return log("No current task") unless current_task

  next_tasks = tasks.join(' | ')
  log(current_task, tooltip: next_tasks.inspect)
end

while true do
  log_focuslock(focuslock_file)
  sleep 1
end
