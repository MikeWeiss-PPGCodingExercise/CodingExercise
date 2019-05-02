/**
 * Created by Mike Weiss on 4/17/2019.
 *
 * Processes all the logic for the Payment__c trigger to ensure logic is all done in a consistent manner.
 */

public with sharing class PaymentTriggerHandler {

    // Static variables to save from passing them around and to allow before/after two part processing.
    private static Set<Id> paymentIdSet;
    private static List<Payment__c> fullPaymentList;
    private static List<AggregateResult> contactAggregatedPaymentList;
    private static List<AggregateResult> projectAggregatedPaymentList;
    private static Map<Id, Contact> idToContactMap = new Map<Id, Contact>();
    private static Map<Id, Project__c> idToProjectMap = new Map<Id, Project__c>();

    // Method to handle the insert payment logic.
    public static void handleInsert(Map<Id, Payment__c> newPaymentsByIdMap) {

        if (!Utils.isMapNullOrEmpty(newPaymentsByIdMap)) {
            paymentIdSet = newPaymentsByIdMap.keySet();

            getValuesToUpdate();
            updateValues();
        }
    }

    // Method to handle the update payment logic.
    public static void handleUpdate(Map<Id, Payment__c> newPaymentsByIdMap, Map<Id, Payment__c> oldPaymentsByIdMap) {

        // Put the values into a list first, since the set can't be updated once created.
        List<Id> oldNewIdList = new List<Id>();
        if (!Utils.isMapNullOrEmpty(newPaymentsByIdMap)) {
            oldNewIdList.addAll(newPaymentsByIdMap.keySet());
        }
        if (!Utils.isMapNullOrEmpty(oldPaymentsByIdMap)) {
            oldNewIdList.addAll(oldPaymentsByIdMap.keySet());
        }

        if (!Utils.isListNullOrEmpty(oldNewIdList)) {
            paymentIdSet = new Set<Id>(oldNewIdList);

            getValuesToUpdate();
            updateValues();
        }
    }

    // Method to handle the before delete logic of getting the values to update.
    public static void handleBeforeDelete(Map<Id, Payment__c> oldPaymentsByIdMap) {

        if (!Utils.isMapNullOrEmpty(oldPaymentsByIdMap)) {
            paymentIdSet = oldPaymentsByIdMap.keySet();

            getValuesToUpdate();
        }
    }

    // Method to handle the after delete logic of updating the values found during before delete.
    public static void handleAfterDelete(Map<Id, Payment__c> oldPaymentsByIdMap) {

        if (!Utils.isMapNullOrEmpty(oldPaymentsByIdMap)) {
            paymentIdSet = oldPaymentsByIdMap.keySet();

            updateValues();
        }
    }

    // Method to handle getting the Contact and Project__c values to update.
    private static void getValuesToUpdate() {
        fullPaymentList = [SELECT Id,
                Contact__c,
                Contact__r.Most_Recent_Payment_Date__c,
                Contact__r.Total_Payment_Amount__c,
                Name,
                Payment_Amount__c,
                Payment_Date__c,
                Project__c,
                Project__r.Total_Payment_Amount__c
        FROM Payment__c
        WHERE Id IN : paymentIdSet];
    }

    // Method to perform the update for the Contact and Project__c values.
    private static void updateValues() {
        contactAggregatedPaymentList = [SELECT Contact__r.Id,
                SUM(Payment_Amount__c) paymentAmount,
                MAX(Payment_Date__c) paymentDate
        FROM Payment__c
        GROUP BY Contact__r.Id];

        projectAggregatedPaymentList = [SELECT Project__r.Id,
                SUM(Payment_Amount__c) paymentAmount
        FROM Payment__c
        GROUP BY Project__r.Id];

        // Go through all of the payments to get the IDs of the Contact and Project__c records effected.
        for (Payment__c currentPayment : fullPaymentList) {
            idToContactMap.put(currentPayment.Contact__c, currentPayment.Contact__r);
            idToProjectMap.put(currentPayment.Project__c, currentPayment.Project__r);
        }

        // Using Aggregate Results to limit queries, simplify logic, and ensure updates are accurate.
        for (aggregateResult currentContactAggregateResult : contactAggregatedPaymentList) {
            if (idToContactMap.get(currentContactAggregateResult.Id) != null) {
                idToContactMap.get(currentContactAggregateResult.Id).Most_Recent_Payment_Date__c
                        = (Date) currentContactAggregateResult.get('paymentDate');
                idToContactMap.get(currentContactAggregateResult.Id).Total_Payment_Amount__c
                        = (Decimal) currentContactAggregateResult.get('paymentAmount');
            }
        }

        for (aggregateResult currentPaymentAggregateResult : projectAggregatedPaymentList) {
            if (idToProjectMap.get(currentPaymentAggregateResult.Id) != null) {
                idToProjectMap.get(currentPaymentAggregateResult.Id).Total_Payment_Amount__c
                        = (Decimal) currentPaymentAggregateResult.get('paymentAmount'); 
            }
        }

        if(!Utils.isMapNullOrEmpty(idToContactMap)) {
            update idToContactMap.values();
        }
        if (!Utils.isMapNullOrEmpty(idToProjectMap)) {
            update idToProjectMap.values();
        }
    }
}