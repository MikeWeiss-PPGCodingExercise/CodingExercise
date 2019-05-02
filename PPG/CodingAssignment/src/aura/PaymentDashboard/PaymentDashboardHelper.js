/**
 * Created by Mike Weiss on 4/18/2019.
 *
 * Helper for the PaymentDashboard component
 */
({
	// Function to get a list of all ContactWrapper objects
	getContactWrapperList : function(component, event) {
		let action = component.get("c.getContactWrapperList");

		action.setParams({
		});

		action.setCallback(this, function(response) {
			let state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				let returnValue = response.getReturnValue();

				component.set("v.contactWrapperList", returnValue);
			}
			else {
				component.set("v.errorMessage", response.getError());
				component.set("v.displayErrorMessage", true);
			}
		});
		$A.enqueueAction(action);
	},
})