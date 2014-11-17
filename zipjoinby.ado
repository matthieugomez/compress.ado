program define zipjoinby
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
local filename `r(filename)'
local filetype `r(filetype)'

tempfile temp
splitpath `temp'
local tempdirectory `r(directory)'


qui !unar -f  "`directory'/`filename'.zip" -o "`tempdirectory'"
joinby `anything' using "`tempdirectory'`filename'",`options'
end

