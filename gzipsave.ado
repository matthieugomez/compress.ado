program define gzipsave
syntax anything [, replace Compression(integer 6) * ram]


splitpath `anything'
local directory `r(directory)'
local filename `r(filename)'
local filetype `r(filetype)'


cap confirm new file "`directory'`filename'.dta.gz"
if _rc  & "`replace'"==""  {
	display as error "file `directory'`filename'.dta.gz already exists"
	exit 602
}

if "`replace'"~=""{
	qui !rm -f "`directory'/`filename'.dta.gz" 
}



if "`ram'"~=""{
	qui memory
	local sizem=`r(data_data_u)' / 1000000
	tempfile ramdisk
	local ramdisk = subinstr("`ramdisk'", "/", "", .)
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
	qui !hdiutil eject /Volumes/`ramdisk'
}
end


program def ashell_gzipsave, rclass
version 8.0
syntax anything (name=cmd)
tempfile temp
shell `cmd' >> "`temp'"
tempname fh
local linenum =0
file open `fh' using "`temp'", read
file read `fh' line
 while r(eof)==0 {
  local linenum = `linenum' + 1
  scalar count = `linenum'
  return local o`linenum' = `"`line'"'
  return local no = `linenum'
  file read `fh' line
 }
file close `fh'

if("$S_OS"=="Windows"){
 shell del `temp'
}
else{
 shell rm `temp'
}
end
