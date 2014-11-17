Read and write compressed .dta files using `zip` or `gzip` 

- These functions only work on Max OSX or Linux.

- Commands use/save/merge/joinby/append can be prefixed by `zip` or `gzip`.  All the usual options in these usual commands work as usual

	```R
	use "mydata"
	zipuse "mydata"
	gzipuse "mydata"
	```

- `zip` requires the command `unar`, while `gzip` requires the command `pigz` (parallel gzip). 

- Any suffix is ignored. In other words, the following commands give the same result
	
	```R
	gzipuse "/mydata.dta"
	gzipuse "/mydata.dta.gz"
	gzipuse "/mydata"
	```

- Experimental
	- Unzip/save in the RAM instead of a hard drive for OSX users. Use the option "ram"
	- Read `gzip` files using a pipe. I can't make it work on Yosemite. Some code that worked on OSX Maverick can be found in the `gipuse.ado` file.
