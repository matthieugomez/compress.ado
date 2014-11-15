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

/*  
qui ashell du -sm "`directory'/`filename'.zip"
if regexm(`"`r(o1)'"',"^([0-9]*).*"){
	local size=regexs(1) 
}	
*size is in megabytes
if `size'>14000/25 | `size'<100{
	tempfile temp
	if regexm(`"`temp'"',`"^(.+)/([^/\.]+)(.*)$"'){
		local tempdirectory=regexs(1)
	}
}
else{
	qui !osascript  -e 'tell application "Finder" to eject (every disk whose name starts with "ram")'
	local ramsize=2048*`size'*25
	qui !diskutil erasevolume HFS+ "ramdisk" `hdiutil attach -nomount ram://`ramsize'`
	*''
	local tempdirectory "/Volumes/ramdisk 1/"
}
*/




*cap local allfiles: dir "/Volumes/RAMDisk" files *
*if _rc~=0{
	
*}
*else{
*	!rm -r /Volumes/RAMDisk
*	local tempdirectory /Volumes/RAMDisk/
*}

*!unzip -oj  "`file'"  -d "`tempdirectory'"
*!chmod 644 "`tempdirectory'`filename'.dta"




/***************************************************************************************************
basically:
!unar -f  "$DataPath/compustat/bank/bank_fundq.zip"  -o "$SavePath"
use "$SavePath/bank_fundq", clear 
erase "$SavePath/bank_fundq.dta"
***************************************************************************************************/