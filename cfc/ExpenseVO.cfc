/**
	ExpenseVO value object. 
*/
component client="true"   
{
	this.id;
	this.expenseDate;
	this.amount;
	this.description;
	this.receiptPath;
	
	function init(expDate, amt, desc, receipt)
	{
		this.expenseDate = expDate;
		this.amount = amt;
		this.description = desc;
		this.receiptPath = receipt;
	}
}