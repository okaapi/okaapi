require File.dirname(__FILE__) + "/../../config/environment" unless defined?(RAILS_ROOT)


res = OkaapiMailer.test('wido@menhardt.com').deliver_now

p res
