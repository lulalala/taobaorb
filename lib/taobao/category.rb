class Taobao::Category
  attr_reader :id

  # @param category_id [Integer]
  def initialize(category_id)
    @id = category_id.to_i
  end

  # @return [String]
  def name
    @name ||= category_request(cids: @id).first[:name]
  end

  def subcategories
    @subcategories ||= category_request(parent_cid: @id)
  end

  # @return [Taobao::PropertyList]
  def properties
    @properties ||= Taobao::PropertyList.new(cid: @id)
  end

  # @return [Taobao::ProductList]
  def products
    @products ||= Taobao::ProductList.new(cid: @id)
  end

  private
  def category_request(optional_params)
    fields = [:cid, :parent_cid, :name, :is_parent].join ','
    params = {method: 'taobao.itemcats.get', fields: fields}
    result = Taobao.api_request(params.merge(optional_params))
    begin
      result[:itemcats_get_response][:item_cats][:item_cat]
    rescue NoMethodError
      raise Taobao::IncorrectCategoryId, 'Incorrect category ID'
    end
  end

end