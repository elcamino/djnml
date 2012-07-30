# encoding: UTF-8

require 'spec_helper'
require 'djnml'
require 'digest/sha1'
require 'singleton'


class LanguageDetector
  include Singleton
end

data_base =  File.join(File.dirname(__FILE__), 'data')
story_file_en = File.join(data_base, 'DN20080506000785.nml')
story_file_de = File.join(data_base, '20120716162053366LL005062.NML')
story_file_internet = File.join(data_base, '20120716161436878LL001634.NML')
story_file_govt = File.join(data_base, 'DN20080506000839.nml')
story_file_admin = File.join(data_base, '20120716155056208LL000587.NML')
story_file_modify_replace_meta = File.join(data_base, 'DN20080506000741.nml')
story_file_modify_replace_headline = File.join(data_base, '20120720222918942LL007284.NML')
invalid_file = File.join(data_base, 'doesnt_exist.nml')



describe "DJNML raises errors when loading a file that doesn't exist" do
  it "DJNML.load('#{invalid_file}') raises an DJNML::FileError" do
    expect { DJNML.load(invalid_file) }.to raise_error(DJNML::FileError)
  end

  it "load('#{invalid_file}') raises an DJNML::FileError" do
    expect { DJNML.new.load(invalid_file) }.to raise_error(DJNML::FileError)
  end
end

describe "DJNML.load('#{story_file_modify_replace_headline}') loads a Dow jones NML administration modify-replace story and parses it." do
  before(:all) {
    @djnml = DJNML.load(story_file_modify_replace_headline)
  }
  subject { @djnml }

  let(:mod_0) { @djnml.modifications[0] }
  let(:mod_1) { @djnml.modifications[1] }
  let(:mod_2) { @djnml.modifications[2] }
  let(:mod_3) { @djnml.modifications[3] }
  let(:mod_4) { @djnml.modifications[4] }
  let(:headline) { mod_0.headline }
  let(:press_cutout) { mod_1.press_cutout }
  let(:urgency) { mod_2.urgency }
  let(:summary) { mod_4.summary }
  let(:text) { mod_3.text }

  it { should be }
  its(:'modifications.size') { should == 5 }

  it "subject.modifications.each.doc_date.should == #{Time.parse('20120720')}" do
    mod_0.doc_date.should == Time.parse('20120720')
    mod_1.doc_date.should == Time.parse('20120720')
    mod_2.doc_date.should == Time.parse('20120720')
  end

  it "subject.modifications.each.product.should == 'LL'" do
    mod_0.product.should == 'LL'
    mod_1.product.should == 'LL'
    mod_2.product.should == 'LL'
  end

  it "subject.modifications.each.publisher.should == 'DJN'" do
    mod_0.publisher.should == 'DJN'
    mod_1.publisher.should == 'DJN'
    mod_2.publisher.should == 'DJN'
  end

  it "subject.modifications.each.seq.should == 7150" do
    mod_0.seq.should == 7150
    mod_1.seq.should == 7150
    mod_2.seq.should == 7150
  end

  it "subject.modifications[0].headline.class.should == String" do
    headline.class.should == String
  end

  it "subject.modifications[0].headline.should == 'Gobierno Brasil rebaja proyección crecimiento 2012 a 3,0%'" do
    headline.should == 'Gobierno Brasil rebaja proyección crecimiento 2012 a 3,0%'
  end

  it "subject.modifications[2].urgency.class.should == String" do
    urgency.class.should == String
  end

  it "subject.modifications[2].urgency.should == '0'" do
    urgency.should == '0'
  end

  it "subject.modifications[1].press_cutout.class.should == String" do
    press_cutout.class.should == String
  end

  it "subject.modifications[1].press_cutout.should == ''" do
    press_cutout.should == ''
  end

  it "subject.modifications[4].xpath.should == ''" do
    mod_4.xpath.should == 'djnml/body/summary'
  end

  it "subject.modifications[4].summary.text.should == 'test summary'" do
    summary.text.should == 'test summary'
  end

  it "subject.modifications[4].summary.html.should == '<p>test summary</p>'" do
    summary.html.should == '<p>test summary</p>'
  end

  it "subject.modifications[3].xpath.should == ''" do
    mod_3.xpath.should == 'djnml/body/text'
  end

  it "subject.modifications[3].text.should == 'test paragraph'" do
    text.text.should == 'test paragraph'
  end

  it "subject.modifications[3].html.should == '<p>test paragraph</p>'" do
    text.html.should == '<p>test paragraph</p>'
  end

end

describe "DJNML.load('#{story_file_modify_replace_meta}') loads a Dow jones NML administration modify-replace story and parses it." do
  before(:all) {
    @djnml = DJNML.load(story_file_modify_replace_meta)
  }
  subject { @djnml }

  let(:mod) { @djnml.modifications[0] }
  let(:mdata) { mod.mdata }

  it { should be }

  its(:'modifications.size') { should == 1 }

  it "subject.modifications[0].xpath.should == 'djnml/head/docdata/djn/djn-newswires/djn-mdata'" do
    mod.xpath.should == 'djnml/head/docdata/djn/djn-newswires/djn-mdata'
  end

  it "subject.modifications[0].doc_date.should == #{Time.parse('20080506')}" do
    mod.doc_date.should == Time.parse('20080506')
  end

  it "subject.modifications[0].product.should == 'DN'" do
    mod.product.should == 'DN'
  end

  it "subject.modifications[0].publisher.should == 'DJN'" do
    mod.publisher.should == 'DJN'
  end

  it "subject.modifications[0].seq.should == 741" do
    mod.seq.should == 741
  end

  it "subject.modifications[0].mdata.should be" do
    mdata.class.should be
  end

  it "subject.modifications[0].mdata.class should == ::DJNML::Modification::Mdata" do
    mdata.class.should == ::DJNML::Modification::Mdata
  end

  it "subject.modifications[0].mdata.company_code.should == %w(ADEN.VX)" do
    mdata.company_code.should == %w(ADEN.VX)
  end

  it "subject.modifications[0].mdata.isin_code.should == %w(CH0012138605)" do
    mdata.isin_code.should == %w(CH0012138605)
  end

  it "subject.modifications[0].mdata.industry_code.should == %w(I/EAG I/SVC I/XDJGI I/XSMI)" do
    mdata.industry_code.map { |c| c.symbol }.should == %w(I/EAG I/SVC I/XDJGI I/XSMI)
  end

  it "subject.modifications[0].mdata.subject_code.should == %w(N/CMDI N/CMR N/DJCB N/DJEI N/DJEP N/DJGP N/DJGV N/DJI N/DJIN N/DJIV N/DJMO N/DJN N/DJPT N/DJWB N/ECR N/EUCM N/EWR N/WER N/BNEU N/CAC N/CNW N/DJPN N/DJS N/DJSS N/DJWI N/ERN N/FCTV N/TNW N/TSY N/WEI)" do
    mdata.subject_code.map { |c| c.symbol }.should == %w(N/CMDI N/CMR N/DJCB N/DJEI N/DJEP N/DJGP N/DJGV N/DJI N/DJIN N/DJIV N/DJMO N/DJN N/DJPT N/DJWB N/ECR N/EUCM N/EWR N/WER N/BNEU N/CAC N/CNW N/DJPN N/DJS N/DJSS N/DJWI N/ERN N/FCTV N/TNW N/TSY N/WEI)
  end

  it "subject.modifications[0].mdata.market_code.should == %w(M/IDU M/NND)" do
    mdata.market_code.map { |c| c.symbol }.should == %w(M/IDU M/NND)
  end

  it "subject.modifications[0].mdata.product_code.should == %w(P/RTRS)" do
    mdata.product_code.map { |c| c.symbol }.should == %w(P/RTRS)
  end

  it "subject.modifications[0].mdata.geo_code.should == %w(R/EU R/SZ R/WEU)" do
    mdata.geo_code.map { |c| c.symbol }.should == %w(R/EU R/SZ R/WEU)
  end

  it "subject.modifications[0].mdata.government_code.should == []" do
    mdata.government_code.should == []
  end

  it "subject.modifications[0].mdata.page_code.should == []" do
    mdata.page_code.should == []
  end

  it "subject.modifications[0].mdata.stat_code.should == []" do
    mdata.stat_code.should == []
  end

  it "subject.modifications[0].mdata.journal_code.should == []" do
    mdata.journal_code.should == []
  end

  it "subject.modifications[0].mdata.routing_code.should == []" do
    mdata.routing_code.should == []
  end

  it "subject.modifications[0].mdata.content_code.should == []" do
    mdata.content_code.should == []
  end

  it "subject.modifications[0].mdata.function_code.should == []" do
    mdata.function_code.should == []
  end
end

describe "DJNML.load('#{story_file_de}') loads a Dow jones NML story and parses it." do
  before(:all) {
    @djnml = DJNML.load(story_file_de)
  }
  subject { @djnml }

  it { should be }

  it "Language should be 'de'" do
    subject.language.should == 'de'
  end

  its(:copyright_year) { should == 2012 }
  its(:copyright_holder) { should == 'Dow Jones & Company, Inc.'}

  it "should have content" do
    subject.has_content?.should == true
  end

end

describe "DJNML.load('#{story_file_internet}') loads a Dow jones NML story and parses it." do
  before(:all) {
    @djnml = DJNML.load(story_file_internet)
  }
  subject { @djnml }

  it { should be }

  it "Language should be 'en'" do
    subject.language.should == 'en'
  end

  its(:website) { should == 'www.vossloh.com' }
  its(:company_name) { should == 'Vossloh AG' }
  its(:company_address) { should == 'Vosslohstr. 4' }
  its(:company_zip) { should == '58791'}
  its(:company_city) { should == 'Werdohl' }
end

describe "DJNML.load('#{story_file_en}') loads a Dow Jones NML story and parses it." do
  before(:all) {
    @djnml = DJNML.load(story_file_en)
  }
  subject { @djnml }

  let(:html_sha1sum) {
    Digest::SHA1.hexdigest(subject.html)
  }

  let(:text_sha1sum) {
    Digest::SHA1.hexdigest(subject.text)
  }

  it { should be }

  # doc
  #
  its(:msize) { should == 11410 }
  its(:md5) { should == '7abbf5047fee493e144efefbdf28c9f0' }
  its(:sys_id) { should == 'dcmn2p1' }
  its(:destination) { should == 'AW' }
  its(:dist_id) { should == 'AMD6' }
  its(:transmission_date) { should == Time.parse('20080506T053501Z') }

  # djnml
  #
  its(:publisher) { should == 'DJN' }
  its(:doc_date) { should == Time.parse('2008-05-06') }
  its(:product) { should == 'DN' }
  its(:seq) { should == 785 }
  its(:lang) { should == 'en-us' }

  # djn-newswires
  #
  its(:news_source) { should == 'DJDN' }
  its(:origin) { should == 'DJ' }
  its(:service_id) { should == 'CO' }

  # djn-urgency
  #
  its(:urgency) { should == 0 }

  # djn-mdata
  #
  its(:brand) { should == 'DJ' }
  its(:temp_perm) { should == 'P' }
  its(:retention) { should == 'N' }
  its(:hot) { should == 'N' }
  its(:original_source) { should == 'T' }
  its(:accession_number) { should == '20080506000785' }
  its(:page_citation) { should == '' }
  its(:display_date) { should == Time.parse('20080506T0535Z') }

  # codes / company
  #
  its(:company_code) { should == %w(ADDYY ADS.XE) }

  # codes / isin
  #
  its(:isin_code) { should == %w(DE0005003404) }

  # codes / page
  #
  its(:page_code) { should == [] }

  # code / industry
  #
  it "industry_code should consist of these symbols: I/FOT I/TEX I/XDAX I/XDJGI I/XISL." do
    subject.industry_code.map { |c| c.symbol }.should == %w(I/FOT I/TEX I/XDAX I/XDJGI I/XISL)
  end

  it "industry_code[0].name.should == 'Footwear'" do
    subject.industry_code[0].name.should == 'Footwear'
  end

  # code / subject
  #
  it "subject_code should consist of these symbols: N/DJCB N/DJEI N/DJEP N/DJFP N/DJGP N/DJGS N/DJGV N/DJI N/DJIN N/DJIV N/DJN N/DJPT N/DJWB N/WER N/ADR N/CAC N/CNW N/DJPN N/DJWI N/ERN N/PRL N/TPCT N/WEI." do
    subject.subject_code.map { |c| c.symbol }.should == %w(N/DJCB N/DJEI N/DJEP N/DJFP N/DJGP N/DJGS N/DJGV N/DJI N/DJIN N/DJIV N/DJN
                                    N/DJPT N/DJWB N/WER N/ADR N/CAC N/CNW N/DJPN N/DJWI N/ERN N/PRL N/TPCT N/WEI )
  end

  it "subject_code[0].name.should == 'Dow Jones Corporate Bond Service'" do
    subject.subject_code[0].name.should == 'Dow Jones Corporate Bond Service'
  end

  # code / market
  #
  it "market_code should consist of these symbols: M/MMR M/NCY M/TPX" do
    subject.market_code.map { |c| c.symbol }.should == %w(M/MMR M/NCY M/TPX)
  end

  it "market_code[0].name.should == 'More News to Follow'" do
    subject.market_code[0].name.should == 'More News to Follow'
  end

  # code / product
  #
  it "product_code should consist of these symbols: P/TAP" do
    subject.product_code.map { |c| c.symbol }.should ==  %w(P/TAP)
  end

  it "product_code[0].name.should == 'Press Releases Auto-Published on Ticker'" do
    subject.product_code[0].name.should == 'Press Releases Auto-Published on Ticker'
  end

  # code / geo
  #
  it "geo_code should consist of these symbols: R/EC R/EU R/GE R/WEU" do
    subject.geo_code.map { |c| c.symbol }.should == %w(R/EC R/EU R/GE R/WEU)
  end

  it "geo_code[0].name.should == 'European Union'" do
    subject.geo_code[0].name.should == 'European Union'
  end

  # empty codes
  #
  its(:stat_code) { should == [] }
  its(:journal_code) { should == [] }
  its(:routing_code) { should == [] }
  its(:content_code) { should == [] }
  its(:function_code) { should == [] }

  # body / headline
  #
  its(:headline) { should == 'PRESS RELEASE: adidas Group: First Quarter 2008 Results' }
  its(:headline_brand) { should == nil }


  # body / text as html
  #
  it "html checksum should be 143f70beac7ca84f3d5f320afe602603e728ee72" do
    html_sha1sum.should == '5b2f356bb4bff2c6ccbe6ad70754952aff926235'
  end

  # body / text as plain text
  #
  it "text checksum should be 27a547372614d04b81c4334bb3902a8a7d980bd4" do
    text_sha1sum.should == '27a547372614d04b81c4334bb3902a8a7d980bd4'
  end

  it "Language should be 'en'" do
    subject.language.should == 'en'
  end

end

describe "DJNML.load('#{story_file_admin}') loads an  Dow Jones admin NML file and parses it." do
  before(:all) {
    @djnml = DJNML.load(story_file_admin)
  }
  subject { @djnml }

  let(:delete_0) { @djnml.delete.first }
  let(:delete_1) { @djnml.delete.last }

  it { should be }
  its(:msize) { should == 1968 }
  its(:md5) { should == '88d754f61ba4361c72a6a6dd0d2d00d5' }
  its(:seq) { should == 587 }
  its(:doc_date) { should == Time.parse('20120713') }

  its(:"delete.size") { should == 20 }

  it "should not have content" do
    subject.has_content?.should == false
  end

  it "delete.first.product should == 'LL'" do
    delete_0.product.should == 'LL'
  end

  it "delete.first.doc_date should == #{Time.parse('20110608')}" do
    delete_0.doc_date.should == Time.parse('20110608')
  end

  it "delete.first.seq should == 1579" do
    delete_0.seq.should == 1579
  end

  it "delete.first.publisher should == 'DJN'" do
    delete_0.publisher.should == 'DJN'
  end

  it "delete.first.reason should == 'expire'" do
    delete_0.reason.should == 'expire'
  end

  it "delete.last.product should == 'LL'" do
    delete_1.product.should == 'LL'
  end

  it "delete.last.doc_date should == #{Time.parse('20110608')}" do
    delete_1.doc_date.should == Time.parse('20110608')
  end

  it "delete.last.seq should == 1598" do
    delete_1.seq.should == 1598
  end

  it "delete.last.publisher should == 'DJN'" do
    delete_1.publisher.should == 'DJN'
  end

  it "delete.last.reason should == 'expire'" do
    delete_1.reason.should == 'expire'
  end

end
