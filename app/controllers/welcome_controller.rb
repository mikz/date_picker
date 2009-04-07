class WelcomeController < ApplicationController
  def index
    @comments = Comment.find :all, :order => "created_at DESC", :include => :user
    @begin = Date.parse("2009-06-29")
    @end   = Date.parse("2009-09-13")
    @dates = {}
    Day.find(:all,:include => :user).each { |day|
      @dates[day.date] ||= []
      @dates[day.date].push day
    }
    @max = 0
    @dates.each_pair do |date,days|
      @max = days.size if days.size > @max
    end
  end

end
