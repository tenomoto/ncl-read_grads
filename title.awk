/^TITLE/||/^title/{
	for (i=2; i<NF-1; i++){
		printf("%s ",$i);
	}
	printf("%s\n", $NF);
}
