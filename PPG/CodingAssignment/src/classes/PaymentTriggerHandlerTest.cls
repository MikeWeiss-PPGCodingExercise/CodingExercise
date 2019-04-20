/**
 * Created by Mike Weiss on 4/17/2019.
 *
 * Test class for PaymentTriggerHandler class.
 */

@isTest
private with sharing class PaymentTriggerHandlerTest {

    private static testMethod void testPaymentTriggers() {
        // Create test data
        Contact testContact = new Contact();
        testContact.LastName = 'Williams';
        insert testContact;

        Project__c testProject = new Project__c();
        testProject.Name = 'Wings';
        insert testProject;

        // Test Insert
        Payment__c testPayment = new Payment__c();
        testPayment.Payment_Amount__c = 5;
        testPayment.Payment_Date__c = Date.today();
        testPayment.Contact__c = testContact.Id;
        testPayment.Project__c = testProject.Id;
        insert testPayment;

        // Test Update
        testPayment.Payment_Amount__c = 100.00;
        testPayment.Payment_Date__c = Date.today().addDays(1);
        update testPayment;

        // Test Delete
        delete testPayment;

    }
}