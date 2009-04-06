class WelcomeController < ApplicationController
  def index
    @begin = Date.parse("2009-06-29")
    @end   = Date.parse("2009-09-13")
    @dates = {}
    Day.find(:all,:include => :user).each { |day|
      @dates[day.date] ||= []
      @dates[day.date].push day
    }
    @max = 0
    @dates.each_pair do |date,days|
      @max = days.count if days.count > @max
    end
  end

end
