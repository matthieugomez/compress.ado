Read and write compressed .dta files using `zip` or `gzip` 

- These functions only work on Max OSX or Linux.

`zip` requires the command `unar`, while `gzip` requires the command `pigz` (parallel gzip). 

- Syntax

	- Commands use/save/merge/joinby/append can be prefixed by `zip` or `gzip`.  

		```R
		use "mydata"
		zipuse "mydata"
		gzipuse "mydata"
		```

	- All the usual options in these usual commands work as usual



	- Any suffix is ignored. In other words, the following commands give the same result
	
		```R
		gzipuse "/mydata.dta"
		gzipuse "/mydata.dta.gz"
		gzipuse "/mydata"
		```

-  OSX users can unzip/save in the RAM instead of a hard drive using the option "ram". 

-  Timings on a 3Go file.

	```
	set rmsg on

	save "temp", replace
	*t = 21s

	gzipsave "temp", replace ram
	*t = 23s

	gzipsave "temp", replace
	*t = 38s

	zipsave "temp", replace ram
	*t = 47s

	zipsave "temp", replace
	*t = 65s

	use "temp", clear
	*t = 10s

	gzipuse "temp", clear ram
	*t = 15s

	gzipuse "temp", clear
	*t = 17s

	zipuse "temp", clear ram
	*t = 25s

	zipuse "temp", clear
	*t = 68s
	```