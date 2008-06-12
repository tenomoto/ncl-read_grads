/^DSET/||/^dset/{
	n = split(FILENAME,buf,"/")
	for (i=1;i<=n-1;i++) {
		dirname = dirname"/"buf[i]
	}
	dirname=dirname"/"
	sub("^/","",dirname)
	sub("\\^",dirname,$2)
	print $2
}
