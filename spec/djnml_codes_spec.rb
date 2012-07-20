# encoding: UTF-8

require 'spec_helper'
require 'djnml/codes'

describe DJNML::Codes do

  it "DJNML::Codes.new() raises an ArgumentError" do
    expect { DJNML::Codes.new }.to raise_error(ArgumentError)
  end

  it "DJNML::Codes.new('ABCDE') ('ABCDE' being an unknown symbol) raises an ArgumentError" do
    expect { DJNML::Codes.new('ABCDE') }.to raise_error(ArgumentError)
  end

  it "DJNML::Codes.new('N/GEN').name.should == 'General News'" do
    DJNML::Codes.new('N/GEN').name.should == 'General News'
  end

  it "DJNML::Codes.new('I/AIR').name.should == 'Airlines'" do
    DJNML::Codes.new('I/AIR').name.should == 'Airlines'
  end

  it "DJNML::Codes.new('R/EU').name.should == 'Europe'" do
    DJNML::Codes.new('R/EU').name.should == 'Europe'
  end

  it "DJNML::Codes.new('G/JUS').name.should == 'Justice Department'" do
    DJNML::Codes.new('G/JUS').name.should == 'Justice Department'
  end

  it "DJNML::Codes.new('J/FDK').name.should == 'Food & Drink'" do
    DJNML::Codes.new('J/FDK').name.should == 'Food & Drink'
  end

  it "DJNML::Codes.new('M/EUR').name.should == 'Euro European Union'" do
    DJNML::Codes.new('M/EUR').name.should == 'Euro European Union'
  end

  it "DJNML::Codes.new('P/MWCM').name.should == 'Credit Markets'" do
    DJNML::Codes.new('P/MWCM').name.should == 'Credit Markets'
  end

  it "DJNML::Codes.new('S/GRGP').name.should == 'Greece GDP'" do
    DJNML::Codes.new('S/GRGP').name.should == 'Greece GDP'
  end
end
