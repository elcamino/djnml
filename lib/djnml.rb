# encoding: UTF-8

# Copyright (c) 2012, Tobias Begalke
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


require 'nokogiri'
require 'date'
require 'language_detector'
require 'djnml/codes'
require 'djnml/delete'
require 'djnml/modification'

class DJNML

  attr_reader :msize, :md5, :sys_id, :destination, :dist_id, :transmission_date,
              :publisher, :doc_date, :product, :seq, :lang,
              :news_source, :origin, :service_id,
              :urgency,
              :brand, :temp_perm, :retention, :hot, :original_source,
              :accession_number, :display_date, :page_citation,
              :company_code, :isin_code, :industry_code, :page_code,
              :government_code, :stat_code, :journal_code, :routing_code,
              :content_code, :function_code, :subject_code, :market_code,
              :product_code, :geo_code,
              :headline, :headline_brand, :text, :html, :language,
              :copyright_year, :copyright_holder,
              :website, :company_name, :company_address, :company_zip, :company_city,
              :delete, :modifications


  def initialize(data = {})
    pp data

    @msize = data['msize'].to_i
    @md5   = data['md5']
    @sys_id = data['sys_id']
    @destination = data['destination']
    @dist_id = data['dist_id']
    @transmission_date = Time.parse(data['transmission_date'])
    @publisher = data['publisher']
    @doc_date  = Time.parse(data['doc_date'])
    @product   = data['product']
    @seq       = data['seq'].to_i
    @lang      = data['lang']
    @news_source = data['news_source']
    @origin      = data['origin']
    @service_id  = data['service_id']
    @urgency     = data['urgency']
    @brand            = data['brand']
    @temp_perm        = data['temp_perm']
    @retention        = data['retention']
    @hot              = data['hot']
    @original_source  = data['original_source']
    @accession_number = data['accession_number']
    @page_citation    = data['page_citation']
    @display_date     = Time.parse(data['display_date'])
    @company_code     = data['company_code']
    @isin_code        = data['isin_code']
    @page_code        = data['page_code']
    @industry_code   = data['industry_code'].to_a.map { |c| Codes.new(c) }
    @government_code = data['government_code'].to_a.map { |c| Codes.new(c) }
    @subject_code    = data['subject_code'].to_a.map { |c| Codes.new(c) }
    @market_code     = data['market_code'].to_a.map { |c| Codes.new(c) }
    @product_code    = data['product_code'].to_a.map { |c| Codes.new(c) }
    @geo_code        = data['geo_code'].to_a.map { |c| Codes.new(c) }
    @stat_code       = data['stat_code'].to_a.map { |c| Codes.new(c) }
    @journal_code    = data['stat_code'].to_a.map { |c| Codes.new(c) }
    @routing_code    = data['routing_code'].to_a.map { |c| Codes.new(c) }
    @content_code    = data['content_code'].to_a.map { |c| Codes.new(c) }
    @function_code   = data['function_code'].to_a.map { |c| Codes.new(c) }
    @headline        = data['headline']
    @headline_brand  = data['headline_brand']
    @html            = data['html']
    @text            = data['text']
    @copyright_year  = data['copyright_year']
    @copyright_holder = data['copyright_holder']
    @website = data['website']
    @company_name = data['company_name']
    @company_address=  data['company_address']
    @company_zip = data['company_zip']
    @company_city = data['company_city']
    @language = data['language']

  end

  def self.load(filename)

    if filename
      if ! File.exists?(filename)
        raise FileError.new("#{filename}: no such file!")
      end

      obj = self.new
      obj.load(filename)
    end
  end

  def load(filename)
    if ! File.exists?(filename)
      raise FileError.new("#{filename}: no such file!")
    end

    parser = Nokogiri::XML(open(filename))

    # doc tag
    #
    begin
      doc                = parser.search('/doc').first
      @msize             = doc['msize'].to_i
      @md5               = doc['md5']
      @sys_id            = doc['sysId']
      @destination       = doc['destination']
      @dist_id           = doc['distId']
      @transmission_date = Time.parse(doc['transmission-date'])
    rescue
      # ignore errors
    end

    doc = nil

    # djnml tag
    #
    begin
      djnml      = parser.search('/doc/djnml').first
      @publisher = djnml['publisher']
      @doc_date  = Time.parse(djnml['docdate'])
      @product   = djnml['product']
      @seq       = djnml['seq'].to_i
      @lang      = djnml['lang']
    rescue
      # ignore errors
    end

    djnml      = nil

    # djn-newswires tag
    #
    begin
      newswires    = parser.search('/doc/djnml/head/docdata/djn/djn-newswires').first
      @news_source = newswires['news-source']
      @origin      = newswires['origin']
      @service_id  = newswires['service-id']
    rescue
      # ignore errors
    end

    newswires = nil

    # djn-press-cutout tag
    #
    presscutout = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-press-cutout').first
    presscutout = nil

    # djn-urgency tag
    #
    begin
      urgency  = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-urgency').first
      @urgency = urgency.text.strip.squeeze.to_i
    rescue
      # ignore errors
    end

    urgency = nil


    # djn-mdata
    #
    begin
      mdata             = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata').first
      @brand            = mdata['brand']
      @temp_perm        = mdata['temp-perm']
      @retention        = mdata['retention']
      @hot              = mdata['hot']
      @original_source  = mdata['original-source']
      @accession_number = mdata['accession-number']
      @page_citation    = mdata['page-citation']
      @display_date     = Time.parse(mdata['display-date'])
    rescue
      # ignore errors
    end

    mdata = nil

    # coding / company
    #
    begin
      ccompany      = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-company/c')
      @company_code = ccompany.map { |tag| tag.text.strip }
    rescue
      # ignore errors
    end

    ccompany = nil

    # coding / isin
    #
    begin
      isin       = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-isin/c')
      @isin_code = isin.map { |tag| tag.text.strip }

    rescue
      # ignore errors
    end

    isin = nil

    # coding / page
    #
    begin
      page       = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-page/c')
      @page_code = page.map { |tag| tag.text.strip }

    rescue
      # ignore errors
    end

    page = nil


    # coding / industry
    #
    begin
      industry       = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-industry/c')
      @industry_code = industry.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    industry = nil

    # coding / government
    #
    begin
      government       = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-government/c')
      @government_code = government.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    government = nil


    # coding / subject
    #
    begin
      subject       = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-subject/c')
      @subject_code = subject.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    subject = nil

    # coding / market
    #
    begin
      market = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-market/c')
      @market_code = market.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    market = nil

    # coding / product
    #
    begin
      product = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-product/c')
      @product_code = product.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    product = nil

    # coding / geo
    #
    begin
      geo = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-geo/c')
      @geo_code = geo.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    geo = nil

    # coding / stat
    #
    begin
      stat = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-stat/c')
      @stat_code = stat.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    stat = nil


    # coding / journal
    #
    begin
      journal = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-journal/c')
      @journal_code = journal.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    journal = nil


    # coding / routing
    #
    begin
      routing = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-routing/c')
      @routing_code = routing.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    routing = nil

    # coding / content
    #
    begin
      content = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-content/c')
      @content_code = content.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    content = nil

    # coding / function
    #
    begin
      function = parser.search('/doc/djnml/head/docdata/djn/djn-newswires/djn-mdata/djn-coding/djn-function/c')
      @function_code = function.map { |tag| Codes.new(tag.text.strip) }
    rescue
      # ignore errors
    end

    function = nil


    # body / headline
    #
    begin
      headline  = parser.search('/doc/djnml/body/headline').first
      @headline = headline.text.strip
      @headline_brand = headline['brand-display'] if headline['brand-display']
    rescue
      # ignore errors
    end

    headline  = nil

    # body / text
    #
    begin
    text  = parser.search('/doc/djnml/body/text').first
    @html = text.children.to_xml
    @text = text.children.text.strip
    rescue
      # ignore errors
    end

    text  = nil

    # copyright
    #
    begin
      copyright         = parser.search('/doc/djnml/head/copyright').first
      @copyright_year   = copyright['year'].to_s.strip.to_i
      @copyright_holder = copyright['holder']
    rescue
      # ignore errors
    end

    copyright = nil

    # website
    #
    begin
      if @text =~ /Internet:\s+(.+?)$/
        @website = $1.strip
      end
    rescue
      # ignore errors
    end

    if @text =~ /Company:\s+(\S.+?)\s*\n+\s+(\b.+?)\n+\s+(\d+)\s+(\b.+?)\n+/
      @company_name = $1.strip
      @company_address=  $2.strip
      @company_zip = $3.strip
      @company_city = $4.strip
    end

    # language
    #
    begin
      @language = LanguageDetector.instance.detect(@text)
    rescue
      # ignore errors
    end

    # stories to delete
    #
    begin
      @delete = []
      doc_delete = parser.search('/doc/djnml/administration/doc-delete')
      doc_delete.each do |dd|
        @delete << Delete.new(:product => dd['product'],
                              :doc_date => dd['docdate'],
                              :seq => dd['seq'],
                              :publisher => dd['publisher'],
                              :reason => dd['reason'])
      end
    rescue
      # ignore errors
    end

    # replacements
    #
    @modifications = []
      doc_modify = parser.search('/doc/djnml/administration/doc-modify').first

      mods = parser.search('/doc/djnml/administration/doc-modify/modify-replace')
      mods.each do |m|
        @modifications << Modification.new(:doc_date => doc_modify['docdate'],
                                           :product => doc_modify['product'],
                                           :publisher => doc_modify['publisher'],
                                           :seq => doc_modify['seq'],
                                           :xml => m)
      end
    self
  end

  def has_content?
    ! self.text.nil?
  end

  class FileError < Exception
  end
end
