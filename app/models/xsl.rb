class Xsl < ActiveRecord::Base
  def apply(xml, params)
    xsl = Nokogiri::XSLT(self.xsl)  
    return xsl.transform(xml, build_params_array(params)).to_xml
  end
  
  private
  def bank_ref_no
    "YESB"+rand(10 ** 10).to_s
  end
  
  def build_params_array(params)
    unless params.nil?
      Nokogiri::XSLT.quote_params(Oj.load(params).to_a.flatten)
    else
      []
    end
  end
end