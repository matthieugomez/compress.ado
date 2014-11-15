program define gzipsave
syntax anything [if] [in] [, replace clear Compression(integer 6) *]


splitpath `anything'
local directory `r(directory)'
local filename `filename'
local filetype `filetype'


local files : dir "`directory'" files `"`filename'.dta.gz"'
if "`files'"~="" & "`replace'"=="" & "`clear'"=="" {
	display as error "file `anything' already exists"
	exit 602
}

if "`replace'"~=""{
	qui !rm -f "`directory'/`filename'.dta.gz" 
}



tempfile temp
if regexm(`"`temp'"',`"^(.+)/([^/\.]+)(.*)$"'){
	local tempdirectory=regexs(1)+"/"
	local tempname=regexs(2)
}	



qui save "`tempdirectory'`filename'.dta", replace
qui !cd "`tempdirectory'"  &&  pigz -c -f -`compression' -p4  "`filename'.dta" > "`directory'/`filename'.dta.gz" && rm "`file'" 


/* Try to  unzip in ram. Any feedback welcome 
qui memory
local sizem=`r(data_data_u)'/1000000
if `sizem'>20{
	local ramsize=2048*`sizem'
	qui !osascript  -e 'tell application "Finder" to eject (every disk whose name starts with "ram")'
	qui !hdiutil eject /Volumes/ramdisk*

	qui !diskutil erasevolume HFS+ "ramdisk" `hdiutil attach -nomount ram://`ramsize'`
	*''
	local tempdirectory "/Volumes/ramdisk 1/"
}
else{
	tempfile temp
	if regexm(`"`temp'"',`"^(.+)/([^/\.]+)(.*)$"'){
		local tempdirectory=regexs(1)
	}
}
*else{
*	!rm -r /Volumes/RAMDisk
*	local tempdirectory /Volumes/RAMDisk/
*}
/*  
if `sizem'>20{
	!cd "`tempdirectory'" && zip -o "`directory'/`filename'.zip" "`filename'.dta" && osascript  -e 'tell application "Finder" to eject (every disk whose name starts with "ram")'
}
else{
	!cd "`tempdirectory'" && zip -o "`directory'/`filename'.zip" "`filename'.dta" && rm "`tempdirectory'`filename'.dta" 
}
*/
end

