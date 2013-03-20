#!/home/wchen/rails/BuddyBuildTracker/script/rails runner
##!/usr/bin/env /Users/wchen/github/BuddyBuildTracker/script/rails runner
## !/usr/bin/env ruby

require 'nokogiri'

def associate_email_to_users(email, addresses)
  addresses.flatten.uniq.each do |addr|
    u = User.find_or_create_by_email(addr)
    u.emails << email
    u.emails.uniq!
    u.save
  end
end

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

  e.status = 'parsed'
  e.save
  puts "#{e.subject} on #{e.date} changed from unparsed to #{e.status}"
end

# Determining the intention of this email.. the hardest part
Email.where(:status => 'parsed').each do |e|
  confidence = 0.5
  # Case 1: A tester signing off on the buddy build
  # Case 2: A developer requesting a buddy build test
  # Case 3: Comments from either party

  # normalize the subject string
  normalized_subject = e.subject.gsub(/(RE|FW[D]): /i, '').strip

  # find all related emails
  #email_thread = Email.all.select {|ea| ea.subject =~ Regexp.new "/^((RE|FW[D]): )*#{normalized_subject}$", 'i' }
  email_thread = Email.where "subject LIKE '%#{normalized_subject}'"

  next
  # TODO confidence is full of crap
  #
  # look for UNC and bug number
  tfs_id = (e.subject+e.body).match /(\d{6})(\D|$)/
  tfs_id = tfs_id[1].to_i unless tfs.id.nil?
  bb_unc = e.body.match  /(\\\\[a-zA-Z0-9\\ -]*)/ # (\\[^:*?"<>|]*)

  confidence *= tfs_id.between?(500000,700000) ? 2 : 0.5

  # look at associated bugs on the thread.. are they the same number?
  email_thread.each do |et|
    if et.bug
      confidence *= et.bug.tfs_id == tfs_id ? 2 : 0.5
    end
  end


  sender = User.find_by_email(e.from.first)

  # Case 1: A tester signing off on the buddy build (the easiest scenario)
  # There should already be a thread that is going on, so we'll check for that
  if  (not email_thread.length.zero?) and
      sender.role == 'tester' and
      e.body.match(/(sign(ing|ed|) off|look(s|ing|) good)/i)
    puts "##{e.id} #{sender.alias} is signing off"
  end

  # Case 2: A developer requesting a buddy build test
  if sender.role == 'developer' and
    puts "##{e.id} #{sender.alias} is requesting buddy build"
  end
  

  next
  
  # ideas on bug id
  #  look for the query table
  #  bug [id :] <number>

  # associate this email with all parties involved
  associate_email_to_users(e, [e.from, e.to])
  associate_email_to_bug(e, tfs_id)
 
  # If email is from a dev, try and find a TFS item number and UNC
  sender = User.find_by_email e.from.first

  # update a UNC
  # - there is already a thread that exists
  #   - email date is later than the other one
  # - it is from a dev
  #
  # a bug numer is found
  # - it is the first email in the thread
  # - if it is not, it is the same bug number


  # I'm going to assume if there's a tfs id and UNC path, it's probably from a dev
  if tfs_id && bb_unc
    tfs_id = tfs_id[1].to_i
    bb_unc = bb_unc[1]

    e.bug = Bug.find_or_create_by_tfs_id(:tfs_id => tfs_id) do |b|
      b.drop_folder = bb_unc
      b.status      = 'unknown'
      b.requestor   = User.find_by_email :email => e.from.first
      b.tester      = User.find_by_email :email => e.to.first

      b.requestor   ||= User.find_or_create_by_name('unassigned')
      b.tester      ||= User.find_or_create_by_name('unassigned')
    end
    e.status = 'complete'
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
