class ServersController < ApplicationController

  def create
    if get_controller_from_state == 'hosts'
      @host = Host.find get_id_from_state
      server = @host.servers.build server_params(:new_server)
    else
      server = Server.new server_params(:new_server)
    end

    if server.save
      redirect_to_state notice: (t 'success.create', thing: 'Server')
    else
      redirect_to_state error: (t 'error.create', thing: 'Server')
    end
  end
  
  def update
    @server = Server.find params[:id]
   
    respond_to do |format|
      if @server.update_attributes(server_params)
        format.html { redirect_to(@server, :notice => 'Server was successfully updated.') }
        format.json { respond_with_bip(@server) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@server) }
      end
    end
  end

  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html {
        redirect_to_state notice: (t 'success.delete', thing: 'Server') }
      format.json { head :no_content }
    end
  end

  private

  def server_params(server_object = :server)
    params.require(server_object).permit(:name)
  end

end
