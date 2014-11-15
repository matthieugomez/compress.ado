program define gzipuse
syntax anything [using] [if] [in][, clear replace pipe *]

qui memory
if  r(data_data_u) ~= 0 & "`clear'"=="" & "`replace'"==""{
	display as error "no; data in memory would be lost"
	exit 4
}

if `"`using'"'~=""{
	local vlist `anything'  using
	if regexm(`"`using'"',`"using (.*)"'){
		local file = regexs(1)
	}
	local file: list clean file
}
else{
	local file `anything'
}

splitpath `file'
local directory `r(directory)'
local filename `filename'
local filetype `filetype'

if "`pipe'"~=""{
	* does not work in OS X Yosemite
	tempfile myscript mypipe
	qui !rm -f `mypipe'.dta
	qui file open myscript using "`myscript'", write replace
	file write myscript ///
	`"mkfifo `mypipe'.dta"' _n ///
	`"unpigz -p4 -c "`directory'/`filename'.dta.gz" > "`mypipe'.dta" &"'
	file close myscript
	! chmod 700 "`myscript'"
	! "`myscript'" > /dev/null 2>&1 < /dev/null
	qui use  `vlist' "`mypipe'.dta" `if' `in',`options' `clear' `replace'
	!rm -f "`mypipe'.dta"
	global S_FN = "`filename'.dta"
}
else{
	tempfile tempfile
	qui ! unpigz -p4 -c "`directory'/`filename'.dta.gz" >  "`tempfile'.dta"
	qui use `vlist' "`tempfile'.dta" `if' `in',`options' `clear' `replace'
	qui !rm -r "`temp'"
	global S_FN = "`filename'.dta"
}
end

