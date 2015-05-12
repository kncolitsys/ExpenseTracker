//This file included in index.cfm

//Handle mobileinit event of JQuery Mobile
$(document).on("mobileinit", function(){
	//perform any initialization, if required
});

//Handle pagecreate event of mainPage (JQM). Page is in index.cfm
$(document).on("pagecreate", "#mainPage", function(){
	$("#addBtn").on("vclick", function(){
		$("#addDlg").dialog({closeBtn:"none"});
		$("#dateTxt").val("");
		$("#amtTxt").val("");
		$("#descTxt").val("");
		$("#receiptImg").attr("src", "");
		$("#receiptImg").hide();
		_tmpImagePath = "";
		$.mobile.changePage("#addDlg",{role:"dialog"});
	});
	
	//Button event handler for Delete All button
	$("#deleteAllBtn").on("vclick", function(){
		deleteAll(); //in index_include.cfm
	});
	
	//Hyper link event handler for 'receipt' 
	$(document).on("click",".imageReceipt", function(event){
		var imagePath = $(event.target).attr("href");
		console.log(imagePath);
		if (imagePath != "")
		{
			$("#receiptDlg").dialog({closeBtn:"right"});
			$.mobile.changePage("#receiptDlg",{role:"dialog"});
			
			//$("#receiptImgLarge").width($("#receiptDlg .ui-dialog-contain").width());
			loadImage(imagePath,"receiptImgLarge"); //in index_include.cfm
		}
		event.preventDefault();
		return false;
	});
	
});

//JQM pagecreate event for add dialog
$(document).on("pagecreate","#addDlg", function(){
	$("#dlgOKBtn1").on("vclick", function(){
		saveExpense(); //in index_include.cfm
	});
	
	//Button event handler for Cancel button
	$("#dlgCancel1").on("vclick", function(){
		$("#addDlg").dialog("close");
		//delete receipt, if it was attached
		if (_tmpImagePath != "")
		{
			deleteFile(_tmpImagePath); //in index_include.cfm
			_tmpImagePath = "";
		}
	});
	
	//Button event handler for Attach Receipt button
	$("#attachRcptBtn").on("vclick", function(){
		attachReceipt(); //in index_include.cfm
	});
	
});

//JQM pagecreate event to display receipt dialog
$(document).on("pagecreate","#receiptDlg", function(){
	//Button event handler for 'Fit' image to window button
	$("#receiptFitBtn").on("vclick", function(){
		$("#receiptImgLarge").css("width","100%");
	});

	//Button event handler for 'Full Size' (image) button
	$("#receiptFullBtn").on("vclick", function(){
		$("#receiptImgLarge").css("width",'');
	});

});
