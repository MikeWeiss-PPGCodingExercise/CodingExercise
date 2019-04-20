/**
 * Created by Mike Weiss on 4/18/2019.
 *
 * Controller to handle all of the back end calls for the Payment Dashboard lightning component
 */

public with sharing class PaymentDashboardController {

    @AuraEnabled
    public static List<Contact> getContactList() {
        List<Contact> contactList = [SELECT Id,
                Name,
                Total_Payment_Amount__c,
                Most_Recent_Payment_Date__c
            FROM Contact];

        return contactList;
    }

    @AuraEnabled
    public static List<Payment__c> getPaymentList() {
        List<Payment__c> paymentList = [SELECT Id,
                Contact__c,
                Contact__r.Most_Recent_Payment_Date__c,
                Contact__r.Total_Payment_Amount__c,
                Payment_Amount__c,
                Payment_Date__c,
                Project__c,
                Project__r.Name,
                Project__r.Total_Payment_Amount__c
        FROM Payment__c];

        return paymentList;
    }

    @AuraEnabled
    public static List<Payment__c> getPaymentListForContact(String contactId) {
        System.debug('%%%%% getPaymentListForContact: ' + contactId);
        List<Payment__c> paymentList = [SELECT Id,
                Contact__c,
                Contact__r.Most_Recent_Payment_Date__c,
                Contact__r.Total_Payment_Amount__c,
                Payment_Amount__c,
                Payment_Date__c,
                Project__c,
                Project__r.Name,
                Project__r.Total_Payment_Amount__c
        FROM Payment__c
        WHERE Contact__c = : contactId];

        System.debug('%%%%% paymentListForContact: ' + paymentList);

        return paymentList;
    }

    @AuraEnabled
    public static List<ContactWrapper> getContactWrapperList() {
        // Get the list of all Contact records
        List<Contact> contactList = getContactList();

        // Get the list of all Payment__c records
        List<Payment__c> paymentList = getPaymentList();

        // Put the payments into a map of lists, keyed on the contact id for easy retrieval
        Map<String, List<Payment__c>> contactIdToPaymentListMap = new Map<String, List<Payment__c>>();
        for (Payment__c currentPayment : paymentList) {
            // Create a new list in case one doesn't exist for the payment's contact
            List<Payment__c> contactPaymentList = new List<Payment__c>();
            String currentContactId = currentPayment.Contact__c;

            if (contactIdToPaymentListMap.get(currentContactId) == null) {
                // Add the payment to the empty list and place it in the map
                contactPaymentList.add(currentPayment);
                contactIdToPaymentListMap.put(currentContactId, contactPaymentList);

            } else {
                // Add the payment to the list for the current payment's contact and replace it in the map
                contactPaymentList = contactIdToPaymentListMap.get(currentContactId);
                contactPaymentList.add(currentPayment);
                contactIdToPaymentListMap.put(currentContactId, contactPaymentList);

            }
        }

        // Create and populate the ContactWrapper list
        List<ContactWrapper> contactWrapperList = new List<ContactWrapper>();

        for (Contact currentContact : contactList) {
            // Only create entries for contacts that have payments asssociated.
            List<Payment__c> currentPaymentList = contactIdToPaymentListMap.get(currentContact.Id);
            if (currentPaymentList != null && !currentPaymentList.isEmpty()) {
                ContactWrapper currentContactWrapper = new ContactWrapper(currentContact, currentPaymentList);
                contactWrapperList.add(currentContactWrapper);
            }
        }

        return contactWrapperList;
    }

    // Method to insert the payment passed if it isn't null.
    @AuraEnabled
    public static void insertPayment(Payment__c newPayment) {
        System.debug('%%%%% newPayment: ' + newPayment);
        if (newPayment != null) {
            insert newPayment;
        }
    }

    // Method to update the payment passed if it isn't null.
    @AuraEnabled
    public static void updatePayments(List<Payment__c> updatePayments) {
        System.debug('%%%%% update payment - enter');
        System.debug('%%%%% updatePayment: ' + updatePayments);
        if (updatePayments != null) {
            update updatePayments;
        }
    }

    // Method to delete the payment passed if it isn't null.
    @AuraEnabled
    public static void deletePayment(Payment__c deletePayment) {
        if (deletePayment != null) {
            delete deletePayment;
        }
    }

    @AuraEnabled
    public static void deletePaymentListById(List<String> deletePaymentIdList){
        System.debug('%%%%% deletePaymentListById - enter');
        System.debug('%%%%% deletePaymentIdList: ' + deletePaymentIdList);
        List<Payment__c> deletePaymentList = [SELECT Id FROM Payment__c WHERE Id IN : deletePaymentIdList];

        if (!deletePaymentIdList.isEmpty()) {
            delete deletePaymentList;
        }
    }


}