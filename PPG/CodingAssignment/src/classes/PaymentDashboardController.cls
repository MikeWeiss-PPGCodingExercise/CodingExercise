/**
 * Created by Mike Weiss on 4/18/2019.
 *
 * Controller to handle all of the back end calls for the Payment Dashboard lightning component
 */

public with sharing class PaymentDashboardController {

    // Function to get the list of all Contact records
    @AuraEnabled
    public static List<Contact> getContactList() {
        List<Contact> contactList = [SELECT Id,
                Name,
                Total_Payment_Amount__c,
                Most_Recent_Payment_Date__c
            FROM Contact];

        return contactList;
    }

    // Function to return a single Contact record, based on Id
    @AuraEnabled
    public static Contact getContactById(String contactId) {
        Contact currentContact;
        if (!String.isBlank(contactId)) {
            List<Contact> contactList = [SELECT Id,
                    Name,
                    Most_Recent_Payment_Date__c,
                    Total_Payment_Amount__c
                FROM Contact
                WHERE Id = : contactId];

            if (!Utils.isListNullOrEmpty(contactList)) {
                currentContact = contactList[0];
            }
        }

        return currentContact;
    }

    // Function to return a list of all Payment records
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

    // Function to get the list of all Payment records for a specified Contact Id
    @AuraEnabled
    public static List<Payment__c> getPaymentListForContact(String contactId) {
        List<Payment__c> paymentList = new List<Payment__c>();
        if (!String.isBlank(contactId)) {
            paymentList = [
                    SELECT Id,
                            Contact__c,
                            Contact__r.Most_Recent_Payment_Date__c,
                            Contact__r.Total_Payment_Amount__c,
                            Payment_Amount__c,
                            Payment_Date__c,
                            Project__c,
                            Project__r.Name,
                            Project__r.Total_Payment_Amount__c
                    FROM Payment__c
                    WHERE Contact__c = :contactId
            ];
        }

        return paymentList;
    }

    // Function to get a list of all ContactWrapper objects
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
            // Only create entries for contacts that have payments associated.
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
        if (newPayment != null) {
            insert newPayment;
        }
    }

    // Method to update the payment passed if it isn't null.
    @AuraEnabled
    public static void updatePayments(List<Payment__c> updatePayments) {
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

    // Method to delete all Payment records that are referenced in the provided Id list
    @AuraEnabled
    public static void deletePaymentListById(List<String> deletePaymentIdList){
        if (!Utils.isListNullOrEmpty(deletePaymentIdList)) {
            List<Payment__c> deletePaymentList = [SELECT Id
                    FROM Payment__c
                    WHERE Id IN : deletePaymentIdList];

            if (!Utils.isListNullOrEmpty(deletePaymentIdList)) {
                delete deletePaymentList;
            }
        }
    }

    // Method to validate if a Project record Id given is valid
    @AuraEnabled
    public static Boolean isProjectIdValid(String projectRecordId) {
        // make sure the provided id isn't null or empty
        if (!String.isBlank(projectRecordId)) {
            // make sure the provided id is a valid length before making a call to the back end
            Integer stringLength = projectRecordId.length();
            if (stringLength == 15 || stringLength == 18) {
                List<Project__c> projectList = [SELECT Id
                    FROM Project__c
                    WHERE Id = : projectRecordId];

                // Make sure a result exists
                if (!Utils.isListNullOrEmpty(projectList)) {
                    return true;
                }
            }
        }

        // for any conditions that get weeded out, return false
        return false;
    }
}