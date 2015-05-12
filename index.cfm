<!DOCTYPE html>

<html>
	<head>
		<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="css/jquery.mobile-1.4.2.min.css" ></link>
		
		<script src="js/jquery-2.1.0.min.js" ></script>
		<script src="js/app.js"></script>
		<script src="js/jquery.mobile-1.4.2.min.js" ></script>
		<style >
			table th {
				text-align:left;
			}
		</style>
	</head>
	
	<body >
		<!--- Main JQuery Mobile poage --->
		<div data-role="page" id="mainPage">
			<div data-role="header" data-position="fixed" >
				<h2>Expense Tracker</h2>
				<div style="padding-left:10px">
					<button class="ui-btn ui-btn-inline" id="addBtn">Add</button>
					<button class="ui-btn ui-btn-inline" id="deleteAllBtn">Delete All</button>
				</div>
			</div>
			<div class="ui-content">
				<div id="expenseListDiv">
					<!--- content will be dymanically populated --->
				</div>
			</div>
			<div data-role="footer" data-position="fixed" >
				<h5>Created with CFMobile</h5>
			</div>
		</div>
		
		<!--- JQM Dialog box to add an epxense item --->
		<div data-role="page" id="addDlg" >
			<div data-role="header">
				<h2>Add Expense</h2>
			</div>
			<div class="ui-content">
      			<table width="100%">
      				<tr>
      					<td>Date:</td>
      					<td><input type="date" id="dateTxt"></td>
      				</tr>
      				<tr>
      					<td>Amount:</td>
      					<td><input type="text" id="amtTxt"></td>
      				</tr>
      				<tr>
      					<td>Desc:</td>
      					<td><input type="text" id="descTxt"></td>
      				</tr>
      				<tr>
      					<td colspan="2"><button class="ui-btn ui-btn-inline" id="attachRcptBtn">Attach Receipt</button></td>
      				</tr>
      				<tr>
      					<td colspan="2"><img id="receiptImg" width="50"></img></td>
      				</tr>
      			</table>
			</div>
			<div data-role="footer">
				<button class="ui-btn ui-btn-inline" id="dlgOKBtn1">OK</button>
				<button class="ui-btn ui-btn-inline" id="dlgCancel1">Cancel</button>
			</div>
		</div>
		
		<!--- JQM Dialog box to display receipt --->
		<div data-role="dialog" id="receiptDlg" style="overflow:scroll">
			<div data-role="header">
				<h2>Receipt</h2>
				<div>
					<button class="ui-btn ui-btn-inline" id="receiptFitBtn">Fit</button>
					<button class="ui-btn ui-btn-inline" id="receiptFullBtn">Full Size</button>
				</div>
			</div>
			<div class="ui-content" style="overflow:scroll">
				<img id="receiptImgLarge"></img>
			</div>
			<div data-role="footer">
			</div>
		</div>
	</body>
</html>

<!--- We will be using device APIs. So enable them --->
<cfclientsettings enabledeviceapi="true" >

<cfclient>
	<!--- All cfclient code to creat dynamic HTML and 
		interface with data access CFC is in the following included file --->
	<cfinclude template="index_include.cfm" >
</cfclient>