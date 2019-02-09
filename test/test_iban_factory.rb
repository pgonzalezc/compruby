require 'test/unit'
require '../src/country_factory'

class TestIBANFactory < Test::Unit::TestCase
	
	def setup
		@countries = IBAN::CountryFactory.get
	end
	
	def test_iban_factory_get
		assert_equal(70,@countries.size)
		assert_not_nil(@countries['ES'])
		assert_nil(@countries['XX'])
	end #test_iban_factory_get
end 