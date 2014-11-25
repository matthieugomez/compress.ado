program define gzipuse
syntax anything [using] [if] [in][, clear replace ram multiplier(real 20)*]

qui memory
if  r(data_data_u) ~= 0 & "`clear'"=="" & "`replace'"==""{
	display as error "no; data in memory would be lost"
	exit 4
}

if `"`using'"'~=""{
	local vlist `anything'  using
	if regexm(`"`using'"',`"using (.*)"'){
		local file = regexs(1)
	}
}
else{
	local file `anything'
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

if "`ram'"~=""{
	filesize_temp "`directory'`filename'.dta.gz"
	local ramsize = 2048 * `multiplier' * ceil(`=r(MB)')
	tempfile ramdisk
	local ramdisk = subinstr("`ramdisk'", "/", "", .)
	qui !hdiutil eject /Volumes/`ramdisk'
	qui !diskutil erasevolume HFS+ "`ramdisk'" `hdiutil attach -nomount ram://`ramsize'`
	*''
	local tempfile "/Volumes/`ramdisk'/one"
}
else{
	tempfile tempfile
}

qui !unpigz -p4 -c "`directory'`filename'.dta.gz" >  "`tempfile'.dta"
qui use `vlist' "`tempfile'.dta" `if' `in',`options' `clear' `replace'
qui !rm -r "`tempfile'.dta" 
global S_FN = "`filename'.dta"

if "`ram'"~=""{
	qui !hdiutil eject /Volumes/`ramdisk'
}
end

/* 
 if "`pipe'"~=""{
 	* does not work in OS X Yosemite
 	tempfile myscriptfile mypipe
 	qui !rm -f "~/mypipe.dta"
 	qui !rm -f "~/myscriptfile"
 	cap file close myscript
 	qui file open myscript using "~/myscriptfile", write replace
 	file write myscript ///
 	`"mkfifo "~/mypipe.dta""' _n ///
 	`"unpigz -p4 -c "`directory'`filename'.dta.gz" > "~/mypipe.dta" &"'
 	file close myscript
 	! chmod 775 ~/myscriptfile
 	! ~/myscriptfile > /dev/null 2>&1 < /dev/null
 	qui use  `vlist' "~/mypipe.dta" `if' `in', `options' `clear' `replace'
 	qui !rm -f "~/mypipe.dta"
 	qui !rm -f "~/myscriptfile"

 	global S_FN = "`filename'.dta"
 }
  */


program define filesize_temp, rclass

	ashell_temp du -sk "`0'"
	if regexm(`"`r(o1)'"',"^([0-9]*).*"){
		local size = regexs(1) 
	}	
	return local KB = `size'
	return local MB = `size'/1000
	return local GB = `size'/1000000
end


program def ashell_temp, rclass
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



