# ex_multidialog

Example show the 4 key design patterns where MultiDialog is beneficial

Master-Detail pattern - typically comprises one or more INPUT statements and one or more INPUT ARRAY statements.  Used to allow input of master-detail data and typically results in the INSERT or UPDATE of 1 row of 1 table and multiple rows of another table.  The user can freely move between the GRID (INPUT) at the top and the TABLE (DISPLAY ARRAY, INPUT ARRAY) at the bottom
![Master Detail](https://user-images.githubusercontent.com/13615993/32206177-6fbca812-be58-11e7-8d68-a2bce111f344.png)

Starter pattern - as used for enquiry, reports, batch processing Pattern is one or more CONSTRUCT statements used in conjunction with one or more INPUT statements.  The user can freely move between INPUT and CONSTRUCT
![Starter Pattern](https://user-images.githubusercontent.com/13615993/32206176-6f7ff142-be58-11e7-9ca8-2edf16f08c71.png)

2 List pattern - Pattern is 2 or more DISPLAY ARRAY statements being visible at the same time.  Typically seen in wizards to transfer elements from one array to another.  The user can freely move between the two TABLE (DISPLAY ARRAY)
![2 List Pattern](https://user-images.githubusercontent.com/13615993/32206175-6f4b41cc-be58-11e7-88df-d9a1d776ee97.png)

Listbox pattern - used to simulate a LISTBOX widget (http://en.wikipedia.org/wiki/List_box).  Characteristics of pattern is a DISPLAY ARRAY statement used at the same time as one or more INPUT or CONSTRUCT statements, and the TABLE is embedded amongst the other widgets.  The user can select a value from the TABLE (DISPLAY ARRAY) as part of the INPUT
![Listbox Pattern](https://user-images.githubusercontent.com/13615993/32206174-6f133e4e-be58-11e7-9529-6d2c2139f902.png)
 
Key things to note are where you can click with the mouse, and how in Informix the developer has to add a mechanism to navigate between the dialogs.  With Genero Multi-Dialog the developer can click anywhere on the screen.

This example dates from 2010 when I was demonstrating MultiDialog to customers.  It is still relevant today
