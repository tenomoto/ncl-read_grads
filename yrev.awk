BEGIN { d=1 }
/^OPTIONS/||/^options/ {
  if (tolower($0) ~ "yrev") {
    d = -1
  } 
}
END { print d }
