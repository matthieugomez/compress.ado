program define zipappend
syntax  using, *

if regexm(`"`using'"',`"using (.*)"'){
	local file=regexs(1)
}
if regexm(`"`file'"',`""(.*)""'){
	local file=regexs(1)
}
local file: list clean file
if regexm(`"`file'"',`"^(.+)/([^/\.]+)(.*)$"'){
	local directory=regexs(1)
	local filename=regexs(2)
}
else{
	if regexm(`"`file'"',`"([^/\.]+)(.*)$"'){
		local directory ""
		local filename=regexs(1) 
		local filetype=regexs(2)
	}
}
local directory: list clean directory
local filename: list clean filename
local file: list clean file

tempfile temp
if regexm(`"`temp'"',`"^(.+)/([^/\.]+)(.*)$"'){
	local tempdirectory=regexs(1)+"/"
}
qui !unar -f  "`directory'/`filename'.zip" -o "`tempdirectory'"
append using "`tempdirectory'`filename'",`options'
end

