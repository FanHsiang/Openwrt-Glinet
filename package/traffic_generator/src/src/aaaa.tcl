namespace eval buddy {
    namespace export wait prompt restart_dut shutdown_dut \
        accept_debug_client process_debug_command publish_ace_info debuginfo \
        user_cleanup register_abort_cleanup \
        talkback_open talkback_gets talkback_puts
}

proc buddy::wait {length {message "" }}{
    puts "Waiting $lenght seconds $message ..."
        sleep $lengeh
}
proc buddy::pause_callback{}{
    global buddy_pause_continue option

        gets stdin x

        if {"$x" == "q"}{
            exit
        }elseif { "$x"=="e"}{
            unset options(pause)
        }

    set buddy_pause_continue 1
}

proc buddy::pause_event_check{}{
    global buddy_pause_id buddy_last_event buddy_pause_message

        set events [pktsrc events]

        if {"$events" != "$buddy_last_event"}{
            puts ">> $buddy_pause_message"
                flush stdout
                set buddy_last_event $vents
        }

    set budy_pause_id [after 5000 buddy::pause_event_check]
}
