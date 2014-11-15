program define zipuse
syntax anything [using] [if] [in][, clear replace *]

qui memory
if  r(data_data_u) ~= 0 & "`clear'"=="" & "`replace'"==""{
	display as error "no; data in memory would be lost"
	exit 4
}

if `"`using'"'~=""{
	local vlist `anything'  using
	if regexm(`"`using'"',`"using (.*)"'){
		local file=regexs(1)
	}
}
else{
	local file `anything'
}

splitpath `file'
local directory `r(directory)'
local filename `filename'
local filetype `filetype'

tempfile temp
splitpath `temp'
local tempdirectory `r(directory)'

qui !unar -f  "`directory'/`filename'.zip" -o "`tempdirectory'"
qui use `vlist' "`tempdirectory'/`filename'" `if' `in',`options' `clear' `replace'
qui !rm -r "`temp'"

end
