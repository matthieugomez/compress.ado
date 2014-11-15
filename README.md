Read and write compressed .dta files using `zip` or `gzip`


- Commands use/save/merge/joinby/append can be prefixed by `zip` or `gzip`. `zip` requires the command `unar`, while `gzip` requires the command `pigz` (parallel gzip).  All the supplementary options in these usual commands work as usual

	```R
	use "mydata"
	zipuse "mydata"
	gzipuse "mydata"
	```

- Any suffix is ignored. In other words, the following commands give the same result
	
	```R
	gzipuse "/mydata.dta"
	gzipuse "/mydata.dta.gz"
	gzipuse "/mydata"
	```

- `gzip` makes more sense than `zip` to compress individual `dta` files

- I'd like to read `gzip` files using a pipe but I can't make it work on Yosemite. Any tip is welcome.