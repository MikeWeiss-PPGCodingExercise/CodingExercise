({
	init: function (cmp, event, helper) {
		cmp.set('v.columns', [
			{label: 'Id', fieldName: 'Id', type: 'text' , editable: false},
			{label: 'Project Name', fieldName: 'Project__rName', type: 'text' ,editable: false},
			{label: 'Payment Amount', fieldName: 'Payment_Amount__c', type: 'currency' ,editable: true},
			{label: 'Payment Date', fieldName: 'Payment_Date__c', type: 'date',
				typeAttributes: {day: 'numeric',month: 'numeric',year: 'numeric',},editable: true}
		]);
		helper.fetchData(cmp,event, helper);
	},
	handleSaveEdition: function (cmp, event, helper) {
		console.log('%%%%% handleSaveEdition - enter');
		var draftValues = event.getParam('draftValues');
		console.log('%%%%% draftValues:');
		console.log(draftValues);

		var action = cmp.get("c.updatePayments");
		console.log('%%%%% action: ');
		console.log(action);
		action.setParams({"updatePayments": draftValues});
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log('%%%%% state: ');
			console.log(state);
			$A.get('e.force:refreshView').fire();

		});
		$A.enqueueAction(action);
	},
	storeSelectedRows : function(component, event, helper){
		console.log('%%%%% store selected rows - enter');
		var selectedRows = event.getParam("selectedRows");
		console.log(selectedRows);
		component.set("v.selectedRows", selectedRows);
	},
	deleteTableRows : function(component, event, helper) {
		console.log('%%%%% deleteTableRows - enter');

		var selectedPayments = component.get("v.selectedRows");
		console.log('%%%%% selectedPayments: ');
		console.log(selectedPayments);
		var IDs = [];
		for (var i = 0; i < selectedPayments.length; i++){
			IDs[i] = selectedPayments[i].Id;
			console.log('%%%%% selected payment');
			console.log(selectedPayments[i].Id)
			console.log(selectedPayments[i]);
		}

		console.log('%%%%% IDs: ');
		console.log(IDs);

		var action = component.get("c.deletePaymentListById");
		action.setParams({
			"deletePaymentIdList": IDs
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
				$A.get('e.force:refreshView').fire();

		});
		$A.enqueueAction(action);
		helper.fetchData(cmp,event, helper);
	},
})