!#/bin/csh
alias h history
alias rt report_timing -nos -cap -trans -nets -cross -to
alias rtc report_timing -nos -cap -trans -nets -cross -path full_clock_expanded -to
alias rtm report_timing -nos -cap -trans -nets -cross -delay min -to
alias rtmc report_timing -nos -cap -trans -nets -cross -path full_clock_expanded -delay min -to

alias rf report_timing -nos -cap -trans -nets -cross -from
alias rfc report_timing -nos -cap -trans -nets -cross -path full_clock_expanded -from
alias rfm report_timing -nos -cap -trans -nets -cross -delay min -from

alias rth  report_timing -nos -cap -trans -nets -cross -through
alias rthm report_timing -nos -cap -trans -nets -cross -slack_lesser_than 0 -delay min -through

alias afo "all_fanout -flat -endpoints_only -only_cells -trace_arcs all -from"
alias afop "all_fanout -flat -endpoints_only -trace_arcs all -from"
alias afi "all_fanin -flat -startpoints_only -only_cells -trace_arcs all -to"
alias afip "all_fanin -flat -startpoints_only -trace_arcs all -to"
#alias afi all_fanin -flat -level 1 -to 
#alias afo all_fanout -flat -level 1 -from

alias s size_cell                           
alias i insert_buffer                       
alias ii insert_buffer -inverter_pair       
alias rm remove_buffer
                                            
alias w write_changes -format icctcl -output
                                            
alias rnc report_noise_calculation

#################################################################################### 
set jsFixRptDir "../rpt/fix"

if {[file exists $jsFixRptDir]} {
    if {[file isdirectory $jsFixRptDir]!=1} { 
       exec my $jsFixRptDir ${jsFixRptDir}.bak 
       exec mkdir $jsFixRptDir
    }
} else {
    exec mkdir $jsFixRptDir
}
alias rpt_cap "report_constraint -max_capacitance -all_violators -nosplit > $jsFixRptDir/cap.repair"
alias rpt_trans_pds "pdsGetTransitionViolation $jsFixRptDir/trans.repair.pds 0.3 "
alias rpt_trans "report_constraint -max_transition -all_violators -nosplit > $jsFixRptDir/trans .repair "

alias rpt_noise "pdsReportNoiseBump -bump_greater_than 0.28 -output $jsFixRptDir/noise.repair "

alias rpt_setup "report_constraints -all_violators -recovery -clock_gating_setup -max_delay -min_pulse_width -min_period -path slack_only -nosplit > $jsFixRptDir/setup.repair"
alias rpt_setup_verbose "report_timing -delay_type max -input_pins -net -cap -transition -max_paths 50000 -slack_lesser_than 0.000 -nworst 25 -nosplit > $jsFixRptDir/setup.repair.verbose" ; # -start_end_pair

alias rpt_hold "report_constraints -all_violators -removal -clock_gating_hold -min_delay -path slack_only -nosplit > $jsFixRptDir/hold.repair"
alias rpt_hold_verbose "report_timing -nosplit -delay_type min -input_pins -net -cap -transition -max_paths 5000 -slack_lesser_than -0.000 > $jsFixRptDir/hold.repair.verbose" ; # -start_end_pair            
#treport_timing -input_pin -nosplit -nets -transition_time -capacitance -max_path 200000 -slack_lesser_than 0 -nworst 10 -delay_type min > EMMC_timing.hold_$


#alias rp report_constraints -all_violators -recovery -clock_gating_setup -max_delay -min_pulse_width -min_period -path slack_only -nosplit >                                                                 
#alias rpv report_timing -nosplit -delay_type max -input_pins -net -cap -transition -max_paths 5000 -slack_lesser_than 0.000 -nworst 100 >
#alias rpm report_constraints -all_violators -removal -clock_gating_hold -min_delay -path slack_only -nosplit >
