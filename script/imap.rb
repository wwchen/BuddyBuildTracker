#!/home/wchen/rails/BuddyBuildTracker/script/rails runner
# for now

require 'rubygems'
require 'mail'
require 'nokogiri'
require 'yaml'

mdir = Maildir.new('/home/wchen/work-mail/wichen@microsoft.com/INBOX._BBTest', false)
mdir = Maildir.new('/home/wchen/work-mail/INBOX._BBTest', false)
mdir.list(:cur).each do |message|
  body = (message.data.match /<body .*?>(.*)<\/body>/m)[1]
  trunc_body = body.sub(/From:.*/m,'')
  msg_body = Hpricot(trunc_body).to_plain_text # or .inner_text
  #
  # add the data into the system
  email = Email.find_or_create_by_unique_name(message.unique_name)
  email.update_attributes!(
    :subject      => (message.data.match /Subject: (.*)/)[1],
    :from         => (message.data.match /From: (.*)/)[1],
    :to           => (message.data.match /To: (.*)/)[1],
    :body         => msg_body
  )
  #email.save
  puts "Email found or created, with id #{message.unique_name}"
  
  # TODO mark the message as read
  

  begin
    # Are there the words "Buddy build"?
    #raise StandardError unless body.match /buddy build/i
    
    # Is there a bug id we can parse for?
    bug_id = msg_body.match /(\d{6})(\D|$)/
    raise StandardError unless bug_id
    bug_id = bug_id[1]

    # Is there a UNC we can pull?
    unc = msg_body.match /(\\\\[a-zA-Z0-9\\ -]*)/ # (\\[^:*?"<>|]*)
    raise StandardError unless not unc.nil? or unc.length == 1
    unc = unc[1]

  rescue StandardError
    #email.destroy
    puts message.unique_name + "destroyed"
    next
  end


  # with the bug id and such in hand, lets create a bb
  buddybuild = BuddyBuild.find_or_create_by_bug_id(bug_id)
  buddybuild.directory = unc
  buddybuild.requestor = Requestor.find_by_name('william')
  buddybuild.tester    = Tester.find_by_name('william')
  email.buddy_build = buddybuild

  buddybuild.save
  email.save
  
end

