({
	fetchData: function (cmp,event,helper) {
		console.debug('%%%%% fetchData - enter');
		var action = cmp.get("c.getPaymentListForContact");


		action.setParams({
			'contactId' : cmp.get("v.contactId")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var data = response.getReturnValue();
				console.log('%%%%% success: ');
				console.log(data);
				for (var i = 0; i < data.length; i++) {
					var row = data[i];
					if (row.Project__c) row.Project__rName = row.Project__r.Name;
				}
				cmp.set('v.data',data);
			}
			// error handling when state is "INCOMPLETE" or "ERROR"
		});
		$A.enqueueAction(action);
	},
})