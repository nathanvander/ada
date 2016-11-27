with System;
with Connection_Class; use Connection_Class;
with Interfaces.C;
with Interfaces.C.Strings;

package Statement_Class is
   	type Statement is new System.Address;
	No_Statement : constant Statement := Statement (System.Null_Address);

   	type Text_Destructor is access procedure (Str : in out System.Address);
   	pragma Convention (C, Text_Destructor);

     
	SQLite_Row: constant Integer:= 100;
     SQLite_Done: constant Integer :=101;

   	--  A prepared SQL statement.
	--this is the constructor for Statement
	function Prepare(conn: Connection; SQL: IN String) return Statement;
	--body defined further

	--returns Sqlite_Row if there is data to be obtained with the column methods
	--returns Sqlite_Done if there is no data
	--can also return other codes like Sqlite_busy or an error code
   	function Step(Stmt: Statement) return Integer;
     pragma Import (C, Step, "sqlite3_step");
   	
   	--  Finalize and free the memory occupied by stmt   	
   	procedure Finalize (Stmt : Statement);
	pragma Import (C, Finalize, "sqlite3_finalize");

   	function Column_Double (Stmt : Statement; Col : Natural) return Float;
   	pragma Import (C, Column_Double,"sqlite3_column_double");
   
   	function Column_Int    (Stmt : Statement; Col : Natural) return Integer;
   	pragma Import (C, Column_Int, "sqlite3_column_int");
   
   ---------------------------------
   --  Get the value stored in a column. This is only valid if the last call
   --  to Step returned Sqlite_Row
   function Column_Text   (Stmt : Statement; Col : Natural) return String;
   --defined in body

   function Column_C_Text(Stmt : Statement; Col : Natural) return Interfaces.C.Strings.chars_ptr;
   pragma Import (C, Column_C_Text,     "sqlite3_column_text");
     
     
   function Column_Bytes (Stmt : Statement; Col : Natural) return Natural;
   pragma Import (C, Column_Bytes,      "sqlite3_column_bytes");

   type Sqlite_Types is (Sqlite_Integer,
                         Sqlite_Float,
                         Sqlite_Text,
                         Sqlite_Blob,
                         Sqlite_Null);

   function Column_Type (Stmt : Statement; Col : Natural) return Sqlite_Types;
   pragma Import (C, Column_Type,       "sqlite3_column_type");

   --  Return the number of columns in the result, 0 for an UPDATE, INSERT or DELETE
   function Column_Count (Stmt : Statement) return Natural;
   pragma Import (C, Column_Count,      "sqlite3_column_count");

   function Column_Name (Stmt : Statement; Col : Natural) return String;
   --  Return the name of the specific column (or the value of the "AS" if one
   --  was specified.
   	
   	--------------------------------------------
   	--Bindings. There are more than these
	procedure Bind_Int(Stmt : Statement; Index : Integer; Value : Interfaces.C.int);
	pragma Import (C, Bind_Int, "sqlite3_bind_int");

	procedure Bind_Int64(Stmt : Statement; Index: Integer; Value: Interfaces.C.long);
	pragma Import (C, Bind_Int64, "sqlite3_bind_int64");

   	procedure Bind_Text (Stmt : Statement; Index : Integer; Str: String; N_Bytes : Natural;
      	Destructor : Text_Destructor := null);
	pragma Import (C, Bind_Text, "sqlite3_bind_text");
   	
end Statement_Class;