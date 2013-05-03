BEGIN{
  months["JAN"] =  1; months["FEB"] =  2; months["MAR"] =  3
  months["APR"] =  4; months["MAY"] =  5; months["JUN"] =  6
  months["JUL"] =  7; months["AUG"] =  8; months["SEP"] =  9
  months["OCT"] = 10; months["NOV"] = 11; months["DEC"] = 12
  units["mn"] = "minutes"; units["hr"] = "hours"
  units["dy"] = "days"; units["mo"] = "month"
  units["yr"] = "years"
}
/^TDEF/||/^tdef/{
  n = split($4,t,"Z")
  dd = substr(t[n],1,2)
  mm = months[toupper(substr(t[n],3,3))]
  yyyy = substr(t[n],6,4)
  
  if (n>1) {
    if (length(t[1])<=2) {
      hhmm = sprintf("%2d:00",t[1])
    } else {
      hhmm = t[1]
    } 
  }

  match($5, "[0-9]+")
  dt = substr($5, RSTART, RLENGTH)
  uu = units[tolower(substr($5, RSTART+RLENGTH, 2))]

  printf("%s from %d-%d-%d %s\n", uu, yyyy, mm, dd, hhmm)
  print $2
  print dt
}
