class AccountMembershipsController < ApplicationController
  # GET /account_memberships
  # GET /account_memberships.xml
  def index
    @account_memberships = AccountMembership.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @account_memberships }
    end
  end

  # GET /account_memberships/1
  # GET /account_memberships/1.xml
  def show
    @account_membership = AccountMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account_membership }
    end
  end

  # GET /account_memberships/new
  # GET /account_memberships/new.xml
  def new
    @account_membership = AccountMembership.new
    @account = Account.find params[:account_id]
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account_membership }
    end
  end

  # GET /account_memberships/1/edit
  def edit
    @account_membership = AccountMembership.find(params[:id])
  end

  # POST /account_memberships
  # POST /account_memberships.xml
  def create
    @account = Account.find params[:account_id]
    @person = Person.find :first, :joins => :emails, :conditions => ['emails.email = ?', params[:email]]
    if @person
      @account_membership = AccountMembership.new( :person => @person, :account => @account)
    else
      @account_membership = AccountMembership.new
    end

    respond_to do |format|
      if @account_membership.save
        flash[:notice] = 'Person was successfully invited.'
        format.html { redirect_to(@account) }
        format.xml  { render :xml => @account_membership, :status => :created, :location => @account_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /account_memberships/1
  # PUT /account_memberships/1.xml
  def update
    @account_membership = AccountMembership.find(params[:id])

    respond_to do |format|
      if @account_membership.update_attributes(params[:account_membership])
        flash[:notice] = 'AccountMembership was successfully updated.'
        format.html { redirect_to(@account_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /account_memberships/1
  # DELETE /account_memberships/1.xml
  def destroy
    @account_membership = AccountMembership.find(params[:id])
    @account_membership.destroy

    respond_to do |format|
      format.html { redirect_to(account_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
