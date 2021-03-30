#! /bin/csh
foreach base_name (enc_scr run data output DB rpt log)
    if (!(-e $base_name) || (-l $base_name)) then
        mkdir -p $base_name
    endif
end

cd enc_scr

foreach aa (`\ls ${PDS}/pds_innovus/enc_scr/00.edi_setup.tcl`)
    set base_name = `basename $aa`
    if (!(-e $base_name) || (-l $base_name)) then
        if ($?PDS_TEST) then ;# for PDS test only
            ##ln -sf $aa $base_name
            cp -rf $aa $base_name
        else
            cp -rf $aa $base_name
        endif
    else
        echo INFO: File exists, skip link scripts : $base_name
    endif
end

## link install_proc tproc
#foreach dir (proc)
#    if (-e $dir) then
#    # $dir is exists
#        echo "INFO: File exists, skip link scripts : ./$dir/"
#    else
#        echo "INFO: ./$dir is not exists, link it from pds."
#        \ln -sf ${PDS}/pds_innovus/scr/$dir $dir
#        endif
#end
