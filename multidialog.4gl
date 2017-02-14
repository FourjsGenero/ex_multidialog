
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

DEFINE list1 DYNAMIC ARRAY OF RECORD
   VALUE STRING
END RECORD
DEFINE list2 DYNAMIC ARRAY OF RECORD
   VALUE STRING
END RECORD

DEFINE listbox RECORD
   listbox1 STRING,
   listbox2 STRING,
   listbox3 STRING,
   listbox4 STRING
END RECORD
DEFINE listbox_values DYNAMIC ARRAY OF STRING




MAIN
DEFINE i INTEGER

   OPTIONS FIELD ORDER FORM
   OPTIONS INPUT WRAP
   DEFER INTERRUPT

   -- Generate some data for each screen
   LET masterdetail.master.master1 = "AB000123"
   LET masterdetail.master.master2 = "SYD1234"
   LET masterdetail.master.master3 = TODAY

   LET masterdetail.detail_arr[1].detail1 = 1
   LET masterdetail.detail_arr[1].detail2 = "F100"
   LET masterdetail.detail_arr[1].detail3 = "200"

   LET listbox.listbox1 = "AB000123"
   LET listbox.listbox2 = "SYD1234"
   FOR i = 1 TO 10
      LET list1[i].value = 2*i-1
      LET list2[i].value = 2*i
      LET listbox_values[i] = ASCII(64+i),ASCII(64+i),ASCII(64+i)
   END FOR
   LET listbox.listbox4 = "F100"

   CLOSE WINDOW SCREEN
   
   OPEN WINDOW w WITH FORM "multidialog"

   -- Allow the user to select a design pattern and view the traditional
   -- Informix way, and the Multi-Dialog way of doing things
   MENU ""
      COMMAND "Informix Master Detail"
         CALL ifx_master_detail()
      COMMAND "Multi Dialog Master Detail"
         CALL md_master_detail()
         
      COMMAND "Informix Starter"
         CALL ifx_starter()
      COMMAND "Multi Dialog Starter"
         CALL md_starter()

      COMMAND "Informix 2 Lists"
         CALL ifx_2list()
      COMMAND "Multi Dialog 2 Lists"
         CALL md_2list()

      COMMAND "Informix Listbox"
         CALL ifx_listbox()
      COMMAND "Multi Dialog Listbox"
         CALL md_listbox()
         
      ON ACTION CLOSE
         EXIT MENU
   END MENU
END MAIN


-- The Master-Detail pattern typically comprises one or more INPUT statements
-- and one or more INPUT ARRAY statements.  Used to allow input of master-detail
-- data and typically results in the INSERT or UPDATE of 1 row of 1 table
-- and multiple rows of another table

FUNCTION ifx_master_detail()
DEFINE mode STRING
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
               ON ACTION back
                  LET mode = "master"
                  EXIT INPUT
               AFTER INPUT
                  IF INT_FLAG THEN
                     LET mode = "exit"
                     EXIT INPUT
                  END IF
            END INPUT
            LET INT_FLAG = 0
      END CASE
   END WHILE
END FUNCTION

FUNCTION md_master_detail()
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

END FUNCTION


-- Starter pattern, as used for enquiry, reports, batch processing
-- Pattern is one or more CONSTRUCT statements used in conjunctin with
-- one or more INPUT statements

FUNCTION ifx_starter()
DEFINE mode STRING
DEFINE where_clause STRING

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
               ON ACTION back
                  LET mode = "qbe"
                  EXIT INPUT
               AFTER INPUT
                  IF INT_FLAG THEN
                     LET mode = "exit"
                     EXIT INPUT
                  END IF
            END INPUT
            LET INT_FLAG = 0
      END CASE
   END WHILE
END FUNCTION

FUNCTION md_starter()
DEFINE where_clause STRING

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
END FUNCTION



-- 2 List pattern
-- Pattern is 2 or more DISPLAY ARRAY statements being visible at the
-- same time.  Typically seen in wizards

FUNCTION ifx_2list()
DEFINE mode STRING

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
END FUNCTION

FUNCTION md_2list()
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

      ON ACTION cancel
         EXIT DIALOG

      ON ACTION accept
         EXIT DIALOG
   END DIALOG

END FUNCTION





-- Listbox pattern, used to simulate a LISTBOX widget (http://en.wikipedia.org/wiki/List_box)
-- Characteristics of pattern is a DISPLAY ARRAY statement used at the same time
-- as one or more INPUT or CONSTRUCT statements, and the TABLE is embedded amongst
-- the other widgets
FUNCTION ifx_listbox()
   DISPLAY ARRAY listbox_values TO listbox.*
      BEFORE DISPLAY
         CALL ui.Interface.Refresh()
         EXIT DISPLAY
   END DISPLAY
         
   INPUT BY NAME listbox.listbox1, listbox.listbox2, listbox.listbox4 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
      ON ACTION select
         DISPLAY ARRAY listbox_values TO listbox.*
            AFTER DISPLAY
         END DISPLAY
         LET int_flag = 0
   END INPUT

END FUNCTION

FUNCTION md_listbox()
   DIALOG
      INPUT BY NAME listbox.listbox1, listbox.listbox2, listbox.listbox4 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
      END INPUT

      DISPLAY ARRAY listbox_values TO listbox.*
      END DISPLAY

      BEFORE DIALOG
         CALL DIALOG.setSelectionMode("listbox", TRUE)

      ON ACTION CLOSE
         EXIT DIALOG

      ON ACTION cancel
         EXIT DIALOG

      ON ACTION accept
         EXIT DIALOG
   END DIALOG

END FUNCTION