require 'rubygems'
require 'grit'

class XMLBuilder
  include Grit
  
  def generate_xml repo
    @committed_data = repo.commits.map do |commit|
      commit.tree.contents.map do |grit_obj|
        {:file_name => grit_obj.name, :content => grit_obj.data, :id => grit_obj.id} if grit_obj.class.name =~ /Blob/
      end
    end
    
    %Q{<?xml version="1.0" encoding="utf-8"?>
    <sphinx:docset>

    <sphinx:schema>
    <sphinx:field name="hash_tag"/> 
    <sphinx:field name="content"/>
    <sphinx:field name="file_name"/>
    <sphinx:field name="file_path"/>
    </sphinx:schema>

    #{@committed_data.map { |tree| tree.map { |blob| "<sphinx:document id=\"#{blob[:id]}\"><hash_tag>#{blob[:id]}</hash_tag><file_name>#{blob[:file_name]}</file_name><content>#{blob[:content]}</content></sphinx:document>"} } }
    </sphinx:docset>}
  end
  
end