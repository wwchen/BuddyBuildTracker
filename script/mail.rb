#!/usr/bin/env ruby

# testing the gem 'ruby'
# http://rubydoc.info/gems/mail/frames
# https://github.com/mikel/mail
require 'rubygems'
require 'mail'
require 'yaml'

CONFIG = YAML.load_file(File.join(File.dirname(File.expand_path(__FILE__)),"config.yml")) unless defined? CONFIG

Mail.defaults do
  retriever_method :imap, { :address    => CONFIG['IMAP_SERVER'],
                            :port       => 993,
                            :user_name  => CONFIG['IMAP_USER'],
                            :password   => CONFIG['IMAP_PASS'],
                            :enable_ssl => true }
end

mails = Mail.find :mailbox => 'INBOX/_BBTest', :what => :all, # :delete_after_find => true

mails.each do |mail|
  mail.to
  mail.from
  mail.body
end
