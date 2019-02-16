require 'test/unit'
require '../src/country_factory'

class TestIBANFactory < Test::Unit::TestCase
	
	def setup
		@countries = IBAN::countries
		@iban_es = "ES5621001111301111111111"
		@iban_by = "BY13NBRB3600900000002Z00AB00"
		@iban_bu = "BG80BNBG96611020345678"
		@iban_cy = "CY17002001280000001200527600"
		@bad_iban = "ES562100111131001111111"
	end
	
	def test_iban_factory_get
		assert_equal(70,@countries.size)
		assert_not_nil(@countries['ES'])
		assert_nil(@countries['XX'])
	end #test_iban_factory_get
	
	def test_iban
		assert_equal(IBAN::Iban.new(@iban_es).to_s,@iban_es)
		assert_equal(IBAN::Iban.new(@iban_by).balance_account_number,"3600")
		assert_equal(IBAN::Iban.new(@iban_bu).account_type,"10")
		assert_equal(IBAN::Iban.new(@iban_cy).account_number,"0000001200527600")
		assert_raises { IBAN::Iban.new(@bad_iban) }
	end #test_iban
end 