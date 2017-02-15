DEFINE listbox RECORD
    listbox1 STRING,
    listbox2 STRING,
    listbox3 STRING,
    listbox4 STRING
END RECORD
DEFINE listbox_values DYNAMIC ARRAY OF STRING



-- Listbox pattern, used to simulate a LISTBOX widget (http://en.wikipedia.org/wiki/List_box)
-- Characteristics of pattern is a DISPLAY ARRAY statement used at the same time
-- as one or more INPUT or CONSTRUCT statements, and the TABLE is embedded amongst
-- the other widgets
FUNCTION ifx_listbox()
    CALL init()
    CALL open_window()
    DISPLAY ARRAY listbox_values TO listbox.*
        BEFORE DISPLAY
            CALL ui.Interface.Refresh()
            EXIT DISPLAY
    END DISPLAY
         
    INPUT BY NAME listbox.listbox1, listbox.listbox2, listbox.listbox4 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        ON ACTION select ATTRIBUTES(TEXT="Select")
            DISPLAY ARRAY listbox_values TO listbox.*
                AFTER DISPLAY
            END DISPLAY
            LET int_flag = 0
    END INPUT
    CALL close_window()
END FUNCTION



FUNCTION gmd_listbox()
    CALL init()
    CALL open_window()
    DIALOG
        INPUT BY NAME listbox.listbox1, listbox.listbox2, listbox.listbox4 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        END INPUT

        DISPLAY ARRAY listbox_values TO listbox.*
        END DISPLAY

        BEFORE DIALOG
            CALL DIALOG.setSelectionMode("listbox", TRUE)

        ON ACTION CLOSE
            EXIT DIALOG

        ON ACTION accept
            EXIT DIALOG

        ON ACTION cancel
            EXIT DIALOG
    END DIALOG
    CALL close_window()
END FUNCTION



PRIVATE FUNCTION open_window()
    OPEN WINDOW lb WITH FORM "listbox"
END FUNCTION


PRIVATE FUNCTION close_window()
    CLOSE WINDOW lb
END FUNCTION


PRIVATE FUNCTION init()
DEFINE i INTEGER

    LET listbox.listbox1 = "AB000123"
    LET listbox.listbox2 = "SYD1234"
    FOR i = 1 TO 10
        LET listbox_values[i] = ASCII(64+i),ASCII(64+i),ASCII(64+i)
    END FOR
    LET listbox.listbox4 = "F100"
END FUNCTION