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


class DJNML
  class Modification
    attr_reader :publisher, :doc_date, :product, :seq, :xpath, :mdata,
                :headline, :text, :urgency, :press_cutout, :summary

    def initialize(args = {})

      @publisher = args[:publisher] if args[:publisher]
      @doc_date  = Time.parse(args[:doc_date]) if args[:doc_date]
      @product   = args[:product] if args[:product]
      @seq       = args[:seq].to_i if args[:seq]
      xml        = args[:xml] if args[:xml]

      if xml && xml.is_a?(Nokogiri::XML::Element)
        @xpath     = xml['xpath']

        if mdata = xml.search('djn-mdata').to_a.first
          @mdata = Mdata.new(mdata)
        end

        if headline = xml.search('headline').to_a.first
          @headline = headline.text.strip
        end

        if text = xml.search('text').to_a.first
          @text = XMLText.new(text)
        end

        if text = xml.search('summary').to_a.first
          @summary = XMLText.new(text)
        end

        if press = xml.search('djn-press-cutout').to_a.first
          @press_cutout = press.text.strip
        end

        if urgency = xml.search('djn-urgency').to_a.first
          @urgency = urgency.text.strip
        end
      else
        @publisher    = args['publisher'] if args['publisher']
        @doc_date     = Time.parse(args['doc_date']) if args['doc_date']
        @product      = args['product'] if args['product']
        @seq          = args['seq'].to_i if args['seq']
        @mdata        = Mdata.new(args['mdata']) if args['mdata']
        @headline     = args['headline'] if args['headline']
        @text         = XMLText.new(args['text']) if args['text']
        @summary      = XMLText.new(args['summary']) if args['summary']
        @press_cutout = args['press_cutout'] if args['press_cutout']
        @urgency      = args['urgency'] if args['urgency']
      end
    end


    def fields_to_modify
      fields = []
      [:mdata, :headline, :text, :urgency, :press_cutout, :summary].each do |f|
        if self.send(f)
          fields << f
        end
      end
      fields
    end

    class XMLText
      attr_reader :text, :html

      def initialize(data)
        if data.is_a?(Nokogiri::XML::Element)
          @text = data.children.text.strip
          @html = data.children.to_xml
        elsif data.is_a?(Hash)
          @text = data['text']
          @html = data['html']
        end
      end

      def to_s
        @text.to_s
      end

    end

    class Mdata
      attr_reader :company_code, :isin_code, :industry_code, :government_code,
                  :page_code, :subject_code, :market_code, :product_code,
                  :geo_code, :stat_code, :journal_code, :routing_code,
                  :content_code, :function_code

      def self.from_hash(data)
        self.new(data) if data.is_a?(Hash)
      end

      def initialize(data = nil)
        return unless data

        initialize_from_xml(data) if data.is_a?(Nokogiri::XML::Element)
        initialize_from_hash(data) if data.is_a?(Hash)
      end

      def initialize_from_hash(data)
        @company_code = data['company_code']
        @isin_code = data['isin_code']
        @page_code = data['page_code']
        @industry_code = data['industry_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @government_code = data['government_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @subject_code = data['subject_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @market_code = data['market_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @geo_code = data['geo_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @stat_code = data['stat_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @journal_code = data['journal_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @routing_code = data['routing_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @function_code = data['function_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
        @product_code = data['product_code'].map { |c| ::DJNML::Codes.new(c['symbol']) }
      end

      def initialize_from_xml(xml)
        # company
        #
        if tag = xml.search('djn-coding/djn-company/c')
          @company_code = tag.map { |tag| tag.text.strip }
          tag = nil
        end

        # isin
        #
        if tag = xml.search('djn-coding/djn-isin/c')
          @isin_code = tag.map { |tag| tag.text.strip }
          tag = nil
        end

        # industry
        #
        if tag = xml.search('djn-coding/djn-industry/c')
          @industry_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # government
        #
        if tag = xml.search('djn-coding/djn-government/c')
          @government_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # page
        #
        if tag = xml.search('djn-coding/djn-page/c')
          @page_code = tag.map { tag.text.strip }
          tag = nil
        end

        # subject
        #
        if tag = xml.search('djn-coding/djn-subject/c')
          @subject_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # market
        #
        if tag = xml.search('djn-coding/djn-market/c')
          @market_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # product
        #
        if tag = xml.search('djn-coding/djn-product/c')
          @product_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # geo
        #
        if tag = xml.search('djn-coding/djn-geo/c')
          @geo_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # stat
        #
        if tag = xml.search('djn-coding/djn-stat/c')
          @stat_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # journal
        #
        if tag = xml.search('djn-coding/djn-journal/c')
          @journal_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # routing
        #
        if tag = xml.search('djn-coding/djn-routing/c')
          @routing_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # content
        #
        if tag = xml.search('djn-coding/djn-content/c')
          @content_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end

        # function
        #
        if tag = xml.search('djn-coding/djn-function/c')
          @function_code = tag.map { |tag| ::DJNML::Codes.new(tag.text.strip) }
          tag = nil
        end
      end
    end
  end
end
