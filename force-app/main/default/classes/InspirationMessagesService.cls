public with sharing class InspirationMessagesService {
    
    @InvocableMethod(label='Generate Inspirational Messages' description='Returns a random inspirational message')
    public static List<Output> generateInspirationalMessage(List<String> inputs){

        aiplatform.ModelsAPI.createGenerations_Request request = new aiplatform.ModelsAPI.createGenerations_Request();

        request.modelName = 'sfdc_ai__DefaultGPT35Turbo';
        aiplatform.ModelsAPI_GenerationRequest requestBody = new aiplatform.ModelsAPI_GenerationRequest();
        request.body = requestBody;
        requestBody.prompt = 'Generate a inspirational message';

        String message;

        try {
            aiplatform.ModelsAPI modelsAPI = new aiplatform.ModelsAPI();
            aiplatform.ModelsAPI.createGenerations_Response response = modelsAPI.createGenerations(request);
            System.debug('Models API response: ' + response.Code200.generation.generatedText);
            message = response.Code200.generation.generatedText;

        } catch(aiplatform.ModelsAPI.createGenerations_ResponseException e) {
            System.debug('Response code: ' + e.responseCode);
            System.debug('The following exception occurred: ' + e);
        }

        if(message != null){
            Eventbus.publish(new Inspirational_Message__e(Message__c = message));
            Output result = new Output();
            result.message = 'Enjoy your message!';
            return new List<Output>{result};
        }
        
        return null;
    }

    public class Output {
        @InvocableVariable(description='Inspirational Message')
        public String message;
    }
}