/^XDEF/||/^xdef/{
  n = $2
  type = $3
  if (toupper(type)=="LINEAR") {
    x0 = $4
    dx = $5
    for (i=0;i<n;i++) {
      print x0 + dx*i
    }
  }else if (toupper(type)=="LEVELS") {
    for (i=4;i<=NF;i++) {
      print $i
    }
    i = NF - 3
    if (n>i) {
      while (i<n) {
        getline
        for (j=1;j<=NF;j++) {
          print $j
          i += 1
        }
      }
  } 
  }
} 
