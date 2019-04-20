/**
 * Created by Mike Weiss on 4/19/2019.
 *
 * Test class for the ContactWrapper class
 */

@isTest
private with sharing class ContactWrapperTest {

    private static testMethod void testContactWrapper() {
        // Setup test data
        Contact testContact = new Contact();
        testContact.LastName = 'Wrapper';
        insert testContact;

        Project__c testProject = new Project__c();
        testProject.Name = 'CW';
        insert testProject;

        Payment__c testPayment = new Payment__c();
        testPayment.Contact__c = testContact.Id;
        testPayment.Project__c = testProject.Id;
        insert testPayment;

        List<Payment__c> testPaymentList = new List<Payment__c>();
        testPaymentList.add(testPayment);

        // Test the constructor
        ContactWrapper testContactWrapper = new ContactWrapper(testContact, testPaymentList);
    }

}