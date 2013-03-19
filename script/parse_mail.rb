#!/home/wchen/rails/BuddyBuildTracker/script/rails runner
##!/usr/bin/env /Users/wchen/github/BuddyBuildTracker/script/rails runner
## !/usr/bin/env ruby

require 'nokogiri'

Email.where(:status => 'unparsed').each do |e|
  (e.from + e.to + e.cc).uniq.each do |address|
    user = User.find_or_create_by_email(address)
    e.users << user
  end

  # clean up the raw_body and store it to body
  paragraphs = (Nokogiri(e.raw_body).xpath '//p').map { |p| p.content }
  inline_reply_result = paragraphs.map { |h| h =~ /From: .*?[\n\s]*Sent: .*?[\n\s]*To: .*?[\n\s]*Subject: .*?/m }
  inline_reply_index = inline_reply_result.index(0) || paragraphs.length
  
  e.body = paragraphs[0,inline_reply_index].join("\n").strip

  e.status = 'parse pending'
  e.save
  puts "#{e.subject} on #{e.date} changed from unparsed to ready"
end

# looking at parsed emails, is there a bug id associated with it?
Email.where(:status => 'parse pending').each do |e|
  # ideas on bug id
  #  look for the query table
  #  bug [id :] <number>
 
  # look for UNC and bug id
  tfs_id = e.subject.match /(\d{6})(\D|$)/
  bb_unc = e.body.match  /(\\\\[a-zA-Z0-9\\ -]*)/ # (\\[^:*?"<>|]*)

  # I'm going to assume if there's a tfs id and UNC path, it's probably from a dev
  if tfs_id && bb_unc
    tfs_id = tfs_id[1].to_i
    bb_unc = bb_unc[1]

    e.bug = Bug.find_or_create_by_tfs_id(:tfs_id => tfs_id) do |b|
      b.drop_folder = bb_unc
      b.status      = 'unknown'
      b.requestor   = User.find :email => e.from.first
      b.tester      = User.find :email => e.to.first

      b.requestor   ||= User.find_or_create_by_name('unassigned')
      b.tester      ||= User.find_or_create_by_name('unassigned')
    end
    e.status = 'parsed'
    e.save
    puts "#{e.subject} on #{e.date} changed from ready to parsed"
  end
end

Bug.where(:status => 'hand off').each do |e|
end

Bug.where(:status => 'hand back').each do |e|
end

Bug.where(:status => 'signed off').each do |e|
end
