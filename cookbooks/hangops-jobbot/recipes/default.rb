#
# Copyright 2017, Don O'Neill (sntxrr+github@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'git::default'

# Create a robots group
group 'robots' do
  action :create
  notifies :create, 'user[hubot]', :immediately
end

# Create a hubot user
user 'hubot' do
  action :create # default action
  non_unique false
  group 'robots'
end

# Create user sntxrr so test kitchen doesn't fail
user 'sntxrr' do
  action :create
  non_unique false
end

# Clone the source code from GitHub.
git '/srv/hangops-jobbot' do
  repository 'https://github.com/rrxtns/hangops-jobbot.git'
  action :checkout
end

# Install nodejs and hubot dependencies
include_recipe 'hangops-jobbot::nodejs'

# Install Runit
include_recipe 'runit::default'

# Install Redis
include_recipe 'redis::install_from_package'

# TODO: need to get a databag going with encrypted values
#       for the Slack API etc.

# Do some more stuff, then notify hubot to start
