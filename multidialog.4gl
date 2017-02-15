











MAIN

    OPTIONS FIELD ORDER FORM
    OPTIONS INPUT WRAP
    DEFER INTERRUPT

    CLOSE WINDOW SCREEN
    OPEN WINDOW w WITH FORM "multidialog"

    -- Allow the user to select a design pattern and view the traditional
    -- Informix way, and the Multi-Dialog way of doing things
    MENU ""
        BEFORE MENU
            MESSAGE "Run and compare programs without and with multi dialog"
        ON ACTION ifx_master_detail
            CALL ifx_master_detail()
        ON ACTION gmd_master_detail
            CALL gmd_master_detail()
         
        ON ACTION ifx_starter
            CALL ifx_starter()
        ON ACTION gmd_starter
            CALL gmd_starter()

        ON ACTION ifx_twolist
            CALL ifx_twolist()
        ON ACTION gmd_twolist
            CALL gmd_twolist()

        ON ACTION ifx_listbox
            CALL ifx_listbox()
        ON ACTION gmd_listbox
            CALL gmd_listbox()
         
        ON ACTION CLOSE
            EXIT MENU
    END MENU
END MAIN