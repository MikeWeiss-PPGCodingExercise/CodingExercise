/**
 * Created by Mike Weiss on 4/18/2019.
 *
 * Helper for the PaymentTable component
 */
({
	// Method to get the payment list for the contact id passed
	fetchData: function (component, event) {
		let action = component.get("c.getPaymentListForContact");

		action.setParams({
			'contactId' : component.get("v.contactId")
		});
		action.setCallback(this, function(response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				let data = response.getReturnValue();
				for (let i = 0; i < data.length; i++) {
					let row = data[i];
					if (row.Project__c) row.Project__rName = row.Project__r.Name;
				}
				component.set('v.data',data);
			}
		});
		$A.enqueueAction(action);
	},
	// Method to get the current contact
	getCurrentContact : function (component, event) {
		let action = component.get("c.getContactById");

		action.setParams({
			'contactId' : component.get("v.contactId")
		});

		action.setCallback(this, function(response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				let data = response.getReturnValue();
				component.set('v.currentContact', data);
			}
		});
		$A.enqueueAction(action);
	},
	// Method to handle saving payment edits
	handleSaveEdition: function (component, event) {
		let draftValues = event.getParam('draftValues');

		let action = component.get("c.updatePayments");
		action.setParams({"updatePayments": draftValues});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				component.set('v.errors', []);
				component.set('v.draftValues', []);
				this.fetchData(component, event);
				this.getCurrentContact(component, event);

				this.showSuccessToast(component, event, "Payment(s) updated successfully");
			}
		});
		$A.enqueueAction(action);
	},
	// Method to update the selected payment records
	storeSelectedRows : function(component, event){
		let selectedRows = event.getParam("selectedRows");
		component.set("v.selectedRows", selectedRows);
	},
	// Method to delete the selected payments
	deleteTableRows : function(component, event) {
		let selectedPayments = component.get("v.selectedRows");
		let IDs = [];
		for (let i = 0; i < selectedPayments.length; i++){
			IDs[i] = selectedPayments[i].Id;
		}

		if (IDs.length > 0) {
			let action = component.get("c.deletePaymentListById");
			action.setParams({
				"deletePaymentIdList": IDs
			});

			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === "SUCCESS") {
					component.set('v.errors', []);
					component.set('v.draftValues', []);
					this.fetchData(component, event);
					this.getCurrentContact(component, event);

					this.showSuccessToast(component, event, "Payment(s) deleted successfully");
				}
			});
			$A.enqueueAction(action);
		} else {
			this.showErrorToast(component, event, "Please select at least one payment to delete");
		}
	},
	// Method to show error toasts
	showErrorToast : function(component, event, message, messageTemplate, messageTemplateData) {
		let toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : 'Error',
			message: message,
			messageTemplate: messageTemplate,
			messageTemplateData: messageTemplateData,
			duration:' 5000',
			key: 'info_alt',
			type: 'error',
			mode: 'pester'
		});
		toastEvent.fire();
	},
	showSuccessToast : function(component, event, message, messageTemplate, messageTemplateData) {
		console.log('%%%%% showSuccessToast');
		let toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : 'Success',
			message: message,
			messageTemplate: messageTemplate,
			messageTemplateData: messageTemplateData,
			duration:' 5000',
			key: 'info_alt',
			type: 'success',
			mode: 'pester'
		});
		toastEvent.fire();
	},
})