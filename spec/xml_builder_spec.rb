require File.join(File.dirname(__FILE__), '../lib/xml_builder')
require File.join(File.dirname(__FILE__), '../spec/spec_helper')

describe XMLBuilder do
  before do
    @xml_builder = XMLBuilder.new
    @repo = Grit::Repo.new(sample_repository_path)
    @generated_xml = @xml_builder.generate_xml(@repo)
  end
  
  it 'should generate a schema def' do
    @generated_xml.should =~ /#{%Q{
    <sphinx:schema>
    <sphinx:field name="hash_tag"/> 
    <sphinx:field name="content"/>
    <sphinx:field name="file_name"/>
    <sphinx:field name="file_path"/>
    </sphinx:schema>}}/m
  end
  
  it 'should generate a xml element for each file' do
    @generated_xml.should =~ /#{%Q{<sphinx:document id=\"(\\S+)\">(.*)</sphinx:document>}}/m    
  end
  
  it 'should contain a file name for each document' do
    @generated_xml.should =~ /<file_name>(\S+)<\/file_name>/m
  end
  
  it 'should contain a commit tag for each document' do
    @generated_xml.should =~ /<hash_tag>(\S+)<\/hash_tag>/m
  end
  
  it 'should contain data for each document' do
    @generated_xml.should =~ /<content>(.*)Planet(.*)<\/content>/m
  end
end
