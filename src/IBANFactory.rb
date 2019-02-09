module IBAN
	$desc_parts = {
		'k' => 'check_digits',
		'b' => 'bank_account',
		's' => 'branch_code',
		'c' => 'account_number',
		'x' => 'national_check_digits',
		'n' => 'owner_account_number',
		'm' => 'currency',
		't' => 'account_type',
		'i' => 'Account_holder',
		'0' => 'zeroes',
		'a' => 'balance_acount_number'
	}
	
	module CountryFactory
		def CountryFactory.get
			countries = {}
			DATA.each do |iban_format|
				iban_format.chomp!.gsub!(' ','')
				country = iban_format[0,2]
				rest = iban_format[2,iban_format.size - 2].gsub(' ','')
				
				sections = get_sections(rest)
				regexp = sections_to_regexp(country,sections)
				
				countries[country] = regexp
			end
			countries
		end
		
		private
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
				res + "(?'#{$desc_parts[letra]}'\\d{#{longitud}})"
			end)
		end #sections_to_regexp
	end

end #module IBAN

include IBAN

$stdout << CountryFactory.get['ES'].source << "\n"


__END__
ALkk bbbs sssx cccc cccc cccc cccc
ADkk bbbb ssss cccc cccc cccc
ATkk bbbb bccc cccc cccc
AZkk bbbb cccc cccc cccc cccc cccc
BHkk bbbb cccc cccc cccc cc
BYkk bbbb aaaa cccc cccc cccc cccc
BEkk bbbc cccc ccxx
BAkk bbbs sscc cccc ccxx
BRkk bbbb bbbb ssss sccc cccc ccct n
BGkk bbbb ssss ttcc cccc cc
CRkk 0bbb cccc cccc cccc cc
HRkk bbbb bbbc cccc cccc c
CYkk bbbs ssss cccc cccc cccc cccc
CZkk bbbb ssss sscc cccc cccc
DKkk bbbb cccc cccc cc
DOkk bbbb cccc cccc cccc cccc cccc
TLkk bbbc cccc cccc cccc cxx
EEkk bbss cccc cccc cccx
FOkk bbbb cccc cccc cx
FIkk bbbb bbcc cccc cx
FRkk bbbb bsss sscc cccc cccc cxx
GEkk bbcc cccc cccc cccc cc
DEkk bbbb bbbb cccc cccc cc
GIkk bbbb cccc cccc cccc ccc
GRkk bbbs sssc cccc cccc cccc ccc
GLkk bbbb cccc cccc cc
GTkk bbbb mmtt cccc cccc cccc cccc
HUkk bbbs sssx cccc cccc cccc cccx
ISkk bbbb sscc cccc iiii iiii ii
IEkk aaaa bbbb bbcc cccc cc
ILkk bbbn nncc cccc cccc ccc
ITkk xbbb bbss sssc cccc cccc ccc 
JOkk bbbb ssss cccc cccc cccc cccc cc
KZkk bbbc cccc cccc cccc
XKkk bbbb cccc cccc cccc
KWkk bbbb cccc cccc cccc cccc cccc cc
LVkk bbbb cccc cccc cccc c
LBkk bbbb cccc cccc cccc cccc cccc
LIkk bbbb bccc cccc cccc c
LTkk bbbb bccc cccc cccc
LUkk bbbc cccc cccc cccc
MKkk bbbc cccc cccc cxx
MTkk bbbb ssss sccc cccc cccc cccc ccc
MRkk bbbb bsss sscc cccc cccc cxx
MUkk bbbb bbss cccc cccc cccc 000m mm
MCkk bbbb bsss sscc cccc cccc cxx
MDkk bbcc cccc cccc cccc cccc
MEkk bbbc cccc cccc cccc xx
NLkk bbbb cccc cccc cc
NOkk bbbb cccc ccx
PKkk bbbb cccc cccc cccc cccc
PSkk bbbb xxxx xxxx xccc cccc cccc c
PLkk bbbs sssx cccc cccc cccc cccc
PTkk bbbb ssss cccc cccc cccx x
QAkk bbbb cccc cccc cccc cccc cccc c
ROkk bbbb cccc cccc cccc cccc
SMkk xbbb bbss sssc cccc cccc ccc
SAkk bbcc cccc cccc cccc cccc
RSkk bbbc cccc cccc cccc xx
SKkk bbbb ssss sscc cccc cccc
SIkk bbss sccc cccc cxx
ESkk bbbb ssss xxcc cccc cccc
SEkk bbbc cccc cccc cccc cccc
CHkk bbbb bccc cccc cccc c
TNkk bbss sccc cccc cccc cccc
TRkk bbbb bxcc cccc cccc cccc cc
AEkk bbbc cccc cccc cccc ccc
GBkk bbbb ssss sscc cccc cc
VAkk bbbc cccc cccc cccc cc
VGkk bbbb cccc cccc cccc cccc
