#!/usr/bin/env ruby

# This script tests the greeting message in the SoSpeed application
puts "Testing SoSpeed greeting message..."
puts "Running the application with level 1 and mode 1..."
puts "Please check that 'こんにちわ' appears in the introduction screen."
puts "Press Ctrl+C to exit the application after verifying."
puts

# Run the application with level 1 and mode 1
system("ruby bin/sospeed --level 1 --mode 1")