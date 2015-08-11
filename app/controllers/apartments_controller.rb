class ApartmentsController < ApplicationController

  LOCATIONS = ["Carroll Gardens", "Cobble Hill / Carroll Gardens", 
    "Cobble Hill", "CARROLL GARDENS", "Carroll Gardents", 
    "Brooklyn Heights - Atlantic Ave & Hicks St", "BOERUM HILL", 
    "Boerum Hill", "brooklyn heights"] 

    # [" (Carroll Gardens)", " (Cobble Hill / Carroll Gardens )", 
    #     " (Cobble Hill )", " (CARROLL GARDENS)", " (Carroll Gardents)", 
    #     " (Brooklyn Heights - Atlantic Ave & Hicks St)", " (BOERUM HILL)", 
    #     " (Boerum Hill)", " (brooklyn heights )"]

  def index
    @apartments = Apartment.good
  end
end
