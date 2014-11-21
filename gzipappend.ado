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

tempfile tempfile

qui ! unpigz -p4 -c "`directory'/`filename'.dta.gz" >  "`tempfile'.dta"
append using  "`tempfile'.dta",`options'
qui !rm -r "`tempfile'.dta" 
end

