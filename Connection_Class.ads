-- see the source to GNATCOLL.SQL.Sqlite.Gnade
-- I want to keep this very simple 
with System;
with Interfaces.C;

package Connection_Class is
   type Database_Record is null record; --  Must be null, hides sqlite data
   --type Database is access Database_Record;
   type Connection is access Database_Record;
   --pragma Convention (C, Database);
   pragma Convention (C, Connection);
   --No_Database : constant Database := null;
   No_Connection : constant Connection := null;

   type Open_Flags is mod 2**32;
   Open_Readonly  : constant Open_Flags := 16#00001#;
   Open_Readwrite : constant Open_Flags := 16#00002#;
   Open_Create    : constant Open_Flags := 16#00004#;
   Open_Nomutex   : constant Open_Flags := 16#08000#;
   Open_Fullmutex : constant Open_Flags := 16#10000#;
   Open_Readwrite_Create: constant Open_Flags := Open_Readwrite or Open_Create;
   
   Open_In_Memory   : constant String := ":memory:";
   Open_Tmp_On_Disk : constant String := "";
   
   	SQLite_OK: constant Integer := 0;
  
	SQLite_Exception: exception;   
	--------------------------------------------
	--get the sqlite version
	function Get_Lib_Version return Integer;
	
	--modified from Gnade
	procedure Open
		(conn       : out Connection;
      	Filename : String := Open_In_Memory;
      	Flags    : Open_Flags := Open_Readwrite or Open_Create or Open_Readwrite_Create;
		Status : out Integer);

   	function Changes (c : Connection) return Natural;
   	pragma Import (C, Changes, "sqlite3_changes");
   	
   	function Last_Insert_Rowid (c : Connection) return Interfaces.C.long;
   	pragma Import (C, Last_Insert_Rowid, "sqlite3_last_insert_rowid");
	---------------------------------------------
	--class constructor
	--This will throw an SQLite_Error if it can't open the file
	function Create(filename: String; flags: Open_Flags) return Connection;

	procedure Close (conn : Connection);

end Connection_Class;