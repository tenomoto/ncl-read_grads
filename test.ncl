load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$HOME/local/lib/ncarg/nclscripts/grads/grads.ncl"

begin
; This example reads JMA GPV converted by jmagpv
; change file name below
  f = grads_addfile("/Volumes/data/GPV/20020808/gsm00x024.ctl")

  print(f@varnames)
  print(f@lev)
  wks = gsn_open_wks("x11", "test")
  do i=0, dimsizes(f@varnames)-1
    print(f@varnames(i))
    x = grads_read(f,f@varnames(i),0)
    if (dimsizes(dimsizes(x)).gt.2) then
      plot = gsn_csm_contour_map_ce(wks, x({1000},:,:), False)
    else
      plot = gsn_csm_contour_map_ce(wks, x, False)
    end if
    delete(x)
  end do
end
