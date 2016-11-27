-- see the source to GNATCOLL.SQL.Sqlite.Gnade
-- I want to keep this very simple 
with System;

package body Connection_Class is

	function Get_Lib_Version return Integer is
		function Internal return Integer;
		pragma Import (C, Internal, "sqlite3_libversion_number");
	begin
		return Internal;
	end;

	--------------------------------------------
	--modified from Gnade
	-------------------------------------------
	----------
	-- Open --
   	----------
	procedure Open
		(conn       : out Connection;
      	Filename : String := Open_In_Memory;
      	Flags    : Open_Flags := Open_Readwrite or Open_Create or Open_Readwrite_Create;
		Status : out Integer)
	is
		function Internal
        		(Name  : String;
         		Db    : access Connection;  --this is a pointer to a pointer
         		Flags : Integer;
         		Vfs   : System.Address := System.Null_Address) return Integer;
      	pragma Import (C, Internal, "sqlite3_open_v2");

      	DB2    : aliased Connection;
   
   	begin
		Status := Internal(Filename & ASCII.NUL, DB2'Unchecked_Access, Integer(Flags));

      	if Status = Sqlite_OK then
			conn := DB2;
      	else
			conn := No_Connection;
      	end if;
   end Open;

	---------------------------------------------
	--class constructor
	--This will throw an SQLite_Error if it can't open the file
	function Create(filename: String; flags: Open_Flags) return Connection is
		conn: Connection;
		status: Integer;
	begin
		Open(conn, filename, flags, status);
		if status = Sqlite_OK then
			return conn;
		else
			raise SQLite_Exception with Integer'image(status);
		end if;
	end Create;

	-----------------------------
   	-- Close --
   	-----------
	procedure Close (conn: Connection) is
		function Internal_Close (conn: Connection) return Integer;
      	pragma Import (C, Internal_Close, "sqlite3_close_v2");
	 	result: Integer;
   	begin
      	if conn /= null then
         		result := Internal_Close (conn);
      	end if;
   	end Close;	
   	
end Connection_Class;