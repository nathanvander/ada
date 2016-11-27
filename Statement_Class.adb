with Interfaces.C;             use Interfaces.C;
with Interfaces.C.Strings;     use Interfaces.C.Strings;

package body Statement_Class is
	--prepare a statement
	function Prepare(conn: Connection;
				SQL: IN String) return Statement is
		status: Integer;
      	function Internal
        		(c2    : Connection;
         		SQL   : String;
         		NByte : Integer;
         		Stmt  : access Statement;
         		Tail  : access System.Address) return Integer;
      	pragma Import (C, Internal, "sqlite3_prepare_v2");
      	Stmt2 : aliased Statement;
      	Tail  : aliased System.Address;
   	begin
      	status := Internal(conn, SQL, SQL'Length, Stmt2'Access, Tail'Access);
		if status = Sqlite_OK then
			return Stmt2;
		else
			raise SQLite_Exception with Integer'image(status);
		end if;      	
   	end Prepare;

   	-----------------
   	-- Column_Text --
   	-----------------
   	function Column_Text (Stmt : Statement; Col : Natural) return String is
      	Val : constant chars_ptr := Column_C_Text (Stmt, Col);
   	begin
     	return Value (Val);
   	end Column_Text;

   	-----------------
   	-- Column_Name --
   	-----------------
   	function Column_Name (Stmt : Statement; Col : Natural) return String is
      	function Internal (Stmt : Statement; Col : Natural) return chars_ptr;
      	pragma Import (C, Internal, "sqlite3_column_name");
   	begin
      	return Value (Internal (Stmt, Col));
   	end Column_Name;

end Statement_Class;