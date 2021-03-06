#
# Cookbook Name:: netsh_firewall
# Library:: netsh_firewall_helpers
#
# Copyright 2015 Biola University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module NetshFirewall
  # Helper methods for netsh_firewall cookbook
  module Helpers
    # Get an array of firewall rules that are enabled
    def parse_enabled_rules
      rules = []
      cmd = Mixlib::ShellOut.new('netsh advfirewall firewall show rule name=all')
      cmd.run_command
      cmd.stdout.split("\r\n\r\n").each do |r|
        rule = {}
        r.lines("\r\n") do |line|
          next if line.empty? || line =~ /^Ok/ || line =~ /^-/
          k, v = line.split(':')
          rule[k.chomp] = v.strip unless v.nil?
        end
        next if rule['Enabled'] == 'No'
        rules << rule
      end
      rules
    end
  end
end

Chef::Recipe.send(:include, ::NetshFirewall::Helpers)
