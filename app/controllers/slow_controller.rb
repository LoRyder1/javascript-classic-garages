class SlowController < ApplicationController

  def slow_action
    sleep 15

    raise "hey".inspect
    
  end


end
