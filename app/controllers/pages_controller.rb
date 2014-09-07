require 'json'
require 'rufus-scheduler'

class PagesController < ApplicationController
	skip_before_filter  :verify_authenticity_token

	@@payment
	@@queue = Mqueue.new
	@@current_message

	@@scheduler = Rufus::Scheduler.new

	@@scheduler.every '30s', :first_in => 0 do
		p "what"
		@@current_message = @@queue.dequeue
	end

	def current
		@message = @@current_message
	end

	def venmo_verify
	  render :text => { note: @@payment['data']['note'], amount: @@payment['data']['amount'] }
	end

	def gimme
		@@payment = JSON.parse request.body.read
	  turns = (@@payment['data']['amount'].to_f / 0.50).truncate
	  turns.times { @@queue.enqueue(@@payment['data']['note']) }
	  p @@payment['data']['note']
	  render :text => @@payment
	end
end
