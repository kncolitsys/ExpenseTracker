<cfclient>
	<!--- included from index.html
		Contains code to create HTML dynamically and acts 
		as interface between HTML UI and data access code in 
		the ExpenseManager.cfc
	--->
	
	<!--- Folder name where receipt images will be saved --->
	<cfset variables.appFolderName = "CFMobileExpenseTracker">

	<cftry>
		<!--- Create an instance of ExpenseManager.cfc and get all expenses from it --->
		<cfset expMgr = new cfc.ExpenseManager()>
		<cfset expenses = expMgr.getExpenses()>
	
		<cfcatch type="any" name="e">
			<cfset alert(e.message)>
		</cfcatch>
	</cftry>
	 
	<!--- Display expense items using client side custom tag in expenseList.cfm --->
	<cf_expenseList parentDiv="expenseListDiv" expenses=#expenses# action="displayAll">
	
	<!--- Reads expense item details from HTML input fields and
		calls ExpenseManager.addExpense to save to the database ---> 
	<cffunction name="saveExpense" >
		
		<cfscript>
			var dateStr = trim($("##dateTxt").val());
			var amtStr = trim($("##amtTxt").val());
			
			if (dateStr == "" || amtStr == "")
			{
				alert("Date and amount are required");
				return;
			}
			
			if (!isNumeric(amtStr))
			{
				alert("Invalid amount");
				return;
			}
			
			var amt = Number(amtStr);
			var tmpDate = new Date(dateStr);
			var desc = trim($("##descTxt").val());
			
			var receiptPath = "";
			
			if (isDefined("_tmpImagePath"))
				receiptPath = _tmpImagePath;
			
			var expVO = new cfc.ExpenseVO(tmpDate.getTime(),amt,desc,receiptPath);
			var expAdded = false;
			
			try
			{ 
				expMgr.addExpense(expVO);
				expAdded = true;
			} 
			catch (any e)
			{
				alert("Error : " + e.message);
				return;
			}
		</cfscript>
		
		<cfset $("##addDlg").dialog("close") >
		
		<cfif expAdded eq true>
	 		<cf_expenseList parentDiv="expenseListDiv" expenses=#expVO# action="append">
		</cfif>
		
	</cffunction>
	
	<!--- Calls ExpenseManager.deleteAllExpenses and 
		then removes all items from the HTML table --->
	<cffunction name="deleteAll" >
		
		<cfscript>
			if (!confirm("Are you sure you want to delete all?"))
				return;
				
			try
			{
				expMgr.deleteAllExpenses();
			} 
			catch (any e)
			{
				alert("Error : " + e.message);
				return;
			}
		</cfscript>
		
 		<cf_expenseList parentDiv="expenseListDiv" action="removeAll">
 			
	</cffunction>
	
	<cfscript>
		//Attach receipt to expense item --->
		function attachReceipt()
		{
			if (!createApplicationFolder())
				return;
	 
			var imageUrl = cfclient.camera.getPicture();
			if (isDefined("imageUrl"))
			{
				var imagePath = copyFileFromTempToPersistentFileSystem(imageUrl);
				if (isDefined("imagePath") && imagePath != "")
				{
					_tmpImagePath = imagePath;
					console.log("image saved to " + imagePath);
					loadImage(imagePath,"receiptImg");
				}
			}
		}
		
		//Creates application folder stored in variables.appFolderName --->
		function createApplicationFolder()
		{
			//set persistent file system
			var persistentfileSystem = cfclient.file.setFileSystem("persistent");
			var appFolderPath = persistentfileSystem.root.fullPath + "/" + variables.appFolderName;
			var createFolder = false;
			try
			{
				var dirPath = cfclient.file.getDirectory(appFolderPath);
				if (!isDefined("dirPath"))
					createFolder = true;
			} catch (any e)
			{
				//assume directory does not exist
				if (e.message)
					createFolder = true;
			}
			if (createFolder)
			{
				try
				{
					var dirEntry = cfclient.file.createDirectory(appFolderPath,true);
				}
				catch (any e)
				{
					alert("Error : " + appFolderPath + " - " + e.message);
					return false;
				}
			}
			return true;
		}
		
		//Copies image file from temporary file system to persistent file system
		//in the folder 
		function copyFileFromTempToPersistentFileSystem (tempFilePath)
		{
			//save existing file system
			var oldFileSystem = cfclient.file.getFileSystem();
			
			//Get file object from the path
			var tmpFile = cfclient.file.get(tempFilePath);
			
			//set persistent file system
			var persistentfileSystem = cfclient.file.setFileSystem("persistent");
			
			//assume application folder is already created
			var newFilePath = persistentfileSystem.root.fullPath + "/" + variables.appFolderName + "/" + tmpFile.name;
			
			//If file with the same name exists in the persistent file system, then try save
			//it with different name
			var count = 1;
			while (count < 10)
			{
				try
				{
					cfclient.file.get(newFilePath);
						
					//file already exists. Try different file name
					count++;
					newFilePath = persistentfileSystem.root.fullPath + "/" + variables.appFolderName + "/" + replace(tmpFile.name,".","_") + "_" + count + ".jpg";
				} 
				catch (any e) {
					//Assume file does not exists. Go ahead and copy from temp location to persistent location.	
					console.log("Exception : " + e.message);
					break;
				}
			}
			
			//Copy file
			cfclient.file.copy(tempFilePath,newFilePath);
				
			//remove temporary file
			cfclient.file.remove(tempFilePath);				
				
			//Restore old file system
			cfclient.file.setFileSystem(oldFileSystem.name);
			
			//return new file path
			return newFilePath;
		}
		
		function loadImage (filePath, imageId)
		{
			//first try to load by using file path
			$("##"+imageId).unbind("load");
			var imageLoaded = false;
			$("##" + imageId).bind("load", function(){
				//image loaded successfully
				imageLoaded = true;
			});
			
			$("##"+imageId).show();
			$("##"+imageId).attr("src",filePath);
			
			setTimeout(function() {
				if (imageLoaded)
					return;
				loadImageData(filePath,imageId);
			},1000);
		}

		function loadImageData(filePath, imageId)
		{
			var imageData = cfclient.file.readAsBase64(filePath);
			$("##"+imageId).attr("src", imageData);
		}
		
		function deleteFile (filePath)
		{
			try
			{
				cfclient.file.remove(filePath);
				console.log("File " + filePath + " deleted");
			} 
			catch (any e)
			{
				console.log("Error removing file - " + filePath);
			}
		}
		
	</cfscript>
</cfclient>