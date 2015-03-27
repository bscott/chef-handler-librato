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
require 'date'
Gem.clear_paths
require 'librato/metrics'
require 'chef'
require 'chef/handler'

class LibratoReporting < Chef::Handler
  attr_accessor :source, :email, :api_key

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
    metrics[:gauge] = {}
    metrics[:counter] = {}
    metrics[:gauge][:updated_resources] = run_status.updated_resources.length
    metrics[:gauge][:all_resources] = run_status.all_resources.length
    metrics[:gauge][:elapsed_time] = run_status.elapsed_time.to_i

    annotations = {}
    annotations[:start_time] = DateTime.parse(run_status.start_time.to_s).strftime('%s')
    annotations[:end_time] = DateTime.parse(run_status.end_time.to_s).strftime('%s')

    if run_status.success?
      metrics[:counter][:success] = 1
      metrics[:counter][:fail] = 0
    else
      metrics[:counter][:success] = 0
      metrics[:counter][:fail] = 1
    end

    metrics.each do |metric_type, data|
      data.each do |metric, value|
        Chef::Log.debug("#{metric} #{value} #{Time.now}")
        begin
        Librato::Metrics.submit :"chef.#{metric}" => {:type => :"#{metric_type}", :value => "#{value}", :source => "#{@source}" }
        rescue Exception => e
          puts "#{e}"
        end
      end
    end

    Chef::Log.debug("Librato annotation chef.converge at #{annotations[:start_time]} - #{annotations[:end_time]}")
    Librato::Metrics.annotate :"chef.converge", "Chef converge on #{@source}", :source => @source, :start_time => annotations[:start_time], :end_time => annotations[:end_time]

  end
end

