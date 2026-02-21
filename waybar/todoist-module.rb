#!/usr/bin/env ruby

require 'json/ext'
require 'csv'
require 'cgi'

def pango_escape(hash)
  hash.transform_values { |v| CGI.escapeHTML(v) }
end

def print_json(hash)
  $stdout.puts(hash.to_json)
  $stdout.flush
end

def log(text, **args)
  print_json(pango_escape({text: text.chomp}.merge(args)))
end

focuslock_project = ARGV.first
unless focuslock_project
  log("Args: todoist-focuslock #SomeTodoistProject")
  exit
end

def log_todoist(project)
  tasks = CSV.parse(`todoist-cli --header --csv list --priority --filter '#Chief & /Focus'`, headers: true)
  current_task = tasks.first&.[]('Content')
  return log("No current task") unless current_task

  next_tasks = tasks.first(5).map{|r| r['Content']}.map(&:chomp).join(' | ')
  log(current_task, tooltip: next_tasks.inspect)
end

while true do
  log_todoist(focuslock_project)
  sleep 10
end
