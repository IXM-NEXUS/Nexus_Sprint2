trigger UpdateDeskIDOnCase on Case (before insert) {
    Integer maxNum = 0;
    AggregateResult DeskIDObj = [SELECT MAX(Desk_Id__c) FROM case];
    maxNum = Integer.valueof(DeskIDObj.get('expr0'));
        for(Case con :Trigger.new){
            maxNum = maxNum + 1;
            
            IF(!con.subject.contains('Case ID #')){
            //con.Desk_Id__c=con.Desk_Id__c;
              con.Desk_Id__c = maxNum ;
            con.subject = con.subject+' Case ID #'+maxNum ;
            }
          
        }
}