({
	init : function(component, event, helper) {
		console.log("%%%%% entering js controller init");

		helper.resetErrorMessage(component, event);
		helper.getContactWrapperList(component, event);
	},
	clickCreateItem : function(component, event, helper) {
		console.log('%%%%% clickCreateItem - enter');
		var newPayment = component.get("v.newItem");
		console.log(newPayment);
		helper.createItem(component, event);
	},
})