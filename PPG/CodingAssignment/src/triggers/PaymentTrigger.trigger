/**
 * Created by Mike Weiss on 4/17/2019.
 *
 * Trigger to run after any Insert/Update/Delete operations on Payment__c to update the Project__c and Contact records.
 * 
 */

trigger PaymentTrigger on Payment__c (after insert, after update, before delete, after delete, after undelete ) {

    // Based on the action type, call the appropriate method on the trigger handler class.
    if (Trigger.isInsert || Trigger.isUndelete) {
        PaymentTriggerHandler.handleInsert(Trigger.newMap);
    } else if (Trigger.isUpdate) {
        PaymentTriggerHandler.handleUpdate(Trigger.newMap, Trigger.oldMap);
    } else if (Trigger.isDelete) {
        if (Trigger.isBefore) {
            PaymentTriggerHandler.handleBeforeDelete(Trigger.oldMap);
        } else if (Trigger.isAfter) {
            PaymentTriggerHandler.handleAfterDelete(Trigger.oldMap);
        }
    }
}