#!/usr/bin/env /Users/wchen/github/BuddyBuildTracker/script/rails runner

Email.where(:status => 'parsed').each do |e|
  e.users = e.users.clear
  e.body = ''
  e.status = 'unparsed'

  e.save!
end
