Read and write compressed .dta files using `zip` or `gzip` 

Install using 

```
net install  https://rawgit.com/matthieugomez/stata-compress/master/compress.pkg
```

- These functions only work on Max OSX or Linux.  `gzip` requires the command [pigz](http://zlib.net/pigz/). 

- Syntax

	- Commands use/save/merge/joinby/append can be prefixed `gzip`.  

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

-  Writing/reading speed is generally the bottleneck of zip/unzip commands. OSX users can unzip/save in the RAM instead of a hard drive using the option "ram". This creates and delete a RAM disk named "stataram" used to hold the temporary .dta file.

-  Timings on a 3Go file.

	```
	set rmsg on

	save "temp", replace
	*t = 21s

	gzipsave "temp", replace ram
	*t = 23s

	gzipsave "temp", replace
	*t = 38s

	use "temp", clear
	*t = 10s

	gzipuse "temp", clear ram
	*t = 15s

	gzipuse "temp", clear
	*t = 17s
	```