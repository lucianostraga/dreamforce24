public with sharing class MetadataCreatorService {
    
    @InvocableMethod(label='Create Metadata' description='Create Salesforce metadata based on XML string input parameters. Call this action immediately after the Generate Metadata action')
    public static List<Output> createMetadata(List<Input> xmlMetadataDefinitions){
      
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        // Construct the full SOAP envelope with the provided XML
        String soapBody = buildSoapRequest(xmlMetadataDefinitions[0].xmlDefinition);
        
        // Set endpoint and headers for Metadata API request
        req.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+'/services/Soap/m/59.0');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction', 'Create');
        req.setBody(soapBody);
        req.setCompressed(true);  

        Output output = new Output();

        try {
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                output.result = 'Object created successfully';
            } else {
                output.result = 'Failed to create object: ' + res.getStatusCode() + ' ' + res.getBody();
            }
        } catch (Exception e) {
            output.result = 'Exception: ' + e.getMessage();
        }

        return new List<Output>{output};
   }

    public static String buildSoapRequest(String soapBody) {
        String soapRequest = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
        soapRequest +=          '<s:Header>';
        soapRequest +=              '<h:SessionHeader ';
        soapRequest +=                  'xmlns:h="http://soap.sforce.com/2006/04/metadata" ';
        soapRequest +=                  'xmlns="http://soap.sforce.com/2006/04/metadata" ';
        soapRequest +=                  'xmlns:xsd="http://www.w3.org/2001/XMLSchema" >';
        soapRequest +=                      '<sessionId>'+UserInfo.getSessionId()+'</sessionId>';
        soapRequest +=              '</h:SessionHeader>';
        soapRequest +=          '</s:Header>';
        // <s:Body></s:Body> as parameter
        soapRequest += soapBody;
        soapRequest += '</s:Envelope>';

        return soapRequest;
    }

    public class Output {
        @InvocableVariable(description='Operation result')
        public String result;
    }

    public class Input {
        @InvocableVariable(description='The XML metada definition string')
        public String xmlDefinition;
    }

}