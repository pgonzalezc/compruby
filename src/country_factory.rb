# Modulo IBAN creador de las factorias para los diferentes
# tipo de IBAN segun el país.
module IBAN
	$desc_parts = {
		'k' => 'check_digits',
		'b' => 'bank_code',
		's' => 'branch_code',
		'c' => 'account_number',
		'x' => 'national_check_digits',
		'n' => 'owner_account_number',
		'm' => 'currency',
		't' => 'account_type',
		'i' => 'Account_holder',
		'0' => 'zeroes',
		'a' => 'balance_account_number'
	}
	
	module CountryFactory
		def CountryFactory.get
			countries = {}
			File::readlines('../resources/iban_formats.txt').each do |iban_format|
				iban_format.chomp!.gsub!(' ','')
				country = iban_format[0,2]
				rest = iban_format[2,iban_format.size - 2].gsub(' ','')
				
				sections = get_sections(rest)
				regexp = sections_to_regexp(country,sections)
				
				countries[country] = regexp
			end
			countries
		end
		
		def CountryFactory.get_sections(from)
			idx = 0
			start = from[0]
			sections = {}
			from.each_char do |c|
				if c != start then
					sections[start] = idx
					idx = 1;start = c
				else
					idx += 1
				end
			end
			sections[start] = idx
			sections
		end #get_sections

		def CountryFactory.sections_to_regexp(country,sections)
			Regexp.new(sections.inject(country.to_s) do |res,assoc|
				letra,longitud = *assoc
				res + "(?'#{$desc_parts[letra]}'\\w{#{longitud}})"
			end)
		end #sections_to_regexp
	end #CountryFactory
	
	def self.countries
		CountryFactory.get
	end
	
	class Iban
		attr_reader :country
		
		def initialize(iban_str)
			parts = /([A-Z]{2})(.+)/.match(iban_str)
			@country = parts[1]
			@rest = parts[2]
			
			parts = IBAN::countries[@country].match(iban_str)
			
			raise 'invalid iban, bad pattern for country [#{@country}]' unless parts
			
			info_empty = $desc_parts.values.difference(parts.names).map do |name|
				[name,""]
			end
			info_iban = parts.names.zip(parts.captures) 
			info_iban.concat(info_empty).each do |name,value|
				define_singleton_method(name.to_sym) do 
					value
				end
			end
			
			raise 'invalid iban, can''t validate check digits' unless 
				validate_check_digits(@country,@rest)
		end #initialize
		
		def to_s
			"#{@country}#{@rest}"
		end
		
		private 
		def validate_check_digits(country,rest)
			# reorder charcter of iban string.
			check_digits = rest[0,2]
			bban = rest[2..]
			
			(bban + country + check_digits).upcase.chars.inject("") do |t,c|
				t + (((c >= '0') && (c <= '9')) ? c : ((c.ord - ?A.ord) + 10).to_s)
			end.to_i % 97 == 1
			
		end #validate_check_digits
	end #Iban

end #module IBAN