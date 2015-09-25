class OpController < ApplicationController
  def index
    @operations = Operation.all.order('id DESC')
  end
  
  def show 
    image_id = params[:id] #image id! not operation.id!
    @operation = Operation.where(image_id: image_id)
        
    respond_to do |format|
      if @operation.count > 0
        @operation = @operation.last
        format.html { redirect_to play_index_path }
        format.json { render :json => { id: @operation.id, operation_type: @operation.operation_type, status: @operation.status } }
      else
        format.html { redirect_to play_index_path }
        format.json { render :json => { error: 'not_found' } }
      end
    end
  end
end