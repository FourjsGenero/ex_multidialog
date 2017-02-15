DEFINE inputconstruct RECORD 
    con RECORD
        qbe1 STRING,
        qbe2 STRING,
        qbe3 STRING
    END RECORD,
    inp RECORD
        printer STRING,
        copies INTEGER,
        collate BOOLEAN
    END RECORD
END RECORD

-- Starter pattern, as used for enquiry, reports, batch processing
-- Pattern is one or more CONSTRUCT statements used in conjunctin with
-- one or more INPUT statements

FUNCTION ifx_starter()
DEFINE mode STRING
DEFINE where_clause STRING

    CALL open_window()
    LET mode = "qbe"
    WHILE mode != "exit"
        CASE mode --
            WHEN "qbe"
                CONSTRUCT BY NAME where_clause ON qbe1, qbe2, qbe3 
                    AFTER CONSTRUCT
                        IF INT_FLAG THEN
                            LET MODE = "exit"
                            EXIT CONSTRUCT
                        END IF
                        LET MODE = "input"
                END CONSTRUCT
                LET INT_FLAG = 0
            WHEN "input"
                INPUT BY NAME inputconstruct.inp.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
                    ON ACTION back ATTRIBUTES(TEXT="Back")
                        LET mode = "qbe"
                        EXIT INPUT
                    AFTER INPUT
                        IF INT_FLAG THEN
                            LET mode = "exit"
                            EXIT INPUT
                        END IF
                        LET mode = "exit"
                END INPUT
                LET INT_FLAG = 0
        END CASE
    END WHILE
    CALL close_window()
END FUNCTION



FUNCTION gmd_starter()
DEFINE where_clause STRING

    CALL open_window()
    DIALOG
        CONSTRUCT BY NAME where_clause ON qbe1, qbe2, qbe3 
        END CONSTRUCT
        
        INPUT BY NAME inputconstruct.inp.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        END INPUT

        ON ACTION accept--
            ACCEPT DIALOG
        ON ACTION cancel--
            EXIT DIALOG
        ON ACTION close--
            EXIT DIALOG
    END DIALOG
    CALL close_window()
END FUNCTION



PRIVATE FUNCTION open_window()
    OPEN WINDOW st WITH FORM "starter"
END FUNCTION



PRIVATE FUNCTION close_window()
    CLOSE WINDOW st
END FUNCTION