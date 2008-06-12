/^VARS/||/^vars/{
	n = $2
	for (i=1;i<=n;i++) {
		getline
		print $1
	}
}
