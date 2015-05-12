/**
	Contains data access functions
**/
component client="true"   
{
	this.dsn = "expense_db";
	
	//Constructor
	function init()
	{
		//Use localStorage flag to check if database is already created
		var dbCreated = localStorage.dbCreated;
		if (!isDefined("dbCreated"))
			localStorage.dbCreated = false;
			
		if (!dbCreated)
		{
			try
			{
				createTable();
				localStorage.dbCreated = true;
			} 
			catch (any e)
			{
				alert("Error : " + e.message);
			}
		}
	}
	
	//Creates expense table
	function createTable()
	{
		try
		{
			queryExecute("drop table expense",[],{"datasource":this.dsn});
		}
		catch (any e){
			//ignore
		}
		queryExecute(
			"create table if not exists expense (id integer primary key, 
			expense_date integer, amount real, desc text, receipt_path text)", 
			[], 
			{"datasource":this.dsn});
	}

	//Adds a single expense item to expense table. Argument of type ExpenseVO
	function addExpense (expVO)
	{
		queryExecute(
			"insert into expense (expense_date,amount,desc,receipt_path) values(?,?,?,?)",
			[expVO.expenseDate,expVO.amount,expVO.description,expVO.receiptPath],
			{"datasource":this.dsn}
		);
		
		//get auto generated id
		queryExecute(
			"select max(id) maxId from expense",
			[],
			{"datasource":this.dsn, "name":"rs"}
		);
		
		expVO.id = rs.maxId[1];
	}
	
	//Queries expense table and returns data as array of ExpenseVO components
	function getExpenses()
	{
		queryExecute("select * from expense order by expense_date desc",
			[],
			{"datasource":this.dsn, "name":"rs"});
		
		console.log("rs = ");
		console.log(rs);
		
		var result = [];
		if (rs.length == 0)
			return result;
		
		for (i = 1; i <= rs.length; i++)
		{
			var expVO = new ExpenseVO();
			expVO.id = rs.id[i];
			expVO.expenseDate = rs.expense_date[i];
			expVO.amount = rs.amount[i];
			expVO.description = rs.desc[i];
			expVO.receiptPath = rs.receipt_path[i];
			result.append(expVO);
		}
		
		return result;
	}  
	
	//Deletes all recrods from expense table
	function deleteAllExpenses()
	{
		var expenses = getExpenses();
		var recCount = arrayLen(expenses);
		for (i = 1; i <= recCount; i++)
		{
			try
			{
				if (expenses[i].receiptPath == "")
					continue;
				cfclient.file.remove(expenses[i].receiptPath);
			} 
			catch (any e)
			{
				console.log("Error deleting file" + e.message);
			}
		}
		
		queryExecute("delete from expense",[],{"datasource":this.dsn});
	}
}