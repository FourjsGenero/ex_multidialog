DEFINE list1 DYNAMIC ARRAY OF RECORD
    VALUE STRING
END RECORD
DEFINE list2 DYNAMIC ARRAY OF RECORD
    VALUE STRING
END RECORD

-- 2 List pattern
-- Pattern is 2 or more DISPLAY ARRAY statements being visible at the
-- same time.  Typically seen in wizards

FUNCTION ifx_twolist()
DEFINE mode STRING

    CALL init()
    CALL open_window()

    DISPLAY ARRAY list1 TO list1.*
        BEFORE DISPLAY
            CALL ui.Interface.refresh()
            EXIT DISPLAY
    END DISPLAY

    DISPLAY ARRAY list2 TO list2.*
        BEFORE DISPLAY
            CALL ui.Interface.refresh()
            EXIT DISPLAY
    END DISPLAY

    LET mode = "list1"
    WHILE mode != "exit"
        CASE mode
            WHEN "list1"
                DISPLAY ARRAY list1 TO list1.*
                    ON ACTION left2right
                        CALL list2.appendElement()
                        LET list2[list2.getLength()].value = list1[DIALOG.getCurrentRow("list1")].value
                        CALL DIALOG.deleteRow("list1",DIALOG.getCurrentRow("list1"))
                        DISPLAY ARRAY list2 TO list2.*
                            BEFORE DISPLAY
                                CALL ui.Interface.refresh()
                                EXIT DISPLAY
                        END DISPLAY
                    --
                    ON ACTION toggle
                        LET mode = "list2"
                        EXIT DISPLAY
                    ON ACTION close
                        LET mode = "exit"
                        EXIT DISPLAY
                    ON ACTION cancel
                        LET mode = "exit"
                        EXIT DISPLAY
                END DISPLAY
         WHEN "list2"
                DISPLAY ARRAY list2 TO list2.*
                    ON ACTION toggle
                        LET mode = "list1"
                        EXIT DISPLAY
                    ON ACTION right2left
                        CALL list1.appendElement()
                        LET list1[list1.getLength()].value = list2[DIALOG.getCurrentRow("list2")].value
                        CALL DIALOG.deleteRow("list2",DIALOG.getCurrentRow("list2"))
                        DISPLAY ARRAY list1 TO list1.*
                            BEFORE DISPLAY
                                CALL ui.Interface.refresh()
                                EXIT DISPLAY
                        END DISPLAY
                    ON ACTION close
                        LET mode = "exit"
                        EXIT DISPLAY
                    ON ACTION cancel
                        LET mode = "exit"
                        EXIT DISPLAY
                END DISPLAY
        END CASE
    END WHILE
    CALL close_window()
END FUNCTION



FUNCTION gmd_twolist()
    CALL init()
    CALL open_window()
    DIALOG ATTRIBUTES(UNBUFFERED)
        DISPLAY ARRAY list1 TO list1.*
            ON ACTION left2right --
                CALL DIALOG.appendRow("list2")
                LET list2[DIALOG.getArrayLength("list2")].value = list1[DIALOG.getCurrentRow("list1")].value
                CALL DIALOG.deleteRow("list1",DIALOG.getCurrentRow("list1"))
        END DISPLAY
        DISPLAY ARRAY list2 TO list2.*
            ON ACTION right2left --
                CALL DIALOG.appendRow("list1")
                LET list1[DIALOG.getArrayLength("list1")].value = list2[DIALOG.getCurrentRow("list2")].value
                CALL DIALOG.deleteRow("list2",DIALOG.getCurrentRow("list2"))
        END DISPLAY

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
    OPEN WINDOW tl WITH FORM "twolist"
END FUNCTION



PRIVATE FUNCTION close_window()
    CLOSE WINDOW tl
END FUNCTION



PRIVATE FUNCTION init()
DEFINE i INTEGER
    FOR i = 1 TO 10
        LET list1[i].value = 2*i-1
        LET list2[i].value = 2*i
    END FOR
END FUNCTION