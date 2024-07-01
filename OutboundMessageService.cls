/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-28-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class OutboundMessageService {
    public static final string attendanceEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/attendance';
    public static final string parentContactEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/parent';
    public static final string childContactEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/child';
    public static final string podEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/pod';
    public static final string podSessionEndpointUrl = 'https://21a3a4b1-2f42-4490-9576-5632b12d572f.mock.pstmn.io/session';
    
    @future(callout=true)
    public static void sendOutboundMessage(Set<Id> recordIds, String objectType, String endPointUrl) {
        // Get the Schema.SObjectType for the given object type name
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectType);
        if (sObjectType == null) {
            System.debug('Invalid object type: ' + objectType);
            return;
        }

        // Get all fields of the object
        Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        List<String> fieldList = new List<String>();
        for (String fieldName : fieldMap.keySet()) {
            fieldList.add(fieldName);
        }

        String queryString = 'SELECT ' + String.join(fieldList,', ') + ' FROM ' + objectType + ' WHERE Id IN :recordIds ALL ROWS';
        // Query the records
        List<SObject> records = Database.query(queryString);
		System.debug(records);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPointUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
		
        // Create JSON payload
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('records', records);
        String jsonPayload = JSON.serialize(payload);
        req.setBody(jsonPayload);
        Http http = new Http();
        HttpResponse res;
        try {
           res = http.send(req);
        } catch(Exception e){
             ExceptionLogger.logCustomException( 'OutboundMessageService', 'sendOutboundMessage',
             'object: ' + objectType + ', HTTP Status Code: ' + res.getStatusCode() + ', Error Message: ' + res.getBody());        
        }
    }
}