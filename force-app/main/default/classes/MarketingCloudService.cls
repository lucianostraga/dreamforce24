global without sharing class MarketingCloudService {
    public String authToken;
    public String subdomain;

	public String getJourneys(){
		if(this.authToken == null){this.authenticate();}

        Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://' + this.subdomain + '.rest.marketingcloudapis.com/interaction/v1/interactions?mostRecentVersionOnly=true');
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('Authorization', 'Bearer ' + this.authToken);
		HttpResponse response = http.send(request);
		if (response.getStatusCode() == 200) {
			System.debug('#### JOURNEYS: '+response.getBody());
			return response.getBody();
		} else {
			System.debug('The status code returned by the Marketing Cloud Interactions API was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
			return null;
		}
	}

    public Boolean sendTransactionalEmails(TransactionalSendRequest tReq){
		if(this.authToken == null){this.authenticate();}

        Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://' + this.subdomain + '.rest.marketingcloudapis.com/messaging/v1/email/messages');
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('Authorization', 'Bearer ' + this.authToken);
		request.setBody(JSON.serialize(tReq));
		HttpResponse response = http.send(request);
		if (response.getStatusCode() == 202) {
			System.debug('#### MKT TRANSACTIONAL EMAIL MESSAGES RESPONSE: '+response.getBody());
			return true;
		} else {
			System.debug('The status code returned by the Marketing Cloud transactional message emails API was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
			return false;
		}
	}
    
	@future(callout=true)
	public static void performAutomationFuture(String automationExternalId){
		MarketingCloudService service = new MarketingCloudService();
		service.performAutomation(automationExternalId);
	}
	
	public Boolean performAutomation(String automationExternalId){
		if(this.authToken == null){this.authenticate();}

		String body = 
		'<?xml version="1.0" encoding="UTF-8"?>'+
		'<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
			'<s:Header>'+
				'<a:Action s:mustUnderstand="1">Perform</a:Action>'+
				'<a:To s:mustUnderstand="1">https://'+this.subdomain+'.soap.marketingcloudapis.com/Service.asmx</a:To>'+
				'<fueloauth xmlns="http://exacttarget.com">'+this.authToken+'</fueloauth>'+
			'</s:Header>'+
			'<s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
				'<PerformRequestMsg xmlns="http://exacttarget.com/wsdl/partnerAPI" xmlns:ns2="urn:fault.partner.exacttarget.com">'+
					'<Action>start</Action>'+
					'<Definitions>'+
						'<Definition xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="Automation">'+
							'<CustomerKey>'+automationExternalId+'</CustomerKey>'+
						'</Definition>'+
					'</Definitions>'+
				'</PerformRequestMsg>'+
			'</s:Body>'+
		'</s:Envelope>';

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://' + this.subdomain + '.soap.marketingcloudapis.com/Service.asmx');
		request.setMethod('POST');
		request.setHeader('Content-Type', 'text/xml');
		request.setHeader('charset','UTF-8');
		request.setHeader('Accept','text/xml');  
		request.setBody(body);
		HttpResponse response = http.send(request);
		
		if (response.getStatusCode() == 200) {
			System.debug('###### PERFORM AUTOMATION RESPONSE: '+response.getBody());
			return true;
		} else {
			System.debug('Error Performing Automation: ' + response.getStatusCode() + ' ' + response.getStatus());
			return false;
		}
	}

	public String getAllDataExtensions(){
		if(this.authToken == null){this.authenticate();}

		String body = 
		'<?xml version="1.0" encoding="UTF-8"?>'+
		'<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
			'<s:Header>'+
				'<a:Action s:mustUnderstand="1">Retrieve</a:Action>'+
				'<a:To s:mustUnderstand="1">https://'+this.subdomain+'.soap.marketingcloudapis.com/Service.asmx</a:To>'+
				'<fueloauth xmlns="http://exacttarget.com">'+this.authToken+'</fueloauth>'+
			'</s:Header>'+
			'<s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
				'<RetrieveRequestMsg xmlns="http://exacttarget.com/wsdl/partnerAPI">'+
					'<RetrieveRequest>'+
						'<ObjectType>DataExtension</ObjectType>'+
						'<Properties>ObjectID</Properties>'+
						'<Properties>CustomerKey</Properties>'+
						'<Properties>Name</Properties>'+
						'<Properties>IsSendable</Properties>'+
						'<Properties>SendableSubscriberField.Name</Properties>'+
						'<Filter xsi:type="SimpleFilterPart">'+
                    		'<Property>Name</Property>'+
                    		'<SimpleOperator>like</SimpleOperator>'+
                    		'<Value>%Dreamforce%</Value>'+
                		'</Filter>'+
					'</RetrieveRequest>'+
				'</RetrieveRequestMsg>'+
			'</s:Body>'+
		'</s:Envelope>';

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://' + this.subdomain + '.soap.marketingcloudapis.com/Service.asmx');
		request.setMethod('POST');
		request.setHeader('Content-Type', 'text/xml');
		request.setHeader('charset','UTF-8');
		request.setHeader('Accept','text/xml');  
		request.setBody(body);

		System.debug('######## '+body);

		HttpResponse response = http.send(request);
		
		if (response.getStatusCode() == 200) {
			System.debug('###### GET ALL DATA EXTENSIONS RESPONSE: '+response.getBody());
			return response.getBody();
		} else {
			System.debug('Error Getting All Data Extensions: ' + response.getStatusCode() + ' ' + response.getStatus());
			return null;
		}
	}

    public String authenticate() {
		Marketing_Cloud_Credentials__mdt credentials = [SELECT Subdomain__c, ClientId__c, ClientSecret__c FROM Marketing_Cloud_Credentials__mdt WHERE DeveloperName = 'Marketing_Cloud_Integration' LIMIT 1][0];
        this.subdomain = credentials.Subdomain__c;

		MarketingCloudAuthRequest authRequest = new MarketingCloudAuthRequest(credentials.ClientId__c, credentials.ClientSecret__c);

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://' + credentials.Subdomain__c + '.auth.marketingcloudapis.com/v2/token');
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody(JSON.serialize(authRequest));
		HttpResponse response = http.send(request);
		if (response.getStatusCode() == 200) {
            MarketingCloudAuthResponse resp = (MarketingCloudAuthResponse) JSON.deserialize(response.getBody(), MarketingCloudAuthResponse.class);
            System.debug('#### MKT AUTH RESPONSE: '+resp);
            this.authToken = resp.access_token;
            return this.authToken;
		} else {
			System.debug('The status code returned by the Marketing Cloud auth API was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
			return null;
		}

	}
	
    private class MarketingCloudAuthRequest {
		String client_id;
		String client_secret;
		String grant_type;

		public MarketingCloudAuthRequest(String clientId, String clientSecret) {
			this.client_id = clientId;
			this.client_secret = clientSecret;
			this.grant_type = 'client_credentials';
		}
	}

	private class MarketingCloudAuthResponse {
		String access_token;
		String token_type;
		String expires_in;
		String scope;
		String soap_instance_url;
		String rest_instance_url;
	}

    private class TransactionalSendRequest {
		String definitionKey;
		List<TransactionalSendRecipient> recipients;
        
        public TransactionalSendRequest(String definitionKey){
            this.definitionKey = definitionKey;
        }
	}

    private class TransactionalSendRecipient {
		String contactKey;
        String to;
        String messageKey;
		Map<String,String> attributes;
	}

	public class DataExtension{
		public String objectId;
		public String customerKey;
		public String name;
		public Boolean isSendable;
	}
}