program define gzipimport
syntax anything [using] [if] [in][, clear replace *]

qui memory
if  r(data_data_u) ~= 0 & "`clear'"=="" & "`replace'"==""{
	display as error "no; data in memory would be lost"
	exit 4
}
local anything=regexr("`anything'","delimited","")
if `"`using'"'~=""{
	local vlist `anything'  using
	if regexm(`"`using'"',`"using (.*)"'){
		local file=regexs(1)
	}
	local file:list clean file
}
else{
	local file `anything'
}
if regexm(`"`file'"',`""(.*)""'){
	local file=regexs(1)
}

if regexm(`"`file'"',`"^(.+)/([^/\.]+)(.*)$"'){
	local directory=regexs(1)
	local filename=regexs(2)
}
else{
	if regexm(`"`file'"',`"([^/\.]+)(.*)$"'){
		local directory ""
		local filename=regexs(1) 
	}
}

local directory: list clean directory
local filename: list clean filename
local file: list clean file


tempfile temp
if regexm(`"`temp'"',`"^(.+)/([^/\.]+)(.*)$"'){
	local tempdirectory=regexs(1)+"/"
}

tempfile myscript mypipe
qui !rm -r `mypipe'.csv
qui file open myscript using "`myscript'", write replace
file write myscript ///
`"mkfifo `mypipe'.csv"' _n ///
`"unpigz -p4 -c "`directory'/`filename'.csv.gz" > `mypipe'.csv &"'
file close myscript
! chmod 700 "`myscript'"
*! "`myscript'" 
! "`myscript'" > /dev/null 2>&1 < /dev/null
qui import delimited `vlist' `mypipe'.csv `if' `in',`options' `clear' `replace'
!rm -f `mypipe'.csv
global S_FN = "`filename'.csv"



end

