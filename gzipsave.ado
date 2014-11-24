program define gzipsave
syntax anything [, replace Compression(integer 6) * ram]


splitpath `anything'
local directory `r(directory)'
local filename `r(filename)'
local filetype `r(filetype)'


local files : dir "`directory'" files `"`filename'.dta.gz"'
if "`files'"~="" & "`replace'"==""  {
	display as error "file `anything' already exists"
	exit 602
}

if "`replace'"~=""{
	qui !rm -f "`directory'/`filename'.dta.gz" 
}



if "`ram'"~=""{
	qui memory
	local sizem=`r(data_data_u)' / 1000000
	tempname ramdisk
	local ramsize = 2048 * ceil(`sizem')
	qui !hdiutil eject /Volumes/`ramdisk'
	qui !diskutil erasevolume HFS+ "`ramdisk'" `hdiutil attach -nomount ram://`ramsize'`
	*''
	local tempdirectory "/Volumes/`ramdisk'/"
}
else{
	tempfile temp
	splitpath `temp'
	local tempdirectory `r(directory)'
}
qui save "`tempdirectory'`filename'.dta", replace
qui !cd "`tempdirectory'"  &&  pigz -c -f -`compression' -p4  "`filename'.dta" > "`directory'`filename'.dta.gz" && rm "`filename'.dta" 

if "`ram'"~=""{
	qui !umount `tempdirectory'
	qui !hdiutil eject `tempdirectory'
}
end

