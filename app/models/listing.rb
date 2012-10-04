class Listing
  # include ListingParser
  include Mongoid::Document
  
  field :raw, :type => String
  field :mls, :type => Integer
  
  # index({ mls: 1}, { unique: true })
  # 
  # def initialize(params={})
  #   super(params)
  #   
  #   if params[:text]
  #     self.raw = params[:text]
  #     self.mls = get_mls_number(params[:text])
  #   end
  # end
end