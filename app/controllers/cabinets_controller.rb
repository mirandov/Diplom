class CabinetsController < ApplicationController
  def index
    render '/app/views/cabinets/index'
  end
  def show
    redirect_to cabinets_path('/app/cabinets/admin')
  end
  def select_role
    url = request.referrer =~ /cabinets/ ? cabinets_path : request.referrer
    redirect_to url
  end
end
