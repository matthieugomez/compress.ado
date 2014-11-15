program define zipsave
syntax anything [if] [in] [, replace clear *]

parsepath `file'
local directory `r(directory)'
local filename `filename'
local filetype `filetype'


local files : dir "`directory'" files `"`filename'.zip"'
if "`files'"~="" & "`replace'"=="" & "`clear'"=="" {
	display as error "file `anything' already exists"
	exit 602
}

tempfile temp
parsepath `temp'
local tempdirectory `r(directory)'


qui !rm "`directory'/`filename'.zip" 
qui save "`tempdirectory'`filename'.dta", replace


qui !cd "`tempdirectory'" && zip -o "`directory'/`filename'.zip" "`filename'.dta" && rm "`tempdirectory'`filename'.dta" 

end
