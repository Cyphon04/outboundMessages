/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-28-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class OutboundMessageServiceTest {
    // Preparing the Endpoint URL's
    public static final string attendanceEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/attendance';
    public static final string parentContactEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/parent';
    public static final string childContactEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/child';
    public static final string podEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/pod';
    public static final string podSessionEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/session';

    @TestSetup static void testData(){
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get('Contact');
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(LastName='Test Contact One'));
        contacts.add(new Contact(LastName='Test Contact Two'));
        insert contacts;
    } 

    @isTest
    public static void testingPositiveOutboundMessage(){
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = 'Test Contact One' OR LastName = 'Test Contact Two'];
        Set<Id> contactIds = new Set<Id>();
        for(Contact con : contacts)
        {
            contactIds.add(con.Id);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OutboundMessageServiceCalloutMock());
        OutboundMessageService.sendOutboundMessage(contactIds, 'Contact', attendanceEndpointUrl);
        // OutboundMessageServiceCalloutMock OutboundMessageMockCallout = new OutboundMessageServiceCalloutMock();
        // Assert.areEqual(response.getStatusCode(), 200);
        // Assert.areEqual(, );

        OutboundMessageService.sendOutboundMessage(contactIds, 'Contacts', attendanceEndpointUrl);
        Test.stopTest();

    }
}