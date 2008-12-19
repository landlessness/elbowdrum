class ItemsController < ApplicationController
  # GET /items
  # GET /items.xml
  def index
    @account = current_person.accounts.find(params[:account_id])
    ymd = params.values_at :year, :month, :day
    @day = ymd.all? ? Time.zone.local(*ymd) : Time.zone.now.beginning_of_day
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.xml
  def create
    @account = current_person.accounts.find params[:account_id]
    @account_membership = @account.account_memberships.find params[:account_membership_id]
    item_type = params[:item].delete(:type)
    @item = @account_membership.items.new(params[:item]).becomes(Object.const_get(item_type))
    raise 'tried to create a non-item object from an item.  this might be an attack' unless @item.is_a?(Item)
    @item.type = item_type
    respond_to do |format|
      if @item.save
        format.js
      else
        format.js  { render :text => 'there was an error' }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to(@item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end
end
