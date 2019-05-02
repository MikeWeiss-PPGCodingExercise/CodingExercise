/**
 * Created by Mike Weiss on 4/18/2019.
 *
 * Controller for the PaymentDashboard component
 */
({
	// function to initialize data
	init : function(component, event, helper) {
		helper.getContactWrapperList(component, event);
	},
})