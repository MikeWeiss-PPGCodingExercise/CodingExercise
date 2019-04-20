/**
 * Created by Mike Weiss on 4/18/2019.
 *
 * Wrapper to display Contact records with the associated Payment__c records for each one on the lightning component.
 */

public with sharing class ContactWrapper {

    @AuraEnabled public Contact contact {get;set;}
    @AuraEnabled public List<Payment__c> paymentList {get;set;}

    public ContactWrapper(Contact passedContact, List<Payment__c> passedPaymentList){
        contact = passedContact;
        paymentList = passedPaymentList;
    }
}