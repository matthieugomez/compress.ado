program define gzipappend
syntax  using, *

if regexm(`"`using'"',`"using (.*)"'){
	local file=regexs(1)
}
if regexm(`"`file'"',`""(.*)""'){
	local file=regexs(1)
}
splitpath `file'
local directory `r(directory)'
local filename `r(filename)'
local filetype `r(filetype)'

cap confirm file "`directory'`filename'.dta.gz"
if _rc{
	display as error "file `directory'`filename'.dta.gz not found"
	exit 4
}

tempfile tempfile

qui ! unpigz -p4 -c "`directory'/`filename'.dta.gz" >  "`tempfile'.dta"
append using  "`tempfile'.dta",`options'
qui !rm -r "`tempfile'.dta" 
end

