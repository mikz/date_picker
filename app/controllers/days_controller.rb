class DaysController < ApplicationController
  before_filter {|c|c.login_required}
  before_filter :load_dates
  def new
  end
  def create
    
    params[:days]['selected'].each do |day|
      current_user.days.create :date => Date.parse(day) unless day.blank?
    end
    redirect_to :action => :edit
  end
  
  def edit
    @days = Day.find_all_by_user_id current_user.id
    @dates = @days.collect {|day| day.date}
  end
  
  def update
    current_user.days.each do |day|
      day.destroy unless params[:days]['selected'].include? day.date.to_s
    end
    dates = current_user.days.map do |day|
      day.date
    end
    selected = params[:days]['selected'].map {|day|
      Date.parse(day) unless day.blank?
    }
    STDERR << %{
      #{dates.inspect}
      #{selected.inspect}
      #{(selected - dates).inspect}
    }
    (selected - dates).each do |date|
      current_user.days.create :date => date unless date.nil?
    end
    redirect_to :action => :edit
  end
  
  protected
  def load_dates
    @begin = Date.parse("2009-06-29")
    @end   = Date.parse("2009-09-13")
  end
end
