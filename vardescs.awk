/^VARS/||/^vars/{
	n = $2
	for (i=1;i<=n;i++) {
		getline
		desc = ""
		for (j=4;j<=NF;j++) {
			desc = desc $j " "
		}
		print desc
	}
}
