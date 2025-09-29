trigger CalculateBusinessHoursTrigger on Case (after insert, after update) {
    if(CalculateBusinessHoursHelper.runOnce()){
        List<Id> caseIds = new List<Id>();
        List<Case> lc = new List<Case>();
        List<Case> lcUpdate = new List<Case>();
        List<datetime> bizHours;
        Datetime bizStart;
        Datetime bizEnd;
        Datetime createdDate;
        Map<Id,BusinessHours> bhsMap = new Map<Id, BusinessHours>();
         for (Case c:trigger.new){
            if(c.BusinessHoursId != null )
                caseIds.add(c.Id);
        }
        if(caseIds.size()>0){
            lc = [select Id, createdDate, Business_Hours__c, BusinessHoursId from Case where Id in :caseIds];
            List<BusinessHours> bhs = [select Id,
                                      MondayStartTime, MondayEndTime,
                                      TuesdayStartTime, TuesdayEndTime,
                                      WednesdayStartTime, WednesdayEndTime,
                                      ThursdayStartTime, ThursdayEndTime,
                                      FridayStartTime, FridayEndTime,
                                      SaturdayStartTime, SaturdayEndTime,
                                      SundayStartTime, SundayEndTime,
                                      TimeZoneSidKey from BusinessHours where isActive = true
                                     ];
            
            for (BusinessHours bh:bhs){
                bhsMap.put(bh.Id,bh);
            }
            
            for (Case c:lc){
                bizHours = CalculateBusinessHoursHelper.calculate(bhsMap,c);
                if (bizHours != null){
                    bizStart = bizHours[0];
                    bizEnd = bizHours[1];
                    createdDate = bizHours[2];
                    if (bizStart <= createdDate && createdDate <= bizEnd)
                        c.Business_Hours__c = True;
                    else
                        c.Business_Hours__c = False;
                }
            }
            update lc;
        }
    }

}