chef-handler-librato
Author - Brian Scott (b@bscott.me)
====================

Chef Handler to send metrics to Librato metrics

Description

This is a simple Chef report handler that reports status of a Chef run through librato.

    http://wiki.opscode.com/display/chef/Exception+and+Report+Handlers

Requirements

Platform: All Platforms


There are two ways to use Chef Handlers.
Method 1

You can install the RubyGem ahead of time, and configure Chef to use them. To do so:

gem install chef-handler-librato

Then add to the configuration (/etc/chef/solo.rb for chef-solo or /etc/chef/client.rb for chef-client):

require "chef-handler-librato"

# Configure the handler
librato_handler = LibratoReporting.new

# metric_type is a string that sets the Metrics type in Librato, defaults to counter
librato_handler.metric_type = "counter"

# Hostname and port of your Graphite server
librato_handler.email = "user@domain.com"
librato_handler.api_key = "667hhff544300096423345"

# Add your handler
report_handlers << librato_handler
exception_handlers << librato_handler

Method 2

Use the chef_handler cookbook by Opscode. Create a recipe with the following:

# Install the `chef-handler-librato` RubyGem during the compile phase
gem_package "chef-handler-librato" do
  action :nothing
end.run_action(:install)

or 

chef_gem "chef-handler-librato" # This workd with Chef-0.10.10 or higher

# Then activate the handler with the `chef_handler` LWRP
argument_array = [
    :metric_type => "counter",
    :email => "user@domain.com",
    :api_key => "c544637891cf5498f9efac33257689rtt57777894"
]

chef_handler "LibratoReporting" do
  source "#{File.join(Gem.all_load_paths.grep(/chef-handler-librato/).first,'chef', 'chef_handler_librato.rb')}"
  arguments argument_array
  action :nothing
end.run_action(:enable)


Patches welcome, just send me a pull request!


