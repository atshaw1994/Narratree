#!/usr/bin/env ruby

require 'open3'

puts "Running tests...\n\n"

passed_tests = 0
failed_tests = 0

commands = [
  "bin/brakeman --no-pager",
  "bin/importmap audit",
  "bin/rubocop -f github",
  "bin/rails db:test:prepare test test:system"
]

commands.each do |cmd|
  puts "--> Running: #{cmd}"
  stdout, stderr, status = Open3.capture3(cmd)

  if status.success?
    puts "✅ Passed"
    passed_tests += 1
  else
    puts "❌ Failed"
    puts stdout # This is the key change: show both
    puts stderr
    failed_tests += 1
  end

  puts "\n"
end

total_tests = passed_tests + failed_tests

if failed_tests == 0
  puts "#{total_tests} tests passed!"
else
  puts "#{passed_tests} test(s) passed, #{failed_tests} failed!"
end

exit failed_tests