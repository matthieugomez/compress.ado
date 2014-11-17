program define gzipuse
syntax anything [using] [if] [in][, clear replace ram *]

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
	local file: list clean file
}
else{
	local file `anything'
}

splitpath `file'
local directory `r(directory)'
local filename `r(filename)'
local filetype `r(filetype)'

if "`ram'"~=""{
	qui memory
	local sizem=`r(data_data_u)'/1000000
	local ramsize = 2048*ceil(`sizem')
	qui !hdiutil eject /Volumes/stataramdisk
	qui !diskutil erasevolume HFS+ "stataramdisk" `hdiutil attach -nomount ram://`ramsize'`
	*''
	local tempfile "/Volumes/stataramdisk/one"
}
else{
	tempfile tempfile
}

qui ! unpigz -p4 -c "`directory'`filename'.dta.gz" >  "`tempfile'.dta"
qui use `vlist' "`tempfile'.dta" `if' `in',`options' `clear' `replace'
qui !rm -r "`temp'"
global S_FN = "`filename'.dta"

if "`ram'"~=""{
	qui !hdiutil eject "/Volumes/stataramdisk"
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