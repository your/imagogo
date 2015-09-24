class OpController < ApplicationController
  def index
    @operations = Operation.all.order('id DESC')
  end
end