/**
 * Created by Mike Weiss on 4/28/2019.
 *
 * Helper for the CreatePayment component
 */
({
    // handle the success of creating a new payment record
    handleSuccess : function(component, event) {
        // get the reload event and fire it to let the parent component know to refresh data
        let reloadEvent = component.getEvent("reloadEvent");
        reloadEvent.fire();

        // toggling the variable that the aura:if uses to reset the form simply
        component.set("v.displayRecordForm", false);
        component.set("v.displayRecordForm", true);

        this.showSuccessToast(component, event, 'Payment created successfully.');
    },
    // Method to validate the project id entered and submit the new payment if so
    validateAndSubmit : function(component, event) {
        let errorMessage = 'Please enter valid values for fields: ';
        let isPaymentValid = true;
        let errorFieldList = [];

        let newPaymentDate = component.find("newPaymentDate").get("v.value");
        let newPaymentAmount = component.find("newPaymentAmount").get("v.value");
        let newProjectId = component.find("newProjectId").get("v.value");

        let action = component.get("c.isProjectIdValid");

        // check for payment date error
        if (!newPaymentDate || newPaymentDate === "") {
            isPaymentValid = false;
            errorFieldList.push("Payment Date");
        }

        // check for payment amount error
        if (!newPaymentAmount || newPaymentAmount === "") {
            isPaymentValid = false;
            errorFieldList.push("Payment Amount");
        }

        // check for project id error
        if (!newProjectId || newProjectId === "") {
            errorFieldList.push("Project");
            this.showErrorToast(component, event, errorMessage + errorFieldList.join(", "));
        } else if (isPaymentValid) {

            action.setParams({
                'projectRecordId': newProjectId
            });

            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let data = response.getReturnValue();
                    // Check the results of validating the project id provided
                    if (data === true) {
                        // Submit the form
                        component.find('newPaymentForm').submit();
                    } else {
                        // Display error message
                        this.showErrorToast(component, event, errorMessage + errorFieldList.join(", "));
                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            this.showErrorToast(component, event, errorMessage + errorFieldList.join(", "));
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