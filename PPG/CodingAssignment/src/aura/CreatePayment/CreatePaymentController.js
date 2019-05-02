/**
 * Created by Mike Weiss on 4/28/2019.
 *
 * Controller for the CreatePayment component
 */
({
    // handle the successful creation of a payment record
    handleSuccess : function (component, event, helper) {
        helper.handleSuccess(component, event);
    },
    // handle the submit functionality for the new payment form
    handleSubmit : function (component, event, helper) {
        helper.validateAndSubmit(component, event);
    },
})