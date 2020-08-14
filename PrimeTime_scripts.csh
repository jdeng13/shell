#!/usr/bin/tclsh
alias h history

alias rr report_timing -trans -nets -nos -through
alias rt  report_timing -cap -trans -nets -cross -nos -to
alias rtc report_timing -cap -trans -nets -cross -path full_clock_expanded -nos -to
alias rtm report_timing -cap -trans -nets -cross -delay min -nos -to
alias rf report_timing -cap -trans -nets -cross -path full_clock_expanded -delay min -nos -to
alias rfc report_timing -cap -trans -nets -cross -nos -from
alias rfm report_timing -cap -trans -nets -cross -path full_clock_expaned -nos -from
alias rfmc report_timing -cap -trans -nets -cross -delay min -nos -from
alias rth report_timing -cap -trans -nets -cross -delay min -nos -path full_clock_expaned -from
alias rthm report_timing -cap -trans -nets -cross -nos -through
alias rthm report_timing -cap -trans -nets -cross -delay min -nos -through

#alias rt   report_timing -cap -trans -cross -nos -to
#alias rtc  report_timing -cap -trans -cross -path full_clock_expanded -nos -to 
#alias rtm  report_timing -cap -trans -cross -delay min -nos -to
#alias rtmc report_timing -cap -trans -cross -path full_clock_expanded -delay min -nos -to 
#alias rf   report_timing -cap -trans -cross -nos -from
#alias rfc  report_timing -cap -trans -cross -path full_clock_expanded -nos -from 
#alias rfm  report_timing -cap -trans -cross -delay min -nos -from
#alias rth  report_timing -cap -trans -cross -nos -through
#alias rthm report_timing -cap -trans -cross -delay min -nos -through

alias afi all_fanin -flat -to
alias afo all_fanout -endpoint -flat -from
alias rc  report_cell -connections -verbose

alias s size_cell
alias i insert_buffer
alias ii insert_buffer -inverter_pair 
alias rm remove_buffer

alias w write_changes -format icctcl -output

alias rp report_constraints -all_violators -recovery -clock_gating_setup -max_delay -min_pulse_width -min_period -path slack_only -nosplit > 
alias rpm report_constraints -all_violators -removal -clock_gating_hold -min_delay -path slack_only -nosplit >
alias rpv report_timing -nosplit -delay_type max -input_pins -net -cap -transition -max_paths 100000 -slack_lesser_than 0.000 -nworst 100 >

alias ge  getEndByStart -delay max -pin
alias gs  getStartByEnd -delay max -pin
alias gel getEndByStart_l -delay max -pin
alias gsl getStartByEnd_l -delay max -pin
alias gem getEndByStart -delay min -pin 
alias geml getEndByStart_l -delay min -pin 
alias gsm getStartByEnd -delay min -pin 
alias gsml getStartByEnd_l -delay min -pin 
alias es  check_slack_window
alias cop collection_print

#######################noise#########################
#source ../scr/tproc/pdsReportNoiseBump.tcl -echo -verbose 
#pdsReportNoiseBump -output ../rpt/noise.rpt -bump_greater_than 0.28

set report_default_significant_digits 4

#=========================
proc check_slack_window {pin} {
  set slack 100
  set min_slack 100
  #foreach_in_col path [get_timing_paths -thro [get_pins $pin]] 
  foreach_in_col path [get_timing_paths -thro $pin] {
    set ss [get_attr $path slack]
    if {$ss < $slack} {
        set slack $ss      
    }
  }
  #foreach_in_col path [get_timing_paths -thro [get_pins $pin] -delay min] 
  foreach_in_col path [get_timing_paths -thro $pin -delay min] {
    set ss [get_attr $path slack]
    if {$ss < $min_slack} {
        set min_slack $ss   
    }
  }
  set ref [get_attr [get_cells -of_obj [get_pins $pin]] ref_name] 
  echo "\n(hold_slack) (setup_slack) (ref_name) (pin_name)" 
  echo "$min_slack $slack $ref $pin\n"
}

#=========================
proc collection_print {collection} {
  set list_temp [list ]
  foreach_in_collection temp [sort_coll $collection full_name] { 
    set f_name [get_attri $temp full_name]
    echo $f_name
  }
}

#=========================
proc getStartByEnd {args} {
    set procargs(-delay) ""
    set procargs(-pin)   ""
    parse_proc_arguments -args $args procargs 
    set delay  $procargs(-delay)
    set pin  $procargs(-pin)

    if {[get_pins $pin -quiet] == ""} {
        echo "Error parameter -pin is not exist"
    }
    if {$delay == "max"} {
        echo "Now...\nget_timing_paths -through $pin -slack_lesser_than 0 -delay_type max -start_end_pair\n......"
        set timingPath [eval "get_timing_paths -through $pin -slack_lesser_than 0 -delay_type max -start_end_pair"] 
    } elseif {$delay == "min" } {
        echo "Now...\nget_timing_paths -through $pin -slack_lesser_than 0 -delay_type min -start_end_pair\n......" 
        set timingPath [eval "get_timing_paths -through $pin -slack_lesser_than 0 -delay_type min -start_end_pair"]
        } else {
        echo "Error incorrect delay type only max and min support"
    }
    echo "Total $delay [sizeof_collection $timingPath] violation path found\n=================================="
  foreach_in_col path $timingPath {
    set startpoint [get_attr [get_attr $path startpoint] full_name] 
    set vio [get_attr $path slack]
    echo $startpoint $vio
  }
}

proc getStartByEnd_l {args} {
    set procargs(-delay) ""
    set procargs(-pin)   ""
    parse_proc_arguments -args $args procargs 
    set delay   $procargs(-delay)
    set pin   $procargs(-pin)

    if {[get_pins $pin -quiet] == ""} {
       echo "Error parameter -pin is not exist"
    }
    if {$delay == "max"} {
        echo "Now...\nget_timing_paths -through $pin -slack_lesser_than 0.03 -delay_type max -start_end_pair\n......"
        set timingPath [eval "get_timing_paths -through $pin -slack_lesser_than 100 -delay_type max -start_end_pair"] 
    } elseif {$delay == "min" } {
        echo "Now...\nget_timing_paths -through $pin -slack_lesser_than 0.03 -delay_type min -start_end_pair\n......" 
        set timingPath [eval "get_timing_paths -through $pin -slack_lesser_than 100 -delay_type min -start_end_pair"]
        } else {
        echo "Error incorrect delay type only max and min support"
    }
  echo "Total $delay [sizeof_collection $timingPath] violation path found\n====================================="
  foreach_in_col path $timingPath {
     set startpoint [get_attr [get_attr $path startpoint] full_name] 
     set vio   [get_attr $path slack]
     echo $startpoint $vio
  }
}

define_proc_attributes getStartByEnd_1 \
   -info "get timing path startPoint which have timing vio by Endpoint!" \
   -define_args {
      {-delay "Put the delay type max or min. Default is max" "<name>" string optional} 
      {-pin "Endpoint" "<name>" string required}
   }

define_proc_attributes getStartByEnd \
   -info "get timing path startPoint which have timing vio by Endpoint!" \
   -define_args {
      {-delay "Put the delay type max or min. Default is max" "<name>" string optional} 
      {-pin "Endpoint" "<name>" string required}
  }
#=======================
#get endPoint by start
proc getEndByStart {args} {
    set procargs(-delay) ""
    set procargs(-pin)   ""
    parse_proc_arguments -args $args procargs 
    set delay  $procargs(-delay)
    set pin   $procargs(-pin)

    if {[get_pins $pin -quiet] == ""} {
        echo "Error parameter -pin is not exist"
    }
    if {$delay == "max"} {
        echo "Now...\nget_timing_paths -through $pin -slack_lesser_than 0 -delay_type max\n...... "
        set timingPath [eval "get_timing_paths -through $pin -slack_lesser_than 0 -delay_type max -start_end_pair"] 
    } elseif {$delay == "min" } {
        echo "Now...\nget_timing_paths -through $pin -slack_lesser_than 0 -delay_type min\n"
        set timingPath [eval "get_timing_paths -through $pin -slack_lesser_than 0 -delay_type min -start_end_pair"]
        } else {
        echo "Error incorrect delay type only max and min support"
    }
    echo "Total $delay [sizeof_collection $timingPath] violation path found\n=====================================" 
    foreach_in_col path $timingPath {
       set endpoint [get_attr [get_attr $path endpoint] full_name] 
       set vio [get_attr $path slack]
       echo $endpoint $vio
    }
}

define_proc_attributes getEndByStart \
   -info "get timing path endpoint which have timing vio by startPoint!" \ 
   -define_args {
       {-delay "Put the delay type max or min. Default is max" "<name>" string optional} 
       {-pin  "startPoint" "<name>" string required}
   }

   proc getEndByStart_l {args} {
   set procargs(-delay) ""
   set procargs(-pin)   ""
   parse_proc_arguments -args $args procargs 
   set delay  $procargs(-delay)
   set pin  $procargs(-pin)

   if {[get_pins $pin -quiet] == ""} {
      echo "Error parameter -pin is not exist"
   }
   if {$delay == "max"} {
      echo "Now...\nget_timing_paths -through $pin -slack_lesser_than 0.03 -delay_type max\n......"
      set timingPath [eval "get_timing_paths -through $pin -slack_lesser_than 100 -delay_type max -start_end_pair"] 
   } elseif {$delay == "min" } {
      echo "Now...\nget_timing_paths -through $pin -slack_lesser_than 0.03 -delay_type min\n"
      set timingPath [eval "get_timing_paths -through $pin -slack_lesser_than 100 -delay_type min -start_end_pair"]
      } else {
      echo "Error incorrect delay type only max and min support"
   }
   echo "Total $delay [sizeof_collection $timingPath] violation path found\n======================================"
   foreach_in_col path $timingPath {
      set endpoint [get_attr [get_attr $path endpoint] full_name]
      set vio  [get_attr $path slack]
   }  echo $endpoint $vio
}

define_proc_attributes getEndByStart_1 \
   -info "get timing path endpoint which have timing vio by startPoint!" \ 
   -define_args {
     {-delay "Put the delay type max or min. Default is max" "<name>" string optional} 
     {-pin "startPoint" "<name>" string required}
 }

proc f_all {end file} {

    #echo "--------------------------------"
    #echo "all start point to end"
    #echo "--------------------------------"
    #echo [format "%-15s%-15s%-100s%-100s" "setup" "hold" "start_point" "end_point"] 
    if {[sizeof_collection [get_pins $end]]} {
      set all_pin_ports [get_pins $end]
    } elseif {[sizeof_collection [get_ports $end]]} {
      set all_pin_ports [get_ports $end] 
    } else {
      puts "Error"; return
    }
    foreach_in_collection tmp $all_pin_ports {

        set pin_name [get_attri $tmp full_name]
        # echo "endpoint : $pin_name"
        alias afi "all_fanin -flat -startpoints_only -trace_arcs all -to"

        foreach_in_collection start_point  [afi $pin_name]  {
            suppress_message {UITE-416}
            set start_poi [get_attri $start_point full_name]
            set setup_timing_path [get_timing_path -from $start_poi -to $pin_name -delay max] 
            set hold_timing_path [get_timing_path -from $start_poi -to $pin_name -delay min]

            set setup_slack [get_attri $setup_timing_path slack] 
            set hold_slack [get_attri $hold_timing_path slack]

            #if {$setup_slack == "INFINITY" || $hold_slack == "INFINITY" || ($setup_slack>0.02)} { 
            #} else {
            #   echo [format "%-15s%-15s%-100s" "$setup_slack" "$hold_slack" "$start_poi"]
            #}
            # echo [format "%-15s%-15s%-100s" "$setup_slack" "$hold_slack" "$start_poi"] 
            echo "report_timing -from $start_poi -to $pin_name >> $file"
            unsuppress_message {UITE-416}
          }
    }
}



proc gcl {pin} {
    get_attribute [get_pins $pin ] clocks

}
proc afol {pin}     {
    foreach a [get_attri [afo $pin] full_name  ] {puts $a}
}
