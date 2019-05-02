/**
 * Created by Mike Weiss on 4/18/2019.
 *
 * Controller for the PaymentTable component
 */
({
	// Method for initializing the payment table
	init: function (component, event, helper) {
		component.set('v.columns', [
			{label: 'Id', fieldName: 'Id', type: 'text' , editable: false},
			{label: 'Project Name', fieldName: 'Project__rName', type: 'text' ,editable: false},
			{label: 'Payment Amount', fieldName: 'Payment_Amount__c', type: 'currency' ,editable: true},
			{label: 'Payment Date', fieldName: 'Payment_Date__c', type: 'date',
				typeAttributes: {day: 'numeric',month: 'numeric',year: 'numeric',},editable: true}
		]);
		helper.fetchData(component,event, helper);
		helper.getCurrentContact(component, event);
	},
	// Method to handle saving payment edits
	handleSaveEdition: function (component, event, helper) {
		helper.handleSaveEdition(component, event);
	},
	// Method to update the selected payment records
	storeSelectedRows : function(component, event, helper){
		helper.storeSelectedRows(component, event);
	},
	// Method to delete the selected payments
	deleteTableRows : function(component, event, helper) {
		helper.deleteTableRows(component, event);
	},
	// Method to handle the reloading of data
	handleReloadEvent : function (component, event, helper) {
		helper.fetchData(component, event);
		helper.getCurrentContact(component, event);
	},
})