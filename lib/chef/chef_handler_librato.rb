#
# Author:: Brian Scott <brainscott@gmail.com>
# Copyright:: Copyright (c) 2012, Brian Scott
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'rubygems'
Gem.clear_paths
require 'librato/metrics'
require 'chef'
require 'chef/handler'

class LibratoReporting < Chef::Handler
  attr_accessor :metric_type, :source, :email, :api_key

  def initialize(options = {})
    @source = options[:source] || "#{Chef::Config[:node_name]}"
    @email = options[:email] || 'test@test.com'
    @api_key = options[:api_key] || 'asdfg'
  end

  def report
    gemspec = if Gem::Specification.respond_to? :find_by_name
                Gem::Specification.find_by_name('chef-handler-librato')
              else
                Gem.source_index.find_name('chef-handler-librato').last
              end

    Chef::Log.debug("#{gemspec.full_name} loaded as a handler.")

    Librato::Metrics.authenticate "#{@email}", "#{@api_key}"

    metrics = {}
    metrics[:guage][:updated_resources] = run_status.updated_resources.length
    metrics[:guage][:all_resources] = run_status.all_resources.length
    metrics[:guage][:elapsed_time] = run_status.elapsed_time.to_i

    if run_status.success?
      metrics[:counter][:success] = 1
      metrics[:counter][:fail] = 0
    else
      metrics[:counter][:success] = 0
      metrics[:counter][:fail] = 1
    end

    metrics.each do |guage, data|
      data.each do |metric, value|
        Chef::Log.debug("#{metric} #{value} #{Time.now}")
        begin
          Librato::Metrics.submit :"#{metric}" => { type: :"#{guage}", value: "#{value}", source: "#{@source}" }
          rescue => e
            puts "#{e}"
        end
      end
    end
  end
end
