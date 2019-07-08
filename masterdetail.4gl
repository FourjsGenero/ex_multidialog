DEFINE masterdetail RECORD
    master RECORD
        master1 CHAR(10),
        master2 CHAR(10),
        master3 DATE
    END RECORD,
    detail_arr DYNAMIC ARRAY OF RECORD
        detail1 INTEGER,
        detail2 CHAR(10),
        detail3 INTEGER
    END RECORD
END RECORD

-- The Master-Detail pattern typically comprises one or more INPUT statements
-- and one or more INPUT ARRAY statements.  Used to allow input of master-detail
-- data and typically results in the INSERT or UPDATE of 1 row of 1 table
-- and multiple rows of another table

FUNCTION ifx_master_detail()
DEFINE mode STRING


    CALL init()
    CALL open_window()
    LET mode = "master"
    WHILE mode != "exit"
        CASE mode --
            WHEN "master"
                INPUT BY NAME masterdetail.master.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
                    AFTER INPUT
                        IF INT_FLAG THEN
                            LET MODE = "exit"
                            EXIT INPUT
                        END IF
                        LET MODE = "detail"
                END INPUT
                LET INT_FLAG = 0
            WHEN "detail"
                INPUT ARRAY masterdetail.detail_arr WITHOUT DEFAULTS FROM detail_arr.*
                    ON ACTION back ATTRIBUTES(TEXT="Back")
                        LET mode = "master"
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



FUNCTION gmd_master_detail()
    CALL init()
    CALL open_window()
    DIALOG
        INPUT BY NAME masterdetail.master.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        END INPUT
        INPUT ARRAY masterdetail.detail_arr FROM detail_arr.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
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
    OPEN WINDOW md WITH FORM "masterdetail"
END FUNCTION



PRIVATE FUNCTION close_window()
    CLOSE WINDOW md
END FUNCTION



PRIVATE FUNCTION init()
    LET masterdetail.master.master1 = "AB000123"
    LET masterdetail.master.master2 = "SYD1234"
    LET masterdetail.master.master3 = TODAY

    LET masterdetail.detail_arr[1].detail1 = 1
    LET masterdetail.detail_arr[1].detail2 = "F100"
    LET masterdetail.detail_arr[1].detail3 = "200"

    LET masterdetail.detail_arr[2].detail1 = 2
    LET masterdetail.detail_arr[2].detail2 = "G200"
    LET masterdetail.detail_arr[2].detail3 = "20"
END FUNCTION