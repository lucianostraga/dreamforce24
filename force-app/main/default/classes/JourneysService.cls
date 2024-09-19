
public with sharing class JourneysService {
    
    @InvocableMethod(label='Get Marketing Cloud Journeys' description='Returns Marketing Cloud Journey status and population details')
    public static List<Output> createMetadata(List<String> inputs){

        List<Journey> customJourneys = new  List<Journey>();

        MarketingCloudService service = new MarketingCloudService();
		String journeysJson = service.getJourneys();
        System.debug('########## '+journeysJson);
        
        Map<String, Object> journeyMap =  (Map<String, Object>) JSON.deserializeUntyped(journeysJson);

        List<Object> journeys = (List<Object>) journeyMap.get('items');

        for(Object j : journeys){
            Map<String, Object> jMap = (Map<String, Object>) j;

            Journey customJourney = new Journey();
            customJourney.name = (String) jMap.get('name');
            customJourney.status = (String) jMap.get('status');
            customJourney.population = Math.floor(Math.random() * (900 - 0 + 1) + 0).intValue();
            customJourneys.add(customJourney);
        }
        
        Output result = new Output();
        result.journeys = JSON.serialize(customJourneys);

        return new List<Output>{result};
   }

    public class Journey {
        public String name;
        public String status;
        public Integer population;
    }

    public class Output {
        @InvocableVariable(description='Journeys JSON')
        public String journeys;
    }
}