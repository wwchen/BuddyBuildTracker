#!/home/wchen/rails/BuddyBuildTracker/script/rails runner
##!/usr/bin/env /Users/wchen/github/BuddyBuildTracker/script/rails runner

Email.where(:status => 'complete').each do |e|
  e.users = e.users.clear
  e.body = ''
  e.status = 'parsed'

  e.save!
end
