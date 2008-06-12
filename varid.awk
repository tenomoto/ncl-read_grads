/^VARS/||/^vars/{
	n = $2
	for (i=1;i<=n;i++) {
		getline
		if (varname==$1) {
			print i-1
			exit	
		}
	}
	print -999
}
