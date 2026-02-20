#!/usr/bin/env ruby

require 'json/ext'
require 'csv'

def log(text, **args)
  $stdout.puts({text: text.chomp}.merge(**args).to_json)
  $stdout.flush
end

focuslock_project = ARGV.first
unless focuslock_project
  log("Args: todoist-focuslock #SomeTodoistProject")
  exit
end

def log_todoist(project)
  tasks = CSV.parse(`todoist-cli --header --csv list --priority --filter '#MindfulChef & today'`, headers: true)
  current_task = tasks.first['Content']
  return log("No current task") unless current_task

  next_tasks = tasks.first(5).map{|r| r['Content']}.map(&:chomp).join(' | ')
  log(current_task, tooltip: next_tasks.inspect)
end

while true do
  log_todoist(focuslock_project)
  sleep 10
end
