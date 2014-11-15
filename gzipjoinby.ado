program define gzipjoinby
syntax anything using, *

if regexm(`"`using'"',`"using (.*)"'){
	local file=regexs(1)
}
local file: list clean file
if regexm(`"`file'"',`""(.*)""'){
	local file=regexs(1)
}

splitpath `file'
local directory `r(directory)'
local filename `filename'
local filetype `filetype'

tempfile tempfile

qui ! unpigz -p4 -c "`directory'/`filename'.dta.gz" >  "`tempfile'.dta"
joinby `anything' using "`tempfile'.dta", `options'
end


