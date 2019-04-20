({
	getContactWrapperList : function(component, event) {
		console.log('%%%%% entered helper getContactWrapperList');

		var action = component.get("c.getContactWrapperList");

		action.setParams({
		});

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var returnValue = response.getReturnValue();
				console.log("%%%%% returnValue: ");
				console.log(returnValue);

				component.set("v.contactWrapperList", returnValue);
			}
			else {
				console.log("Failed with state: " + state);
				component.set("v.errorMessage", response.getError());
				component.set("v.displayErrorMessage", true);
			}
		});
		$A.enqueueAction(action);
	},

	resetErrorMessage : function(component, event) {
		component.set("v.errorMessage", "");
		component.set("v.displayErrorMessage", false);
		component.set("v.isFormValid", true);

	},
	createItem : function(component, event) {
		console.log('%%%%% createItem - enter');
		var newPayment = component.get("v.newItem");
		console.log(newPayment);

		var action = cmp.get("c.insertPayment");
		console.log('%%%%% action: ');
		console.log(action);
		action.setParams({"newPayment": newPayment});
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log('%%%%% state: ');
			console.log(state);
			$A.get('e.force:refreshView').fire();

		});
		$A.enqueueAction(action);
	},

})