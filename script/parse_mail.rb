#!/usr/bin/env /Users/wchen/github/BuddyBuildTracker/script/rails runner
## !/home/wchen/rails/BuddyBuildTracker/script/rails runner
## !/usr/bin/env ruby

require 'nokogiri'

Email.where(:status => 'unparsed').each do |e|
  (e.from + e.to + e.cc).uniq.each do |address|
    user = User.find_or_create_by_email(address)
    e.users << user
  end
  
#  paragraphs = []
#  (Nokogiri(e.raw_body).xpath '//p').each do |p|
#    paragraphs << p.content
#  end

  paragraphs = (Nokogiri(e.raw_body).xpath '//p').map { |p| p.content }
  #p.map { |h| h =~ /(From|To|Subject|Sent): .*/ }
  inline_reply_result = paragraphs.map { |h| h =~ /From: .*?Sent: .*?To: .*?Subject: .*?/m }
  inline_reply_index = inline_reply_result.index(0) || paragraphs.length
  
  e.body = paragraphs[0,inline_reply_index].join("\n").strip
  e.status = 'parsed'

  e.save
  "Parsed mail #{e.subject} on #{e.date}"
end
