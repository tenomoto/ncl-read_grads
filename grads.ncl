undef("runawk")
undef("grads_addfile")
undef("grads_time")
undef("grads_read")
awk = "/usr/bin/awk -f $HOME/local/lib/ncarg/nclscripts/grads/"

function runawk(s:string, f:string)
begin
  return(systemfunc(awk+s+" "+f))
end

function grads_addfile(f:string)
local obuf, nv, nls
begin
  ctl = f
  ctl@grd = runawk("dset.awk",f)
  ctl@title = runawk("title.awk",f)
  ctl@undef = stringtofloat(runawk("undef.awk",f))
  ctl@lev = stringtofloat(runawk("zdef.awk",f))
  ctl@lev = ctl@lev(::stringtoshort(runawk("zrev.awk",f)))
  ctl@lat = stringtofloat(runawk("ydef.awk",f))
  ctl@lat = ctl@lat(::stringtoshort(runawk("yrev.awk", f)))
  ctl@lon = stringtofloat(runawk("xdef.awk ",f))
  ctl@varnames = runawk("varnames.awk ",f)
  ctl@varlevs = stringtointeger(runawk("varlevs.awk ",f))
  obuf = ctl@varlevs
  obuf = 0
  nv = dimsizes(ctl@varnames)
  nls = ctl@varlevs > 1
  do i=1, nv-1
    obuf(i) = obuf(i-1) + nls(i-1)
  end do
  ctl@offsets = obuf
  ctl@nlevs = ctl@offsets(nv-1) + nls(i-1)
    
  ctl@vardescs = runawk("vardescs.awk ",f)
  return(ctl)
end 

function grads_time(f:string)
local tbuf, n, d
begin
  tbuf = runawk("tdef.awk",f)
  n = stringtointeger(tbuf(1))
  d = stringtointeger(tbuf(2))
  t = fspan(0, (n-1)*d, n)
  t@units = tbuf(0)
  return(t)
end

function grads_read(ctl:string, varname:string, r:integer)
local lev, nz, lat, ny, lon, nx, i
begin
  lev = ctl@lev
  lev!0 = "lev"
  lev&lev = lev
  if (max(lev).gt.1) then
    if ((min(lev).lt.250).or.(max(lev).gt.2000)) then
      ctl@lev_long_name = "pressure"
      if (max(lev).gt.1100.) then
        lev@units = "Pa"
      else
        lev@units = "hPa"
      end if  
    else
      lev@long_name = "theta"
    end if
  else
    lev@long_name = "sigma"
    lev@units = ""
  end if
  nz = dimsizes(lev)

  lat = ctl@lat
  lat!0 = "lat"
  lat&lat = lat
  lat@units = "degrees_north"
  ny = dimsizes(lat)

  lon = ctl@lon
  lon!0 = "lon"
  lon&lon = lon
  lon@units = "degrees_east"
  nx = dimsizes(lon)

  varid = stringtointeger(runawk("varid.awk varname="+varname,ctl))
  if (varid.lt.0) then
    print("variable not found in "+ctl)
    exit
  end if

  nl = ctl@varlevs(varid)
  
  is = (ctl@nlevs)*r + ctl@offsets(varid)
  if (nl.eq.0) then
    x = new((/ny, nx/), "float")
    x = fbindirread(ctl@grd, is, (/ny, nx/), "float")
    x!0 = "lat"
    x&lat = lat
    x!1 = "lon"
    x&lon = lon
  else
    x = new((/nl, ny, nx/), "float")
    do i=0, nl-1
      rec = i+is 
      x(i,:,:) = fbindirread(ctl@grd, rec, (/ny, nx/), "float")
    end do
    x!0 = "lev"
    x&lev = lev(0:nl-1)
    x!1 = "lat"
    x&lat = lat
    x!2 = "lon"
    x&lon = lon
  end if
  x@_FillValue = ctl@undef
  return(x)
end
