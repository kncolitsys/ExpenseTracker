<cfclient>
<!--- Custom tag to display list of expenses
	Regaired attributes are parentDiv and action.
	Supported actions : displayApp, append and removeAll.
	Attribute expenses is required when action is 'displayAll'. Value if array of ExpenseVO 
	Attribute expense is also required when action is 'append', but value in this case is a single ExpenseVO 
--->

	<!--- Handle only tag start --->
	<cfif thisTag.executionMode eq "start">
		<cfset processTagStart()>
	</cfif>
	
	<!--- Tag start --->
	<cffunction name="processTagStart" >
		
		<cfset variables.action = "">
		
		<cfif not structKeyExists(attributes,"parentDiv") or attributes.parentDiv eq "">
			<!--- parentDiv is not specified --->
			<cfreturn >
		</cfif>
		
		<cfif structKeyExists(attributes,"action")>
			<cfset variables.action = attributes.action>
		</cfif>

		<cfif structKeyExists(attributes,"expenses")>
			<!--- 
				Displays list of expenses in a given div element
				If attribute.expenses is an array then create HTML table and display in the parent DIV
				If attribute.expenses is not an array then assume it to be ExpenseVO and append to 
					the existing table
			 --->
				
			<cfif variables.action eq "displayAll" and isArray(attributes.expenses)>
				<cfset displayExpensesArray()>
				<cfreturn >
			<cfelseif variables.action eq "append" >
				<cfset appendExpense()>
				<cfreturn >
			</cfif>
		</cfif>
		
		<cfif variables.action eq "removeAll">
			<cfset removeAllExpenses()>
		</cfif>
	</cffunction>
	
	<!--- Display array of expenseVO objects --->
	<cffunction name="displayExpensesArray" >
		<cfset var expenses = attributes.expenses>
		<cfset var parentDiv = attributes.parentDiv>

		<cfif expenses.length eq 0>
			<!--- No expneses added to database yet --->
			<cfset $("##" + parentDiv).append("<b>No expenses found</b>")>
			<cfreturn >
		</cfif>
		
		<!--- Create table --->
		<cfset $("##" + parentDiv).children().remove()>
		<cfset tblEml = $(createHTMLtable()).appendTo("##" + parentDiv)>

		<!--- Add table rows --->				
		<cfloop array="#expenses#" index="expense">
			<cfset $(tblEml).append(createTableRow(expense))>
		</cfloop>
		
	</cffunction>
	
	<!--- Append one expense item to the existing list --->
	<cffunction name="appendExpense" >
		
		<cfset var expenseVO = attributes.expenses>
		<cfset var parentDiv = attributes.parentDiv>
		
		<!---First check if we need to create the table --->
		<cfset tblElm = $("##" + parentDiv + " table")>
		<cfif tblElm.length eq 0>
			<!--- Table does not exist. Create one --->
			<cfset $("##" + parentDiv).children().remove()>
			<cfset tblElm = $(createHTMLtable()).appendTo("##" + parentDiv)>
		</cfif>
		
		<!--- append expenseVO --->
		<cfset $(tblElm).append(createTableRow(expenseVO))>
	</cffunction>
	
	<!--- Create HTML text for displaying expnese in a table row --->
	<cffunction name="createTableRow" >
		<cfargument name="expenseVO" >
		
		<cfoutput >
			<cfsavecontent variable="tmpStr" >
				<tr>
					<td>#dateToStr(expenseVO.expenseDate)#</td>
					<td>#expenseVO.amount#</td>
					<td>#expenseVO.description#</td>
					<cfif expenseVO.receiptPath neq "">
						<td>
							<a href="#expenseVO.receiptPath#" class="imageReceipt">receipt</a>
						</td>
					<cfelse>
						<td></td>
					</cfif>
				</tr>
			</cfsavecontent>
		</cfoutput>
		
		<cfreturn tmpStr>
	</cffunction>
	
	<!--- removes all expense rows from the table --->
	<cffunction name="removeAllExpenses" >
		<cfset var parentDiv = attributes.parentDiv>
		<cfset $("##" + parentDiv).children().remove()>
		<cfset $("##" + parentDiv).append("<b>No expenses found</b>")>
	</cffunction>
	
	<!--- Creates HTML table to display expenses --->
	<cffunction name="createHTMLtable" >
		<cfsavecontent variable="tmpStr">
			<table width="100%">
				<tr>
					<th>Date</th>
					<th>Amount</th>
					<th>Description</th>
					<th></th>
				</tr>
			</table>
		</cfsavecontent>
		
		<cfreturn tmpStr>		
	</cffunction>

	<!--- Converts date in milliseconds to local string --->
	<cffunction name="dateToStr" >
		<cfargument name="dateAsNumber" type="numeric" required="true" >
		<cfset tmpDate = new Date(dateAsNumber)>
		<cfreturn dateFormat(tmpDate,"mm/dd/yyyy")>
	</cffunction>
</cfclient>