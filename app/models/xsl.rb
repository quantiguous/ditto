class Xsl < ActiveRecord::Base
  def apply(xml)
    xsl = Nokogiri::XSLT(self.xsl)    
    return xsl.transform(xml, ["UUID", "'#{SecureRandom.uuid.gsub('-','').upcase}'", "currentDate", "'#{Date.today}'", "uniqueRequestNo", "'#{SecureRandom.uuid.gsub('-','').upcase}'", "bankReferenceNo", "'#{bank_ref_no}'"]).to_xml    
  end
  
  private
  def bank_ref_no
    "YESB"+rand(10 ** 10).to_s
  end
end