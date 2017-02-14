# ex_multidialog

Example show the 4 key design patterns where MultiDialog is beneficial

Master-Detail pattern - typically comprises one or more INPUT statements and one or more INPUT ARRAY statements.  Used to allow input of master-detail data and typically results in the INSERT or UPDATE of 1 row of 1 table and multiple rows of another table

Starter pattern - as used for enquiry, reports, batch processing Pattern is one or more CONSTRUCT statements used in conjunctin with one or more INPUT statements

2 List pattern - Pattern is 2 or more DISPLAY ARRAY statements being visible at the same time.  Typically seen in wizards to transfer elements from one array to another

Listbox pattern - used to simulate a LISTBOX widget (http://en.wikipedia.org/wiki/List_box).  Characteristics of pattern is a DISPLAY ARRAY statement used at the same time as one or more INPUT or CONSTRUCT statements, and the TABLE is embedded amongst the other widgets
 
Key things to note are where you can click with the mouse, and how in Informix the developer has to add a mechanism to navigate between the dialogs.  With Genero Multi-Dialog the developer can click anywhere on the screen.

This example dates from 2010 when I was demonstrating MultiDialog to customers.  It is still relevant today
