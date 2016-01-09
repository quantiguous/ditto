class XmlValidator < ActiveRecord::Base
  belongs_to :route
  
  validates_presence_of :name, :xml_schema
  validates_uniqueness_of :name
  has_one :response, dependent: :destroy
  accepts_nested_attributes_for :response, :reject_if => lambda { |a| a[:response].blank?}, :allow_destroy => true 
  
  def evaluate(reqString)
    reqDoc = Nokogiri::XML(reqString)
    strippedDoc = remove_soap_header(reqDoc)
    p strippedDoc.to_xml.tr("\n","")
    xsd = Nokogiri::XML::Schema(self.xml_schema)
      
    if xsd.validate(strippedDoc).empty?
      # schema validaion passed
      return true
    else
      # schema validation failed, we return the response to be sent back to the client
      return false
    end       
  end

  # responses are converted to a hash and sent back
  def build_reply(route_id)
    {:route_id => route_id, :status_code => '500', :response => self.response, :response_text => self.response.response }
  end 
  
  
  def remove_soap_header(reqDoc)
    xsl_string = '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><xsl:template match="@* | node()"><xsl:copy><xsl:apply-templates select="@* | node()" /></xsl:copy></xsl:template><xsl:template match="soapenv:*"><xsl:apply-templates select="@* | node()" /></xsl:template></xsl:stylesheet>'
    template = Nokogiri::XSLT(xsl_string)
    soapReqDoc = template.transform(reqDoc)    
  end
end